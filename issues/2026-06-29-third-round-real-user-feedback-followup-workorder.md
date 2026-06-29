# [Work Order] 第三輪真人使用回饋跟進施工單

- Work Order ID: WO-2026-06-29-08
- 日期: 2026-06-29
- Stream ID: maintainer
- 範圍: 第三輪真人使用回饋的 workspace 模板一致性與 admin 模型盤點能力
- 來源: `.github/issues/real-user-feedback-form.md` 最新回填 + `/site-reliability-engineer` + `/usability-test-coordinator` read-only triage
- 目前狀態: Blocked on external participants
- 目前階段: 我的方案模板收斂、admin 逐卡盤點與本地驗證完成；等待新一輪真人驗收資源
- 下一位 owner: CEO / usability-test-coordinator

## 1) Issue Classification

產品型 feedback。這一輪不再是前一批的「我的模型頁模板一致性」與「授權文件重寫」延伸，而是新的兩條產品需求：

1. 我的方案頁也要與我的裝置、我的模型收斂成同一套管理模板。
2. admin 帳戶要先看到 cards 中現有的所有模型，即使部分資料尚未依標準流程補齊，也應先被認列到平台模型清單。

這代表本批次不應回塞到 `WO-2026-06-29-07`。前一張工單目前已進入「本地驗證完成，等待第三輪真人驗收」的 closure 軌道；若把新需求混入，會破壞 SOP3 單一真相源與 closure criteria。

## 2) Reproduction Status

1. 我的方案頁模板不一致：可直接重現。
   - 最新真人回饋要求我的方案頁與我的裝置、我的模型使用同一套模板。
   - 現況 `templates/pages/workspace/solutions.html` 仍以卡片瀏覽為主，不是 `templates/pages/admin/devices.html` / `templates/pages/workspace/guide.html` 同族的管理模板。
2. admin 無法先認列所有模型卡：可直接重現。
   - 最新真人回饋要求 admin 模型清單能看見 cards 中現在已有的所有模型，即使資料不完整也先收進清單。
   - 現況 admin 只有聚合型儀表板與單一使用者資產視角，缺少一個「all cards inventory」式的 admin 模型清單。

## 3) Frozen Input Contract

1. 最新真人回饋來源
   - `.github/issues/real-user-feedback-form.md`
2. 目前對照頁面
   - `templates/pages/admin/devices.html`
   - `templates/pages/workspace/guide.html`
   - `templates/pages/workspace/solutions.html`
3. 目前 admin 盤點與資產視角
   - `templates/pages/admin/platform.html`
   - `templates/pages/admin/model_card_publish_ops.html`
   - `templates/pages/admin/user_assets.html`
   - `utils/platform/monitoring_dashboard.py`
4. 本單不處理
   - `WO-2026-06-29-07` 的第三輪真人驗收 blocker
   - 授權文件再次大改版
   - 模型上架後端狀態機重新設計

## 4) Findings

### `FB3-01` 我的方案頁未對齊我的裝置 / 我的模型管理模板

- 分類: usability / IA consistency / interaction contract mismatch
- 現況: 我的方案頁仍是卡片瀏覽主體，不是已經收斂過的 workspace 管理模板家族。
- 風險: 使用者在同一個 workspace 內仍要切換不同的任務模型，客服指引、截圖教學、模板契約測試與回歸驗收無法共用。
- owner: `product-strategy-manager` + `ui-ux-designer` + `senior-software-engineer`

### `FB3-02` admin 缺少「先認列全部模型卡」的盤點清單

- 分類: admin visibility / data inventory / operability gap
- 現況: admin 能看到儀表板摘要與特定使用者資產，但沒有一個以 card 實體為中心的全量模型清單；部分非標準流程產生的模型資料也無法先以「資料待補」方式被認列。
- 風險: 平台維運者無法先盤點現況再補資料，會把「資料缺漏」誤判為「模型不存在」，也會削弱 admin 的治理與清整能力。
- owner: `architecture-research-developer` + `senior-software-engineer` + `site-reliability-engineer`

## 5) Missing Information Request

1. `FB3-01` 已足以派工，不需要再追問視覺偏好；目前缺的是三個 sibling 頁的共享模板契約與差異化欄位表。
2. `FB3-02` 已足以派工，不需要等全部 legacy 資料補齊；目前缺的是 admin 模型清單的 source of truth 與「資料待補」狀態定義。

