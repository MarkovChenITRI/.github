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

若 initiative 目標是重寫 README、docs、Pages 文件、維運手冊、developer site 或任何使用者可見文件，SOP1 除一般 blueprint 產出外，還必須在 manifest 或導覽治理分項中凍結一份 `Page Inventory 與寫作契約`，至少包含欄位：`Page ID | 預定路徑 | 對外標題 | 文件類型 | Primary Reader | Handled Object | 讀者任務 | Upstream Input Signal | Downstream Handoff | 主來源 | 輔助來源 | Source Completeness | Rewrite Permission State | 可宣稱內容 | 必須待確認內容 | 本輪產出狀態 | 驗證方式`。

其中 `文件類型` 必須對應 `.github/instructions/user-facing-docs.instructions.md` 的任務型、概念型或參考型；若某頁來源不足，`本輪產出狀態` 必須明示為 `draft-placeholder`、`deferred` 或其他 PM 凍結狀態，不得讓 SOP2 owner 自行判斷是否定稿。

`Rewrite Permission State` 固定只允許 `open-for-rewrite` 或 `frozen`。若 CEO / 使用者已明示某頁、某段、某組頁面骨架、固定用語或逐頁內容為定稿，必須標成 `frozen`，並在 manifest 保留可追溯原文來源；SOP2 / SOP3 未取得重新授權前，不得改寫 `frozen` 內容。

凡是跨頁文件重寫，除 `Page Inventory 與寫作契約` 外，還必須同步凍結五份 section-level 工件：`Reader Matrix`、`Actor / Responsibility Matrix`、`Canonical Terminology Table`、`Source-of-Truth Map`、`Deferred Claims List`。若缺其中任一工件，SOP1 不得宣稱完成，也不得讓文件任務進入 SOP2。

若 CEO / 使用者在 SOP1 過程中，已明確同意逐頁頁面內容、H1 / H2 骨架、必備段落、固定用語、完成條件或頁內 `How`，則 manifest 還必須額外凍結一份 `已同意逐頁內容原文` 或等價段落，作為可查核的原文驗收來源。這份原文不得只保留 PM 壓縮後的摘要版，也不得只剩 Page Inventory 或 derived page freeze。

`product-strategy-manager` 可以在原文之後再整理出 `逐頁內容凍結`、`derived page freeze` 或其他便於施工的結構化版本，但**原文來源必須與整理版並存**，且整理版不得取代原文。若整理版與已同意原文不一致，視為 SOP1 尚未完成。

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

若 initiative 是使用者文件 / Pages / README / 導覽重寫，且 CEO / 使用者已同意逐頁頁面內容，`00-manifest.md` 在固定八段之後，還必須新增一段 `已同意逐頁內容原文` 或等價段落，逐頁保存已同意內容，供後續 SOP2 / SOP3 逐項查核。

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

每份分項規劃檔都必須有一段可交接的施工藍圖，但**主要表達形式不得只是一張摘要表**。這一段的寫法要接近論文中的 methodology 章節：要讓下游看完後，不需再從對話或零散訊息回推「到底要做什麼、改哪裡、哪些東西已存在、哪些不存在、哪些要新增、哪些要更新、更新的具體內容是什麼、若條件不成立要停在哪裡」。

可使用表格作為索引或附錄，但表格只能輔助，不可取代主體敘述。

`執行策略與內容規劃` 至少要包含下列六類資訊，且必須用可交接的完整文字寫清楚：

