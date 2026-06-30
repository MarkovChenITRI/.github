# 真人使用回饋表

## 原始回饋

### 1. 我的方案頁面的狀態與可見性欄位並未修改

我的方案頁的方案清單，狀態與可見性希望直接改成下拉式選單，只有「公開 / 已隱藏」兩種即可，不需要「發不發布」tag。

### 2. 我的方案頁面的操作欄位並未修改

操作欄位希望統一為「檢視 / 刪除」兩個按鈕；目前方案清單仍只有「檢視」。

### 3. 將所有現有的模型小卡認列在 admin 帳戶底下

希望將現有模型小卡都視為 admin 依新增流程建立的模型；若有欄位缺失，應允許後續補填更新，而不是因資料不完整就不被認列。

## FAE Workorder Inputs

### 1) Issue Classification

產品型 feedback，且可拆成三條 workorder finding：

1. `RUF-01` 我的方案頁狀態 / 可見性語意未收斂。
	- 類型: usability / IA consistency / labeling mismatch
	- 判定: 已出現理解落差與可見性問題
2. `RUF-02` 我的方案頁操作欄位未與同族管理頁一致。
	- 類型: usability / interaction consistency / action discoverability gap
	- 判定: 已出現理解落差與操作可預期性問題
3. `RUF-03` admin 對既有模型小卡缺少一致的認列與後補流程。
	- 類型: admin usability / maintenance-flow consistency / information architecture gap
	- 判定: 屬管理者維護流程一致性的可用性與可理解性問題

### 2) Reproduction Status

1. `RUF-01`: 部分可冷啟動重現。
	- 可檢查: 方案頁目前是否仍以 tag 或非下拉式控制呈現狀態 / 可見性，且是否把「公開 / 已隱藏」與其他 lifecycle 狀態混在一起。
	- 不可宣稱: 不得宣稱已證明所有使用者都無法理解；目前只能說已存在明確回饋，且 UI 語意存在可檢查風險。
2. `RUF-02`: 可冷啟動重現。
	- 可檢查: 方案頁操作欄是否缺少「刪除」，以及是否與同工作區其他管理頁的列表操作契約不一致。
3. `RUF-03`: 可冷啟動重現。
	- 可檢查: admin 是否缺少「先認列既有模型卡、再補齊缺漏欄位」的單一路徑，或現況是否把「欄位缺失」等同於「不存在 / 不納管」。

### 3) User-Journey Risk

1. `RUF-01` 風險: 方案提供者在管理自己的方案時，無法從頁面直接理解「目前可見性可以改什麼」與「狀態欄位代表什麼」，容易把 lifecycle 狀態、發布狀態與可見性混為一談。
2. `RUF-02` 風險: 使用者在同一套 workspace 管理旅程中，對操作欄的預期被打破；當裝置 / 模型頁已形成「檢視 / 刪除」心智模型時，方案頁只剩「檢視」會造成猶豫、誤判權限，或轉而尋找不存在的編輯入口。
3. `RUF-03` 風險: admin 無法以「先收編既有資產、再補資料」的維護心智處理 legacy 模型卡，會把平台現況盤點、資料補齊與新增流程混成同一件事，降低治理可理解性，也提高遺漏既有資產的風險。

### 4) Missing Information

#### 需要 CEO 提供真人使用者後才能補齊

1. `RUF-01`
	- 方案提供者是否真的把「公開 / 已隱藏」視為唯一需要的可見性語言，還是只是在現有頁面下暫時提出最小可接受簡化。
	- 使用者是否仍需要看見其他非可見性的生命周期資訊，但希望不要放在同一欄位。
2. `RUF-02`
	- 使用者期待的「刪除」是硬刪除、軟刪除、撤下發布，還是單純從清單移除可見性。
	- 真實使用者在看到「檢視 / 刪除」後，是否還會期待額外的「編輯」或「複製」操作。
3. `RUF-03`
	- admin 維運者是否能在新流程下清楚分辨「已認列但待補資料」與「尚未存在於平台 inventory」。
	- admin 是否把這條流程理解成「補登 legacy 資產」，而不是「重新新增一批模型」。

#### 可先做冷啟動檢查，不必等待真人資源

1. `RUF-01`
	- 盤點方案頁目前的欄位名稱、控制元件型態、預設文案與選項集合。
	- 比對是否把可見性語意與發布 / 狀態語意混欄。
