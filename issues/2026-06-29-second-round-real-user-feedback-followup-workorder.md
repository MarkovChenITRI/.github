# [Work Order] 第二輪真人使用回饋跟進施工單

- Work Order ID: WO-2026-06-29-07
- 日期: 2026-06-29
- Stream ID: maintainer
- 範圍: 第二輪真人使用回饋的設計修正、文件重寫與驗收規劃
- 來源: `.github/issues/real-user-feedback-form.md` 最新回填 + `/site-reliability-engineer` + `/usability-test-coordinator` read-only triage
- 目前狀態: Blocked on external participants
- 目前階段: 模板收斂、文件重寫與本地驗證完成；等待 CEO 提供第三輪真人驗收資源
- 下一位 owner: CEO / usability-test-coordinator

## 1) Issue Classification

產品型 feedback。這不是治理型 skill 落差，而是第二輪真人回饋直接指出：

1. 我的模型頁面雖然已做過第一版改版，但仍未與「我的裝置」對齊成同一套管理模板。
2. 「模型憑證與授權」文件分類雖已建立入口，但後續頁面仍不符合開發者文件應有的敘事深度與架構說明。

這代表上一張工單對 `FB-02` 與 `FB-03` 的完成證據，只證明「先前版本已改善」，不代表「已符合真人期待」。

## 2) Reproduction Status

1. 模型頁模板不一致：可直接重現。
   - 真人回饋要求「我的模型」使用與「我的裝置」一模一樣的模板，只允許新增視窗欄位不同。
   - 現況 `templates/pages/workspace/guide.html` 仍是 hero + 左側清單 + 右側摘要 + 長表單的混合工作台，不是 `templates/pages/admin/devices.html` 的同型 CRUD 模板。
2. 文件深度不足：可直接重現。
   - `docs/platform/advanced/model-credentials-and-authorization.md`、`docs/platform/advanced/authorization-and-access.md`、`docs/platform/advanced/model-card-publishing.md` 目前仍以表格盤點、矩陣、清單為主要骨架，缺少開發者文件應有的架構敘事、邏輯梳理與交互示意。

## 3) Frozen Input Contract

1. 最新真人回饋來源
   - `.github/issues/real-user-feedback-form.md`
2. 目前模型頁與對照頁
   - `templates/pages/workspace/guide.html`
   - `templates/pages/admin/devices.html`
3. 目前文件頁
   - `docs/platform/advanced/model-credentials-and-authorization.md`
   - `docs/platform/advanced/authorization-and-access.md`
   - `docs/platform/advanced/model-card-publishing.md`
4. 本單不處理
   - 第三輪真人受測者招募本身
   - 重新定義模型上架後端狀態機
   - 新增外部依賴或大型文件框架重構

## 4) Findings

### `FB2-01` 我的模型頁未對齊我的裝置頁模板

- 分類: usability / interaction consistency / UI contract mismatch
- 現況: 真人回饋明確要求我的模型頁與我的裝置頁使用一模一樣的模板，只允許「新增」視窗欄位不同；現況仍是另一套工作台骨架。
- 風險: 使用者在同一個 workspace 中面對兩套不同任務模型，增加認知負擔，也使 SOP、客服說明、回歸測試與截圖教學無法共用。
- owner: `product-strategy-manager` + `ui-ux-designer` + `senior-software-engineer`

### `FB2-02` 模型憑證與授權文件後續頁面不符開發者文件定位

- 分類: docs / architecture narrative gap / developer experience
- 現況: 入口頁之後的深度頁仍主要靠表格盤點與矩陣清單，缺少像 developer guide / Learn 式的文字敘事、邏輯梳理、系統邊界圖與互動示意。
- 風險: 維運者雖能找到頁面，但無法快速建立完整心智模型；遇到 callback、grant、GitHub Secrets、`AIHUB_LICENSE_KEY` 等邊界問題時，仍需自行拼湊上下文。
- owner: `product-strategy-manager` + `architecture-research-developer` + `site-reliability-engineer`

