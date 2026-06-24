# `.github` —— Connect AI 的 VS Code Copilot Runtime

本 repo 是 Connect AI 公司化開發規範的 **VS Code Copilot 端自足 runtime**。子專案只需掛載本 repo，即可在 VS Code Copilot 取得完整的十四位員工 agent、部門 SOP、深度 skill playbook 與公司憲法。

> 使用 Claude Code 的使用者，請掛載 `.claude/` 並閱讀 `.claude/README.md`。兩個 repo 各自服務自己的 AI 工具，使用時不要把一邊的檔案複製到另一邊。

## 你會得到的能力

掛載後，你不需要每次手動貼規範給 Copilot。VS Code 會自動或按需讀取下列內容：

| 你想要 | 使用方式 | 本 repo 提供 |
|--------|----------|-------------|
| 讓 Copilot 一直遵守 Connect AI 的工作方式 | 直接在 Chat / Agent mode 提問 | `.github/copilot-instructions.md` |
| 讓特定任務套用對應部門 SOP | 描述任務或開啟相關檔案 | `.github/instructions/*.instructions.md` |
| 讓特定員工處理任務 | 從 Agent picker 選取，或輸入 `@agent-name` | `.github/agents/*.agent.md` |
| 啟動深度 playbook | 輸入 `/skill-name`，或讓 Copilot 依任務自動匹配 | `.github/skills/*/SKILL.md` |

## 五分鐘啟用路徑

1. 在子專案根目錄掛載 `.github/`。
2. 用 `Chat: Open Customizations` 確認 Instructions、Agents、Skills 都有載入。
3. 從 Agent picker 選一位員工，或在 Chat 直接輸入 `@agent-name`。
4. 第一次任務建議先從 PM 開始，讓需求、受眾與驗收標準先被定義清楚。

完成後，使用者應該能做到三件事：知道 Copilot 會自動遵守哪些共識、知道該選哪位 agent、知道問題發生時去哪裡檢查載入狀態。

## 安裝

在子專案根目錄執行一次：

```bash
git submodule add https://github.com/MarkovChenITRI/.github.git .github
git commit -m "chore: add .github submodule (VS Code Copilot runtime)"
```

掛載後，VS Code Copilot 會偵測 `.github/copilot-instructions.md`、`.github/instructions/`、`.github/agents/` 與 `.github/skills/`，讓 Copilot 自動取得 Connect AI 的協作規範與員工角色。

## 可用 Agent 與責任範圍

| 可用 Agent | 部門 | 適合交給他處理的事 | 不適合交給他的事 |
|-----------|------|----------------------|------------------|
| `product-strategy-manager` | PM | 釐清使用者、商務目標、MVP、驗收標準、交付形式 | 寫程式、決定技術實作細節 |
| `tech-stack-curator` | PM | 評估開源依賴、授權相容性、商用風險、LICENSE 草案 | 整合套件到程式碼 |
| `documentation-experience-manager` | PM | 規劃 README、onboarding、quickstart、系統文件與接手文件的讀者成功路徑 | 發明產品承諾、架構契約或未驗證步驟 |
| `architecture-research-developer` | RD | 設計模組邊界、依賴方向、public API、不變式與架構藍圖 | 寫函式內部實作 |
| `database-architect` | RD | 設計資料庫 Schema、ER 模型、正規化、索引策略、資料完整性約束 | 寫 migration 程式碼或 ORM 實作 |
| `ui-ux-designer` | RD | 設計 information architecture、使用者流程、互動狀態、設計系統、無障礙基準 | 寫前端程式碼或 CSS |
| `algorithm-research-developer` | RD | 設計 AI / ML / CV / 最佳化演算法、數學假設、loss、metrics、baseline | 決定產品目標或直接取代工程實作 |
| `senior-software-engineer` | RD | 依架構藍圖實作、重構、命名、unit test、Clean Code | 決定商務範圍或驗收標準 |
| `testing-quality-engineer` | QE | 設計測試策略、CI/CD、整合測試、E2E、驗收驗證 | 直接修改 RD 程式碼或決定架構 |
| `field-application-engineer` | QE | 收斂 GitHub Issue、重現問題、分派 action item、確認修復後能否關閉 | 直接修 code、承諾產品時程或自行擴張 scope |
| `security-engineer` | QE | 威脱建模、OWASP 審查、機密管理審查、依賴漏洞（CVE）分級 | 主動攻擊性滲透測試或 exploit |
| `site-reliability-engineer` | QE | 部署拓撲、Infrastructure as Code、監控告警、容量規劃、rollback、事故應變 | 未經核准對正式環境做破壞性操作 |
| `skill-talent-acquisition` | HR | 需要新增或擴充 AI 協作能力、萃取新的 skill / persona | 評分既有 skill 或做品質稽核 |
| `skill-quality-auditor` | HR | 回顧協作品質、記錄規範落差、檢查 skill 是否貼近實際決策 | 招募新角色或直接改業務/技術決策 |

