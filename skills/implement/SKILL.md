---
name: implement
description: "Use when the user asks to add, modify, or fix code under the presentation, application, domain, or infrastructure layers."
---

# implement

使用者要求新增、修改或修正落在使用者介面層、應用層、領域層、基礎設施層的程式碼時觸發。

依 `.github/instructions/ddd-architecture.instructions.md` 的 Implementation SOP 執行：判斷所屬層級 → 確認 `.github/specs/<layer>.md` 是否已有對應模組的段落（沒有就依 `plan` skill 的流程先建立）→ 依「分層放置規則」與「依賴方向」施工 → 行為有變更時回寫規格書。
