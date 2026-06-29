# 環節 06：授權資源生命週期管理

## 簡述

定義平台運維團隊如何管理授權資源（Publish Grant、ACR credential、Callback Token）的簽發、輪替、撤銷、過期、稽核。本環節涵蓋運維工作流、自動化清理 job、合規稽核、應急響應。

---

## 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Grant 簽發政策** | TTL 預設值、revocation reason 分類、審核權限 | 初始簽發邏輯（屬環節 02） |
| **Credential Rotation** | ACR username/password 輪替計畫、GitHub Secrets 更新通知 | ACR 帳戶實際創建（屬 DevOps） |
| **Revocation Workflow** | 撤銷 API、cascading invalidation (callback token 失效) | 業務決策何時撤銷（屬 PM） |
| **Expiration Job** | 自動過期標記、清理過期資源、通知開發者 | Grant 過期後的業務轉移（屬 PM） |
| **Secret Store 抽象層** | Key Vault / Vault.io adapter；支援多後端 | 具體 KV 實裝（屬 Infrastructure） |
| **稽核日誌** | 記錄所有簽發/撤銷/輪替事件、合規報告產出 | 日誌儲存基礎設施（屬 Infrastructure） |

---

## 依賴方向

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

## Public API Contract

### 1. 撤銷 Publish Grant

**Endpoint**：`POST /api/admin/model-card-publish/{publish_grant_id}/revoke`

**認証**：session 必須存在；要求 admin 或 maintain 角色

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

**認証**：admin / maintain

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

**認証**：admin / maintain

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

3. **稽核日誌不可刪除**  
   audit_log 表的記錄為 append-only；無 DELETE 或 UPDATE，只有 INSERT。

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
- ✅ Grace period（舊 credential 短期可用）

### 不支持

- ❌ Grant 過期後自動延長（需新簽發）
- ❌ Credential 自動輪替（當前手動；可留二期自動化）
- ❌ 撤銷後的 callback 恢復（revoked 狀態永久）
- ❌ 稽核日誌刪除（合規必須保留）

---

## Source of Truth

| 項目 | 位置 | 備註 |
|-----|------|------|
| 撤銷邏輯 | [utils/model_card/publishing.py](../../../utils/model_card/publishing.py) | 需搜尋 revoke 相關函式 |
| 資料表擴展 | [utils/db.py](../../../utils/db.py) | model_publish_grant, audit_log schema |
| Expiration Job | 待實作 | Scheduled task，建議 hourly 或 daily |
| Credential Rotation | 待實作 | Manual endpoint + notification |

---

## 待確認項（TBD）

1. **Credential Rotation 自動化程度**  
   - 當前規劃為手動 (運維人員呼叫 API 觸發)
   - 若需自動輪替，考慮 30/60/90 天自動轉換策略
   - **決策方**：Infrastructure / PM
   - **Priority**：P2

2. **Grace Period 長度**  
   - 輪替後舊 credential 應可用多久（建議 24-48 小時）？
   - **決策方**：PM / RD（安全與便利權衡）
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

## 查核清單（Checklist）

### Grant 撤銷

- [ ] **撤銷 API 定義**：只有 admin/maintain 可呼叫
- [ ] **Revocation Reason 列舉**：emergency_security_incident, provider_violation, license_expired, other
- [ ] **副作用檢查**：
  - model_publish_grant 記錄 revoked_at, reason, note
  - 後續 callback 拒絕
  - 稽核日誌記錄此事件
- [ ] **無法恢復**：revoked grant 無復原 API

### Credential Rotation

- [ ] **Rotation API 定義**：admin 專用
- [ ] **受影響 Grant 清單**：rotation 時回傳所有使用舊 credential 的 grant
- [ ] **Grace Period 管理**：
  - 新 credential 發放立刻可用
  - 舊 credential 保留 24-48 小時
  - 超期後 callback 驗証時拒絕
- [ ] **通知機制**：郵件或 webhook 通知受影響提供者
- [ ] **更新指南**：提供清晰的 GitHub 秘密更新步驟文件

### 過期管理

- [ ] **Expiration Scanner Job**：定期 (hourly/daily) 掃描 expires_at < now 的 grant
- [ ] **標記與通知**：
  - 在距離過期 7 天時發送提醒通知
  - 過期當日標記狀態為 expired
  - 運維人員可查詢即將過期清單
- [ ] **過期 Grant 無法用於 Callback**：callback 驗証時檢查 expires_at

### 稽核日誌

- [ ] **事件類型涵蓋**：
  - grant_issued
  - callback_received
  - grant_revoked
  - credential_rotation
  - expiration_check
  - cleanup
- [ ] **Append-only 表**：audit_log 無 DELETE/UPDATE，只有 INSERT
- [ ] **完整欄位**：timestamp, actor, event_type, details (JSON), ip_address, user_agent
- [ ] **查詢 API**：按 grant_id / date range / event_type 查詢

### 監測與告警

- [ ] **監測指標**：
  - Grant 簽發速率
  - Grant 撤銷速率
  - Credential 輪替頻率
  - 過期 Grant 計數
  - 稽核日誌寫入速率
- [ ] **告警規則**：
  - 撤銷 grant 連續 >5 次，可能安全事故
  - Credential 輪替失敗計數 >2，告警
  - 審計日誌寫入失敗，critical alert

### 文件與 SOP

- [ ] **運維 SOP**：
  - 何時手動撤銷 grant（emergency response checklist）
  - Credential 輪替流程（按步驟指南）
  - 過期 grant 清理程序
  - 稽核報告產出方式
- [ ] **故障排查**：
  - Credential 輪替失敗原因與修復
  - Callback 驗証失敗（revoked/expired grant）
  - 稽審日誌查詢技巧
- [ ] **訓練材料**：運維人員培訓資料

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
| Credential Rotation | 手動觸發 + 通知 | 運維控制度高；可 grace period | 若全自動，失敗恢復困難 |
| 過期政策 | TTL 後自動過期 + 標記 | 簡單可靠 | 若允許延長，需新簽發或版本管理 |
| 稽審保留 | 無限期 | 合規必須 | 若短期刪除，違反合規要求 |

---

**查核完成日期**：_____________  
**完成者**：_____________  
**審核者**：_____________  
