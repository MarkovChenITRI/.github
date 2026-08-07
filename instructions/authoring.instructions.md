---
description: "Use when adding or editing a rule, procedure, or skill inside this runtime's own .github/instructions, .github/prompts, or .github/skills directories. Gives the decision procedure for which mechanism to use."
applyTo: ".github/instructions/**/*.md, .github/prompts/**/*.md, .github/skills/**/*.md"
---

# 新增規則或流程的判斷 SOP

依序回答下列問題，走到符合的分支就照做，不必往下看其他分支：

1. 這件事要不要不管使用者怎麼講、只要 Copilot 碰到符合路徑的檔案就套用？
   - 是 → 建立 `instructions/<name>.instructions.md`：frontmatter 寫 `description`（何時該用）與 `applyTo`（涵蓋的檔案路徑 glob），內文放規則與 SOP 本體。完成。
   - 否 → 進第 2 題。
2. 這件事有沒有實際副作用（操作活系統、寫入外部服務、對外送出東西）？
   - 有 → 建立 `prompts/<name>.prompt.md`：frontmatter 寫 `description`，內文放完整流程；這個流程只能用 `/<name>` 手動呼叫觸發。完成，不進第 3 題。
   - 沒有 → 進第 3 題。
3. 使用者只用自然語言講出意圖、沒有提到檔名或指令時，這件事需不需要照樣被觸發？
   - 需要 → 內容本體依第 1、2 題的判斷寫進 `instructions/<name>.instructions.md` 或 `prompts/<name>.prompt.md`，再另外建立 `skills/<name>/SKILL.md`：資料夾名稱等於 frontmatter 的 `name`；`description` 寫清楚「做什麼＋何時該用」；內文只指向第 1、2 題建立的那份 instructions 或 prompts 檔案執行，維持流程本體只在一個地方寫。完成。
   - 不需要 → 只留 instructions 或 prompts，不建 skill。完成。

## 用詞規則

內文一律用台灣中文的日常說法，讓沒碰過這套系統的人一讀就懂。檔案路徑、frontmatter 欄位名稱（例如 `applyTo`、`description`、`name`）、指令與程式碼維持原樣，用反引號標起來；除此之外的敘述文字，遇到英文技術詞或大陸用語，換成台灣人日常會講的中文說法。

寫完後自我檢查：內文若混入路徑、欄位名稱、指令以外的英文字或縮寫，先想一次台灣人平常會怎麼講同一件事，能換就換掉。
