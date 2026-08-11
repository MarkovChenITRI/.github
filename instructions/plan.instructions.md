---
description: "Loaded automatically for all plan-*.md prompts. Mirrors the plan 技能通用規範 section in copilot-instructions.md."
applyTo: ".github/prompts/plan-*.md"
---

# plan 技能通用規範

（同 `copilot-instructions.md` 的「plan 技能通用規範」段落——確保換引擎也能讀到相同規則。各專案在確認工具鏈後，可在此補充引擎特定的讀取步驟。）

plan 技能負責三類產出物，彼此有建立順序依賴：

1. **規格書**：系統架構（`<專案資料夾>/.github/specs/overview.md`）先建，模組規格（`<專案資料夾>/.github/specs/<layer>/<module>.md`）次之，使用範例／驗收標準（`<專案資料夾>/.github/specs/usage-examples/<flow>.md`）最後。
2. **計劃書**（`<專案資料夾>/.github/proposals/<name>.md`）：獨立於規格書，不依賴前三者先存在。

各類產出物的格式依循：

| 產出物 | 格式依循 |
|---|---|
| 系統架構、模組規格、使用範例 | `spec-format.instructions.md` |
| 計劃書敘述段落（目標市場需求、產品開發與技術服務） | `proposal-format.instructions.md` |
| 計劃書圖表段落（架構圖、時程、查核點） | `proposal-schedule-format.instructions.md` |

進入任何 plan prompt 的主動作前，先讀取對應的現有文件；已有的內容只補齊缺的部分，不整份覆蓋。
