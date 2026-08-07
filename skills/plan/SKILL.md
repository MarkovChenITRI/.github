---
name: plan
description: "Use when the user wants to plan or draft a spec for a new module or feature, and .github/specs/<layer>.md does not yet have an entry for it."
---

# plan

使用者要規劃或撰寫一個新模組／功能的規格時觸發。

依 `.github/prompts/plan.prompt.md` 的問答流程執行：判斷所屬層級 → 確認 `.github/specs/<layer>.md` 是否已有這個模組的段落 → 依序問答收斂 Who／What／How／Where → 寫入規格書 → 請使用者確認。
