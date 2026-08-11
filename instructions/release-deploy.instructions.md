---
description: "Use when releasing or deploying this project — pre-deployment checklist, deployment steps, and post-deployment verification."
applyTo: ".github/workflows/deployment*.yml"
---

# 發布與部署（Release、Deploy）

## 執行前提

說明這個階段的前提條件：`code-build` 的哪些產物必須先就緒、測試狀態要求（例如 CI 全綠、smoke test 通過）、需要哪些環境設定與密鑰。由各專案在確認發布流程後填入。

## 職責邊界

- **負責**：把建置好的產物送進部署環境、驗證部署結果、輸出版本記錄。
- **不負責**：業務邏輯修改（歸 `implement` 的 Code/Build 階段）、測試執行（歸 `test` skill）。

由各專案填入具體的工具與環境邊界。

## 產出物與存放位置

說明這個階段的產出物放哪：workflow run logs、部署報告、版本標籤慣例。由各專案填入。

## Release/Deploy SOP

使用者要求發布或部署時，走這段：

1. **前置檢查**：確認必要的環境設定、密鑰、基礎資源就緒——具體項目由各專案填入。
2. **建置步驟**：由各專案填入。
3. **部署步驟**：由各專案填入。
4. **部署後驗證**：依序驗證健康端點、資料庫連線、核心 API——由各專案填入。
5. **版本記錄**：tag、changelog、部署報告——由各專案填入。
