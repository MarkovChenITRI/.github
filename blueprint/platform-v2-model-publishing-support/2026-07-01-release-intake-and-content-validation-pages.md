# 發布接收與內容查驗頁施工

## 1. 標題

Platform V2 模型上架支援：發布接收與內容查驗頁施工

## 2. Metadata 表

| 欄位 | 值 |
| --- | --- |
| Subitem ID | SUB-03 |
| Parent Initiative | `platform-v2-model-publishing-support` |
| Depends On | SUB-01 |
| Planned Workorder Filename | `.github/issues/2026-07-platform-v2-model-publishing-support-intake-validation-workorder.md` |

## 3. 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| Product Strategy Manager | Senior Software Engineer | Testing Quality Engineer |

## 4. 問題陳述與分項目標

現有文件已經零散提到 callback、發布結果、容器化規範與 labels，但缺少以平台維護者實際工作順序整理的「發布接收」與「內容查驗」兩頁，也缺少平台 How：平台要收哪些輸入、先驗什麼、何時能往下走、何時必須退回修正。

本分項目標是把送件後到送審前的兩個核心頁面寫成可施工、可維護、可回查的任務型文件，並對齊共享規格頁與相鄰供應商頁。

## 5. 預期效益

- 維護者不必先懂 callback / digest / labels 才能上手，而能按頁面順序理解如何接收與查驗。
- 平台在送件後的關鍵處理順序被固定，減少後續維護偏差。
- 共享規格與平台查驗方法的分工被寫清楚。

## 6. In Scope

- 新增或重寫 `docs/platform-v2/model-publishing/release-intake.md`。
- 新增或重寫 `docs/platform-v2/model-publishing/content-validation.md`。
- 對齊共享規格頁與 platform 查驗敘事。
- 微調 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` 的引用方式與內容邊界。

## 7. Out of Scope

- 平台內部資料物件與狀態頁的完整說明。
- 供應商 workflow 教學全文。
- 審核與正式發布判定細節。

## 8. 前置依賴與輸入契約

| 輸入 | 來源 | 說明 |
| --- | --- | --- |
| Page Inventory 與寫作契約 | SUB-01 | 提供標題、類型與來源邊界 |
| 現有 callback / publishing 頁 | 現有 docs | 提供現況敘事來源 |
| route 與 schema 事實 | `utils/routes/model_card_publish_routes.py`、`utils/db.py` | 提供平台可宣稱的處理事實 |
| 共享規格來源 | 現有 containerization / reference 頁 | 提供欄位與限制真相源 |

## 9. 執行策略與內容規劃

### 9.1 方法目標與成功定義

本分項要建立送件後到送審前的兩個核心 task pages：

1. `docs/platform-v2/model-publishing/release-intake.md` 用來定義平台如何接收發布結果。
2. `docs/platform-v2/model-publishing/content-validation.md` 用來定義平台如何查驗容器內容與 metadata。

成功的標準是：維護者可以依頁面順序處理一次完整的收件與查驗，而不是只讀到兩份概念說明。若讀者仍看不出「收件時先看什麼、什麼情況代表已收件、什麼情況必須退回、查驗時要對照哪個真相源」，則本分項未完成。

### 9.2 施工對象與現況判定

本分項的三類施工對象如下：

1. `docs/platform-v2/model-publishing/release-intake.md` 預期目前不存在，屬 `new`。這表示 SOP2 必須建立新頁，不能假設現有 callback 頁已可直接充當維護者 runbook。
2. `docs/platform-v2/model-publishing/content-validation.md` 預期目前不存在，屬 `new`。這表示 SOP2 必須建立一個專門說平台查驗方法的新頁，而不是繼續混在供應商規格頁。
3. `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` 已存在，屬 `rewrite-existing-reference`。這表示其欄位與限制是固定真相源；本輪可更新內容與引用方式，但不得改動 canonical path。

在本分項中，「更新」若用於共享規格頁，只代表調整其定位、連結與命名，不代表把平台查驗步驟抄進去；「新增」若用於 task page，代表要建立新的頁面骨架、H1、步驟與判斷條件，而不是從舊頁複製一小段文字。

### 9.3 步驟順序與依賴關係

1. 先處理 `release-intake.md`，因為內容查驗頁的前進條件，必須以前一頁對「什麼叫做成功收件」的定義為基礎。
2. 在 `release-intake.md` 中，先整理平台接收的輸入集合，包括發布結果回報、發布授權、映像摘要與其他平台必看欄位，再把它們排成實際處理順序。
3. 只有在收件頁先定義了「收到什麼才算存在」「缺什麼代表不存在或不完整」之後，才建立 `content-validation.md` 去描述如何核對內容。
4. `content-validation.md` 完成初稿後，再回頭對齊 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`，確認哪些欄位保留在 reference 頁、哪些操作保留在 platform task page。

