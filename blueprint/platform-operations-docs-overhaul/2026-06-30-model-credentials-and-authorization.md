# POV2-03 模型憑證與授權

## Metadata 表

| Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename |
| --- | --- | --- | --- |
| POV2-03 | platform-operations-docs-overhaul | POV2-01 | `.github/issues/platform-operations-v2-model-credentials-workorder.md` |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 問題陳述與分項目標

「模型憑證與授權」是現有平台維運中最接近完整功能域的 scope。V2 要保留此優點，重新撰寫模型憑證、權限、授權 token、發布憑證與維護重點，讓維護者先理解有哪些授權物件、誰使用它們、平台在哪些節點檢查它們。

## 預期效益

1. 模型相關授權概念有單一入口與清楚邊界。
2. 權限體系、token 流程與發布憑證不再散落於 advanced / reference 中。
3. 維護者能判斷授權問題應查帳號權限、token、publish grant 或模型上架流程。

## In Scope

1. `總覽`：模型憑證與授權物件地圖。
2. `授權與權限體系`：帳號角色、資源可見性與管理責任。
3. `授權 Token 流程`：授權 token 流程的維護者視角說明。
4. `發布憑證規範`：publish grant 相關規格的維護者說明。
5. `授權相關維護重點`：日常檢查與常見錯誤判讀。

## Out of Scope

1. 不設計新的授權模型。
2. 不修改 token 或 publish grant API shape。
3. 不宣稱正式 License Key 配發已上線，除非來源與 QE 證據確認。

## 前置依賴與輸入契約

| 輸入 | 來源 | 要求 |
| --- | --- | --- |
| 模型憑證總覽 | S8 | 保留概念邊界並改寫成 V2 語氣。 |
| 權限體系 | S9 + S4 | 權限與資料表關係需可追溯。 |
| Token 規格 | S15 | 作為規格來源，不得改寫規格含義。 |
| 發布憑證 | S16 | 作為 publish grant 來源。 |
| 維護重點 | S12 + S8 + S9 | 常見錯誤需標示來源或待補。 |

## SOP1 修正 Handoff

Status: pending-ceo-mapping-review.

本分項下一輪 SOP2 只能依 `00-manifest.md` 的 Formal Page Inventory 施工。正式頁面為：`PV2-A01` `docs/platform-v2/model-credentials-authorization/index.md`、`PV2-A02` `docs/platform-v2/model-credentials-authorization/authorization-access.md`、`PV2-A03` `docs/platform-v2/model-credentials-authorization/license-token-flow.md`、`PV2-A04` `docs/platform-v2/model-credentials-authorization/publish-grant-standard.md`、`PV2-A05` `docs/platform-v2/model-credentials-authorization/maintenance-checkpoints.md`。

舊 `docs/platform-v2/model-credentials-and-authorization.md` 只能作為歷史草稿參考，不得作為正式施工交付物。

## 執行策略與內容規劃

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| Authorization overview | product-strategy-manager | 依 S8 重寫授權物件、使用角色與平台節點。 | 模型憑證與授權文件 | 總覽頁 | 不得新增未來源支撐的授權物件。 | 讀者能分辨 token、grant、license、角色權限。 |
| Access model | senior-software-engineer | 依 S9 + S4 重寫角色、可見性、資料表關係。 | 模型憑證與授權文件 | 授權與權限體系頁 | Schema facts 需確認。 | 權限規則與資料來源可追溯。 |
| Token and grant references | senior-software-engineer | 將 S15、S16 重寫為維護者可查的規格解讀。 | 模型憑證與授權文件 | Token / publish grant 頁 | 不改變規格語意。 | 規格頁能回查原 Reference。 |
| Maintenance notes | senior-software-engineer | 從 S12、S8、S9 抽取日常檢查與錯誤判讀。 | 模型憑證與授權文件 | 授權相關維護重點頁 | 未有證據的錯誤情境標待補。 | 維護者知道授權問題先查哪個面。 |

## 交付物清單

1. 模型憑證與授權總覽頁。
2. 授權與權限體系頁。
3. 授權 Token 流程頁。
4. 發布憑證規範頁。
5. 授權相關維護重點頁。

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-03-CP1 | Authorization object map | 文件列出授權物件、使用角色、平台消費節點。 | 授權概念不混淆。 | 依 S8 重寫總覽。 | QE 檢查是否有未來源支撐物件。 | `docs/platform-v2/` |
| POV2-03-CP2 | Access boundary | 角色、可見性、資料表關聯有來源。 | 維護者能定位權限問題。 | 依 S9 + S4 重寫。 | 抽查權限敘述是否能回查來源。 | `docs/platform-v2/` |
| POV2-03-CP3 | Reference separation | Token / grant 規格與操作維護說明分清楚。 | 規格不被誤用為任務步驟。 | 將 S15/S16 轉成 V2 規格頁。 | QE 檢查規格語意未被改寫。 | `docs/platform-v2/` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-03-CP1 | confirmed | confirmed | blocked | 已依 `PV2-A01` 至 `PV2-A05` 建立 `docs/platform-v2/model-credentials-authorization/` 五頁；待 SOP3 驗證。 |
| POV2-03-CP2 | confirmed | confirmed | blocked | 已重寫平台 session、role gate、資源可見性與部署授權邊界；待 SOP3 驗證來源與權限語意。 |
| POV2-03-CP3 | confirmed | confirmed | blocked | 已建立授權 Token 與發布憑證頁，保留規格語意並標明部署授權 / 發布憑證差異；待 SOP3 驗證。 |

## CEO 待提供資源

| 項目 | 內容 |
| --- | --- |
| 正式授權狀態 | 確認正式 License Key / token / grant 流程哪些已上線，哪些仍為 PoC 或規劃。 |

## 風險與待確認事項

1. 若正式 License Key 配發尚未上線，V2 不得把它寫成可操作流程。
2. Reference 規格若包含工程契約，文件需標示讀者是否應直接操作。 