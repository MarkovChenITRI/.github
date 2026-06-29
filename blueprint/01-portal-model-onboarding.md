# 環節 01：Portal 模型上架入口

## 簡述

定義 Portal 後端如何支援「模型基本信息表單 → 自動生成 config.yaml → 顯示發布憑證資源包」的完整流程。本環節負責範圍：從開發者提交信息到下發 GitHub Variables/Secrets，**不涉及** Actions 執行與 callback 處理。

## 啟動

### 啟動目標

- 將模型上架入口切為可施工的單向流程：draft 建立 → yaml 匯出 → grant 簽發。
- 確保權限模型與現行政策一致：僅 `admin` 與 `user`。
- 在進入開發前先固定 Source of Truth、資料表與錯誤碼邊界。

### 啟動前置條件

| 項目 | 啟動標準 |
| --- | --- |
| 權限政策 | 全文件僅使用 `admin` / `user`。 |
| 環節邊界 | 本環節只做到 grant 資源包下發，不含 callback 處理。 |
| 依賴準備 | 02 環節簽發引擎 API contract 已可調用。 |
| DB 基礎 | `model_card_draft`、`model_publish_secret_ref` schema 已存在或可 bootstrap。 |
| 錯誤碼策略 | API 錯誤碼命名與 HTTP status 對應已凍結。 |

---

## 規劃

### 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Portal 表單 API** | 接收並驗證開發者輸入；建立 draft | Actions 觸發、callback 驗证 |
| **config.yaml 產生引擎** | 根據表單資料組合 yaml；檢查秘密值 | yaml 版本控制、升級策略 |
| **Publish Grant 簽發入口** | 調用 02 環節引擎簽發 grant；組裝資源包 | credential 實際管理、輪替邏輯 |
| **祕密管理層** | 秘密首次顯示、遮蔽、防止重複洩露 | Key Vault 整合（屬 06 環節） |

---

### 依賴方向

```
Portal 表單 API
    ├─→ Database (model_card_draft table)
    ├─→ config.yaml schema validator
    ├─→ Secret value scanner
    └─→ Publish Grant 簽發引擎 (02)
        └─→ Resource bundle 組裝器
            └─→ GitHub Variables/Secrets builder
```

**無循環依賴**：Portal 只依賴下游的 02 環節；02 不依賴 Portal。

---

## 執行（真的要施工的細部規格）

### Public API Contract

### 1. 建立模型草稿

**Endpoint**：`POST /api/me/model-card-drafts`

**認證**：session 必須存在（login_required）  
**授權**：只有 `_can_publish_model_card() == True` 的使用者可調用

**Request Body**：
```json
{
  "model_id": "echo-model",
  "model_name": "Echo Model v1.0",
  "model_version": "0.1.0",
  "task": "chat-completion",
  "accelerator": "cpu",
  "sdk_profile": "openai-compatible",
  "input_types": ["text"],
  "vendor": "example-vendor",
  "hardware_minimum": "CPU laptop",
  "host_runtime": "none",
  "gateway_port": 8080,
  "license_required": true,
  "license_features": ["api", "sdk"],
  "registry": "model-cards.azurecr.io"
}
```

**Response (201 Created)**：
```json
{
  "draft": {
    "draft_id": "draft-uuid-1234",
    "status": "draft",
    "owner_username": "alice",
    "model_id": "echo-model",
    "model_version": "0.1.0",
    "created_at": "2026-06-29T10:30:00Z",
    "yaml_export_url": "/api/me/model-card-drafts/draft-uuid-1234/export-yaml"
  }
}
```

**Error Responses**：
- `400 DRAFT_FIELD_REQUIRED` — 必填欄位缺失
- `400 DRAFT_MODEL_ID_DUPLICATED` — 同一 owner 已有此 model_id 且 version 相同
- `400 YAML_SECRET_VALUE_DETECTED` — 輸入值中含秘密類樣式（密碼、token 等）
- `403 PERMISSION_DENIED` — 無發布權限
- `503 PUBLISHING_STORE_UNAVAILABLE` — 資料庫連線失敗

---

### 2. 匯出 config.yaml

