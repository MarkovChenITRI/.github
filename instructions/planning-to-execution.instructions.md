---
description: "Use when a blueprint task is in the 規劃 → 執行 stage. Define the input contract, standard output package, and signoff rules for turning a frozen blueprint into concrete work orders."
applyTo: ".github/blueprint/02-*.md,.github/blueprint/03-*.md,.github/blueprint/04-*.md"
---

# Blueprint SOP2：規劃到執行

SOP2 只處理把已凍結的 blueprint 變成可施工執行面，不再重新定義需求。此階段仍以 blueprint 內各負責人的查核點、checked 填報與施工簽核為主，不在此階段另開 issue 工單取代 blueprint。

## 標準輸入

| 項目 | 內容 |
|------|------|
| 已簽核 blueprint | SOP1 完成且必要查核點已定義 |
| 施工相依關係 | 哪些查核點必須先成立，哪些項目可平行進行 |
| 驗證規則 | 每項施工如何被證明完成 |
| 變更邊界 | 哪些文件、設定、程式可以動 |

## Blueprint 執行填報規則

1. SOP2 啟動後，各負責人仍需直接在對應 blueprint 環節內完成查核點的 checked 填報、施工簽核與偏差揭露。
2. blueprint 在 SOP2 仍是執行對齊面：用來確認哪個查核點完成、誰簽署、哪些前提仍成立。
3. 只有進入 SOP3、需要統一驗收、blocker、closure state 與重新派工時，才轉入 `.github/issues/*.md` 的 work order issue。
4. CEO 在 SOP2 不介入施工細節，只在有人回報 blueprint 前提失效、需外部資源或需重新裁決範圍時出場。

## 標準產出

| 項目 | 內容 |
|------|------|
| 施工完成物 | 程式、文件、設定、流程的實際變更 |
| 施工簽核 | blueprint 內每個查核點對應的施工簽名 |
| 殘餘風險 | 尚未消失但已明確揭露的風險 |
| 偏差回寫 | blueprint 內的 checked 狀態、owner 簽核、偏差說明同步更新；若前提被推翻，再回上游重開規劃 |

## 完成判定

1. 每個查核點都能對應到具體檔案或程式變更。
2. 每個完成項都有施工簽署。
3. 若有偏差，必須先回寫對應 blueprint 的查核欄位與偏差說明；只有進入驗收阻塞、closure state 管理或重新派工時，才在 SOP3 開 issue 工單。
4. 若 CEO 尚未提供真人受測管道、正式環境核准或其他人類輸入，必須在 blueprint 中明示為待決條件，不得假裝施工已可直接完成關單。