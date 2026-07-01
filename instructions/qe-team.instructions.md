---
description: "Use when discussing testing strategy, test pyramid, CI/CD workflows, GitHub Actions, GitHub Pages deployment, test coverage, integration/E2E/acceptance tests, secret management, threat modeling, OWASP review, dependency vulnerabilities (CVE), deployment topology, infrastructure as code, monitoring/alerting, incident response, rollback, quality metrics, GitHub Issue triage, user bug reports, reproduction, debug closure, usability testing, user research, beta testing recruitment screeners, or cold-start / fresh-eyes documentation walkthroughs. Defines QE authority boundaries, test quadrants, CI gates, security review, operability, usability testing, and FAE issue routing."
applyTo: "**/{tests,test,__tests__,e2e,integration}/**, **/*.{test,spec}.{ts,tsx,js,jsx,py}, .github/workflows/**, **/infra/**, **/*.{tf,bicep}"
---

# QE 部門共通準則

QE 部門負責 V-Model 右翼「做了對的嗎」。本檔只保留 QE 共通規則：測試分層、CI gate、文件驗收、指標欄位與角色分流。資安、維運、issue triage、真人可用性測試的深度流程回各自 agent / skill。

員工：`testing-quality-engineer`、`field-application-engineer`、`security-engineer`、`site-reliability-engineer`、`usability-test-coordinator`。完整角色定義見 `.github/agents/`；本檔與 `.github/agents/` 共同提供 VS Code Copilot 的完整工作流。

| 員工 | 這裡只記角色入口 |
|------|----------------|
| `testing-quality-engineer` | 測試策略、CI/CD、驗收設計、冷啟動文件測試 |
| `field-application-engineer` | GitHub Issue 入口與 closure recommendation |
| `security-engineer` | 資安審查、威脅建模、CVE 分流 |
| `site-reliability-engineer` | 部署拓撲、IaC、監控告警、rollback |
| `usability-test-coordinator` | 真人可用性測試協定與 findings |

## 一、測試四象限分流

| 象限 | 測試類型 | 執行載體 | 觸發時機 |
|------|---------|---------|---------|
| 商務 × 支援設計 | E2E / UI / 驗收 | GitHub Action + GitHub Pages | PR + merge to main |
| 商務 × 評估專案 | 探索性測試 | 本地手動，QE 主導 | 重大發布前 |
| 技術 × 支援設計 | 整合 / 服務 / 單元 | GitHub Action（純自動化） | 每次 push |
| 技術 × 評估專案 | 非功能性（壓力 / 跨平台 / 安全） | 子專案 `scripts/` 本地腳本 | 開發者按需執行 |

## 二、測試金字塔

底層大量、頂層少量，建議比例 70 / 20 / 10。

```
        E2E (10%)         ← 慢、貴、稀少；只覆蓋關鍵商業流程
       ──────────
      整合 (20%)          ← 中等成本；驗證模組間協作
     ──────────────
    單元 (70%)            ← 快、準、便宜；覆蓋邏輯細節
   ──────────────────
```

**反金字塔（冰淇淋甜筒）**：E2E 多、單元少，是 QE 失敗的最強指標。發現此模式須立即向 `architecture-research-developer` 反映重構需求。

## 三、GitHub Action 規範

### 觸發條件

| 事件 | 執行內容 |
|------|---------|
| PR opened / synchronize | 單元 + 整合測試（快速反饋） |
| Merge to main | 完整測試套件（含 E2E、效果驗證） |

### Workflow 檔案位置

子專案的 `.github/workflows/`，依測試類型獨立檔案：

- `unit-tests.yml`
- `integration-tests.yml`
- `e2e-tests.yml`（merge to main 才觸發）

### CI 擋 PR 規則

| 失敗類型 | 動作 |
|---------|------|
| 單元測試失敗 | 擋 PR |
| 整合測試失敗 | 擋 PR |
| E2E 測試失敗 | 警示但不擋（E2E 偶發失敗常見，需人工判斷） |
| 非功能性測試失敗 | 警示但不擋（屬本地手動測試範疇） |

## 四、機密資訊管理

機密絕對不入版控。流程：

1. **機密註冊**：API KEY、token 進 GitHub Repository Secrets
2. **Workflow 注入**：在 `.github/workflows/*.yml` 透過 `${{ secrets.KEY_NAME }}` 引用，build 時寫入 `.env`
3. **版控隔離**：`.env` 永遠在 `.gitignore`；本機開發提供 `.env.example` 範本（不含真值）
4. **Pages 前端**：需要 KEY 時走 Action build-time 注入，不直接把 KEY 暴露在前端 JS

```yaml
- name: Build with secrets
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: |
    echo "API_KEY=$API_KEY" > .env
    npm run build
```

機密的註冊與隔離流程由 `testing-quality-engineer` 維護；輪替、最小權限與風險分級由 `security-engineer` 深入審查。

## 五、QE 角色分流

- 資安審查、威脅建模、CVE 分流：交 `security-engineer`
- 部署拓撲、IaC、監控告警、rollback：交 `site-reliability-engineer`
- GitHub Issue intake、重現資訊、closure recommendation：交 `field-application-engineer`
- 真人可用性測試、screener、訪談與 findings：交 `usability-test-coordinator`
- `testing-quality-engineer` 保留 QE 共通責任：測試策略、CI gate、驗收設計、冷啟動文件測試

## 六、與 RD 部門的協作面

### RD → QE 的接收清單

收到 RD 交棒的設計文件時：

