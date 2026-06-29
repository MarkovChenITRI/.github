# 環節 05：Callback 接收與狀態遷移

## 簡述

定義 Platform 如何接收 GitHub Actions callback、驗証簽章、檢驗 ACR artifact、轉移 draft 狀態、儲存驗証結果。本環節是平台事件驅動層，銜接環節 04 (GitHub Actions) 與環節 06 (生命週期管理)。

---

## 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Callback Endpoint** | HTTP POST 接收、rate limiting、CSRF 豁免 | 實際簽署驗証（委派環節 02） |
| **簽章驗証** | HMAC-SHA256 對比、constant-time compare | Token 生成與管理（屬環節 02） |
| **Payload 驗証** | JSON schema 檢查、build_status 有效性 | Payload 內容完整性（環節 04 負責） |
| **ACR Artifact 驗証** | Image 可拉取、digest 一致、labels 檢查 | ACR 帳戶與連線（屬 DevOps） |
| **狀態轉移** | Draft 從 grant_issued → pending_review 或 revision_requested | 最終 review 決策（屬 admin） |
| **驗証結果儲存** | model_publish_evidence 記錄 | 稽核日誌清理（屬環節 06） |

---

## 依賴方向

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

## Public API Contract

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

## 查核清單（Checklist）

### Endpoint 與認証

- [ ] **Endpoint 定義**：`POST /api/model-card-publish/callback` 正確宣告
- [ ] **CSRF 豁免**：callback endpoint 在 security.py 中已豁免 CSRF 檢查
- [ ] **Bearer Token 驗証**：提取 Authorization header 中的 token；若缺漏或無效回傳 401/403
- [ ] **Rate Limiting**：若需要，設置 per-IP 或 per-grant 的速率限制（非強制，可留二期）

### 簽章驗証

- [ ] **Header 提取**：從 X-Callback-Signature 提取簽章值
- [ ] **簽章演算法**：HMAC-SHA256 (與環節 02 一致)
- [ ] **Constant-time Compare**：使用 `secrets.compare_digest()` 比對簽章，防時序攻擊
- [ ] **驗証失敗處理**：返回 403 Forbidden，不進行後續操作

### Payload 驗証

- [ ] **JSON 解析**：安全地解析 request body；若無效 JSON 回傳 400
- [ ] **Schema 驗証**：
  - publish_grant_id: 必填，36 字 UUID
  - build_status: 必填，值 ∈ {success, failure, cancelled}
  - image_uri: 必填（若 build_status=success）
  - image_digest: 必填（若 build_status=success），格式 sha256:...
  - image_labels_json: 可選，若有則為 JSON string
  - workflow_run_url, workflow_logs_url: 必填，URL 格式
- [ ] **缺漏欄位處理**：若必填欄位缺漏，回傳 400 PAYLOAD_VALIDATION_FAILED

### Idempotency 檢查

- [ ] **X-Idempotency-Key 讀取**：若不提供，則由 callback 内容或 publish_grant_id 產生預設值
- [ ] **Duplicate 檢查**：查詢 (publish_grant_id, idempotency_key)，若已存在標記為 duplicate
- [ ] **Duplicate 回應**：返回 202 且 evidence_id 指向原 callback，不重複執行

### ACR Artifact 驗証

- [ ] **Image Pull 測試**：
  - 嘗試 pull image (或至少 HEAD 檢查)
  - 若失敗記錄為 artifact_pull_success = 0
  - 記錄錯誤信息但不中止（允許 review 層決策）
- [ ] **Digest 比對**：
  - 從 ACR 取得實際 digest
  - 與 callback payload 中的 image_digest 比對
  - 若不匹配，標記 artifact_digest_match = 0，記錄警告
- [ ] **Labels 檢查**：
  - 從 image config 讀取 labels
  - 檢查必填 labels（model-version, model-id, publish-grant-id）存在
  - 檢查 model-version == payload 中對應值
  - 若缺漏或不匹配，標記 artifact_labels_match = 0

### 狀態轉移

- [ ] **Grant 有效性檢查**：呼叫環節 02 的 `is_grant_expired(publish_grant_id)`；若過期/撤銷拒絕回傳 409
- [ ] **當前狀態檢查**：Draft status 必為 grant_issued；否則拒絕轉移
- [ ] **Build Status 分支**：
  - build_status = success：轉移 grant_issued → pending_review
  - build_status = failure：轉移 grant_issued → revision_requested (或 pending_review，待決策)
  - build_status = cancelled：保持 grant_issued，記錄為已取消
- [ ] **狀態轉移紀錄**：model_publish_evidence 記錄 status_before, status_after, transition_reason

### 驗証結果儲存

- [ ] **Callback Event 記錄**：model_publish_callback_event 存儲完整 callback payload、簽章驗証結果、時間戳
- [ ] **Evidence 記錄**：model_publish_evidence 存儲驗証摘要：passed/failed/warnings 各項
- [ ] **完整性**：所有欄位完整填充，無 NULL（NULLABLE 欄位除外）

### 錯誤處理

- [ ] **錯誤碼完整**：
  - CALLBACK_SIGNATURE_INVALID (403)
  - PAYLOAD_VALIDATION_FAILED (400)
  - GRANT_EXPIRED (409)
  - GRANT_REVOKED (409)
  - ACR_ARTIFACT_NOT_FOUND (400，訊息層記錄)
  - ACR_ARTIFACT_VERIFICATION_FAILED (202，異步處理)
- [ ] **Error Response 格式**：統一 JSON + error code，無洩露內部細節

### 監測與日誌

- [ ] **監測指標**：
  - callback 接收速率 (requests/min)
  - 簽章驗証失敗計數
  - Duplicate callback 計數
  - ACR artifact 驗証失敗率
  - 狀態轉移成功率
- [ ] **日誌記錄**：
  - callback 接收時間、publish_grant_id、build_status
  - 簽章驗証結果（成功/失敗原因）
  - ACR 驗証結果（各項詳情）
  - 狀態轉移紀錄（before, after, reason）

### 文件與故障排查

- [ ] **API 文檔**：endpoint、request/response 格式、錯誤碼、重試指南
- [ ] **故障排查**：
  - 簽章驗証失敗：檢查 callback_token 是否與 grant 一致
  - ACR 連線失敗：檢查 ACR credential 與網路
  - Duplicate callback：檢查 idempotency_key 是否唯一
  - 狀態轉移失敗：檢查 grant 是否過期、draft 當前狀態
- [ ] **監測告警**：簽章驗証連續失敗 >5 次、ACR 驗証失敗率 >10% 時觸發告警

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

**查核完成日期**：_____________  
**完成者**：_____________  
**審核者**：_____________  
