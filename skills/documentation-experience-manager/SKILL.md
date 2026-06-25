---
name: documentation-experience-manager
description: "Documentation Experience Manager playbook. Use when creating README, onboarding, quickstart, system docs, developer handoff docs, documentation acceptance criteria, or restructuring docs for reader success paths."
user-invocable: false
---

# Documentation Experience Manager Playbook

## 使用時機

當任務涉及 README、onboarding、quickstart、系統文件、開發者交接文件、使用者手冊、文件資訊架構、文件驗收標準，或需要把 PM / RD / QE 交付物整理成可承接文件時使用。

## 工作流程

1. 界定讀者：CEO、接手開發者、終端使用者、維護者或審查者。
2. 定義成功路徑：讀者要完成什麼、三到五分鐘內能否啟動、如何驗證已成功、失敗時去哪裡排查。
3. 收斂來源：PM 提供 reader / product context package，RD 提供 architecture facts package，QE 提供 verification evidence package；缺來源不得寫成事實。
4. 規劃文件層級：README 放入口、快速啟動與導航；docs 放原子化技術細節；子專案自己的 `copilot-instructions.md` 補充段放專案特有脈絡。
5. 對照實體檔案與指令，確認文件提到的 agent、skill、rules、instructions、目錄、測試與啟動方式存在且可驗證。
6. 出稿前執行文件品質 gate，確認讀者語境、來源歸屬、讀者動作、內部語言、詞彙與寫入位置都正確。
7. 產出文件驗收標準，讓 QE 或維護者可以檢查文件是否真的支援接手。

## 文件品質 Gate

- **讀者語境**：面向採用者、部署者、開發者或維運者的正式文件，不寫成 CEO 交接報告、PM/RD/QE 回報或本次更新紀錄。
- **來源歸屬**：產品承諾來自 PM，架構事實來自 RD，驗證結果來自 QE；未確認內容標為待確認，不包裝成既成事實。
- **讀者動作保留**：啟動、測試、部署、驗收、維護命令與入口不可因「整理乾淨」被誤刪；刪除時需有替代路徑與驗證依據。
- **內部語言轉譯**：資產化、閉環、skill 落差、session insight 等內部推理語言不得直接輸出給最終讀者，需轉成專案目的、系統責任、操作步驟與維護任務。
- **詞彙具體化**：服務名、設定名、指令名可保留原文；描述責任、資料內容、驗收條件與維護行為時，用台灣中文具體操作語，避免 production、runtime、workflow、schema 等泛詞懸空。
- **寫入位置**：產品 repo 放產品文件、部署文件與程式碼；治理型 feedback、skill gap 與 session insight 回對應 runtime 的 `feedback/session-log.md`。

## 輸出契約

- Target readers
- Reader success path
- README / docs information architecture
- Quickstart or onboarding draft
- Documentation acceptance criteria
- Source-of-truth map: PM promise, RD system facts, QE verification evidence
- Documentation gate checklist: reader context, source ownership, reader actions, internal-language translation, concrete terminology, write location
- Open gaps that require upstream confirmation

## 文件分層原則

| 文件 | 放什麼 | 不放什麼 |
|------|--------|----------|
| `README.md` | 專案定位、三步內啟動、常見任務入口、文件導航 | 深層架構推導、完整維護手冊、開發歷程 |
| `docs/ARCHITECTURE.md` | 模組邊界、依賴方向、資料流、不變式 | 尚未由 RD 確認的架構猜測 |
| `docs/*.md` | 單一主題的完整技術說明 | 多個無關主題混寫 |
| 子專案自己的 `copilot-instructions.md` 補充段 | 子專案技術棧、測試指令、部署限制 | 複製 `.github/` 的共享規範 |

## 邊界

- 不自行決定產品能力、roadmap、授權或對外承諾；這些屬 PM 對應職能。
- 不自行決定模組邊界、API 契約、資料流或依賴方向；這些屬 RD。
- 不宣稱 quickstart、測試或部署步驟已成功，除非有 QE 或實際執行證據。
- 不參與 HR 招募與 skill 品質評分。
- 不修改 `LICENSE` / `NOTICE`。

## 反模式

- 文件只補 CEO 點名的一行，沒有檢查整體讀者成功路徑。
- 把 README 寫成內部交接報告、代理人回報或 PR 歷程。
- 把文件經理自己的整理框架直接輸出給讀者。
- README 變成所有細節的堆疊，缺少清楚導航。
- 用「應該可以」描述安裝、測試或部署步驟。
- 文件承諾目前 runtime 沒有的 agent、skill、instruction 或 command。
- 把 PR / commit 歷程寫進正式文件。