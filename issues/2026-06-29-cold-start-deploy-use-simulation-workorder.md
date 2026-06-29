# [Work Order] 冷啟動新手部署沙盤推演跟進施工單

- Work Order ID: WO-2026-06-29-06
- 日期: 2026-06-29
- Stream ID: provider
- 範圍: blueprint 理想使用情境下的 deploy-and-use 冷啟動風險收斂
- 來源: `/field-application-engineer` + `/site-reliability-engineer` + `/usability-test-coordinator` 沙盤推演
- 目前狀態: Open
- 目前階段: heuristic triage 完成，等待 scope freeze 與施工派工
- 下一位 owner: product-strategy-manager

## 1) Issue Classification

產品型 feedback。這張工單來自文件 / 指令 / 驗收路徑的冷啟動沙盤推演，不是真人 findings。目的不是宣稱「已完成 usability 驗證」，而是在真正招募受測者之前，先把最可能阻塞新手的高風險缺口收斂成可施工 action items。

## 2) Simulation Boundary

1. 本單依據現有 blueprint、model-provider 文件與 deploy-and-use 協定做 heuristic / cold-start simulation。
2. 本單不是 `usability-test-coordinator` 的真人 findings package。
3. 本單可用來安排文件、工程、維運與驗收施工，但不能拿來宣稱 naive user 已成功完成任務。

## 3) Frozen Input Contract

1. 文件入口與理想路徑
   - `docs/model-provider/index.md`
   - `docs/model-provider/packaging-quickstart.md`
   - `docs/model-provider/deploy-usability-test-protocol.md`
2. blueprint 設計前提
   - `.github/blueprint/07-documentation-and-operations-sop.md`
3. 不在本單內直接處理
   - 編造真人使用者原話或情緒訊號
   - 未經 PM scope freeze 就擴張成大型 onboarding wizard
   - 未經 CEO 提供真人管道就宣稱完成 usability closure

## 4) Findings

### `SIM-01` Bash-only 指令會讓 Windows / 非 Bash 新手在建置前就卡住

- 分類: docs / operability / platform mismatch
- 現況: `docs/model-provider/packaging-quickstart.md` 使用 `mapfile -t ... < <(...)` 這類 Bash 專屬語法。
- 風險: Windows / PowerShell 使用者即使理解流程，也可能在第一個 build 指令前失敗，誤以為是 Docker 或模型問題。
- owner: `product-strategy-manager` + `senior-software-engineer` + `site-reliability-engineer`

### `SIM-02` 同一頁同時混寫 provider packaging 與 end-user deploy-and-use

- 分類: information architecture / docs
- 現況: `packaging-quickstart.md` 同時宣告自己覆蓋「本機封裝驗收」與「end-user deploy-and-use 最小可行路徑」。
- 風險: 新手無法判定自己此刻是在做上架準備、容器驗收，還是最終部署使用，容易把不同角色的責任混成一條路。
- owner: `product-strategy-manager`

### `SIM-03` 憑證與授權心智模型太密集，使用者必須先懂四種值才有第一個成功點

- 分類: usability / docs / runtime onboarding
- 現況: 文件雖有憑證分層表，但新手仍需在首次成功前同時理解 `AIHUB_ACR_USERNAME` / `AIHUB_ACR_PASSWORD`、`AIHUB_CALLBACK_TOKEN`、`AIHUB_LICENSE_KEY`、`OPENAI_API_KEY` 與固定 tag / digest 的差異。
- 風險: 使用者把 Publish Grant secret、runtime license 與 client placeholder 混用，造成錯誤定位困難。
- owner: `senior-software-engineer` + `site-reliability-engineer` + `product-strategy-manager`

### `SIM-04` 理想路徑缺少單一進度板，使用者必須自己拼接跨頁前置條件

- 分類: docs / task flow / validation
- 現況: 使用者需在 `index.md`、`packaging-quickstart.md` 與 `deploy-usability-test-protocol.md` 之間自行推理「現在做到哪裡、下一步是什麼、何時才算可進入真人驗收」。
- 風險: 可能把 `/healthz` ready 誤判為整條路徑完成，或不知道何時該轉交維運 / QE / usability。
- owner: `product-strategy-manager` + `testing-quality-engineer`

## 5) Missing Information Request

1. 本單只有 heuristic triage，尚缺真人原始紀錄。
2. 若要關閉本單或宣稱 deploy-and-use 對新手已順暢，仍需第二階段真人驗收。
3. 若 Windows 是目標平台之一，需明確決定文件要提供 PowerShell 等效路徑，或宣告目前只支援 Bash / Linux。

## 6) Owner Matrix

| 階段 | Owner | 交付物 |
|------|-------|--------|
| 問題收斂 | field-application-engineer | heuristic triage、issue 結構、closure gate 整理 |
| 範圍凍結 | product-strategy-manager | 讀者切分、第一版修正範圍、out-of-scope |
| 文件重構 | product-strategy-manager | 單一路徑、角色切分、進度板與命令入口 |
| 工程支援 | senior-software-engineer | shell 相容輔助、env preflight、必要腳本 |
| 維運驗收 | site-reliability-engineer | deploy 路徑、rollback 路徑、平台相容性 signoff |
| 文件 / 指令 gate | testing-quality-engineer | 冷啟動命令驗證與 regression gate |
| 真人驗收 | usability-test-coordinator | findings package |
| 外部資源提供 | CEO | 受測者管道、測試平台或招募資源 |

## 7) Action Items

### `ACT-01` 凍結讀者切分與第一版修正範圍

