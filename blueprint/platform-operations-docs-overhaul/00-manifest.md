# 平台維運 V2 文件重寫規劃 Manifest

## 本期目標

建立一組獨立的「平台維運 V2」開發者網站文件規劃包，後續在 `docs/platform-v2/` 重新撰寫新文件。V2 不取代現有「平台維運」頁面；它先以功能域方式重組平台維護者需要的知識與任務路徑，並要求每篇新文件都能追溯到現有來源文件或明確標示待補來源。

## CEO 商務真相摘要

| 項目 | 內容 |
| --- | --- |
| 目標讀者 | AI Hub WebUI 平台維護者、接手開發者、需要理解平台維運功能域的 RD / QE 成員。 |
| 採用情境 | 讀者正在維護 AI Hub 開發者網站與 WebUI 平台，需要理解平台基礎、模型憑證與授權、模型上架、Azure / DB / CI/CD、監控排查與內部規格。 |
| 一句話定位 | 「平台維運 V2」是面向平台維護者的開發者文件區，透過功能域重新撰寫現有平台維運資料，而不是把既有頁面搬家或增補零散章節。 |
| 最低成功標準 | V2 目錄能讓讀者依平台功能域找到該讀的文件；每篇規劃文件都有來源對照、讀者任務、成功條件與不在範圍；未有來源支撐的頁面明確標記待補。 |
| 明確不做 | 不改現有「平台維運」導航；不承諾正式上線切換；不新增工程功能、workflow、API、schema 或 Azure 資源；不把未驗證事實寫成已上線能力。 |
| 外部限制 | 使用者文件需符合 `.github/instructions/user-facing-docs.instructions.md`：先寫讀者要完成什麼、標題可掃描、任務型文件需包含開始條件、步驟、驗證與疑難排解。 |

## CEO Immutable Acceptance Source

本段是 CEO 明確要求的最高驗收來源。PM、RD、QE、FAE 可以依本段建立分項、Page Inventory、施工藍圖與驗證規則，但不得在未取得 CEO 明確同意前壓縮、替換、改名、合併、移除或改變層級。

```text
平台維運
├── 平台基礎
│   ├── 平台維運入口 [S1]
│   ├── 系統與服務架構 [S2]
│   ├── 介面與任務流程 [S3]
│   ├── 資料與正式真相源 [S4] + [S2]
│   └── 平台交付鏈概觀 [S5] + [S6]
├── 模型憑證與授權
│   ├── 總覽 [S8]
│   ├── 授權與權限體系 [S9] + [S4]
│   ├── 授權 Token 流程 [S15]
│   ├── 發布憑證規範 [S16]
│   └── 授權相關維護重點 [S12] + [S8] + [S9]
├── 模型上架與發布
│   ├── 上架總覽 [S10]
│   ├── 容器化規範 [S14]
│   ├── 發布 Callback API [S18]
│   ├── 上架施工規格 [S19]
│   ├── 上架故障排查 [S12] + [S10] + [S18]
│   └── 上架驗證證據 待補
├── 平台資源與資料
│   ├── Azure 資源準備 [S6]
│   ├── 資料備份與還原 [S7]
│   ├── Quota 與用量管理 [S11]
│   ├── 正式資料維護 [S4]
│   └── 機密與設定邊界 [S5] + [S6] + [S2]
├── 平台交付與部署
│   ├── GitHub CI/CD [S5]
│   ├── 部署前提與環境依賴 [S6] + [S5]
│   ├── 部署驗證與健康檢查 [S5] + [S12]
│   ├── 維運監控與故障排查 [S12]
│   └── 回滾與恢復 待補 from [S6]+[S7]+[S12]
└── 規格與內部契約
	├── 規格 Reference 入口 [S13]
	├── 平台內部契約入口 [S17]
	├── Model Card 容器化規範 [S14]
	├── 授權 Token 流程 [S15]
	├── 發布憑證規範 [S16]
	├── 發布 Callback API [S18]
	└── Model Card 上架施工規格 [S19]
```

## IA Fidelity Rules

1. 六大功能域、子頁名稱與巢狀關係不得刪除、壓扁、改名、合併或移到其他層級，除非 CEO 明確同意。
2. Page Inventory 只能由 `CEO Immutable Acceptance Source` 派生，不能反向取代 CEO 指定 IA。
3. 若 PM 需要提出不同頁面數、不同檔名或不同導覽層級，必須新增 `PM proposed mapping`，並在 CEO 同意前保持 blocked。
4. SOP2 開工前，Executor 必須確認每個施工頁面可回追到 CEO 指定節點；無法回追者不得施工。
5. SOP3 驗收時，Validator 必須同時檢查 MkDocs build 與 IA fidelity；MkDocs build 通過不代表 IA 通過。

## 預期效益

