# POV2-06 平台交付與部署

## Metadata 表

| Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename |
| --- | --- | --- | --- |
| POV2-06 | platform-operations-docs-overhaul | POV2-01, POV2-02, POV2-05 | `.github/issues/platform-operations-v2-delivery-deployment-workorder.md` |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 問題陳述與分項目標

平台交付與部署是開發者網站維運的重要功能域，包含 GitHub CI/CD、Azure / GitHub / Key Vault 前提、部署驗證、健康檢查、監控排查，以及目前仍待補的回滾與恢復。現有文件存在 workflow / script 宣稱與 repo 實體不一致的風險，V2 需要以來源重寫並揭露待確認項目。

## 預期效益

1. 維護者能理解程式如何交付到平台環境，以及部署成功的最低判定。
2. CI/CD 文件不再把未確認檔案或腳本寫成確定存在。
3. 回滾與恢復缺口被明確列為待補，不會被監控頁零散段落取代。

## In Scope

1. `GitHub CI/CD`：重寫 workflow、OIDC、部署 job、文件站發布與驗證方式。
2. `部署前提與環境依賴`：重寫 Azure、GitHub Secrets / Variables、Key Vault、App Service 前提。
3. `部署驗證與健康檢查`：重寫 `/healthz`、`/api/model-cards`、deployment report 與成功標準。
4. `維運監控與故障排查`：重寫日常訊號與常見異常。
5. `回滾與恢復`：目前來源不足，先規劃待補頁或待補章節。

## Out of Scope

1. 不新增或修正 workflow yaml。
2. 不新增 Azure deployment script。
3. 不把測試失敗的現況包裝為已通過。
4. 不承諾 deployment pipeline 已涵蓋所有 release gates。

## 前置依賴與輸入契約

| 輸入 | 來源 | 要求 |
| --- | --- | --- |
| CI/CD 流程 | S5 | 需對照 repo 實體；有落差即標待確認。 |
| 環境依賴 | S6 + S5 | 說明前提，不暴露機密值。 |
| 健康檢查 | S5 + S12 | 成功標準需可驗證。 |
| 監控排查 | S12 | 告警與待補項需保留成熟度說明。 |
| 回滾恢復 | S6 + S7 + S12 | 來源不足，標待補。 |

## SOP1 修正 Handoff

Status: pending-ceo-mapping-review.

本分項下一輪 SOP2 只能依 `00-manifest.md` 的 Formal Page Inventory 施工。正式頁面為：`PV2-D01` `docs/platform-v2/delivery-deployment/github-cicd.md`、`PV2-D02` `docs/platform-v2/delivery-deployment/deployment-prerequisites.md`、`PV2-D03` `docs/platform-v2/delivery-deployment/deployment-verification-health.md`、`PV2-D04` `docs/platform-v2/delivery-deployment/monitoring-troubleshooting.md`、`PV2-D05` `docs/platform-v2/delivery-deployment/rollback-recovery.md`。

舊 `azure-environment-and-cicd.md`、`monitoring-and-troubleshooting.md`、`release-gate.md` 只能作為歷史草稿參考，不得作為正式施工交付物。

## 執行策略與內容規劃

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| CI/CD rewrite | senior-software-engineer | 依 S5 重寫 CI/CD，並對照 repo 實體標示待確認。 | 平台交付與部署文件 | GitHub CI/CD 頁 | QE 需驗證文件引用檔案存在。 | 不存在的 workflow 不被寫為現況。 |
| Deployment prerequisites | senior-software-engineer | 依 S6 + S5 重寫環境依賴。 | 平台交付與部署文件 | 部署前提與環境依賴頁 | 不暴露 secret value。 | 前提、缺失影響與檢查面清楚。 |
| Health checks | senior-software-engineer | 依 S5 + S12 重寫部署驗證與健康檢查。 | 平台交付與部署文件 | 部署驗證與健康檢查頁 | 驗證結果需由 QE 佐證。 | 成功標準可被測試或人工查核。 |
| Monitoring and recovery | senior-software-engineer | 依 S12 重寫監控排查，回滾恢復標待補。 | 平台交付與部署文件 | 監控排查、回滾恢復頁 | 回滾來源不足不得寫成完整流程。 | 待補與現有內容分離。 |

## 交付物清單

1. GitHub CI/CD 頁。
2. 部署前提與環境依賴頁。
3. 部署驗證與健康檢查頁。
4. 維運監控與故障排查頁。
5. 回滾與恢復待補頁或章節。

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-06-CP1 | CI/CD truth check | 文件引用 workflow / script 前需確認存在或標待確認。 | 防止部署文件失真。 | 依 S5 重寫並對照 repo。 | QE 執行檔案存在性檢查。 | `docs/platform-v2/`、repo file list |
| POV2-06-CP2 | Deployment verification | 成功上線最低標準與檢查點明確。 | 維護者知道如何判斷部署結果。 | 依 S5/S12 重寫。 | QE 檢查是否有可驗證標準。 | `docs/platform-v2/` |
| POV2-06-CP3 | Recovery gap | 回滾與恢復若來源不足，保留待補標記。 | 不假裝流程成熟。 | 建立待補頁或章節。 | QE 檢查未宣稱完整 rollback runbook。 | `docs/platform-v2/` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-06-CP1 | confirmed | confirmed | blocked | 已建立 `PV2-D01`，以 repo workflow 現況待驗證語氣重寫 CI/CD；待 SOP3 驗證檔案存在性與宣稱。 |
| POV2-06-CP2 | confirmed | confirmed | blocked | 已建立 `PV2-D02`、`PV2-D03`，重寫部署前提、健康檢查與最低成功標準；待 SOP3 驗證。 |
| POV2-06-CP3 | confirmed | confirmed | blocked | 已建立 `PV2-D04`、`PV2-D05`，監控排查與回滾恢復缺口分離呈現；待 SOP3 驗證。 |

## CEO 待提供資源

| 項目 | 內容 |
| --- | --- |
| CI/CD 現況確認 | 確認 production workflow、Pages workflow、unit workflow 與 provisioning script 的真實狀態。 |

## 風險與待確認事項

1. 現有測試與文件曾引用不存在的 workflow，SOP2 必須先做存在性檢查。
2. 回滾與恢復資料不足，不能作為本輪完成頁面除非 CEO / SRE 補來源。