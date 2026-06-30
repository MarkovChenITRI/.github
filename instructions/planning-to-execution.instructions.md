---
description: "Use when a blueprint task is in the 規劃 → 執行 stage. Define the input contract, standard output package, and signoff rules for turning a frozen blueprint into concrete work orders."
applyTo: ".github/blueprint/02-*.md,.github/blueprint/03-*.md,.github/blueprint/04-*.md,blueprint/**/*.md"
---

# Blueprint SOP2：規劃到執行

SOP2 只處理把已凍結的 blueprint 變成可施工執行面，不再重新定義需求。此階段仍以 blueprint 內各負責人的查核點、checked 填報與施工簽核為主，不在此階段另開 issue 工單取代 blueprint。

## 標準輸入

| 項目 | 內容 |
|------|------|
| 已簽核 blueprint | SOP1 完成且必要查核點已定義 |
| `00-manifest.md` | 已凍結的 initiative 級索引、分項依賴與規劃凍結線 |
| 分項規劃檔 | 對應分項的 `yyyy-mm-dd-<subitem-english-name>.md` |
| 施工相依關係 | 哪些查核點必須先成立，哪些項目可平行進行 |
| 驗證規則 | 每項施工如何被證明完成 |
| 變更邊界 | 哪些文件、設定、程式可以動 |

## Blueprint 執行填報規則

1. SOP2 啟動後，各負責人仍需直接在對應 blueprint 環節內完成查核點的執行、`查核點簽核表` 回填與偏差揭露。
2. blueprint 在 SOP2 仍是執行對齊面：用來確認哪個查核點已施工、哪個角色已簽核、哪些前提仍成立。
3. 只有進入 SOP3、需要統一驗收、blocker、closure state 與重新派工時，才轉入 `.github/issues/*.md` 的 work order issue。
4. CEO 在 SOP2 不介入施工細節，只在有人回報 blueprint 前提失效、需外部資源或需重新裁決範圍時出場。

## Blueprint 分項檔與施工對應規則

1. 每個分項規劃檔都是施工前的規劃真相源，不是施工進度板。
2. RD / QE 在 SOP2 必須直接回到對應 blueprint 分項檔的 `查核點定義表` 與 `查核點簽核表` 完成填報，不得另外發明第二套 checklist。
3. 若需先預告未來會進入 SOP3 的 issue 工單，應只在分項 Metadata 的 `Planned Workorder Filename` 欄位記錄預定檔名，不得提前把 issue 當成 SOP2 狀態板。
4. 同一個分項預設對應一份 work order issue；若未來確實需要拆多份 issue，必須先在 manifest 中明示，否則視為規劃偏差。

## 標準產出

| 項目 | 內容 |
|------|------|
| 施工完成物 | 程式、文件、設定、流程的實際變更 |
| 施工確認 | blueprint 內 `查核點簽核表` 的角色簽核回填結果 |
| 殘餘風險 | 尚未消失但已明確揭露的風險 |
| 偏差回寫 | blueprint 內的 `查核點簽核表`、偏差說明與必要註記同步更新；若前提被推翻，再回上游重開規劃 |

## 完成判定

1. 每個查核點都能對應到具體檔案或程式變更。
2. 每個完成項都有對應角色的簽核回填。
3. 若有偏差，必須先回寫對應 blueprint 的 `查核點簽核表` 與偏差說明；只有進入驗收阻塞、closure state 管理或重新派工時，才在 SOP3 開 issue 工單。
4. 若 CEO 尚未提供真人受測管道、正式環境核准或其他人類輸入，必須在 blueprint 中明示為待決條件，不得假裝施工已可直接完成關單。
5. 若分項檔缺少固定欄位、檔名不符合 `yyyy-mm-dd-<subitem-english-name>.md`，或 `00-manifest.md` 無法回索引該分項，視為 SOP2 前置條件不足。