2. `RUF-02`
	- 比對方案頁、我的模型頁、我的裝置頁的操作欄是否採相同按鈕集合與排列節奏。
	- 檢查刪除操作是否有權限界線、確認流程與空狀態回饋。
3. `RUF-03`
	- 盤點 admin 現況是否具備既有模型卡 inventory、缺漏欄位提示、後補入口與狀態標示。
	- 檢查新增流程是否能容忍 legacy 資料缺欄位而先認列。

### 5) Action Items

#### `ACT-01` 凍結方案頁狀態 / 可見性語意範圍

- Owner: `product-strategy-manager`
- Input:
  - 本回饋 `RUF-01`
  - 方案頁現況欄位與控制元件盤點
  - workspace 同族頁面的術語對照
- Done condition: 定義方案頁哪些資訊屬於「可見性」、哪些屬於「生命周期 / 發布狀態」，並凍結本輪是否只保留「公開 / 已隱藏」兩種可見性選項。
- Verification: workorder 中有明確 in-scope / out-of-scope，且 reviewer 能看出不再混用不同狀態語意。

#### `ACT-02` 收斂方案頁狀態欄位與控制元件

- Owner: `ui-ux-designer`
- Input:
  - `ACT-01` 範圍凍結
  - 方案頁現況 UI
  - workspace 其他管理頁的欄位契約
- Done condition: 方案頁把可見性控制與其他狀態資訊拆清楚；若保留 lifecycle 資訊，也不得再假裝它是同一個可切換欄位。
- Verification: cold-start walkthrough 可辨識「哪個欄位是可改的可見性，哪個欄位只是資訊顯示」，不需靠口頭解釋。

#### `ACT-03` 對齊方案頁操作欄互動契約

- Owner: `ui-ux-designer` + `senior-software-engineer`
- Input:
  - 本回饋 `RUF-02`
  - 方案頁與 sibling 管理頁的操作欄比對
  - 刪除權限與確認流程現況
- Done condition: 方案頁操作欄與同族管理頁採同一組基礎操作契約，至少解決目前「只有檢視、缺少刪除」的不一致。
- Verification: cold-start checklist 比對三頁操作欄後，不再出現同族頁面卻使用不同主操作集合的情況。

#### `ACT-04` 凍結 admin 既有模型卡認列流程

- Owner: `product-strategy-manager` + `architecture-research-developer`
- Input:
  - 本回饋 `RUF-03`
  - admin 現況 inventory / publish / asset 頁面盤點
  - 既有模型卡資料缺漏樣態
- Done condition: 定義「既有模型卡先認列、缺欄位後補」的流程語意、source of truth 與最小必填欄位策略。
- Verification: 文件能清楚區分「先認列 legacy 資產」與「重新走一次新增流程」不是同一件事。

#### `ACT-05` 提供 admin 可理解的既有模型卡 inventory 與補欄位路徑

- Owner: `senior-software-engineer`
- Input:
  - `ACT-04` 流程契約
  - admin 模型清單 / 詳情 / 補欄位入口現況
- Done condition: admin 能看到既有模型卡、辨識缺漏欄位、進入補資料流程，且資料不完整不會阻止先被納管。
- Verification: 以完整資料卡與缺漏資料卡兩種情境走查，都能在 UI 上分辨「已認列待補」與「不可用 / 不存在」。

#### `ACT-06` 建立冷啟動驗收與真人驗收分流

- Owner: `field-application-engineer` + `testing-quality-engineer`
- Input:
  - `RUF-01` 至 `RUF-03`
  - 上述 action 完成物
- Done condition: workorder 內明確拆出「可冷啟動驗收」與「需真人驗收」兩類證據，不再把 heuristic 檢查寫成真人結論。
- Verification: issue 內每個 finding 都有對應的 cold-start evidence 與 external validation gap 欄位。

#### `ACT-07A` 提供真人驗收資源

- Owner: `CEO`
- Input:
  - 已完成的方案頁與 admin 維護流程變更
  - 測試任務腳本
- Done condition: 提供符合角色的真實受測者管道，至少涵蓋方案提供者與 admin 維運者兩類。
- Verification: 受測者來源、時段或平台資訊已交給 `usability-test-coordinator`。

