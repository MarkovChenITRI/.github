# Platform V2 模型上架支援文件 4W1H 閱讀缺口與重寫規劃

## Issue Classification

- 類型：docs / cold-start reading gap / information architecture
- 分類角色：field-application-engineer
- 影響範圍：Platform V2 模型上架支援主入口與其下六頁

## Reproduction Status

- 狀態：reproduced
- 重現方式：以「第一次接手平台維護者」冷讀七頁文件，檢查是否能回答 who / what / where / how / when。
- 結論：可理解抽象治理規則，但無法直接轉成平台維護操作，存在系統性 4W1H 缺口。

## Scope

- `docs/platform-v2/model-publishing/index.md`
- `docs/platform-v2/model-publishing/preparation.md`
- `docs/platform-v2/model-publishing/release-intake.md`
- `docs/platform-v2/model-publishing/content-validation.md`
- `docs/platform-v2/model-publishing/data-and-state.md`
- `docs/platform-v2/model-publishing/issue-handling.md`
- `docs/platform-v2/model-publishing/release-decision.md`

## Problem Statement

目前七頁文件偏向「平台治理規則摘要」，不是「第一次接手平台維護者的操作說明」。文件大量描述平台應確認什麼、應補齊什麼、可回查什麼，但沒有持續明寫：

1. 誰執行這一步。
2. 在平台哪個後台或哪個操作位置執行。
3. 什麼時候進入這一步。
4. 具體怎麼做。
5. 做完之後應看到什麼結果。

結果是不同讀者會自行腦補網站後台位置、權限角色、證據來源與決策節點，造成閱讀理解空窗與流程歧義。

最新 FAE 雙角色沙盤演練又證明另一個更早出現的結構性問題：供應商入口把流程寫成可直接自助前進，平台入口卻把下一步定義成必須先由平台維護者完成 Publish Grant、repository path、callback URL 與正式模板來源的 handoff。這個 handoff 在供應商入口沒有被可靠建立，因此會在最早的 Step 1 → Step 2 交接點中止流程。

## Latest FAE Walkthrough Verdict

- 類型：docs / handoff contract failure / dual-reader walkthrough blocker
- 角色：field-application-engineer
- 演練方式：分別以「模型供應商」與「平台維護者」冷讀目前文件，依文件順序照表操課
- 結論：`no-go`
- 中止點：供應商完成 `取得上架資料` 後，文件直接要求前往模板專案；平台文件卻要求供應商進入模板與 GitHub 設定前，平台必須先交付 Publish Grant、repository path、callback URL 與正式模板來源

## Latest FAE Walkthrough Summary

### 模型供應商視角

1. 供應商入口把流程寫成線性自助路徑：先在網站建立草稿、下載 `model_card.yaml`，再前往模板專案。
2. 同一入口又說目前路徑已包含發布憑證、GitHub Actions workflow 與 callback 狀態回報，因此供應商會合理期待後續所需的發布憑證會在自己的文件路徑中自然取得。
3. `取得上架資料` 頁在下載 `model_card.yaml` 後直接把供應商送往下一步，沒有停等點，也沒有明確寫出必須先收到平台交付的 Publish Grant、repository path、callback URL 與模板來源。
4. 供應商因此無法判斷自己現在該直接 clone 模板繼續，還是該先等待平台維護者完成交接。

### 平台維護者視角

1. 平台入口把自己的第一段工作定義為：模型供應商填完草稿後，平台再生成 `model_card.yaml`、準備 Publish Grant、固定模板來源。
2. 平台準備頁明確要求平台在供應商開始填 GitHub 設定前，先交付 Variables / Secrets、repository 設定與 callback URL。
3. 平台準備頁也要求平台固定單一模板來源，再讓供應商 clone 模板到自己的專案。
4. 這表示平台文件依賴一個正式 handoff gate；但供應商文件沒有定義這個交接點，雙方即使都照文件走，也不能保證在同一時點完成同一筆交接。

## First Severe Blocker

第一個足以中止流程的 blocker 是：供應商 Step 1 完成後，文件把下一步寫成可直接進 Step 2；平台文件卻把 Step 2 前的必要前提寫成維護者必須先完成 Publish Grant handoff。

這個 blocker 一出現，就不應再假設後續 `發布接收`、`內容查驗`、`發布判定` 具有可操作性，因為下游一開始就把 `publish_grant_id`、repository path、callback URL 與 workflow 設定當成最小必要輸入，但上游沒有先建立這些輸入的取得方式與交接責任。