## 6) Owner Matrix

| 階段 | Owner | 交付物 |
|------|-------|--------|
| 問題收斂 | field-application-engineer | feedback triage、action item 與 closure recommendation |
| 範圍凍結 | product-strategy-manager | 第三輪修正範圍與非目標清單 |
| 模板契約 | ui-ux-designer | 我的裝置 / 我的模型 / 我的方案共用模板契約 |
| 盤點架構 | architecture-research-developer | admin all-cards inventory 的資料契約與 source of truth |
| 工程實作 | senior-software-engineer | 我的方案模板收斂與 admin 模型清單功能 |
| Operability 驗收 | site-reliability-engineer | admin 盤點與資料待補 runbook / walkthrough |
| 測試與 gate | testing-quality-engineer | 模板一致性與 admin 模型盤點驗收清單 |
| 真人驗收 | usability-test-coordinator | 新一輪 findings package |

## 7) Action Items

### `ACT-01` 凍結三個 workspace 頁的共享模板範圍

- Owner: `product-strategy-manager`
- 輸入資料:
  - `.github/issues/real-user-feedback-form.md`
  - `templates/pages/admin/devices.html`
  - `templates/pages/workspace/guide.html`
  - `templates/pages/workspace/solutions.html`
- 完成條件: 定義我的裝置 / 我的模型 / 我的方案三頁必須共用的管理模板骨架，以及哪些欄位與業務文案允許差異化。
- 驗證方式: 產出共享模板完成定義與 out-of-scope 清單，避免再次落回「概念類似但任務模型不同」。

### `ACT-02` 產出三頁 sibling 管理模板契約

- Owner: `ui-ux-designer`
- 輸入資料:
  - `templates/pages/admin/devices.html`
  - `templates/pages/workspace/guide.html`
  - `templates/pages/workspace/solutions.html`
- 完成條件: 明確定義統計卡、列表主體、空狀態、主 CTA、檢視 / 新增容器、成功 / 失敗訊息與操作節奏的共通契約。
- 驗證方式: side-by-side checklist 比對後，方案頁差異只剩欄位與業務語彙，不再剩不同 IA。

### `ACT-03` 將我的方案頁收斂為同族管理模板

- Owner: `senior-software-engineer`
- 輸入資料:
  - `ACT-01` 範圍凍結
  - `ACT-02` 模板契約
- 完成條件: `templates/pages/workspace/solutions.html` 與對應互動改為與裝置 / 模型同族的管理模板；不再以純卡片瀏覽作為主工作流。
- 驗證方式:
  - focused template / route regression test
  - 人工比對空狀態、檢視、建立、取消、成功、失敗六條路徑

### `ACT-04` 凍結 admin 模型盤點清單的資料契約

- Owner: `product-strategy-manager`
- 輸入資料:
  - `.github/issues/real-user-feedback-form.md`
  - `templates/pages/admin/platform.html`
  - `templates/pages/admin/model_card_publish_ops.html`
  - `templates/pages/admin/user_assets.html`
  - `utils/platform/monitoring_dashboard.py`
- 完成條件: 定義這次 admin 需要的是「all cards inventory」，不是只有聚合摘要或單一使用者資產頁，並列出最小欄位與可接受的缺值策略。
- 驗證方式: 形成 reader job-to-be-done 與 source of truth 說明。

### `ACT-05` 產出 admin all-cards inventory 架構契約

- Owner: `architecture-research-developer`
- 輸入資料:
  - `ACT-04` 範圍凍結
  - `utils/platform/monitoring_dashboard.py`
- 完成條件: 定義 admin 模型清單的 source of truth 以 card 實體為中心，並定義「資料待補 / 非標準流程 legacy / 可發布 / 可部署」等狀態語意。
- 驗證方式: reviewer 能清楚區分聚合儀表板、使用者資產頁與 all-cards inventory 三者責任，不再混用。

### `ACT-06` 提供 admin 可見的全部模型卡盤點清單

- Owner: `senior-software-engineer`
- 輸入資料:
  - `ACT-05` 架構契約
- 完成條件: admin 可在單一頁面看到所有 card 實體，即使 metadata 不完整也先認列；每筆至少可辨識來源、狀態、缺漏欄位與下一步。
- 驗證方式:
  - 以完整 card、缺欄位 card、legacy 非標準 card 三種資料驗證都可出現在清單
  - 不只剩儀表板總數，也不只剩單一使用者資產視角

