---
description: "Loaded automatically for all test-related prompts. Mirrors the test 技能通用規範 — test pyramid, SOP pointer, and which instructions file covers each test type."
applyTo: ".github/prompts/test-*.md"
---

# test 技能通用規範

test 技能負責 `tests/` 底下四類測試，每次異動前先讀取上層資源（規格書與使用範例）確認邊界；各類測試的詳細 SOP 見對應的 instructions 檔：

| 測試類型 | 路徑 | 詳細規則 |
|---|---|---|
| units（領域層單元測試） | `tests/units/` | `ci-test.instructions.md` |
| modules（應用層整合測試） | `tests/modules/` | `ci-test.instructions.md` |
| infra（硬體依賴，僅本機） | `tests/infra/` | `infra-test.instructions.md` |
| operations（使用者流程操作測試） | `tests/operations/` | `operations-test.instructions.md` |
