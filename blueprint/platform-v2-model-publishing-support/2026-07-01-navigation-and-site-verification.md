# 導覽調整、相鄰頁對齊與最終驗證

## 1. 標題

Platform V2 模型上架支援：導覽調整、相鄰頁對齊與最終驗證

## 2. Metadata 表

| 欄位 | 值 |
| --- | --- |
| Subitem ID | SUB-05 |
| Parent Initiative | `platform-v2-model-publishing-support` |
| Depends On | SUB-02, SUB-03, SUB-04 |
| Planned Workorder Filename | `.github/issues/2026-07-platform-v2-model-publishing-support-nav-verification-workorder.md` |

## 3. 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| Product Strategy Manager | Senior Software Engineer | Testing Quality Engineer |

## 4. 問題陳述與分項目標

即使各頁都改寫完成，若 mkdocs 導覽、相鄰 model-provider / reference 頁與最終驗證沒有同步完成，網站實際體驗仍可能和 blueprint 不一致：頁面可能找不到、連結斷掉、讀者路徑亂掉，或新頁面雖存在但沒有實際被導入文件站。

本分項目標是把本輪頁面真正接進網站導覽、把相鄰頁分工對齊，並用可執行驗證證明「有做、做完、可讀」。

## 5. 預期效益

- 網站導覽會反映新的七頁架構，而不是停留在舊頁名。
- model-provider / reference 頁會與 Platform V2 新分工一致。
- 最終驗證可直接回答：哪些頁已施工、哪些連結已修正、哪些頁仍屬待確認。

## 6. In Scope

- 更新 `mkdocs.yml` 導覽標題與路徑。
- 調整必要的 model-provider / reference 相鄰頁連結與敘事分工。
- 把舊 `platform-v2/model-publishing/` live 頁從主流程導航移出，並依 manifest 凍結處置改成 redirect 或相鄰 reference / task page 入口。
- 進行 docs build / link / cold-read 類型驗證。
- 回寫最終施工證據位置。

## 7. Out of Scope

- 新增與本 initiative 無關的導覽節點。
- 重構整個 docs 資訊架構。
- 變更不在 Page Inventory 內的頁面內容。

## 8. 前置依賴與輸入契約

| 輸入 | 來源 | 說明 |
| --- | --- | --- |
| SUB-02~04 交付物 | 前置分項 | 七頁核心內容已落檔 |
| `mkdocs.yml` | repo | 網站導覽真相源 |
| 相鄰頁現況 | `docs/model-provider/**`、reference 頁 | 對齊連結與讀者路徑 |
| 驗證規則 | manifest、SUB-01 | 逐頁驗證方式與完成條件 |

## 9. 執行策略與內容規劃

### 9.1 方法目標與成功定義

本分項的目標不是抽象地說「把導覽處理一下」，而是把前四個分項做出的內容真正接進站點。成功的定義是：

1. `mkdocs.yml` 中存在一條能從 Platform V2 導到七頁新架構的明確導覽鏈。
2. 需要保留的相鄰頁仍存在於原主要讀者路徑，但其連結與敘事已對齊新的平台支援分工。
3. docs build 與冷讀檢查能證明這不是 blueprint 裡的理想圖，而是網站實際可到達、可理解的結果。

若最後仍出現「頁面檔案已存在，但導航找不到」「導覽存在，但連到舊頁或不存在路徑」「相鄰頁仍把平台頁當供應商操作步驟頁」，則本分項失敗。

### 9.2 施工對象與現況判定

本分項處理四類對象，且每一類的操作語意不同：

1. `mkdocs.yml` 已存在，操作語意是 `update-navigation`。這代表更新既有導覽節點，而不是重建整份導覽檔。
2. `docs/platform-v2/model-publishing/index.md`、`preparation.md`、`release-intake.md`、`content-validation.md`、`data-and-state.md`、`issue-handling.md`、`release-decision.md` 在本分項開始時應已存在或至少已被前序分項建立；若其中任一頁不存在，本分項不是默默跳過，而是視為 blocker。
3. `docs/model-provider/index.md`、`publish-readiness.md`、`packaging-quickstart.md`、`first-publish-checklist.md` 已存在，操作語意是 `revise-adjacent-links-and-scope`。這表示更新交叉導覽與分工描述，但不重寫供應商主體內容。
4. `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` 已存在，操作語意是 `use-fixed-reference-anchor`。這表示本分項必須讓平台頁與供應商頁都指向這條已凍結的真相源路徑，而不是再確認它在哪裡。

在本分項中，「存在」有明確標準：不只檔案路徑存在，還包括它已具有 blueprint 要求的主題與路徑角色；若只存在空殼檔案或舊頁內容，仍視為尚未完成前置分項。

### 9.3 步驟順序與依賴關係

1. 先檢查 SUB-02 到 SUB-04 預定產出的七頁是否已存在於指定路徑，且其 H1 與頁面主題不明顯偏離 blueprint。這是導覽更新的前置條件。
2. 只有在七頁存在時，才更新 `mkdocs.yml` 的 Platform V2 導覽節點，把舊節點標題與路徑替換成新架構。
3. 導覽更新完成後，才修改相鄰 model-provider / reference 頁，因為這些頁的交叉導覽必須指向已凍結的路徑，而不是暫時名稱。
4. 所有路徑與連結穩定後，最後才執行 docs build、導覽冷讀與章節檢查，收斂最終驗證結果與殘餘風險。

這個順序不可顛倒。若先改相鄰頁再改導覽，會造成供應商頁短暫指向不存在或未定稿的路徑；若未先確認七頁存在就更新 `mkdocs.yml`，導覽會生成死路徑。

