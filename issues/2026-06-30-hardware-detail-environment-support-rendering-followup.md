# Issue: Hardware Detail 環境安裝與支援內容編碼 / 版面結構 follow-up

- Date: `2026-06-30`
- Issue Type: `bug + IA follow-up`
- Reporter: `field-application-engineer`
- Severity: `high`
- Current Status: `open`

## Issue Classification

| Field | Value |
| --- | --- |
| Problem Class | Production content integrity + information architecture mismatch |
| Affected Surface | `/hardware/<slug>` public detail page |
| User Impact | 使用者會看到 `????` 的壞資料，且 `環境安裝與支援` 被放在下方支援資源區而非主內容切換區 |
| Reproduction Status | Reproduced |

## Reproduction Summary

1. 開啟任一 AMD 裝置的 `/hardware/<slug>`。
2. 觀察 `環境安裝與支援` 內容區。
3. 實際結果：畫面出現 `????`；版面上 `環境安裝與支援` 與下方支援資源混在同一區塊。

## Evidence

| Evidence ID | Description |
| --- | --- |
| EV-01 | Live DB readback：`hardware_device.support_markdown` 在正式 Azure SQL 中已存成 `????`，證明不是 Markdown renderer 缺失，而是資料寫入時的編碼損壞。 |
| EV-02 | Repo code readback：`utils/hardware/markdown_support.py` 已存在 server-side Markdown renderer，模板也有使用 `product.support_markdown_html|safe`。 |
| EV-03 | Live page screenshot：`環境安裝與支援` 區塊顯示 `????`，且內容位置落在下方資源區。 |

## Suspected Owners And Action Items

| Owner | Action Item | Done When | Verification |
| --- | --- | --- | --- |
| `senior-software-engineer` | 將正式 `support_markdown` 改為從 repo-backed UTF-8 真相源回寫，不再從易亂碼的臨時 terminal payload 直接灌入 | 正式 DB 中 AMD 兩台內容可正確顯示中文，其他裝置明確顯示來源邊界文案 | Live DB readback + `/hardware/<slug>` smoke |
| `senior-software-engineer` | 調整模板結構，讓 `Overview / 環境安裝與支援` 變成上方主內容切換；下方區塊固定為 `技術支援與合作` | 點擊上方 tab 時切換主內容；下方只保留固定支援資源 | Template test + live page smoke |
| `testing-quality-engineer` | 補充針對主內容切換與下方固定支援區的驗證 | 窄測試涵蓋新的 DOM 結構與文字邊界 | `python -m pytest tests/test_solution_template.py -q` |
| `field-application-engineer` | 保留本 issue 作為 production incident 與來源邊界紀錄 | Issue 內已有 root cause、owner、驗證方式與 closure criteria | Issue completeness review |

## Closure Criteria

1. 正式 DB 讀回的 `support_markdown` 不再含 `????`。
2. `/hardware/<slug>` 頁面上方主內容可在 `Overview` 與 `環境安裝與支援` 間切換。
3. 下方區塊固定為 `技術支援與合作`，不再混放環境安裝文件。
4. 測試與 live smoke 皆通過。