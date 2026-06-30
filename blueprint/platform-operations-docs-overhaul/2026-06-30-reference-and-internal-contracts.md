# POV2-07 規格與內部契約

## Metadata 表

| Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename |
| --- | --- | --- | --- |
| POV2-07 | platform-operations-docs-overhaul | POV2-01, POV2-03, POV2-04 | `.github/issues/platform-operations-v2-reference-contracts-workorder.md` |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 問題陳述與分項目標

平台維運 V2 需要保留規格 Reference 與平台內部契約，但不能讓它們成為新人第一入口。此分項要規劃一個查閱型區域，集中放容器化、授權 token、發布憑證、Callback API 與 Model Card 上架施工規格，並說明何時該查規格、何時該回到功能域文件。

## 預期效益

1. 規格頁與任務頁分工清楚。
2. 維護者能快速找到深水區契約，但不會把工程契約誤當一般操作指南。
3. V2 可保留現有 reference / internal-contracts 的價值，同時改善導覽語境。

## In Scope

1. `規格 Reference 入口`：重寫規格區入口。
2. `平台內部契約入口`：重寫內部契約區入口。
3. `Model Card 容器化規範`：依 S14 重寫查閱頁。
4. `授權 Token 流程`：依 S15 重寫查閱頁。
5. `發布憑證規範`：依 S16 重寫查閱頁。
6. `發布 Callback API`：依 S18 重寫查閱頁。
7. `Model Card 上架施工規格`：依 S19 重寫查閱頁。

## Out of Scope

1. 不變更規格內容、API shape 或 schema。
2. 不把 reference 頁寫成 step-by-step 操作指南。
3. 不引入新規格或新契約。

## 前置依賴與輸入契約

| 輸入 | 來源 | 要求 |
| --- | --- | --- |
| Reference 入口 | S13 | 轉成 V2 查閱定位。 |
| Internal contracts 入口 | S17 | 說明深度維護情境。 |
| 容器化規範 | S14 | 保持規格語意。 |
| 授權 token | S15 | 保持規格語意。 |
| 發布憑證 | S16 | 保持規格語意。 |
| Callback API | S18 | 保持契約語意。 |
| 上架施工規格 | S19 | 保持工程契約語意。 |

## SOP1 修正 Handoff

Status: pending-ceo-mapping-review.

本分項下一輪 SOP2 只能依 `00-manifest.md` 的 Formal Page Inventory 施工。正式頁面為：`PV2-C01` `docs/platform-v2/reference-contracts/index.md`、`PV2-C02` `docs/platform-v2/reference-contracts/internal-contracts-index.md`、`PV2-C03` `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`、`PV2-C04` `docs/platform-v2/reference-contracts/model-license-token-standard.md`、`PV2-C05` `docs/platform-v2/reference-contracts/model-card-publish-grant-standard.md`、`PV2-C06` `docs/platform-v2/reference-contracts/model-card-publish-callback-api.md`、`PV2-C07` `docs/platform-v2/reference-contracts/model-card-publishing-implementation.md`。

舊 functional-domain 導讀頁不能取代規格與內部契約區的正式查閱頁；下一輪需重建完整 reference-contracts 巢狀導覽。

## 執行策略與內容規劃

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| Reference entry | product-strategy-manager | 依 S13/S17 重寫入口，說明查閱情境與不作為第一入口。 | 規格與內部契約文件 | Reference / internal contract 入口頁 | V2 導覽需先凍結。 | 入口能導回功能域文件。 |
| Spec pages | senior-software-engineer | 依 S14-S16 重寫規格查閱頁。 | 規格與內部契約文件 | 容器化、token、publish grant 頁 | 不改規格語意。 | 規格可追溯來源。 |
| Contract pages | senior-software-engineer | 依 S18-S19 重寫 API / 施工契約查閱頁。 | 規格與內部契約文件 | Callback、上架施工規格頁 | 不改契約語意。 | 深度維護情境清楚。 |

## 交付物清單

1. 規格 Reference 入口頁。
2. 平台內部契約入口頁。
3. Model Card 容器化規範頁。
4. 授權 Token 流程頁。
5. 發布憑證規範頁。
6. 發布 Callback API 頁。
7. Model Card 上架施工規格頁。

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-07-CP1 | Reference positioning | 入口說明何時查規格、何時回功能域頁。 | 避免讀者迷失於深水區。 | 依 S13/S17 重寫。 | QE 檢查入口是否可掃描。 | `docs/platform-v2/` |
| POV2-07-CP2 | Spec fidelity | S14-S16 的規格語意未被改寫。 | 保持契約一致性。 | 重寫文字但保留欄位與規則語意。 | 抽查關鍵欄位與來源一致。 | `docs/platform-v2/` |
| POV2-07-CP3 | Contract fidelity | S18-S19 的 API / 工程契約語意未被改寫。 | 避免文件破壞工程契約。 | 重寫導讀與使用情境，不改契約內容。 | RD / QE 對照來源文件。 | `docs/platform-v2/` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-07-CP1 | confirmed | confirmed | blocked | 已建立 `PV2-C01`、`PV2-C02`，將 reference 與 internal contracts 定位為查閱區；待 SOP3 驗證。 |
| POV2-07-CP2 | confirmed | confirmed | blocked | 已建立 `PV2-C03` 至 `PV2-C05`，保留容器、授權 token、發布憑證規格語意；待 SOP3 驗證。 |
| POV2-07-CP3 | confirmed | confirmed | blocked | 已建立 `PV2-C06`、`PV2-C07`，保留 Callback API 與上架施工規格契約邊界；待 SOP3 驗證。 |

## CEO 待提供資源

| 項目 | 內容 |
| --- | --- |
| 契約發布邊界 | 確認哪些內部契約可出現在公開 GitHub Pages，哪些需保留內部文件。 |

## 風險與待確認事項

1. 內部契約若包含尚未實作或敏感操作，V2 需標示讀者與可用情境。
2. Reference 頁若被過度簡化，可能損失規格精確性；SOP2 需由 RD / QE 對照來源。