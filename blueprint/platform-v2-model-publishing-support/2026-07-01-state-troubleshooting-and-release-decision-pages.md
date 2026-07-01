# 資料狀態、問題處理與發布判定頁施工

## 1. 標題

Platform V2 模型上架支援：資料狀態、問題處理與發布判定頁施工

## 2. Metadata 表

| 欄位 | 值 |
| --- | --- |
| Subitem ID | SUB-04 |
| Parent Initiative | `platform-v2-model-publishing-support` |
| Depends On | SUB-01 |
| Planned Workorder Filename | `.github/issues/2026-07-platform-v2-model-publishing-support-state-decision-workorder.md` |

## 3. 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| Product Strategy Manager | Senior Software Engineer | Testing Quality Engineer |

## 4. 問題陳述與分項目標

即使平台已收件並完成內容查驗，若沒有把資料物件、狀態轉換、固定排障順序與發布判定條件寫清楚，後續維護仍會回到憑印象處理，造成頁面雖改寫但維運方法未固定。

本分項要把平台維護者在送件後半段的三個核心維護頁做實：

1. 看懂平台保存哪些資料與狀態。
2. 出問題時按固定順序排查。
3. 證據齊備時依固定條件做發布判定。

## 5. 預期效益

- 維護者能從資料與狀態看出流程卡在哪一段。
- 排障方法被固定，不再憑個人經驗跳步。
- 發布判定有可追溯證據與 no-go 條件。

## 6. In Scope

- 新增或重寫 `docs/platform-v2/model-publishing/data-and-state.md`。
- 新增或重寫 `docs/platform-v2/model-publishing/issue-handling.md`。
- 新增或重寫 `docs/platform-v2/model-publishing/release-decision.md`。
- 與 `utils/db.py`、publishing routes、既有 docs 事實對齊。

## 7. Out of Scope

- 改動實際狀態機或資料表。
- 補做正式驗收證據本體。
- 供應商側 checklists 與 workflow 細節教學。

## 8. 前置依賴與輸入契約

| 輸入 | 來源 | 說明 |
| --- | --- | --- |
| Page Inventory 與寫作契約 | SUB-01 | 提供頁名、類型與驗證方式 |
| `utils/db.py` | repo | 平台資料物件真相源 |
| publishing routes / tests | repo | 狀態與事件處理的實作事實 |
| 現有 troubleshooting / evidence docs | docs | 提供可沿用敘事來源 |

## 9. 執行策略與內容規劃

### 9.1 方法目標與成功定義

本分項處理的是送件後半段的維運方法，不只是補三頁說明文字。成功的定義是：

1. 維護者能從 `data-and-state.md` 看懂平台保存哪些資料、哪些狀態代表流程在哪一段。
2. 維護者能從 `issue-handling.md` 依固定順序排查，而不是憑個人經驗跳步。
3. 維護者能從 `release-decision.md` 依證據做出 go / no-go 判定，而不是只看到一串證據名稱。

若這三頁之間仍無法回答「現在案件到底存在於哪個狀態」「這個問題該先查哪個觀察點」「何時才能宣告可發布」，則本分項未完成。

### 9.2 施工對象與現況判定

1. `docs/platform-v2/model-publishing/data-and-state.md` 預期目前不存在，屬 `new`。它要建立的是資料物件與狀態語意的新真相頁，不是從 implementation spec 挑幾段貼上。
2. `docs/platform-v2/model-publishing/issue-handling.md` 預期目前不存在，屬 `new`。它要建立的是維護者排障順序，而不是把零散 troubleshooting 集合成長文。
3. `docs/platform-v2/model-publishing/release-decision.md` 預期目前不存在，屬 `new`。它要建立的是發布判定的方法與 no-go 條件，而不是簡短結論頁。
4. `utils/db.py` 與相關 publishing routes 已存在，屬 `exists-as-source`。這表示它們不是本分項要修改的對象，而是本分項可宣稱事實的來源。

在本分項中，「存在」用在資料與狀態時，不只是資料列或欄位有名字，而是維護者能在 repo 事實中指出它的角色與用途；「不存在」則代表 blueprint 不允許文案先發明一個資料物件或狀態名稱再找實作補上。

### 9.3 步驟順序與依賴關係

1. 先建立 `data-and-state.md`，因為問題處理與發布判定都必須依賴對資料物件與狀態的共同語意。
2. 在資料與狀態頁中，先整理平台保存的物件，再整理各物件跨事件變化的狀態；不要先寫狀態名稱，再回頭補物件定義。
3. `data-and-state.md` 初稿穩定後，才建立 `issue-handling.md`。問題處理頁的每個觀察點都必須能回指某個資料物件、狀態或事件來源。
4. 最後才建立 `release-decision.md`，因為 go / no-go 判定必須以上兩頁已定義的資料、狀態與問題排查邏輯為前提。