## Conflicting Statements

1. `docs/model-provider/index.md`
   目前把供應商路徑寫成：先建立模型卡草稿並下載設定檔，再自訂模型專案，形成「下載後可直接往下走」的線性預期。

2. `docs/model-provider/packaging-data.md`
   目前在 Step 1 結尾直接把供應商送往 Step 2，沒有建立任何平台 handoff gate。

3. `docs/platform-v2/model-publishing/index.md`
   目前把平台準備寫成：模型供應商先填基本資料，平台再確認草稿是否足以生成 `model_card.yaml`、提供樣板來源，並準備 Publish Grant 所需設定。

4. `docs/platform-v2/model-publishing/preparation.md`
   目前明確要求平台在供應商開始填 GitHub 設定前，先產生 Variables / Secrets、repository 設定，並要求供應商使用草稿頁顯示值填入 repository path 與 callback URL。

5. `docs/platform-v2/model-publishing/preparation.md`
   目前也要求平台先固定正式模板來源，再讓供應商 clone 模板到自己的專案。

以上五點合起來代表：平台文件假設存在一個正式交接點，但供應商文件沒有明寫這個交接點，所以 handoff 契約未成立。

## Findings

### High Severity

0. 頁面群：`docs/model-provider/index.md`、`docs/model-provider/packaging-data.md`、`docs/platform-v2/model-publishing/index.md`、`docs/platform-v2/model-publishing/preparation.md`
   問題類型：供應商 Step 1 → Step 2 handoff 契約缺失。
   為何造成理解空窗：供應商文件把流程寫成可直接下載 `model_card.yaml` 後繼續 clone 模板；平台文件卻把 Publish Grant、repository path、callback URL 與正式模板來源定義成 Step 2 前必要平台交付。兩邊即使都照文件走，也不保證會在同一時點完成同一筆交接。
   缺少：`who`、`when`、`how`

1. 頁面：`docs/platform-v2/model-publishing/index.md`
   問題類型：用「七個固定階段」描述整體流程。
   為何造成理解空窗：把「資料與狀態」與「問題處理」寫成主流程固定階段，第一次接手者無法分辨正常主線與例外分支。
   缺少：`when`、`how`

2. 頁面：`docs/platform-v2/model-publishing/index.md`
   問題類型：整頁只寫「平台要確認什麼」「要看哪一頁」。
   為何造成理解空窗：讀者知道要確認，但不知道在平台哪個後台頁面、哪個事件列表、哪個管理入口或哪種資料畫面做確認。
   缺少：`where`、`how`

3. 頁面：`docs/platform-v2/model-publishing/index.md`
   問題類型：「開始之前」只排除錯的讀者，未定義對的讀者。
   為何造成理解空窗：沒有說清楚平台維護者在此流程中的角色是後台管理員、內容審核者、工程維運，還是具資料查核權限的人。
   缺少：`who`

4. 頁面：`docs/platform-v2/model-publishing/preparation.md`
   問題類型：把「上架資料」「工具與範本」寫成資源清單。
   為何造成理解空窗：只列應備物件，沒有說平台維護者在什麼地方建立、下載、核對、發送給供應商，例如後台哪個頁面建立模型、哪裡取得 `model_card.yaml`、哪裡複製樣板入口。
   缺少：`where`、`how`

5. 頁面：`docs/platform-v2/model-publishing/preparation.md`
   問題類型：「平台要如何交付這些資源」是治理判斷，不是操作指令。
   為何造成理解空窗：讀者不知道誰發送、透過哪個通道發送、建立模型草稿後何時交付、核發授權前何時補齊樣板與設定。
   缺少：`who`、`where`、`when`、`how`

6. 頁面：`docs/platform-v2/model-publishing/preparation.md`
   問題類型：反覆使用「可回查來源」「樣板來源」「交付邊界」。
   為何造成理解空窗：這些詞適合內部盤點，不適合接手操作；讀者不知道回查是到網站後台、GitHub repo、文件站，還是資料紀錄。
   缺少：`where`

7. 頁面：`docs/platform-v2/model-publishing/release-intake.md`
   問題類型：只列出接收時要有的欄位。
   為何造成理解空窗：沒有說這些欄位分別從哪裡取得，例如 callback 事件頁、供應商提供的 workflow 連結、平台資料紀錄、registry 查詢結果。
   缺少：`where`、`how`

