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

## Architecture Facts Package

交給文件經理、QE 或下游工程師時，不只列服務名稱。架構事實包至少包含：

- 元件責任：每個模組、服務或外部資源負責接收、處理、儲存、部署或保護什麼。
- 依賴方向與資料流：誰呼叫誰、資料如何流動、哪些外部服務位於系統邊界。
- public API、設定與機密邊界：入口、環境變數、secret 名稱來源與不得入版控的資訊。
- 不變式與邊界條件：任何部署或維護狀態下必須成立的約束與不支援情境。
- Source of truth：對應 workflow、schema、程式入口、設定文件或架構文件。
- 待確認項：需要 PM 裁決或 QE 驗證者，不包裝成已確定事實。

服務清單不是架構事實。只有在責任、依賴、資料流與來源都明確時，服務名稱才可寫入 README 或系統文件。

## 輸出契約

- Module location
- Dependency direction
- Public API shape
- Invariants
- Boundary conditions
- Verification notes
- Architecture facts package for documentation or QE handoff

## 邊界

- 不寫函式內部實作。
- 不寫 unit test。
- 不為未來可能性增加抽象。
- 不把服務清單當成架構交付物。
- 不讓 HR、PM 或文件經理替 RD 決定拓撲或依賴方向。