## [2026-06-12] 子專案：ai-hub-webui

### 落差描述
本次 AI Hub WebUI 的 README 與維運文件雖已補齊圖表、表格、程式碼區塊與步驟，但語境一度偏向「CEO 交接報告」與第三人稱內部彙整。這會讓專案看起來像一次內部交接成果，而不是可被外部開發者、公司或任何採用者直接使用的獨立技術資產。

### 蒸餾過程
這筆語氣原則來自 CEO 要求 README 參考 Microsoft Learn 的產品文件寫法，當時明確以 [Azure App Service 概觀](https://learn.microsoft.com/zh-tw/azure/app-service/overview) 作為例子。該頁不是用內部交接語氣報告「誰完成了什麼」，而是先說 App Service 是什麼、為什麼使用、不同讀者情境可以得到什麼能力，最後再導向後續步驟與相關資源。這表示 README 不能只把部署結果或維運細節列出來，而要先讓採用者理解專案本身提供什麼、適合誰、可以完成什麼任務，以及下一步去哪裡操作或驗收。

### 實際決策
文件應採用中立、直接面向讀者的產品文件語氣，參照 Microsoft Learn App Service overview 的做法：先交代服務或專案是什麼、為什麼讀者需要它、哪些情境會用到，再提供架構、操作、驗收與後續文件入口。README 與相關文件要像本專案本身提供的正式使用與維運指南，而不是代理人向 CEO 回報的工作紀錄。建議句型包含「若要...您可以...」、「您不需要先...」、「請先...」、「您可以用它...」。文件可保留 Mermaid 圖、表格、程式碼、驗收步驟與部署資訊，但敘事主體應是採用者、部署者、開發者或維運者，而不是 CEO、PM、RD、QE 的內部交接角色。

### 校正建議
後續產出 README、部署指南、資料庫維護文件、架構文件或公開採用文件時，先確認文件是否把專案視為「可被採用的獨立資產」。若文件內容是給最終讀者使用，應避免「本次更新」、「交接」、「新任 CEO」、「PM/RD/QE 回報」、「請 CEO 判斷」等語境；可用 [Azure App Service 概觀](https://learn.microsoft.com/zh-tw/azure/app-service/overview) 作為檢查範例，看文件是否先講清楚用途、讀者情境、能力邊界與下一步，而不是直接進入內部成果整理。採納時應檢查：讀者不需要知道內部角色分工，也能依文件完成理解、部署、驗收與維護。

## [2026-06-12] 子專案：ai-hub-webui

### 落差描述
README 修正過程中，文件一度把文件撰寫者的內部理解框架直接呈現給讀者，例如「資產化」、「閉環」或把網站內容整理成清單。這些概念有助於撰寫者組織資訊，但不是讀者理解專案時需要看到的語言，容易讓 README 變成文件管理視角，而不是產品與系統採用視角。

### 蒸餾過程
本次原則是從多輪 CEO 校正中蒸餾而來：第一，README 的目的必須回到「通過 GitHub Pages, Azure App/DB 自動化部署 AI Hub 解決方案官方網站」，不能把 documentation manager 的「資產化」目的誤寫成專案目的。第二，專案組成要由網站實際商業邏輯推導，先確認三項產品、兩大類解決方案與兩項核心技術，再說明為什麼需要網站前端、網站後端與資料庫。第三，「閉環」是文件撰寫者自己的內部思考模型，輸出給讀者時應包裝成 GitHub Pages、GitHub Actions、Azure App Service、Azure Database for PostgreSQL、Azure Key Vault 五個服務構成的系統架構。第四，工作環境與部署資源段落應先講 VS Code、Copilot、PostgreSQL 外掛與 uv，再用內文導向 workflow、schema、Azure 設定等專門文件。第五，抽象條件句容易留下解釋空間，README 應補具體情境，例如只啟動網站、本機連 PostgreSQL、push 到 GitHub main 後自動測試與部署。

### 前情提要
這筆回饋只適用於已經選定 GitHub Pages、GitHub Actions、Azure App Service、Azure Database for PostgreSQL、Azure Key Vault 作為交付路徑的 AI Hub WebUI README，不是一般性主張「所有專案都應使用 GitHub / Azure」。當文件提到這些服務時，原因必須回到本專案的既定目的：用 GitHub Pages 與 Azure App/DB 自動化部署 AI Hub 解決方案官方網站，並支撐網站產品、資料保存、維護與自動化驗收。若未來專案換成其他雲端或部署方式，應重新蒸餾對應架構，而不是套用這筆結論。

### 實際決策
README 應先用專案目的與平台要打造的具體內容引導讀者，再把內容轉譯成本專案已採用服務下的系統說明。產品面要說明三項產品、兩大類解決方案與兩項核心技術；架構面要說明為什麼在本專案中需要 GitHub Pages、GitHub Actions、Azure App Service、Azure Database for PostgreSQL、Azure Key Vault 這五個既定服務，以及每個服務各自支撐哪一段讀者任務；工作環境面要先說明本機工具，再將 workflow、schema、Key 設定等細節導向專門文件。段落順序應跟讀者任務一致：先理解目的與架構，再準備環境，接著本機啟動與自動部署，最後才談資料庫保存、修正與維護。

採納這筆原則時，應檢查 README 是否回答三個問題：讀者為什麼要理解這段、這段依據的是哪個已存在的專案事實、讀者看完後下一步能做什麼。若一段文字只是在宣稱「某服務支撐某目的」，但沒有說清楚該服務在本專案的具體任務、驗收方式或後續文件入口，就應退回重寫。

### 校正建議
documentation-experience-manager 在撰寫 README 時，應把「內部整理概念」留在自己腦中，輸出時改成讀者可採用的產品、架構、操作與維護語言。不要預設所有資訊都要整理成表格；若已有 workflow、schema、Azure 設定等專門文件，應在相關段落用內文自然引用，而不是只集中放在最後的文件清單。遇到 CEO 多輪校正時，應同步記錄蒸餾過程：哪些詞被否決、哪些讀者路徑被確立、哪些專案事實成為 README 的排序依據，避免下次重複犯同一類文件抽象化錯誤。

記錄蒸餾結果前，必須先寫好前情提要：這筆原則從哪個情境來、適用於哪類專案或文件、有哪些前提不能省略、哪些情況下不應套用。若缺少前情提要，後面的「實際決策」會像無來源的教條，其他 agent 無法判斷何時採納、何時退回或如何檢討。

## [2026-06-12] 子專案：ai-hub-webui

### 落差描述
README 在整理部署、資料庫與維運內容時，曾反覆使用 `production`、`runtime`、`workflow`、`secret value`、`catalog`、`schema`、`subscription` 等意義過廣或偏工程內部的詞。這些詞對工程師可能有概略方向，但對採用者或接手者來說會留下太多想像空間，不容易立刻知道指的是正式上線資源、網站後端服務、部署流程、密碼值、資料表結構，還是模型部署選項清單。

### 前情提要
這筆回饋來自 AI Hub WebUI README 的最後語氣校正。當文件已經確定要面向採用者、維運者與接手開發者時，不能只靠英文工程泛詞維持專業感；README 的責任是把本專案實際使用的 GitHub Pages、GitHub Actions、Azure App Service、Azure Database for PostgreSQL、Azure Key Vault 與 PostgreSQL 維護流程說清楚。若詞彙是服務名稱、設定名稱或檔案名稱，例如 GitHub Secrets、App Service Settings、`pg_dump`、`deployment-report`，可以保留原名；但說明句應改成台灣讀者能直接理解的中文。

### 實際決策
文件敘述應以具體中文取代泛詞：`production` 改成「正式上線環境」或「正式上線資源」；`runtime` 改成「網站後端服務」、「網站啟動需要的環境變數」或「模型部署選項」；`workflow` 改成「GitHub Actions 部署流程」或「部署流程檔」；`secret value` 改成「密碼值」；`schema` 改成「資料表結構」；`catalog` 改成「選項清單」；`subscription` 改成「訂用帳戶」。若英文詞是必要的正式名稱，第一次出現時要用中文補足用途，不要讓讀者自行猜測範圍。

### 校正建議
documentation-experience-manager 後續撰寫 README、部署文件、資料庫維護文件或接手文件時，應掃描是否有意義太廣的英文詞。凡是讀者看完仍可能問「具體是哪個環境、哪個流程、哪個設定、哪個資料表、哪個密碼」的句子，都應改成台灣中文的具體操作語。技術詞不是不能保留，但必須分清楚：服務名、設定名、指令名保留原名；描述責任、資料內容、驗收條件與維護行為時，應優先使用清楚中文。

## [2026-06-12] 子專案：ai-hub-webui

### 落差描述
README 撰寫過程暴露出兩個文件治理落差。第一，feedback 曾被寫到 ai-hub-webui 根目錄的 `feedback/session-log.md`，但 feedback 屬於 `.github/feedback/` 的 HR / skill-quality-auditor 記錄範圍，不應進入產品 repo。第二，README 修改一度把「乾淨」誤解成刪減或抽象，導致必要的讀者動作被拿掉，例如本機啟動命令 `uv run python app.py` 被誤刪；部署段與資料庫維運段也曾把連結、願景、規則與工作細節混在一起，讓讀者看不到先後順序或章節責任。

### 實際決策
feedback 一律記錄在 `.github/feedback/session-log.md`，ai-hub-webui 根目錄不保留 `feedback/`。README 編排則採用「導言只放願景與分類，細節回到各自小節」的規則：本機啟動保留可執行命令；提交與自動部署改成先確認設定、再 push、再看 GitHub Actions 驗收、最後查正式資源或建立新資源；資料庫維運改成一段資料保存願景，並分成「資料表更新」與「資料移植/重建」兩條工作路徑。重複資料清單、重複維護指南連結與連結堆疊都應收斂。

### 校正建議
documentation-experience-manager 與 skill-quality-auditor 後續處理 README 或 feedback 時，應先確認寫入位置：產品 repo 只放產品文件、部署文件與程式碼；HR feedback、skill 落差與 session insight 一律放 `.github/feedback/`。README 編輯時需檢查三件事：必要命令是否仍存在、交叉參照是否有閱讀順序、章節導言是否只負責願景與分類。若為了修格式或檔尾問題需要大幅重建中文 Markdown，應優先停下來確認更小的編輯方式，避免造成重複段落、code fence 斷裂或把中途方案寫成最終事實。

## [2026-06-22] 子專案：ai-hub-webui

### 落差描述
本次 Model Card deployment pages 修正一度過度依賴關鍵字掃描，例如只查 `驗收`、`smoke test`、`visibility` 等殘留詞，卻沒有先完整閱讀部署頁、首頁入口與 container integration 回指的語意。這導致表面上清掉了部分字詞，但文件仍可能在讀者路徑、章節承接、角色語氣與相鄰頁面引用上不順，甚至讓部署者從首頁或 provider 文件又被帶回 QE / 發布檢查語境。

### 實際決策
編輯正式文件時，關鍵字掃描只能作為最後的殘留檢查，不能取代完整閱讀。文件修正前應至少完整瀏覽目標頁全篇，並閱讀會影響同一讀者路徑的相關頁面，例如入口頁、相鄰部署頁、共通規範頁與回指段落。修正時要以「讀者從哪裡進來、看完這段要做什麼、下一頁如何承接」為主軸，確認語氣、章節順序、表格欄位、流程圖節點與跨頁連結一致；最後才用關鍵字掃描確認沒有殘留不適合的詞。

### 校正建議
documentation-experience-manager 後續修 README、GitHub Pages 文件、部署指南、資料庫維護文件或 provider 規範時，應採用「全篇閱讀 -> 相關頁語意比對 -> 最小修文 -> 建置驗證 -> 關鍵字殘留掃描」的順序。若 CEO 指出「語意不順」或「不是只查關鍵字」時，應停止擴大 grep，先逐頁閱讀並摘要目前讀者路徑，再做文案修正。skill-quality-auditor 後續評估文件類 skill 表現時，也應把「是否完整閱讀目標文件與相關語意上下文」列為檢查點；只靠關鍵字掃描完成文件修正，應視為文件體驗落差。