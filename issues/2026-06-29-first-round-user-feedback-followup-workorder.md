# [Work Order] 第一輪真人使用回饋跟進施工單

- Work Order ID: WO-2026-06-29-05
- 日期: 2026-06-29
- Stream ID: maintainer
- 範圍: 第一輪真人使用回饋的工程跟進與驗收規劃
- 來源: `real-user-feedback-form.md` 第一輪回填 + `/site-reliability-engineer` + `/usability-test-coordinator` read-only triage
- 目前狀態: Superseded by newer feedback
- 目前階段: 第二輪真人回饋已否定部分完成判定，後續施工轉移至 `WO-2026-06-29-07`
- 下一位 owner: field-application-engineer

## 1) Issue Classification

產品型 feedback。這不是新的藍圖需求，而是第一輪真人回饋已指出可重現的產品缺陷、文件架構缺口與資訊架構負擔，需要收斂為新的施工單。

## 2) Reproduction Status

1. CI failure 可直接重現。
   - `unit-tests` workflow 失敗，`tests/test_api_error_contract.py` 期待 `FORBIDDEN`，實際收到 `PERMISSION_DENIED`。
2. 模型頁面認知負擔問題目前來自第一輪真人回饋。
   - 使用者明確指出現有模型頁與其他頁面心智模型不一致，希望改成類似「我的裝置」的列表 + 新增視窗流程。
3. 平台維運文件的「模型憑證與授權」分類缺口可從 GitHub Pages 導覽重現。
   - 平台維運下沒有一個可一眼辨識的授權 / 憑證分類中心，維護者很難快速找到完整邏輯。

## 3) Frozen Input Contract

1. 第一輪真人回饋來源
   - `.github/issues/real-user-feedback-form.md`
2. 現有平台 / 開發者文件
   - `docs/platform/github_cicd_workflow.md`
   - `docs/platform/advanced/model-card-publishing.md`
   - `docs/model-provider/index.md`
   - `mkdocs.yml`
3. 直接可重現的測試失敗證據
   - `tests/test_api_error_contract.py`
   - GitHub Actions `unit-tests` failure log
4. 不在本單內處理
   - 真人受測者招募本身
   - Model Card 發布後端核心功能重寫
   - 未經 PM 凍結就直接承諾完整 repo 自動建立或大型 wizard 範圍

## 4) Findings

### `FB-01` 403 錯誤語彙與測試契約分裂

- 分類: bug / CI / contract regression
- 現況: `tests/test_api_error_contract.py` 期待 `FORBIDDEN`，但 model-card publish admin route 實際回 `PERMISSION_DENIED`，造成 `unit-tests` workflow fail。
- 風險: CI 失敗、對外 API 錯誤語彙不一致、文件與測試心智模型分裂。
- owner: `senior-software-engineer` + `testing-quality-engineer`

### `FB-02` 模型頁資訊架構與其他資產頁不一致

- 分類: usability / information architecture
- 現況: 第一輪真人回饋指出模型頁仍停留在過期的步驟式心智模型，與「我的裝置」型列表管理頁差異過大，導致過重的認知負擔。
- 風險: 模型提供者不知道目前狀態、下一步動作與新增模型入口，增加平台介入成本。
- owner: `product-strategy-manager` + `ui-ux-designer` + `senior-software-engineer`

### `FB-03` 平台維運文件缺少「模型憑證與授權」分類中心

- 分類: docs / operability / discoverability
- 現況: GitHub Pages 中雖有授權與上架相關頁，但沒有一個明確分類能讓平台維護者快速辨識「模型憑證與授權」的完整邏輯。
- 風險: 維運者找不到 Publish Grant、ACR credential、callback token、部署 `AIHUB_LICENSE_KEY` 的邊界，造成誤用與支持成本上升。
- owner: `product-strategy-manager` + `site-reliability-engineer`

## 5) Missing Information Request

