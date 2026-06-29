---
description: "Use when discussing testing strategy, test pyramid, CI/CD workflows, GitHub Actions, GitHub Pages deployment, test coverage, integration/E2E/acceptance tests, secret management, threat modeling, OWASP review, dependency vulnerabilities (CVE), deployment topology, infrastructure as code, monitoring/alerting, incident response, rollback, quality metrics, GitHub Issue triage, user bug reports, reproduction, debug closure, usability testing, user research, beta testing recruitment screeners, or cold-start / fresh-eyes documentation walkthroughs. Defines QE authority boundaries, test quadrants, CI gates, security review, operability, usability testing, and FAE issue routing."
applyTo: "**/{tests,test,__tests__,e2e,integration}/**, **/*.{test,spec}.{ts,tsx,js,jsx,py}, .github/workflows/**, **/infra/**, **/*.{tf,bicep}"
---

# QE 部門作業準則

QE 部門負責 V-Model 右翼「做了對的嗎」。操作對象是測試策略、CI/CD 流程、品質指標、資安審查、正式環境可維運性與真人使用者驗證。

員工：`testing-quality-engineer`、`field-application-engineer`、`security-engineer`、`site-reliability-engineer`、`usability-test-coordinator`。完整角色定義見 `.github/agents/`；本檔與 `.github/agents/` 共同提供 VS Code Copilot 的完整工作流。

| 員工 | 負責 |
|------|------|
| `testing-quality-engineer` | 測試策略、CI/CD、integration / E2E / acceptance、品質指標、冷啟動文件測試 |
| `field-application-engineer` | GitHub Issue intake、重現資訊收斂、debug action item 分派、修復驗證與關閉建議 |
| `security-engineer` | 威脱建模、OWASP 審查、機密管理審查、依賴漏洞（CVE）分流 |
| `site-reliability-engineer` | 部署拓撲、IaC、監控告警、容量規劃、rollback、事故應變 |
| `usability-test-coordinator` | 可用性測試協定設計、真人受測者招募條件、Usability Findings Package 彙整 |

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

機密的**註冊與隔離流程**由 `testing-quality-engineer` 維護；機密管理現況是否有風險（輪替、最小權限、過度授權）的**審查**由 `security-engineer` 負責，兩者不互相取代。

## 五、資安審查與威脱建模

`security-engineer` 補上 QE 基礎 checklist 與深度滲透測試之間的缺口：威脱建模、OWASP Top 10 逐項審查、依賴漏洞（CVE）分級。

### 介入時機

- 新增登入、權限、付款或個資處理功能
- CI 報告相依套件漏洞（Dependabot / npm audit / pip-audit）
- 部署前需要資安檢查清單

### Security Review Package（交工程師 / QE）

1. 資料分類與信任邊界
2. 威脱清單與緩解措施（STRIDE 或對應方法）
3. OWASP / checklist 逐項結果（通過 / 不通過 / 不適用）
4. 機密管理現況與風險
5. 依賴漏洞清單與嚴重度分級
6. 待確認項：法規合規認證、紅隊測試需求，交外部專業顧問

### 與 QE 的分工

- `testing-quality-engineer` 跑基礎 security checklist（機密不入版控、依賴版本是否更新）
- `security-engineer` 補威脱建模、OWASP 逐項審查與弱點分級
- 深度滲透測試 / 紅隊演練仍外包，兩者皆不得宣稱可獨自完成

## 六、部署與維運管理

`site-reliability-engineer` 銜接 QE 的 CI/CD 設計與正式環境維運：部署拓撲、Infrastructure as Code（IaC）、監控告警、容量規劃、rollback 與事故應變。

### Operability Facts Package（交工程師 / QE）

1. 部署拓撲：環境分層、部署策略、流量路由
2. IaC 現況：哪些資源已宣告為程式碼、哪些仍手動操作（技術債清單）
3. 監控與告警：關鍵指標、告警門檎、on-call 路徑
4. 容量與成本：資源規格、預期負載、成本估算
5. Rollback 路徑：如何回滾、回滾所需時間
6. 待確認項：正式環境變更窗口、預算上限需 CEO 裁決

