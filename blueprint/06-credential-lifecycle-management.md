# 環節 06：授權資源生命週期管理

## 簡述

定義平台運維團隊如何管理授權資源（Publish Grant、ACR credential、Callback Token）的簽發、輪替、撤銷、過期、稽核。本環節涵蓋運維工作流、自動化清理 job、合規稽核、應急響應。

## 啟動

| 項目 | 啟動標準 |
| --- | --- |
| 權限政策 | 管理 API 僅允許 `admin`。 |
| 稽核政策 | 主紀錄可刪除，但刪除事件不可刪除。 |
| 失效策略 | 舊金鑰輪替後立即失效（無緩衝）。 |
| 交接邊界 | 02 負責初始簽發，06 負責後續生命週期。 |

---

## 規劃

### 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Grant 簽發政策** | TTL 預設值、revocation reason 分類、審核權限 | 初始簽發邏輯（屬環節 02） |
| **Credential Rotation** | ACR username/password 輪替計畫、GitHub Secrets 更新通知 | ACR 帳戶實際創建（屬 DevOps） |
| **Revocation Workflow** | 撤銷 API、cascading invalidation (callback token 失效) | 業務決策何時撤銷（屬 PM） |
| **Expiration Job** | 自動過期標記、清理過期資源、通知開發者 | Grant 過期後的業務轉移（屬 PM） |
| **Secret Store 抽象層** | Key Vault / Vault.io adapter；支援多後端 | 具體 KV 實裝（屬 Infrastructure） |
| **稽核日誌** | 記錄所有簽發/撤銷/輪替事件、合規報告產出 | 日誌儲存基礎設施（屬 Infrastructure） |

---

### 依賴方向

```
運維後台 / Scheduled Job
    ├─→ Grant 簽發 API (環節 02)
    ├─→ Grant 撤銷 API
    ├─→ Credential Rotation Job
    │   ├─→ ACR API (轉換 credential)
    │   └─→ GitHub Secrets API (通知更新)
    ├─→ Expiration Scanner
    │   ├─→ Database 查詢 expires_at < now
    │   └─→ 標記為 expired
    ├─→ Secret Store (Key Vault adapter)
    │   └─→ 儲存/輪替/撤銷秘密
    └─→ Audit Log Writer
        └─→ 稽核日誌表
```

---

## 執行（真的要施工的細部規格）

### Public API Contract

### 1. 撤銷 Publish Grant

**Endpoint**：`POST /api/admin/model-card-publish/{publish_grant_id}/revoke`

**認証**：session 必須存在；僅允許 `admin`

**Request Body**：
```json
{
  "reason": "emergency_security_incident | provider_violation | license_expired | other",
  "revocation_note": "提供撤銷原因說明 (optional)"
}
```

**Response (200 OK)**：
```json
{
  "publish_grant_id": "grant-uuid-5678",
  "status": "revoked",
  "revoked_at": "2026-06-29T15:30:00Z",
  "revoked_by": "admin_user",
  "reason": "emergency_security_incident"
}
```

**Side Effect**：
- model_publish_grant.revoked_at ← now
- model_publish_grant.revocation_reason ← reason
- model_publish_grant.status ← revoked
- 後續 callback 檢查時會發現 grant revoked，拒絕接受
- GitHub Secrets 可選擇性地通知提供者（需第三方集成）

---

### 2. 輪替 ACR Credential

**Endpoint**：`POST /api/admin/model-card-acr/credentials/rotate`

**認証**：僅允許 `admin`

**Request Body**：
```json
{
  "acr_name": "model-cards",
  "force_immediate": false,
  "notification_mode": "email | webhook | both"
}
```

**Response (200 OK)**：
```json
{
  "acr_name": "model-cards",
  "rotation_started_at": "2026-06-29T15:30:00Z",
  "rotation_completed_at": "2026-06-29T15:35:00Z",
  "old_username": "old-acr-user",
  "new_username": "new-acr-user",
  "affected_grants_count": 42,
  "affected_grants": [
    { "publish_grant_id": "grant-uuid-5678", "provider": "alice", "model_id": "echo-model" },
    ...
  ],
  "github_secrets_update_required": true,
  "update_instructions_url": "https://..."
}
```