8. 頁面：`docs/platform-v2/model-publishing/release-intake.md`
   問題類型：處理順序是抽象驗證語句。
   為何造成理解空窗：讀者看得懂判準，看不懂實作，例如怎樣算授權有效、在哪裡看可接收 callback 的狀態、在哪裡比對 repository、tag、digest。
   缺少：`where`、`how`

9. 頁面：`docs/platform-v2/model-publishing/content-validation.md`
   問題類型：列查驗維度，未寫查驗流程。
   為何造成理解空窗：沒有說從哪裡看後台 metadata、在哪裡查 registry labels、從哪個結果頁判斷查驗通過或退回。
   缺少：`where`、`how`

10. 頁面：`docs/platform-v2/model-publishing/content-validation.md`
    問題類型：共享規格、labels、guard metadata、artifact 等名詞很多。
    為何造成理解空窗：沒有告訴第一次接手者這些欄位實際出現在哪裡、比對不一致時要回報誰。
    缺少：`what`、`where`、`who`

11. 頁面：`docs/platform-v2/model-publishing/data-and-state.md`
    問題類型：只把資料類型與狀態翻成白話。
    為何造成理解空窗：沒有說狀態在哪裡看得到、誰能改、什麼事件會自動切換、什麼情況需要人工介入。
    缺少：`where`、`who`、`when`、`how`

12. 頁面：`docs/platform-v2/model-publishing/data-and-state.md`
    問題類型：狀態更新規則寫成應然規則。
    為何造成理解空窗：沒有交代轉換是由 callback 自動寫入、管理後台操作觸發，還是人工審核寫入，直接影響維護者該等系統還是補資料。
    缺少：`who`、`how`、`when`

13. 頁面：`docs/platform-v2/model-publishing/issue-handling.md`
    問題類型：排查資訊與排查順序像檢查表。
    為何造成理解空窗：沒有定義每種問題從哪個入口進來，例如使用者在後台看到什麼畫面、平台管理員在哪個事件列表接案、何時算進入異常流程。
    缺少：`when`、`where`

14. 頁面：`docs/platform-v2/model-publishing/issue-handling.md`
    問題類型：常見問題情境只寫「先查」「再查」。
    為何造成理解空窗：缺少實際查詢路徑與責任角色，讀者只能自行腦補要查 GitHub、平台 DB、ACR 或後台頁面中的哪一個。
    缺少：`where`、`who`、`how`

15. 頁面：`docs/platform-v2/model-publishing/release-decision.md`
    問題類型：只列供應商證據與平台補件證據種類。
    為何造成理解空窗：沒有說由誰收集、收在哪裡、誰有權做最終判定、判定結果要寫回哪個平台欄位或審核畫面。
    缺少：`who`、`where`、`how`

16. 頁面：`docs/platform-v2/model-publishing/release-decision.md`
    問題類型：發布判定與 no-go 條件全是決策原則。
    為何造成理解空窗：沒有操作型結尾，例如在哪個頁面把狀態設成待審核、何時通知供應商、何時才算正式發布完成。
    缺少：`where`、`when`、`how`

### Medium Severity

17. 頁面：七頁全體。
    問題類型：反覆使用「至少要」「可回查」「應補齊」「應確認」。
    為何造成理解空窗：這是內部審查語氣，不是接手操作語氣；讀者知道標準，不知道第一步怎麼做。
    缺少：`how`

18. 頁面：七頁全體。
    問題類型：大量跨頁連結把關鍵操作外包給其他頁。
    為何造成理解空窗：第一次接手者還沒建立心智模型，就被迫在平台頁、供應商頁、reference 頁之間跳轉，容易混淆三種讀者。
    缺少：`who`、`where`

19. 頁面：七頁全體。
    問題類型：完成條件多寫成「可回查」「可追溯」「可判斷」。
    為何造成理解空窗：這些是驗收語，不是觀察語；沒有說成功時畫面、資料、狀態應該長什麼樣。
    缺少：`what`、`when`

## Cross-page Root Causes