### 正式環境變更紀律

- 對正式環境的破壞性操作（刪除資源、強制覆寫、降級資料庫）未經 CEO 或 change window 核准不得執行
- 手動 Portal 操作視為技術債，須逐步轉成可重複執行的 IaC
- 上線前必須有 rollback 路徑，沒有路徑不得推上線

## 七、可用性測試與真人使用者驗證

`usability-test-coordinator` 補上 QE 自動化驗收測試與真實使用者主觀反應之間的缺口：設計可用性測試協定、招募篩選條件，並把真人原始記錄彙整成可行動的發現。

### 與冷啟動測試的分工

- `testing-quality-engineer` 自己跑「冷啟動測試」：開一個無專案上下文的 subagent 或全新會話（必要時換不同模型），假裝完全沒看過這個專案，只依公開文件 / 指令操作，回報卡點。這驗證的是**文件 / 指令層級**的可理解性，成本低、可隨時重跑。
- 但所有 AI session 都共享訓練資料中大量的軟體慣例知識，不是真正的「天真使用者」；情緒反應、肢體互動與無障礙工具的真實使用情境，AI 無法替代。這部分由 `usability-test-coordinator` 負責設計協定，但**真人受測者本身需由 CEO 提供管道**（beta 名單、測試平台、現場招募），協調員不能自行招募、聯繫或支付，也不能自己冒充真人反應、不能在沒有真人原始資料時編造發現。
- 兩者互補：冷啟動測試先擋掉文件層級的低垂果實（缺步驟、斷連結、命令跑不動），真人測試才驗證更深層的情緒與可用性問題。

### 介入時機

- 產品已有可操作的 prototype / MVP，需要驗證真人能否完成關鍵任務
- PM 提出的商務假設（如「使用者會願意付費」「使用者覺得這個流程順手」）需要真人驗證而非主觀判斷
- `ui-ux-designer` 的設計稿落地後，需要確認真人是否真的能依設計流程完成任務
- 既有功能被回報「難用」但缺乏具體重現資訊

### Usability Findings Package（交 `ui-ux-designer` / `product-strategy-manager` / `senior-software-engineer`）

1. 受測者輪廓與招募條件、樣本量、已知偏誤（如熟悉本專案的人混入）
2. 任務完成率與卡點：哪個任務在哪一步失敗、猶豫或求助
3. 觀察記錄與情緒訊號：困惑、挫折、驚喜的具體時刻，先列現象不先下結論
4. 量化指標（如有）：完成時間、求助次數、錯誤率
5. 待確認項：樣本量是否足以代表真實使用者群、是否需擴大測試規模，需 PM 或 CEO 裁決

### 與 QE 的分工

- `testing-quality-engineer` 做自動化驗收測試與冷啟動文件測試
- `usability-test-coordinator` 做真人質化可用性測試，需 CEO 提供真人測試管道才能宣稱「已完成真人測試」
- 功能性缺陷轉 `senior-software-engineer` 修復並補回歸測試；設計問題轉 `ui-ux-designer`；商務假設驗證結果轉 `product-strategy-manager` 裁決

## 八、與 RD 部門的協作面

### RD → QE 的接收清單

收到 RD 交棒的設計文件時：

- [ ] API 規格是否可測（能 mock 嗎、副作用能隔離嗎）
- [ ] 不變式是否可斷言（能轉成 assertion 嗎）
- [ ] 邊界條件是否完整（極大值、極小值、空輸入、非法輸入）
- [ ] 依賴關係圖是否標明外部服務（哪些 mock、哪些真實呼叫）
- [ ] `database-architect` 的資料完整性約束是否可斷言（schema facts package）
- [ ] `ui-ux-designer` 的無障礙基準是否可驗證（design facts package）