**Manual Step Required**（不自動化）：
- 各提供者需手動在 GitHub Repository secrets 中更新 AIHUB_ACR_USERNAME 與 AIHUB_ACR_PASSWORD
- Platform 可提供通知郵件 + 更新指南連結

---

### 3. 查詢過期 Grant

**Endpoint**：`GET /api/admin/model-card-publish/status?days_until_expiry=7`

**認証**：僅允許 `admin`

**Query Parameters**：
- days_until_expiry: 查詢距今 N 天內即將過期的 grant（預設 7 天）

**Response (200 OK)**：
```json
{
  "expires_in_days": 7,
  "total_count": 15,
  "items": [
    {
      "publish_grant_id": "grant-uuid-5678",
      "owner_username": "alice",
      "model_id": "echo-model",
      "expires_at": "2026-07-06T10:30:00Z",
      "days_remaining": 7,
      "status": "grant_issued",
      "callback_status": "pending_response"
    },
    ...
  ]
}
```

---

### 4. 列出所有過期 Grant（已過期）

**Endpoint**：`GET /api/admin/model-card-publish/expired`

**Response (200 OK)**：
```json
{
  "total_count": 24,
  "items": [
    {
      "publish_grant_id": "grant-uuid-old",
      "owner_username": "bob",
      "model_id": "old-model",
      "expired_at": "2026-06-15T10:30:00Z",
      "cleanup_status": "not_cleaned | cleaned"
    },
    ...
  ]
}
```

---

### 5. 稽核報告：特定 Grant 的操作歷史

**Endpoint**：`GET /api/admin/model-card-publish/{publish_grant_id}/audit`

**Response (200 OK)**：
```json
{
  "publish_grant_id": "grant-uuid-5678",
  "audit_events": [
    {
      "event_id": "event-uuid-1",
      "timestamp": "2026-06-29T10:30:00Z",
      "event_type": "grant_issued | callback_received | grant_revoked | credentials_rotated",
      "actor": "alice | system | admin",
      "details": "{}",
      "ip_address": "192.168.1.1" (if applicable),
      "user_agent": "..." (if applicable)
    },
    ...
  ]
}
```

---

## 資料表映射

### `model_publish_grant` (擴展)
```sql
-- 在環節 02 基礎上擴展：
ALTER TABLE model_publish_grant ADD (
  revoked_at DATETIME2,
  revocation_reason VARCHAR(100),  -- enum: emergency_security_incident, provider_violation, ...
  revocation_note NVARCHAR(500),
  revoked_by_username NVARCHAR(255),
  
  -- Credential rotation tracking
  credential_rotation_count INT DEFAULT 0,
  last_credential_rotation_at DATETIME2
);
```

### `model_credential_audit_log` (新表)
```sql
CREATE TABLE model_credential_audit_log (
  audit_event_id NVARCHAR(36) PRIMARY KEY,
  publish_grant_id NVARCHAR(36),  -- FK, 可為 null (系統層事件)
  event_type VARCHAR(50),  -- grant_issued | callback_received | grant_revoked | credential_rotation | expiration_check | cleanup
  actor_username NVARCHAR(255),  -- 執行者或 'system'
  actor_type VARCHAR(30),  -- user | system | service_principal
  event_details NVARCHAR(MAX),  -- JSON: { action, resource_id, before, after, ... }
  created_at DATETIME2 NOT NULL,
  ip_address NVARCHAR(45),  -- IPv4 or IPv6
  user_agent NVARCHAR(MAX),
  
  INDEX idx_publish_grant_id (publish_grant_id),
  INDEX idx_created_at (created_at),
  INDEX idx_event_type (event_type)
);
```

### `model_credential_secret_rotation` (新表，可選)
```sql
CREATE TABLE model_credential_secret_rotation (
  rotation_event_id NVARCHAR(36) PRIMARY KEY,
  acr_name NVARCHAR(100),
  old_credential_hash NVARCHAR(MAX),  -- HMAC of old credential
  new_credential_hash NVARCHAR(MAX),
  rotation_status VARCHAR(30),  -- in_progress | completed | failed | rolled_back
  rotation_started_at DATETIME2 NOT NULL,
  rotation_completed_at DATETIME2,
  affected_grants_count INT,
  failed_updates_count INT,
  
  -- 通知狀態
  notification_status VARCHAR(30),  -- not_sent | email_sent | email_failed | webhook_sent | webhook_failed
  notification_sent_at DATETIME2
);
```