### `ACT-07` 產出 admin 盤點與資料待補 runbook

- Owner: `site-reliability-engineer`
- 輸入資料:
  - `ACT-06` 完成物
- 完成條件: 補一份維運走查，說明哪些模型只是資料待補、哪些屬於發布證據缺漏、哪些仍不可部署。
- 驗證方式: 至少兩個 walkthrough 能區分「模型存在但資料不完整」與「模型不存在或狀態不可用」。

### `ACT-08` 建立模板一致性與 admin 盤點驗收 gate

- Owner: `testing-quality-engineer`
- 輸入資料:
  - `ACT-03` 完成物
  - `ACT-06` 完成物
- 完成條件: 補驗收清單，至少覆蓋：
  - 我的方案是否與我的裝置 / 我的模型同族
  - admin 是否能看見所有模型卡
  - 缺欄位資料是否以可辨識方式顯示
- 驗證方式: focused regression 或自動化測試可阻止退回「只有摘要沒有清單」或「方案頁又回到獨立版型」。

### `ACT-09A` CEO 提供新一輪真人驗收資源

- Owner: `CEO`
- 輸入資料:
  - `ACT-03` 與 `ACT-06` 完成物
  - 新一輪真人驗收任務腳本
- 完成條件: 提供方案提供者 / 平台維運者受測者名單或測試管道。
- 驗證方式: 受測者名單、時段或測試平台已交給 `usability-test-coordinator`。

### `ACT-09B` 執行新一輪真人驗收並產出 findings

- Owner: `usability-test-coordinator`
- 輸入資料:
  - `ACT-03` 完成後的方案頁
  - `ACT-06` 完成後的 admin 模型清單
  - `ACT-09A` 提供的真人受測者資源
- 完成條件: 收集新一輪真人回饋，驗證：
  - 使用者是否認定我的方案 / 我的模型 / 我的裝置是同一套管理模板
  - admin 是否能直觀看到所有現有模型，並分辨哪些資料待補
- 驗證方式: findings package 含完成率、卡點、原話、成功 / 失敗判定與 closure recommendation。

## 8) Verification Evidence

1. 直接證據
   - `.github/issues/real-user-feedback-form.md`
2. 目前對照頁面
   - `templates/pages/admin/devices.html`
   - `templates/pages/workspace/guide.html`
   - `templates/pages/workspace/solutions.html`
3. 目前 admin 盤點與資產視角
   - `templates/pages/admin/platform.html`
   - `templates/pages/admin/model_card_publish_ops.html`
   - `templates/pages/admin/user_assets.html`
   - `utils/platform/monitoring_dashboard.py`
4. triage 證據
   - `/site-reliability-engineer` read-only triage
   - `/usability-test-coordinator` read-only triage

## 9) Closure Criteria

1. 我的方案頁與我的裝置 / 我的模型完成模板一致性對齊，不再只是同主題不同任務模型。
2. admin 能看到平台現有的全部模型卡，缺資料者也能先被認列並標示為待補。
3. 維運者能透過 runbook 區分「資料待補」與「發布 / 部署不可用」兩種不同狀態。
4. 新一輪真人驗收能收斂出「已符合期待」或「仍有缺口」的 findings package。

## 10) Closure Recommendation

- 目前建議: `blocked pending external validation`
- 原因:
  - `ACT-03`、`ACT-06`、`ACT-07`、`ACT-08` 已完成本地施工與驗證，但 `ACT-09A` / `ACT-09B` 仍需要 CEO 提供真人驗收資源。
  - 本單目前缺的不是工程完成度，而是外部真人驗收證據包。

## 11) Feedback Routing Recommendation

產品型 feedback，留在本 repo 的 issues / docs / PR 討論。這不是 HR 治理型 feedback，不回收至 `feedback/session-log.md`。

## 12) Unified Metrics Contract

