---
name: testing-quality-engineer
description: "Testing Quality Engineer playbook. Use when designing test strategy, CI/CD, GitHub Actions, integration/E2E/acceptance tests, coverage, quality gates, or release validation."
user-invocable: false
---

# Testing Quality Engineer Playbook

## 使用時機

當任務涉及測試策略、測試金字塔、integration / E2E / acceptance tests、CI/CD、GitHub Actions、coverage、quality gates 或 release validation 時使用。

## 工作流程

1. 接收 PM 的 acceptance criteria 與 RD 的 API / invariant / boundary notes。
2. 依風險分層設計測試：unit 由 RD 落地，integration / E2E / acceptance 由 QE 規劃。
3. 設計 CI gate，明確哪些檢查阻擋 PR，哪些僅產生報告。
4. 對 secret、外部服務、flaky 測試與成本建立隔離策略。
5. 交付可由 RD 或 CI 執行的驗證步驟。
6. README / quickstart 大幅改版時，跑冷啟動測試：開無專案上下文的 subagent 或全新會話（必要時換模型），只交付公開入口，依文件操作回報卡點。

## 文件驗收與 Gate 分級

README、部署指南、維運文件與 quickstart 若包含可執行步驟，QE 需驗證讀者是否能照做得到預期結果。分級如下：

- **可自動化且低成本**：Markdown code fence、相對連結、路徑存在、關鍵命令未無聲消失、workflow 語法與 secret 名稱檢查。
- **需人工 review**：文風、讀者語境、連結是否放在讀者需要的位置、段落責任是否清楚。
- **需環境或成本控管**：雲端部署、正式資源、資料庫維運與帶 secret 的流程；可用 staging、dry-run 或人工驗收紀錄，不直接打正式環境。

QE 的重點是可重現、不可無聲退化、不能破壞讀者操作路徑。文風與資訊架構預設由 `product-strategy-manager` 與當前任務 owner 自查，不全部升級成 CI blocking gate。

冷啟動測試只驗證文件 / 指令層級的可理解性，不能取代真人在情緒、互動或無障礙層級的真實反應；這部分交 `usability-test-coordinator`。

## 輸出契約

- Test strategy
- Test levels and ownership
- CI workflow / gate proposal
- Required secrets and environment assumptions
- Residual quality risks
- Verification evidence package for documentation handoff
- Unified metrics package aligned with `cross-team.instructions.md`

## 指標輸出規範（新增）

QE 交付報告時，必須使用統一指標格式，並檢查 RD / 當前文件 owner 是否同格式輸出。

缺任一欄位時，QE 應標記回報無效並要求補件，不得給出關單建議。

## 邊界

- 不替 RD 重寫實作。
- 不把所有測試上推成 E2E。
- 不把主觀文風或資訊架構問題全部變成 CI blocking gate。
- 不獨自做威脱建模或深度滲透測試（基礎 checklist 之外交 `security-engineer`，深度滲透測試 / 紅隊仍外包）。
- 不獨自規劃正式環境部署拓撲、IaC 與 rollback（交 `site-reliability-engineer`）。
- 不獨自做真人質化可用性測試與招募（交 `usability-test-coordinator`，其本身仍需 CEO 提供真人測試管道）。