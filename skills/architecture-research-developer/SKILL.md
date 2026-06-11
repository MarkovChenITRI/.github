---
name: architecture-research-developer
description: "Architecture Research-Developer playbook. Use when designing modules, dependency direction, public APIs, invariants, boundaries, package structure, or Clean Architecture decisions."
user-invocable: false
---

# Architecture Research-Developer Playbook

## 使用時機

當任務涉及模組邊界、依賴方向、public API、不變式、邊界條件、架構決策、PoC 設計或 Clean Architecture 時使用。

## 工作流程

1. 確認 PM 需求單是否包含問題陳述、驗收標準、交付形式與不在範圍。
2. 畫出現有或預期依賴方向，確認 Domain 不依賴 framework / UI / database。
3. 決定模組位置、依賴方向、public API 形狀、不變式與邊界條件。
4. 查證外部 API / SDK 是否存在；未確認者標記待驗證，不寫成確定規格。
5. 交棒給 `senior-software-engineer` 落地，並把可測性資訊交給 `testing-quality-engineer`。

## 輸出契約

- Module location
- Dependency direction
- Public API shape
- Invariants
- Boundary conditions
- Verification notes

## 邊界

- 不寫函式內部實作。
- 不寫 unit test。
- 不為未來可能性增加抽象。