1. 平台維護者能用功能域理解平台，而不是在「基礎理解 / 進階維運 / 規格」之間自行拼接脈絡。
2. 每篇 V2 文件都有來源清單與待補來源欄位，避免把現有文件落差或規劃中契約誤寫成現況。
3. 後續 RD / QE / 文件 owner 可依分項規劃重寫文件，不需回對話追溯目錄設計理由。
4. 「模型憑證與授權」既有良好 scope 被保留為範例，其他平台功能域依同樣原則重整。

## 計畫架構圖

```text
平台維運 V2
├── 平台基礎
├── 模型憑證與授權
├── 模型上架與發布
├── 平台資源與資料
├── 平台交付與部署
└── 規格與內部契約
```

來源索引：

| Source ID | 現有來源文件 | 用途 |
| --- | --- | --- |
| S1 | `docs/platform/index.md` | 現有平台維運入口與閱讀順序。 |
| S2 | `docs/platform/repository_architecture.md` | 系統與服務架構、repo 目錄、責任邊界。 |
| S3 | `docs/platform/uxui_architecture.md` | 介面、任務流程與頁面責任。 |
| S4 | `docs/platform/database_schema.md` | 資料表、正式資料真相源、已部署 / 規劃中邊界。 |
| S5 | `docs/platform/github_cicd_workflow.md` | GitHub Actions、OIDC、部署與文件站說明。 |
| S6 | `docs/platform/azure_resources_preparation.md` | Azure 資源、Key Vault、App Service、SQL Database 準備。 |
| S7 | `docs/platform/database_migration.md` | 資料備份、還原、移轉與驗收。 |
| S8 | `docs/platform/advanced/model-credentials-and-authorization.md` | 模型憑證與授權總覽。 |
| S9 | `docs/platform/advanced/authorization-and-access.md` | 授權與權限體系。 |
| S10 | `docs/platform/advanced/model-card-publishing.md` | Model Card 上架維護脈絡。 |
| S11 | `docs/platform/advanced/quota-usage.md` | Quota 與用量管理。 |
| S12 | `docs/platform/advanced/operations-runbook.md` | 監控、故障排查、告警與待補維運能力。 |
| S13 | `docs/platform/reference/index.md` | 規格 Reference 入口。 |
| S14 | `docs/platform/reference/model_card_containerization_standard.md` | Model Card 容器化規範。 |
| S15 | `docs/platform/reference/model_license_token_standard.md` | 授權 token 流程。 |
| S16 | `docs/platform/reference/model_card_publish_grant_standard.md` | 發布憑證規範。 |
| S17 | `docs/platform/internal-contracts/index.md` | 平台內部契約入口。 |
| S18 | `docs/platform/internal-contracts/model_card_publish_callback_api.md` | 發布 Callback API。 |
| S19 | `docs/platform/internal-contracts/model_card_publishing_implementation.md` | Model Card 上架施工規格。 |

## CEO IA to Page Inventory Mapping

本段是由 `CEO Immutable Acceptance Source` 派生的正式施工對照。每一列都必須保留 CEO 指定節點與來源；SOP2 不得跳過、合併或改名，除非 CEO 明確同意。

