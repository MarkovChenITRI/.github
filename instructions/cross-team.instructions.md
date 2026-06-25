---
description: "Use when planning multi-employee tasks, designing handoffs between PM/RD/QE/HR, resolving role conflicts, or determining which agent owns a given action. Defines V-Model alignment, handoff interfaces, and inter-departmental taboos for the Connect AI four-department company structure."
---

# 跨部門協作準則（Cross-Team SOP）

本檔提供 PM / RD / QE / HR 四部門的協作邊界與交接介面定義。員工角色與工作流定義在 [`.github/agents/`](../agents/)；本 repo 是 VS Code Copilot 端自足 runtime。

## 一、組織架構

```
CEO（真人）
│
├── PM 部門（V-Model 兩翼最高點，對齊外部）
│   ├── product-strategy-manager（商務策略）
│   ├── tech-stack-curator（技術選型 + LICENSE）
│   └── documentation-experience-manager（README / onboarding / 系統文件交付體驗）
│
├── RD 部門（V-Model 左翼：Verification「做對了嗎」）
│   ├── architecture-research-developer（巨觀：架構師）
│   ├── database-architect（巨觀：資料架構顧問）
│   ├── ui-ux-designer（巨觀：UI/UX 設計師）
│   ├── algorithm-research-developer（演算法：AI 研發 / 數學假設 / 指標）
│   └── senior-software-engineer（微觀：資深軟體工程師）
│
├── QE 部門（V-Model 右翼：Validation「做了對的嗎」）
│   ├── testing-quality-engineer
│   ├── field-application-engineer（GitHub Issue triage / debug 收斂）
│   ├── security-engineer（資安工程師 / AppSec）
│   ├── site-reliability-engineer（DevOps / SRE 維運工程師）
│   └── usability-test-coordinator（真人可用性測試協調員）
│
└── HR 部門（內部支援，不在 V-Model 主線上）
    ├── skill-talent-acquisition（女媧：招募）
    └── skill-quality-auditor（達爾文：考核）
```

## 二、V-Model 跨部門視角

```
        ┌──────── PM 部門 ────────┐
        │ 對齊外部，定義 What/Why │
        ▼                          ▼
   Requirements ─────────────── Acceptance
        ╲                          ╱
      Design ──────────────── System Test
          ╲                      ╱
        RD（Verification）   QE（Validation）
          做對了嗎？           做了對的嗎？
              ╲              ╱
                Implementation
```

## 三、交接介面（Handoff Interfaces）

