---
description: "協助使用者為一個使用者流程，草擬 <專案資料夾>/.github/specs/usage-examples/<flow-name>.md 的情境、前置條件與步驟初稿，作為驗收標準；實際執行與記錄結果交給 test 技能"
---

# 使用範例驗收標準

依 `spec-format.instructions.md` 的「使用範例／驗收標準」格式，透過問答協助使用者草擬一條使用者操作流程的驗收標準初稿；實際執行與記錄結果由 `test` 技能寫進 `<專案資料夾>/tests/operations/<flow-name>.md`。產出寫入 `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md`。

## 開始之前

1. 確認要草擬的流程名稱；使用者未提供時，先詢問。
2. 開啟 `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md`，確認是否已存在：
   - 已存在：告知使用者已存在，詢問要整組重新建立、還是局部更新；使用者選定後才繼續。
   - 不存在：繼續下方問答步驟。
3. 確認 `<專案資料夾>/.github/specs/overview.md` 已存在——驗收標準需對應到已有規格的模組；overview.md 尚未建立時停下說明原因，改走 `plan-overview.prompt.md` 先建立系統架構。

## 問答步驟

依序詢問，每個欄位問完先覆誦使用者的回答，確認理解正確後再問下一個：

1. 情境／角色：使用者是誰、想完成什麼目標。
2. 前置條件：系統狀態、需要的帳號或資料。
3. 步驟：依序列出操作與每一步的預期結果，湊成完整的步驟表。

## 寫入驗收標準

1. 依 `spec-format.instructions.md`「使用範例／驗收標準」的固定格式，整理情境／角色、前置條件、步驟三段內容。
2. 開啟 `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md`，寫入整理好的內容；檔案不存在時先建立。
3. 在對話中貼出寫入的完整內容，請使用者確認。

## 完成條件

- **格式面**：`<專案資料夾>/.github/specs/usage-examples/<flow-name>.md` 已存在，情境／角色、前置條件、步驟三段齊全——逐一對照 `spec-format.instructions.md`「使用範例／驗收標準」範本確認。
- **內容面**：情境／角色有具體的使用者角色描述；前置條件可操作，讀者能判斷系統是否滿足；步驟表每一步都有對應的預期結果。
- **程序面**：使用者已確認過寫入的內容。