- reporting_week: `2026-W27`
- stream_id: `maintainer`
- owner: `field-application-engineer` / `product-strategy-manager` / `ui-ux-designer` / `architecture-research-developer` / `senior-software-engineer` / `site-reliability-engineer` / `testing-quality-engineer` / `usability-test-coordinator`
- metric_name: `third_round_real_user_feedback_closure_rate`
- baseline: `latest real-user feedback reopens workspace template consistency at the solutions page and requests admin-visible recognition of all existing model cards`
- target: `the solutions page matches the shared workspace management template and admin can inventory all existing model cards with missing-data markers`
- current: `the solutions page now uses the shared management-template family and admin can inventory each model card entity with missing-data markers; external usability validation is still pending`
- trend: `up`
- evidence_links: `.github/issues/real-user-feedback-form.md`, `templates/partials/workspace/management.html`, `templates/pages/admin/devices.html`, `templates/pages/workspace/guide.html`, `templates/pages/workspace/solutions.html`, `templates/pages/admin/platform.html`, `templates/pages/admin/model_card_publish_ops.html`, `templates/pages/admin/user_assets.html`, `utils/platform/monitoring_dashboard.py`
- blocker: `new-round real-user validation resources have not been supplied yet`
- veto_status: `blocked`
- closure_recommendation: `blocked pending external validation`

## 13) 2026-06-29 執行與簽核更新

### 13.1 範圍凍結與模板契約落地

1. `ACT-01` / `ACT-02` 已以既有 sibling 頁面模板為真相源完成落地。
  - 共享骨架採用：統計卡 + 主清單 + 空狀態 + 主 CTA + 同頁管理語境。
  - 允許差異只保留在欄位語彙與動作入口，不再保留獨立 IA。
2. `ACT-04` / `ACT-05` 已以 admin 資源監測頁現有 payload 為真相源完成落地。
  - admin 這次要的是 all-cards inventory，不再把模型卡聚成單一 model 摘要。
  - 缺值策略採「先認列、再標示資料待補」，不把缺 metadata 誤判成不存在。

### 13.2 工程完成物

1. `ACT-03` 我的方案頁模板收斂完成。
  - `templates/pages/workspace/solutions.html` 已從純卡片瀏覽改為同族管理模板。
  - 新版包含統計卡、方案清單表格、空狀態與主 CTA，並保留 lifecycle presentation metadata 作為狀態真相源。
  - 後續 refinement 已把裝置 / 模型 / 方案三頁共用的統計卡與清單外殼抽到 `templates/partials/workspace/management.html`，不再只是三份相似 HTML。
2. `ACT-06` admin 全部模型卡盤點完成。
  - `utils/platform/monitoring_dashboard.py` 的模型盤點已改為逐 card 實體列示。
  - 每筆至少可辨識模型名稱、來源裝置 / card id、部署類型、量化方式與缺漏欄位數。
  - 缺 metadata 的 card 會以 `資料待補` 顯示，而不是被聚合摘要吃掉。

### 13.3 Operability Walkthrough

1. `ACT-07` admin 盤點與資料待補走查完成。
  - 情境 A: 若清單出現某模型且帶有 `資料待補`，代表模型卡已存在，下一步是補 repo、license 或介面證據，不是重新認列模型。
  - 情境 B: 若清單出現模型但缺漏欄位為 `0`，代表 card metadata 已齊備，可交由後續發布 / 部署流程繼續處理。
  - 情境 C: 若 admin 搜尋不到 card，才可判定為目前 inventory 中不存在，而不是單純資料不完整。

### 13.4 測試與簽核

1. `ACT-08` focused gate 已完成。
  - `pytest tests/test_solution_template.py tests/test_route_boundaries.py -q`
  - 結果：`45 passed`
  - 共用 partial refinement 後再執行 `pytest tests/test_solution_template.py -q`
  - 結果：`32 passed`
2. 編輯後檔案靜態錯誤檢查完成。
  - `templates/partials/workspace/management.html`: no errors
  - `templates/pages/admin/devices.html`: no errors
  - `templates/pages/workspace/guide.html`: no errors
  - `templates/pages/workspace/solutions.html`: no errors
  - `utils/platform/monitoring_dashboard.py`: no errors
  - `tests/test_solution_template.py`: no errors
  - `tests/test_route_boundaries.py`: no errors

### 13.5 剩餘 blocker

1. `ACT-09A` 尚未完成：CEO 尚未提供新一輪真人驗收受測者或測試時段。
2. `ACT-09B` 尚未完成：`usability-test-coordinator` 尚未能據此產出 findings package。
3. 因此本單可宣稱「工程完成、本地驗證完成」，不可宣稱「整體 closure 完成」。