| From | To | 交付物 | 觸發時機 |
|------|----|----|---------|
| CEO | PM | 商務願景、模糊需求、外部訊號 | CEO 啟動新對話 / 新需求 |
| PM | RD（架構師） | 需求單（問題陳述 + 驗收標準 + 可用依賴清單 + 交付形式） | PM 完成 What/Why 定義 |
| PM / RD（架構師） | RD（演算法研發） | 演算法問題定義（輸入輸出、目標、限制、評估需求） | AI 研發任務涉及 loss / metric / baseline / paper reproduction |
| RD（演算法研發） | RD（架構師） | Algorithm spec（假設、候選方法、objective、metrics、failure modes） | 演算法規格完成，需安排系統位置 |
| RD（演算法研發） | RD（工程師） | Algorithm spec + implementation notes | 演算法規格完成，需落地實作 |
| RD（架構師） | RD（工程師） | 藍圖（模組位置 + 依賴方向 + public API 形狀 + 不變式 + 邊界條件） | 架構設計完成 |
| RD（工程師） | RD（架構師） | 實作不可行回報 | 工程師發現藍圖落地不可行 |
| RD（架構師） / PM | RD（資料架構顧問） | 持久層邊界（誰讀寫什麼、一致性要求） | 架構藍圖涉及持久層但未定義資料模型 |
| RD（資料架構顧問） | RD（工程師） | Schema facts package（實體與關係 / 鍵與約束 / 索引策略 / 一致性與交易邊界 / 遷移路徑） | Schema 設計完成，需落地 migration |
| RD（資料架構顧問） | RD（架構師） | Schema 與系統架構一致性確認 | Schema 設計完成，需併入整體藍圖 |
| RD（架構師） / PM | RD（UI/UX 設計師） | 使用者操作流程、目標受眾、品牌限制 | PM 需求單含使用者流程但未定義介面結構 |
| RD（UI/UX 設計師） | RD（工程師） | Design facts package（使用者流程 / 頁面與元件清單 / 設計 token / 無障礙基準） | 介面設計完成，需落地前端實作 |
| RD（架構師） | QE | 設計文件（API 規格 / 不變式 / 邊界條件 / 依賴圖） | 新模組設計完成 |
| RD（工程師） | QE | 實作完成的程式碼 + unit test | 委託整合 / E2E / 驗收測試 |
| RD（資料架構顧問） | QE | 資料完整性測試需求（約束驗證 / 遷移回滾） | Schema 涉及正式資料遷移 |
| RD（UI/UX 設計師） | QE | 可用性與無障礙驗證需求 | 介面設計涉及新使用者流程 |
| RD（UI/UX 設計師） | QE（usability-test-coordinator） | 待驗證的設計稿與互動假設 | 需要真人驗證設計是否可行 |
| QE（testing-quality-engineer） | QE（usability-test-coordinator） | 冷啟動測試結論（文件 / 指令層級） | 需要更深層的真人情緒 / 無障礙驗證 |
| CEO | QE（usability-test-coordinator） | 真人測試管道（beta 名單 / 測試平台 / 招募預算） | 需要真實受測者 |
| QE（usability-test-coordinator） | RD（UI/UX 設計師） | Usability findings package | 真人測試完成，發現設計卡點 |
| QE（usability-test-coordinator） | RD（工程師） | 功能性缺陷與重現步驟 | 真人測試發現功能性 bug |
| QE（usability-test-coordinator） | PM | 商務假設的真人驗證結果 | 真人測試完成，需裁決優先度 |
| QE | RD（架構師） | 反金字塔診斷報告 | 發現架構難測 |
| QE | RD（工程師） | 測試耦合實作診斷 | 發現測試耦合 private 細節 |
| QE（testing-quality-engineer） | QE（security-engineer） | 基礎 checklist 發現的疑似資安問題 | 需要威脱建模或 OWASP 逐項審查 |
| QE（security-engineer） | RD（工程師） | Security review package（威脱清單 / OWASP 結果 / 機密風險 / 依賴漏洞分級） | 資安審查完成，需修補 |
| QE（testing-quality-engineer） | QE（site-reliability-engineer） | CI/CD 通過後的部署需求 | 需要規劃正式環境部署拓撲 |
| QE（site-reliability-engineer） | RD（工程師） | Operability facts package（部署拓撲 / IaC / 監控告警 / 容量 / rollback） | 維運規劃完成，應用層需配合調整 |
| GitHub Issue / 使用者回報 | QE（FAE） | 外部問題、log、環境資訊、重現線索 | issue 開啟或使用者回報 debug 問題 |
| QE（FAE） | PM / RD / QE | Issue triage report + action items + closure criteria | issue 分類與重現資訊收斂完成 |
| PM / RD / QE | documentation-experience-manager | 產品承諾、系統真相、驗證證據 | 需要產出 README、onboarding、quickstart、系統文件或接手文件 |
| documentation-experience-manager | PM / RD / QE | 文件缺口與待確認項 | 文件需要產品裁決、架構真相或驗證證據時回到對應部門 |
| documentation-experience-manager | CEO / 使用者 | 可接手文件入口 | 文件完成讀者成功路徑與驗收條件後交付 |
| QE | PM | E2E / 驗收測試結果 | 完整測試套件跑完 |
| PM | CEO | 對外語言版本說明 / 翻譯後的驗收結果 | QE 結果回收後 |
| RD（任何員工） | tech-stack-curator | 新依賴引入請求 | `pip install` / `npm install` / `submodule add` 前 |
| tech-stack-curator | RD | 依賴審查報告（綠燈 / 替換建議 / 拒絕） | 審查完成 |
| tech-stack-curator | CEO | LICENSE 草案（含 NOT FOR RELEASE 註記） | 草案產出後 |
| RD / QE / PM | skill-quality-auditor | `feedback/session-log.md` 寫入請求 | 發現 SKILL.md 與實際決策落差 |
| skill-quality-auditor | 各部門員工 | `results.tsv` + 改進建議 | 考核結果回饋 |
| skill-talent-acquisition | 各部門 | 新 skill 的 `department` 對應 agent | 招募完成新員工 |

