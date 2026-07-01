# 準備支援頁施工

## 1. 標題

Platform V2 模型上架支援：準備支援頁施工

## 2. Metadata 表

| 欄位 | 值 |
| --- | --- |
| Subitem ID | SUB-02 |
| Parent Initiative | `platform-v2-model-publishing-support` |
| Depends On | SUB-01 |
| Planned Workorder Filename | `.github/issues/2026-07-platform-v2-model-publishing-support-preparation-pages-workorder.md` |

## 3. 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| Product Strategy Manager | Senior Software Engineer | Testing Quality Engineer |

## 4. 問題陳述與分項目標

現有 Platform V2 的入口頁與上架相關頁面沒有把平台在供應商送件前需要提供的資料、工具與範本系統化寫出來，導致整條支援鏈從「供應商已送件」才開始。這不符合 CEO 要求，也會讓後續維護者缺少對上游準備支援的理解。

本分項要完成兩件事：

1. 把現有入口頁改寫成真正的「模型上架支援」總入口。
2. 新建或改造「上架準備」頁，實際寫出平台如何交付 `model_card.yaml`、Python 憑證解密庫、範例程式與 ACR GitHub Actions / CI 範本庫。

## 5. 預期效益

- 平台維護者能從入口頁立即理解這條流程從哪裡開始。
- 供應商送件前所需平台資源有清楚的支援文件，不再只存在相鄰頁或隱性知識中。
- 後續排障時，能先分辨是準備支援沒備妥，還是送件後才發生問題。

## 6. In Scope

- 重寫 `docs/platform-v2/model-publishing/index.md`。
- 新增或重寫 `docs/platform-v2/model-publishing/preparation.md`。
- 對齊入口頁與 `docs/model-provider/index.md` 的交叉導覽。
- 凍結頁面章節順序與每節 How。

## 7. Out of Scope

- 發布接收、內容查驗、資料狀態與發布判定的詳細頁內容。
- model-provider 供應商操作細節全文改寫。
- 實際建立新的程式庫或 workflow template 本體。

## 8. 前置依賴與輸入契約

| 輸入 | 來源 | 說明 |
| --- | --- | --- |
| Page Inventory 與寫作契約 | SUB-01 | 本分項必須依凍結頁序與標題施工 |
| 既有 Platform V2 入口頁 | `docs/platform-v2/model-publishing/index.md` | 現行入口基礎 |
| 既有 model-provider 前置頁 | `docs/model-provider/index.md`、`packaging-data.md`、`template-repo.md` 等 | 支援前置資源來源 |
| 樣板與工具事實 | `model-card-package-template/`、repo 既有文件 | 寫定平台可宣稱的準備資源 |

## 9. 執行策略與內容規劃

### 9.1 方法目標與成功定義

本分項要把「平台如何在供應商送件前完成準備支援」實際落成兩個頁面成果：

1. 一個沿用既有路徑但整頁改寫的入口頁：`docs/platform-v2/model-publishing/index.md`。
2. 一個目前預期不存在、需要新建的準備頁：`docs/platform-v2/model-publishing/preparation.md`。

成功不是只有把這兩個檔名列出來，而是要讓維護者看完後能明確知道平台先準備什麼、怎麼交付給供應商、何時算準備完成。若讀者仍只能看懂「這區大概在講模型上架」，而不知道平台先做哪些前置工作，則本分項失敗。

### 9.2 施工對象與現況判定

本分項先固定三類施工對象與其操作語意：

1. `docs/platform-v2/model-publishing/index.md` 已存在，操作語意是 `rewrite`。這代表保留原檔路徑，但重寫 H1、章節骨架、導覽作用與頁面主敘事，不是只補一段前言。
2. `docs/platform-v2/model-publishing/preparation.md` 預期目前不存在，操作語意是 `new`。這代表要在該精確路徑建立新檔，並在後續導覽中讓它成為可到達節點。
3. `docs/model-provider/index.md` 與其他供應商前置頁已存在，操作語意是 `revise-adjacent`。這代表保留其供應商任務定位，只補或改交叉導覽，不讓它承接平台維護者主敘事。

在這裡，「存在」不只是檔案存在於 repo，而是它已被本輪 blueprint 承認為可沿用的真相源；「新增」不只是建立空檔，而是建立具有固定 H1、章節與讀者任務的新頁；「更新」不只是改字，而是明確替換頁面骨架與頁面責任。

### 9.3 步驟順序與依賴關係

施工順序必須是：

1. 先依 SUB-01 凍結的 Page Inventory，確認入口頁屬 `rewrite`、準備頁屬 `new`、相鄰供應商頁屬 `revise-adjacent`。若這三種語意未先確定，後續所有變更都不得開始。
2. 先改寫入口頁，再建立準備頁。原因是入口頁要先定義整條支援鏈的閱讀順序，準備頁才知道自己在流程中的位置。
3. 入口頁改寫完成後，才把其中的「上架準備」節點導向新頁路徑；在新頁尚未存在前，不得把導覽切成最終版本。
4. 準備頁內容固定後，最後才更新相鄰 model-provider 頁的交叉導覽，避免在主頁尚未穩定時先讓供應商頁指向不存在或會變動的目標。