1. `FB-02` 目前只有第一輪真人文字回饋，尚缺畫面操作錄影或逐步 click path；可先做第一版 IA 與頁面方案，但不要宣稱已完成 usability closure。
2. `FB-03` 已足以做文件分類重整，但若要做最終導覽驗收，仍需第二位非核心維護者做冷啟動走查。

## 6) Owner Matrix

| 階段 | Owner | 交付物 |
|------|-------|--------|
| 問題收斂 | field-application-engineer | feedback triage、action item 與 closure recommendation |
| 範圍凍結 | product-strategy-manager | 模型頁改版 MVP 邊界與 out-of-scope |
| IA / UX 設計 | ui-ux-designer | 模型頁列表 / 新增流程設計稿 |
| 工程實作 | senior-software-engineer | CI 契約修正、模型頁行為調整、文件入口實作 |
| 維運觀點驗收 | site-reliability-engineer | 平台授權 / 憑證文件可發現性驗收 |
| 測試與 gate | testing-quality-engineer | CI / docs 契約檢查與 regression gate |
| 文件回寫 | product-strategy-manager | Pages 導覽與授權分類中心 |
| 第二輪真人驗收 | usability-test-coordinator | 新 IA / 新文件的下一輪 findings package |

## 7) Action Items

### `ACT-01` 對齊 403 錯誤契約

- Owner: `senior-software-engineer`
- 輸入資料:
  - `tests/test_api_error_contract.py`
  - `utils/routes/model_card_publish_routes.py`
  - `utils/routes/api_errors.py`
- 目前狀態: Completed
- 完成條件: 403 的對外語彙只保留一套規則；測試、route 與共用 error handler 不再分裂成 `FORBIDDEN` / `PERMISSION_DENIED` 兩套心智模型。
- 驗證方式: `pytest tests/test_api_error_contract.py tests/test_model_card_publish_routes.py -q` 通過。
- 完成證據: `tests/test_api_error_contract.py` 已改為與 `model_card_publish_routes.py` 對齊，focused pytest `35 passed`。

### `ACT-02` 為錯誤契約建立 regression gate

- Owner: `testing-quality-engineer`
- 輸入資料:
  - `tests/test_api_error_contract.py`
  - `unit-tests` workflow 現況
- 目前狀態: Completed
- 完成條件: 若未來再出現 403 錯誤碼語彙漂移，CI 能直接失敗並指出契約破口。
- 驗證方式: 以本地或 CI 重新執行對應測試；故意模擬錯誤碼漂移時測試可失敗。
- 完成證據: 既有 `tests/test_api_error_contract.py` 已持續充當 regression gate；本次重跑 `pytest tests/test_api_error_contract.py tests/test_model_card_publish_routes.py -q` 成功，確認 CI gate 恢復有效。

### `ACT-03` 凍結模型頁改版 MVP 範圍

- Owner: `product-strategy-manager`
- 輸入資料:
  - 第一輪真人回饋中的模型頁建議
  - 現有 `docs/model-provider/index.md` 路徑
- 目前狀態: Completed
- 完成條件: 明確定義第一版只處理哪些事，例如「列表管理 + 新增模型草稿 + 產生 yaml / template repo 指引」，並列出不做事項，例如「直接代建 GitHub repo」若未核准則不納入。
- 驗證方式: 產出可供 RD / QE 使用的範圍清單與 out-of-scope 清單。
- 完成證據:
   - Problem statement: `/guide` 目前仍是過時的 Step 1 / Step 2 大表單，第一版需改成「我的模型」列表導向工作台，讓使用者先看到資產、狀態與下一步。
   - In-scope for MVP:
      - `/guide` 改為列表導向的「我的模型」工作台。
      - 提供明確「新增模型」入口。
      - 每筆模型可顯示狀態與下一步。
      - 保留既有 create draft / export yaml / create publish grant 核心能力。
      - 若現有後端沒有草稿清單 API，補最小讀取能力支撐列表首頁。
   - Out-of-scope for MVP:
      - 不納入自動建立 GitHub template repo。
      - 不重做完整 callback / 審核 / catalog sync 流程。
      - 不把 `/guide` 擴張成大型 wizard 或多角色管理頁。
   - Acceptance criteria:
      - `/guide` 首頁不再以 Step 1 / Step 2 作為主視覺與主文案。
      - 已登入使用者可看到自己的模型列表或可操作空狀態。
      - 使用者可從明確入口建立新 draft。
      - 每筆 draft 可看懂目前狀態與下一步。
      - 現有 create / export / grant 核心價值在新頁面中仍可操作。