- Owner: `product-strategy-manager`
- 輸入資料:
  - `docs/model-provider/index.md`
  - `docs/model-provider/packaging-quickstart.md`
  - 本工單 Findings
- 完成條件: 明確定義第一版是要修「provider packaging 路徑」、「end-user deploy-and-use 路徑」，或兩者以何種入口切開。
- 驗證方式: 產出 reader split、MVP 修正範圍與 out-of-scope，不再讓同一頁同時扮演多角色入口。
- 狀態: Open

### `ACT-02` 提供 shell 相容命令路徑

- Owner: `product-strategy-manager` + `senior-software-engineer`
- 輸入資料:
  - `docs/model-provider/packaging-quickstart.md`
  - `tools.generate_oci_labels`
- 完成條件: 文件提供至少一條新手可直接執行的正式 build 路徑，不依賴 Bash 專屬語法；若要保留 Bash 範例，需同步提供 PowerShell 等效方式或 shell-agnostic script。
- 驗證方式: 在 Windows / PowerShell 與 Bash 任一目標環境中，能完成 build 指令準備且不需自行改寫語法。
- 狀態: Open

### `ACT-03` 建立 deploy-and-use 憑證預檢與決策表

- Owner: `senior-software-engineer` + `site-reliability-engineer` + `product-strategy-manager`
- 輸入資料:
  - `docs/model-provider/packaging-quickstart.md`
  - `docs/model-provider/deploy-usability-test-protocol.md`
- 完成條件: 在第一次 `docker run` 前，使用者可透過單一預檢表或工具確認自己手上的值要放到哪裡，並得到下一步提示。
- 驗證方式: 新手不需回頭查多頁文字，就能分辨 ACR credential、callback token、runtime license 與 Open WebUI placeholder。
- 狀態: Open

### `ACT-04` 建立單一進度板與關鍵驗收節點

- Owner: `product-strategy-manager` + `testing-quality-engineer`
- 輸入資料:
  - `docs/model-provider/index.md`
  - `docs/model-provider/packaging-quickstart.md`
  - `docs/model-provider/deploy-usability-test-protocol.md`
- 完成條件: 提供一份單一 checklist 或導航板，讓使用者知道目前所處步驟、前置條件、唯一正式驗證路徑與何時需要轉入真人驗收。
- 驗證方式: 冷啟動走查時，使用者可在單頁確認「現在在哪裡、下一步是什麼、完成什麼才算過關」。
- 狀態: Open

### `ACT-05A` 提供真人受測管道

- Owner: `CEO`
- 輸入資料:
  - `docs/model-provider/deploy-usability-test-protocol.md`
  - 本工單 Findings 與修正後文件
- 完成條件: 提供 beta 名單、測試平台、招募預算或內部非核心維護者名單。
- 驗證方式: 工單內能列出受測者來源與測試批次安排。
- 狀態: Blocked

### `ACT-05B` 補齊真人 findings package

- Owner: `usability-test-coordinator`
- 輸入資料:
  - 修正後的 deploy-and-use 路徑
  - `docs/model-provider/deploy-usability-test-protocol.md`
- 完成條件: 產出可追溯 findings package，驗證上述冷啟動風險是否真的被消除。
- 驗證方式: 受測者輪廓、任務完成率、卡點、情緒訊號與分流 owner 完整可追溯。
- 狀態: Blocked on `ACT-05A`

## 8) Verification Evidence Required

1. 文件與藍圖證據
   - `docs/model-provider/index.md`
   - `docs/model-provider/packaging-quickstart.md`
   - `docs/model-provider/deploy-usability-test-protocol.md`
   - `.github/blueprint/07-documentation-and-operations-sop.md`
2. Shell 相容證據
   - Windows / PowerShell 或等效目標環境的可執行命令證據
3. 路徑驗收證據
   - 單一進度板 / checklist
   - 憑證預檢或決策表
4. 真人驗收證據
   - `usability-test-coordinator` findings package

## 9) Closure Criteria

1. `SIM-01` 到 `SIM-04` 都有明確 owner、施工完成物與驗證證據。
2. 冷啟動路徑不再要求新手自行改寫 Bash-only 指令或自行猜測角色切分。
3. FAE 能基於同一張工單整理 closure recommendation。
4. 若要宣稱 deploy-and-use 對新手已通過，必須補上 `ACT-05A` 與 `ACT-05B` 的真人驗收證據；僅完成 heuristic triage 不得直接關單為 pass。

## 10) Feedback Routing Recommendation

產品型 feedback，留在本 repo 的 issues / docs / PR 討論。這不是 HR 治理型 skill 落差，不回收至 `feedback/session-log.md`。

## 11) Unified Metrics Contract

- reporting_week: `2026-W27`
- stream_id: `provider`
- owner: `field-application-engineer` / `product-strategy-manager` / `senior-software-engineer` / `site-reliability-engineer` / `testing-quality-engineer` / `usability-test-coordinator` / `CEO`
- metric_name: `cold_start_deploy_use_risk_closure_rate`
- baseline: `ideal blueprint path still contains shell-specific commands, mixed reader paths, dense credential mental model, and fragmented progress checkpoints`
- target: `cold-start newcomer can complete the intended path without shell mismatch, role confusion, or credential misuse before real-user validation starts`
- current: `heuristic triage completed; engineering and docs follow-up not started`
- trend: `flat`
- evidence_links: `docs/model-provider/index.md`, `docs/model-provider/packaging-quickstart.md`, `docs/model-provider/deploy-usability-test-protocol.md`, `.github/blueprint/07-documentation-and-operations-sop.md`