### 9.4 變更面與內容語意

對 `docs/platform-v2/model-publishing/index.md` 的改寫必須至少包含以下具體變更：

1. 把 H1 更新為「模型上架支援」。
2. 把現有偏向「供應商送件後」的敘事改成完整流程總覽，明確補入平台在送件前提供上架資源的階段。
3. 把章節骨架改成任務型文件可掃描結構，至少能回答這份頁面會幫維護者完成什麼、流程從哪開始、每段應去哪一頁。
4. 把入口頁定位成七頁主流程的導航頁，而不是單一概念說明頁。

對 `docs/platform-v2/model-publishing/preparation.md` 的新增必須至少包含以下內容：

1. 明寫平台要提供哪些前置資源，例如 `model_card.yaml` 生成方式、Python 憑證解密庫、範例程式、GitHub Actions / CI 範本來源。
2. 對每一項資源寫出平台如何交付、維護者從哪裡取得、交付完成後供應商能拿它做什麼。
3. 對每一項資源標示可宣稱與待確認邊界，避免把尚未固定下載點或模板來源寫成既成事實。
4. 在頁末寫出準備完成的檢查條件，例如：模板來源已可回查、命名規則已一致、供應商可取得對應材料。

對相鄰頁的更新只限於：

1. 補上正向交叉導覽。
2. 避免相鄰頁繼續承接平台維護者主流程。
3. 不重寫供應商自己的操作教學全文。

### 9.5 決策點、分支與阻擋條件

1. 若 `preparation.md` 在 repo 中其實已存在舊版內容，SOP2 不得自行決定沿用、另開新路徑或改 slug；必須先標記為 `blocked` 並回到 SOP1 更新 manifest 路徑契約，未更新前不得直接覆寫。
2. 若某項前置資源沒有單一可回查來源，例如 ACR GitHub Actions / CI 範本庫沒有固定路徑，頁面只能寫成目前來源或待收斂狀態，不得虛構精確入口。
3. 若入口頁與準備頁對「平台先做什麼」出現互相矛盾的敘事，必須先回到入口頁統一流程，再繼續改相鄰導覽。
4. 若相鄰 model-provider 頁需要大幅改寫才能不混線，這超出本分項範圍，應標記為後續分項或額外 blueprint，而不是在此偷偷擴張。

### 9.6 證據、完成訊號與回寫位置

本分項的證據應包含：

1. 入口頁存在於原路徑，但已完成整頁骨架更新。
2. 準備頁存在於新路徑，且其章節足以支撐平台前置支援敘事。
3. 相鄰導覽已能把平台維護者導到本區、把供應商導回供應商入口。

完成訊號是：維護者從入口頁開始，能清楚找到準備頁，並知道平台在供應商送件前需要備妥哪些支援；證據回寫位置是這兩個頁面本身、相鄰導覽更新處，以及本分項的查核點證據欄位。

## 10. 交付物清單

- 改寫後的 `docs/platform-v2/model-publishing/index.md`。
- 新增或重寫後的 `docs/platform-v2/model-publishing/preparation.md`。
- 入口頁與準備頁中的相鄰導覽文字。

## 11. 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| CP-01 | 入口頁改寫完成 | 入口頁已改為「模型上架支援」且章節順序符合 blueprint | 維護者能先建立全貌 | 依 Workstream「入口頁重寫」施工 | 章節結構與標題檢查 | `docs/platform-v2/model-publishing/index.md` |
| CP-02 | 上架準備頁完成 | 上架準備頁已明確寫出平台提供的資料、工具、模板與交付方式 | 上游準備支援可被維護 | 依 Workstream「上架準備頁施工」施工 | 逐節檢查 What / How / 完成條件 | `docs/platform-v2/model-publishing/preparation.md` |
| CP-03 | 相鄰導覽對齊 | 平台頁與 model-provider 頁分工清楚、連結正確 | 降低讀者迷路與 audience 混線 | 依 Workstream「相鄰導覽對齊」施工 | 冷讀導覽測試 | 相關頁面 diff |

## 12. 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| CP-01 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已完成 `docs/platform-v2/model-publishing/index.md` 改寫，H1 與七頁主流程導航符合 blueprint |
| CP-02 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已新增 `docs/platform-v2/model-publishing/preparation.md`，並以 repo 事實界定來源與待確認邊界 |
| CP-03 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已更新 `docs/model-provider/index.md` 導向平台支援入口，且保留供應商主流程定位 |

## 13. CEO 待提供資源

無。

## 14. 風險與待確認事項

- 若現有 repo 沒有單一明確位置承載 ACR GitHub Actions / CI 範本庫，頁面需誠實寫成目前範本來源或待收斂狀態，不可編造固定下載點。
- 已依本原則施工：目前頁面僅宣稱 `model-card-package-template/` 與既有供應商文件可回查的範本來源，未虛構第二套正式下載入口。
