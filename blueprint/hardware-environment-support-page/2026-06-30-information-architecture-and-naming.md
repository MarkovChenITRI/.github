# Subitem: Information Architecture And Naming

## Problem Statement

使用者目前在 hardware detail 頁看到的是三個平行 tab，但真正需要完成的任務只有兩類：理解裝置本身，以及完成環境前置準備。現況把規格、資源與安裝前置條件拆成三個平行入口，會稀釋真正該被優先閱讀的支援文件。

## Target User / Stakeholder

- 模型開發者
- 部署者
- UI / UX 設計 owner
- PM 驗收者

## Scope

1. 凍結 hardware detail 的主要任務入口數量。
2. 凍結第二入口的正式對外名稱與不用名稱清單。
3. 凍結 `Overview` 與第二入口各自承擔的閱讀任務。

## Acceptance Criteria

1. 明確定義 `Overview` 與第二入口各自要解決的任務，不再有第三個平行主入口。
2. 第二入口正式名稱凍結為 `環境安裝與支援`，並明確列出不用名稱清單。
3. 定義 `Specifications` 被回收到哪種閱讀脈絡，而不是單純刪掉資訊。

## Out Of Scope

1. 不做 wireframe、元件設計或 CSS 決策。
2. 不決定前端 route、template 結構或 JS 狀態管理。

## Delivery Form

- 正式命名決策包
- 導覽定位敘述
- 讀者入口定義

## Decision Freeze

1. 第二入口正式名稱為 `環境安裝與支援`。
2. `支援與合作`、`Drivers and Resources` 不作為本輪對外名稱。
3. `Overview` 保留裝置理解、規格摘要與必要背景。

## 交付驗收（查核點 Checklist）

`Checked` 可接受值：`Y / N / N/A`

| Checkpoint ID | Owner | 完成條件 | 驗證方式 | 證據位置 | Blocking Gate | Signoff |
| --- | --- | --- | --- | --- | --- | --- |
| IA-01 | PM | 已明確寫出兩個主要任務入口的任務定義 | 人工審閱分項檔 | 本檔 Scope / Acceptance Criteria；`templates/pages/hardware/detail.html` product-tabs | 若未定義則不得進 SOP2 | Evidence backfilled in SOP2 |
| IA-02 | PM | 已將第二入口正式名稱凍結為 `環境安裝與支援`，並列出不用名稱 | 人工審閱 Decision Freeze | 本檔 Decision Freeze；`templates/pages/hardware/detail.html` 第二入口文案；`tests/test_solution_template.py` | 若命名未凍結則不得開工 | Signed by PM |
| IA-03 | UI-UX | 已確認 `Specifications` 不會因移除 tab 而失去可讀入口 | UI / UX review | `templates/pages/hardware/detail.html` Overview 內的 `spec-area`；`tests/test_solution_template.py` 驗證 `Specifications` tab 已移除但規格區仍存在 | 若資訊被刪而非回收則 no-go | Implemented by RD, UI-UX signoff pending |
| IA-04 | PM | 已將 `支援與合作` 與 `Drivers and Resources` 排除為本輪對外名稱 | 人工審閱 | 本檔 Decision Freeze；`docs/platform/uxui_architecture.md`；`tests/test_solution_template.py` | 若主名稱仍模糊則 no-go | Signed by PM |
