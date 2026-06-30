---
description: "Use when a blueprint task is in the 開始 → 規劃 stage. Define the input contract, standard output package, and freeze criteria for turning a vague request into a reviewable blueprint."
applyTo: ".github/blueprint/README.md,.github/blueprint/01-*.md,blueprint/**/00-manifest.md,blueprint/**/*.md"
---

# Blueprint SOP1：開始到規劃

SOP1 只處理把需求變成可施工 blueprint 的前半段，不承接施工細節，也不承接驗收細節。CEO 在這一段必須先提供商務真相與計畫架構圖；`product-strategy-manager` 再把它 formalize 成可交接的 manifest 與分項規劃檔，不直接下到 RD 的技術 How。

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
| 角色 Handoff Package | PM / RD / QE / FAE / HR 對應輸出 |
| 查核點定義 | owner、完成條件、驗證方式、簽署欄位 |
| 規劃凍結線 | 進入 SOP2 後不得任意漂移的內容 |

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
3. 計畫架構圖
4. 分項索引表
5. 規劃凍結線
6. CEO 待提供資源

分項索引表至少包含欄位：`Subitem ID | 分項名稱 | Owner | Depends On | Resource Level | Blueprint File | Planned Workorder File | Status`。

### 分項規劃檔固定內容

每份 `yyyy-mm-dd-<subitem-english-name>.md` 至少包含以下段落，順序不可顛倒：

1. 標題
2. Metadata 表
3. 角色指派表
4. 問題陳述與分項目標
5. In Scope
6. Out of Scope
7. 前置依賴與輸入契約
8. 交付物清單
9. 查核點定義表
10. 查核點簽核表
11. CEO 待提供資源
12. 風險與待確認事項

Metadata 表至少包含欄位：`Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename`。

`角色指派表` 固定欄位為：`Planner | Executor | Validator`。

`查核點定義表` 固定欄位為：`Checkpoint ID | Item | 完成條件 | 驗證方式 | 證據位置`。

`查核點簽核表` 固定欄位為：`Checkpoint ID | Planner | Executor | Validator | Notes`。

其中 `查核點定義表` 屬於 SOP1 凍結欄位，供 PM 在規劃完成前寫定；`查核點簽核表` 屬於 SOP2 / SOP3 回填欄位，只允許對應角色依執行與驗收進度更新。

`Planner`、`Executor`、`Validator` 三欄直接表示各角色的簽核狀態；允許值固定為：`pending`、`confirmed`、`blocked`、`rejected`、`n/a`。

## 完成判定

1. `00-manifest.md` 已存在，且可索引所有分項規劃檔。
2. 每個分項都已建立對應的 `yyyy-mm-dd-<subitem-english-name>.md`。
3. 每個查核點都能由 `查核點定義表` 追到完成條件與驗證方式，並由 `查核點簽核表` 追到各角色簽核狀態。
4. 規劃內容已可被 RD / QE 逐項接手，不再是口語摘要。
5. CEO 輸入已被 PM 收斂成可驗證條件，而不是停留在願景口號。
6. 若缺計畫架構圖、manifest 或分項規劃檔，視為 SOP1 尚未完成，不得進入 SOP2。