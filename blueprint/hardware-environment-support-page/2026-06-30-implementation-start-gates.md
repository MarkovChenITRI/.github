# Subitem: Implementation Start Gates

## Problem Statement

若直接從概念跳到施工，RD 會同時承接命名、資訊架構、內容邊界與驗收入口的不確定性，容易導致施工中途反覆重切。這份分項的用途是把開工前必須凍結的 gate 寫成可簽核條件。

## Target User / Stakeholder

- RD
- QE
- PM
- FAE

## Scope

1. 凍結可開工前的 blocking gate。
2. 凍結後續 workorder 必須承接的驗收入口。
3. 排除已完成項目，避免工單重工。

## Acceptance Criteria

1. RD 可從本分項直接知道開工前還缺哪些已凍結輸入。
2. QE 可直接從本分項知道後續要驗什麼，不需再補問目標行為。
3. 已完成項目已明確列為不重工範圍。

## Out Of Scope

1. 不寫 test case、CI 指令或工時。
2. 不安排施工順序或分 sprint。

## Delivery Form

- 開工 gate 表
- Handoff package 表
- 不重工清單

## Handoff Package

| From | To | Required Input |
| --- | --- | --- |
| PM | RD | `環境安裝與支援` 正式命名凍結、資訊架構凍結、Markdown 內容定位、已完成項目排除清單 |
| PM | QE | 使用者任務、最低成功標準、blocking gate |
| PM | FAE | 支援入口定位、平台與原廠責任邊界 |

## 交付驗收（查核點 Checklist）

`Checked` 可接受值：`Y / N / N/A`

| Checkpoint ID | Owner | 完成條件 | 驗證方式 | 證據位置 | Blocking Gate | Signoff |
| --- | --- | --- | --- | --- | --- | --- |
| GATE-01 | PM | 已列出不重工清單，且與本 initiative 範圍一致 | 人工審閱 Manifest 與本檔 | `00-manifest.md` 已完成項目段落；本次實作未回頭修改 `/guide` 與 docs cleanup 既有項目 | 若已完成項目仍被開工則 no-go | Evidence backfilled in SOP2 |
| GATE-02 | PM / RD | RD 已收到包含 `環境安裝與支援` 正式名稱在內的 What / Why 輸入，可直接進 SOP2 | RD handoff review | 本檔 Handoff Package；實作落地於 `utils/hardware/__init__.py`、`templates/pages/hardware/detail.html`、`static/js/hardware-detail.js` | 若 RD 仍需回推對話則不得開工 | Signed by RD via implementation |
| GATE-03 | PM / QE | QE 已有可追的驗收入口 | QE handoff review | `tests/test_hardware_products.py`、`tests/test_solution_template.py`；focused validation：`python -m pytest tests/test_hardware_products.py tests/test_solution_template.py -q` → `70 passed` | 若驗收入口模糊則不得開工 | Validated by focused test run |
| GATE-04 | PM | 本 initiative 未偷渡 API / schema / framework How | 人工審閱全文 | 本檔與其他分項檔仍維持 What / Why / Gate 描述；How 僅存在 SOP2 實作檔案 | 若混入 How 則退回 SOP1 | Evidence backfilled in SOP2 |