| CEO IA 節點 | Page ID | 預定路徑 | 對外標題 | 主來源 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| 平台維運 | PV2-ROOT | `docs/platform-v2/index.md` | 平台維運 V2 | S1 | write |
| 平台基礎 / 平台維運入口 | PV2-F01 | `docs/platform-v2/foundation/index.md` | 平台維運入口 | S1 | write |
| 平台基礎 / 系統與服務架構 | PV2-F02 | `docs/platform-v2/foundation/system-service-architecture.md` | 系統與服務架構 | S2 | write |
| 平台基礎 / 介面與任務流程 | PV2-F03 | `docs/platform-v2/foundation/interface-task-flows.md` | 介面與任務流程 | S3 | write |
| 平台基礎 / 資料與正式真相源 | PV2-F04 | `docs/platform-v2/foundation/data-source-of-truth.md` | 資料與正式真相源 | S4 | write |
| 平台基礎 / 平台交付鏈概觀 | PV2-F05 | `docs/platform-v2/foundation/delivery-chain-overview.md` | 平台交付鏈概觀 | S5 | write-with-fact-check |
| 模型憑證與授權 / 總覽 | PV2-A01 | `docs/platform-v2/model-credentials-authorization/index.md` | 總覽 | S8 | write |
| 模型憑證與授權 / 授權與權限體系 | PV2-A02 | `docs/platform-v2/model-credentials-authorization/authorization-access.md` | 授權與權限體系 | S9 | write |
| 模型憑證與授權 / 授權 Token 流程 | PV2-A03 | `docs/platform-v2/model-credentials-authorization/license-token-flow.md` | 授權 Token 流程 | S15 | write |
| 模型憑證與授權 / 發布憑證規範 | PV2-A04 | `docs/platform-v2/model-credentials-authorization/publish-grant-standard.md` | 發布憑證規範 | S16 | write |
| 模型憑證與授權 / 授權相關維護重點 | PV2-A05 | `docs/platform-v2/model-credentials-authorization/maintenance-checkpoints.md` | 授權相關維護重點 | S12 | write-with-known-gaps |
| 模型上架與發布 / 上架總覽 | PV2-P01 | `docs/platform-v2/model-publishing/index.md` | 上架總覽 | S10 | write |
| 模型上架與發布 / 容器化規範 | PV2-P02 | `docs/platform-v2/model-publishing/containerization-standard.md` | 容器化規範 | S14 | write |
| 模型上架與發布 / 發布 Callback API | PV2-P03 | `docs/platform-v2/model-publishing/callback-api.md` | 發布 Callback API | S18 | write |
| 模型上架與發布 / 上架施工規格 | PV2-P04 | `docs/platform-v2/model-publishing/implementation-spec.md` | 上架施工規格 | S19 | write |
| 模型上架與發布 / 上架故障排查 | PV2-P05 | `docs/platform-v2/model-publishing/troubleshooting.md` | 上架故障排查 | S12 | write-with-known-gaps |
| 模型上架與發布 / 上架驗證證據 | PV2-P06 | `docs/platform-v2/model-publishing/verification-evidence.md` | 上架驗證證據 | 待補 | draft-placeholder |
| 平台資源與資料 / Azure 資源準備 | PV2-R01 | `docs/platform-v2/resources-data/azure-resources.md` | Azure 資源準備 | S6 | write-with-fact-check |
| 平台資源與資料 / 資料備份與還原 | PV2-R02 | `docs/platform-v2/resources-data/database-backup-restore.md` | 資料備份與還原 | S7 | write |
| 平台資源與資料 / Quota 與用量管理 | PV2-R03 | `docs/platform-v2/resources-data/quota-usage.md` | Quota 與用量管理 | S11 | write |
| 平台資源與資料 / 正式資料維護 | PV2-R04 | `docs/platform-v2/resources-data/production-data-maintenance.md` | 正式資料維護 | S4 | write |
| 平台資源與資料 / 機密與設定邊界 | PV2-R05 | `docs/platform-v2/resources-data/secrets-configuration-boundary.md` | 機密與設定邊界 | S5 | write-with-fact-check |
| 平台交付與部署 / GitHub CI/CD | PV2-D01 | `docs/platform-v2/delivery-deployment/github-cicd.md` | GitHub CI/CD | S5 | write-with-fact-check |
| 平台交付與部署 / 部署前提與環境依賴 | PV2-D02 | `docs/platform-v2/delivery-deployment/deployment-prerequisites.md` | 部署前提與環境依賴 | S6 | write-with-fact-check |
| 平台交付與部署 / 部署驗證與健康檢查 | PV2-D03 | `docs/platform-v2/delivery-deployment/deployment-verification-health.md` | 部署驗證與健康檢查 | S5 | write-with-known-gaps |
| 平台交付與部署 / 維運監控與故障排查 | PV2-D04 | `docs/platform-v2/delivery-deployment/monitoring-troubleshooting.md` | 維運監控與故障排查 | S12 | write-with-known-gaps |
| 平台交付與部署 / 回滾與恢復 | PV2-D05 | `docs/platform-v2/delivery-deployment/rollback-recovery.md` | 回滾與恢復 | 待補 | draft-placeholder |
| 規格與內部契約 / 規格 Reference 入口 | PV2-C01 | `docs/platform-v2/reference-contracts/index.md` | 規格 Reference 入口 | S13 | write |
| 規格與內部契約 / 平台內部契約入口 | PV2-C02 | `docs/platform-v2/reference-contracts/internal-contracts-index.md` | 平台內部契約入口 | S17 | write |
| 規格與內部契約 / Model Card 容器化規範 | PV2-C03 | `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` | Model Card 容器化規範 | S14 | write |
| 規格與內部契約 / 授權 Token 流程 | PV2-C04 | `docs/platform-v2/reference-contracts/model-license-token-standard.md` | 授權 Token 流程 | S15 | write |
| 規格與內部契約 / 發布憑證規範 | PV2-C05 | `docs/platform-v2/reference-contracts/model-card-publish-grant-standard.md` | 發布憑證規範 | S16 | write |
| 規格與內部契約 / 發布 Callback API | PV2-C06 | `docs/platform-v2/reference-contracts/model-card-publish-callback-api.md` | 發布 Callback API | S18 | write |
| 規格與內部契約 / Model Card 上架施工規格 | PV2-C07 | `docs/platform-v2/reference-contracts/model-card-publishing-implementation.md` | Model Card 上架施工規格 | S19 | write |