若第 1 步沒有把收件完成與收件失敗的條件寫清楚，第 3 步不得開始，因為內容查驗頁會失去進入條件。

### 9.4 變更面與內容語意

對 `docs/platform-v2/model-publishing/release-intake.md` 的建立必須至少寫清楚：

1. 平台在收件時要看哪些輸入，各輸入缺失時代表什麼狀態。
2. 哪些資訊存在就代表案件可進下一階段，哪些不存在就必須暫停或退回。
3. 平台應依什麼順序檢查，例如先確認案件身分，再確認發布結果，再確認映像摘要與授權材料。
4. 常見收件失敗情境的處理方式，至少要寫出現象、代表原因與下一步。

對 `docs/platform-v2/model-publishing/content-validation.md` 的建立必須至少寫清楚：

1. 平台查驗的對象是什麼，包括映像本體、digest、metadata、描述標記或其他必要欄位。
2. 什麼叫做內容存在，例如該欄位在共享規格中有定義且能於本次案件取得；什麼叫做內容不存在，例如缺欄位、欄位值不可判讀、或無法與規格對照。
3. 哪些差異屬於可修正偏差、哪些差異代表必須退回重送。
4. 查驗通過後平台要留下哪些記錄，讓後續資料狀態頁能接手。

對共享規格頁的更新只應做兩件事：

1. 維持它作為欄位與限制定義的真相源。
2. 把平台 task page 連回來，但不承接平台的步驟說明。

### 9.5 決策點、分支與阻擋條件

1. 若收件頁需要引用的 route 或 callback 能力在 repo 中仍屬契約而非落地事實，頁面只能如實寫成平台目前依此契約判讀，不可宣稱 production 已完整實作。
2. 若共享規格頁與現有供應商頁對同一欄位給出不同語意，必須先解決 reference 真相源衝突，否則內容查驗頁不得定稿。
3. 若收件頁無法定義最小必備輸入集合，就不得向後宣稱內容查驗可開始，因為案件是否「存在」都尚未成立。
4. 若內容查驗頁必須介紹大量供應商打包細節才能成立，代表 reference / provider 分工仍錯位，需回到分工設計，不應在本頁硬塞。

### 9.6 證據、完成訊號與回寫位置

完成證據應包含：

1. `release-intake.md` 已能回答平台收到什麼、缺什麼、何時前進。
2. `content-validation.md` 已能回答平台查什麼、如何對照、何時退回。
3. 共享規格頁與 platform task page 的責任邊界已透過連結與文字明確區分。

完成訊號是：維護者照著頁面順序操作，能把案件從「已送件但未確認」帶到「可進入後續資料與狀態管理」；證據回寫位置是這兩個新頁、相關 reference 頁，以及本分項查核點欄位。

## 10. 交付物清單

- `docs/platform-v2/model-publishing/release-intake.md`
- `docs/platform-v2/model-publishing/content-validation.md`
- 共享規格頁的引用對齊調整

## 11. 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| CP-01 | 發布接收頁完成 | 頁面含輸入、處理順序、前進條件與常見失敗情境 | 維護者可正確處理送件後第一站 | 依 Workstream「發布接收頁施工」施工 | 結構檢查與來源對照 | `release-intake.md` |
| CP-02 | 內容查驗頁完成 | 頁面含查驗項目、查驗方法、退回判準與紀錄要求 | 維護者可正確完成查驗 | 依 Workstream「內容查驗頁施工」施工 | 結構檢查與來源對照 | `content-validation.md` |
| CP-03 | 共享規格分工清楚 | 平台頁不再充當欄位字典，reference 頁不再充當平台 runbook | 讀者能理解 reference 與 task page 分工 | 依 Workstream「共享規格連接對齊」施工 | 冷讀與連結檢查 | 相關頁面 diff |

## 12. 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| CP-01 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已完成 `docs/platform-v2/model-publishing/release-intake.md`，收件輸入、順序、前進條件與失敗情境皆已落檔 |
| CP-02 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已完成 `docs/platform-v2/model-publishing/content-validation.md`，含查驗項目、退回判準與紀錄要求 |
| CP-03 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已把共享規格頁與平台 task page 分流，reference 頁回鏈至 `content-validation.md` |

## 13. CEO 待提供資源

無。

## 14. 風險與待確認事項

- 若 route / tests 顯示某些 callback 能力仍屬契約而非正式落地，頁面必須用可宣稱 / 待確認邊界處理，不可過度承諾。
- 已依本原則施工：`release-intake.md` 僅宣稱 repo 現有 callback 契約、測試與平台判讀邏輯，不把 production endpoint 行為寫成既成事實。