## 常見任務該找誰

| 使用者現在想做 | 建議入口 | 第一個提示詞可以這樣寫 |
|----------------|----------|--------------------------|
| 需求還很模糊，不確定要做成什麼 | `@product-strategy-manager` | `@product-strategy-manager 幫我把這個想法整理成目標使用者、MVP 與驗收標準` |
| 想引用新套件、框架或模型 | `@tech-stack-curator` | `@tech-stack-curator 審查這個依賴是否適合商用與目前授權` |
| 需要整理 README、quickstart 或系統文件 | `@documentation-experience-manager` | `@documentation-experience-manager 幫我規劃這份文件的讀者成功路徑與文件架構` |
| 不確定模組邊界或依賴方向 | `@architecture-research-developer` | `@architecture-research-developer 先幫我定義模組邊界與依賴方向` |
| 需要設計資料庫 Schema 或資料模型 | `@database-architect` | `@database-architect 幫我設計這個功能需要的資料表結構與索引策略` |
| 需要設計介面、使用者流程或無障礙規格 | `@ui-ux-designer` | `@ui-ux-designer 幫我規劃這個功能的使用者流程與介面結構` |
| 需要設計 AI 演算法、loss、metric 或 baseline | `@algorithm-research-developer` | `@algorithm-research-developer 幫我把這個 AI 問題整理成演算法規格與評估指標` |
| 已有架構藍圖，要開始改程式 | `@senior-software-engineer` | `@senior-software-engineer 依照這份藍圖實作，並保持 Clean Code` |
| GitHub Issue 需要重現、分類與分派 | `@field-application-engineer` | `@field-application-engineer 幫我 triage 這個 issue，整理 action items 與關閉條件` |
| 想確認怎麼驗證這次變更 | `@testing-quality-engineer` | `@testing-quality-engineer 幫我設計這次變更的測試與驗收方式` |
| 需要威脱建模或資安審查 | `@security-engineer` | `@security-engineer 幫我審查這個功能的威脱模型與 OWASP checklist` |
| 需要規劃部署、監控或正式環境維運 | `@site-reliability-engineer` | `@site-reliability-engineer 幫我規劃這次上線的部署拓撲與 rollback 路徑` |
| 需要新增一種 AI 協作能力 | `@skill-talent-acquisition` | `@skill-talent-acquisition 幫我判斷是否需要蒸餾新的 skill 或 agent` |
| 發現 AI 協作方式和實際期待有落差 | `@skill-quality-auditor` | `@skill-quality-auditor 回顧這次對話，找出值得記錄的規範落差` |

## 第一次啟用檢查

掛載後請在 VS Code 執行以下檢查，確認 Copilot 真的讀到本模組：

1. 執行 `Chat: Open Customizations`，在 Instructions、Agents、Skills 分頁確認來源包含 `.github/`。
2. 在 Chat 輸入 `/`，確認可搜尋到十四個 Connect AI skills。
3. 打開 Agent picker，確認可選十四位員工 agent。
4. 在 Chat 視窗右鍵開啟 Diagnostics，確認沒有載入錯誤。

若 VS Code 只開啟 monorepo 的子資料夾，Copilot 預設只找目前 workspace 內的 customization。此時請打開 repo root，或啟用 `chat.useCustomizationsInParentRepositories` 讓 VS Code 往父層 repo 尋找 `.github/`。

## 日常工作流

### 1. 讓全域規範自動生效

一般聊天、改程式、寫文件時不用特別指定；`.github/copilot-instructions.md` 會自動提供 Connect AI 的全域原則，例如繁體中文、Clean Architecture、Rollback first、Self-verification、YAGNI、部門分工邊界。

如果你的子專案有自己的技術棧或啟動方式，請只在子專案層補充：

```markdown
## 本專案補充規範
技術棧：Python 3.12 + FastAPI + PostgreSQL
測試指令：pytest tests/ -v
部署環境：Docker + GCP Cloud Run
```

不要把十四位員工的角色定義複製到子專案文件；角色與 SOP 由本 `.github/` runtime 統一提供。

### 2. 選擇正確員工

需要特定職能時，請直接從 Agent picker 選員工，或在 Chat 使用 `@agent-name`：

