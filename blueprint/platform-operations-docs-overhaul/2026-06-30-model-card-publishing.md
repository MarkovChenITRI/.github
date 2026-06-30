# POV2-04 模型上架與發布

## Metadata 表

| Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename |
| --- | --- | --- | --- |
| POV2-04 | platform-operations-docs-overhaul | POV2-01, POV2-03 | `.github/issues/platform-operations-v2-model-card-publishing-workorder.md` |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 問題陳述與分項目標

Model Card 上架牽涉模型供應商封裝、容器規範、發布憑證、callback、審核與平台接收。現有內容分散在 advanced、reference、internal-contracts 與 runbook 中。V2 需以平台維護者視角重寫「模型上架與發布」功能域，並明確區分可操作維護內容與內部工程契約。

## 預期效益

1. 維護者能理解 Model Card 上架從封裝到回報的完整平台流程。
2. 規格文件與上架維護文件可以互相連結但不混為同一類入口。
3. 上架故障排查與驗證證據的待補缺口被明確揭露。

## In Scope

1. `上架總覽`：平台如何看待 Model Card 上架流程與維護檢查點。
2. `容器化規範`：重寫 Model Card 容器化規範的維護者版本。
3. `發布 Callback API`：重寫 callback 契約的維護者查閱頁。
4. `上架施工規格`：重寫工程契約入口與使用情境。
5. `上架故障排查`：從現有 runbook 與上架文件整理常見判讀。
6. `上架驗證證據`：若資料不足，保留待補頁或待補章節。

## Out of Scope

1. 不新增上架 API 或 callback 欄位。
2. 不替模型供應商文件重寫上架全流程；本分項只處理平台維護者文件。
3. 不宣稱 ACR artifact 驗證、正式 callback 或審核流程已上線，除非來源與 QE 證據確認。

## 前置依賴與輸入契約

| 輸入 | 來源 | 要求 |
| --- | --- | --- |
| 上架維護脈絡 | S10 | 作為總覽與維護流程來源。 |
| 容器規格 | S14 | 作為規格來源。 |
| Callback API | S18 | 作為契約來源。 |
| 上架施工規格 | S19 | 作為內部工程契約來源。 |
| 故障排查 | S12 + S10 + S18 | 只能整理來源中已有的故障情境。 |

## SOP1 修正 Handoff

Status: pending-ceo-mapping-review.

本分項下一輪 SOP2 只能依 `00-manifest.md` 的 Formal Page Inventory 施工。正式頁面為：`PV2-P01` `docs/platform-v2/model-publishing/index.md`、`PV2-P02` `docs/platform-v2/model-publishing/containerization-standard.md`、`PV2-P03` `docs/platform-v2/model-publishing/callback-api.md`、`PV2-P04` `docs/platform-v2/model-publishing/implementation-spec.md`、`PV2-P05` `docs/platform-v2/model-publishing/troubleshooting.md`、`PV2-P06` `docs/platform-v2/model-publishing/verification-evidence.md`。

舊 `docs/platform-v2/model-card-publishing.md` 只能作為歷史草稿參考，不得作為正式施工交付物。

## 執行策略與內容規劃

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| Publishing overview | product-strategy-manager | 依 S10 重寫平台維護者上架總覽。 | 模型上架與發布文件 | 上架總覽頁 | 授權 scope 需與 POV2-03 對齊。 | 讀者能理解上架流程與平台責任。 |
| Specs rewrite | senior-software-engineer | 依 S14/S18/S19 重寫規格頁，保留契約查閱定位。 | 模型上架與發布文件 | 容器化、Callback、施工規格頁 | 不修改規格語意。 | 規格頁可追溯來源。 |
| Troubleshooting | senior-software-engineer | 依 S12 + S10 + S18 整理上架卡住與回報失敗判讀。 | 模型上架與發布文件 | 上架故障排查頁 | 缺少實證情境則標待補。 | 常見故障有來源與處理方向。 |
| Verification evidence gap | testing-quality-engineer | 定義上架驗證證據頁是否可寫；不足則保留待補。 | 模型上架與發布文件 | 上架驗證證據頁或待補章節 | QE 需提供可驗證證據契約。 | 未有資料不會被寫成完成流程。 |

## 交付物清單

1. 上架總覽頁。
2. 容器化規範頁。
3. 發布 Callback API 頁。
4. 上架施工規格頁。
5. 上架故障排查頁。
6. 上架驗證證據待補頁或章節。

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-04-CP1 | Publishing journey | 上架總覽描述封裝、提交、回報、審核、平台接收的維護者視角。 | 平台維護者能掌握功能域。 | 依 S10 重寫，不直接搬移。 | QE 檢查是否未混入供應商任務頁語氣。 | `docs/platform-v2/` |
| POV2-04-CP2 | Contract pages | 容器化、Callback、施工規格頁各自有用途與來源。 | 深水區契約可查但不誤導新人。 | 依 S14/S18/S19 重寫。 | 檢查規格語意與來源一致。 | `docs/platform-v2/` |
| POV2-04-CP3 | Evidence gap | 上架驗證證據若無來源，明確標待補。 | 不發明驗證結果。 | 建立待補頁或待補章節。 | QE 檢查是否未宣稱未驗證成功條件。 | `docs/platform-v2/` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-04-CP1 | confirmed | confirmed | blocked | 已依 `PV2-P01` 至 `PV2-P06` 建立 `docs/platform-v2/model-publishing/` 六頁；待 SOP3 驗證。 |
| POV2-04-CP2 | confirmed | confirmed | blocked | 已重寫容器化、Callback、施工規格與排查頁，保留來源規格語意；待 SOP3 驗證。 |
| POV2-04-CP3 | confirmed | confirmed | blocked | 已建立 `verification-evidence.md` 作為待補證據頁，未宣稱已完成上架驗收；待 SOP3 驗證。 |

## CEO 待提供資源

| 項目 | 內容 |
| --- | --- |
| 上架成熟度確認 | 確認 Model Card 上架、callback、artifact 驗證與審核流程哪些已可對外描述為現況。 |

## 風險與待確認事項

1. 上架流程可能包含規劃中契約，需避免寫成已上線操作。
2. 上架驗證證據目前標示為待補，不應在 SOP2 被省略或假設完成。