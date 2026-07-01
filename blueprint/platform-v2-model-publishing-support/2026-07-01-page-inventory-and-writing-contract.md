# 架構凍結與寫作契約

## 1. 標題

Platform V2 模型上架支援：架構凍結與寫作契約

## 2. Metadata 表

| 欄位 | 值 |
| --- | --- |
| Subitem ID | SUB-01 |
| Parent Initiative | `platform-v2-model-publishing-support` |
| Depends On | none |
| Planned Workorder Filename | `.github/issues/2026-07-platform-v2-model-publishing-support-page-inventory-workorder.md` |

## 3. 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| Product Strategy Manager | Senior Software Engineer | Testing Quality Engineer |

## 4. 問題陳述與分項目標

目前 Platform V2 的模型上架文件區既有頁名、頁序與頁面分工不足以支撐本輪重寫：

- 主標題與分頁標題仍帶有偏舊、偏內部或偏單點術語的問題。
- 頁面順序沒有完整覆蓋供應商送件前的平台準備支援。
- 頁面多數只有 What，缺少平台維護者在實務上要怎麼做的 How。
- 若沒有先凍結 Page Inventory、文件類型、對外標題、主來源與驗證方式，後續施工容易再度漂移。

本分項目標是把本輪要動的頁面、每頁對外任務、頁面類型、來源、可宣稱內容、待確認內容與驗證方法凍結成單一契約，作為 SOP2 實際動工的真相源。

## 5. 預期效益

- 後續施工不需要再從對話回推「到底哪一頁要保留、哪一頁要新增、哪一頁要退休」。
- 每頁的寫作模式與讀者任務被凍結，降低後續頁面語氣與結構再度失衡的風險。
- QE 能依 Page Inventory 逐頁檢查施工是否完成，而不是事後主觀判斷。

## 6. In Scope

- 凍結 Platform V2 模型上架支援區的七頁核心頁面架構。
- 凍結相鄰 model-provider / reference 頁面的必要調整範圍。
- 凍結每頁的文件類型、讀者任務、主來源、輔助來源、可宣稱內容與驗證方式。
- 凍結本輪沿用既有 `docs/platform-v2/model-publishing/` 路徑族的決策。

## 7. Out of Scope

- 實際撰寫最終頁面全文。
- 變更 route、資料表、workflow 或 schema 本體。
- 對外宣稱 production 已完成新的正式發布能力。

## 8. 前置依賴與輸入契約

| 輸入 | 來源 | 說明 |
| --- | --- | --- |
| CEO Immutable Acceptance Source | manifest | 本輪不可變更邊界與標題要求 |
| 現有 Platform V2 模型上架頁 | repo 現況 | 提供現行頁面路徑與可沿用內容 |
| 現有 model-provider 頁 | repo 現況 | 提供供應商側相鄰頁與前置準備內容 |
| 現有 reference / contract 頁 | repo 現況 | 提供共享規格與契約來源 |

## 9. 執行策略與內容規劃

### 9.1 方法目標與成功定義

本分項不是在寫最終頁面內容，而是在建立整個 initiative 的施工契約。成功的定義不是「有一份表」而已，而是後續任何分項 owner 打開 manifest 後，都能精確知道：

1. 哪些頁面是沿用既有檔案但整頁改寫。
2. 哪些頁面目前不存在，必須在 SOP2 新增到哪個精確路徑。
3. 哪些相鄰頁只做分工與連結調整，不負責承接平台維護者主流程。
4. 哪些內容目前只能作為待確認或待驗證，不可被寫成既成事實。

若下游仍需回頭問「這個頁面到底要不要新建」「更新是改標題還是整頁換骨架」「相鄰頁是保留還是退休」，代表本分項未完成。

### 9.2 施工對象與現況判定語意

本分項先凍結本 initiative 中幾種狀態字的精確意義，避免後續分項各自解讀：

1. `rewrite`：該檔案今天已存在，SOP2 會保留原路徑，但重寫 H1、章節骨架、讀者任務與頁面作用，不視為小修。
2. `new`：該檔案今天不存在，SOP2 必須在 Page Inventory 指定的精確路徑建立新檔，並讓導覽能到達。
3. `revise-adjacent`：該檔案已存在且保留原主要任務，但需更新交叉導覽、連結或少量分工敘事。
4. `rewrite-existing-reference`：該共享規格頁已存在於固定 canonical path，SOP2 可重寫內容、補連結、修正文案，但不得改動路徑或把它換成其他 reference anchor。
5. `exists`：不只代表檔案路徑存在，也代表它是本輪承認的真相源之一，可被其他頁引用。
6. `does-not-exist`：不只代表目前看不到檔案，還代表下游不得假設已有對應內容，必須顯式建立或阻擋。

在這個 initiative 中，`docs/platform-v2/model-publishing/index.md` 屬於 `rewrite`；`preparation.md`、`release-intake.md`、`content-validation.md`、`data-and-state.md`、`issue-handling.md`、`release-decision.md` 預設屬於 `new`；`docs/model-provider/*.md` 相關頁屬於 `revise-adjacent`；共享容器規格頁屬於 `rewrite-existing-reference`。

### 9.3 步驟順序與依賴關係

本分項的施工順序如下：