## 5) Missing Information Request

1. `FB2-01` 的「一模一樣模板」需求已足以派工，不需要再追問風格偏好；目前缺的是欄位與 modal 行為 mapping，不是 UI 方向。
2. `FB2-02` 已足以派工重寫文件骨架；目前缺的是每頁要補到何種深度的圖說與敘事最小集，這應由 PM 與架構師共同定義。

## 6) Owner Matrix

| 階段 | Owner | 交付物 |
|------|-------|--------|
| 問題收斂 | field-application-engineer | feedback triage、action item 與 closure recommendation |
| 範圍凍結 | product-strategy-manager | 第二輪修正範圍與非目標清單 |
| UI 合約 | ui-ux-designer | 模型頁與裝置頁共用模板契約 |
| 架構敘事 | architecture-research-developer | 文件需要的系統邊界圖、時序圖與資料流骨架 |
| 工程實作 | senior-software-engineer | 模型頁模板收斂與必要前端互動調整 |
| 文件重寫 | product-strategy-manager | 深度頁重寫與讀者路徑重組 |
| Operability 驗收 | site-reliability-engineer | 文件是否支撐維運判斷的走查結論 |
| 測試與 gate | testing-quality-engineer | 頁面一致性與文件品質的驗收清單 |
| 下一輪真人驗收 | usability-test-coordinator | 第三輪 findings package |

## 7) Action Items

### `ACT-01` 凍結「模板一致性」修正範圍

- Owner: `product-strategy-manager`
- 輸入資料:
  - `.github/issues/real-user-feedback-form.md`
  - `templates/pages/workspace/guide.html`
  - `templates/pages/admin/devices.html`
- 完成條件: 明確定義「我的模型頁要與我的裝置頁一致」的完成標準，包含哪些骨架必須共用、哪些欄位可差異化、哪些內容降級為次要資訊。
- 驗證方式: 產出共享模板完成定義與 out-of-scope 清單，避免又落回「只是改善、不是真正對齊」。

### `ACT-02` 產出模型頁 / 裝置頁共用模板契約

- Owner: `ui-ux-designer`
- 輸入資料:
  - `templates/pages/admin/devices.html`
  - `templates/pages/workspace/guide.html`
  - 最新真人回饋文字與畫面差異
- 完成條件: 產出 side-by-side 模板契約，定義清單區、統計卡、主 CTA、操作列、空狀態、modal 容器、成功/失敗訊息、檢視/新增模式必須一致；只允許模型欄位 schema 與文案不同。
- 驗證方式: checklist 比對後，模型頁與裝置頁的差異只能剩欄位與業務內容，不能再是不同工作流。

### `ACT-03` 將我的模型頁收斂為裝置頁同型模板

- Owner: `senior-software-engineer`
- 輸入資料:
  - `ACT-01` 範圍凍結
  - `ACT-02` 模板契約
- 完成條件: `templates/pages/workspace/guide.html` 與對應 JS 互動改為與裝置頁同型的管理模板；新增模型採同頁 modal 或等價共享容器，不再保留獨立 hero + 長流程工作台骨架。
- 驗證方式:
  - `tests/test_solution_template.py` 補或更新模板一致性契約。
  - 人工比對「空狀態、新增、取消、檢視、成功、失敗」六條路徑的交互節奏與裝置頁一致。

### `ACT-04` 凍結文件深度重寫範圍

- Owner: `product-strategy-manager`
- 輸入資料:
  - `.github/issues/real-user-feedback-form.md`
  - 三份現有文件頁
- 完成條件: 定義這次不是「再補幾個表格」，而是「入口頁保留導覽，深度頁改為敘事優先」的文件重寫邊界，並列出必須回答的核心問題。
- 驗證方式: 形成每頁的 reader job-to-be-done 與非目標清單。

