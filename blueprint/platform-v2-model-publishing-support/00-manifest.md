# Platform V2 模型上架支援 Blueprint Manifest

## 1. 本期目標

把 Platform V2 現有偏向「模型上架與發佈」的文件區，重構為一套真正可施工、可查核、可維護的「模型上架支援」文件體系，讓平台維護者能依固定順序處理：

1. 平台先準備供模型供應商使用的上架資料、工具與範本。
2. 平台接收模型供應商送出的發布結果。
3. 平台查驗容器內容與平台規格是否一致。
4. 平台用一致資料與狀態記錄整個上架流程。
5. 平台在失敗時依固定方法處理問題。
6. 平台在證據齊備時做出審核或正式發布判定。

本期不只做規劃，而是要把 Pages 文件實際改成上述形態，並在最後檢查是否真的完成施工與驗證。

## 2. CEO 商務真相摘要

- 讀者主體是第一次接手這個專案的平台維護者，不假設其已理解既有專有名詞或內部背景。
- 本區不只支援模型供應商把模型送進平台，也支援模型供應商在準備模型容器前所需要的平台資源，包括 `model_card.yaml` 的生成、Python 憑證解密庫、範例程式、以及自動上傳到 ACR 的 GitHub Actions / CI 範本庫。
- 文件要符合 Microsoft Learn 式語境：標題可掃描、先寫讀者要完成什麼，再寫背景；第一次出現專有名詞時要附白話說明。
- 文件不能只有 What，必須把平台維護者實際要怎麼做寫清楚，包括看哪些輸入、依什麼順序處理、用什麼條件前進或退回、失敗時回哪一步補齊。
- Platform V2 這一區要能支撐真實施工與後續維護，不是只做成規劃藍圖或純概念頁。

## 3. CEO Immutable Acceptance Source

下列要求為本 initiative 的最高驗收來源，後續 Page Inventory、分項規劃檔與施工藍圖不得自行壓縮、替換、改名或改變層級：

1. Platform V2 的主入口頁 H1 對外標題固定為「模型上架支援」。
2. 本區內容必須涵蓋模型供應商送件前的平台準備支援，不得只涵蓋送件後的接收、審核與發布。
3. 文件語氣需採 Microsoft Learn 式正向任務敘事，不使用「這是...不是...」之類對比式說明作為對外頁面主要文字。
4. 專有名詞第一次出現時必須附白話說明，預設 CEO / 平台維護者是第一次接觸此專案的人。
5. 第二頁之後的頁面標題要像正式文件標題，短、穩定、可掃描，不直接以純內部術語或過長口語句作為頁名。
6. 每一頁都必須交代 What 與 How：除了說明頁面處理什麼，還要說明平台維護者實際怎麼處理、依什麼順序處理、完成與失敗的判準是什麼。
7. 本期 blueprint 不只查驗規劃是否齊全，而是要凍結實際施工方法，讓後續 Pages 文件真的被改成現在規劃要求的樣子，並在最後查驗是否做了、是否做完。

## 4. 預期效益

- 平台維護者能從入口頁一路找到準備、接收、查驗、狀態、排障與發布判定的對應文件，不必從零拼湊流程。
- 模型供應商所需的前置資源來源、模板與設定命名會有清楚平台側說明，不會靠口耳相傳。
- Platform V2 與相鄰 model-provider / reference 文件之間的分工會被凍結，降低後續再度混線的風險。
- 文件頁面在施工後可用真實路徑、真實來源與真實驗證方式回查，不會停留在空泛規劃語。

## 5. 計畫架構圖

