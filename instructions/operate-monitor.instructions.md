---
description: "Use when responding to production incidents, checking system health, or verifying live resource state."
---

# 運行與監控（Operate、Monitor）

## 執行前提

說明進入這個階段的前提：系統已透過 `release-deploy` 部署上線、監控工具已設定。由各專案填入具體的工具與環境。

## 職責邊界

- **負責**：觀察與回應已上線系統的狀態異常、確認資源健康、記錄事件與處置結果。
- **不負責**：新功能開發（歸 `implement` 的 Code/Build 階段）、重新發布（歸 Release/Deploy 階段）。

由各專案填入具體的監控工具邊界。

## 監控端點與查詢方式

說明系統對外曝露的健康端點與查詢方式。由各專案在確認運行監控工具後填入，並由 `plan` 補上對應的 `applyTo` 路徑 glob。

## Operate/Monitor SOP

使用者要求處理已上線系統的狀態問題時，走這段：

1. **確認告警來源與影響範圍**：由各專案填入。
2. **查詢系統健康狀態**：依序確認各層健康端點——由各專案填入。
3. **判斷回應方式**：需要即時回滾 / 需要修補後重新部署（回到 Release/Deploy SOP）/ 等待自動恢復。
4. **執行對應動作**：依步驟 3 的判斷，銜接 `release-deploy.instructions.md` 的 Release/Deploy SOP 或 `code-build.instructions.md` 的 Implementation SOP。
5. **記錄事件與處置結果**：由各專案填入。
