---
description: "扮演真實使用者，依 <專案資料夾>/.github/specs/usage-examples/<flow-name>.md 的步驟表逐步實際操作系統，並把執行結果記錄到 <專案資料夾>/tests/operations/<flow-name>.md"
---

# 使用者操作測試

依 `test-operations.instructions.md` 的 operations 測試程序，親自扮演目標使用者，執行指定的使用者流程腳本；使用範例腳本由 `plan` 技能的 `plan-usage-example.prompt.md` 建立。執行紀錄寫入 `<專案資料夾>/tests/operations/<flow-name>.md` 的「執行紀錄」段落。

## 開始之前

1. 確認要執行的流程名稱：使用者呼叫時已指定就直接使用；未指定時，列出 `<專案資料夾>/.github/specs/usage-examples/` 目錄下所有可用檔案，請使用者選擇。
2. 確認腳本與紀錄檔都已備妥：開啟 `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md` 取得這條流程的情境／角色、前置條件與步驟表；確認 `<專案資料夾>/tests/operations/<flow-name>.md` 是否已存在（已存在時，這次執行會在現有「執行紀錄」段落後新增一筆；不存在時，依 `templates/test-operations.md` 先建立檔案）。
3. 確認 `<專案資料夾>/.github/specs/presentation.md` 已存在，找到這條流程相關模組的 Who／What／How／Where，取得要驗證的介面契約，並依系統曝露方式選定操作工具：Web App 用 VS Code 命令選擇區執行 `Simple Browser: Show`；Python SDK／library 用 Jupyter Notebook cell；CLI 工具用 VS Code 內建終端機；其他曝露方式選擇真實使用者實際會用的同一種管道。

## 執行步驟

1. 用步驟 4 選定的工具，依步驟 2 取得的 `.github/specs/usage-examples/<flow-name>.md`「步驟」表順序逐步實際操作。
2. 每一步操作後，比對該表記載的預期結果與實際觀察到的畫面或輸出，記下實際結果。
3. 依序完整執行「步驟」表中的每一步，逐步記下實際觀察到的結果，包含與預期不符的步驟。

## 寫入測試紀錄

1. 依 `test-operations.instructions.md`「tests/operations/<flow>.md 固定內容」的格式，把逐步實際結果與整體判定整理成可寫入狀態。
2. 開啟 `<專案資料夾>/tests/operations/<flow-name>.md`，在「執行紀錄」段落寫入日期、執行者、使用工具、逐步實際結果、整體判定；檔案不存在時先建立。
3. 在對話中摘要整體判定結果，請使用者確認；整體判定為 partial 或 fail 時，同時指出 `<專案資料夾>/.github/specs/presentation.md` 中對應模組的 Who，把後續處理方式交給對應的 Who 決定。

## 完成條件

- **格式面**：`<專案資料夾>/tests/operations/<flow-name>.md` 已存在，「執行紀錄」段落包含日期、執行者、使用工具、逐步實際結果（步驟表）、整體判定五個欄位——逐一對照 `test-operations.instructions.md`「固定內容」確認。
- **內容面**：步驟表內每個步驟都已實際執行並記下實際觀察（含與預期不符的步驟）；整體判定為 partial 或 fail 時，已指出對應模組的 Who。
- **程序面**：使用者已確認過整體判定結果。