1. **方法目標與成功定義**：這個分項在 SOP2 真正要做出的成果是什麼，完成後哪個對象會變成什麼狀態。
2. **施工對象與現況判定**：逐一說明會動到的檔案、頁面、設定或流程目前是已存在、不存在、暫存、待退休、需保留；若寫「更新」必須說明更新哪個既有對象、保留什麼、替換什麼；若寫「新增」必須說明新增到哪個精確路徑或位置。
3. **步驟順序與依賴關係**：按實際施工順序寫出先做什麼、後做什麼、每一步使用哪些輸入、產生哪些中間成果、下一步憑什麼才可開始。
4. **決策點、分支與阻擋條件**：明確寫出什麼情況代表可以繼續、什麼情況必須停止、退回、改寫 blueprint 或要求 CEO / 上游補資源。不得只寫抽象的 blocking gate 名稱。
5. **變更面與內容語意**：對每個觸碰面說明是建立、改寫、搬移、刪除、保留、重導向、補連結、重組章節，並說明具體變更內容，不可只列檔名。
6. **證據、完成訊號與回寫位置**：說明做完後應留下哪些證據、由誰看什麼結果判定完成、結果回寫到哪裡。

若 initiative 是文件、Pages、README、導覽或其他使用者文件重寫，這一段還必須額外寫清楚：

1. 每個頁面路徑是沿用既有檔案、建立新檔、搬移既有檔案、退休舊檔，還是只更新相鄰連結。
2. 每個頁面的 H1、章節骨架、主要讀者任務與相鄰頁連接方式。
3. 何者可直接宣稱為既成事實，何者只能寫成待確認或待驗證狀態。

若作者希望附上 `Workstream | Owner | 觸碰面 | 交付物` 之類的摘要表，可放在 methodology 敘述之後作為索引，但不得讓摘要表成為 `執行策略與內容規劃` 的主要內容。

`查核點定義表` 固定欄位為：`Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置`。

`查核點簽核表` 固定欄位為：`Checkpoint ID | Planner | Executor | Validator | Notes`。

其中 `執行策略與內容規劃` 與 `查核點定義表` 都屬於 SOP1 凍結欄位，供 PM 協調 RD / QE 在規劃完成前寫定；`查核點簽核表` 屬於 SOP2 / SOP3 回填欄位，只允許對應角色依執行與驗收進度更新。

`Planner`、`Executor`、`Validator` 三欄直接表示各角色的簽核狀態；允許值固定為：`pending`、`confirmed`、`blocked`、`rejected`、`n/a`。

## 完成判定

1. `00-manifest.md` 已存在，且可索引所有分項規劃檔。
2. 每個分項都已建立對應的 `yyyy-mm-dd-<subitem-english-name>.md`。
3. 每個查核點都能由 `查核點定義表` 追到完成條件、預期效益、執行方法與驗證方式，並由 `查核點簽核表` 追到各角色簽核狀態。
4. 每個分項都已有 methodology 等級的 `執行策略與內容規劃`，可讓 RD / QE 直接接手開工，而不需再從對話回推施工方法與變更語意。
5. 規劃內容已可被 RD / QE 逐項接手，不再是口語摘要。
6. CEO 輸入已被 PM 收斂成可驗證條件，而不是停留在願景口號。
7. 若缺計畫架構圖、manifest、分項規劃檔或施工藍圖，視為 SOP1 尚未完成，不得進入 SOP2。
8. 若 initiative 目標包含使用者文件重寫，且缺少逐頁 `Page Inventory 與寫作契約`，視為 SOP1 尚未完成；不得進入全量撰寫或定稿。
9. 若 CEO 明確輸入未被寫入 manifest，或 Page Inventory / 施工藍圖與 CEO 明確輸入不一致且未取得 CEO 同意，視為 SOP1 尚未完成；不得進入 SOP2。
10. 若 initiative 已有 CEO / 使用者同意的逐頁內容，但 manifest 未保留原文凍結來源，只剩摘要、表格或 PM 派生版本，視為 SOP1 尚未完成；不得進入 SOP2。
11. 若 initiative 目標包含跨頁文件重寫，且缺少 `Reader Matrix`、`Actor / Responsibility Matrix`、`Canonical Terminology Table`、`Source-of-Truth Map` 或 `Deferred Claims List` 任一項，視為 SOP1 尚未完成；不得進入 SOP2。
12. 若 `Source Completeness` 顯示 PM / RD / QE 任一來源未齊，卻仍把頁面標為可定稿狀態，視為 SOP1 尚未完成；不得進入 SOP2。