## Formal Page Inventory 與寫作契約

Status: approved-for-sop2.

本表已由 CEO 確認為 SOP2 施工契約。SOP2 必須依本表建立或重寫 `docs/platform-v2/` 文件；不得自行新增未列入的頁面、改變文件類型，或把待確認內容寫成已驗證現況。所有頁面必須重新撰寫，不得直接複製既有來源頁。

| Page ID | 預定路徑 | 對外標題 | 文件類型 | 讀者任務 | 主來源 | 輔助來源 | 可宣稱內容 | 必須待確認內容 | 本輪產出狀態 | 驗證方式 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PV2-ROOT | `docs/platform-v2/index.md` | 平台維運 V2 | 任務型 | 判斷平台維運 V2 能協助完成哪些維護任務，並依六大功能域進入下一篇。 | S1 | S2-S19 | V2 依 CEO 指定功能域重寫現有平台維運來源，且與既有平台維運並存。 | V2 是否公開並列於正式網站導覽需 CEO 確認。 | write | 檢查首頁是否列出六大功能域與對應入口。 |
| PV2-F01 | `docs/platform-v2/foundation/index.md` | 平台維運入口 | 任務型 | 先理解平台維運區處理哪些事、哪些主題先讀、哪些是進階維護。 | S1 | S2-S19 | 現有平台維運入口與 V2 閱讀順序。 | 正式公開策略。 | write | 檢查是否承接 root 入口並導向五個平台基礎子頁。 |
| PV2-F02 | `docs/platform-v2/foundation/system-service-architecture.md` | 系統與服務架構 | 概念型 | 理解 App Service、Azure SQL Database、Key Vault、GitHub Actions、Flask app、routes、templates、static 的責任分工。 | S2 | S5, S6 | 來源文件描述的系統與服務責任。 | production 拓撲與資源名稱需確認，不揭露秘密值。 | write | 檢查服務責任是否只來自來源或標待確認。 |
| PV2-F03 | `docs/platform-v2/foundation/interface-task-flows.md` | 介面與任務流程 | 概念型 | 依前台、工作台、平台管理頁理解主要操作路徑與功能落點。 | S3 | S2 | 來源文件描述的 UI/任務流程。 | 實際使用者行為與可用性證據需另補。 | write | 檢查每個流程是否能回追到來源。 |
| PV2-F04 | `docs/platform-v2/foundation/data-source-of-truth.md` | 資料與正式真相源 | 概念型 | 分辨正式資料表、已部署真相源與規劃中契約。 | S4 | S2 | 來源文件描述的資料表、關聯與真相源邊界。 | production DB 狀態與敏感資源名稱需確認。 | write | 檢查已部署 / 規劃中 / 待確認三類標示。 |
| PV2-F05 | `docs/platform-v2/foundation/delivery-chain-overview.md` | 平台交付鏈概觀 | 概念型 | 理解程式如何進入測試、部署、文件發布與環境驗證。 | S5 | S6 | 來源文件宣稱的交付鏈與 Azure 依賴。 | workflow、OIDC、Pages 與 production deployment 實況需 QE 驗證。 | write-with-fact-check | 檢查文件是否區分來源宣稱與已驗證現況。 |
| PV2-A01 | `docs/platform-v2/model-credentials-authorization/index.md` | 總覽 | 概念型 | 先定義模型憑證與授權物件、使用者與平台消費節點。 | S8 | S9, S15, S16 | 現有模型憑證與授權概念。 | 正式授權成熟度與安全驗證證據。 | write | 檢查是否導向授權、token、發布憑證與維護頁。 |
| PV2-A02 | `docs/platform-v2/model-credentials-authorization/authorization-access.md` | 授權與權限體系 | 概念型 | 理解帳號角色、資源可見性、權限判斷與管理責任。 | S9 | S4 | 來源文件描述的授權與權限邊界。 | production 權限資料與安全驗證證據。 | write | 檢查角色與資料來源是否可追溯。 |
| PV2-A03 | `docs/platform-v2/model-credentials-authorization/license-token-flow.md` | 授權 Token 流程 | 參考型 | 查 token 流程、欄位、驗證與失敗情境。 | S15 | S8, S9 | 來源規格中的 token 流程與欄位語意。 | 實際部署驗證與安全測試證據。 | write | 檢查欄位定義與來源一致。 |
| PV2-A04 | `docs/platform-v2/model-credentials-authorization/publish-grant-standard.md` | 發布憑證規範 | 參考型 | 查發布憑證欄位、用途、驗證依據與平台檢查點。 | S16 | S8 | 來源規格中的 publish grant 概念。 | 正式核發流程與安全驗證證據。 | write | 檢查不新增未來源支撐欄位。 |
| PV2-A05 | `docs/platform-v2/model-credentials-authorization/maintenance-checkpoints.md` | 授權相關維護重點 | 任務型 | 維護時檢查授權狀態並定位常見錯誤。 | S12 | S8, S9 | 來源 runbook 與授權文件可支撐的維護重點。 | 正式告警、監控與事故流程需補。 | write-with-known-gaps | 檢查故障排查內容是否標示待補。 |
| PV2-P01 | `docs/platform-v2/model-publishing/index.md` | 上架總覽 | 任務型 | 理解 Model Card 上架流程、主要狀態與維護者檢查點。 | S10 | S14, S18, S19 | 來源文件中的上架脈絡。 | 上架驗證證據與 callback deployment 狀態。 | write | 檢查是否導向容器化、callback、施工規格、排查與驗證頁。 |
| PV2-P02 | `docs/platform-v2/model-publishing/containerization-standard.md` | 容器化規範 | 參考型 | 查 Model Card 容器交付結構、欄位與交付要求。 | S14 | S10 | 來源規格中的容器化要求。 | 實際驗收證據。 | write | 檢查規格欄位與來源一致。 |
| PV2-P03 | `docs/platform-v2/model-publishing/callback-api.md` | 發布 Callback API | 參考型 | 查外部發布流程回報平台狀態的欄位與事件。 | S18 | S10, S19 | 來源契約中的 callback API。 | 實際部署與安全驗證證據。 | write | 檢查 API 契約不新增未驗證項目。 |
| PV2-P04 | `docs/platform-v2/model-publishing/implementation-spec.md` | 上架施工規格 | 參考型 | 查上架功能的工程契約、狀態機與實作依據。 | S19 | S10, S18 | 來源施工規格中的狀態與工程契約。 | 是否對外公開需 CEO 確認。 | write | 檢查內部契約不包裝成對外承諾。 |
| PV2-P05 | `docs/platform-v2/model-publishing/troubleshooting.md` | 上架故障排查 | 任務型 | 上架卡住、callback 失敗、artifact 驗證失敗時收斂問題。 | S12 | S10, S18 | 來源支撐的已知排查路徑。 | 完整 runbook、告警與 incident response 待補。 | write-with-known-gaps | 檢查每個排查步驟有來源或待補。 |
| PV2-P06 | `docs/platform-v2/model-publishing/verification-evidence.md` | 上架驗證證據 | 任務型 | 確認平台如何判定一次上架成功。 | 待補 | S10, S14, S18, S19 | 僅可列出待補證據需求。 | 正式驗證證據需 RD/QE 補。 | draft-placeholder | 檢查不得宣稱已完成驗收。 |
| PV2-R01 | `docs/platform-v2/resources-data/azure-resources.md` | Azure 資源準備 | 任務型 | 理解平台依賴哪些 Azure 資源、重建環境時要確認什麼。 | S6 | S2, S5 | 來源文件中的 Azure 資源準備事項。 | 實際 subscription/resource group/name 需確認，不揭露秘密值。 | write-with-fact-check | 檢查敏感資訊未外洩且狀態標示清楚。 |
| PV2-R02 | `docs/platform-v2/resources-data/database-backup-restore.md` | 資料備份與還原 | 任務型 | 執行或理解 Azure SQL Database 備份、搬遷、還原與驗收流程。 | S7 | S4 | 來源文件中的備份還原與驗收概念。 | production 執行證據與權限流程需確認。 | write | 檢查步驟與驗證結果只寫來源可支撐內容。 |
| PV2-R03 | `docs/platform-v2/resources-data/quota-usage.md` | Quota 與用量管理 | 概念型 | 理解平台用量、配額、統計與相關異常。 | S11 | S4 | 來源文件中的 quota 與用量管理概念。 | 實際配額值、監控指標與告警門檻。 | write | 檢查無來源數值不得新增。 |
| PV2-R04 | `docs/platform-v2/resources-data/production-data-maintenance.md` | 正式資料維護 | 任務型 | 判斷哪些表支撐哪些功能，資料異常時看哪些表與關聯。 | S4 | S2 | 來源文件中的資料表責任與關聯。 | production DB 狀態與資料修復 SOP。 | write | 檢查表責任與狀態邊界清楚。 |
| PV2-R05 | `docs/platform-v2/resources-data/secrets-configuration-boundary.md` | 機密與設定邊界 | 概念型 | 理解 Key Vault、GitHub Variables、App Settings 與正式環境設定責任邊界。 | S5 | S6, S2 | 來源文件中的機密與設定邊界。 | 實際 secret 名稱與值不得揭露；production 設定需確認。 | write-with-fact-check | 檢查文件只描述邊界與引用來源。 |
| PV2-D01 | `docs/platform-v2/delivery-deployment/github-cicd.md` | GitHub CI/CD | 任務型 | 理解 workflow、OIDC、部署 job、文件站發布與驗證方式。 | S5 | S6 | 來源文件宣稱的 CI/CD 與 Pages 流程。 | repo workflow 實況、OIDC 與 Pages 設定需 QE 驗證。 | write-with-fact-check | 檢查不存在的 workflow 不得寫成現況。 |
| PV2-D02 | `docs/platform-v2/delivery-deployment/deployment-prerequisites.md` | 部署前提與環境依賴 | 任務型 | 檢查 Azure 資源、GitHub Secrets / Variables、Key Vault 與 App Service 前提。 | S6 | S5 | 來源文件中的部署前提。 | production 環境依賴與權限需確認。 | write-with-fact-check | 檢查前提分為已知、來源宣稱、待確認。 |
| PV2-D03 | `docs/platform-v2/delivery-deployment/deployment-verification-health.md` | 部署驗證與健康檢查 | 任務型 | 用 health check、API 與 deployment report 判斷最低上線成功標準。 | S5 | S12 | 來源文件提到的部署驗證訊號。 | 正式驗證指標與證據需 QE 補。 | write-with-known-gaps | 檢查不得宣稱 release ready。 |
| PV2-D04 | `docs/platform-v2/delivery-deployment/monitoring-troubleshooting.md` | 維運監控與故障排查 | 任務型 | 找到日常監控訊號、常見異常與收斂入口。 | S12 | S5, S6 | 來源文件中的監控與排查能力。 | 正式監控、告警、incident response 狀態需補。 | write-with-known-gaps | 檢查每個能力標示已知或待補。 |
| PV2-D05 | `docs/platform-v2/delivery-deployment/rollback-recovery.md` | 回滾與恢復 | 任務型 | 建立未來 rollback / restore / 重建環境的閱讀入口。 | 待補 | S6, S7, S12 | 僅可列待補能力與來源缺口。 | 正式回滾與恢復 SOP 需 SRE/QE/CEO 補。 | draft-placeholder | 檢查不得寫成完整 runbook。 |
| PV2-C01 | `docs/platform-v2/reference-contracts/index.md` | 規格 Reference 入口 | 概念型 | 判斷何時進規格區查對照。 | S13 | S14-S16 | 來源 reference 入口與規格分類。 | 對外公開範圍需 CEO 確認。 | write | 檢查導向所有 reference 子頁。 |
| PV2-C02 | `docs/platform-v2/reference-contracts/internal-contracts-index.md` | 平台內部契約入口 | 概念型 | 判斷何時進工程契約區查實作依據。 | S17 | S18, S19 | 來源 internal contracts 入口。 | 對外公開範圍需 CEO 確認。 | write | 檢查不把內部契約寫成對外承諾。 |
| PV2-C03 | `docs/platform-v2/reference-contracts/model-card-containerization-standard.md` | Model Card 容器化規範 | 參考型 | 查 Model Card 容器化規格。 | S14 | S10 | 來源規格內容。 | 實際驗收證據。 | write | 檢查欄位與來源一致。 |
| PV2-C04 | `docs/platform-v2/reference-contracts/model-license-token-standard.md` | 授權 Token 流程 | 參考型 | 查 token 規格。 | S15 | S8, S9 | 來源規格內容。 | 安全驗證證據。 | write | 檢查欄位與來源一致。 |
| PV2-C05 | `docs/platform-v2/reference-contracts/model-card-publish-grant-standard.md` | 發布憑證規範 | 參考型 | 查 publish grant 規格。 | S16 | S8 | 來源規格內容。 | 正式核發流程。 | write | 檢查欄位與來源一致。 |
| PV2-C06 | `docs/platform-v2/reference-contracts/model-card-publish-callback-api.md` | 發布 Callback API | 參考型 | 查 callback 契約。 | S18 | S10, S19 | 來源契約內容。 | 實際部署與安全驗證證據。 | write | 檢查契約與來源一致。 |
| PV2-C07 | `docs/platform-v2/reference-contracts/model-card-publishing-implementation.md` | Model Card 上架施工規格 | 參考型 | 查上架工程契約。 | S19 | S10, S18 | 來源施工規格內容。 | 對外公開範圍需 CEO 確認。 | write | 檢查不新增未驗證工程承諾。 |

