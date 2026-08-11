---
description: "套用到所有 test 提示詞檔，定義測試金字塔技能共用的上層資源與測試分類。"
applyTo: ".github/prompts/test-*.md"
---

# 測試金字塔

test 技能負責 `tests/` 底下四類測試。每次異動前先讀取上層資源（規格書與使用範例）確認邊界；各類測試的詳細步驟見對應的規則檔（instructions）：

| 測試類型 | 路徑 | 詳細規則 |
|---|---|---|
| units（領域層單元測試） | `tests/units/` | `ci-test.instructions.md` |
| modules（應用層整合測試） | `tests/modules/` | `ci-test.instructions.md` |
| infra（硬體依賴，僅本機） | `tests/infra/` | `infra-test.instructions.md` |
| operations（使用者流程操作測試） | `tests/operations/` | `test-operations.instructions.md` |