### `ACT-04` 設計模型頁新 IA 與新增流程

- Owner: `ui-ux-designer`
- 輸入資料:
  - 第一輪真人回饋
  - 現有「我的裝置」頁心智模型
- 目前狀態: Completed
- 完成條件: 產出列表頁資訊架構、狀態欄位、主要 CTA、空狀態，以及新增模型 modal / panel 的欄位設計。
- 驗證方式: 用任務走查確認使用者能完成「看懂目前狀態、找到下一步、知道怎麼新增模型」。
- 完成證據:
   - 頁面資訊架構:
      - 頁首摘要區
      - 篩選與搜尋區
      - 模型草稿列表區
      - 詳情區 / 進度摘要區
      - 輔助資源區
   - 每筆列表至少顯示:
      - 模型名稱、`model_id`、版本、草稿狀態、最後更新時間、yaml 狀態、publish grant 狀態、主要下一步。
   - 主要 CTA 與狀態流轉:
      - `draft`: 編輯草稿 / 下載 YAML
      - `package_ready`: 下載 YAML / 建立發布憑證
      - `grant_issued`: 查看發布設定
      - 其餘狀態以「現在在哪裡 + 下一步」摘要呈現，不把所有內部狀態碼直接暴露給新手。
   - 新增模型互動建議:
      - 採 `modal + 建立後進詳情區` 的兩段式互動。
      - 第一版 modal 只收最小必要欄位，不引入大型 wizard。
   - 無障礙與認知負擔要求:
      - 狀態不可只靠顏色。
      - 列表操作命名直接。
      - modal 需具備焦點陷阱、Esc 關閉與返回焦點。

### `ACT-05` 實作模型頁第一版改版

- Owner: `senior-software-engineer`
- 輸入資料:
  - `ACT-03` 的範圍凍結結果
  - `ACT-04` 的設計稿
- 目前狀態: Completed
- 完成條件: 模型頁改成資產列表導向，新增模型入口改為可直接啟動資料收集流程，不再讓使用者從過期雙步驟頁面猜測下一步。
- 驗證方式: 相關 route / template / page 行為測試通過；人工走查空列表、已有草稿、grant issued 三種狀態。
- 已完成子項:
   - 已補最小 `GET /api/me/model-card-drafts` API，作為列表首頁的資料來源。
   - 已新增 route test 固定住 drafts list 契約。
- `/guide` 已改成「模型草稿清單 + 右側工作台」的列表導向首頁，不再以 Step 1 / Step 2 做為主視覺入口。
- 已新增既有草稿選取、新增模型入口、選取摘要與下一步提示。
- 驗證證據:
   - `pytest tests/test_model_card_publish_routes.py tests/test_api_error_contract.py -q` 通過，`36 passed`。
   - `pytest tests/test_model_card_publish_routes.py tests/test_api_error_contract.py tests/test_solution_template.py -q` 通過，`68 passed`。
   - `static/js/guide.js`、`templates/pages/workspace/guide.html`、`utils/routes/workspace_page_routes.py` 診斷無錯誤。

### `ACT-06` 建立「模型憑證與授權」文件分類中心

- Owner: `product-strategy-manager`
- 輸入資料:
  - `mkdocs.yml`
  - `docs/platform/advanced/model-card-publishing.md`
  - 既有授權 / 權限文件