### `ACT-05` 產出授權與上架的架構敘事骨架

- Owner: `architecture-research-developer`
- 輸入資料:
  - `docs/platform/advanced/model-credentials-and-authorization.md`
  - `docs/platform/advanced/authorization-and-access.md`
  - `docs/platform/advanced/model-card-publishing.md`
- 完成條件: 產出至少兩份圖說素材與敘事骨架：
  - 平台角色 / 部署授權 / 模型上架授權的邊界圖
  - Model Card 上架從草稿、grant、GitHub Actions、callback、artifact verify 到 review 的時序或狀態圖
- 驗證方式: reviewer 能不用跳三頁就說出 session、Publish Grant、callback token、`AIHUB_LICENSE_KEY` 各自位在哪個流程層。

### `ACT-06` 重寫模型憑證與授權文件群

- Owner: `product-strategy-manager`
- 輸入資料:
  - `ACT-04` 文件範圍凍結
  - `ACT-05` 架構圖與敘事骨架
- 完成條件:
  - `model-credentials-and-authorization.md` 保留為分類入口頁。
  - `authorization-and-access.md` 改為平台角色、部署授權與存取控制的文字敘事主文。
  - `model-card-publishing.md` 改為模型上架生命週期、系統邊界、失敗路徑與交互示意主文。
  - 表格退到摘要或 reference 角色，不再當正文主體。
- 驗證方式: 冷讀讀者可在單頁內回答「這頁解的是哪條主線、資料怎麼流、失敗時先查哪裡」。

### `ACT-07` 驗證文件是否支撐維運判斷

- Owner: `site-reliability-engineer`
- 輸入資料:
  - `ACT-06` 完成後的三頁文件
- 完成條件: 文件能支撐至少兩個維運情境的判斷路徑：
  - GitHub Actions callback 失敗
  - 部署者拿到 `AIHUB_LICENSE_KEY` 後仍無法啟動容器
- 驗證方式: 以 incident walkthrough 驗證讀者是否能在單一路徑中完成定位，而不是來回跳表格拼圖。

### `ACT-08` 建立頁面一致性與文件深度驗收 gate

- Owner: `testing-quality-engineer`
- 輸入資料:
  - `ACT-03` 完成物
  - `ACT-06` 完成物
- 完成條件: 補一份驗收清單，至少覆蓋：
  - 模型頁與裝置頁的模板一致性
  - 文件頁是否具備主敘事、圖說、排查路徑與 reference 分層
- 驗證方式: 新一輪真人回饋的兩條意見都能被對應到明確驗收欄位，不再只是抽象抱怨。

### `ACT-09A` CEO 提供第三輪真人測試資源

- Owner: `CEO`
- 輸入資料:
  - `ACT-03` 與 `ACT-06` 完成物
  - 新一輪真人驗收任務腳本
- 完成條件: 提供模型提供者與平台維護者受測者名單或測試管道。
- 驗證方式: 受測者名單、時段或測試平台已交給 `usability-test-coordinator`。

### `ACT-09B` 執行第三輪真人驗收並產出 findings

- Owner: `usability-test-coordinator`
- 輸入資料:
  - `ACT-03` 完成後的模型頁
  - `ACT-06` 完成後的文件頁
  - `ACT-09A` 提供的真人受測者資源
- 完成條件: 收集第三輪真人回饋，驗證：
  - 使用者是否認定我的模型與我的裝置為同一套管理模板
  - 維運者是否覺得文件深度足以支撐理解與排查
- 驗證方式: findings package 含完成率、卡點、原話、成功/失敗判定與 closure recommendation。

## 8) Verification Evidence

### 2026-06-29 執行與簽核更新

#### 已完成項目

1. `ACT-01` ~ `ACT-03`
  - 已將 `templates/pages/workspace/guide.html` 改為與 `templates/pages/admin/devices.html` 同族的管理模板：統計卡、表格清單、同頁 modal。
  - `static/js/guide.js` 已改為以表格列渲染草稿，並用 modal 承接檢視 / 新增 / 續跑流程。
