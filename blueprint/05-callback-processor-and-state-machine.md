# 環節 05：Callback 接收與狀態遷移

## 簡述

定義 Platform 如何接收 GitHub Actions callback、驗証簽章、檢驗 ACR artifact、轉移 draft 狀態、儲存驗証結果。本環節是平台事件驅動層，銜接環節 04 (GitHub Actions) 與環節 06 (生命週期管理)。

## 啟動

| 項目 | 啟動標準 |
| --- | --- |
| callback 安全基線 | Bearer + HMAC-SHA256 簽章驗證可用。 |
| 幂等策略 | 重複 callback 可辨識且不重複入帳。 |
| artifact 驗證 | 可查 ACR digest 與 labels 一致性。 |

---

## 規劃

### 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Callback Endpoint** | HTTP POST 接收、rate limiting、CSRF 豁免 | 實際簽署驗証（委派環節 02） |
| **簽章驗証** | HMAC-SHA256 對比、constant-time compare | Token 生成與管理（屬環節 02） |
| **Payload 驗証** | JSON schema 檢查、build_status 有效性 | Payload 內容完整性（環節 04 負責） |
| **ACR Artifact 驗証** | Image 可拉取、digest 一致、labels 檢查 | ACR 帳戶與連線（屬 DevOps） |
| **狀態轉移** | Draft 從 grant_issued → pending_review 或 revision_requested | 最終 review 決策（屬 admin） |
| **驗証結果儲存** | model_publish_evidence 記錄 | 稽核日誌清理（屬環節 06） |

---

### 依賴方向

```
GitHub Actions Callback POST
    ↓
Callback Endpoint (/api/model-card-publish/callback)
    ├─→ Header 驗証 (Authorization: Bearer)
    ├─→ Signature 驗証 (X-Callback-Signature)
    │   └─→ 調用環節 02 的 verify_callback_payload()
    ├─→ Payload 驗証 (JSON schema + build_status)
    ├─→ ACR Artifact 驗証
    │   ├─→ ACR API 查詢 image metadata
    │   ├─→ Digest 比對
    │   └─→ Labels 檢查
    ├─→ Idempotency 檢查 (防重複)
    ├─→ 狀態轉移
    │   └─→ 更新 model_card_draft.status
    └─→ Evidence 儲存
        └─→ model_publish_evidence 記錄
```

---

## 執行（真的要施工的細部規格）

### Public API Contract

### Callback Endpoint

**Endpoint**：`POST /api/model-card-publish/callback`

**認証**：Bearer token (X-Callback-Signature header，無 session)  
**CSRF**：豁免（webhook 來源）

**Request Header**：
```
Authorization: Bearer <callback_token>
X-Callback-Signature: HMAC-SHA256(payload, token)
X-Idempotency-Key: <unique-key>
Content-Type: application/json
```

**Request Body**：
```json
{
  "publish_grant_id": "grant-uuid-5678",
  "build_status": "success" | "failure" | "cancelled",
  "image_uri": "model-cards.azurecr.io/model-cards/echo-model:0.1.0",
  "image_digest": "sha256:abc123def456...",
  "image_labels_json": "{\"model-version\": \"0.1.0\", ...}",
  "workflow_run_url": "https://github.com/owner/repo/actions/runs/12345",
  "workflow_logs_url": "https://github.com/owner/repo/actions/runs/12345/attempts/1"
}
```

**Response (202 Accepted)**：
```json
{
  "status": "received",
  "evidence_id": "evidence-uuid-9999",
  "message": "Callback processed; image verification in progress",
  "next_status": "pending_review"
}
```

**Response (400 Bad Request)**：
```json
{
  "error": "CALLBACK_SIGNATURE_INVALID | PAYLOAD_VALIDATION_FAILED | ACR_ARTIFACT_NOT_FOUND",
  "message": "Signature verification failed"
}
```

**Response (403 Forbidden)**：
```json
{
  "error": "CALLBACK_SIGNATURE_INVALID",
  "message": "Bearer token not recognized or expired"
}
```

**Response (409 Conflict)**：
```json
{
  "error": "GRANT_EXPIRED | GRANT_REVOKED",
  "message": "Grant has expired or been revoked"
}
```

---

## 資料表映射

### `model_publish_callback_event`
```sql
CREATE TABLE model_publish_callback_event (
  callback_event_id NVARCHAR(36) PRIMARY KEY,
  publish_grant_id NVARCHAR(36) NOT NULL,  -- FK
  idempotency_key NVARCHAR(MAX),  -- X-Idempotency-Key from request
  received_at DATETIME2 NOT NULL,
  
  -- Payload 內容
  build_status VARCHAR(30) NOT NULL,  -- success | failure | cancelled
  image_uri NVARCHAR(MAX),
  image_digest NVARCHAR(MAX),  -- sha256:...
  image_labels_json NVARCHAR(MAX),  -- JSON string
  workflow_run_url NVARCHAR(MAX),
  workflow_logs_url NVARCHAR(MAX),
  
  -- 簽章驗証結果
  signature_valid BIT NOT NULL,
  signature_error NVARCHAR(255),  -- 若驗証失敗的原因
  
  -- 幂等性檢查
  is_duplicate BIT DEFAULT 0,
  duplicate_of_callback_id NVARCHAR(36),  -- 若是重複，指向原 callback
  
  FOREIGN KEY (publish_grant_id) REFERENCES model_publish_grant(publish_grant_id),
  UNIQUE (publish_grant_id, idempotency_key)  -- 幂等性
);
```