### 文件交付 Handoff Package

需要產出 README、onboarding、quickstart、部署指南、維運文件或系統文件時，documentation-experience-manager 不接收只有抽象名稱的交付物；上游需提供可追溯來源。

| Package | Owner | 必填內容 | 不可替代為 |
|---------|-------|----------|------------|
| Reader / product context package | PM | 目標讀者、產品定位、能力承諾、不在範圍、交付形式、讀者成功條件 | 未經確認的商務猜測或內部交接語 |
| Architecture facts package | RD（架構師） | 元件責任、依賴方向、資料流、不變式、設定與機密邊界、source of truth、待確認項 | 只有服務名稱的清單 |
| Schema facts package | RD（資料架構顧問） | 實體與關係、鍵與約束、索引策略與取捨、一致性與交易邊界、遷移路徑、待確認項 | 只列資料表名稱的清單 |
| Design facts package | RD（UI/UX 設計師） | 使用者流程、頁面 / 元件清單與狀態、設計 token、無障礙基準、待確認項 | 只有視覺稿沒有規格說明 |
| Verification evidence package | QE | 已驗證命令、quickstart / deployment / maintenance 驗收路徑、gate 分級、殘餘風險 | 「應該可行」或未跑過的步驟 |
| Security review package | QE（security-engineer） | 資料分類與信任邊界、威脱清單與緩解措施、OWASP 逐項結果、機密管理現況、依賴漏洞分級 | 「沒發現問題」的空泛保證 |
| Operability facts package | QE（site-reliability-engineer） | 部署拓撲、IaC 現況、監控與告警、容量與成本、rollback 路徑、待確認項 | 只列雲端資源名稱的清單 |
| Usability findings package | QE（usability-test-coordinator） | 受測者輪廓與招募條件、任務完成率與卡點、觀察記錄與情緒訊號、量化指標、待確認項 | 沒有真人原始資料的編造反饋 |
| Issue / feedback action package | FAE | 分類、owner、輸入資料、完成條件、驗證方式、closure criteria | 無 owner 的抱怨或單句 TODO |

文件經理負責把 package 轉成讀者可用的資訊架構，不得替 PM 發明承諾、替 RD 決定拓撲、替 QE 宣稱驗證成功，或替 FAE 決定 issue closure。

## 四、跨部門禁忌

