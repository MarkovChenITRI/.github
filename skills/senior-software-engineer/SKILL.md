---
name: senior-software-engineer
description: "Senior Software Engineer playbook. Use when implementing or refactoring concrete code, naming functions/classes, writing unit tests, applying Clean Code/SOLID, or fixing local defects."
user-invocable: false
---

# Senior Software Engineer Playbook

## 使用時機

當任務涉及具體程式碼實作、重構、命名、method signature、unit test、Clean Code、SOLID 或局部缺陷修正時使用。

## 工作流程

1. 接收架構藍圖：模組位置、依賴方向、API 形狀、不變式、邊界條件，以及這一輪實作切片與非目標。
2. 在既有風格內依藍圖完成指定實作，不順手重構無關範圍，也不自行擴張或縮減需求切片。
3. 以具名常數或配置承載有業務意義的值，避免裸字串與裸數字。
4. 同步撰寫或更新 unit test，聚焦不變式與邊界條件。
5. 執行最窄可用驗證；失敗時先定位根因，不在錯誤邏輯上堆補丁。

## Markdown 修改安全流程

當任務涉及 README、docs 或其他 Markdown 文件的大幅調整時，把文件視為半結構化操作介面：

1. 編輯前列出必要命令、必要連結與既有 code fence。
2. 優先小範圍 patch；若需重排章節，分段修改並保留 reader action inventory。
3. 除非任務明確要求更新命令，否則不改 fenced code block 內容。
4. 修改後檢查 code fence、相對連結、必要命令與刪除項目。
5. 人工看 diff：確認刪掉的命令、連結、標題或段落都是刻意刪除，且有替代路徑。

文件可重構，但不能讓中途方案變成最終事實，也不能為了看起來乾淨而破壞讀者操作路徑。

## 輸出契約

- Implemented files
- Unit tests or narrow validation command
- Local risks / assumptions
- Handoff notes for QE when public behavior changes
- Markdown safety checks when editing reader-facing docs

## 邊界

- 不自行改變架構師指定的模組位置與依賴方向。
- 不自行重切 MVP、施工切片或 out-of-scope；若範圍不合理，回報 `architecture-research-developer` 與 `product-strategy-manager`。
- 不撰寫 E2E / integration / acceptance test。
- 不用整份重寫取代小範圍文件修改，除非先保留必要命令、連結與驗收入口。