---

## 不變式（Invariants）

1. **撤銷後 Grant 不可恢復**  
   revoked_at 一旦設置，不可修改或清空；revoked status 永久。

2. **Credential 輪替不中斷現有使用**  
   發放新 credential 時，舊 credential 仍短期可用（grace period），待所有 grant 更新後才廢除。

3. **稽核刪除政策分層**  
  主紀錄可刪除；刪除事件必須寫入不可刪除的刪除追蹤紀錄。

4. **過期標記後 grant 無法再用於 callback**  
   Callback 驗証時若發現 expires_at < now，拒絕接受。

5. **Credential Rotation 必記錄 before/after hash**  
   不儲存原文；用雜湊驗証新舊 credential 存在。

---

## 邊界條件（Boundary Conditions）

### 支持

- ✅ 手動撤銷 grant（即刻生效）
- ✅ 自動過期（expires_at < now）
- ✅ 批量查詢過期 grant（用於清理）
- ✅ Credential 輪替通知（郵件 / webhook）
- ✅ 完整稽核日誌（所有操作記錄）
- ✅ 舊金鑰輪替後立即失效（不保留緩衝）

### 不支持

- ❌ Grant 過期後自動延長（需新簽發）
- ❌ Credential 自動輪替（當前手動；可留二期自動化）
- ❌ 撤銷後的 callback 恢復（revoked 狀態永久）
- ❌ 刪除事件紀錄刪除（刪除事件必須可追蹤且不可刪）

---

## Source of Truth

| 項目 | 位置 | 備註 |
|-----|------|------|
| 撤銷邏輯 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py) | 需搜尋 revoke 相關函式 |
| 資料表擴展 | [utils/db.py](../../../utils/db.py) | model_publish_grant, audit_log schema |
| Expiration Job | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py) | `expire_publish_grants()` + admin expire-scan API |
| Credential Rotation | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py) | `rotate_publish_grant_credential()` + admin API |

---

## 待確認項（TBD）

1. **Credential Rotation 自動化程度**  
   - 當前規劃為手動 (運維人員呼叫 API 觸發)
   - 若需自動輪替，考慮 30/60/90 天自動轉換策略
   - **決策方**：Infrastructure / PM
   - **Priority**：P2

2. **刪除事件追蹤最小欄位**  
  - 刪除追蹤是否強制包含 reason、actor、target、timestamp、request_id？
  - **決策方**：PM / RD
  - **Priority**：P1

3. **稽核日誌保留期限**  
   - 合規要求保留多久（建議 90+ 天）？
   - **決策方**：法務 / 合規部門
   - **Priority**：P0（合規必須）

4. **過期 Grant 自動清理**  
   - 過期 N 天後是否自動刪除資料或僅標記（當前無刪除邏輯）？
   - **決策方**：PM / RD（資料保留政策）
   - **Priority**：P2

---

## 交付驗收（查核點 Checklist）

### Checked 填寫規範

本環節以表格 `Checked` 欄位管理：`Y`=完成、`N`=未完成、`N/A`=不適用。

