# Issue: Hardware 環境安裝與支援線上 Editor 體驗不符需求

- Date: `2026-06-30`
- Issue Type: `product requirement mismatch`
- Reporter: `field-application-engineer`
- Severity: `high`
- Current Status: `open`

## Issue Classification

| Field | Value |
| --- | --- |
| Problem Class | Authoring UX mismatch |
| Affected Surface | `/hardware/<slug>` admin edit flow for `環境安裝與支援` |
| User Impact | 平台管理者目前拿到的是欄位級 Markdown 輸入，但需求期待的是可直接線上編修、承擔 editor 角色的內容編輯體驗 |
| Reproduction Status | Reproduced from current implementation review + user report |

## Reproduction Summary

1. 以 admin 身分進入任一 hardware detail 頁。
2. 切換到 `編輯模式`。
3. 觀察 `環境安裝與支援` 的編修介面。
4. 實際結果：目前只提供 `hardwareSupportMarkdownInput` textarea 型態的欄位編輯，偏向資料欄位寫入流程；使用者明確回報這和原先要求的 `GitHub form editor` 型線上編輯體驗不符。

## Expected Behavior

1. `環境安裝與支援` 應提供線上可編修的 editor 體驗，而不只是單純綁一個 Markdown 欄位。
2. 編修者應感受到自己在操作內容 editor，而不是只是在維護一段被硬關聯的靜態內容來源。
3. 編輯流程應支援內容編修這個角色的核心任務，例如可讀的輸入區、清楚的編修狀態，以及必要時的預覽或等價回饋。

## Evidence

| Evidence ID | Description |
| --- | --- |
| EV-01 | 使用者最新回報：`環境安裝與支援和我當初要的github form editor不符，你現在是硬關聯一個檔案而不是讓人能夠線上編輯`。 |
| EV-02 | 目前 template 實作在 `templates/pages/hardware/detail.html` 只暴露 `id="hardwareSupportMarkdownInput"` 的 textarea。 |
| EV-03 | 目前前端腳本在 `static/js/hardware-detail.js` 只把 `support_markdown` 作為一般欄位值送出，尚未表達 editor workflow。 |

## Suspected Owners And Action Items

| Owner | Action Item | Done When | Verification |
| --- | --- | --- | --- |
| `product-strategy-manager` | 補明確定義 `GitHub form editor` 在本產品中的最低體驗契約，避免後續再次把「可維護 Markdown」誤落成單純欄位 | 有一份可交付給 RD / UI 的 editor acceptance criteria | Requirement review |
| `ui-ux-designer` | 將 `環境安裝與支援` 的 admin 編修流程定義成 editor 任務流，而不是單一 textarea 欄位 | 有明確的互動狀態、輸入區結構與回饋要求 | UX review |
| `senior-software-engineer` | 依新的 editor 契約調整 admin 編修介面與資料提交流程 | admin 頁面呈現線上 editor 體驗，且不再只有欄位級輸入感 | Template / JS review + manual smoke |
| `testing-quality-engineer` | 補一條驗收，確保 `環境安裝與支援` 的編修介面符合 editor 任務，而不是退化回單純 textarea 欄位 | regression 不再重現 | Narrow test + admin smoke |
| `field-application-engineer` | 維持本 issue 作為使用者需求落差、重現方式與 closure recommendation 真相源 | Issue 欄位與證據完整 | Issue completeness review |

## Closure Criteria

1. `環境安裝與支援` 的 admin 編修介面被驗證為線上 editor 體驗，而不只是單一欄位編輯。
2. 使用者原始要求中的 `GitHub form editor` 差距已被翻譯成可驗證的產品與 UI 契約。
3. 修正後需附 admin 編輯畫面截圖、互動錄影或同等級可追溯證據。
4. 驗收必須明確證明編修者是在操作 editor workflow，而不是只對靜態欄位值做輸入。