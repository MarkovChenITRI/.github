# GitHub Copilot Skills for VS Code

這個 repo 是一套給 VS Code 使用的 GitHub Copilot runtime。把它放進專案後，Copilot 會自動讀取共享的 instructions、agents 和 skills，你不需要在每次對話中手動重貼規則。

如果你是第一次使用，先完成本頁的掛載與啟用檢查。完成後，你應該能做到三件事：

1. 知道 Copilot 會自動遵守哪些共享規則。
2. 知道該選哪位 agent 開始工作。
3. 知道載入失敗時要去哪裡檢查。

## 你會得到什麼

掛載後，這個 runtime 會提供四種能力：

1. 讓 Copilot 持續遵守這個專案定義的共享工作方式。
2. 讓不同任務自動套用對應規則。
3. 讓你直接指定合適的 agent 接手。
4. 讓複雜任務可再深入使用 skill。

## 開始之前

在掛載這個 runtime 前，先確認兩件事：

1. 你正在 repo root 操作，或已確認 VS Code 允許往父層 repo 尋找 customizations。
2. 你的子專案需要的是共享協作規範，而不是只在單一 repo 內自訂少量提示。

## 掛載這個 runtime

如果你只是想先確認這個 runtime 能不能被 VS Code 載入，先直接把它 clone 到專案根目錄的 `.github/`：

```bash
git clone https://github.com/MarkovChenITRI/.github.git .github
```

完成後，VS Code Copilot 會偵測 `.github/copilot-instructions.md`、`.github/instructions/`、`.github/agents/` 與 `.github/skills/`。

如果你確認這套 runtime 會保留在專案中，再提交這次變更：

```bash
git commit -m "chore: add .github Copilot runtime"
```

## 驗證是否已成功載入

完成掛載後，在 VS Code 依序檢查：

1. 執行 `Chat: Open Customizations`。
2. 在 Instructions、Agents、Skills 分頁確認來源包含 `.github/`。
3. 在 Chat 輸入 `/`，確認可搜尋到這個專案提供的 skills。
4. 打開 Agent picker，確認可選到這個專案提供的 agents。
5. 在 Chat 視窗右鍵開啟 Diagnostics，確認沒有載入錯誤。

最低成功標準如下：

1. `Chat: Open Customizations` 看得到 `.github/` 來源。
2. Agent picker 看得到這個專案提供的 agents。

如果 VS Code 只開啟 monorepo 的子資料夾，Copilot 預設只找目前 workspace 內的 customization。這時請打開 repo root，或啟用 `chat.useCustomizationsInParentRepositories` 讓 VS Code 往父層 repo 尋找 `.github/`。

## 開始第一個任務

完成驗證後，直接用下面這條路徑開始：

1. 需求還模糊時，先找 `@product-strategy-manager`。
2. 範圍已清楚、準備設計或實作時，改找 `@architecture-research-developer` 或 `@senior-software-engineer`。
3. 要補測試、驗收、部署或真實使用驗證時，再切到 QE 相關 agent。

如果你只想先確認 runtime 有沒有真的能用，可以直接丟一個真實任務給 `@product-strategy-manager`，看它是否會沿用這個專案的工作方式回應。

## 角色與使用風格

不同 agent 不只分工不同，回應風格也不同。先理解他們的性格，通常更容易選對入口。