1. 七頁共同把文件寫成「平台治理規則摘要」，不是「第一次接手平台維護者的操作說明」。
2. 全文幾乎都有 `what`，但系統性缺少 `where`，沒有持續指出網站後台路徑、管理入口、事件列表、審核頁、registry 查詢位置、證據儲存位置。
3. 全文持續模糊 `who`，都寫「平台維護者」，沒有拆出建立草稿者、核發授權者、接收 callback 的人、查驗者、發布決策者。
4. 全文缺少 `when`，很少說明何時進入某頁、何時退出、何時要求供應商補件、何時轉進下一頁。
5. 全文缺少 `how`，多數步驟都是判準，不是操作；讀者知道要驗證什麼，不知道如何在平台上實際完成。
6. 七頁把主流程頁、例外處理頁、參考對照頁混排，第一次冷讀的人無法建立「正常流程先走哪幾頁，出錯再去哪幾頁」的工作順序。
7. 文件過度依賴外部連結與內部名詞，沒有在當頁先交代最小可執行背景，迫使讀者自行腦補系統表面與權限模型。

## Recommended Rewrite Order

以「平台維護者實際工作順序」重新規劃如下：

1. `docs/platform-v2/model-publishing/index.md`
   職責：定義這組文件寫給誰、他在平台中的角色是什麼、通常從哪個後台入口開始、正常主流程是哪 4 步、異常時改看哪一頁。

2. `docs/platform-v2/model-publishing/preparation.md`
   職責：描述模型供應商開始封裝前，平台維護者在哪裡建立或確認草稿、在哪裡下載或交付上架資料、在哪裡提供樣板與授權設定。

3. `docs/platform-v2/model-publishing/release-intake.md`
   職責：描述供應商送回結果後，平台維護者在哪裡接收 callback 或發布事件、要先看哪幾個欄位、什麼情況可進下一步。

4. `docs/platform-v2/model-publishing/content-validation.md`
   職責：描述平台維護者在哪裡查 image、metadata、labels 與授權欄位，哪些欄位一致才算通過，哪些不一致要退回。

5. `docs/platform-v2/model-publishing/release-decision.md`
   職責：描述查驗完成後誰做判定、在哪裡把案件送進待審核或正式發布、要留下哪些決策證據。

6. `docs/platform-v2/model-publishing/issue-handling.md`
   職責：作為例外分支頁，不再假裝是固定主流程，而是明確寫成「當接收失敗、查驗失敗、狀態卡住時，從哪一步回頭排查」。

7. `docs/platform-v2/model-publishing/data-and-state.md`
   職責：作為全流程附錄或 reference，集中說明資料物件、狀態名、事件來源、誰能改寫、每個狀態通常由哪個前頁步驟觸發。

## 4W1H Writing Rules

以下規則同時作為後續重寫的驗收標準：

1. 每頁開頭第一段必須明寫讀者身分與使用時機，句型固定為「當你是誰、在什麼情況下、要完成什麼，就看這一頁」。
2. 每個步驟都必須先寫 `where`，再寫 action；句型固定為「在某頁面或某系統位置，執行某動作，確認某結果」。
3. 每個名詞第一次出現時，必須同頁交代它在哪裡看得到，不能只丟名詞再把讀者送去別頁查。
4. 任何表格欄位若寫「輸入」「資料」「證據」「結果」，都必須補一欄「取得位置」或「觀察位置」。
5. 任何表格欄位若寫「狀態」「判定」「完成條件」，都必須補一欄「誰更新」與「何時更新」。
6. 不可只寫「平台維護者」；必須明寫角色，例如建立草稿者、核發授權者、接收發布結果者、技術查驗者、發布決策者。
7. 不可只寫「確認」「核對」「補齊」「回查」；必須改成可觀察操作，例如開啟哪個頁面、查看哪個欄位、比對哪兩份資料。
8. 主流程頁只能寫正常路徑；異常處理必須集中放在例外分支頁，不得在每頁把主流程與排錯流程混寫。
9. 每頁最後都必須提供可觀察成功訊號，句型固定為「完成這頁後，你應看到什麼狀態、留下什麼紀錄、進入下一頁哪個步驟」。
10. 每一頁至少要出現一次完整 4W1H 句型，能讓第一次接手的人不跳頁也知道第一步怎麼開始。
11. 驗收標準：找一位未參與此流程的人冷讀該頁，若他無法回答誰做、在哪裡做、何時做、怎麼做，就視為不通過。

## Issue-ready Action Items