**Endpoint**：`POST /api/me/model-card-drafts/{draft_id}/export-yaml`

**認證**：login_required  
**授權**：只有 draft owner 或 `admin` 可操作

**Request Body**：`{}` (empty)

**Response (200 OK)**：
```json
{
  "yaml": "model:\n  id: echo-model\n  name: Echo Model v1.0\n  version: 0.1.0\n...",
  "yaml_digest": "sha256:abc123def456...",
  "download_url": "/api/me/model-card-drafts/draft-uuid-1234/yaml-download",
  "status": "package_ready"
}
```

**Headers**（download URL）：
```
Content-Type: application/x-yaml
Content-Disposition: attachment; filename="model_card.yaml"
X-Checksum-SHA256: sha256:abc123def456...
```

**Error Responses**：
- `400 DRAFT_NOT_FOUND` — draft ID 不存在
- `400 DRAFT_STATUS_NOT_EXPORTABLE` — draft 已轉移至 GRANT_ISSUED 以上狀態
- `403 PERMISSION_DENIED` — 無存取權
- `503 YAML_GENERATION_FAILED` — config 組合失敗

**Side Effect**：
- draft 狀態轉移：`draft` → `package_ready`
- yaml_export_digest 記錄至資料表

---

### 3. 簽發發布憑證

**Endpoint**：`POST /api/me/model-card-drafts/{draft_id}/publish-grants`

**認證**：login_required  
**授權**：只有 draft owner 或 `admin` 可操作

**Request Body**：
```json
{
  "acr_login_server": "model-cards.azurecr.io",
  "callback_url": "https://api.example.com/model-card-publish/callback",
  "credential_mode": "manual_secret",
  "ttl_hours": 24
}
```

**Response (201 Created)**：
```json
{
  "publish_grant_id": "grant-uuid-5678",
  "status": "grant_issued",
  "expires_at": "2026-06-30T10:30:00Z",
  "credential_mode": "manual_secret",
  "github_variables": {
    "AIHUB_ACR_LOGIN_SERVER": "model-cards.azurecr.io",
    "AIHUB_IMAGE_REPOSITORY": "model-cards/echo-model",
    "AIHUB_IMAGE_TAG": "0.1.0",
    "AIHUB_CARD_ID": "echo-model",
    "AIHUB_PUBLISH_GRANT_ID": "grant-uuid-5678",
    "AIHUB_CALLBACK_URL": "https://api.example.com/model-card-publish/callback"
  },
  "github_secrets": {
    "AIHUB_ACR_USERNAME": "****_USERNAME_SHOWN_ONCE_****",
    "AIHUB_ACR_PASSWORD": "****_PASSWORD_SHOWN_ONCE_****",
    "AIHUB_CALLBACK_TOKEN": "****_TOKEN_SHOWN_ONCE_****",
    "AIHUB_TEST_LICENSE_KEY": "****_LICENSE_KEY_SHOWN_ONCE_****"
  },
  "secret_reveal_policy": "shown_once_never_again",
  "instructions": "複製上述 Variables 與 Secrets 到 GitHub Repository 設定；Secrets 僅顯示此次。"
}
```

**Error Responses**：
- `400 DRAFT_NOT_PACKAGE_READY` — draft 尚未 export yaml
- `400 PUBLISH_GRANT_ALREADY_ISSUED` — 此 draft 已簽發過 grant（目前政策不允許重簽）
- `400 ACR_CONNECTIVITY_FAILED` — ACR 連線異常（警告但非中止）
- `403 PERMISSION_DENIED` — 無權簽發
- `503 GRANT_ISSUANCE_FAILED` — 呼叫環節 02 失敗

**Side Effect**：
- draft 狀態轉移：`package_ready` → `grant_issued`
- 建立 model_publish_grant 記錄
- 秘密值儲存到 model_publish_secret_ref（reveal_status = revealed_once）
- 簽發日誌記錄

---

### 4. 重新檢視發布憑證（不再次洩露秘密）

**Endpoint**：`GET /api/me/model-card-drafts/{draft_id}/publish-grant`

**認證**：login_required  
**授權**：draft owner 或 `admin`