| 角色 | 性格與互動方式 | 什麼時候找他 |
|------|------------------|----------------|
| `product-strategy-manager` | 擅長先收斂目標、讀者與成功條件，會先問「你到底想完成什麼」；當需求開始失焦或團隊對範圍有分歧時，也會回到整體 MVP 視角做最後裁決 | 需求還模糊、範圍容易失焦時 |
| `tech-stack-curator` | 做事像依賴與授權審查員，會主動監測 RD 團隊準備引入或已使用的套件、框架與外部資源，持續檢查 license、商業使用限制、維護狀態與安全風險，再整理成可採用、有條件採用或不建議採用的清單；對 LICENSE 或 NOTICE 只提出草案與使用條件，不接受風險還沒分級就直接納入專案 | 要評估套件、框架、模型或 LICENSE 時 |
| `architecture-research-developer` | 重視潔淨架構、領域語意與責任分界，會把既定 MVP 轉成可施工藍圖，明確界定本輪要做與不做的模組、依賴、API 與邊界；遇到過期或黏死設計時，也會要求先取得同意後清理 | 要先定義系統結構與介面時 |
| `database-architect` | 對資料語意、欄位關係與一致性很敏感，通常會先把表結構收斂乾淨，再討論效能或 migration 取捨 | 需求碰到 schema、狀態語意或資料來源時 |
| `ui-ux-designer` | 會沿著使用者操作路徑一路追問：第一眼看到什麼、下一步要按哪裡、卡住時怎麼被救回來；重視資訊層次、互動狀態與可理解性，不太接受只憑主觀美感拍板 | 要整理頁面流程、資訊架構或文案時 |
| `algorithm-research-developer` | 像研究審稿人一樣，會先追問假設是否成立、baseline 是否公平、指標是否真的代表目標，並要求把 failure mode 與驗證方式說清楚；不太接受「感覺這個方法應該比較好」這種直覺式決策 | 需求涉及 AI、演算法或評估方法時 |
| `senior-software-engineer` | 務實而克制，習慣在既定藍圖與施工切片內把需求落成可維護程式，重視命名、可讀性、unit test 與根因修正 | 規格已清楚，準備開始寫碼或重構時 |
| `testing-quality-engineer` | 對假綠燈很敏感，會先問這次到底要證明什麼、在哪一層驗、失敗訊號是什麼，以及改動會不會讓別處默默壞掉；重視可執行的驗證證據，不喜歡只有口頭上的「應該沒問題」 | 要補測試策略、驗收條件或 release gate 時 |
| `field-application-engineer` | 擅長把模糊抱怨拆成可重現問題與 owner action item | 在追 issue、收斂使用者回饋或排 owner 時 |
| `security-engineer` | 對權限、暴露面與機密資料很敏感，會優先找風險點 | 需求碰到 auth、secrets 或安全邊界時 |
| `site-reliability-engineer` | 會先看部署真相、回滾路徑與監控證據，不只看 repo 內容 | 問題跟部署、快取、環境差異或 operability 有關時 |
| `usability-test-coordinator` | 站在真人測試角度，會關注任務腳本、卡點與原話證據 | 需要設計或整理真人驗收時 |
| `skill-talent-acquisition` | 擅長把零散需求整理成新能力或新角色定義 | 要新增 skill、persona 或長期能力時 |

如果你不知道從哪位開始，預設先走 `product-strategy-manager` → `architecture-research-developer` / `senior-software-engineer` → `testing-quality-engineer`。

## 常見任務入口

| 你現在想做什麼 | 建議入口 |
|------------------|----------|
| 先把需求講清楚 | `@product-strategy-manager` |
| 先把技術邊界講清楚 | `@architecture-research-developer` |
| 直接開始實作 | `@senior-software-engineer` |
| 規劃測試與驗收 | `@testing-quality-engineer` |
| 重現 issue 與分派 owner | `@field-application-engineer` |
| 處理授權、依賴與 LICENSE | `@tech-stack-curator` |
| 整理 README 或 onboarding | 直接在原任務中修改，先把讀者要完成的任務寫清楚 |

## 日常使用方式

使用這個 runtime 時，請遵守以下習慣：

1. 一般聊天不用特別指定；`.github/copilot-instructions.md` 會自動生效。
2. 需要特定職能時，先選 agent；需要完整檢查表時，再用 skill。
3. 專案自己的 `copilot-instructions.md` 只補專案特有技術棧、測試指令與部署限制，不複製這套 runtime 的共用規則。
4. 若行為不如預期，先看 `Chat: Open Customizations` 和 Chat Diagnostics。

若你正在改 README、docs 或 UI 文案，先確認三件事：

1. 這份內容是寫給誰。
2. 讀者要完成什麼任務。
3. 成功時讀者應看到什麼結果。

## 疑難排解

如果你懷疑 `.github` 沒有生效，先檢查以下問題：

1. 你是不是只開了 monorepo 的子資料夾，而不是 repo root。
2. `Chat: Open Customizations` 中是否真的看得到 `.github/` 來源。
3. Agent picker 是否出現這個專案提供的 agents。
4. `/` 選單是否搜尋得到對應 skills。
5. Chat Diagnostics 是否出現載入錯誤。

## 快速檢查清單

- [ ] 專案已包含 `.github/`。
- [ ] `Chat: Open Customizations` 能看到 Instructions、Agents、Skills。
- [ ] Agent picker 能看到這個專案提供的 agents。
- [ ] `/` 選單能找到需要的 skill。
- [ ] 已用一個真實任務測試 agent 是否能被選用。
- [ ] 專案已補技術棧、測試指令、部署限制。

## 下一步

如果你要繼續往下操作，使用這些入口：

- 想看共享憲法：`copilot-instructions.md`
- 想看任務規則：`instructions/`
- 想看角色入口：`agents/`
- 想看深度 playbook：`skills/`

README 只負責入口與導航；需要完整內容時，請直接查看對應規則檔。

## 這個 runtime 包含哪些檔案

```text
.github/
├── README.md
├── copilot-instructions.md
├── instructions/
├── agents/
└── skills/
```