```text
Platform V2 模型上架支援
├── A. 架構凍結與寫作契約
│   ├── 凍結頁面順序、標題、文件類型
│   └── 凍結 Page Inventory 與來源對照
├── B. 準備支援施工
│   ├── 改寫入口頁
│   └── 建立「上架準備」頁與前置資源敘事
├── C. 接收與查驗施工
│   ├── 建立「發布接收」頁
│   ├── 建立「內容查驗」頁
│   └── 對齊共享容器規格與平台查驗方法
├── D. 狀態、排障、判定施工
│   ├── 建立「資料與狀態」頁
│   ├── 建立「問題處理」頁
│   └── 建立「發布判定」頁
└── E. 導覽、相鄰頁與驗證
    ├── 調整 mkdocs 導覽
    ├── 對齊 model-provider / reference 相鄰頁
    └── 建立最終施工與驗證證據
```

## 6. 分項索引表

| Subitem ID | 分項名稱 | Owner | Depends On | Resource Level | Blueprint File | Planned Workorder File | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| SUB-01 | 架構凍結與寫作契約 | Product Strategy Manager | none | M | [2026-07-01-page-inventory-and-writing-contract.md](2026-07-01-page-inventory-and-writing-contract.md) | `.github/issues/2026-07-platform-v2-model-publishing-support-page-inventory-workorder.md` | completed |
| SUB-02 | 準備支援頁施工 | Product Strategy Manager + Senior Software Engineer | SUB-01 | M | [2026-07-01-preparation-support-pages.md](2026-07-01-preparation-support-pages.md) | `.github/issues/2026-07-platform-v2-model-publishing-support-preparation-pages-workorder.md` | completed |
| SUB-03 | 發布接收與內容查驗頁施工 | Product Strategy Manager + Senior Software Engineer | SUB-01 | H | [2026-07-01-release-intake-and-content-validation-pages.md](2026-07-01-release-intake-and-content-validation-pages.md) | `.github/issues/2026-07-platform-v2-model-publishing-support-intake-validation-workorder.md` | completed |
| SUB-04 | 資料狀態、問題處理與發布判定頁施工 | Product Strategy Manager + Senior Software Engineer | SUB-01 | H | [2026-07-01-state-troubleshooting-and-release-decision-pages.md](2026-07-01-state-troubleshooting-and-release-decision-pages.md) | `.github/issues/2026-07-platform-v2-model-publishing-support-state-decision-workorder.md` | completed |
| SUB-05 | 導覽調整、相鄰頁對齊與最終驗證 | Product Strategy Manager + Testing Quality Engineer | SUB-02, SUB-03, SUB-04 | H | [2026-07-01-navigation-and-site-verification.md](2026-07-01-navigation-and-site-verification.md) | `.github/issues/2026-07-platform-v2-model-publishing-support-nav-verification-workorder.md` | completed |

## 7. 規劃凍結線

下列內容在進入 SOP2 前視為凍結，不得未經 CEO 同意任意漂移：