#### `ACT-07B` 產出真人 usability findings package

- Owner: `usability-test-coordinator`
- Input:
  - `ACT-07A` 提供的受測者資源
  - `RUF-01` 至 `RUF-03` 的驗證任務腳本
- Done condition: 以真人觀察資料確認使用者是否能理解方案頁欄位語意、是否能預期操作欄行為，以及 admin 是否能理解 legacy 模型卡的認列與補資料流程。
- Verification: findings package 含原始觀察、卡點、任務完成率與未解問題，不以 AI 推測補寫真人反應。

### 6) Usability Findings Package Requirements

若後續進入真人驗收，至少需要以下內容：

1. 受測者分群
	- 方案提供者
	- admin 維運者
	- 是否熟悉本專案、是否曾使用舊版頁面
2. 任務腳本
	- 在方案頁把某個方案改成隱藏或公開
	- 在方案頁判斷某個方案目前是否可刪除，並完成刪除或說明為何不敢按
	- 在 admin 視角確認某張既有模型卡是否已被平台認列，若缺欄位則指出下一步去哪裡補
3. 觀察紀錄
	- 哪個欄位被誤解為可編輯或不可編輯
	- 是否把 lifecycle 狀態誤認為可見性開關
	- 是否找不到刪除入口，或不理解刪除後果
	- 是否把「資料待補」誤解成「模型不存在」
4. 量化欄位
	- 任務完成率
	- 首次猶豫點
	- 求助次數
	- 任務完成時間
5. 待確認項
	- 使用者是否需要比「公開 / 已隱藏」更多的可見性語言
	- admin 是否需要批次補欄位，而不是逐卡補欄位

### 7) Closure Recommendation Constraints

FAE 在 closure recommendation 中應遵守以下限制：

1. 不得因 cold-start walkthrough 通過就宣稱「真人已可理解」。
2. `RUF-01` 與 `RUF-02` 至少要有 UI 契約收斂證據，才能從 open 進入 waiting-for-validation，而不是維持 ambiguous。
3. `RUF-03` 若只有 inventory 清單、沒有缺欄位補資料路徑，不得建議關閉。
4. 若 CEO 尚未提供真人受測資源，最終狀態只能是 `blocked pending external validation` 或等價語意，不得寫成 fully closed。
5. 若真人 findings 顯示使用者仍把可見性、狀態與發布語意混淆，必須 reopen 到產品 / 設計 / 工程 action，而不是以「已照需求做下拉」直接關單。

### 8) Unified Metrics Rows

| reporting_week | stream_id | finding_id | owner | metric_name | baseline | target | current | trend | blocker | veto_status | closure_recommendation |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 2026-W27 | maintainer | RUF-01 | product-strategy-manager / ui-ux-designer / senior-software-engineer | solution_visibility_label_clarity | 方案頁狀態與可見性語意混用，使用者已明確提出希望只保留公開 / 已隱藏 | 可見性欄位語意單一、控制元件可直接理解，且不再與其他狀態混欄 | 已收到真人回饋，但尚未完成 UI 契約與冷啟動驗收證據彙整 | flat | 尚未完成欄位語意凍結與後續真人驗收 | blocked | reopen and route to PM / UX / engineering |
| 2026-W27 | maintainer | RUF-02 | ui-ux-designer / senior-software-engineer / testing-quality-engineer | solution_actions_consistency | 同族 workspace 管理頁的操作欄心智模型不一致，方案頁仍只有檢視 | 方案頁與 sibling 頁操作欄一致，至少消除檢視 / 刪除落差 | 已有明確回饋，可冷啟動比對，但尚未補齊一致性證據 | flat | 方案頁操作契約尚未收斂，且缺真人確認是否仍期待其他操作 | blocked | reopen and route to UX / engineering |
| 2026-W27 | maintainer | RUF-03 | product-strategy-manager / architecture-research-developer / senior-software-engineer | admin_legacy_model_recognition_flow | admin 缺少把既有模型卡先認列再補欄位的可理解流程 | admin 可盤點所有既有模型卡，並清楚區分已認列待補與不存在 | 已有需求方向，但尚未確認 inventory、補欄位入口與真人理解證據 | flat | admin 維護流程契約與真人驗收資源皆未完成 | blocked | reopen and route to PM / architecture / engineering |
