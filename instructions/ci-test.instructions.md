---
description: "Use when adding, running, or updating a units or modules test, or setting up the CI workflow that runs them."
applyTo: "tests/units/**, tests/modules/**, .github/workflows/**"
---

# CI 自動化執行（units、modules）測試準則

## 測試金字塔

units、modules、operations 三類除了執行機制不同，該寫多少數量也不同，依測試金字塔原則分配：

1. units 數量最多、涵蓋情境最廣：外部依賴都用假物件取代，執行最快、成本最低，同一個模組的每一種輸入組合與邊界條件都該有對應案例。
2. modules 數量次之：只驗證跨模組整合才會出錯的行為（例如真實依賴的組合方式、交易邊界），units 已經涵蓋的單一模組邏輯不重複寫。
3. operations 數量最少，理由見 `operations-test.instructions.md`。

infra 不適用這個比例，見 `infra-test.instructions.md`。

新增測試前，先確認這個情境有沒有被更底層的測試涵蓋過——modules 動筆前先看 units 有沒有涵蓋、operations 動筆前先看 modules 有沒有涵蓋；已經涵蓋時，優先在底層補案例，不疊加到上層。

## 新增測試 SOP

現有程式碼還沒有對應測試時：

### units

1. 開啟 `<專案資料夾>/.github/specs/domain.md`，找到對應模組的 What 與 How。
2. 在 `<專案資料夾>/tests/units/` 下建立新的測試檔案，外部依賴用假物件（mock/stub）取代。
3. 在終端機執行 `pytest <專案資料夾>/tests/units` 確認新測試通過。

### modules

1. 開啟 `<專案資料夾>/.github/specs/application.md`，找到對應 use case 的 How。
2. 在 `<專案資料夾>/tests/modules/` 下建立新的測試檔案，依情境使用真實依賴或容器化依賴（例如 testcontainers）。
3. 在終端機執行 `pytest <專案資料夾>/tests/modules` 確認新測試通過。

## 執行測試 SOP

需要確認現有測試目前是否通過時：

### units

1. 在終端機執行 `pytest <專案資料夾>/tests/units`。
2. 每次 `git push` 後，GitHub Actions 的 `units` job 也會自動執行同一條指令（在 CI 執行環境裡，`<專案資料夾>` 就是簽出後的檢查目錄本身，指令維持 `pytest tests/units` 不加前綴，見下方「設定 CI」），結果顯示在 PR 的 checks 清單中。

### modules

1. 在終端機執行 `pytest <專案資料夾>/tests/modules`。
2. 每次 `git push` 後，GitHub Actions 的 `modules` job 也會自動執行同一條指令，結果顯示在 PR 的 checks 清單中。

## 更新測試 SOP

下列任一情境成立時，進入這段 SOP：

- 執行測試後有案例 fail。
- `<專案資料夾>/.github/specs/<layer>.md` 對應模組的段落被更新，測試還沒跟上。

### 判斷步驟

1. 開啟 `<專案資料夾>/.github/specs/<layer>.md`，找到對應模組目前的 What／How。
2. 比對測試案例驗證的行為，跟規格書目前的 What／How 是否一致：
   - 一致（規格書已反映新行為，測試案例還沒跟上）→ 屬於這段 SOP 的更新情境，往下走「更新步驟」。
   - 不一致（規格書內容還是舊的，測試失敗代表程式碼行為偏離規格）→ 屬於回歸，回報該模組段落裡的 Who，處理方式交由 Who 決定。

### 更新步驟

- units：在 `<專案資料夾>/tests/units/` 修改對應測試檔案，執行 `pytest <專案資料夾>/tests/units` 確認通過。
- modules：在 `<專案資料夾>/tests/modules/` 修改對應測試檔案，執行 `pytest <專案資料夾>/tests/modules` 確認通過。

## 目錄結構

```text
tests/
├── units/
│   └── <鏡射 src/domain/ 的結構>
└── modules/
    └── <鏡射 src/application/ 的結構>
```

## 設定 CI

在 `<專案資料夾>`（不是這個 runtime 本身）底下建立 `.github/workflows/tests.yml`：

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

這份 workflow 只定義 `units` 與 `modules` 兩個 job；`infra` 維持本機執行，`operations` 由 `/test-operations` 手動觸發。非 Python 專案把 `Set up environment` 與執行指令換成對應語言的安裝與測試指令，job 名稱與觸發規則維持不變。

建好 workflow 後，到 GitHub 網站的 repository 頁面，依序執行：`Settings` → `Branches` → 對目標分支的規則按 `Edit`（或 `Add branch protection rule`）→ 勾選 `Require status checks to pass before merging` → 在搜尋框輸入並勾選 `units` 與 `modules` → 按 `Save changes`。完成後，這兩個 job 的失敗才會擋 merge。

涵蓋外部貢獻者從 fork 送出的 PR 時，改用 `pull_request_target` 觸發，並自行評估這個事件類型帶來的安全風險。

需要在 workflow 中使用機密（API KEY、token、密碼）時，先在 GitHub 網站的 repository 頁面依序執行：`Settings` → `Secrets and variables` → `Actions` → `New repository secret`，登記名稱與值；YAML 中透過 `${{ secrets.KEY_NAME }}` 讀取。