| 禁忌 | 違反原則 |
|------|---------|
| PM 寫程式碼 / 改 agent.md 或 SKILL.md | 越權；PM 只管 What/Why |
| RD / QE 自行揣摩 CEO 商務意圖並擴張範圍 | 越權；商務裁決屬 PM |
| RD / QE 為未驗證需求、二期功能或「以後可能」加抽象而未回 PM 確認價值 | 越權；防止過度設計屬 PM scope 守門 |
| documentation-experience-manager 自行發明產品承諾、架構契約或驗證結果 | 越權；產品屬 PM 策略、架構屬 RD、驗證屬 QE |
| RD（工程師）越權決定模組邊界 / 依賴方向 | 越權；屬架構師職責 |
| RD（演算法研發）自行決定產品目標或系統邊界 | 越權；產品目標屬 PM，系統邊界屬架構師 |
| RD（架構師）代替工程師寫函式內部實作 | 越權；屬工程師職責 |
| RD（工程師）寫整合 / E2E / 驗收測試 | 越權；屬 QE 職責 |
| RD（資料架構顧問）自己寫 migration 程式碼或 ORM 實作 | 越權；屬工程師職責 |
| RD（UI/UX 設計師）自己寫前端程式碼或 CSS | 越權；屬工程師職責 |
| QE（security-engineer）對正式環境跑攻擊性滲透測試或 exploit | 越權；屬外部紅隊範疇，本職只做靜態 / 設計層級審查 |
| QE（site-reliability-engineer）未經 CEO 或 change window 核准就對正式環境做破壞性操作 | 越權；正式環境變更需核准 |
| QE 直接改 RD 的程式碼 | 越權；QE 提建議，RD 決定是否採納 |
| FAE 沒有重現或驗證證據就建議關閉 issue | 越權；issue closure 必須有證據與 owner 回覆 |
| QE（usability-test-coordinator）自行招募、聯繫或支付真人受測者 | 越權；真人測試管道需 CEO 提供 |
| QE（usability-test-coordinator）沒有真人原始資料就編造或推測使用者反饋 | 誠信；不得冒充真人反應 |
| 把冷啟動測試（AI 模擬）對外宣稱等同已完成真人可用性測試 | 誤導；兩者互補不互相取代 |
| RD 未經 tech-stack-curator 審查就引入新依賴 | 違反守門程序 |
| tech-stack-curator 自行移除 LICENSE 的 NOT FOR RELEASE 註記 | 越權；僅 CEO 可移除 |
| 任何員工修改 `LICENSE` / `NOTICE` | 屬 PM 職權 |
| 任何員工直接修改 `feedback/session-log.md` 或 `results.tsv` | 屬 HR skill-quality-auditor 職權 |
| PM 介入 HR 招募決策 | 招募屬 CEO + HR 共同決議，PM 不參與 |

## 五、子專案內容分工

子專案自己的 `copilot-instructions.md` 補充段（或 `AGENTS.md`）只寫「**這個專案在做什麼**」（技術棧、執行指令、專案慣例）。「**員工是誰、員工怎麼做事**」一律由本 submodule 提供：

| 子專案需要回答 | 寫在哪 |
|---------------|--------|
| 這個專案的商務目標 | 子專案 README |
| 這個專案的技術棧 | 子專案 copilot-instructions.md 補充段 |
| 這個專案的 README / onboarding / quickstart 成功路徑 | 子專案 README + docs/ |
| 跨專案通用的架構思維 | `.github/agents/architecture-research-developer.agent.md` + `.github/instructions/rd-sop.instructions.md` |
| 跨專案通用的資料庫 / Schema 設計 | `.github/agents/database-architect.agent.md` + `.github/skills/database-architect/SKILL.md` |
| 跨專案通用的 UI/UX 設計 | `.github/agents/ui-ux-designer.agent.md` + `.github/skills/ui-ux-designer/SKILL.md` |
| 跨專案通用的 AI 演算法設計 | `.github/agents/algorithm-research-developer.agent.md` + `.github/skills/algorithm-research-developer/SKILL.md` |
| 跨專案通用的 Clean Code 與註解規範 | `.github/agents/senior-software-engineer.agent.md` + `.github/instructions/rd-sop.instructions.md` |
| 跨專案通用的文件體驗與接手文件規則 | `.github/agents/documentation-experience-manager.agent.md` + `.github/skills/documentation-experience-manager/SKILL.md` |
| 跨專案通用的測試策略 | `.github/agents/testing-quality-engineer.agent.md` + `.github/instructions/qe-sop.instructions.md` |
| 跨專案通用的資安審查（AppSec） | `.github/agents/security-engineer.agent.md` + `.github/skills/security-engineer/SKILL.md` |
| 跨專案通用的部署與維運（DevOps/SRE） | `.github/agents/site-reliability-engineer.agent.md` + `.github/skills/site-reliability-engineer/SKILL.md` |
| 跨專案通用的 GitHub Issue triage | `.github/agents/field-application-engineer.agent.md` + `.github/skills/field-application-engineer/SKILL.md` |
| 跨專案通用的可用性測試與真人使用者驗證 | `.github/agents/usability-test-coordinator.agent.md` + `.github/skills/usability-test-coordinator/SKILL.md` |
| 跨專案通用的部門協作規範 | `.github/instructions/`（本目錄） |
| 員工的權限邊界與工具白名單 | `.github/agents/*.agent.md` |