- [ ] API 規格是否可測（能 mock 嗎、副作用能隔離嗎）
- [ ] 不變式是否可斷言（能轉成 assertion 嗎）
- [ ] 邊界條件是否完整（極大值、極小值、空輸入、非法輸入）
- [ ] 依賴關係圖是否標明外部服務（哪些 mock、哪些真實呼叫）
- [ ] `database-architect` 的資料完整性約束是否可斷言（schema facts package）
- [ ] 關聯式 schema 是否有至少 3NF 的判定，或已附上偏離 3NF 的理由、風險與回退條件
- [ ] `ui-ux-designer` 的無障礙基準是否可驗證（design facts package）

任一不滿足 → 退回 RD 補齊，不勉強寫測試。

### QE → RD 的回饋面

- 發現反金字塔 → 向 `architecture-research-developer` 提 refactor 建議
- 發現測試耦合 private 細節 → 向 `senior-software-engineer` 提重構建議
- **QE 不直接改 RD 程式碼**，只提建議

## 七、與 PM 部門的接件面

- 上游：QE 接受 `product-strategy-manager` 的驗收標準，轉為可執行 E2E 測試
- 下游：測試報告交回 `product-strategy-manager` 由其翻譯為對外語言
- 依賴：QE 自身引入新測試框架（Cypress / Playwright / k6）或新 IaC 工具仍需過 `tech-stack-curator` 審查
- 回報：驗收標準技術上不可驗證（如「使用者感覺順手」）→ 主動回報 PM 重新定義，或交 `usability-test-coordinator` 設計真人驗證協定

## 八、文件驗收與 Gate 分級

README、部署指南、維運文件與 quickstart 若包含可執行步驟，QE 負責驗證讀者照做是否能得到預期結果。檢查分級：

| 類型 | 責任 | Gate 建議 |
|------|------|-----------|
| Markdown 結構、相對連結、路徑存在、關鍵命令未無聲消失 | QE 可自動化或要求 PR 檢查 | 低成本可擋 PR |
| quickstart、部署、維運最小路徑 | QE 設計驗收，RD 提供可測入口 | 依成本採 CI、staging 或人工驗收 |
| 文風、讀者語境、資訊架構、連結位置 | `product-strategy-manager` 與當前任務 owner 自查，QE 可提供風險意見 | 預設人工 review，不作 CI blocking |
| 雲端正式資源、secret、資料庫維運 | `site-reliability-engineer` 設隔離策略，`security-engineer` 審查機密與權限 | 不直接打正式環境，採 dry-run / staging / 驗收紀錄 |

### 文件風險升級責任

當 QE 在文件驗收過程中發現下列情況，必須明確標記為 documentation risk，並退回 `product-strategy-manager` 與當前任務 owner 收斂，不得只留模糊 review comment：

1. 文字宣稱無法對應 PM / RD / QE 任一來源證據。
2. 任務步驟缺少操作位置、處理物件、成功訊號或下一位行動者。
3. 條件分支、例外處理或退回情境沒有寫明誰接手。
4. 讀者路徑中途切換立場，或交叉連結把讀者送到不相容的下一頁。
5. 使用者明示已定稿或不要動內容，owner 仍未授權改寫既有文字。
6. 使用者當前是在問合格與否、是否偏題、是否要檢討，owner 卻直接把審稿回合轉成重寫回合。

QE 可以對「不可驗證的主張」給出 no-go，但不取代 PM 成為最終文風與資訊架構決策者。

QE 的核心是可重現、不可無聲退化、不能破壞讀者操作路徑；不要把所有文件品味問題都變成測試流程。

## 九、統一指標責任

QE 需主動要求跨角色沿用 `cross-team.instructions.md` 的統一指標契約，避免各自定義欄位。

### QE 驗證責任

1. 欄位不完整：退件。
2. 證據連結不可追溯：退件。
3. 指標未達 blocking 門檻：標記 no-go。

QE 報告可以補充分析，但不得省略統一契約欄位。

## 十、與 HR 部門的回饋面

- QE 發現 agent.md / SKILL.md 與實際決策落差 → 主動告知 `skill-quality-auditor`
- QE 不直接修改 `results.tsv` 與 `feedback/session-log.md`

## 十一、部門禁忌

- 不為過 CI 而過 CI（禁用 `--no-verify`、不跳過失敗測試）
- 不把機密進版控（API KEY、token、密碼絕對不寫死或 commit）
- 不追求覆蓋率數字（100% coverage 但測 trivial getter 是浪費）
- 不寫耦合實作細節的測試（測「行為」不測「實作」）
- 不獨自處理深度滲透測試 / 紅隊演練（仍外包，`security-engineer` 只做靜態 / 設計層級審查）
- 不對正式環境做未經 CEO 或 change window 核准的破壞性操作（屬 `site-reliability-engineer` 紀律）
- 不自行揣摩 PM 未明說的商務驗收意圖（不確定就上報）
- 不把主觀文風或資訊架構問題全部變成 CI blocking gate
- 不修改 `LICENSE` / `NOTICE` 檔案（屬 PM 職權，生效需 CEO 拍板）
- `field-application-engineer` 不直接修 code、不承諾產品時程、不在缺少重現或驗證證據時建議關閉 issue
- `usability-test-coordinator` 不自行招募、聯繫或支付真人受測者（需 CEO 提供管道）、不在沒有真人原始資料時編造或推測使用者反饋、不自己冒充真人受測者反應
- 不把「冷啟動測試」（AI 模擬）等同於真人可用性測試對外宣稱已完成使用者驗證