## 分項索引表

下列分項檔仍保留先前 SOP2 執行紀錄，但其 `confirmed` 簽核只能作為歷史證據，不得覆蓋本 manifest 中新的 `CEO IA to Page Inventory Mapping` 與 `Formal Page Inventory 與寫作契約`。待 CEO 確認 mapping 後，下一輪 SOP2 必須以本 manifest 為最高施工契約，再回寫各分項檔的查核點狀態。

| Subitem ID | 分項名稱 | Owner | Depends On | Resource Level | Blueprint File | Planned Workorder File | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| POV2-01 | 導覽與來源治理 | product-strategy-manager | none | Medium | `2026-06-30-navigation-and-source-governance.md` | `.github/issues/platform-operations-v2-navigation-workorder.md` | pending-ceo-mapping-review |
| POV2-02 | 平台基礎 | product-strategy-manager | POV2-01 | Medium | `2026-06-30-platform-foundation.md` | `.github/issues/platform-operations-v2-platform-foundation-workorder.md` | pending-ceo-mapping-review |
| POV2-03 | 模型憑證與授權 | product-strategy-manager | POV2-01 | Medium | `2026-06-30-model-credentials-and-authorization.md` | `.github/issues/platform-operations-v2-model-credentials-workorder.md` | pending-ceo-mapping-review |
| POV2-04 | 模型上架與發布 | product-strategy-manager | POV2-01, POV2-03 | Medium | `2026-06-30-model-card-publishing.md` | `.github/issues/platform-operations-v2-model-card-publishing-workorder.md` | pending-ceo-mapping-review |
| POV2-05 | 平台資源與資料 | product-strategy-manager | POV2-01, POV2-02 | Medium | `2026-06-30-platform-resources-and-data.md` | `.github/issues/platform-operations-v2-resources-data-workorder.md` | pending-ceo-mapping-review |
| POV2-06 | 平台交付與部署 | product-strategy-manager | POV2-01, POV2-02, POV2-05 | Medium | `2026-06-30-platform-delivery-and-deployment.md` | `.github/issues/platform-operations-v2-delivery-deployment-workorder.md` | pending-ceo-mapping-review |
| POV2-07 | 規格與內部契約 | product-strategy-manager | POV2-01, POV2-03, POV2-04 | Medium | `2026-06-30-reference-and-internal-contracts.md` | `.github/issues/platform-operations-v2-reference-contracts-workorder.md` | pending-ceo-mapping-review |