### `model_publish_evidence`
```sql
CREATE TABLE model_publish_evidence (
  evidence_id NVARCHAR(36) PRIMARY KEY,
  publish_grant_id NVARCHAR(36) NOT NULL,
  callback_event_id NVARCHAR(36),
  
  -- CI 驗証結果
  ci_build_status VARCHAR(30),  -- success | failure | cancelled
  ci_logs_url NVARCHAR(MAX),
  ci_completed_at DATETIME2,
  
  -- ACR Artifact 驗証
  artifact_verification_status VARCHAR(30),  -- success | failure | not_attempted
  artifact_image_uri NVARCHAR(MAX),
  artifact_digest NVARCHAR(MAX),
  artifact_labels_json NVARCHAR(MAX),
  artifact_pull_success BIT,
  artifact_digest_match BIT,
  artifact_labels_match BIT,
  
  -- 驗証總結
  verification_summary NVARCHAR(MAX),  -- JSON: {passed: [...], failed: [...], warnings: [...]}
  verification_completed_at DATETIME2,
  
  -- 狀態機轉移
  status_before VARCHAR(30),
  status_after VARCHAR(30),
  transition_reason VARCHAR(100),  -- callback_received | verification_failed 等
  
  FOREIGN KEY (publish_grant_id) REFERENCES model_publish_grant(publish_grant_id),
  FOREIGN KEY (callback_event_id) REFERENCES model_publish_callback_event(callback_event_id)
);
```

---

## 不變式（Invariants）

1. **簽章驗証失敗 → 403 Forbidden**  
   不寫入資料庫；直接拒絕。

2. **同一 publish_grant_id 的重複 callback → 幂等性保證**  
   檢查 (publish_grant_id, idempotency_key) unique；若重複，返回 202 (已接收)，不重複處理。

3. **狀態轉移遵循 PUBLISHING_STATE_TRANSITIONS**  
   callback_accepted 時 grant_issued → pending_review（不可跳過或反向）。

4. **Draft 狀態轉移前必驗証 grant 未過期或撤銷**  
   呼叫環節 02 的 is_grant_expired()；若過期/撤銷，拒絕轉移。

5. **驗証結果永久儲存**  
   model_publish_evidence 記錄不可刪除或修改；用於後續 audit 與 review。

---

## 邊界條件（Boundary Conditions）

### 支持

- ✅ Callback 異步接收（無同步 image 拉取，可後台驗証）
- ✅ Build failure 時仍接受 callback（允許 revision）
- ✅ 多次 callback 由同一 grant（需 idempotency_key 不同）
- ✅ ACR artifact 驗証為「盡力」（失敗不中止，留 review 層決策）
- ✅ Callback URL 可重定向（允許 301/302）

### 不支持

- ❌ Callback 同步等待 ACR 驗証完成（防阻塞）
- ❌ 過期 grant 的 callback 接受（必拒絕）
- ❌ 嵌套 callback（webhook 不觸發二次 webhook）

---

## Source of Truth

