---
description: "Use when a blueprint task is in the 開始 → 規劃 stage. Define the input contract, standard output package, and freeze criteria for turning a vague request into a reviewable blueprint."
applyTo: ".github/blueprint/README.md,.github/blueprint/**/00-manifest.md,.github/blueprint/**/*.md,blueprint/**/00-manifest.md,blueprint/**/*.md"
---

# Blueprint SOP1：開始到規劃

SOP1 只處理把需求變成可施工 blueprint 的前半段，不承接最終程式實作細節，也不承接驗收細節。CEO 在這一段必須先提供商務真相與計畫架構圖；`product-strategy-manager` 再把它 formalize 成可交接的 manifest 與分項規劃檔，不直接決定 RD 的最終程式寫法，但必須把每個分項整理成可交棒的施工藍圖。

## 標準輸入

| 項目 | 內容 |
|------|------|
| 啟動來源 | CEO 指示、使用者回報、Issue、商務需求、內部風險訊號 |
| CEO 商務真相 | 為誰解決什麼問題、最低成功標準、明確不做的範圍、外部限制 |
| 計畫架構圖 | 該期目標、分項、分項依賴、資源級別與最低成功判定 |
| 已知前提 | 現況、限制、不可變更邊界、利害關係人 |
| 初始問題定義 | 要解決什麼、為誰解決、成功的最低判定是什麼 |

## 標準產出

| 項目 | 內容 |
|------|------|
| `00-manifest.md` | initiative 級母檔，承接計畫架構圖、分項索引與凍結線 |
| 分項規劃檔 | 每個分項一份 `yyyy-mm-dd-<subitem-english-name>.md` |
| Blueprint package | manifest + 分項規劃檔組成的可交接規劃包，不是摘要筆記 |
| CEO Immutable Acceptance Source | CEO 明確提出的原始要求、命名、資訊架構、最低成功標準與不可變更邊界 |
| 角色 Handoff Package | PM / RD / QE / FAE / HR 對應輸出 |
| 查核點定義 | owner、完成條件、預期效益、執行方法、驗證方式、簽署欄位 |
| 施工藍圖 | 每個分項的執行策略、內容規劃、觸碰面與交付物 |
| 規劃凍結線 | 進入 SOP2 後不得任意漂移的內容 |

### CEO 明確輸入不可變更規則

CEO 已明確提供的原始要求、功能域名稱、巢狀資訊架構、最低成功標準、不可變更邊界與外部限制，必須在 manifest 中以 `CEO Immutable Acceptance Source` 或等價段落保留，並作為後續 SOP 的最高驗收來源。

`product-strategy-manager` 可以把 CEO 輸入 formalize 成分項、Page Inventory、施工藍圖或查核點，但不得在未取得 CEO 明確同意前壓縮、替換、改名、合併、移除或改變層級。若 PM 需要提出不同頁面數、不同命名或不同 IA 層級，必須標示為 `PM proposed mapping`，並在 CEO 同意前保持 `blocked`，不得視為凍結契約。

任何 Page Inventory、分項索引或施工藍圖都只是 CEO 明確輸入的 derived artifact，不得反向取代 CEO 原始要求。若 derived artifact 與 CEO 明確輸入不一致，SOP1 不得宣稱完成，也不得進入 SOP2。

### 使用者文件重寫 blueprint 的額外產出

若 initiative 目標是重寫 README、docs、Pages 文件、維運手冊、developer site 或任何使用者可見文件，SOP1 除一般 blueprint 產出外，還必須在 manifest 或導覽治理分項中凍結一份 `Page Inventory 與寫作契約`，至少包含欄位：`Page ID | 預定路徑 | 對外標題 | 文件類型 | 讀者任務 | 主來源 | 輔助來源 | 可宣稱內容 | 必須待確認內容 | 本輪產出狀態 | 驗證方式`。

其中 `文件類型` 必須對應 `.github/instructions/user-facing-docs.instructions.md` 的任務型、概念型或參考型；若某頁來源不足，`本輪產出狀態` 必須明示為 `draft-placeholder`、`deferred` 或其他 PM 凍結狀態，不得讓 SOP2 owner 自行判斷是否定稿。

## CEO 在 SOP1 的責任

1. 提供商務真相、外部限制與人類才知道的前提。
2. 提供該期計畫架構圖，至少列出期目標、分項、分項依賴、資源級別與最低成功判定。
3. 不直接指定工程實作、驗證方法、時程切法或 RD 的技術拆模方式。
4. 若缺正式環境政策、法律邊界、真人測試資源等人類輸入，需在 SOP1 就先標成待提供條件，而不是等 SOP3 才臨時發現。