每個查核點皆需逐列填寫 `規劃簽核`、`施工簽核`、`測試簽核`，不得改為整份文件一次簽核。

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Grant 撤銷 API | 僅 admin 可撤銷，原因枚舉完整，且撤銷不可恢復。 | Y | `utils/routes/model_card_publish_routes.py` (`/revoke`) + `utils/model_card/publishing.py` (`revoke_publish_grant`) | admin gate + reason enum 完成。 | PM | RD | QE |
| 撤銷副作用一致 | 撤銷後 grant 標記、callback 阻擋與稽核記錄一致。 | Y | `utils/model_card/publishing.py` (`revoke_publish_grant`, `verify_callback_payload`) + unit tests | grant/secret/audit 一致更新。 | PM | RD | QE |
| Credential Rotation API | rotation 為 admin 專用，且可回傳受影響 grant 清單。 | Y | `utils/routes/model_card_publish_routes.py` (`/rotate-credential`) + `utils/model_card/publishing.py` (`rotate_publish_grant_credential`) | rotation API 已上線。 | PM | RD | QE |
| 舊金鑰立即失效 | 輪替後舊 credential/token 立即無效，新 credential 可立即使用。 | Y | `utils/model_card/publishing.py` (`rotate_publish_grant_credential`) + tests | callback token hash 即時替換。 | PM | RD | QE |
| 受影響對象通知 | 輪替完成後可通知受影響提供者並附更新指引。 | Y | `docs/platform/advanced/operations-runbook.md` + `model-card-package-template/docs/github-variables-and-secrets.md` | 依既有 SOP 執行通知。 | PM | RD | QE |
| 過期掃描作業 | scanner 可定期掃描過期 grant 並產生名單。 | Y | `utils/model_card/publishing.py` (`expire_publish_grants`) + `utils/routes/model_card_publish_routes.py` (`/expire-scan`) | 過期掃描 API 與邏輯完成。 | PM | RD | QE |
| 過期提醒與標記 | 可在到期前提醒，到期後標記 expired 並供查詢。 | Y | `utils/model_card/publishing.py` (`expire_publish_grants`, `list_publish_pipeline_status`) | 到期標記與查詢可用。 | PM | RD | QE |
| Callback 過期阻擋 | callback 驗證會阻擋 expired grant。 | Y | `utils/model_card/publishing.py` (`verify_callback_payload`) + `tests/test_model_card_publishing.py` | expired 會回 `PUBLISH_GRANT_EXPIRED`。 | PM | RD | QE |
| 稽核事件覆蓋完整 | issued/callback/revoked/rotation/expiration/cleanup 事件可追蹤。 | Y | `utils/model_card/publishing.py` (`_write_publish_grant_audit`) + `utils/db.py` (`model_publish_grant_audit`) | 事件寫入與索引已完成。 | PM | RD | QE |
| 稽核保留策略一致 | 主紀錄可刪，刪除事件不可刪，且欄位完整。 | Y | `utils/db.py` schema + `docs/platform/advanced/operations-runbook.md` | 稽核表結構與保留原則文件化。 | PM | RD | QE |
| 稽核查詢能力 | 可按 grant、時間區間、事件類型查詢。 | Y | `utils/model_card/publishing.py` (`list_publish_grant_audits`) + `/api/admin/model-card-publish/audits` | grant/event_type 查詢已實作。 | PM | RD | QE |
| 監測與告警 | 指標完整，異常門檻可觸發告警。 | Y | `utils/model_card/publishing.py` metrics + `docs/platform/advanced/operations-runbook.md` | 監測項與操作門檻已定義。 | PM | RD | QE |
| 文件、SOP、訓練材料 | 操作流程、排障指南與培訓材料可直接落地。 | Y | `docs/internal-contracts/model_card_publishing_implementation.md` + model-provider docs | 操作與排障材料就緒。 | PM | RD | QE |

---

## 依賴於此環節的下游

| 下游環節 | 依賴點 | 需求 |
|---------|--------|------|
| **環節 07** (Pages 文件) | SOP 文件、運維指南、稽核報告樣板 | 完整文件化供運維參考 |

---

## 關鍵決策總結

| 決策項 | 當前值 | 理由 | 變更影響 |
|--------|--------|------|---------|
| 撤銷機制 | 手動 + 永久 | 安全；防誤操作 | 若允許恢復，安全性下降；如允許自動撤銷，複雜度增加 |
| Credential Rotation | 手動觸發 + 通知 + 舊金鑰立即失效 | 運維控制度高，且符合 MVP 安全凍結決策 | 若改回緩衝期，需重新評估風險 |
| 過期政策 | TTL 後自動過期 + 標記 | 簡單可靠 | 若允許延長，需新簽發或版本管理 |
| 稽審保留 | 主紀錄可刪除；刪除事件不可刪除 | 兼顧治理彈性與可追溯性 | 若刪除事件可刪，將失去追責鏈 |

---

### 簽核說明

本環節改為逐查核點簽核：每列均需填寫 `規劃簽核`、`施工簽核`、`測試簽核`。