若第 1 步不能明確界定核心資料物件，第 3 與第 4 步都不得進行，否則後續頁面會各自發明自己的狀態語言。

### 9.4 變更面與內容語意

對 `data-and-state.md` 的新增必須至少寫清楚：

1. 平台保存哪些資料物件，例如草稿、授權、證據、審核結果或其他 repo 可回查實體。
2. 每個資料物件在流程中的用途，以及缺失時代表什麼風險。
3. 狀態名稱的白話意義，包含什麼叫做已收到、已確認、待審核、已發布等。
4. 哪些事件會推動狀態轉換，哪些事件不足以推動狀態前進。

對 `issue-handling.md` 的新增必須至少寫清楚：

1. 排查順序必須固定，例如先看案件是否存在、再看輸入是否完整、再看查驗結果、最後看審核或同步失敗。
2. 每一步都要寫出觀察點、成功訊號、失敗訊號與下一步，而不是只列問題名稱。
3. 哪些問題可由平台直接處理，哪些問題必須回供應商補件。

對 `release-decision.md` 的新增必須至少寫清楚：

1. 平台判定所依賴的輸入證據集合。
2. 哪些條件存在才可判定為 go，哪些條件不存在或不一致就必須 no-go。
3. 判定完成後要如何更新或對外同步結果。
4. 這一頁只定義判定方法，不代替正式驗收證據本體。

### 9.5 決策點、分支與阻擋條件

1. 若 `utils/db.py` 或 route 事實無法支持某個文案聲稱的資料物件或狀態，該內容必須降為待確認，不得硬寫進資料與狀態頁。
2. 若問題處理頁中的某個步驟無法回指前序頁定義的資料或狀態，代表排障邏輯不完整，必須先補資料與狀態頁。
3. 若發布判定需要額外的正式環境或人工政策，但 repo 中沒有可宣稱來源，頁面只能寫成決策前提，不可冒充已自動化或已落地。
4. 若某問題情境其實屬於供應商打包錯誤，而非平台維運錯誤，必須在問題處理頁中明寫回供應商補件，不得把供應商問題偽裝成平台內部排障。

### 9.6 證據、完成訊號與回寫位置

完成證據應包含：

1. `data-and-state.md` 已能用 repo 事實解釋資料物件與狀態。
2. `issue-handling.md` 已有固定排查順序與每步的判斷方法。
3. `release-decision.md` 已能清楚列出 go / no-go 判定所依賴的證據與條件。

完成訊號是：同一位維護者先讀資料與狀態頁、再讀問題處理頁、最後讀發布判定頁，能用同一套名詞理解整個後半流程；證據回寫位置是三個新頁本身、查核點證據欄位，以及後續驗證紀錄。

## 10. 交付物清單

- `docs/platform-v2/model-publishing/data-and-state.md`
- `docs/platform-v2/model-publishing/issue-handling.md`
- `docs/platform-v2/model-publishing/release-decision.md`

## 11. 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| CP-01 | 資料與狀態頁完成 | 頁面能說明資料物件、狀態與更新方法 | 維護者可看懂流程停在哪裡 | 依 Workstream「資料與狀態頁施工」施工 | 與 `utils/db.py` 對照 | `data-and-state.md` |
| CP-02 | 問題處理頁完成 | 頁面有固定排查順序與每段判斷方法 | 排障過程不再跳步 | 依 Workstream「問題處理頁施工」施工 | 章節檢查與情境覆蓋檢查 | `issue-handling.md` |
| CP-03 | 發布判定頁完成 | 頁面有平台判定順序與 no-go 條件 | 發布決策可追溯 | 依 Workstream「發布判定頁施工」施工 | 判定鏈檢查 | `release-decision.md` |

## 12. 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| CP-01 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已完成 `docs/platform-v2/model-publishing/data-and-state.md`，並對照 `utils/db.py` 與 publishing 狀態名詞 |
| CP-02 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已完成 `docs/platform-v2/model-publishing/issue-handling.md`，排查順序與每段觀察點均已落檔 |
| CP-03 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已完成 `docs/platform-v2/model-publishing/release-decision.md`，明列 go / no-go 判定鏈與證據邊界 |

## 13. CEO 待提供資源

無。

## 14. 風險與待確認事項

- 若現有 repo 對某些 published / review 流程僅有部分實作，文件需誠實界定可宣稱範圍與待確認內容。
- 已依本原則施工：發布判定頁僅定義判定方法與 no-go 條件，不把正式驗收證據本體寫成已完成交付。