0. Owner：`product-strategy-manager`
   輸入：供應商入口文件、平台維護入口文件、FAE 雙角色 walkthrough blocker。
   完成條件：定義單一 canonical handoff，明確寫出「模型供應商完成草稿後，必須收到哪些平台輸出，才可進入模板 clone 與 GitHub 設定」。
   驗證方式：冷讀供應商入口後，未參與撰寫的人能明確回答自己此刻應等待平台，並能列出至少 `publish_grant_id`、repository path、callback URL、template source 四項交付物。

1. Owner：`senior-software-engineer`
   輸入：供應商入口現況、平台入口現況、canonical handoff 契約。
   完成條件：同步改寫供應商與平台兩側文件，讓 Step 1 → Step 2 的順序、輸出清單、責任人與阻擋條件完全一致。
   驗證方式：逐頁對照，確認不再出現一邊叫供應商直接前進、另一邊要求平台先交付必要輸入的衝突。

2. Owner：`product-strategy-manager`
   輸入：七頁現況、目標讀者為第一次接手的平台維護者、使用者要求的 4W1H 標準。
   完成條件：產出單一 reader contract，明確定義每頁讀者、使用時機、正常主流程順序與例外分支位置。
   驗證方式：檢查每頁首頁是否能回答誰看、何時看、看完要去哪一頁。

3. Owner：`ui-ux-designer`
   輸入：平台後台實際資訊架構、相關管理頁名稱、模型草稿與發布流程中的實際操作入口。
   完成條件：為七頁補齊可讀的後台導覽語彙與頁面路徑命名規則，避免只剩系統內部名詞。
   驗證方式：隨機抽 10 個步驟，逐一確認都包含具體位置描述，而不是抽象詞。

4. Owner：`senior-software-engineer`
   輸入：平台真實流程、callback 入口、狀態轉換事實、artifact 與審核資料來源。
   完成條件：把每頁中的抽象判準改寫成操作事實，補齊每個輸入欄位的取得位置、每個狀態的更新來源、每個判定的寫回位置。
   驗證方式：逐頁對照文件與系統事實，確認沒有只寫「確認」「可回查」卻缺少位置與動作。

5. Owner：`testing-quality-engineer`
   輸入：重寫後文件、冷讀維護者 persona、4W1H 驗收規則。
   完成條件：設計一份冷讀 walkthrough，至少涵蓋準備、接收、查驗、判定、異常排查 5 種任務。
   驗證方式：未參與撰寫的人能僅靠文件回答每個任務的 who、what、where、how、when；任一欄回答不出即退回修文。

6. Owner：`field-application-engineer`
   輸入：本次 findings、重寫後草稿、冷讀測試結果。
   完成條件：將每個理解空窗收斂為可追蹤 issue checklist，並確認沒有把供應商教學、平台維護、reference contract 混在同一頁主流程。
   驗證方式：逐頁檢查是否還存在「抽象流程詞可成立，但第一次接手者仍無法開始操作」的段落。

7. Owner：`testing-quality-engineer`
   輸入：canonical handoff 契約、供應商入口、平台入口。
   完成條件：新增一條文件 release gate，凡是平台下游頁面視為最小必要輸入的值，都必須先在上游入口頁建立取得方式、交接責任與停等點。
   驗證方式：逐項抽查 `publish_grant_id`、repository path、callback URL、template source，確認都已在上游入口被明寫。

8. Owner：`product-strategy-manager` + `senior-software-engineer`
   輸入：目前七頁排序、實際上架作業時序。
   完成條件：完成重新排序與頁責切分，讓主流程固定為準備、接收、查驗、判定，異常處理與資料狀態改為支援頁。
   驗證方式：用一個正常上架案例走讀整組文件，確認不需要先讀異常頁或 reference 頁才能開始主流程。

## Closure Recommendation

- 現階段：`no-go`
- 原因：文件除了 4W1H 缺口外，還存在供應商 Step 1 → Step 2 handoff 契約缺失。只要這個 blocker 沒修正，後續 `發布接收`、`內容查驗`、`發布判定` 都建立在未可靠產生的輸入前提上。
- 關閉前必要證據：
   1. 供應商入口與平台入口對同一 handoff 的對齊版本。
   2. 冷讀供應商能正確回答自己何時要等待平台、要收到哪些交付物的 walkthrough 紀錄。
   3. 冷讀平台維護者能正確回答何時完成交付、交付哪些值的 walkthrough 紀錄。
  1. 七頁重寫後版本。
  2. 每頁對應的 4W1H 自查結果。
  3. 冷讀 walkthrough 驗收紀錄。
  4. FAE 對照本 issue checklist 的 closure review。