### 9.4 變更面與內容語意

對 `mkdocs.yml` 的更新必須具體包含：

1. 把 Platform V2 模型上架區的節點標題改成七頁新架構所對應的對外標題。
2. 若現有節點仍指向舊頁名或舊路徑，要明確替換為新路徑，而不是只改顯示文字。
3. 若 blueprint 指定的新頁是 `new` 路徑，`mkdocs.yml` 必須把它納入導覽；若頁面仍不存在，則不能假裝更新完成。
4. 保持相鄰區入口順序可理解，不因本輪調整把其他讀者路徑打散。

對相鄰頁的更新必須具體包含：

1. `docs/model-provider/index.md` 要把平台支援頁當作相鄰支援入口，而不是供應商主流程本體。
2. `publish-readiness.md` 要把供應商提交結果與平台收件頁的對應關係說清楚，並修正連到舊 callback 或舊發布頁的連結。
3. `packaging-quickstart.md` 要連回共享規格真相源，而不是把平台查驗方法抄進供應商頁。
4. `first-publish-checklist.md` 要保持供應商 checklist 任務，但其平台側輸入與證據欄位需對齊新的平台接收與判定頁。

對舊 Platform V2 上架頁的處置必須具體包含：

1. `containerization-standard.md` 從主流程導航退出，改導向 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`。
2. `callback-api.md` 從主流程導航退出，改導向 `docs/platform-v2/reference-contracts/model-card-publish-callback-api.md`。
3. `implementation-spec.md` 從主流程導航退出，改導向 `docs/platform-v2/reference-contracts/model-card-publishing-implementation.md`。
4. `troubleshooting.md` 從主流程導航退出，改導向 `docs/platform-v2/model-publishing/issue-handling.md`。
5. `verification-evidence.md` 從主流程導航退出，改導向 `docs/platform-v2/model-publishing/release-decision.md`。

對最終驗證的更新必須具體包含：

1. 驗證七頁在導覽中是否都可到達。
2. 驗證頁面標題與 blueprint 是否一致。
3. 驗證相鄰頁連結是否指向正確新路徑。
4. 記錄哪些風險仍待後續處理，而不是把所有未竟事項模糊寫成「待補」。

### 9.5 決策點、分支與阻擋條件

1. 若任一七頁核心頁不存在、內容明顯還是舊主題，或 H1 與 blueprint 不一致，`mkdocs.yml` 更新必須停止，並把缺失回指對應前序分項。
2. 若相鄰頁沒有指向 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`，或仍保留其他未凍結替代路徑，SUB-05 不得關單，必須修正連結後才能完成。
3. 若 docs build 失敗是因為本輪新增或替換的路徑錯誤，必須在本分項修正；若失敗是站上既有無關問題，需明確揭露但不得無限擴張範圍。
4. 若冷讀測試顯示讀者仍會把平台支援頁當供應商操作頁，必須回到相鄰頁連結與導覽文字重寫，而不是只說「之後再補」。

### 9.6 證據、完成訊號與回寫位置

本分項的完成證據必須至少包括：

1. 更新後的 `mkdocs.yml`，可證明七頁新架構已接進導航。
2. 相鄰 model-provider / reference 頁的更新內容，可證明交叉導覽與分工已對齊。
3. docs build、導覽檢查、章節檢查與殘餘風險紀錄，可證明網站實際可到達、可讀、可查。

完成訊號是：從站點入口進入 Platform V2 後，能沿導航抵達七頁新架構，且從相鄰供應商頁也能正確回指需要的共享規格或平台支援頁；證據回寫位置是 `mkdocs.yml`、相鄰頁本身，以及本分項驗證證據紀錄。

## 10. 交付物清單

- 更新後的 `mkdocs.yml`
- 對齊後的 model-provider / reference 相鄰頁
- docs build 與導覽驗證證據
- 最終殘餘風險清單

## 11. 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| CP-01 | 導覽更新完成 | `mkdocs.yml` 可導到七頁新架構 | 使用者能從網站找到新頁 | 依 Workstream「導覽更新」施工 | 導覽節點檢查 | `mkdocs.yml` diff |
| CP-02 | 相鄰頁對齊完成 | model-provider / reference 頁連結與分工對齊新架構 | 減少 audience 混線與 broken links | 依 Workstream「相鄰頁對齊」施工 | 冷讀導覽測試 | 相關頁面 diff |
| CP-03 | 最終驗證完成 | 有 docs build、逐頁結構檢查與殘餘風險紀錄 | 可回答是否真的做完 | 依 Workstream「最終驗證」執行 | build 結果與檢查清單 | 驗證紀錄 |

## 12. 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| CP-01 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已更新 `mkdocs.yml`，Platform V2 導覽改為七頁新架構 |
| CP-02 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已更新 `docs/model-provider/index.md`、`publish-readiness.md`、`packaging-quickstart.md`、`first-publish-checklist.md` 與共享規格頁回鏈 |
| CP-03 | signed 2026-07-01 | signed 2026-07-01 | verified 2026-07-01 | 已執行 `python -m mkdocs build --strict`；build 通過，舊頁未列入 nav 為 blueprint 凍結處置 |

## 13. CEO 待提供資源

無。

## 14. 風險與待確認事項

- 若 docs build 暴露舊有 broken links 或相鄰頁結構問題，需在本分項中一併揭露，但不自動擴張到與本 initiative 無關的整站重構。
- 2026-07-01 build 結果：站點建置成功；訊息僅指出五個舊 `platform-v2/model-publishing/` 頁仍存在於 docs 目錄但未列入 nav。這是本 initiative 凍結的 `retire-or-redirect` 結果，不視為 blocker。