1. 先從 CEO Immutable Acceptance Source 取回不可變更條件，凍結七頁主流程順序，避免下游在寫頁時自行增刪階段。
2. 逐頁標記現況狀態，也就是它是 `rewrite`、`new`、`revise-adjacent` 還是 `rewrite-existing-reference`。這一步要先做，否則後續所有「更新」「新增」都沒有操作語意。
3. 逐頁補完 Page Inventory 的對外標題、文件類型、讀者任務、主來源、輔助來源、可宣稱內容、待確認內容與驗證方式，讓下游知道每一頁能說什麼、不能說什麼。
4. 把相鄰頁納入同一份契約，明確寫出它們不承接 Platform V2 主流程，只負責供應商操作或共享規格真相源，避免 SOP2 才臨時發現 audience 混線。
5. 最後把上述狀態與頁面契約回寫到 manifest，讓 SUB-02 到 SUB-05 都引用同一套定義。

若第 2 步沒有完成，後續任何分項都不得宣稱可直接動工，因為還沒有凍結「改寫」與「新建」的差異。

### 9.4 變更面與內容語意

本分項本身主要更新的是 manifest，而不是 docs 頁面本體；但它必須為後續 docs 變更建立精確語意：

1. 對 `docs/platform-v2/model-publishing/index.md`，本分項凍結的是「保留原路徑、整頁重寫」這個決策，而不是只改標題。
2. 對 `docs/platform-v2/model-publishing/preparation.md`、`release-intake.md`、`content-validation.md`、`data-and-state.md`、`issue-handling.md`、`release-decision.md`，本分項凍結的是「SOP2 必須建立這些新檔到指定路徑」。
3. 對 `docs/model-provider/index.md`、`publish-readiness.md`、`packaging-quickstart.md`、`first-publish-checklist.md`，本分項凍結的是「保留原主要讀者任務，只更新連結與相鄰分工敘事」。
4. 對共享容器規格頁，本分項凍結的是「單一真相源固定為 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`，本輪只允許重寫內容與修正連結，不允許再改 canonical path」。

### 9.5 決策點、分支與阻擋條件

本分項的主要決策點如下：

1. 若某個預定 `new` 路徑其實已經存在同名舊檔，SOP2 不得自行決定沿用、退休或搬移；必須先標記為 `blocked` 並回到 SOP1 更新 manifest 後，才可繼續施工。
2. 若某個相鄰頁同時承接供應商流程與平台查驗語意，必須標示為 audience 混線，並在後續分項拆開其角色；在拆開前不得宣稱分工已凍結。
3. 若某頁缺少可宣稱來源，只能在 Page Inventory 標成待確認或待驗證，不可為了讓 blueprint 看起來完整而虛構內容。
4. 若後續分項出現任何與 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` 不一致的替代路徑提案，必須先回到 manifest 更新 CEO 核准路徑映射，否則視為 SOP2 偏差。

### 9.6 證據、完成訊號與回寫位置

本分項完成時，證據不是 docs build，而是 manifest 內已可回查的契約：

1. Page Inventory 的每一列都有明確狀態語意、讀者任務與驗證方式。
2. 後續每個分項都能引用這份契約，而不需要各自重新定義頁序或路徑狀態。
3. manifest 與後續分項檔不會對同一頁給出互相衝突的路徑或任務定義。

完成訊號是：任一讀者只看 manifest 與本分項，就能回答每個頁面是存在、待建立、待改寫、待搬移，還是只做相鄰更新；證據回寫位置固定在 `00-manifest.md` 與本分項的第 9 節。

## 10. 交付物清單

- 更新後的 manifest `Page Inventory 與寫作契約`。
- 凍結的七頁 Platform V2 頁序與標題。
- 相鄰 model-provider / reference 頁面調整名單。
- 逐頁來源、宣稱邊界與驗證方式。

## 11. 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| CP-01 | 七頁頁序凍結 | manifest 與所有分項引用的頁序一致 | 後續施工不再漂移閱讀順序 | 在 manifest 與分項施工藍圖中統一七頁順序 | 交叉檢查所有 blueprint 檔案是否一致 | `00-manifest.md`、各分項檔 |
| CP-02 | Page Inventory 完整 | 所有本輪要動的頁面都有路徑、標題、類型、來源與驗證方式 | 施工與驗證可追溯 | 逐頁填寫 Page Inventory 欄位 | 檢查無空白欄位且對應現有或預定頁面 | `00-manifest.md` |
| CP-03 | 寫作契約凍結 | 每頁都能對應 What / How / 完成條件的寫法要求 | 避免後續只寫抽象描述 | 在分項施工藍圖中把章節與施工 How 寫定 | 抽查分項藍圖與 manifest 一致 | 本分項檔、後續分項檔 |

## 12. 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| CP-01 | pending | pending | pending | 頁序以本分項為唯一凍結來源 |
| CP-02 | pending | pending | pending | Page Inventory 必須覆蓋相鄰支援頁 |
| CP-03 | pending | pending | pending | 後續分項需直接引用本契約 |

## 13. CEO 待提供資源

無。

## 14. 風險與待確認事項

- 若施工中發現既有 `docs/platform-v2/model-publishing/` 路徑已造成嚴重語意誤導，可能需要回 CEO 確認是否連資料夾 slug 一併調整。
- 若相鄰 model-provider / reference 頁與本輪新頁分工無法以小幅調整解決，SUB-05 需補回 manifest 再凍結。