## Page Inventory 與寫作契約

Status: invalid; superseded by `CEO Immutable Acceptance Source` after SOP3 FAE review. The table below is retained as failure evidence only and must not be used as the SOP2 construction contract.

原因：下表將 CEO 指定的六大功能域巢狀 IA 壓縮為 9 頁 flat Page Inventory，未取得 CEO 同意，違反 `IA Fidelity Rules`。下一輪必須先建立 CEO IA 到 Page Inventory 的逐項 mapping，才能重新進入 SOP2。

SOP2 不得再依下表建立或重寫 `docs/platform-v2/` 文件；不得自行新增未列入的頁面、改變文件類型，或把待確認內容寫成已驗證現況。

| Page ID | 預定路徑 | 對外標題 | 文件類型 | 讀者任務 | 主來源 | 輔助來源 | 可宣稱內容 | 必須待確認內容 | 本輪產出狀態 | 驗證方式 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| LEGACY-PV2-P01 | `docs/platform-v2/index.md` | 入口 | 任務型 | 先判斷平台維運 V2 可協助完成哪些維護任務，並選擇下一篇文件。 | S1 | S2-S19 | V2 依平台功能域重寫現有平台維運來源，且與既有平台維運並存。 | V2 是否公開並列於正式網站導覽需 CEO 確認。 | write | 檢查首頁是否說明讀者任務、開始條件、入口與待確認邊界。 |
| LEGACY-PV2-P02 | `docs/platform-v2/operating-map.md` | 維運任務地圖 | 概念型 | 用平台功能域理解維護者在憑證、上架、資源、交付、資料與排查之間的閱讀路徑。 | S1 | S2, S3, S8-S12 | 六個功能域與來源文件的關係。 | 不宣稱 production workflow、Azure 資源或監控狀態已驗證。 | write | 檢查每個功能域是否能回追到來源 ID 或待補標記。 |
| LEGACY-PV2-P03 | `docs/platform-v2/model-credentials-and-authorization.md` | 模型憑證與授權 | 概念型 | 理解模型授權、token、publish grant 與平台權限邊界。 | S8 | S9, S15, S16 | 現有來源描述的授權模型、token 流程與發布憑證概念。 | 正式授權成熟度、實際 production 憑證發放流程與安全驗證證據。 | write | 檢查授權宣稱是否只來自 S8/S9/S15/S16，待確認項目是否標明。 |
| LEGACY-PV2-P04 | `docs/platform-v2/model-card-publishing.md` | Model Card 上架維運 | 任務型 | 維護 Model Card 上架流程、容器化規格、callback 與上架異常排查入口。 | S10 | S14, S18, S19 | 來源文件中的上架流程、容器化要求、callback API 與施工規格。 | 上架驗證證據不足時不得寫成已完成驗收；實際 callback deployment 狀態需 RD/QE 確認。 | write-with-known-gaps | 檢查頁面是否包含來源限制與待補驗證證據標記。 |
| LEGACY-PV2-P05 | `docs/platform-v2/azure-environment-and-cicd.md` | Azure 環境與 CI/CD | 任務型 | 了解 Azure 資源準備、GitHub Actions、OIDC、Pages 與部署前置條件。 | S5 | S6 | 來源文件宣稱的 Azure / CI/CD / Pages 準備事項。 | workflow、script、production deployment、OIDC 設定與 Pages 實況需 repo / QE 驗證；不存在的 workflow 不得寫成現況。 | write-with-fact-check | 檢查文件是否列出已驗證、來源宣稱與待確認三種狀態。 |
| LEGACY-PV2-P06 | `docs/platform-v2/database-and-migration.md` | 資料庫與移轉 | 任務型 | 理解正式資料真相源、資料表責任、備份還原與 migration 驗收。 | S4 | S7 | 來源文件描述的資料表、Azure SQL Database、migration 與驗收概念。 | production database 狀態、實際 migration 執行證據與敏感資源名稱需 CEO/RD/QE 確認。 | write | 檢查是否避免揭露秘密值，且 migration 驗證只寫來源可支撐內容。 |
| LEGACY-PV2-P07 | `docs/platform-v2/quota-and-usage.md` | Quota 與用量 | 概念型 | 理解平台 quota、用量管理與維護者需要觀察的資料邊界。 | S11 | S4 | 來源文件中的 quota 與用量管理概念。 | 實際配額值、監控指標、告警門檻與 production 資料需確認。 | write | 檢查數值型宣稱是否有來源；無來源數值不得新增。 |
| LEGACY-PV2-P08 | `docs/platform-v2/monitoring-and-troubleshooting.md` | 監控與故障排查 | 任務型 | 依已知 runbook 找到監控、排查、告警與待補維運能力。 | S12 | S5, S6, S7 | 來源文件中已列出的監控、故障排查與待補維運能力。 | 回滾與恢復來源不足；正式監控、告警、incident response 狀態需 SRE/QE/CEO 補來源。 | draft-placeholder | 只建立可追溯骨架與待補標記；不得寫成完整 runbook。 |
| LEGACY-PV2-P09 | `docs/platform-v2/release-gate.md` | 發布檢查與證據 | 任務型 | 在 V2 文件交付前確認來源、事實、驗證證據與待補項目。 | S5 | S10, S12, S14-S19 | 可列出本輪文件的檢查項與證據需求。 | 上架驗證證據、回滾與恢復、production CI/CD 真相未補前不得宣稱 release ready。 | draft-placeholder | 檢查頁面只作為待補證據清單，不包裝成已完成驗收。 |

