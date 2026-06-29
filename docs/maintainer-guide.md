# `.github` 維護者指南

本文件說明如何維護 Connect AI 的 `.github` runtime。這是一份給維護者看的操作文件，不是給一般子專案使用者的入口頁。

如果你的目標是讓使用者知道如何掛載與使用這個 runtime，請改 [README](./../README.md)。如果你的目標是調整 runtime 規則、角色或技能，請用本頁決定要改哪一層。

## 你會在這份文件中完成什麼

看完本頁後，你應該能做到三件事：

1. 判斷一個變更應該改在 README、docs、instructions、agents 還是 skills。
2. 避免把維護者內容寫進使用者文件。
3. 在修改後檢查 runtime 是否仍然一致、可載入且沒有越權擴張。

## 開始之前

在修改任何 `.github` 文件前，先確認下列原則：

1. 根目錄 README 是給子專案使用者看的，不是維護手冊。
2. runtime 載入檔只放執行規則；設計理由與維護說明放在 `docs/`。
3. 角色、規則與 skill 的責任要分層，不要讓同一條規範在多處互相打架。

## 先判斷要改哪裡

當你準備修改 `.github` runtime 時，先用下表決定落點：

| 你想達成的效果 | 修改位置 | 使用時機 |
|------------------|----------|----------|
| 所有對話都要遵守一條規則 | `.github/copilot-instructions.md` | 規則必須全域常駐 |
| 只在特定任務或檔案套用規則 | `.github/instructions/*.instructions.md` | 規則只該在特定情境載入 |
| 新增一位固定角色或限制工具權限 | `.github/agents/*.agent.md` | 需要新的角色入口或權限邊界 |
| 把重複流程變成可重用 playbook | `.github/skills/<name>/SKILL.md` | 需要深度流程、長指引或 slash command |
| 說明維護理由、資訊架構或治理背景 | `.github/docs/*.md` | 內容是給人讀，不是給 runtime 常駐載入 |
| 補子專案特有技術棧、測試指令與部署限制 | 子專案自己的 `copilot-instructions.md` 或 `AGENTS.md` | 內容只屬於單一子專案 |
| 讓使用者文件與 UI 文案自動套用人類寫作規則 | `.github/instructions/user-facing-docs.instructions.md` | 需要把 Azure Learn 式寫法變成常駐規則 |

## 維護 README

只有在你要改變子專案使用者的成功路徑時，才修改根目錄 README。

### README 應該回答什麼

README 只回答四件事：

1. 這個 runtime 會幫使用者得到什麼。
2. 如何掛載與啟用。
3. 日常如何選 agent 或 skill。
4. 如何確認模組已生效，遇到載入問題時怎麼自查。

### 不要把這些內容放進 README

下列內容應留在 `docs/` 或其他真相源，不要混回 README：

1. skill 蒸餾、考核與品質評分流程。
2. frontmatter 欄位規則、工具白名單設計與維護細節。
3. 維護者提交、發版、PR、tag 與內部同步流程。

### 修改 README 時要檢查什麼

1. 讀者是不是子專案使用者，而不是維護者。
2. 使用者是否能在五分鐘內完成掛載、啟用檢查與第一次真實任務。
3. README 是否只承諾 runtime 真的存在的 agents、instructions 與 skills。

## 維護 instructions、agents 和 skills

當你修改 runtime 行為時，請用下列規則檢查。

### 修改 instructions 時

1. 用精準的 `applyTo`。
2. 避免用過寬的 glob 汙染所有對話 context。
3. 把正式規則寫在 instruction，不把維護說明寫進去。

### 修改 agents 時

1. `description` 必須說清楚何時使用。
2. `tools` 應採最小權限。
3. 不要讓 agent 自己承接不屬於該角色的決策。

### 修改 skills 時

1. `name` 必須與資料夾名稱一致。
2. 描述必須具體，不要只寫抽象名詞。
3. 大型參考資料放在 skill 目錄內，並用 Markdown link 引用。
4. 高頻共享規則應留在 instructions，不要把 skill 寫成常駐憲法。

## 避免文件受眾漂移

文件受眾漂移是這個 repo 最容易反覆出現的維護問題。當 README 開始混入維護流程、內部欄位規則或治理細節時，代表文件已寫給錯的人。

### 誰負責判斷

| 角色 | 責任 |
|------|------|
| `product-strategy-manager` | 定義 README 的讀者、成功條件與交付形式 |
| `skill-quality-auditor` | 發現並記錄文件受眾漂移 |
| RD | 依 PM 與 Auditor 的結論執行實際調整 |

### 何時應視為受眾漂移

若 README 出現下列內容，應優先搬回 `docs/`：

1. 維護者流程。
2. 內部欄位規則。
3. 發版步驟。
4. 鏡像同步、治理備註或 runtime 設計內幕。

## 修改後如何驗證

每次修改後，至少檢查以下項目：

1. 使用者文件是否仍然只寫給使用者。
2. 觸發詞、職權邊界與交棒關係是否語意一致。
3. `applyTo`、agent 描述與 skill 名稱是否仍可被正確載入。
4. README 是否仍能支援五分鐘啟用路徑。

## 快速檢查清單

- [ ] 我已先判斷這次變更應該改在哪一層。
- [ ] 我沒有把維護者流程寫進 README。
- [ ] 我沒有把治理理由寫進 runtime 常駐檔。
- [ ] README 只承諾實際存在的能力。
- [ ] instructions、agents、skills 的責任邊界沒有互相重疊。

## 下一步

如果你要繼續往下操作，使用這些文件：

- 想看使用者入口：`../README.md`
- 想看 CEO 怎麼操作流程：`ceo-playbook.md`
- 想看使用者文件標準：`documentation-standards.md`
- 想看正式跨部門規則：`../instructions/cross-team.instructions.md`
- 想看現有 work order：`../issues/README.md`