任一不滿足 → 退回 RD 補齊，不勉強寫測試。

### QE → RD 的回饋面

- 發現反金字塔 → 向 `architecture-research-developer` 提 refactor 建議
- 發現測試耦合 private 細節 → 向 `senior-software-engineer` 提重構建議
- **QE 不直接改 RD 程式碼**，只提建議

## 九、與 PM 部門的接件面

- 上游：QE 接受 `product-strategy-manager` 的驗收標準，轉為可執行 E2E 測試
- 下游：測試報告交回 `product-strategy-manager` 由其翻譯為對外語言
- 依賴：QE 自身引入新測試框架（Cypress / Playwright / k6）或新 IaC 工具仍需過 `tech-stack-curator` 審查
- 回報：驗收標準技術上不可驗證（如「使用者感覺順手」）→ 主動回報 PM 重新定義，或交 `usability-test-coordinator` 設計真人驗證協定

## 十、文件驗收與 Gate 分級

README、部署指南、維運文件與 quickstart 若包含可執行步驟，QE 負責驗證讀者照做是否能得到預期結果。檢查分級：

| 類型 | 責任 | Gate 建議 |
|------|------|-----------|
| Markdown 結構、相對連結、路徑存在、關鍵命令未無聲消失 | QE 可自動化或要求 PR 檢查 | 低成本可擋 PR |
| quickstart、部署、維運最小路徑 | QE 設計驗收，RD 提供可測入口 | 依成本採 CI、staging 或人工驗收 |
| 文風、讀者語境、資訊架構、連結位置 | documentation-experience-manager 自查，QE 可提供風險意見 | 預設人工 review，不作 CI blocking |
| 雲端正式資源、secret、資料庫維運 | `site-reliability-engineer` 設隔離策略，`security-engineer` 審查機密與權限 | 不直接打正式環境，採 dry-run / staging / 驗收紀錄 |

QE 的核心是可重現、不可無聲退化、不能破壞讀者操作路徑；不要把所有文件品味問題都變成測試流程。

<<<<<<< HEAD
## 七點五、統一指標輸出格式（RD / QE / Documentation 共用）

QE 需主動要求跨角色使用同一套指標契約，避免「各寫各的」導致無法比較與關單。

### 必填欄位

1. reporting_week
2. stream_id（provider / maintainer / consumer）
3. owner
4. metric_name
5. baseline
6. target
7. current
8. trend（up / flat / down）
9. evidence_links
10. blocker
11. veto_status（pass / fail）

### QE 驗證責任

1. 欄位不完整：退件。
2. 證據連結不可追溯：退件。
3. 指標未達 blocking 門檻：標記 no-go。

QE 報告可以補充分析，但不得省略統一契約欄位。

## 八、與 HR 部門的回饋面
=======
## 十一、與 HR 部門的回饋面
>>>>>>> 242c23700b3740c7995ad3d354873667a08afb60

- QE 發現 agent.md / SKILL.md 與實際決策落差 → 主動告知 `skill-quality-auditor`
- QE 不直接修改 `results.tsv` 與 `feedback/session-log.md`

## 十二、GitHub Issue triage 流程

`field-application-engineer` 是 issue 入口，不直接修 code。標準流程：

1. 分類 issue：bug、setup/docs、feature request、dependency、environment、cannot reproduce。
2. 收斂重現資訊：版本、平台、指令、設定、log、最小重現步驟、期望與實際行為。
3. 判斷 owner：產品範圍交 PM，架構交架構師，資料模型交資料架構顧問，介面交 UI/UX 設計師，演算法交演算法研發，實作交工程師，資安問題交 `security-engineer`，部署/維運事故交 `site-reliability-engineer`，可用性問題交 `usability-test-coordinator`，驗證交 QE。
4. 產出 action items：每項包含 owner、輸入資料、完成條件與驗證方式。
5. 修復後檢查驗證證據，產出 issue 回覆草案與 closure recommendation。

## 十三、部門禁忌

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
