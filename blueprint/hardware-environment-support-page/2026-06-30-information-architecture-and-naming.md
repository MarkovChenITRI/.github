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

## Expected Benefits

1. 讓模型開發者與部署者在進入 hardware detail 時，先看到真正影響環境準備成功率的主要任務入口，而不是被平行 tab 分散注意力。
2. 讓平台對外命名穩定，降低 `支援`、`資源`、`安裝` 等語意混用造成的理解成本與後續文案漂移。
3. 讓 `Specifications` 資訊保留在正確脈絡中被閱讀，避免因導覽重整造成資訊遺失或誤判產品弱化規格揭露。

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

## Execution Strategy And Content Plan

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| 任務入口收斂 | PM | 把 hardware detail 的主要使用者任務收斂成兩個入口，明確定義 `Overview` 與第二入口各自解決的閱讀任務 | 本檔 Problem Statement / Scope / Acceptance Criteria；`templates/pages/hardware/detail.html` product-tabs | 任務入口定義稿 | IA-01 必須先成立，否則 RD 無法依固定入口施工 | 分項檔已明確寫出兩個主要任務入口的任務定義 |
| 正式命名凍結 | PM | 凍結第二入口正式名稱，並同步列出排除名稱，避免 UI、文件與測試各自採用不同命名 | 本檔 Decision Freeze；`templates/pages/hardware/detail.html` 第二入口文案；`docs/platform/uxui_architecture.md` | 正式命名決策包 | IA-02、IA-04 必須成立，否則不得開工 | 第二入口正式名稱與排除名稱已在 blueprint 與對應觸碰面對齊 |
| 規格資訊回收 | UI-UX / RD | 將 `Specifications` 從主入口移除，但保留其內容在 `Overview` 脈絡中可閱讀，避免資訊遺失 | `templates/pages/hardware/detail.html` Overview 內 `spec-area`；`tests/test_solution_template.py` | 規格回收方案 | IA-03 必須成立，否則導覽調整會造成資訊缺口 | `Specifications` 不再是獨立 tab，但規格內容仍可在 Overview 內找到 |

## Decision Freeze

1. 第二入口正式名稱為 `環境安裝與支援`。
2. `支援與合作`、`Drivers and Resources` 不作為本輪對外名稱。
3. `Overview` 保留裝置理解、規格摘要與必要背景。

## 交付驗收（查核點 Checklist）

`Checked` 可接受值：`Y / N / N/A`

| Checkpoint ID | Owner | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 | Blocking Gate | Signoff |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| IA-01 | PM | 已明確寫出兩個主要任務入口的任務定義 | 使用者能先分辨「理解裝置」與「完成環境前置」兩類任務，降低進站後的導覽判斷成本 | 在 blueprint 中凍結 `Overview` 與第二入口的任務邊界，並要求 UI 與模板只保留兩個主要入口 | 人工審閱分項檔 | 本檔 Scope / Acceptance Criteria；`templates/pages/hardware/detail.html` product-tabs | 若未定義則不得進 SOP2 | Evidence backfilled in SOP2 |
| IA-02 | PM | 已將第二入口正式名稱凍結為 `環境安裝與支援`，並列出不用名稱 | 對外命名一致，讓後續文件、UI 文案與驗收不再因名稱擺盪產生重工 | 在 Decision Freeze 與對應 UI / 文件觸碰面同步凍結正式名稱，並列出排除名稱清單 | 人工審閱 Decision Freeze | 本檔 Decision Freeze；`templates/pages/hardware/detail.html` 第二入口文案；`tests/test_solution_template.py` | 若命名未凍結則不得開工 | Signed by PM |
| IA-03 | UI-UX | 已確認 `Specifications` 不會因移除 tab 而失去可讀入口 | 導覽收斂後仍保留規格閱讀能力，避免使用者誤以為平台拿掉產品規格資訊 | 把 `Specifications` 的閱讀內容回收到 `Overview` 區塊，而不是直接刪除規格內容 | UI / UX review | `templates/pages/hardware/detail.html` Overview 內的 `spec-area`；`tests/test_solution_template.py` 驗證 `Specifications` tab 已移除但規格區仍存在 | 若資訊被刪而非回收則 no-go | Implemented by RD, UI-UX signoff pending |
| IA-04 | PM | 已將 `支援與合作` 與 `Drivers and Resources` 排除為本輪對外名稱 | 減少名稱過寬或語意偏移，讓第二入口穩定聚焦在環境準備與支援文件 | 把不用名稱明確寫入 blueprint 與對應文件，禁止施工時回退到舊名稱或混用名稱 | 人工審閱 | 本檔 Decision Freeze；`docs/platform/uxui_architecture.md`；`tests/test_solution_template.py` | 若主名稱仍模糊則 no-go | Signed by PM |