## 規劃凍結線

0. `CEO Immutable Acceptance Source` 是本 initiative 的最高驗收來源；任何 Page Inventory、分項規劃檔、施工藍圖與驗證結果若與其不一致，必須先回 SOP1 修正或取得 CEO 同意。
1. 「平台維運 V2」是新文件區，規劃目標是重寫 `docs/platform-v2/`，不得直接改掉現有「平台維運」文件區。
2. 每篇 V2 文件必須參考來源文件重新撰寫，不得直接複製舊頁內容當成成品。
3. 所有已上線能力、規劃中契約、待補來源必須在文件中明確區分。
4. 文件語氣面向平台維護者與接手開發者，不使用 CEO / PM / RD / QE 內部交接語作為對外內容。
5. PM 僅凍結讀者任務、成功路徑、來源契約、範圍與 blocking gate；RD / QE 後續補 architecture facts 與 verification evidence，不由 PM 宣稱未驗證事實。
6. 不新增依賴、不新增 Azure 服務、不承諾時程、不承諾正式發布日期。

## CEO 待提供資源

| 項目 | 需要 CEO 提供的內容 | Blocking Gate |
| --- | --- | --- |
| 正式發布策略 | 是否允許 V2 與現有平台維運頁並列於網站導覽，或先以 draft / hidden docs 形式驗證。 | V2 導覽上線前需確認。 |
| 現況真相確認 | 對 CI/CD、Pages、workflow、Azure 資源與 production 狀態的正式現況確認。 | 文件不得把未驗證項目寫成現況。 |
| 待補來源優先序 | 對「上架驗證證據」與「回滾與恢復」兩個待補頁是否納入本輪寫作的裁決。 | 若未提供，兩頁只能保留待補標記。 |

## SOP2 進入判定

Status: in-sop2.

本 blueprint 不得依目前 9 頁 flat Page Inventory 重新進入 SOP2。CEO 已確認 `CEO IA to Page Inventory Mapping` 與 `Formal Page Inventory 與寫作契約`，並核准開始改正式文件與網站導覽。

後續 RD/QE 依 Formal Page Inventory 施工與驗證。若 CEO 要調整頁名、路徑、頁面數或分組，本 manifest 必須先回 SOP1 更新 mapping，不得直接改 SOP2 成品。