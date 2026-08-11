---
description: "套用到所有 plan 提示詞檔，定義領域驅動設計技能共用的產出順序、格式與讀取規則。"
applyTo: ".github/prompts/plan-*.md"
---

# 領域驅動設計技能通用準則

plan 技能負責三類產出物，彼此有建立順序依賴：

1. **規格書**：系統架構（`<專案資料夾>/.github/specs/architecture.md`）先建，模組規格（`<專案資料夾>/.github/specs/modules.md`）次之，使用範例／驗收標準（`<專案資料夾>/.github/specs/examples.md`）最後。
2. **計劃書**：市場需求與技術定位（`<專案資料夾>/.github/proposals/ideation.md`）與計畫執行規劃（`<專案資料夾>/.github/proposals/action-items.md`）各自獨立於規格書。

各類產出物的格式依循：

| 產出物 | 格式依循 |
|---|---|
| 系統架構、模組規格、使用範例 | `spec-format.instructions.md` |
| 計劃書敘述段落（目標市場需求、產品開發與技術服務） | `proposal-format.instructions.md` |
| 計劃書圖表段落（架構圖、時程、查核點） | `proposal-schedule-format.instructions.md` |

進入任何 plan 提示詞檔的問答步驟前，先讀取對應的現有文件；已有的內容只補齊缺的部分，不整份覆蓋。
