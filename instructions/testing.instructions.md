---
description: "Use when adding, running, or updating any test — infra, units, modules, or operations. First identify which of the three scenarios applies (add / run / update), then follow that scenario's procedure for the relevant category."
applyTo: "tests/{infra,units,modules,operations}/**, .github/workflows/**"
---

# 測試執行準則

## 何時被呼叫

Copilot 處理測試相關任務時，先判斷屬於下列哪一種情境，再到對應段落執行步驟：

- 對應的程式碼或使用者流程還沒有測試 → 走「新增測試 SOP」
- 需要確認現有測試目前是否通過 → 走「執行測試 SOP」
- 對應的程式碼或使用者流程已變更，現有測試需要同步調整 → 走「更新測試 SOP」

三種情境都要先判斷這個測試屬於 infra、units、modules、operations 哪一類，再依該分類的步驟執行。

## 新增測試 SOP

現有程式碼或使用者流程還沒有對應測試時：

### infra

1. 開啟 `.github/specs/infrastructure.md`，找到要驗證的硬體行為與邊界條件。
2. 在 `tests/infra/main.py` 撰寫新的測試案例。
3. 接上目標硬體，在終端機執行 `pytest tests/infra/main.py` 確認新測試通過。

### units

1. 開啟 `.github/specs/domain.md`，找到對應模組的 What 與 How。
2. 在 `tests/units/` 下建立新的測試檔案，外部依賴用假物件（mock/stub）取代。
3. 在終端機執行 `pytest tests/units` 確認新測試通過。

### modules

1. 開啟 `.github/specs/application.md`，找到對應 use case 的 How。
2. 在 `tests/modules/` 下建立新的測試檔案，依情境使用真實依賴或容器化依賴（例如 testcontainers）。
3. 在終端機執行 `pytest tests/modules` 確認新測試通過。

### operations

1. 開啟 `.github/specs/presentation.md`，找到這條新流程要驗證的介面契約。
2. 依「tests/operations/&lt;flow&gt;.md 固定內容」的格式，在 `tests/operations/<flow-name>.md` 建立這條流程的腳本。
3. 依「操作工具對應」選定工具，在對話中輸入 `/operations-test` 首次執行並記錄結果。

## 執行測試 SOP

需要確認現有測試目前是否通過時：

### infra

1. 接上目標硬體，在終端機執行 `pytest tests/infra/main.py`。
2. 這個指令維持本機執行；`.github/workflows/tests.yml` 不包含這個分類。

### units

1. 在終端機執行 `pytest tests/units`。
2. 每次 `git push` 後，GitHub Actions 的 `units` job 也會自動執行同一條指令，結果顯示在 PR 的 checks 清單中。

### modules

1. 在終端機執行 `pytest tests/modules`。
2. 每次 `git push` 後，GitHub Actions 的 `modules` job 也會自動執行同一條指令，結果顯示在 PR 的 checks 清單中。

### operations

1. 在對話中輸入 `/operations-test` 並指定要執行的 `tests/operations/<flow-name>.md`。
2. Copilot 依「操作工具對應」選定的工具逐步實際操作，把結果記錄到該檔案的「執行紀錄」段落。

## 更新測試 SOP

下列任一情境成立時，進入這段 SOP：

- 執行測試後有案例 fail。
- `.github/specs/<layer>.md` 對應模組的段落被更新，測試還沒跟上。

### 判斷步驟

1. 開啟 `.github/specs/<layer>.md`，找到對應模組目前的 What／How。
2. 比對測試案例驗證的行為，跟規格書目前的 What／How 是否一致：
   - 一致（規格書已反映新行為，測試案例還沒跟上）→ 屬於這段 SOP 的更新情境，往下走「更新步驟」。
   - 不一致（規格書內容還是舊的，測試失敗代表程式碼行為偏離規格）→ 屬於回歸，回報該模組段落裡的 Who，處理方式交由 Who 決定。

### 更新步驟

依測試所屬分類，修改對應測試後重新執行確認：

- infra：在 `tests/infra/main.py` 修改對應案例，接上目標硬體，執行 `pytest tests/infra/main.py` 確認通過。
- units：在 `tests/units/` 修改對應測試檔案，執行 `pytest tests/units` 確認通過。
- modules：在 `tests/modules/` 修改對應測試檔案，執行 `pytest tests/modules` 確認通過。
- operations：在 `tests/operations/<flow-name>.md` 更新步驟表與預期結果，在對話中輸入 `/operations-test` 重新執行並記錄結果。

## 操作工具對應

operations 測試依系統曝露方式挑選操作工具：

- Web App：在 VS Code 按 `Ctrl+Shift+P`（macOS 為 `Cmd+Shift+P`）開啟命令選擇區，執行 `Simple Browser: Show`，輸入執行中頁面的網址，在裡面操作。
- Python SDK／library：開啟或建立一個 `.ipynb` notebook，在 cell 中 `import` 該套件、呼叫要驗證的公開 API，執行 cell 觀察輸出。
- CLI 工具：在 VS Code 內建終端機（`` Ctrl+` ``）直接執行要驗證的指令。
- 其他曝露方式：選擇真實使用者實際會用的同一種管道操作。

## tests/operations/&lt;flow&gt;.md 固定內容

```markdown
# <流程名稱>

## 情境／角色
使用者是誰、想完成什麼目標。

## 前置條件
系統狀態、需要的帳號或資料。

## 步驟

| # | 操作 | 預期結果 |
|---|------|---------|
| 1 | ... | ... |

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
├── infra/
│   └── main.py
├── units/
│   └── <鏡射 src/domain/ 的結構>
├── modules/
│   └── <鏡射 src/application/ 的結構>
└── operations/
    └── <flow-name>.md
```

## 設定 CI

在子專案（不是這個 runtime 本身）建立 `.github/workflows/tests.yml`：

```yaml
name: Tests

on: push

jobs:
  units:
    name: Domain Layer Unit Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up environment
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      - name: Run unit tests
        run: pytest tests/units

  modules:
    name: Application Layer Module Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up environment
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      - name: Run module tests
        run: pytest tests/modules
```

這份 workflow 只定義 `units` 與 `modules` 兩個 job；`infra` 維持本機執行，`operations` 由 `/operations-test` 手動觸發。非 Python 專案把 `Set up environment` 與執行指令換成對應語言的安裝與測試指令，job 名稱與觸發規則維持不變。

建好 workflow 後，到 GitHub 網站的 repository 頁面，依序執行：`Settings` → `Branches` → 對目標分支的規則按 `Edit`（或 `Add branch protection rule`）→ 勾選 `Require status checks to pass before merging` → 在搜尋框輸入並勾選 `units` 與 `modules` → 按 `Save changes`。完成後，這兩個 job 的失敗才會擋 merge。

涵蓋外部貢獻者從 fork 送出的 PR 時，改用 `pull_request_target` 觸發，並自行評估這個事件類型帶來的安全風險。

需要在 workflow 中使用機密（API KEY、token、密碼）時，先在 GitHub 網站的 repository 頁面依序執行：`Settings` → `Secrets and variables` → `Actions` → `New repository secret`，登記名稱與值；YAML 中透過 `${{ secrets.KEY_NAME }}` 讀取。
