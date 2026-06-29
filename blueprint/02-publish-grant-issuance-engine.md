# 環節 02：發布憑證簽發引擎

## 簡述

定義 Platform 如何簽發、管理和驗證 Publish Grant（發布憑證）。Grant 是一次性上架授權資產，包含 grant ID、ACR path、credential mode、callback URL/token、TTL、狀態轉移規則。本環節是平台核心邏輯，介於 Portal (01) 與 Callback 處理器 (05) 之間。

## 啟動

| 項目 | 啟動標準 |
| --- | --- |
| 權限政策 | 全環節僅使用 `admin` / `user` 角色語意。 |
| 輸入條件 | draft 必須已 `package_ready`，才允許簽發 grant。 |
| 依賴就緒 | 01 環節可提供完整 draft metadata 與 owner 資訊。 |
| 安全底線 | callback token 簽章採 HMAC-SHA256 + constant-time compare。 |

---

## 規劃

### 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Grant 簽發器** | 建立 grant 記錄；生成唯一 ID；簽發 callback token | Secret 儲存、Azure Key Vault 集成（屬環節 06） |
| **Credential Mode 管理器** | 支援多種 mode（manual_secret / scoped_token / service_principal / github_oidc） | ACR 實際連線與帳號建立（屬 DevOps） |
| **Token 生成與驗証** | HMAC-SHA256 簽章、constant-time compare | Token 輪替與過期管理（屬環節 06） |
| **Grant 過期檢查** | 檢查 expires_at 並決定 callback 是否受理 | 自動過期清理 job（屬環節 06） |
| **狀態轉移邏輯** | 根據 callback 結果轉移 draft 狀態 | 最終審核決策（屬環節 05 callback 後） |

---

### 依賴方向

```
Portal (01) 簽發請求
    ↓
Grant 簽發器
    ├─→ grant ID 生成器 (UUID)
    ├─→ callback_token 簽發 (HMAC-SHA256)
    ├─→ Database (model_publish_grant table)
    ├─→ credential mode selector
    ├─→ ACR credential fetcher (警告層，非中止)
    └─→ secret_ref 記錄器
        └─→ Database (model_publish_secret_ref table)

Callback 處理器 (05)
    ↓
Grant 過期檢查
    ├─→ 驗証 publish_grant_id 與 expires_at
    └─→ 決定是否接受 callback
```

**無循環依賴**：環節 02 只依賴 01 與 database，被 05 依賴。

---

## 執行（真的要施工的細部規格）

### Public API Contract

### 1. 簽發 Publish Grant（由環節 01 呼叫）

**Function**：`create_publish_grant(draft_id, owner_username, **kwargs)`

**呼叫方**：環節 01 的 `api_create_publish_grant` endpoint

**Input Parameters**：
```python
create_publish_grant(
    draft_id: str,                          # 來自環節 01
    owner_username: str,                    # 來自 session
    acr_login_server: str = "model-cards.azurecr.io",
    callback_url: str,                      # GitHub Actions 回傳 URL
    credential_mode: str = "manual_secret",  # manual_secret | scoped_token | service_principal | github_oidc
    ttl_hours: int = 24                     # Token 有效期
)
```

**Return Value**：
```python
{
    'publish_grant_id': 'grant-uuid-5678',
    'credential_mode': 'manual_secret',
    'expires_at': '2026-06-30T10:30:00Z',
    'github_variables': {
        'AIHUB_ACR_LOGIN_SERVER': 'model-cards.azurecr.io',
        'AIHUB_IMAGE_REPOSITORY': 'model-cards/echo-model',
        'AIHUB_IMAGE_TAG': '0.1.0',
        'AIHUB_CARD_ID': 'echo-model',
        'AIHUB_PUBLISH_GRANT_ID': 'grant-uuid-5678',
        'AIHUB_CALLBACK_URL': 'https://api.example.com/model-card-publish/callback'
    },
    'github_secrets': {
        'AIHUB_ACR_USERNAME': 'acr-username-xyz',
        'AIHUB_ACR_PASSWORD': 'acr-password-secret-xyz',
        'AIHUB_CALLBACK_TOKEN': 'callback-token-secret-xyz',
        'AIHUB_TEST_LICENSE_KEY': 'license-key-xyz'
    }
}
```

