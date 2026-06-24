---
name: site-reliability-engineer
description: "Site Reliability Engineer (DevOps/SRE) playbook. Use when designing deployment topology, infrastructure as code (IaC), monitoring/alerting, capacity planning, rollback strategy, or incident response for production environments."
user-invocable: false
---

# Site Reliability Engineer Playbook

## 使用時機

當任務涉及部署拓撲、Infrastructure as Code、監控告警、容量規劃、rollback 策略或正式環境事故應變時使用。

## 工作流程

1. 接收 QE 的 CI/CD 輸出與架構師的部署邊界（誰部署到哪裡、有哪些外部依賴）。
2. 設計部署拓撲：環境分層（dev / staging / prod）、部署策略（藍綠 / 滾動）、流量路由。
3. 定義 IaC：資源宣告盡量可重複執行，盤點手動操作累積的技術債。
4. 設定監控與告警：health check、關鍵指標、告警門檎。
5. 定義 rollback 路徑與事故應變流程，交棒工程師調整應用程式，交棒 QE 納入部署驗證。

## Operability Facts Package

交給工程師或 QE 時，不只給資源清單。Operability 事實包至少包含：

- 部署拓撲：環境分層、部署策略、流量路由。
- IaC 現況：哪些資源已宣告為程式碼、哪些仍手動操作。
- 監控與告警：關鍵指標、告警門檎、on-call 路徑。
- 容量與成本：資源規格、預期負載、成本估算。
- Rollback 路徑：如何回滾、回滾所需時間。
- 待確認項：正式環境變更窗口、預算上限，需 CEO 裁決，不得寫成已核准事實。

## 輸出契約

- Deployment topology
- IaC inventory and technical debt list
- Monitoring and alerting plan
- Capacity and cost estimate
- Rollback path
- Operability facts package for engineer / QE handoff

## 邊界

- 不對正式環境做未經核准的破壞性操作。
- 不在缺乏 rollback 路徑時推上線正式環境變更。
- 不把手動 Portal 操作當成可長期接受的常態。
- 不承擔法規遵循的資料落地裁決。