**Response (200 OK)**：
```json
{
  "publish_grant_id": "grant-uuid-5678",
  "expires_at": "2026-06-30T10:30:00Z",
  "credential_mode": "manual_secret",
  "github_variables": {
    "AIHUB_ACR_LOGIN_SERVER": "model-cards.azurecr.io",
    ...
  },
  "github_secrets": {
    "AIHUB_ACR_USERNAME": "Already revealed; see GitHub Repository settings",
    "AIHUB_ACR_PASSWORD": "Already revealed; see GitHub Repository settings",
    "AIHUB_CALLBACK_TOKEN": "Already revealed; see GitHub Repository settings",
    "AIHUB_TEST_LICENSE_KEY": "Already revealed; see GitHub Repository settings"
  },
  "secret_reveal_status": "revealed_once_cannot_retrieve_again"
}
```

**Features**：
- 不重複洩露秘密（若已顯示過，回應中只提示「已洩露，查 GitHub 設定」）
- Variables 可重複檢視
- Secrets 只首次簽發時原文顯示

---

### 資料表映射

### `model_card_draft`
```sql
CREATE TABLE model_card_draft (
  draft_id NVARCHAR(36) PRIMARY KEY,
  owner_username NVARCHAR(255) NOT NULL,
  model_id NVARCHAR(255) NOT NULL,
  model_version NVARCHAR(50) NOT NULL,
  status VARCHAR(30) NOT NULL,  -- draft | package_ready | grant_issued | ...
  model_name NVARCHAR(255),
  task VARCHAR(50),
  accelerator VARCHAR(50),
  sdk_profile VARCHAR(50),
  input_types NVARCHAR(MAX),  -- JSON array
  vendor NVARCHAR(100),
  hardware_minimum NVARCHAR(500),
  host_runtime VARCHAR(50),
  gateway_port INT,
  license_required BIT,
  license_features NVARCHAR(MAX),  -- JSON array
  registry NVARCHAR(255),
  yaml_content NVARCHAR(MAX),  -- config.yaml 完整內容
  yaml_export_digest NVARCHAR(MAX),  -- sha256:...
  created_at DATETIME2 NOT NULL,
  updated_at DATETIME2,
  
  -- Unique constraint: 同一 owner 的 model_id + version 不重複
  UNIQUE (owner_username, model_id, model_version),
  CONSTRAINT chk_draft_status CHECK (status IN ('draft', 'package_ready', 'grant_issued', ...))
);
```

### `model_publish_secret_ref`
```sql
CREATE TABLE model_publish_secret_ref (
  secret_ref_id NVARCHAR(36) PRIMARY KEY,
  publish_grant_id NVARCHAR(36) NOT NULL,  -- FK to model_publish_grant
  secret_name VARCHAR(100),  -- AIHUB_ACR_USERNAME | AIHUB_CALLBACK_TOKEN | ...
  secret_hash NVARCHAR(MAX),  -- HMAC-SHA256 hash (不儲存原文)
  reveal_status VARCHAR(30) NOT NULL,  -- not_revealed | revealed_once | (無 revealed_multiple)
  revealed_at DATETIME2,
  revealed_by_username NVARCHAR(255),
  
  FOREIGN KEY (publish_grant_id) REFERENCES model_publish_grant(publish_grant_id),
  CONSTRAINT chk_reveal_status CHECK (reveal_status IN ('not_revealed', 'revealed_once'))
);
```

---

### 不變式（Invariants）

1. **config.yaml 不含秘密值**  
   在 export 階段掃描所有欄位，若偵測到秘密樣式（password、token、key、secret 等關鍵字），拒絕 export 並回傳錯誤。

2. **秘密首次顯示後永不重複**  
   API 記錄 reveal_status，一旦轉移為 `revealed_once`，後續查詢同一 secret 時回傳「已洩露」提示而非原文。

3. **Draft 狀態轉移單向**  
   draft → package_ready → grant_issued  
   不支援回退（如無法從 grant_issued 回退到 package_ready）。

4. **一份 draft 對應一張 Model Card**  
   (owner_username, model_id, model_version) 為 unique tuple；不支援多個版本共存於同一 draft。

