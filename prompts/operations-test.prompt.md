---
description: "扮演真實使用者，依 tests/operations/<flow>.md 腳本逐步實際操作系統，並記錄執行結果"
---

# 使用者操作測試 SOP

依 `.github/instructions/operations-test.instructions.md` 的 operations 測試程序，親自扮演目標使用者，執行指定的使用者流程腳本。

## 開始之前

1. 確認要執行哪一份 `tests/operations/<flow>.md`：使用者呼叫時已指定流程名稱就直接使用；未指定時，列出 `tests/operations/` 目錄下所有可用檔案，請使用者選擇。
2. 開啟 `.github/specs/presentation.md`，找到這條流程相關模組的 Who／What／How／Where，取得要驗證的介面契約。
3. 依系統曝露方式選擇操作工具：Web App 用 VS Code 命令選擇區（`Ctrl+Shift+P` / macOS `Cmd+Shift+P`）執行 `Simple Browser: Show` 開啟頁面；Python SDK／library 用 Jupyter Notebook 的 cell `import` 套件並呼叫 API；CLI 工具用 VS Code 內建終端機（`` Ctrl+` ``）；其他曝露方式，選擇真實使用者實際會用的同一種管道。

## 執行步驟

1. 用步驟 3 選定的工具，依腳本「步驟」表的順序逐步實際操作。
2. 每一步操作後，比對腳本記載的預期結果與實際觀察到的畫面或輸出，記下實際結果。
3. 依序完整執行腳本中的每一步，逐步記下實際觀察到的結果，包含與預期不符的步驟。

## 完成條件

1. 腳本內每個步驟都已實際執行並記錄實際結果。
2. 已把執行紀錄（日期、執行者、使用工具、逐步實際結果、整體 pass / partial / fail）寫回該 `tests/operations/<flow>.md` 檔案的「執行紀錄」段落。
3. 已在對話中摘要整體判定結果。
4. 整體判定為 partial 或 fail 時，已指出 `.github/specs/presentation.md` 中對應模組的 Who，把後續處理方式交給對應的 Who 決定。
