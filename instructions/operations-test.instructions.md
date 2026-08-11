---
description: "Use when adding, running, or updating an operations test — a live user-flow test that Copilot drives directly against the running system."
applyTo: "tests/operations/**"
---

# Copilot 操作驗證（operations）測試準則

operations 數量最少，比例原則見 `ci-test.instructions.md` 的「測試金字塔」段落。

## 新增測試 SOP

現有使用者流程還沒有對應測試時：

1. 開啟 `<專案資料夾>/.github/specs/presentation.md`，找到這條新流程要驗證的介面契約。
2. `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md` 還沒有初稿時，交給 `plan` 技能的 `plan-usage-example.prompt.md` 建立；已有初稿時，直接沿用。
3. 依「操作工具對應」選定工具，在對話中輸入 `/operations-test` 首次執行並記錄結果。

## 執行測試 SOP

需要確認現有測試目前是否通過時：

1. 在對話中輸入 `/operations-test` 並指定要執行的流程；步驟表與預期結果依 `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md` 為準。
2. Copilot 依「操作工具對應」選定的工具逐步實際操作，把結果記錄到 `<專案資料夾>/tests/operations/<flow-name>.md` 的「執行紀錄」段落。

## 更新測試 SOP

下列任一情境成立時，進入這段 SOP：

- 執行測試後有案例 fail。
- `<專案資料夾>/.github/specs/presentation.md` 對應模組的段落被更新，測試還沒跟上。
- `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md` 的步驟被更新，執行還沒跟上。

### 判斷步驟

1. 開啟 `<專案資料夾>/.github/specs/presentation.md`，找到對應模組目前的 What／How。
2. 比對測試案例驗證的行為，跟規格書目前的 What／How 是否一致：
   - 一致（規格書已反映新行為，測試案例還沒跟上）→ 屬於這段 SOP 的更新情境，往下走「更新步驟」。
   - 不一致（規格書內容還是舊的，測試失敗代表程式碼行為偏離規格）→ 屬於回歸，回報該模組段落裡的 Who，處理方式交由 Who 決定。

### 更新步驟

先更新 `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md` 的步驟表與預期結果，在對話中輸入 `/operations-test` 依新步驟重新執行，結果記到 `<專案資料夾>/tests/operations/<flow-name>.md` 的「執行紀錄」段落。

## 操作工具對應

operations 測試依系統曝露方式挑選操作工具：

- Web App：在 VS Code 按 `Ctrl+Shift+P`（macOS 為 `Cmd+Shift+P`）開啟命令選擇區，執行 `Simple Browser: Show`，輸入執行中頁面的網址，在裡面操作。
- Python SDK／library：開啟或建立一個 `.ipynb` notebook，在 cell 中 `import` 該套件、呼叫要驗證的公開 API，執行 cell 觀察輸出。
- CLI 工具：在 VS Code 內建終端機（`` Ctrl+` ``）直接執行要驗證的指令。
- 其他曝露方式：選擇真實使用者實際會用的同一種管道操作。

## tests/operations/&lt;flow&gt;.md 固定內容

```markdown
# <流程名稱>

驗收標準見 `<專案資料夾>/.github/specs/usage-examples/<flow-name>.md`。

## 執行紀錄
- 日期：
- 執行者：
- 使用工具：
- 逐步實際結果：
- 整體判定：pass / partial / fail
```

## 目錄結構

```text
tests/
└── operations/
    └── <flow-name>.md
```