- 目前狀態: Completed
- 完成條件: GitHub Pages 導覽中可直接看見「模型憑證與授權」分類，並能從分類中心導到 Publish Grant、GitHub Secrets/Variables、callback token、部署 `AIHUB_LICENSE_KEY` 等頁面。
- 驗證方式: 非核心維護者可在兩次點擊內找到「上架憑證與部署授權的差異」。
- 完成證據:
   - 已新增 `docs/platform/advanced/model-credentials-and-authorization.md` 作為分類入口。
   - `mkdocs.yml` 已新增「模型憑證與授權」導覽群組。
   - `docs/platform/index.md`、`authorization-and-access.md`、`model-card-publishing.md` 已回指分類入口。

### `ACT-07` 驗證文件可發現性與維運閱讀路徑

- Owner: `site-reliability-engineer`
- 輸入資料:
  - `ACT-06` 完成後的 Pages 導覽
  - 平台維運文件站
- 目前狀態: Completed
- 完成條件: 平台維護者能從文件站快速釐清 Publish Grant、ACR credential、callback token 與部署 `AIHUB_LICENSE_KEY` 的邊界。
- 驗證方式: 冷啟動走查一個任務，例如「找出模型上架要填的 GitHub Secrets 與部署時要注入的 License 差異」，確認路徑清楚。
- 完成證據:
   - `mkdocs build --strict` 通過。
   - `testing-quality-engineer` 冷啟動驗收結論：`pass`。
   - 驗收路徑：從「平台維運 > 維運入口」1 次點擊到「模型憑證與授權」分類頁，再於第 2 次點擊到 `授權與權限體系` 或 `Model Card 上架` 細節頁，可在兩次點擊內找到並釐清上架憑證與部署授權差異。
   - Residual risk：若維護者直接 deep-link 到 `GitHub CI/CD`，仍可能把平台部署 CI/CD 與模型上架 CI/CD 混看，但已不構成 blocking issue。

### `ACT-08A` CEO 提供第二輪真人測試資源

- Owner: `CEO`
- 輸入資料:
   - `ACT-05` / `ACT-06` / `ACT-07` 完成證據
   - 第二輪真人測試 protocol
- 目前狀態: Blocked on CEO resource
- 完成條件: 提供模型提供者與平台維護者受測者名單或測試管道，讓第二輪 protocol 可執行。
- 驗證方式: 受測者名單、時段或測試管道已交付給 `usability-test-coordinator`。
- 目前阻塞: 外部參與者尚未提供。

### `ACT-08B` 執行第二輪真人驗收並產出 findings

- Owner: `usability-test-coordinator`
- 輸入資料:
  - `ACT-04` / `ACT-05` / `ACT-06` 完成物
  - `real-user-feedback-form.md`
- 目前狀態: Ready, waiting for participants
- 完成條件: 第二輪真人測試聚焦於模型頁新 IA 與文件新導覽，明確驗證是否降低認知負擔。
- 驗證方式: 依 protocol 執行任務、收集錄影 / 計時 / 路徑 / 原話，並輸出 findings package。
- 第二輪 protocol:
   - 測試目標:
      - 驗證模型頁列表導向工作台是否讓模型提供者更容易分辨「續跑既有草稿」與「另建新草稿」。
      - 驗證平台維護者是否能在兩次點擊內分清 Publish Grant、callback token、GitHub Secrets 與 `AIHUB_LICENSE_KEY` 邊界。
   - 受測者條件:
      - A 組：模型提供者 3-5 人，熟悉 GitHub repo / CI 基本操作，但未參與本次改版。
      - B 組：平台維護者 3-5 人，負責平台文件或維運排障，但未參與本次資訊架構撰寫。
   - 任務腳本:
      - 任務 1：續跑既有草稿。
      - 任務 2：建立新草稿。
      - 任務 3：從文件站找到 callback token 與 GitHub Secrets 邊界。
      - 任務 4：分辨 `AIHUB_LICENSE_KEY`、Publish Grant、callback token 的用途。
   - 成功門檻:
      - 模型頁任務成功率至少 80%。
      - 文件邊界任務成功率至少 80%。
      - 至少 70% 受測者能自行口述「續跑既有草稿」與「另建新草稿」差異。
   - 證據欄位:
      - 測試日期、版本、受測者代號、角色、任務完成與否、完成時間、點擊路徑、是否需提示、誤解點、受測者原話、主持人觀察。