2. `ACT-04` ~ `ACT-07`
  - 已將 `docs/platform/advanced/model-credentials-and-authorization.md` 收斂為分類入口頁。
  - 已將 `docs/platform/advanced/authorization-and-access.md` 與 `docs/platform/advanced/model-card-publishing.md` 重寫為敘事優先的深度頁，補上邊界、流程與失敗路徑。
3. `ACT-08`
  - 已把模板契約斷言補進 `tests/test_solution_template.py`，並用 focused regression 與 `mkdocs build --strict` 驗證。

#### 尚未完成項目

1. `ACT-09A`
  - 阻塞中。仍需 CEO 提供第三輪真人驗收受測者或測試管道。
2. `ACT-09B`
  - 尚未開始。依 SOP 必須等 `ACT-09A` 完成後，才能由 `usability-test-coordinator` 產出 findings package。

1. 直接證據
   - `.github/issues/real-user-feedback-form.md`
2. 目前頁面實作證據
   - `templates/pages/workspace/guide.html`
   - `templates/pages/admin/devices.html`
  - `static/js/guide.js`
3. 目前文件證據
   - `docs/platform/advanced/model-credentials-and-authorization.md`
   - `docs/platform/advanced/authorization-and-access.md`
   - `docs/platform/advanced/model-card-publishing.md`
4. triage 證據
   - `/site-reliability-engineer` read-only triage
   - `/usability-test-coordinator` read-only triage
5. 本地驗證證據
  - `pytest tests/test_solution_template.py -q`
  - `mkdocs build --strict`

## 9) Closure Criteria

1. 我的模型頁與我的裝置頁完成模板一致性對齊，不再只是方向相似。
2. 模型憑證與授權文件群完成敘事優先的深度重寫，不再以表格盤點充當正文主體。
3. SRE 能用文件完成至少兩條 incident walkthrough，不需在三頁間自行拼圖。
4. 第三輪真人驗收能收斂出「已符合期待」或「仍有缺口」的 findings package。

## 10) Closure Recommendation

- 目前建議: `no-go`
- 原因:
  - `FB2-01` 與 `FB2-02` 的工程與文件修正已完成本地驗證，但第三輪真人驗收尚未執行。
  - 依 SOP，`ACT-09A` / `ACT-09B` 未完成前，不可宣稱已符合真人期待並關單。

## 11) Feedback Routing Recommendation

產品型 feedback，留在本 repo 的 issues / docs / PR 討論。這不是 HR 治理型 feedback，不回收至 `feedback/session-log.md`。

## 12) Unified Metrics Contract

- reporting_week: `2026-W27`
- stream_id: `maintainer`
- owner: `field-application-engineer` / `product-strategy-manager` / `ui-ux-designer` / `architecture-research-developer` / `senior-software-engineer` / `site-reliability-engineer` / `testing-quality-engineer` / `usability-test-coordinator`
- metric_name: `second_round_real_user_feedback_closure_rate`
- baseline: `second-round real user feedback shows model page template mismatch and developer-doc narrative insufficiency`
- target: `the model page matches the device management template and the credential/authorization docs are rewritten into narrative-first developer guides`
- current: `the model page template and the credential docs have been rewritten and passed local validation; real-user acceptance is still pending`
- trend: `up`
- evidence_links: `.github/issues/real-user-feedback-form.md`, `templates/pages/workspace/guide.html`, `templates/pages/admin/devices.html`, `docs/platform/advanced/model-credentials-and-authorization.md`, `docs/platform/advanced/authorization-and-access.md`, `docs/platform/advanced/model-card-publishing.md`
- blocker: `third-round real-user validation still depends on CEO-provided participants`
- veto_status: `fail`
- closure_recommendation: `no-go`