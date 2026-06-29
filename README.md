# `.github` for VS Code Copilot

這個 repo 是 Connect AI 的 VS Code Copilot runtime。把它掛進子專案後，Copilot 會自動讀取共享的 instructions、agents 和 skills，你不需要在每次對話中手動重貼公司規範。

如果你是第一次使用，先完成本頁的掛載與啟用檢查。完成後，你應該能做到三件事：

1. 知道 Copilot 會自動遵守哪些共享規則。
2. 知道該選哪位 agent 開始工作。
3. 知道載入失敗時要去哪裡檢查。

## 你會得到什麼

掛載後，VS Code 會自動或按需讀取下列內容：

| 需求 | 使用方式 | 來源 |
|------|----------|------|
| 讓 Copilot 持續遵守 Connect AI 的工作方式 | 直接在 Chat 或 Agent mode 提問 | `.github/copilot-instructions.md` |
| 讓特定任務套用對應部門規則 | 描述任務，或開啟相關檔案 | `.github/instructions/*.instructions.md` |
| 讓特定角色接手任務 | 從 Agent picker 選取，或輸入 `@agent-name` | `.github/agents/*.agent.md` |
| 啟動深度 playbook | 輸入 `/skill-name`，或讓 Copilot 依任務自動匹配 | `.github/skills/*/SKILL.md` |

## 開始之前

在掛載這個 runtime 前，先確認兩件事：

1. 你正在 repo root 操作，或已確認 VS Code 允許往父層 repo 尋找 customizations。
2. 你的子專案需要的是共享協作規範，而不是只在單一 repo 內自訂少量提示。

## 掛載這個 runtime

在子專案根目錄執行一次：

```bash
git submodule add https://github.com/MarkovChenITRI/.github.git .github
git commit -m "chore: add .github submodule (VS Code Copilot runtime)"
```

完成後，VS Code Copilot 會偵測 `.github/copilot-instructions.md`、`.github/instructions/`、`.github/agents/` 與 `.github/skills/`。

## 驗證是否已成功載入

完成掛載後，在 VS Code 依序檢查：

1. 執行 `Chat: Open Customizations`。
2. 在 Instructions、Agents、Skills 分頁確認來源包含 `.github/`。
3. 在 Chat 輸入 `/`，確認可搜尋到 Connect AI skills。
4. 打開 Agent picker，確認可選到十四位員工 agent。
5. 在 Chat 視窗右鍵開啟 Diagnostics，確認沒有載入錯誤。

如果 VS Code 只開啟 monorepo 的子資料夾，Copilot 預設只找目前 workspace 內的 customization。這時請打開 repo root，或啟用 `chat.useCustomizationsInParentRepositories` 讓 VS Code 往父層 repo 尋找 `.github/`。

## 選擇第一位 agent

第一次任務建議先從 PM 開始，先把需求、讀者與驗收標準定義清楚，再往 RD 和 QE 推進。

| 部門 | 建議入口 | 適用情境 |
|------|----------|----------|
| PM | `product-strategy-manager` | 需求還模糊，需要先定義使用者、MVP 與驗收標準 |
| PM | `tech-stack-curator` | 要引入新依賴、框架、模型或處理授權問題 |
| RD | `architecture-research-developer` | 要先定義模組邊界、依賴方向與 public API |
| RD | `database-architect` / `ui-ux-designer` / `algorithm-research-developer` | 需要補資料結構、介面結構或演算法規格 |
| RD | `senior-software-engineer` | 藍圖已凍結，要開始實作或重構 |
| QE | `testing-quality-engineer` | 要設計測試策略、CI gate 與驗收方式 |
| QE | `field-application-engineer` / `security-engineer` / `site-reliability-engineer` / `usability-test-coordinator` | 分別處理 issue triage、資安審查、維運部署與真人可用性測試 |
| HR | `skill-talent-acquisition` / `skill-quality-auditor` | 要新增能力，或回顧現有協作規範是否失真 |

如果你不知道從哪位開始，預設先走 PM → RD → QE。

## 常見任務入口

| 你現在想做什麼 | 建議入口 |
|------------------|----------|
| 先把需求講清楚 | `@product-strategy-manager` |
| 先把技術邊界講清楚 | `@architecture-research-developer` |
| 直接開始實作 | `@senior-software-engineer` |
| 規劃測試與驗收 | `@testing-quality-engineer` |
| 重現 issue 與分派 owner | `@field-application-engineer` |
| 處理授權、依賴與 LICENSE | `@tech-stack-curator` |
| 整理 README 或 onboarding | 直接在原任務中修改；會自動套用 `user-facing-docs.instructions.md`，必要時由 `product-strategy-manager` 協調讀者路徑與範圍 |

## 日常使用方式

使用這個 runtime 時，請遵守以下習慣：

1. 一般聊天不用特別指定；`.github/copilot-instructions.md` 會自動生效。
2. 需要特定職能時，先選 agent；需要完整檢查表時，再用 skill。
3. 子專案自己的 `copilot-instructions.md` 只補專案特有技術棧、測試指令與部署限制，不複製本 runtime 的員工與 SOP。
4. 若行為不如預期，先看 `Chat: Open Customizations` 和 Chat Diagnostics。

## 疑難排解

如果你懷疑 `.github` 沒有生效，先檢查以下問題：

1. 你是不是只開了 monorepo 的子資料夾，而不是 repo root。
2. `Chat: Open Customizations` 中是否真的看得到 `.github/` 來源。
3. Agent picker 是否出現 Connect AI agents。
4. `/` 選單是否搜尋得到對應 skills。
5. Chat Diagnostics 是否出現載入錯誤。

## 快速檢查清單

- [ ] 子專案已掛載 `.github/`。
- [ ] `Chat: Open Customizations` 能看到 Instructions、Agents、Skills。
- [ ] Agent picker 能看到十四位員工。
- [ ] `/` 選單能找到需要的 skill。
- [ ] 已用一個真實任務測試 agent 是否能被選用。
- [ ] 子專案已補技術棧、測試指令、部署限制。

## 這個 runtime 包含哪些檔案

```text
.github/
├── README.md
├── copilot-instructions.md
├── instructions/
├── agents/
└── skills/
```

## 下一步

如果你要繼續往下操作，使用這些入口：

- 想看共享憲法：`copilot-instructions.md`
- 想看任務規則：`instructions/`
- 想看角色入口：`agents/`
- 想看深度 playbook：`skills/`

README 只負責入口與導航；完整規範請回到各自的真相源。
