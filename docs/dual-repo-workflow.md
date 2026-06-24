# 雙 Repo 抉擇與工作流指南（VS Code Copilot 端）

`.github` 與 `.claude` 是兩個平行、獨立的 runtime repo。兩者內容等效，但不互相依賴；子專案維護者依使用的 AI 工具擇一掛載，只有同時使用 VS Code Copilot 與 Claude Code 時才同時掛兩個。

## 一、兩個 repo 的關係

| Primitive | VS Code Copilot（讀 `.github/`） | Claude Code（讀 `.claude/`） |
|-----------|----------------------------------|------------------------------|
| 全域常駐憲法 | `.github/copilot-instructions.md` | `.claude/CLAUDE.md` |
| 部門 SOP（條件載入） | `.github/instructions/*.instructions.md`（`applyTo`） | `.claude/rules/*.md`（有 `paths` 時條件載入，無 `paths` 時無條件載入） |
| 員工 / subagent | `.github/agents/*.agent.md` | `.claude/agents/*.md` |
| 深度行為 playbook | `.github/skills/*/SKILL.md` | `.claude/skills/*/SKILL.md` |

兩端等效但不追求逐字相同。frontmatter、檔名與工作流拆分方式依各 runtime 官方 primitive 設計調整。`.agent.md` 負責角色、工具與 handoff；`SKILL.md` 負責按需載入的深度 workflow。

## 二、何時掛哪個

| 使用情境 | 建議 |
|----------|------|
| 只用 VS Code Copilot | 只掛 `.github/` |
| 只用 Claude Code | 只掛 `.claude/` |
| 兩個工具都用 | 同時掛 `.github/` 與 `.claude/`，並接受或關閉重複載入 |

子專案中兩個 submodule 永遠平行掛在專案根目錄，不透過 nested submodule 互相取得。

## 三、雙掛時的 VS Code 載入行為

同時掛兩個 repo 時，VS Code Copilot 可能讀入：

| 來源 | 預設行為 |
|------|----------|
| `.github/copilot-instructions.md` | 全域常駐 |
| `.github/instructions/*.instructions.md` | 依 `applyTo` 或語意描述載入 |
| `.github/agents/*.agent.md` | 作為 custom agents |
| `.github/skills/*/SKILL.md` | 先發現 `name` / `description`，任務相關時按需載入全文 |
| `.claude/CLAUDE.md` | `chat.useClaudeMdFile` 啟用時載入 |
| `.claude/rules/*.md` | `chat.instructionsFilesLocations` 包含 `.claude/rules` 時載入 |
| `.claude/agents/*.md` | 作為 Claude-format agents 被 VS Code 識別 |

若兩端內容維持等效，預期主要成本是 token 與重複提示；但 VS Code 會把多個 instruction 來源合併進 context，沒有保證特定覆蓋順序。雙掛時應用 Diagnostics 確認實際載入來源；若兩端鏡像 drift，就可能出現互斥規則。若只使用 VS Code Copilot，請不要額外掛 `.claude/`。

## 四、個人即時同步與子專案鎖版

| 目標 | 載體 |
|------|------|
| 個人跨專案立即生效 | VS Code user profile instructions/agents，以及 Claude Code user-level customizations |
| 子專案共享且可審查升級 | `.github/` / `.claude/` submodule |
| 兩者並行 | repo 作版本化真相源，個人層作即時工作副本 |

Submodule 適合鎖定版本，不適合自動把每次上游修改推送到所有子專案。若目標是即時同步，應把個人層 customizations 視為主要執行面，repo 視為可回溯的來源。

## 五、維護者同步原則

任何規範變更都要同步檢查兩端是否仍等效：

- 十四位員工是否兩端都存在
- 五份部門 SOP 是否兩端都存在
- 十四份深度 skill 是否兩端都存在
- 觸發詞與職權邊界是否一致
- VS Code 端是否不依賴 `.claude/` 才能完成工作流
- Claude Code 端是否不依賴 `.github/` 才能完成工作流