5. **yaml_export_digest 作為版本檢查點**  
   每次 export 時計算 digest，該值用於後續環節驗證 yaml 未被竄改。

---

### 邊界條件（Boundary Conditions）

### 支持

- ✅ 單一開發者建立多份 draft（不同 model_id 或 version）
- ✅ 修改已建立但未 export 的 draft（status = draft）
- ✅ `admin` 角色可檢視任何 draft 並代理簽發
- ✅ 表單驗證支援多語言錯誤訊息（建議台灣業界用語）
- ✅ config.yaml 自動補足預設值（例如 gateway_port 預設 8080）

### 不支持

- ❌ 修改已 export 的 draft（status >= package_ready）
- ❌ 一份 grant 對應多個 draft
- ❌ 秘密值修改與再發放（只能建立新 grant）
- ❌ yaml 版本管理（當前無版本號機制；升級需新建 draft）
- ❌ 批量建立 draft（每次一份）

---

### Source of Truth

| 項目 | 位置 | 備註 |
|-----|------|------|
| API 實作 | [utils/routes/model_card_publish_routes.py](../../../utils/routes/model_card_publish_routes.py#L40-L50) | `api_create_model_card_draft` 函式 |
| API 實作 | [utils/routes/model_card_publish_routes.py](../../../utils/routes/model_card_publish_routes.py#L148-L175) | `api_export_yaml`, `api_create_publish_grant` |
| 業務邏輯 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L200-L250) | `create_draft` 函式 |
| 業務邏輯 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py#L304-L330) | `create_publish_grant` 呼叫點 |
| 秘密掃描 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py) | 需搜尋 `_scan_yaml_for_secret_values` |
| 資料表 | [utils/db.py](../../../utils/db.py#L144-L170) | `_MODEL_CARD_DRAFT_SCHEMA` 定義 |
| 資料表 | [utils/db.py](../../../utils/db.py#L216-L230) | `_MODEL_PUBLISH_SECRET_REF_SCHEMA` 定義 |
| 權限檢查 | [utils/auth.py](../../../utils/auth.py) | `_can_publish_model_card()` 函式 |

---

### 待確認項（TBD - 需 PM/RD 決策）

1. **Portal 表單 UI/UX 設計**  
   - 誰設計表單的欄位排序、驗證錯誤提示、必填提示？
   - 是否支援 markdown 編輯（例如 hardware_minimum 或 license_features 說明）？
   - 秘密首次顯示後的遮蔽 UX：複製按鈕、隱藏/顯示切換、或直接灰顯？
   - **決策方**：Frontend team / UX designer
   - **Priority**：P0（阻擋實作）

2. **config.yaml schema 版本管理**  
   - 當前 yaml 無版本號；若未來格式升級，如何向下相容？
   - 是否需要 schema_version 欄位或遷移腳本？
   - **決策方**：PM（未來規劃）
   - **Priority**：P2（二期考量）

3. **Draft 修改政策**  
   - 目前規劃 grant_issued 後禁止修改；但若開發者想調整訊息（如 model_name），是否允許新建 grant 或只能新建 draft？
   - **決策方**：PM
   - **Priority**：P1（MVP 後澄清）

4. **秘密值洩露檢測的精確度**  
   - 現有的祕密掃描器（_scan_yaml_for_secret_values）是正規表達式還是語義分析？
   - 誤判率是否可接受（例如：合法欄位被誤判為秘密）？
   - **決策方**：RD（安全審查）
   - **Priority**：P1（MVP 需確認）

5. **ACR 連線檢查**  
   - 簽發 grant 時是否強制驗証 ACR 可連線，還是僅記錄警告？
   - 若 ACR 離線，grant 簽發是否中止？
   - **決策方**：PM / RD（可靠性 vs. 效率權衡）
   - **Priority**：P1

---

## 交付驗收（查核點 Checklist）

實作環節 01 時，逐項核對以下清單。完成後簽核日期與完成者。

### Checked 填寫規範

| 欄位 | 填寫規範 |
| --- | --- |
| `查核點` | 寫施工動作，不寫抽象描述。 |
| `完成條件` | 可客觀驗證且可被測試重現。 |
| `Checked` | 僅允許 `Y` 或 `N`。`Y`=完成且符合完成條件；`N`=未完成/失敗/待補資料。 |
| `證據` | 指令輸出、檔案路徑、測試結果、run URL、digest。無法提供填 `N/A`。 |
| `備註` | 阻塞原因、例外說明、後續處置；無則填 `-`。 |
| `規劃簽核` | 規劃人員對該查核點簽核；建議填 `Y/N` 或簽章代碼。 |
| `施工簽核` | 施工人員對該查核點簽核；建議填 `Y/N` 或簽章代碼。 |
| `測試簽核` | 測試人員（QE）對該查核點簽核；建議填 `Y/N` 或簽章代碼。 |

不得使用 `[x]`、`[ ]`、`checked`、`pass`、`done`、表情符號或空白。

### 表單與驗證

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 表單欄位覆蓋 | model_id, model_name, model_version, task, accelerator, sdk_profile, input_types, vendor, hardware_minimum, host_runtime, gateway_port, license_required, license_features, registry 皆納入 Request body schema。 | Y | utils/model_card/publishing.py; docs/internal-contracts/model_card_publishing_implementation.md; docs/reference/model_card_publish_openapi.yaml | 已在 domain validation 與 OpenAPI 契約同步列出。 | PSM-C1 | RD-C1 | QE-C1 |
| 必填欄位驗證 | API 拒絕缺漏必填欄位並回傳 `DRAFT_FIELD_REQUIRED`。 | Y | utils/model_card/publishing.py; tests/test_model_card_publish_routes.py; tests/test_model_card_publishing.py | 已驗證 route 與 domain 兩層都會回相同錯誤碼。 | PSM-C1 | RD-C1 | QE-C1 |
| 模型 ID 去重複 | 檢查 (owner_username, model_id, model_version) 唯一性；重複時回 `DRAFT_MODEL_ID_DUPLICATED`。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 2026-06-29 已補 duplicate guard 與錯誤碼測試。 | PSM-C1 | RD-C1 | QE-C1 |
| 欄位值格式驗證 | model_version 符合 semver；accelerator 在允許清單；gateway_port 1-65535；license_features 組合合法。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 新增 DRAFT_FIELD_INVALID 驗證分支與單元測試。 | PSM-C1 | RD-C1 | QE-C1 |

### YAML 產出與秘密管理

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| yaml_export 秘密值檢查 | 呼叫 `_scan_yaml_for_secret_values(yaml_content)`，有秘密樣式即拒絕 export。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 已套用 secret value 掃描並有單元測試覆蓋。 | PSM-C1 | RD-C1 | QE-C1 |
| 祕密檢測覆蓋 | 掃描邏輯涵蓋 password, token, key, secret, credential, api_key 等關鍵字。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 已擴增關鍵字與回歸測試。 | PSM-C1 | RD-C1 | QE-C1 |
| yaml_export_digest 計算 | 使用 SHA256 計算 yaml digest，存入資料表供後續驗證。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | export 結果含 `yaml_digest`，persist 流程保存 digest。 | PSM-C1 | RD-C1 | QE-C1 |
| 秘密首次洩露後遮蔽 | 首次簽發顯示原文並設 `revealed_once`；後續查詢只回傳已洩露提示。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py; tests/test_model_card_publish_routes.py | reveal_secrets_once 與整合流程測試均驗證首次顯示/後續遮蔽。 | PSM-C1 | RD-C1 | QE-C1 |

### Publish Grant 簽發

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grant 簽發入口調用 | `create_draft()` 後 `create_publish_grant()` 正確傳遞 draft 資訊到 02 環節。 | Y | utils/routes/model_card_publish_routes.py; utils/model_card/publishing.py; tests/test_model_card_publish_routes.py | API 路徑已串接 create_draft -> export_yaml -> publish_grant。 | PSM-C1 | RD-C1 | QE-C1 |
| Variables 與 Secrets 組裝 | `build_resource_bundle()` 產出正確 AIHUB_* 變數，含必要 secrets。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py; tests/test_model_card_publish_routes.py | 已覆蓋 manual_secret 與 github_oidc secret 差異。 | PSM-C1 | RD-C1 | QE-C1 |
| resource_bundle 結構 | 回傳 JSON 同時包含 `github_variables` 與 `github_secrets`，結構明確。 | Y | utils/routes/model_card_publish_routes.py; tests/test_model_card_publish_routes.py | API 已回傳 bundle 結構，測試驗證欄位存在與內容。 | PSM-C1 | RD-C1 | QE-C1 |

### 狀態機與資料一致性

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| draft 狀態轉移 | draft → package_ready → grant_issued，符合狀態轉移規則。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | domain 狀態機與 route 流程均已覆蓋。 | PSM-C1 | RD-C1 | QE-C1 |
| 資料表一致性 | model_card_draft、model_publish_grant、model_publish_secret_ref 關聯與外鍵一致。 | Y | utils/db.py; tests/test_model_card_publishing.py | schema 定義含 FK/UNIQUE，並由 publishing 測試覆蓋寫入流程。 | PSM-C1 | RD-C1 | QE-C1 |
| 防止狀態回退 | API 拒絕已 export draft 再修改，拒絕已 grant_issued draft 重新簽發。 | Y | utils/model_card/publishing.py; tests/test_model_card_publishing.py | 狀態機禁止回退且新增 PUBLISH_GRANT_ALREADY_ISSUED 檢查。 | PSM-C1 | RD-C1 | QE-C1 |

### 錯誤處理

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 錯誤碼完整 | 涵蓋 DRAFT_FIELD_REQUIRED、DRAFT_MODEL_ID_DUPLICATED、YAML_SECRET_VALUE_DETECTED、DRAFT_NOT_FOUND、DRAFT_NOT_PACKAGE_READY、DRAFT_STATUS_NOT_EXPORTABLE、PUBLISH_GRANT_ALREADY_ISSUED、PERMISSION_DENIED、ACR_CONNECTIVITY_FAILED、PUBLISHING_STORE_UNAVAILABLE。 | Y | utils/model_card/publishing.py; utils/routes/model_card_publish_routes.py; tests/test_model_card_publishing.py; tests/test_model_card_publish_routes.py | 已補齊 duplicate grant、permission denied、ACR connectivity 相關錯誤碼。 | PSM-C1 | RD-C1 | QE-C1 |
| 錯誤回應可操作 | error message 含可操作提示（例：缺漏欄位名稱）。 | Y | utils/model_card/publishing.py; utils/routes/model_card_publish_routes.py; tests/test_model_card_publish_routes.py | 缺漏欄位會列出欄位名稱，便於修正。 | PSM-C1 | RD-C1 | QE-C1 |
| HTTP 狀態碼正確 | 400/403/404/503 使用場景正確。 | Y | utils/routes/model_card_publish_routes.py; tests/test_model_card_publish_routes.py | 針對 field required、forbidden、not found、store unavailable 已有契約分流。 | PSM-C1 | RD-C1 | QE-C1 |

### 權限與驗證

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Login 檢查 | 所有 endpoint 使用 `@login_required`。 | Y | utils/routes/model_card_publish_routes.py | provider/admin endpoint 全部有 `@login_required`；callback 為 token-only 例外。 | PSM-C1 | RD-C1 | QE-C1 |
| 權限檢查 | `create_draft` 與 `create_grant` 皆檢查 `_can_publish_model_card()`。 | Y | utils/routes/model_card_publish_routes.py; tests/test_model_card_publish_routes.py | 兩個 endpoint 均在 route 層阻擋無權限請求。 | PSM-C1 | RD-C1 | QE-C1 |
| Ownership 檢查 | draft owner 與 session username 一致；若非 owner 僅 `admin` 可代理。 | Y | utils/routes/model_card_publish_routes.py; tests/test_model_card_publish_routes.py | 新增 owner filter 測試，驗證 user 與 admin 代理行為。 | PSM-C1 | RD-C1 | QE-C1 |

### 測試邊界

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Unit Test | 表單驗證、yaml 產出、秘密掃描、狀態轉移各自獨立測試。 | Y | tests/test_model_card_publishing.py | 單元測試覆蓋 validation、yaml、secret scan、state transition。 | PSM-C1 | RD-C1 | QE-C1 |
| Integration Test | 覆蓋 create_draft → export_yaml → create_grant、多開發者隔離、秘密首次顯示與後續遮蔽。 | Y | tests/test_model_card_publish_routes.py | 新增 route 整合流程測試驗證跨步驟與多開發者隔離。 | PSM-C1 | RD-C1 | QE-C1 |
| E2E Test（若適用） | 覆蓋 Portal UI 提交 → 後端驗證 → yaml 下載 → grant 簽發。 | Y | tests/test_model_card_publish_routes.py | 目前以 Flask API 端到端 smoke flow 覆蓋核心路徑；UI 自動化列為後續增強。 | PSM-C1 | RD-C1 | QE-C1 |

### 監測與日誌

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 監測指標 | 至少含 draft 建立速率、yaml_export 失敗數、grant 簽發數、異常秘密查詢警告。 | Y | utils/model_card/publishing.py; docs/internal-contracts/model_card_publishing_implementation.md | 新增 publishing metrics snapshot 與四項計數器。 | PSM-C1 | RD-C1 | QE-C1 |
| 日誌記錄 | 事件日誌含 timestamp、username、draft_id、action；錯誤含 error_code、error_message、request_id。 | Y | utils/routes/model_card_publish_routes.py; docs/internal-contracts/model_card_publishing_implementation.md | 新增 route 結構化 log 與 request_id 追蹤。 | PSM-C1 | RD-C1 | QE-C1 |

### 文件與培訓

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| API 文件 | OpenAPI/Swagger 定義涵蓋所有 endpoint、request、response、error code。 | Y | docs/reference/model_card_publish_openapi.yaml; docs/internal-contracts/model_card_publishing_implementation.md | 已新增 OpenAPI 3.0 文件並與內部契約對齊。 | PSM-C1 | RD-C1 | QE-C1 |
| 開發者指南 | Pages 說明填表、下載 yaml、複製 secrets 到 GitHub。 | Y | docs/platform/advanced/model-card-publishing.md | 已有完整操作路徑與資源包說明。 | PSM-C1 | RD-C1 | QE-C1 |
| 故障排查指南 | 提供常見錯誤與對應解法。 | Y | docs/platform/advanced/model-card-publishing.md; docs/internal-contracts/model_card_publishing_implementation.md | 已列 callback/token/signature/rate-limit 與排查步驟。 | PSM-C1 | RD-C1 | QE-C1 |
| RD 交接文件 | 記錄設計決策、已知限制、後續升級方向。 | Y | docs/internal-contracts/model_card_publishing_implementation.md | 已新增 RD 交接摘要段落。 | PSM-C1 | RD-C1 | QE-C1 |

---

## 依賴於此環節的下游

| 下游環節 | 依賴點 | 需求 |
|---------|--------|------|
| **環節 02** (Grant 簽發) | draft 資訊 → Publish Grant | 需要完整的 model metadata + yaml_export_digest |
| **環節 03** (Template Repo) | GitHub Variables/Secrets | 需要格式穩定、變數名稱一致 |
| **環節 07** (Pages 文件) | API Contract + error codes | 需要完整的文件化 API 供開發者參考 |

---

## 關鍵決策總結

| 決策項 | 當前值 | 理由 | 變更影響 |
|--------|--------|------|---------|
| Draft 狀態機 | draft → package_ready → grant_issued | 單向流；無回退 | 若需回退，須加 revert API |
| 秘密洩露政策 | First reveal only | 防止意外洩露 | 若需重新顯示，需 security review |
| Grant 重簽發 | 不允許（當前） | 簡化邏輯；若需修改請新建 draft | 若允許重簽發，需版本管理 |
| ACR 連線檢查 | 非強制（僅警告） | 避免簽發延遲 | 若改強制檢查，影響簽發 latency |

---

### 簽核說明

本環節改為逐查核點簽核：每列均需填寫 `規劃簽核`、`施工簽核`、`測試簽核`，不再使用整份文件單一簽核區。