## Blueprint 檔案與命名規範

### Initiative 結構

每個 initiative 應建立在 `blueprint/<feature-name>/` 目錄下，最小結構如下：

```text
blueprint/<feature-name>/
├── 00-manifest.md
├── yyyy-mm-dd-<subitem-english-name>.md
├── yyyy-mm-dd-<subitem-english-name>.md
└── ...
```

### 檔名規則

1. manifest 檔名固定為 `00-manifest.md`。
2. 每個分項固定一份檔案，檔名格式為 `yyyy-mm-dd-<subitem-english-name>.md`。
3. `<subitem-english-name>` 必須使用 PM 統一命名的英文 slug，僅允許小寫英文字母、數字與連字號。
4. 禁止使用中文檔名、`final`、`new`、`latest`、`v2` 這類無語意字尾。
5. 若同日同名衝突，尾碼補 `-01`、`-02`，但仍視為同一命名體系。

### `00-manifest.md` 固定內容

`00-manifest.md` 至少包含以下段落，順序不可顛倒：

1. 本期目標
2. CEO 商務真相摘要
3. CEO Immutable Acceptance Source
4. 預期效益
5. 計畫架構圖
6. 分項索引表
7. 規劃凍結線
8. CEO 待提供資源

分項索引表至少包含欄位：`Subitem ID | 分項名稱 | Owner | Depends On | Resource Level | Blueprint File | Planned Workorder File | Status`。

### 分項規劃檔固定內容

每份 `yyyy-mm-dd-<subitem-english-name>.md` 至少包含以下段落，順序不可顛倒：

1. 標題
2. Metadata 表
3. 角色指派表
4. 問題陳述與分項目標
5. 預期效益
6. In Scope
7. Out of Scope
8. 前置依賴與輸入契約
9. 執行策略與內容規劃
10. 交付物清單
11. 查核點定義表
12. 查核點簽核表
13. CEO 待提供資源
14. 風險與待確認事項

Metadata 表至少包含欄位：`Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename`。

`角色指派表` 固定欄位為：`Planner | Executor | Validator`。

### `執行策略與內容規劃` 固定內容

每份分項規劃檔都必須有一段可交接的施工藍圖，至少包含以下欄位：`Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號`。

此段的目的是讓 RD / QE 在 SOP2 開工時，不需再從對話或零散訊息回推「到底要做什麼、改哪裡、交什麼」；它定義的是可施工的方法包，不是最終程式碼細節。

`查核點定義表` 固定欄位為：`Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置`。

`查核點簽核表` 固定欄位為：`Checkpoint ID | Planner | Executor | Validator | Notes`。

其中 `執行策略與內容規劃` 與 `查核點定義表` 都屬於 SOP1 凍結欄位，供 PM 協調 RD / QE 在規劃完成前寫定；`查核點簽核表` 屬於 SOP2 / SOP3 回填欄位，只允許對應角色依執行與驗收進度更新。

`Planner`、`Executor`、`Validator` 三欄直接表示各角色的簽核狀態；允許值固定為：`pending`、`confirmed`、`blocked`、`rejected`、`n/a`。

## 完成判定

1. `00-manifest.md` 已存在，且可索引所有分項規劃檔。
2. 每個分項都已建立對應的 `yyyy-mm-dd-<subitem-english-name>.md`。
3. 每個查核點都能由 `查核點定義表` 追到完成條件、預期效益、執行方法與驗證方式，並由 `查核點簽核表` 追到各角色簽核狀態。
4. 每個分項都已有 `執行策略與內容規劃`，可讓 RD / QE 直接接手開工，而不需再從對話回推施工方法。
5. 規劃內容已可被 RD / QE 逐項接手，不再是口語摘要。
6. CEO 輸入已被 PM 收斂成可驗證條件，而不是停留在願景口號。
7. 若缺計畫架構圖、manifest、分項規劃檔或施工藍圖，視為 SOP1 尚未完成，不得進入 SOP2。
8. 若 initiative 目標包含使用者文件重寫，且缺少逐頁 `Page Inventory 與寫作契約`，視為 SOP1 尚未完成；不得進入全量撰寫或定稿。
9. 若 CEO 明確輸入未被寫入 manifest，或 Page Inventory / 施工藍圖與 CEO 明確輸入不一致且未取得 CEO 同意，視為 SOP1 尚未完成；不得進入 SOP2。