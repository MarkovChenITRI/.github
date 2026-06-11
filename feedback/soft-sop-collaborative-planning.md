# 軟性 SOP：CEO 連續校準式規劃協作

本文件記錄一次有效的 Connect AI 團隊協作模式，供後續優化 agent 營運、調整 SOP、或訓練新員工時參考。它不是強制流程，而是當專案從 PoC 走向 MVP、需求尚未完全定型、且需要 PM / RD / QE / HR 同步收斂時可套用的軟性作法。

## 適用情境

- CEO 要求盤點專案是否符合 Connect AI 公司化開發準則。
- 現有文件、架構、demo、測試已累積 PoC 債務，需要重新分期與收斂。
- 多個部門對同一個議題各自有合理觀點，但尚未形成一致交付規格。
- 使用者連續修正 agent 的假設，需要把修正寫回文件、藍圖與測試標準。
- 目標不是立即寫大量程式，而是把下一階段 MVP 變成可驗證 contract。

## 核心原則

1. CEO 校準產品真相，agent 負責吸收、重構、落文件。
2. PM 先定義 What / Why / MVP 價值，不替 RD 決定實作細節。
3. RD 把產品方向轉成架構邊界、dependency direction、schema、registry、runtime contract。
4. QE 把 RD contract 轉成 gate，不用「測試很多」掩蓋重疊或缺口。
5. HR / Darwin 觀察合作過程，找出 skill、agent、handoff、SOP 的可改進點。
6. 每次 CEO 修正假設後，必須同步更新規劃文件；不能只在對話中口頭承認。

## 建議流程

### 1. 先盤點現況，不急著規劃

輸入：README、CLAUDE.md、docs、blueprint、核心程式、demo、tests。

產出：

- 已完成的一期成果。
- 還有價值但不該留在主線的歷史成果。
- 當前架構債、測試債、demo 債。
- 哪些東西屬於 SDK core，哪些只是 demo profile。

### 2. PM 先收斂產品目標

PM 需要回答：

- 二期完成後，使用者會得到哪些新 feature。
- 這些 feature 對 MVP 的價值是什麼。
- 哪些是二期不做，避免範圍失控。

若 CEO 修正產品方向，例如「不是遠端部署優先，而是 local-first 一鍵啟動」，PM 必須重新定義 MVP 語言。

### 3. RD 定義可擴展架構

RD 需要把 PM 方向轉為 contract：

- 五節點拓樸語意。
- SDK / demo UI 職責邊界。
- node / provider / tool / profile registry。
- schema-driven property panel。
- secret binding。
- run artifact / provenance。
- trace replay。
- custom node contract。
- execution environment policy，例如 uv-first、conda-compatible。

RD 不應只寫抽象原則；每個 contract 都要能被 demo、Gateway、測試或文件引用。

### 4. QE 誠實盤點測試重疊與缺口

QE 需要明確回答：

- 哪些測試是 unit / integration / E2E / acceptance。
- 哪些測試正在覆蓋相同面向。
- 哪些 PoC 期的 acceptance test 應被降級、合併或改成 contract test。
- 二期新增 contract 要由哪些 gate 保護。

QE 禁止把「測試數量多」等同於品質成熟；若尚未整理完成，應明確說不能宣稱完全獨立。

### 5. CEO 連續質詢時，agent 要更新模型

此模式的重點不是 agent 第一次回答正確，而是每次 CEO 指出偏差後，agent 能做到：

- 承認假設偏差。
- 回到 PM / RD / QE 權責重新拆解。
- 修正主線文件。
- 同步調整 roadmap、architecture、quality gates。
- 記錄需要成為長期習慣的決策。

範例校準點：

- demo 不是附屬玩具，而是 MVP 體驗入口。
- 五節點不是線性 pipeline，而是 bounded cyclic state graph。
- local-first 一鍵啟動是二期核心，不是部署細節。
- schema-driven UI 要以 SDK contract 為真相源，前端 hardcode 只能當 fallback。
- inline Python node 預設用 uv-first execution environment；conda 僅作 vendor stack 相容。

### 6. 文件要收斂，不要把歷史債搬進未來

整理文件時建議分三層：

- Stage summary：保留一期已完成成果與可重用資產。
- Next-phase architecture / quality：定義二期 contract 與 gate。
- Roadmap：只保留 phase、目的、驗收與不做事項。

過長的 milestone、tracks、risk decision 應壓縮成索引或歷史紀錄；未來讀者應能在少量文件中理解目前主線。

## 交付物建議

一次完整規劃會話結束時，至少應留下：

- `docs/00-program-stages.md`：一期 / 二期總覽。
- `blueprint/stage-1-summary.md`：一期成果收斂。
- `blueprint/stage-2-roadmap.md`：二期階段與驗收。
- `docs/01-architecture/next-phase-clean-architecture.md`：RD contract。
- `docs/06-quality/next-phase-test-standard.md`：QE gate。
- repo memory：只記錄會影響未來決策的短句，不寫長篇過程。

若發現既有 skill 或 agent 行為與本次有效合作模式有落差，再由 Darwin 依 HR SOP 另行寫入 `feedback/session-log.md`，不要把本文件當作考核紀錄替代品。

## 成功訊號

- CEO 的修正被吸收進文件，而不是停留在對話。
- PM 能說清楚二期完成後的新 feature 與不做事項。
- RD 能指出 demo UI、Gateway、SDK core、provider、custom node 的邊界。
- QE 能承認測試重疊，並把二期 contract 轉成可執行 gate。
- 後續 agent 接手時，不需要重讀整段會話也能知道目前主線。

## 反模式

- 只產生長文件，沒有壓縮主線。
- 把 demo 當成 disposable UI，忽略它是 MVP 體驗入口。
- 把 PoC hardcode 包裝成架構決策。
- 用抽象名詞代替可測 contract。
- PM 越權指定實作，或 RD / QE 自行擴張商務範圍。
- QE 用測試數量掩蓋測試重疊。
- CEO 修正後只口頭答應，沒有回寫文件。
