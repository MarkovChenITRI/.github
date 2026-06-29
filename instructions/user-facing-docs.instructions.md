---
description: "Use when writing or revising user-facing documentation, developer docs, onboarding, quickstarts, Pages content, or user-visible UI copy. Enforces Azure Learn-style human documentation structure and language."
applyTo: ".github/README.md,.github/docs/**/*.md,README.md,docs/**/*.md,**/README.md,**/docs/**/*.md,templates/**/*.html,static/js/**/*.js"
---

# 使用者文件與 UI 文案準則

本檔適用於所有**給人看**的內容：README、onboarding、quickstart、開發者文件、Pages 文件、維運說明，以及產品頁面上的使用者可見文字。目標不是讓內容看起來像 agent 規範，而是讓人能快速理解、照著做並完成任務。

## 一、先判斷這是不是人類文件

符合下列任一條件，就套用本準則：

1. 內容是給採用者、開發者、維運者、審查者或終端使用者閱讀。
2. 內容的成功標準是「人能完成任務」，不是「Copilot 能套用規則」。
3. 內容會出現在 Pages、README、docs、HTML 頁面、按鈕、提示文字、錯誤訊息或空狀態。

若內容是給 Copilot 執行的規則，請回 `.github/instructions/`、`.github/agents/`、`.github/skills/`，不要用本檔的寫法。

## 二、固定寫作模式

### 任務型文件

若文件是在教讀者完成一件事，優先使用這個結構：

1. 這份文件會幫你完成什麼
2. 開始之前
3. 執行步驟
4. 驗證結果
5. 疑難排解
6. 下一步

### 概念型文件

若文件是在解釋概念或邊界，優先使用這個結構：

1. 這份文件說明什麼
2. 什麼時候需要理解這件事
3. 核心概念或邊界
4. 常見誤解
5. 下一步

### 參考型文件

若文件是欄位、設定、契約或 API 對照表，優先使用這個結構：

1. 這份文件提供什麼參考
2. 欄位或值的定義
3. 範例
4. 限制或注意事項
5. 相關文件

## 三、語氣與結構

1. 先寫讀者要完成什麼，再寫背景。
2. 標題要可掃描，直接描述讀者能做的事。
3. 步驟一律用編號清單。
4. 每一步只做一個主要動作；若讀者可能搞不清楚位置，先寫操作位置再寫動作。
5. 用命令式動詞起句，例如「執行」「選擇」「確認」「開啟」。
6. 若文件有成功條件，明確寫出讀者應看到什麼結果。

## 四、禁止把內部語言直接給使用者

下列語言不得直接丟給使用者，除非文件本身就是在解釋內部治理流程：

1. 「agent 應該」「skill 落差」「session insight」「上下文汙染」
2. 「PM / RD / QE / HR 交棒」這類內部分工語言
3. 「這輪修了什麼」「本次 patch」「PR 歷程」這類開發紀錄語言

需要保留的，應轉成讀者可理解的操作語，例如：

- 內部語言：`verification evidence package`
- 對外語言：`驗證結果與可追溯證據`

## 五、使用者可見文案規則

套用到 HTML、JS 或 UI 文案時：

1. 優先寫行動與結果，不寫內部系統狀態。
2. 錯誤訊息要告訴使用者下一步能做什麼。
3. 空狀態要說明目前沒有什麼、可以做什麼。
4. 不把內部欄位名、資料表名、角色名直接暴露成主要文案。
5. 不用「理論上」「應該」「正常來說」這類不負責任語氣。

## 六、正式交付前的來源檢查

任何使用者文件或 UI 文案，在定稿前都要能對應到三類來源：

1. PM 的 reader / product context package
2. RD 的 system facts package
3. QE 的 verification evidence package

若缺其中任一來源，不得把內容包裝成既成事實。

## 七、交付責任

1. `product-strategy-manager` 定義讀者、成功條件與交付形式。
2. 當前任務 owner 可以直接依本準則撰寫使用者文件與 UI 文案。
3. RD 提供系統事實，QE 提供驗證證據。
4. 若任務涉及跨頁重構、資訊架構調整或多方來源收斂，則由 `product-strategy-manager` 協調 reader contract，並由相關 owner 共同完成。
5. 任何角色都不應直接以內部工作語氣定稿使用者文件。

## 八、快速檢查清單

- [ ] 這份內容是寫給人，不是寫給 Copilot。
- [ ] 標題可掃描，能直接描述讀者要完成什麼。
- [ ] 文件結構符合任務型、概念型或參考型其中一種。
- [ ] 讀者能看出開始條件、操作步驟、成功結果與下一步。
- [ ] 內容沒有直接暴露內部治理語言或開發紀錄語氣。