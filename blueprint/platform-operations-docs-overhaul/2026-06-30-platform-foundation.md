# POV2-02 平台基礎

## Metadata 表

| Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename |
| --- | --- | --- | --- |
| POV2-02 | platform-operations-docs-overhaul | POV2-01 | `.github/issues/platform-operations-v2-platform-foundation-workorder.md` |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 問題陳述與分項目標

平台維護者需要先建立平台心智模型：平台是什麼、哪些服務組成、資料與交付邊界在哪裡。現有資料分散在平台入口、專案架構、UX/UI、資料庫與 CI/CD 頁，V2 需重新撰寫成一組「平台基礎」文件，而不是照舊頁順序搬移。

## 預期效益

1. 維護者可快速理解平台功能、服務責任、頁面任務與資料真相源。
2. 系統事實與規劃中契約可被清楚分開。
3. 後續模型授權、上架、資源資料、部署文件可共用同一平台背景。

## In Scope

1. `平台維運入口`：重寫 V2 平台基礎入口。
2. `系統與服務架構`：重寫 App Service、SQL、Key Vault、GitHub Actions、Flask 模組責任。
3. `介面與任務流程`：重寫前台、工作台、管理頁如何支撐平台維運判斷。
4. `資料與正式真相源`：重寫正式資料、規劃契約、資料責任邊界。
5. `平台交付鏈概觀`：重寫測試、部署、文件發布與環境驗證的概念層。

## Out of Scope

1. 不重寫詳細操作步驟；操作放入平台資源與資料、平台交付與部署分項。
2. 不新增架構契約或 route / schema 細節。
3. 不把現有文件中未落地的 workflow 或 script 寫成已存在。

## 前置依賴與輸入契約

| 輸入 | 來源 | 要求 |
| --- | --- | --- |
| 平台入口現況 | S1 | 只抽取讀者路徑與維運區定位。 |
| 架構事實 | S2 | 需由 RD 在 SOP2 對照 repo 實體確認。 |
| UI / 任務流程 | S3 | 需轉成維護者判斷功能落點的語言。 |
| 資料真相源 | S4 | 必須保留已部署 / 規劃中契約區分。 |
| 交付鏈概念 | S5 + S6 | 有事實落差時標待確認。 |

## SOP1 修正 Handoff

Status: pending-ceo-mapping-review.

本分項下一輪 SOP2 只能依 `00-manifest.md` 的 Formal Page Inventory 施工。正式頁面為：`PV2-F01` `docs/platform-v2/foundation/index.md`、`PV2-F02` `docs/platform-v2/foundation/system-service-architecture.md`、`PV2-F03` `docs/platform-v2/foundation/interface-task-flows.md`、`PV2-F04` `docs/platform-v2/foundation/data-source-of-truth.md`、`PV2-F05` `docs/platform-v2/foundation/delivery-chain-overview.md`。

舊 `index.md`、`operating-map.md`、`azure-environment-and-cicd.md`、`database-and-migration.md` 的分散承接方式已失效，只能作為歷史草稿或來源參考。

## 執行策略與內容規劃

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| Foundation entry | product-strategy-manager | 將 S1 重寫為 V2 平台基礎入口，先說讀者要完成什麼。 | `docs/platform-v2/platform-foundation/index.md` 或等效頁 | 平台基礎入口頁 | V2 導覽需先凍結。 | 入口能導向四個基礎主題。 |
| Service map | senior-software-engineer | 依 S2 重寫服務責任與 repo 對應，移除對未確認檔案的現況宣稱。 | 平台基礎文件 | 系統與服務架構頁 | RD 需對照 repo 實體。 | 服務邊界可追溯到來源與 repo。 |
| UI task flow | senior-software-engineer | 依 S3 重寫成維護者可用的頁面與任務流程地圖。 | 平台基礎文件 | 介面與任務流程頁 | UI facts 需由 RD / UI owner 確認。 | 每個頁面功能能對應維運判斷目的。 |
| Data truth | senior-software-engineer | 依 S4 重寫資料責任、已部署表與規劃契約。 | 平台基礎文件 | 資料與正式真相源頁 | Schema facts 需保持來源區分。 | 文件不混淆已部署與規劃中資料。 |
| Delivery overview | senior-software-engineer | 依 S5 + S6 重寫交付鏈概念，將未確認 workflow 標待確認。 | 平台基礎文件 | 平台交付鏈概觀頁 | CI/CD 實體落差需揭露。 | 文件不宣稱不存在檔案為現況。 |

## 交付物清單

1. 平台維運入口重寫頁。
2. 系統與服務架構重寫頁。
3. 介面與任務流程重寫頁。
4. 資料與正式真相源重寫頁。
5. 平台交付鏈概觀重寫頁。

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-02-CP1 | Foundation scope | 五個平台基礎頁都有讀者任務、來源與不在範圍。 | 平台背景可被下游功能域共用。 | 依 S1-S6 重寫而非複製。 | QE 檢查各頁來源與任務描述。 | `docs/platform-v2/` |
| POV2-02-CP2 | Fact boundary | 已部署、規劃中、待確認三類事實有明確標記。 | 降低維護者誤判。 | 逐頁建立事實狀態段落。 | 抽查 CI/CD 與 DB 相關敘述。 | `docs/platform-v2/` |
| POV2-02-CP3 | Developer docs tone | 文件不用內部交接語，改用讀者任務語言。 | 符合開發者網站閱讀習慣。 | 套用 user-facing docs instruction。 | 審查標題與步驟是否可掃描。 | `docs/platform-v2/` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-02-CP1 | confirmed | confirmed | blocked | 已依 `PV2-F01` 至 `PV2-F05` 建立 `docs/platform-v2/foundation/` 五頁；待 SOP3 驗證。 |
| POV2-02-CP2 | confirmed | confirmed | blocked | 已在 foundation 頁區分服務責任、UI 流程、資料真相源與交付鏈邊界；待 SOP3 驗證來源一致性。 |
| POV2-02-CP3 | confirmed | confirmed | blocked | 已以使用者文件語氣重寫 foundation 頁，保留任務型 / 概念型結構；待 SOP3 驗證可讀性。 |

## CEO 待提供資源

| 項目 | 內容 |
| --- | --- |
| 現況確認 | 確認現有 CI/CD、Pages 與 Azure 部署狀態是否可對外寫為現況。 |

## 風險與待確認事項

1. S5 / S6 內提及的 workflow 與 scripts 可能與 repo 實體不一致，需在 SOP2 由 RD / QE 對照。
2. 若資料庫現況未由正式環境確認，資料頁只能以來源文件與 repo schema 說明，不宣稱 production 已具備。 