- 目前阻塞: `ACT-08A` 尚未完成，因此 findings package 尚不能產出。

## 8) Verification Evidence

1. 直接證據
   - `.github/issues/real-user-feedback-form.md`
   - `tests/test_api_error_contract.py`
   - GitHub Actions `unit-tests` failure log
2. 文件與導覽證據
   - `docs/platform/github_cicd_workflow.md`
   - `docs/platform/advanced/model-card-publishing.md`
   - `docs/model-provider/index.md`
   - `mkdocs.yml`
3. 後續驗收證據
   - 修正後的 CI 綠燈結果
   - 更新後的 Pages 導覽截圖或走查紀錄
   - 第二輪真人回饋摘要

## 9) Closure Criteria

1. `FB-01` 的 CI failure 已解除，且 403 契約有單一真相源。
2. `FB-02` 有 PM 凍結範圍、UI/UX 設計稿與第一版工程落地證據。
3. `FB-03` 的文件分類中心已在 Pages 導覽可見，且維護者可完成冷啟動走查。
4. FAE 能基於證據更新 closure recommendation；若第二輪真人驗收尚未完成，需明確標註 remaining gate。

## 9A) 本輪執行與簽核紀錄

| 路徑 | 結果 | 簽核 |
| --- | --- | --- |
| `FB-01` CI 錯誤契約 | 已完成修正並通過 focused pytest。 | `senior-software-engineer` 完成；`testing-quality-engineer` 驗證通過。 |
| `FB-02` 模型頁改版規劃與第一版實作 | PM scope freeze、UI IA handoff、drafts list API 與 `/guide` 列表化第一版已完成。 | `product-strategy-manager`、`ui-ux-designer`、`senior-software-engineer` 已完成本輪簽核。 |
| `FB-03` 文件分類中心 | 已完成分類入口與站內回指，並通過冷啟動走查。 | `product-strategy-manager` 協調完成；`testing-quality-engineer` 冷啟動 signoff 通過。 |
| 第二輪真人驗收 | protocol 已完成，但 findings 仍待 CEO 提供受測者後執行。 | `usability-test-coordinator` 已完成 protocol；`CEO` 待提供資源。 |

## 10) Feedback Routing Recommendation

產品型 feedback，留在本 repo 的 issues / docs / PR 討論。這不是 HR 治理型 skill 落差，不回收至 `feedback/session-log.md`。

## 11) Unified Metrics Contract

- reporting_week: `2026-W27`
- stream_id: `maintainer`
- owner: `field-application-engineer` / `product-strategy-manager` / `ui-ux-designer` / `senior-software-engineer` / `site-reliability-engineer` / `testing-quality-engineer` / `usability-test-coordinator`
- metric_name: `first_round_user_feedback_closure_rate`
- baseline: `first-round user feedback uncovered CI contract drift, model-page IA burden, and missing credential/auth documentation classification`
- target: `all first-round feedback items have owner, implementation evidence, and a clear second-round validation path`
- current: `FB-01 已修正並通過 focused pytest；FB-02 已完成列表化第一版與 drafts list API；FB-03 已完成分類入口並通過冷啟動走查；僅剩第二輪真人驗收待外部參與者`
- trend: `up`
- evidence_links: `.github/issues/real-user-feedback-form.md`, `tests/test_api_error_contract.py`, `docs/platform/github_cicd_workflow.md`, `docs/platform/advanced/model-card-publishing.md`, `docs/model-provider/index.md`, `mkdocs.yml`
- blocker: `第二輪真人驗收仍待 CEO 提供受測者與測試管道`
- veto_status: `fail`
- closure_recommendation: `no-go`