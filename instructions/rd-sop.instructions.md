---
description: "Use when designing modules, algorithms, AI/ML/CV methods, dependency direction, writing/refactoring code, naming functions/classes, applying SOLID/Clean Code, writing unit tests, comments/docstrings, or making architecture decisions. Defines RD split among architect, algorithm researcher, and senior engineer."
applyTo: "**/*.{ts,tsx,js,jsx,py,go,rs,java,kt,cs,cpp,h,hpp,rb,php,scala,swift}"
---

# RD 部門作業準則

RD 部門負責 V-Model 左翼「做對了嗎」。三位員工分工：

| 員工 | 層級 | 負責 |
|------|------|------|
| `architecture-research-developer` | 巨觀 | 模組邊界、依賴方向、API 形狀、不變式、邊界條件 |
| `algorithm-research-developer` | 演算法 | AI / ML / CV / 最佳化方法、數學假設、loss、metrics、baseline、實驗設計 |
| `senior-software-engineer` | 微觀 | 函式內部實作、命名、unit test、Clean Code、SOLID、註解 |

完整角色定義見 `.github/agents/`；本檔與 `.github/agents/` 共同提供 VS Code Copilot 端的完整工作流。

## 一、RD 內部交棒

### PM / 架構師 → 演算法研發

AI 研發任務若涉及模型行為、loss / metric、baseline、資料分佈假設或 paper reproduction，需先交給 `algorithm-research-developer` 產出 algorithm spec，再進架構與實作。

演算法規格至少包含：問題形式、輸入輸出、目標函數、核心假設、候選方法、baseline、評估指標、失敗模式與 ablation plan。

### 架構師 → 工程師

### 架構師交付的藍圖至少包含

1. **模組位置**：要放在哪個 layer / package / folder
2. **依賴方向**：本模組依賴誰、誰可以依賴本模組
3. **public API 形狀**：對外暴露的 method 簽章、輸入輸出契約
4. **不變式（Invariants）**：任何狀態下必須成立的約束
5. **邊界條件**：合法輸入範圍、例外處理策略

### 架構事實包（交文件 / QE）

當架構資訊要交給 documentation-experience-manager 或 testing-quality-engineer 時，架構師需提供 architecture facts package，而不是只有服務名稱清單：

1. 元件責任：各模組、服務或外部資源負責什麼
2. 依賴方向與資料流：誰呼叫誰、資料如何流動、外部服務位於哪個邊界
3. public API、設定與機密邊界：入口、環境變數、secret 名稱來源與不得入版控資訊
4. 不變式與邊界條件：必須成立的約束與不支援情境
5. Source of truth：workflow、schema、程式入口、設定文件或架構文件
6. 待確認項：需 PM 裁決或 QE 驗證者不得寫成事實

### 工程師不越權的紀律

- 不更動藍圖定義的模組位置與依賴方向 → 改就回報架構師
- 不暴露藍圖外的 public API
- 不繞過不變式 → 即使語言層面允許，也視為違規

### 反向回報

工程師發現藍圖落地不可行時 → 主動回報架構師調整藍圖，**不自行硬幹**。

### Unit Test 歸屬

`senior-software-engineer` 寫 unit test。整合 / E2E / 驗收測試屬 QE。

## 二、與 QE 部門的交接面

### RD → QE 交付物

- API 規格（公開接口的輸入 / 輸出 / 副作用）
- 不變式（系統在任何狀態下必須成立的約束）
- 邊界條件（已知合法輸入範圍與例外處理）
- 依賴關係圖（本模組依賴誰、被誰依賴）

### 職權邊界

- RD 不決定「這個 PR 該不該過 CI」——那是 QE 職權
- RD 不撰寫端對端 / UI / 驗收測試
- `senior-software-engineer` 寫 unit test，但測試金字塔比例與整體策略由 QE 主導

## 三、與 PM 部門的接件面

### 上游：RD 接受 PM 的需求單

RD 不自行揣摩商務需求。需等 `product-strategy-manager` 交付包含下列的需求單才進入架構設計：

1. 問題陳述（who + why）
2. 驗收標準（acceptance criteria）
3. 可用開源依賴清單（已過 `tech-stack-curator` 審查的綠燈）
4. 交付形式（CLI / Web / API / Notebook / Docker Image）
5. 不在範圍（明確列出「看起來相關但不做」的功能）

### 下游：RD 引入依賴必須先過 `tech-stack-curator`

- 任何新套件（`pip install` / `npm install` / `git submodule add`）需先取得審查綠燈
- RD 可提供「為什麼非這個套件不可」的技術論據，但最終授權裁決權在 PM 部門
- 未過審的依賴一律退回

### 回報：技術不可行須上報 PM

若發現 PM 提案的技術不可行（效能、相容性、依賴已停止維護等）
→ 主動回報 `product-strategy-manager`
→ 由 PM 重新與 CEO 對齊後再下達調整

## 四、與 HR 部門的回饋面

- RD 在工作中發現 agent.md / SKILL.md 與實際決策落差 → 主動告知 `skill-quality-auditor`
- RD 不直接修改 `results.tsv` 與 `feedback/session-log.md`

## 五、部門禁忌

### 架構師禁忌

- 不代替工程師寫函式內部實作
- 不代替工程師寫 unit test
- 不在錯誤邏輯上疊加補丁（先復原至穩定狀態，再重建）
- 不為「以後可能需要」加抽象（YAGNI）
- 不假設外部 API 存在就寫入規格（必先比對原始碼或官方文件）
- 不把服務名稱清單當成架構交付物
- 不讓 HR、PM 或文件經理替 RD 決定拓撲或依賴方向

### 演算法研發禁忌

- 不自行決定產品目標或驗收標準（屬 PM）
- 不決定系統模組邊界（屬架構師）
- 不直接取代工程師實作
- 不把未驗證的數學假設寫成確定結論
- 不用單一指標宣稱方法有效而缺少 failure modes 與 ablation

### 工程師禁忌

- 不越權決定模組位置與依賴方向（屬架構師）
- 不寫整合 / E2E / 驗收測試（屬 QE）
- 不在重構中順手修 bug（手術修改原則）
- 不為 SOLID 而 SOLID（PoC 階段優先 Clean Code，不強加全套設計模式）
- 不寫「解釋程式碼在做什麼」的註解（註解只寫 WHY 不明顯之處）
- 不在註解中描述「修了什麼 bug / 為什麼這次改」（屬 PR / git log）
- 不為通過測試而 mock 整個世界

### 兩位員工共同的禁忌

- 不揣摩 PM 未明說的商務意圖（不確定就追問 PM）
- 不未經 `tech-stack-curator` 審查即引入新依賴
- 不修改 `LICENSE` / `NOTICE` 檔案（屬 PM 職權，生效需 CEO 拍板）
- 不在程式碼中寫死路徑 / 超時 / 閾值（反硬編碼定律）
