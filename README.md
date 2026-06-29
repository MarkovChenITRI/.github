# `.github` —— Connect AI 的 VS Code Copilot Runtime

本 repo 是 Connect AI 公司化開發規範的 **VS Code Copilot 自足 runtime**。子專案只需掛載本 repo，即可在 VS Code Copilot 取得完整的十五位員工 agent、部門 SOP、深度 skill playbook 與公司憲法。

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

README 只提供選人入口，不重寫每位員工的完整 workflow。完整邊界、handoff 與工具白名單請直接看 `.github/agents/*.agent.md`。

| 部門 | 建議先找誰 | 何時用 |
|------|------------|--------|
| PM | `product-strategy-manager` | 需求還模糊，需要先定義使用者、MVP、驗收標準 |
| PM | `tech-stack-curator` | 要引入新依賴、框架、模型或處理授權問題 |
| PM | `documentation-experience-manager` | 要整理 README、quickstart、onboarding 或系統文件 |
| RD | `architecture-research-developer` | 要先定義模組邊界、依賴方向、public API |
| RD | `database-architect` / `ui-ux-designer` / `algorithm-research-developer` | 需要補資料結構、介面結構或演算法規格 |
| RD | `senior-software-engineer` | 藍圖已凍結，要開始實作或重構 |
| QE | `testing-quality-engineer` | 要設計測試策略、CI gate、驗收方式 |
| QE | `field-application-engineer` / `security-engineer` / `site-reliability-engineer` / `usability-test-coordinator` | 分別處理 issue triage、資安審查、維運部署、真人可用性測試 |
| HR | `skill-talent-acquisition` / `skill-quality-auditor` | 要新增能力，或回顧現有協作規範是否失真 |

## 常見任務該找誰

| 使用者現在想做 | 建議入口 |
|----------------|----------|
| 先把需求講清楚 | `@product-strategy-manager` |
| 先把技術邊界講清楚 | `@architecture-research-developer` |
| 直接開始實作 | `@senior-software-engineer` |
| 規劃測試與驗收 | `@testing-quality-engineer` |
| 重現 issue 與分派 owner | `@field-application-engineer` |
| 處理授權、依賴與 LICENSE | `@tech-stack-curator` |
| 整理 README 或 onboarding | `@documentation-experience-manager` |

若不知道從哪位開始，預設先走 PM → RD → QE。

## 第一次啟用檢查

掛載後請在 VS Code 執行以下檢查，確認 Copilot 真的讀到本模組：

1. 執行 `Chat: Open Customizations`，在 Instructions、Agents、Skills 分頁確認來源包含 `.github/`。
2. 在 Chat 輸入 `/`，確認可搜尋到十五個 Connect AI skills。
3. 打開 Agent picker，確認可選十五位員工 agent。
4. 在 Chat 視窗右鍵開啟 Diagnostics，確認沒有載入錯誤。

若 VS Code 只開啟 monorepo 的子資料夾，Copilot 預設只找目前 workspace 內的 customization。此時請打開 repo root，或啟用 `chat.useCustomizationsInParentRepositories` 讓 VS Code 往父層 repo 尋找 `.github/`。

## 日常使用原則

1. 一般聊天不用特別指定；`.github/copilot-instructions.md` 會自動生效。
2. 需要特定職能時，先選 agent；需要完整檢查表時，再用 skill。
3. 子專案自己的 `copilot-instructions.md` 只補專案特有技術棧、測試指令與部署限制，不複製本 runtime 的員工與 SOP。
4. 若行為不如預期，先看 `Chat: Open Customizations` 和 Chat Diagnostics。

## 使用者檢查清單

- [ ] 子專案已掛載 `.github/`。
- [ ] `Chat: Open Customizations` 能看到 Instructions、Agents、Skills。
- [ ] Agent picker 能看到十五位員工。
- [ ] `/` 選單能找到需要的 skill。
- [ ] 已用一個真實任務測試 agent 是否能被選用。
- [ ] 子專案已補技術棧、測試指令、部署限制。

## 使用者會看到的檔案

```
.github/
├── README.md
├── copilot-instructions.md
├── instructions/
├── agents/
└── skills/
```

README 只負責入口與導航；完整規範請回到 `copilot-instructions.md`、`instructions/`、`agents/`、`skills/` 各自的真相源。