| 項目 | 位置 | 備註 |
|-----|------|------|
| Callback endpoint | [utils/routes/model_card_publish_routes.py](../../../utils/routes/model_card_publish_routes.py#L52-L62) | 路由定義 |
| Callback 處理邏輯 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L692-L750) | `process_publish_callback()` 函式 |
| Payload 驗証 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L352-L368) | `verify_callback_payload()` 函式 |
| 資料表 | [utils/db.py](../../../utils/db.py#L231-L283) | `_MODEL_PUBLISH_CALLBACK_EVENT_SCHEMA` |
| CSRF 豁免 | [utils/security.py](../../../utils/security.py) | 需檢查是否已豁免 callback endpoint |

---

## 待確認項（TBD）

1. **ACR Artifact 驗証超時**  
   - 若 ACR API 無回應（>5s），是否中止 callback 處理或標記為「待稍後驗証」？
   - 當前無超時邏輯
   - **決策方**：RD / QE（可靠性）
   - **Priority**：P1

2. **Build Failure 時的狀態轉移**  
   - 若 build_status = failure，是否轉移為 revision_requested 或保持 grant_issued？
   - **決策方**：PM（業務邏輯）
   - **Priority**：P1

3. **Callback 異步驗証**  
   - Image 拉取與驗証是否應在 background job 中進行（當前同步）？
   - **決策方**：RD / QE（性能決策）
   - **Priority**：P2

---

## 交付驗收（查核點 Checklist）

### Checked 填寫規範

本環節以表格 `Checked` 欄位管理：`Y`=完成、`N`=未完成、`N/A`=不適用。

每個查核點皆需逐列填寫 `規劃簽核`、`施工簽核`、`測試簽核`，不得改為整份文件一次簽核。

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Callback Endpoint 與認證 | endpoint、CSRF 豁免、Bearer token 驗證與速率限制策略完整。 | Y | utils/routes/model_card_publish_routes.py; utils/security.py; tests/test_model_card_publish_routes.py; tests/test_security_session.py | 2026-06-29：已補 callback 速率限制（429）。 | PSM-C1 | RD-C1 | QE-C1 |
| 簽章驗證安全性 | signature 讀取、HMAC-SHA256、constant-time compare 與拒絕策略正確。 | Y | utils/model_card/publishing.py; utils/routes/model_card_publish_routes.py; tests/test_model_card_publishing.py; tests/test_model_card_publish_routes.py | 2026-06-29 完成第一輪：新增 `X-Callback-Signature` 驗證與 403 拒絕契約。 | PSM-C1 | RD-C1 | QE-C1 |
| Payload Schema 驗證 | JSON 與必要欄位驗證完整，缺漏可回傳明確錯誤。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 已驗證缺欄位錯誤碼 `CALLBACK_FIELD_REQUIRED`。 | PSM-C1 | RD-C1 | QE-C1 |
| Idempotency 機制 | idempotency key 讀取、重複檢查與 duplicate 回應可重現。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py; tests/test_model_card_publish_routes.py | duplicate callback 會回既有結果且不重複寫入。 | PSM-C1 | RD-C1 | QE-C1 |
| ACR Artifact 可驗證 | pull/digest/labels 三項驗證可執行且有結果欄位。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 已導入 pluggable `registry_artifact_fetcher`，驗證 digest/labels/config_digest 並回填 verification 結果。 | PSM-C1 | RD-C1 | QE-C1 |
| Grant 有效性檢查 | grant 過期/撤銷/狀態不符時可阻擋轉移。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 已覆蓋 expired/revoked/terminal status 拒絕。 | PSM-C1 | RD-C1 | QE-C1 |
| 狀態轉移分支 | success/failure/cancelled 分支與轉移紀錄一致。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 以 `ci_status` 驅動 accepted/rejected 分支並進行狀態轉移。 | PSM-C1 | RD-C1 | QE-C1 |
| 驗證結果落表 | callback event 與 evidence 記錄完整且欄位齊備。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 已確認 callback_event/evidence/image_artifact 三表寫入。 | PSM-C1 | RD-C1 | QE-C1 |
| 錯誤碼與回應契約 | 錯誤碼集合完整，JSON 回應格式一致且不洩露細節。 | Y | utils/routes/model_card_publish_routes.py; tests/test_model_card_publish_routes.py | 已補 `CALLBACK_SIGNATURE_INVALID`=403、`CALLBACK_RATE_LIMITED`=429。 | PSM-C1 | RD-C1 | QE-C1 |
| 監測與日誌 | 指標可觀測，日誌可追溯驗證與轉移結果。 | Y | utils/model_card/publishing.py | 已加 callback duplicate/signature invalid 結構化日誌，後續可接監測平台。 | PSM-C1 | RD-C1 | QE-C1 |
| 文件與故障排查 | API 文檔、故障排查與告警門檻可操作。 | Y | docs/internal-contracts/model_card_publishing_implementation.md | 已補 callback header 契約、簽章錯誤與節流錯誤排障步驟。 | PSM-C1 | RD-C1 | QE-C1 |

---

## 依賴於此環節的下游

| 下游環節 | 依賴點 | 需求 |
|---------|--------|------|
| **環節 06** (生命週期管理) | Draft 狀態、Evidence 記錄 | 狀態轉移清楚，用於查詢與審計 |
| **環節 07** (Pages 文件) | Callback 簽章規則、故障排查 | 完整文件化 |

---

## 關鍵決策總結

| 決策項 | 當前值 | 理由 | 變更影響 |
|--------|--------|------|---------|
| Callback 簽章驗証 | 強制 (403 if fail) | 安全必須；防 webhook spoofing | 若去除，安全性顯著下降 |
| Idempotency | unique (grant_id, key) | 防重複；幂等 | 若無 idempotency，重複 callback 破壞狀態 |
| ACR 驗証 | 非強制 (警告層) | 異步可靠性；不阻塞 callback | 若改強制，callback latency 增加 |
| 狀態轉移 | callback → pending_review | 準備審核；允許人工決策 | 若直接發布，跳過審核環節 |

---

### 簽核說明

本環節改為逐查核點簽核：每列均需填寫 `規劃簽核`、`施工簽核`、`測試簽核`。