```text
@product-strategy-manager 幫我把這個需求拆成 MVP 與驗收標準
@documentation-experience-manager 規劃 README 與 quickstart 的讀者成功路徑
@architecture-research-developer 先定義模組邊界與依賴方向
@senior-software-engineer 依照架構藍圖實作
@testing-quality-engineer 針對這次變更設計驗證策略
@tech-stack-curator 審查這個 npm 套件的授權風險
```

建議順序是 PM 先定義 What / Why，RD 架構師定義藍圖，RD 工程師實作，QE 驗證。跨 agent 的 handoff 會在回覆後出現建議按鈕；使用者可檢查上一階段結果後再交棒，不會被迫自動跳下一步。

### 3. 使用深度 skill

Skills 是按需載入的 playbook。當任務描述符合 `SKILL.md` 的 `description` 時，Copilot 可能自動載入；你也可以輸入 slash command 明確觸發：

```text
/architecture-research-developer 分析目前服務拆分是否違反 Clean Architecture
/senior-software-engineer 重構這段程式並補 unit test
/testing-quality-engineer 檢查這個 PR 的測試金字塔是否合理
```

Skill body 載入後會進入目前對話 context；如果只是想讓某個角色持續處理整段任務，優先選 custom agent。如果是要啟動一段可重複程序或深度 checklist，優先用 skill。

### 4. 檢查 Copilot 實際用了哪些規範

Copilot 回覆底部的 References 可能顯示使用到的 instruction / skill。若行為不如預期：

- 用 `Chat: Open Customizations` 查看來源檔案是否存在。
- 用 Chat Diagnostics 查看載入錯誤。
- 確認目前提問是否明確提到想使用的員工、部門或工作類型。
- 若 skill 沒有出現在 `/` 選單，重啟 VS Code 或重新開啟 workspace 後再確認。

## 使用者檢查清單

- [ ] 子專案已掛載 `.github/`。
- [ ] `Chat: Open Customizations` 能看到 Instructions、Agents、Skills。
- [ ] Agent picker 能看到十四位員工。
- [ ] `/` 選單能找到需要的 skill。
- [ ] 已用一個真實任務測試 agent 是否能被選用。
- [ ] 子專案已補技術棧、測試指令、部署限制。

## 使用者會看到的檔案

```
.github/
├── README.md                       # 本檔
├── copilot-instructions.md         # 公司憲法（VS Code Copilot 全域常駐）
├── instructions/                   # 部門 SOP（依任務或檔案自動載入）
│   ├── cross-team.instructions.md
│   ├── pm-sop.instructions.md
│   ├── rd-sop.instructions.md
│   ├── qe-sop.instructions.md
│   └── hr-sop.instructions.md
├── agents/                         # 員工 custom agents（角色、可用工具、handoffs）
│   ├── product-strategy-manager.agent.md
│   ├── tech-stack-curator.agent.md
│   ├── documentation-experience-manager.agent.md
│   ├── architecture-research-developer.agent.md
│   ├── database-architect.agent.md
│   ├── ui-ux-designer.agent.md
│   ├── algorithm-research-developer.agent.md
│   ├── senior-software-engineer.agent.md
│   ├── testing-quality-engineer.agent.md
│   ├── field-application-engineer.agent.md
│   ├── security-engineer.agent.md
│   ├── site-reliability-engineer.agent.md
│   ├── skill-talent-acquisition.agent.md
│   └── skill-quality-auditor.agent.md
└── skills/                         # 深度 playbook（按需載入）
    ├── product-strategy-manager/SKILL.md
    ├── tech-stack-curator/SKILL.md
    ├── documentation-experience-manager/SKILL.md
    ├── architecture-research-developer/SKILL.md
    ├── database-architect/SKILL.md
    ├── ui-ux-designer/SKILL.md
    ├── algorithm-research-developer/SKILL.md
    ├── senior-software-engineer/SKILL.md
    ├── testing-quality-engineer/SKILL.md
    ├── field-application-engineer/SKILL.md
    ├── security-engineer/SKILL.md
    ├── site-reliability-engineer/SKILL.md
    ├── skill-talent-acquisition/SKILL.md
    └── skill-quality-auditor/SKILL.md
```

## 邊緣情境：同時使用 VS Code Copilot 與 Claude Code

一般 Copilot 使用者只需要掛 `.github/`。若同一個子專案同時使用 VS Code Copilot 與 Claude Code，請先閱讀 [docs/dual-repo-workflow.md](docs/dual-repo-workflow.md)，確認是否真的需要雙掛，以及如何避免重複載入規範。
