---
description: "Use when adding, running, or updating an infra test — hardware-dependent tests that only run locally."
applyTo: "tests/infra/**"
---

# 僅本機驗證（infra）測試準則

這一類不適用測試金字塔比例，數量以實際要驗證的硬體行為與邊界條件為準（units、modules、operations 三類的比例原則見 `test-ci.instructions.md` 的「測試金字塔」段落）。

## 新增測試 SOP

現有程式碼還沒有對應測試時：

1. 開啟 `<專案資料夾>/.github/specs/infrastructure.md`，找到要驗證的硬體行為與邊界條件。
2. 在 `<專案資料夾>/tests/infra/main.py` 撰寫新的測試案例。
3. 接上目標硬體，在終端機執行 `pytest <專案資料夾>/tests/infra/main.py` 確認新測試通過。

## 執行測試 SOP

需要確認現有測試目前是否通過時：

1. 接上目標硬體，在終端機執行 `pytest <專案資料夾>/tests/infra/main.py`。
2. 這個指令維持本機執行；`<專案資料夾>/.github/workflows/tests.yml` 不包含這個分類。

## 更新測試 SOP

下列任一情境成立時，進入這段 SOP：

- 執行測試後有案例 fail。
- `<專案資料夾>/.github/specs/infrastructure.md` 對應模組的段落被更新，測試還沒跟上。

### 判斷步驟

1. 開啟 `<專案資料夾>/.github/specs/infrastructure.md`，找到對應模組目前的 What／How。
2. 比對測試案例驗證的行為，跟規格書目前的 What／How 是否一致：
   - 一致（規格書已反映新行為，測試案例還沒跟上）→ 屬於這段 SOP 的更新情境，往下走「更新步驟」。
   - 不一致（規格書內容還是舊的，測試失敗代表程式碼行為偏離規格）→ 屬於回歸，回報該模組段落裡的 Who，處理方式交由 Who 決定。

### 更新步驟

在 `<專案資料夾>/tests/infra/main.py` 修改對應案例，接上目標硬體，執行 `pytest <專案資料夾>/tests/infra/main.py` 確認通過。

## 目錄結構

```text
tests/
└── infra/
    └── main.py
```