1. Platform V2 本區的對外標題與閱讀順序：模型上架支援 → 上架準備 → 發布接收 → 內容查驗 → 資料與狀態 → 問題處理 → 發布判定。
2. 本期必須補入供應商送件前的平台準備支援，而不只寫送件後的結果處理。
3. 每頁的寫法必須包含可執行的 How，不得只保留 What。
4. Page Inventory 中標記為 `rewrite`、`new`、`retire-or-redirect` 的頁面路徑與對外標題。
5. Platform V2 與 model-provider / reference 的分工：Platform V2 說平台如何支援與判定；相鄰頁負責供應商操作細節與共享規格真相源。
6. 共享容器規格的 canonical path 固定為 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`，本期不得改成其他 reference slug，也不得改成「之後再決定」。
7. 本期七頁主流程與相鄰頁調整預設沿用既有 `docs/platform-v2/model-publishing/` 路徑族；這不是暫定 mapping，而是本輪已核准施工路徑。若後續要改 slug，必須重新回到 SOP1 更新 manifest。

## 8. CEO 待提供資源

目前無額外 CEO 待提供資源；本輪以既有 repo 內容、既有文件、既有 route / schema / workflow 事實作為規劃來源。

## 9. Page Inventory 與寫作契約

| Page ID | 預定路徑 | 對外標題 | 文件類型 | 讀者任務 | 主來源 | 輔助來源 | 可宣稱內容 | 必須待確認內容 | 本輪產出狀態 | 驗證方式 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| P-01 | `docs/platform-v2/model-publishing/index.md` | 模型上架支援 | 任務型 | 判斷目前問題位於哪一段模型上架支援流程 | 既有 `platform-v2/index.md`、現有上架總覽頁、CEO 明確要求 | manifest、相鄰分頁規格 | 可宣稱平台支援鏈與閱讀順序 | 不宣稱送件後每段都已完成正式環境驗證 | rewrite | 對照本 blueprint 固定頁序與頁面章節 |
| P-02 | `docs/platform-v2/model-publishing/preparation.md` | 上架準備 | 任務型 | 確認平台是否已備妥供應商上架前需要的資料、工具與範本 | model-provider 現有前置頁、repo 樣板事實 | `docs/model-provider/*.md`、model-card-package-template | 可宣稱平台準備哪些材料與交付方式 | 需確認每一項下載入口或模板最終採用位置 | new | 對照模板、文件連結與下載路徑 |
| P-03 | `docs/platform-v2/model-publishing/release-intake.md` | 發布接收 | 任務型 | 確認平台是否已收到可信的發布結果 | 現有 callback / publishing docs、route 事實 | `utils/routes/model_card_publish_routes.py`、測試 | 可宣稱平台接收時要看哪些輸入與順序 | 不宣稱 production endpoint 行為超出 repo 現況 | new | 對照 route、既有 callback 契約與測試名稱 |
| P-04 | `docs/platform-v2/model-publishing/content-validation.md` | 內容查驗 | 任務型 | 確認容器內容與平台要求一致 | 現有 containerization standard、publishing docs | `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`、model-provider packaging docs | 可宣稱平台核對哪些內容與退回判準 | 欄位文案與例子需忠於現有共享規格內容，不可擴寫未驗證欄位 | new | 對照共享規格與 platform 查驗敘事 |
| P-05 | `docs/platform-v2/model-publishing/data-and-state.md` | 資料與狀態 | 概念型 | 看懂平台保存哪些資料與每個狀態的意義 | `utils/db.py`、現有 implementation spec | tests、route docs | 可宣稱資料物件與狀態責任 | 不宣稱未在 repo 落地的額外資料表與狀態 | new | 對照 `utils/db.py` 與 publishing 測試 |
| P-06 | `docs/platform-v2/model-publishing/issue-handling.md` | 問題處理 | 任務型 | 依固定順序收斂模型上架失敗問題 | 現有 troubleshooting、workflow / route / docs 事實 | SUB-02~04 輸出 | 可宣稱平台排查順序與補件切點 | 不宣稱已覆蓋正式環境所有 incident 類型 | new | 對照排查鏈是否能回指前置頁 |
| P-07 | `docs/platform-v2/model-publishing/release-decision.md` | 發布判定 | 任務型 | 依證據判斷是否可進待審核或正式發布 | 現有 verification-evidence、publishing 狀態語意 | QE 驗證規劃 | 可宣稱平台判定所需證據與 no-go 條件 | 不宣稱本輪已完成正式驗收證據本體 | new | 對照證據欄位與狀態定義 |
| S-01 | `docs/model-provider/index.md` | 模型上架入口 | 任務型 | 維持供應商自己的上架主入口，並指向平台支援相鄰頁 | 既有 model-provider index | SUB-02~03 產出 | 可宣稱供應商入口仍是主要操作路徑 | 需確認新增交叉連結後的導覽文字 | revise-adjacent | 冷讀導覽測試 |
| S-02 | `docs/model-provider/publish-readiness.md` | 提交上架流程 | 任務型 | 讓供應商端流程與平台側「發布接收」對齊 | 現有 publish-readiness | route / callback 契約 | 可宣稱供應商應交付哪些結果 | 不宣稱供應商可以直接完成平台審核或發布判定 | revise-adjacent | 對照供應商輸出與平台輸入 |
| S-03 | `docs/model-provider/packaging-quickstart.md` | 建置 Docker 映像檔 | 任務型 | 維持供應商容器建置路徑，並改連到共享規格 | 現有 packaging-quickstart | `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` | 可宣稱供應商如何生成與建置 | 不再把平台查驗方法寫在供應商頁 | revise-adjacent | 連結與角色分工檢查 |
| S-04 | `docs/model-provider/first-publish-checklist.md` | 第一次發布檢查表 | 任務型 | 保持供應商側 checklist，但對齊平台支援鏈輸入需求 | 現有 checklist | SUB-02、SUB-03 產出 | 可宣稱供應商需準備的證據與設定 | 不宣稱平台已完成後續查驗或審核 | revise-adjacent | 檢查 checklist 與平台接收欄位對齊 |
| R-01 | `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` | 共享容器規格 | 參考型 | 提供平台與供應商共同引用的欄位與約束真相源 | 既有 reference-contracts / containerization docs | packaging docs、platform validation docs | 可宣稱欄位定義、範例與限制 | 內容可更新，但 canonical path 本輪固定不變 | rewrite | 連結與欄位對照檢查 |
| O-01 | `docs/platform-v2/model-publishing/containerization-standard.md` | 舊容器化規範頁 | 參考型 | 退出主流程導航，並把舊連結導向共享容器規格真相源 | 現有舊頁 | `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` | 可宣稱此舊頁不再是主流程真相源 | 不再保留雙軌規格頁 | retire-or-redirect | 檢查舊導覽與舊連結是否導向 R-01 |
| O-02 | `docs/platform-v2/model-publishing/callback-api.md` | 舊 Callback API 頁 | 參考型 | 退出主流程導航，並把舊連結導向 callback reference 頁 | 現有舊頁 | `docs/platform-v2/reference-contracts/model-card-publish-callback-api.md` | 可宣稱此舊頁不再承接主流程解說 | 不保留與新收件頁重複的雙軌解釋 | retire-or-redirect | 檢查舊導覽與舊連結是否導向 callback reference |
| O-03 | `docs/platform-v2/model-publishing/implementation-spec.md` | 舊上架施工規格頁 | 參考型 | 退出主流程導航，並把舊連結導向 implementation reference 頁 | 現有舊頁 | `docs/platform-v2/reference-contracts/model-card-publishing-implementation.md` | 可宣稱工程契約仍存在但不再掛在主流程導航 | 不保留舊主流程位置 | retire-or-redirect | 檢查舊導覽與舊連結是否導向 implementation reference |
| O-04 | `docs/platform-v2/model-publishing/troubleshooting.md` | 舊上架故障排查頁 | 任務型 | 退出舊頁，改由新問題處理頁承接故障排查任務 | 現有舊頁 | `docs/platform-v2/model-publishing/issue-handling.md` | 可宣稱故障排查主入口已改由新頁承接 | 不保留舊頁與新頁雙軌排障入口 | retire-or-redirect | 檢查舊導覽與舊連結是否導向問題處理 |
| O-05 | `docs/platform-v2/model-publishing/verification-evidence.md` | 舊上架驗證證據頁 | 任務型 | 退出舊頁，改由新發布判定頁承接證據與完成條件敘事 | 現有舊頁 | `docs/platform-v2/model-publishing/release-decision.md` | 可宣稱發布判定頁是新證據判定入口 | 不保留舊頁與新頁雙軌完成判定入口 | retire-or-redirect | 檢查舊導覽與舊連結是否導向發布判定 |

## 10. 已同意逐頁內容原文

本節保留 CEO / 使用者已同意的逐頁內容原文，作為後續 SOP2 / SOP3 的直接查核來源。SUB-01 之後的任何 Page Inventory、逐頁內容凍結、施工藍圖或 docs 實作，都只能依此原文展開；不得以 PM 摘要版取代。

### 10.1 頁面一：模型上架支援

`H1 粗體`
`# 模型上架支援`

`H2 細體`
`## 這份文件會幫你完成什麼`
說明這一區是平台維護者接手模型上架流程的入口。讀者會先知道平台在這條流程中提供哪些支援、在哪些節點做確認，以及遇到不同問題時應往哪一頁看。

`H2 細體`
`## 流程概觀`
用白話描述整條路徑：平台先準備上架資料、程式庫與流程範本；模型供應商依這些資源準備模型容器與自動化流程；平台收到發布結果後，再依序完成查驗、審核與同步。

`H2 細體`
`## 平台在每一段要完成的工作`
列出整條平台責任鏈：

- 準備上架資料
- 提供程式與範本
- 建立發布授權
- 接收發布結果
- 查驗容器內容
- 記錄資料與狀態
- 處理異常情況
- 做出發布判定

`H2 細體`
`## 怎麼使用這組文件`
直接教讀者如何選頁：

- 要確認平台先準備了什麼，先看「上架準備」
- 要確認平台有沒有收到結果，先看「發布接收」
- 要確認內容正不正確，先看「內容查驗」
- 要處理卡住或失敗，先看「問題處理」
- 要決定能不能發布，先看「發布判定」

`H2 細體`
`## 完成條件`
讀者能把目前工作定位到正確階段，並知道下一步要查哪一頁。

### 10.2 頁面二：上架準備

`H1 粗體`
`# 上架準備`

`H2 細體`
`## 這份文件會幫你完成什麼`
說明平台在模型供應商正式準備模型容器前，需要先提供哪些資料、工具與範本，讓後續封裝與發布都沿用同一套基準。

`H2 細體`
`## 平台要準備哪些上架資料`
第一次出現專有名詞時補白話說明：

- `model_card.yaml`：描述模型基本資訊、執行條件與發布欄位的設定檔
- 模型草稿資料：模型供應商先在平台上建立的基本資料
- 欄位責任：哪些欄位由平台生成，哪些欄位由供應商填寫

`H2 細體`
`## 平台要提供哪些工具與範本`
這一節把你要求的範圍正式納入：

- Python 憑證解密庫
- 範例程式
- 容器封裝樣板
- 自動上傳到 ACR 的 GitHub Actions / CI 範本庫

第一次出現 ACR 時補白話說明：
ACR 是 Azure Container Registry，也就是用來存放容器映像的雲端倉庫。

`H2 細體`
`## 平台要如何交付這些資源`
這一節是本頁的 `How`，要具體寫：

- 從哪個平台頁面產生 `model_card.yaml`
- 從哪裡下載樣板或範例程式
- Variables 與 Secrets 的名稱從哪裡取得
- GitHub Actions / CI 範本從哪裡複製或引用
- 平台如何標示目前適用的範本版本

`H2 細體`
`## 平台要如何確認準備工作已完成`
這一節要寫維護者怎麼檢查，而不只是說要有什麼：

- `model_card.yaml` 能否正常生成
- 樣板與程式庫版本是否可追溯
- 下載入口是否有效
- Variables / Secrets 命名是否固定
- 範例程式是否與目前流程一致

`H2 細體`
`## 常見偏移與修正方式`
例如：

- 供應商拿到舊版樣板
- `model_card.yaml` 欄位與現在流程不一致
- 範例程式與授權流程不同步
- Secrets 命名與 CI 範本不一致

每項都要寫成「現象 / 原因 / 修正方式」。

`H2 細體`
`## 完成條件`
平台已備妥可直接交付供應商的上架資料、工具與模板，且版本與來源可追溯。

### 10.3 頁面三：發布接收

`H1 粗體`
`# 發布接收`

`H2 細體`
`## 這份文件會幫你完成什麼`
說明平台如何接收模型供應商送出的發布結果，並判斷這份結果是否可進入下一步內容查驗。

`H2 細體`
`## 開始之前`
第一次出現專有名詞時補白話說明：

- 發布結果回報：模型供應商的自動化流程在完成建置與上傳後，把結果送回平台
- 發布授權：平台核發的一次性發布資料，用來限制本次可發布的位置與識別
- 映像摘要：用來唯一識別容器映像內容的值

`H2 細體`
`## 平台要先收哪些資訊`
列出維護者在這一步需要的最少輸入：

- 發布授權編號
- workflow run
- repository
- tag
- digest
- 錯誤代碼
- 完成時間

`H2 細體`
`## 平台接收時的處理順序`
這一節要寫成明確步驟：

1. 先確認授權是否有效
2. 再確認回報目標位置是否正確
3. 再確認 workflow 是否完成必要步驟
4. 再確認回報內容是否完整
5. 最後確認是否為重複回報

`H2 細體`
`## 平台如何判定可往下走`
列出前進條件：

- 授權有效
- 回報位置正確
- 必要欄位齊全
- workflow 狀態合理
- 非重複事件

`H2 細體`
`## 常見失敗情況與處理方式`
要用「現象 / 代表原因 / 下一步」格式，而不是只列錯誤碼。
例如：

- 授權已過期：表示本次發布超出允許時限；下一步是重新取得有效授權
- 回報位置不符：表示 workflow 發布到錯的位置；下一步是回頭核對 repository/tag 規則
- 重複回報：表示平台已處理過同一事件；下一步是比對既有紀錄

`H2 細體`
`## 完成條件`
平台已收到可信且可查驗的發布結果，能進入內容查驗。

### 10.4 頁面四：內容查驗

`H1 粗體`
`# 內容查驗`

`H2 細體`
`## 這份文件會幫你完成什麼`
說明平台如何核對供應商送出的容器內容，確認它與平台要求一致。

`H2 細體`
`## 開始之前`
補白話說明：

- 容器映像：把模型與執行環境打包成可執行封裝
- 映像摘要：這份封裝的唯一識別
- 描述標記：附在映像上的欄位，用來說明模型是誰、版本是什麼、如何啟動、需要什麼授權
- 共享規格：平台與供應商共同依據的欄位與規則定義

`H2 細體`
`## 平台要檢查哪些內容`
從維護者能理解的角度列出：

- 模型識別與版本
- 啟動入口
- 授權欄位
- 硬體條件
- 保護機制標記

`H2 細體`
`## 平台要怎麼檢查`
這一節是核心 `How`，要具體寫：

1. 先從發布接收頁取得 digest 與 metadata
2. 再依共享規格逐項比對
3. 若欄位缺漏或與草稿不一致，標記為需修正
4. 若核心欄位齊全且一致，再標記為查驗通過

`H2 細體`
`## 退回修正的判準`
要寫清楚哪些錯誤可補件、哪些應中止本次流程重新準備。
例如：

- 欄位缺漏可補件
- 核心識別與草稿不一致需退回修正
- 平台查不到實際容器內容則不能往下走

`H2 細體`
`## 查驗通過後要留下哪些紀錄`
這一節補足後續維護需要的 `How`：

- 查驗結果
- 查驗時間
- 摘要資訊
- 對應授權或發布事件
- 判定人或自動檢查來源

`H2 細體`
`## 完成條件`
平台已確認容器內容與平台要求一致，且查驗紀錄可供後續審核使用。

### 10.5 頁面五：資料與狀態

`H1 粗體`
`# 資料與狀態`

`H2 細體`
`## 這份文件會幫你完成什麼`
說明平台如何保存上架資料，以及如何用處理狀態表示目前進度。

`H2 細體`
`## 平台會保存哪些資料`
用白話對照資料類型：

- 草稿資料
- 匯出設定
- 發布授權
- 機密參照
- 回報紀錄
- 查驗結果
- 容器紀錄
- 審核紀錄

`H2 細體`
`## 各狀態代表什麼`
用「狀態名稱 + 白話說明」方式寫：

- 已準備
- 等待回報
- 已收到
- 已確認
- 待審核
- 已發布
- 需修正

`H2 細體`
`## 平台要怎麼更新狀態`
這一節要明確說明 `How`：

- 收到有效結果後，狀態從等待回報進入已收到
- 完成內容查驗後，狀態進入已確認或待審核
- 發現內容不一致時，狀態改為需修正
- 完成審核與同步後，狀態才可進入已發布

`H2 細體`
`## 維護時應先查資料還是先看狀態`
這一節很重要，因為它會影響後續維護行為：

- 如果問題是資料缺漏，先看保存資料
- 如果問題是流程停住，先看狀態與最後一次事件
- 如果問題是畫面與實際不一致，再交叉看資料與狀態

`H2 細體`
`## 哪些資料可以進入平台目錄`
明確說明只有通過查驗並完成審核的資料，才可進正式目錄。

`H2 細體`
`## 完成條件`
讀者能從資料與狀態判斷目前進度與缺口，不靠人工猜測。

### 10.6 頁面六：問題處理

`H1 粗體`
`# 問題處理`

`H2 細體`
`## 這份文件會幫你完成什麼`
提供固定順序的維護方法，避免維護者在出錯時跳步處理。

`H2 細體`
`## 開始之前`
列出排查最少需要的資訊，並逐項說明用途：

- 發布授權編號
- workflow run
- digest
- 狀態
- 平台頁面觀察結果

`H2 細體`
`## 排查順序`
這一節要直接寫成操作順序：

1. 先看上架準備是否齊全
2. 再看發布授權
3. 再看發布接收
4. 再看內容查驗
5. 最後看審核與同步

`H2 細體`
`## 每一段要怎麼判斷有沒有問題`
每一段都要有四個欄位：

- 觀察點
- 成功訊號
- 失敗訊號
- 下一步

這樣後續維護才不會漂。

`H2 細體`
`## 常見問題情境`
例如：

- 平台未收到結果
- 收到結果但找不到容器內容
- 查驗完成但卡在待審核
- 已發布但頁面未更新

`H2 細體`
`## 何時需要請模型供應商補件`
要寫清楚平台與供應商的責任切點。
例如：

- 缺供應商輸入
- 容器內容與宣告不一致
- workflow 本身失敗
- 回報內容不完整

`H2 細體`
`## 完成條件`
平台維護者可指出問題落點、責任歸屬與後續動作。

### 10.7 頁面七：發布判定

`H1 粗體`
`# 發布判定`

`H2 細體`
`## 這份文件會幫你完成什麼`
說明平台在什麼條件下，可以把模型送進待審核或正式發布。

`H2 細體`
`## 開始之前`
第一次出現「證據」時要補白話說明：
證據是可追溯的結果紀錄，用來證明平台不是只看單一回報就宣布完成。

`H2 細體`
`## 模型供應商應提供哪些結果`
例如：

- 建置結果
- 測試結果
- 上傳結果
- 發布結果回報紀錄

`H2 細體`
`## 平台應補哪些確認結果`
例如：

- 內容查驗紀錄
- 發布授權與回報紀錄
- 審核決策
- 同步結果

`H2 細體`
`## 平台要怎麼做發布判定`
這一節是本頁最重要的 `How`：

1. 先核對供應商結果是否完整
2. 再核對平台查驗紀錄是否齊備
3. 再確認審核是否完成
4. 最後確認同步條件是否成立
5. 任一缺口都不能宣布完成

`H2 細體`
`## 哪些情況不能宣布完成`
用 no-go 條件明確寫出：

- 只有回報沒有查驗
- 只有查驗沒有審核
- 只有審核沒有同步
- 缺少 workflow 紀錄
- 缺少容器查驗結果

`H2 細體`
`## 完成條件`
讀者能清楚分辨：

- 已收到
- 已確認
- 已審核
- 已發布

### 10.8 這份原文的查核用途

這版相較前一版，最大的差異是把 `How` 明確補進每一頁：

- 平台要看哪些輸入
- 按什麼順序處理
- 用什麼條件前進
- 用什麼條件退回
- 哪些紀錄必須留下
- 出問題時回哪一步修正

### 10.9 相鄰頁調整內容凍結

本 initiative 不只重寫 Platform V2 七頁，也必須凍結相鄰頁的調整方向，避免 SOP2 動工時又回到「這頁到底要不要改」：

1. `docs/model-provider/index.md`
保留供應商入口定位，但要新增指向 Platform V2 模型上架支援的相鄰導覽，說明平台維護者可到該區確認支援鏈。
2. `docs/model-provider/publish-readiness.md`
保留供應商提交流程主體，但要把平台將接收哪些結果、哪些輸出會被當作平台收件輸入對齊到發布接收頁。
3. `docs/model-provider/packaging-quickstart.md`
保留供應商建置映像檔任務，但所有欄位與限制應導回共享規格真相源，不在此頁承接平台查驗方法。
4. `docs/model-provider/first-publish-checklist.md`
保留 checklist 任務，但要對齊平台接收與發布判定所需要的輸入與證據。
5. `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`
其任務固定為欄位定義、範例與限制的真相源；Platform V2 task pages 只能引用它，不可把平台操作方法倒灌回共享規格頁。

### 10.10 舊 Platform V2 上架頁去向凍結

目前 live 導覽上的舊 `docs/platform-v2/model-publishing/` 頁，不得在 SOP2 由 owner 自行決定去留；本節凍結其唯一處置：

1. `docs/platform-v2/model-publishing/containerization-standard.md`
處置固定為 `redirect to docs/platform-v2/reference-contracts/model-card-containerization-standard.md`。它不再保留為主流程規格頁。
2. `docs/platform-v2/model-publishing/callback-api.md`
處置固定為 `redirect to docs/platform-v2/reference-contracts/model-card-publish-callback-api.md`。它不再承接主流程收件說明。
3. `docs/platform-v2/model-publishing/implementation-spec.md`
處置固定為 `redirect to docs/platform-v2/reference-contracts/model-card-publishing-implementation.md`。它保留工程契約用途，但退出主流程導航。
4. `docs/platform-v2/model-publishing/troubleshooting.md`
處置固定為 `redirect to docs/platform-v2/model-publishing/issue-handling.md`。故障排查主入口改由新問題處理頁承接。
5. `docs/platform-v2/model-publishing/verification-evidence.md`
處置固定為 `redirect to docs/platform-v2/model-publishing/release-decision.md`。證據與完成判定敘事改由新發布判定頁承接。

本輪不允許保留上述舊頁與新頁雙軌並存的主流程導航。若實作需要保留舊檔作為 stub redirect 或過渡說明，可保留檔案殼，但其導航位置與主責任必須依本節固定處置移轉。

## 11. CEO 核准路徑映射

依 2026-07-01 本輪 CEO 指示，以下路徑映射視為已核准施工契約，不再只是 PM 暫定 mapping：

1. Platform V2 七頁主流程沿用 `docs/platform-v2/model-publishing/` 路徑族，包含 `index.md`、`preparation.md`、`release-intake.md`、`content-validation.md`、`data-and-state.md`、`issue-handling.md`、`release-decision.md`。
2. 共享規格真相源固定沿用 `docs/platform-v2/reference-contracts/model-card-containerization-standard.md`。
3. 相鄰供應商頁沿用既有 `docs/model-provider/` 路徑族，透過交叉導覽與連結調整對齊本 initiative。
4. 本輪若未重新開啟 SOP1，不得把上述路徑改成其他 slug、搬到其他目錄，或改成「先施工再決定最終位置」。
