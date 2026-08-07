---
name: test
description: "Use when the user asks to add, run, or update any test — infra, units, modules, or operations. Includes actually driving a live operations test (opening a browser or notebook against the running system), not just writing the test script."
---

# test

使用者要求新增、執行或更新測試時觸發。

1. 先判斷屬於新增、執行、更新哪一種情境，再判斷屬於 infra、units、modules、operations 哪一類。
2. infra／units／modules 三類，依 `.github/instructions/testing.instructions.md` 對應情境的 SOP 執行。
3. operations 類：
   - 情境是新增或更新測試腳本時，依 `testing.instructions.md` 的「新增測試 SOP」／「更新測試 SOP」寫入或修改 `tests/operations/<flow-name>.md`。
   - 情境是執行測試時，直接依 `.github/prompts/operations-test.prompt.md` 的完整流程執行，包含實際用選定工具（VS Code Simple Browser、Jupyter Notebook、終端機等）操作活的系統並記錄結果，不需要使用者另外輸入 `/operations-test`。
