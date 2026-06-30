# POV2-05 平台資源與資料

## Metadata 表

| Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename |
| --- | --- | --- | --- |
| POV2-05 | platform-operations-docs-overhaul | POV2-01, POV2-02 | `.github/issues/platform-operations-v2-resources-data-workorder.md` |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 問題陳述與分項目標

平台維運不只包含程式部署，也包含 Azure 資源、正式資料、備份還原、Quota 與機密設定邊界。現有頁面分散於 Azure 資源準備、資料庫結構、資料移轉、Quota 與 CI/CD 文件。V2 需將這些重寫成「平台資源與資料」功能域。

## 預期效益

1. 維護者能分辨 Azure 資源、資料庫、Key Vault、GitHub Variables 與 App Settings 的責任。
2. 資料備份還原與正式資料維護不再被混在架構背景中。
3. Quota 與用量管理被視為平台營運功能，而非零散進階頁。

## In Scope

1. `Azure 資源準備`：依 S6 重寫資源依賴與重建檢查。
2. `資料備份與還原`：依 S7 重寫備份、搬遷、還原與驗收。
3. `Quota 與用量管理`：依 S11 重寫用量與異常管理。
4. `正式資料維護`：依 S4 重寫表與功能對應。
5. `機密與設定邊界`：依 S5 + S6 + S2 重寫 Key Vault、Variables、App Settings 邊界。

## Out of Scope

1. 不提供真實 secret value、resource name 或 production inventory。
2. 不新增資料表、migration 或 Azure 腳本。
3. 不把備份 / restore 指令包裝成已在本輪驗證通過。

## 前置依賴與輸入契約

| 輸入 | 來源 | 要求 |
| --- | --- | --- |
| Azure 資源 | S6 | 不寫實際 production 名稱。 |
| 備份還原 | S7 | 步驟需保留驗收與風險提醒。 |
| Quota 用量 | S11 | 需區分已實作與規劃。 |
| 正式資料 | S4 | 表與功能對應需可追溯。 |
| 設定邊界 | S5 + S6 + S2 | CI/CD 事實落差需標待確認。 |

## SOP1 修正 Handoff

Status: pending-ceo-mapping-review.

本分項下一輪 SOP2 只能依 `00-manifest.md` 的 Formal Page Inventory 施工。正式頁面為：`PV2-R01` `docs/platform-v2/resources-data/azure-resources.md`、`PV2-R02` `docs/platform-v2/resources-data/database-backup-restore.md`、`PV2-R03` `docs/platform-v2/resources-data/quota-usage.md`、`PV2-R04` `docs/platform-v2/resources-data/production-data-maintenance.md`、`PV2-R05` `docs/platform-v2/resources-data/secrets-configuration-boundary.md`。

舊 `azure-environment-and-cicd.md`、`database-and-migration.md`、`quota-and-usage.md` 只能作為歷史草稿參考，不得作為正式施工交付物。

## 執行策略與內容規劃

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| Azure resources | senior-software-engineer | 依 S6 重寫資源依賴、準備目的與重建檢查。 | 平台資源與資料文件 | Azure 資源準備頁 | 不暴露實際 secret / resource values。 | 資源用途與缺失影響清楚。 |
| Data operations | senior-software-engineer | 依 S7 + S4 重寫備份還原與正式資料維護。 | 平台資源與資料文件 | 備份還原、正式資料維護頁 | DB 現況需標來源。 | 資料操作與資料責任分清。 |
| Quota operations | senior-software-engineer | 依 S11 重寫 Quota / usage 功能域。 | 平台資源與資料文件 | Quota 與用量管理頁 | 規劃中功能需揭露。 | 用量異常判讀有來源。 |
| Secrets boundary | senior-software-engineer | 依 S5/S6/S2 重寫 Key Vault、Variables、App Settings 邊界。 | 平台資源與資料文件 | 機密與設定邊界頁 | 不列 secret value。 | 維護者能知道設定放在哪類系統。 |

## 交付物清單

1. Azure 資源準備頁。
2. 資料備份與還原頁。
3. Quota 與用量管理頁。
4. 正式資料維護頁。
5. 機密與設定邊界頁。

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-05-CP1 | Resource boundary | Azure / DB / Key Vault / GitHub 設定責任分清。 | 維護者可定位資源問題。 | 依 S6/S5/S2 重寫。 | QE 檢查是否暴露敏感值或未驗證現況。 | `docs/platform-v2/` |
| POV2-05-CP2 | Data maintenance | 備份還原與正式資料維護有來源與驗收描述。 | 資料操作更可交接。 | 依 S7/S4 重寫。 | 檢查是否含成功條件與風險提示。 | `docs/platform-v2/` |
| POV2-05-CP3 | Quota clarity | Quota 已實作與規劃內容分開。 | 避免營運功能誤判。 | 依 S11 重寫。 | 抽查狀態標記。 | `docs/platform-v2/` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-05-CP1 | confirmed | confirmed | blocked | 已建立 `PV2-R01` 與 `PV2-R05`，說明 Azure 資源與機密設定邊界且不揭露 secret value；待 SOP3 驗證。 |
| POV2-05-CP2 | confirmed | confirmed | blocked | 已建立 `PV2-R02` 與 `PV2-R04`，重寫備份還原與正式資料維護；待 SOP3 驗證來源與風險提示。 |
| POV2-05-CP3 | confirmed | confirmed | blocked | 已建立 `PV2-R03`，區分 Quota、Budget、Credit 與產品策略待確認內容；待 SOP3 驗證。 |

## CEO 待提供資源

| 項目 | 內容 |
| --- | --- |
| Production 資源揭露邊界 | 確認哪些資源資訊可寫入文件，哪些只能描述為 Key Vault / GitHub 設定中的值。 |

## 風險與待確認事項

1. 文件應避免列出實際機密與正式資源清單。
2. 如果備份還原程序未經近期驗證，需標示為來源步驟而非已驗證結果。