**Error Handling**：
- `ModelCardPublishingError('DRAFT_NOT_PACKAGE_READY')` — draft 未 export yaml
- `ModelCardPublishingError('PUBLISH_GRANT_ALREADY_ISSUED')` — draft 已有 grant（不允許重簽）
- `ModelCardPublishingError('INVALID_CREDENTIAL_MODE')` — credential_mode 不在許可清單
- `ModelCardPublishingError('ACR_CONNECTIVITY_FAILED')` — ACR 連線測試失敗（警告，grant 仍發）
- `ModelCardPublishingError('GRANT_ISSUANCE_FAILED')` — 資料庫寫入失敗

---

### 2. 驗証 Callback 簽章（由環節 05 呼叫）

**Function**：`verify_callback_payload(publish_grant_id, callback_payload, provided_signature)`

**呼叫方**：環節 05 的 callback endpoint

**Input**：
```python
verify_callback_payload(
    publish_grant_id: str,
    callback_payload: bytes,  # JSON 序列化後的 bytes
    provided_signature: str    # X-Callback-Signature header 值
)
```

**Logic**：
1. 從資料庫查詢 grant 記錄，取得 callback_token_hash
2. 檢查 expires_at > now (若過期返回 False)
3. 計算 expected_signature = HMAC-SHA256(callback_payload, callback_token)
4. 使用 secrets.compare_digest() 比對 provided_signature == expected_signature
5. 返回 (is_valid: bool, grant_record: dict | None)

**Return**：
```python
(
    is_valid=True,
    grant_record={
        'publish_grant_id': 'grant-uuid-5678',
        'draft_id': 'draft-uuid-1234',
        'owner_username': 'alice',
        'expires_at': '2026-06-30T10:30:00Z',
        'status': 'grant_issued',  # 可能的值：grant_issued | revoked
        'revocation_reason': None
    }
) or (False, None)
```

---

### 3. 檢查 Grant 過期（由環節 05 呼叫）

**Function**：`is_grant_expired(publish_grant_id)`

**Input**：
```python
is_grant_expired(publish_grant_id: str)
```

**Return**：
```python
{
    'expired': True | False,
    'expires_at': '2026-06-30T10:30:00Z',
    'revoked': True | False,
    'revocation_reason': 'emergency_security_incident' | None
}
```

---

## 資料表映射

### `model_publish_grant`
```sql
CREATE TABLE model_publish_grant (
  publish_grant_id NVARCHAR(36) PRIMARY KEY,
  draft_id NVARCHAR(36) NOT NULL,  -- FK to model_card_draft
  owner_username NVARCHAR(255) NOT NULL,
  model_id NVARCHAR(255) NOT NULL,
  acr_login_server NVARCHAR(255),
  callback_url NVARCHAR(MAX),
  credential_mode VARCHAR(30) NOT NULL,  -- manual_secret | scoped_token | service_principal | github_oidc
  callback_token_hash NVARCHAR(MAX),  -- HMAC-SHA256 hash (不儲存原文)
  issued_at DATETIME2 NOT NULL,
  expires_at DATETIME2 NOT NULL,
  revoked_at DATETIME2,
  revocation_reason NVARCHAR(500),
  status VARCHAR(30) NOT NULL,  -- grant_issued | pending_review | published | revoked | expired
  
  FOREIGN KEY (draft_id) REFERENCES model_card_draft(draft_id),
  UNIQUE (draft_id),  -- 一份 draft 對應一個 grant
  CONSTRAINT chk_grant_status CHECK (status IN ('grant_issued', 'pending_review', ...))
);
```

### `model_publish_secret_ref`
```sql
CREATE TABLE model_publish_secret_ref (
  secret_ref_id NVARCHAR(36) PRIMARY KEY,
  publish_grant_id NVARCHAR(36) NOT NULL,  -- FK
  secret_name VARCHAR(100),  -- AIHUB_ACR_USERNAME | AIHUB_ACR_PASSWORD | AIHUB_CALLBACK_TOKEN | AIHUB_TEST_LICENSE_KEY
  secret_value_hash NVARCHAR(MAX),  -- 不儲存原文；用於稽核
  created_at DATETIME2 NOT NULL,
  
  FOREIGN KEY (publish_grant_id) REFERENCES model_publish_grant(publish_grant_id)
);
```

---

## 不變式（Invariants）

1. **一份 draft 只有一個有效 grant**  
   model_publish_grant.draft_id 為 unique key；建立第二個 grant 時拒絕。

2. **callback_token_hash 永不儲存原文**  
   使用 HMAC-SHA256 雜湊儲存；callback 驗証時重新計算並用 constant-time compare。

3. **Grant 過期或撤銷後，callback 拒絕**  
   即使 callback 簽章正確，若 expires_at < now 或 revoked_at is not null，拒絕接受。

