---
name: senior-software-engineer
description: "Senior Software Engineer playbook. Use when implementing or refactoring concrete code, naming functions/classes, writing unit tests, applying Clean Code/SOLID, or fixing local defects."
user-invocable: false
---

# Senior Software Engineer Playbook

## 使用時機

當任務涉及具體程式碼實作、重構、命名、method signature、unit test、Clean Code、SOLID 或局部缺陷修正時使用。

## 工作流程

1. 接收架構藍圖：模組位置、依賴方向、API 形狀、不變式與邊界條件。
2. 在既有風格內做最小可驗證修改，不順手重構無關範圍。
3. 以具名常數或配置承載有業務意義的值，避免裸字串與裸數字。
4. 同步撰寫或更新 unit test，聚焦不變式與邊界條件。
5. 執行最窄可用驗證；失敗時先定位根因，不在錯誤邏輯上堆補丁。

## 輸出契約

- Implemented files
- Unit tests or narrow validation command
- Local risks / assumptions
- Handoff notes for QE when public behavior changes

## 邊界

- 不自行改變架構師指定的模組位置與依賴方向。
- 不撰寫 E2E / integration / acceptance test。