# `.github` 維護者指南

本文件供 `.github` runtime 維護者使用。一般子專案使用者只需閱讀根目錄 `README.md`。

## README 受眾邊界

根目錄 `README.md` 是給子專案使用者看的導入頁，不是維護者操作手冊。它只回答四件事：

- 這個 runtime 能幫使用者得到什麼。
- 如何掛載與啟用。
- 日常如何呼叫 agent / skill。
- 如何確認模組已生效、遇到載入問題時怎麼自查。

以下內容必須放在 `docs/`，不要放回 README：

- skill 蒸餾、考核、品質評分流程。
- 哪個檔案該怎麼修改、frontmatter 欄位規則、工具權限設計。
- 維護者提交、發版、PR、tag 的操作細節。

分工判定：PM `product-strategy-manager` 負責 README 的受眾定位與交付形式；HR `skill-quality-auditor` 負責發現並記錄「文件受眾漂移」這類規範落差；RD 依 PM/HR 的結論執行文件調整。不需要新增角色。

### 角色執行校正

`product-strategy-manager` 在處理 README 時，必須先回答「這份文件交付給誰、讀者完成哪個動作就算成功」。若答案是子專案使用者，README 就只能保留導入、啟用、日常操作與自查；維護者流程不得混入。

PM 不得只回應 CEO 指出的單一缺口。每次處理 README 都必須建立「使用者成功路徑」並檢查整份文件：使用者要得到什麼、五分鐘內如何啟用、常見任務該走哪個入口、如何驗證已生效、哪些能力是此 runtime 實際提供。若 README 宣稱 agent / skill / instructions 可用，PM 必須要求 RD 先對照實體檔案，不能把未存在的能力寫成產品承諾。

`skill-quality-auditor` 在回顧這類文件工作時，不應只檢查內容是否完整，還要檢查受眾是否漂移。若 README 出現維護者流程、內部欄位規則、發版步驟或鏡像同步細節，應判定為「文件受眾漂移」，建議移入 `docs/`。

Auditor 對 PM 的校正重點不是「補哪張表」，而是確認 PM 是否已從使用者目標推導整份 README 的資訊架構。若 PM 只按 CEO 點名項目逐項補洞，未主動檢查同類缺口，應記錄為 PM 執行落差並要求重做受眾、成功條件與能力承諾檢查。

`skill-talent-acquisition` 的介入邊界是判斷是否缺少新角色或新 skill。此案例屬於既有 PM 與 Auditor 的職責未正確執行，不需要招募新角色；女媧只需校正分工，必要時把此準則沉澱到維護文件或既有 skill。

## 什麼時候該改哪裡

| 想達成的效果 | 修改位置 | 注意事項 |
|--------------|----------|----------|
| 所有對話都要遵守一條規則 | `.github/copilot-instructions.md` | 保持精簡，避免長篇流程常駐消耗 context |
| 只在特定檔案或任務套用規則 | `.github/instructions/*.instructions.md` | 用精準 `applyTo`，不要濫用 `**` |
| 新增一位固定角色或限制工具權限 | `.github/agents/*.agent.md` | `description` 要說清楚何時使用；`tools` 採最小權限 |
| 把重複流程變成 slash command | `.github/skills/<name>/SKILL.md` | `name` 必須與資料夾一致；描述要具體；大型參考資料放 skill 目錄內並用 Markdown link 引用 |
| 專案自己的技術棧 / 測試命令 | 子專案自己的 `copilot-instructions.md` 補充段或 `AGENTS.md` | 只寫「這個專案在做什麼」，不複製 Connect AI 公司規範 |

## 維護注意

- 修改 `instructions/` 時注意 `applyTo` glob 寬度，避免污染所有對話 context。
- 修改 `agents/` 的 `tools` 白名單需明確權衡：寬鬆容易越權，過嚴 agent 無法工作。
- 修改 `skills/` 時保持 `name` 與資料夾名稱一致，並把高頻規則留在 instructions，避免 skill 變成常駐憲法。

## 自我一致性檢查

維護者修改任何規範後，至少檢查：

- README 是否只承諾本 runtime 實際存在的 agents、instructions 或 skills。
- 使用者是否能在五分鐘內完成掛載、啟用檢查與第一次真實任務。
- 常見任務是否有明確入口，不需要讀者理解內部維護流程。
- 觸發詞、職權邊界與交棒關係是否語意一致。