4. **credential_mode 必在許可清單**  
   model_publish_grant.credential_mode 必為 {manual_secret, scoped_token, service_principal, github_oidc} 之一。

5. **秘密雜湊無法倒推原文**  
   使用業界標準的 constant-time compare；不儲存 plain text secret。

---

## 邊界條件（Boundary Conditions）

### 支持

- ✅ 多個開發者各自簽發獨立的 grant
- ✅ 同一 draft 因 callback 失敗後可重新簽發（需 PM 決策確認）
- ✅ 僅 `admin` 可代理簽發與撤銷
- ✅ credential_mode 未來擴充（新增 mode 類型時只須加表單值）
- ✅ Callback URL 與 token 可客製化（不強制特定格式）

### 不支持

- ❌ Grant 簽發後無法編輯（無修改 API）
- ❌ 同時發放多個 callback_token（一個 grant 一個 token）
- ❌ Callback token 輪替（當前無 rotate API；若需要屬環節 06）
- ❌ Grant 過期自動延長（TTL 固定；如需延長只能新簽發）

---

## Source of Truth

| 項目 | 位置 | 備註 |
|-----|------|------|
| 狀態機定義 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L38-L70) | `PUBLISHING_STATE_TRANSITIONS`, `TRANSITION_ERROR_CODES` |
| Grant 簽發邏輯 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L570-L620) | `create_publish_grant_record()` 函式 |
| Token 生成 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L340-L350) | `generate_callback_token()`, `hash_callback_token()` |
| Token 驗証 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L352-L368) | `verify_callback_payload()` 函式 |
| 資源包組裝 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L622-L631) | `create_resource_bundle()` 函式 |
| 資料表 | [utils/db.py](../../../utils/db.py#L188-L210) | `_MODEL_PUBLISH_GRANT_SCHEMA` |
| 資料表 | [utils/db.py](../../../utils/db.py#L216-L230) | `_MODEL_PUBLISH_SECRET_REF_SCHEMA` |

---

## 待確認項（TBD）

1. **Grant 簽發後修改政策**  
   - 若開發者想修改 callback_url，是否允許更新現有 grant，或須新簽發？
   - 當前政策：新簽發（禁止修改）；但若開發者請求修改，考慮是否加 PATCH API
   - **決策方**：PM / RD
   - **Priority**：P2

2. **Credential Mode 選擇建議**  
   - 何時 manual_secret vs. github_oidc？開發者文件中是否提供選型指南？
   - **決策方**：PM / RD（架構決策）
   - **Priority**：P1

3. **Secret Store 後端實作**  
   - 當前 callback_token_hash 儲存在 SQL Server；未來若改 Azure Key Vault，API 層需否變更？
   - **決策方**：Infrastructure / RD
   - **Priority**：P2（二期考慮）

4. **Callback Retry 與 Timeout**  
   - Grant 簽發時是否啟動 background job 監聽 callback 超時（例如 30 分鐘無反應）？
   - 當前無 retry 機制；若需要屬環節 05 或 06
   - **決策方**：RD / QE（可靠性決策）
   - **Priority**：P2

---

## 交付驗收（查核點 Checklist）

### Checked 填寫規範

每個查核點皆需逐列填寫 `規劃簽核`、`施工簽核`、`測試簽核`，不得改為整份文件一次簽核。

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grant ID 生成 | 使用 `uuid.uuid4()` 產出唯一 ID，無碰撞風險。 | Y | `utils/model_card/publishing.py` (`create_publish_grant`, `issue_callback_token`) | 已實作與測試覆蓋。 | PM | RD | QE |
| Callback Token 簽發與儲存 | token 使用高熵值產生，僅保存 hash，不保存原文。 | Y | `utils/model_card/publishing.py` (`hash_callback_token`, `verify_callback_token`) + `tests/test_model_card_publishing.py` | Hash-only 儲存已驗證。 | PM | RD | QE |
| Expires_at 與 Draft 狀態檢查 | `expires_at` 計算正確，且簽發前必須 `draft.status == package_ready`。 | Y | `utils/model_card/publishing.py` (`create_publish_grant`, `verify_callback_payload`) + `tests/test_model_card_publishing.py` | package_ready gate 與 TTL 檢查就緒。 | PM | RD | QE |
| Draft 重複簽發防護 | 同 draft 不得重複簽發 grant。 | Y | `utils/model_card/publishing.py` (`create_publish_grant`) + `tests/test_model_card_publishing.py` | duplicate guard 已生效。 | PM | RD | QE |
| Credential Mode 驗證 | mode 僅允許 `manual_secret/scoped_token/service_principal/github_oidc`。 | Y | `utils/model_card/publishing.py` (`SUPPORTED_CREDENTIAL_MODES`) + `tests/test_model_card_publishing.py` | 不支援 mode 會回錯誤碼。 | PM | RD | QE |
| Mode 特定邏輯一致 | `github_oidc` 路徑檢查可用，且 mode 不支援回退。 | Y | `utils/model_card/publishing.py` (`build_resource_bundle`) + `tests/test_model_card_publishing.py` | OIDC 不輸出 ACR password。 | PM | RD | QE |
| 秘密管理完整性 | ACR、callback、test license 秘密輸出規格完整，且符合最小揭露。 | Y | `utils/model_card/publishing.py` (`reveal_secrets_once`, `upsert_secret_refs`) + route/integration tests | Show-once policy 已驗證。 | PM | RD | QE |
| 資源包組裝完整性 | `github_variables` 與 `github_secrets` 必要鍵完整且命名與環節 03 一致。 | Y | `utils/model_card/publishing.py` (`build_resource_bundle`) + `docs/reference/model_card_publish_grant_standard.md` | 變數鍵名與契約一致。 | PM | RD | QE |
| Callback 驗證準備 | callback token hash 與 `expires_at` 正確落表，供環節 05 驗證。 | Y | `utils/model_card/publishing.py` (`create_publish_grant_record`, `process_publish_callback`) | 落表與 callback 驗證流程已串接。 | PM | RD | QE |
| 狀態轉移規則 | 初始 `grant_issued`，轉移規則完整且無循環。 | Y | `utils/model_card/publishing.py` (`PUBLISHING_STATE_TRANSITIONS`, `_transition_for`) | 狀態機與錯誤碼映射完整。 | PM | RD | QE |
| 錯誤處理契約 | 錯誤碼完整，回應格式統一為 JSON + 錯誤碼，不回傳 stack trace。 | Y | `utils/routes/model_card_publish_routes.py` + `tests/test_model_card_publish_routes.py` | API 錯誤契約一致。 | PM | RD | QE |
| 監測與日誌 | 指標與日誌欄位完整，可追溯簽發、驗證、撤銷。 | Y | `utils/model_card/publishing.py` (`_increment_metric`, logger, audit) | 簽發/回調/生命週期事件可追溯。 | PM | RD | QE |
| 測試邊界覆蓋 | Unit / Integration / E2E（若適用）覆蓋核心路徑。 | Y | `tests/test_model_card_publishing.py` + `tests/test_model_card_publish_routes.py` (66 passed) | 核心路徑已自動化驗證。 | PM | RD | QE |
| 文件與交接完整 | API 文檔、架構文檔、運維 SOP、故障排查都可落地使用。 | Y | `docs/internal-contracts/model_card_publishing_implementation.md`, `docs/reference/model_card_publish_openapi.yaml` | 文件與程式契約同步。 | PM | RD | QE |

---

## 依賴於此環節的下游

| 下游環節 | 依賴點 | 需求 |
|---------|--------|------|
| **環節 03** (Template Repo) | GitHub Variables/Secrets | 格式穩定、變數名稱一致 |
| **環節 05** (Callback 處理器) | Token 驗証函式、過期檢查 | API 穩定、效能達標（<10ms 驗証） |
| **環節 06** (生命週期管理) | Grant 撤銷、過期管理 | 撤銷 API、過期標記邏輯 |
| **環節 07** (Pages 文件) | API Contract + 狀態轉移規則 | 完整文件化供開發者與運維參考 |

---

## 關鍵決策總結

| 決策項 | 當前值 | 理由 | 變更影響 |
|--------|--------|------|---------|
| Grant 唯一性 | 一份 draft 一個 grant | 簡化邏輯；防止秘密洩露過度 | 若允許多個 grant，秘密管理複雜度增加 |
| Callback Token 儲存 | Hash only（不存原文） | 安全性；防止 DB breach 時洩露 | 若需原文，須用 encryption at rest |
| Expires_at 固定 | TTL 後不可延長 | 強制過期；提高安全性 | 若需延長，考慮新簽發而非修改 |
| ACR 連線檢查 | 警告層（不中止） | 避免 grant 簽發延遲；ACR 問題由後續環節回報 | 若改強制檢查，影響簽發 latency |

---

### 簽核說明

本環節改為逐查核點簽核：每列均需填寫 `規劃簽核`、`施工簽核`、`測試簽核`。
