# Platform Operations V2 navigation mismatch work order

- Work Order ID: POV2-NAV-2026-06-30
- Date: 2026-06-30
- Stream ID: platform-operations-docs-overhaul
- Source Blueprint File: `.github/blueprint/platform-operations-docs-overhaul/2026-06-30-navigation-and-source-governance.md`
- Source Checkpoint IDs: POV2-01-CP1, POV2-01-CP2, POV2-01-CP3
- Current Stage: PM closure summary pending
- Next Owner: product-strategy-manager

## Issue Classification

| Field | Value |
| --- | --- |
| Type | docs / information architecture mismatch |
| Reported by | CEO / platform maintainer review |
| FAE status | reproduced |
| Severity | blocking for Platform Operations V2 release readiness |
| Affected surface | `mkdocs.yml`, `docs/platform-v2/`, Platform Operations V2 blueprint package |
| Feedback routing | Product repo issue; not HR runtime feedback. |

## Objective and Scope

Track the mismatch between the intended Platform Operations V2 Pages structure and the structure produced during SOP2.

The user-provided target is a six-domain navigation tree with nested pages. The implemented V2 Pages structure is a nine-page flat navigation section. This issue records the gap and freezes the actual target structure for the next PM/RD/QE pass.

In scope:

1. Record the reproduced mismatch.
2. Preserve the target Pages structure requested by the CEO.
3. Assign follow-up owners and acceptance gates.
4. Prevent closing Platform Operations V2 as release-ready until navigation and page inventory match the requested structure or CEO explicitly approves a different structure.

Out of scope:

1. Do not rewrite the V2 documents in this issue.
2. Do not change `mkdocs.yml` in this issue.
3. Do not declare the current flat V2 structure acceptable.
4. Do not promise schedule or release date.

## Frozen Input Contract

### Reproduction Evidence

Current `mkdocs.yml` contains a flat Platform Operations V2 section:

```yaml
平台維運 V2:
  - 入口: platform-v2/index.md
  - 維運任務地圖: platform-v2/operating-map.md
  - 模型憑證與授權: platform-v2/model-credentials-and-authorization.md
  - Model Card 上架維運: platform-v2/model-card-publishing.md
  - Azure 環境與 CI/CD: platform-v2/azure-environment-and-cicd.md
  - 資料庫與移轉: platform-v2/database-and-migration.md
  - Quota 與用量: platform-v2/quota-and-usage.md
  - 監控與故障排查: platform-v2/monitoring-and-troubleshooting.md
  - 發布檢查與證據: platform-v2/release-gate.md
```

The frozen blueprint already stated that the V2 directory architecture input must preserve six functional domains, but the manifest Page Inventory collapsed the output into nine flat pages. Therefore, the issue is not only a MkDocs nav problem; it is a blueprint-to-execution drift problem.

### Target Pages Structure

The following is the requested Platform Operations V2 structure. Future SOP1/SOP2 repair must use this as the target unless CEO explicitly replaces it.

```text
平台維運
├── 平台基礎
│   # 用途：讓維護者先建立平台整體心智模型，理解平台是什麼、怎麼組成、資料與交付邊界在哪裡
│   ├── 平台維運入口
│   │   # 內容：平台維運區要處理哪些事、哪些主題先讀、哪些主題是進階維護才需要進入
│   │   # 來源：[S1]
│   ├── 系統與服務架構
│   │   # 內容：App Service、Azure SQL Database、Key Vault、GitHub Actions、Flask app、routes、templates、static 的責任分工
│   │   # 來源：[S2]
│   ├── 介面與任務流程
│   │   # 內容：前台、工作台、平台管理頁的資訊架構與主要操作路徑，幫助維護者判斷功能落點
│   │   # 來源：[S3]
│   ├── 資料與正式真相源
│   │   # 內容：正式資料表、關聯、哪些資料屬已部署真相源、哪些只是規劃中契約
│   │   # 來源：[S4] + [S2]
│   └── 平台交付鏈概觀
│       # 內容：程式如何進入測試、部署、文件發布與環境驗證；目前有哪些 workflow 與 Azure 依賴
│       # 來源：[S5] + [S6]
│
├── 模型憑證與授權
│   # 用途：整理模型相關的授權、憑證、權限與角色邊界，這是目前最成熟、最像完整功能域的一組文件
│   ├── 總覽
│   │   # 內容：先定義有哪些憑證與授權物件、誰會使用、平台在哪些節點消費這些資料
│   │   # 來源：[S8]
│   ├── 授權與權限體系
│   │   # 內容：帳號角色、資源可見性、權限判斷、存取邊界與管理責任
│   │   # 來源：[S9] + [S4]
│   ├── 授權 Token 流程
│   │   # 內容：token 的流程、欄位、驗證與失敗情境，作為授權鏈的規格頁
│   │   # 來源：[S15]
│   ├── 發布憑證規範
│   │   # 內容：模型發布憑證的欄位、用途、驗證依據與平台檢查點
│   │   # 來源：[S16]
│   └── 授權相關維護重點
│       # 內容：日常維護時要檢查哪些授權狀態、常見錯誤從哪裡看
│       # 來源：[S12] + [S8] + [S9]
│
├── 模型上架與發布
│   # 用途：收斂 Model Card 從封裝、提交、回報、審核到平台接收的完整維護主題
│   ├── 上架總覽
│   │   # 內容：平台如何看待 Model Card 上架流程、主要狀態、平台維護者要關心的檢查點
│   │   # 來源：[S10]
│   ├── 容器化規範
│   │   # 內容：Model Card 封裝成容器時必須符合的結構、欄位與交付要求
│   │   # 來源：[S14]
│   ├── 發布 Callback API
│   │   # 內容：外部發布流程如何把狀態回報給平台、平台要接受哪些欄位與事件
│   │   # 來源：[S18]
│   ├── 上架施工規格
│   │   # 內容：上架功能的內部工程契約、狀態機與平台實作依據
│   │   # 來源：[S19]
│   ├── 上架故障排查
│   │   # 內容：上架卡住、callback 失敗、artifact 驗證失敗時怎麼判讀
│   │   # 來源：[S12] + [S10] + [S18]
│   └── 上架驗證證據
│       # 內容：待補；建議未來整理「平台如何判定一次上架成功」的驗證頁
│       # 來源：待補
│
├── 平台資源與資料
│   # 用途：整理支撐平台運作的 Azure 資源、正式資料、備份還原與用量管理
│   ├── Azure 資源準備
│   │   # 內容：平台依賴哪些 Azure 資源、命名與對應關係、重建環境時要確認什麼
│   │   # 來源：[S6]
│   ├── 資料備份與還原
│   │   # 內容：Azure SQL Database 備份、搬遷、還原與驗收流程
│   │   # 來源：[S7]
│   ├── Quota 與用量管理
│   │   # 內容：平台如何管理用量、配額、統計與相關異常
│   │   # 來源：[S11]
│   ├── 正式資料維護
│   │   # 內容：哪些表支撐哪些功能、資料異常時應該看哪些表與關聯
│   │   # 來源：[S4]
│   └── 機密與設定邊界
│       # 內容：Key Vault、GitHub Variables、App Settings 與正式環境設定的責任邊界
│       # 來源：[S5] + [S6] + [S2]
│
├── 平台交付與部署
│   # 用途：整理平台從原始碼到正式環境的建置、部署、驗證與故障排查
│   ├── GitHub CI/CD
│   │   # 內容：workflow、OIDC、部署 job、文件站發布、驗證方式
│   │   # 來源：[S5]
│   ├── 部署前提與環境依賴
│   │   # 內容：Azure 資源、GitHub Secrets / Variables、Key Vault 與 App Service 之間的前提關係
│   │   # 來源：[S6] + [S5]
│   ├── 部署驗證與健康檢查
│   │   # 內容：/healthz、/api/model-cards、deployment report 與成功上線最低標準
│   │   # 來源：[S5] + [S12]
│   ├── 維運監控與故障排查
│   │   # 內容：日常要看哪些訊號、常見異常有哪些、先從哪裡開始收斂
│   │   # 來源：[S12]
│   └── 回滾與恢復
│       # 內容：待補；目前文件只有零散提到 rollback / restore / 重建，尚未形成獨立頁
│       # 來源：待補（可由 [S6] + [S7] + [S12] 補齊）
│
└── 規格與內部契約
    # 用途：集中放查規格與查內部工程契約的深水區頁面，不作為第一入口，但維護時要能快速找到
    ├── 規格 Reference 入口
    │   # 內容：規格頁總覽，告訴維護者何時該進規格區查對照
    │   # 來源：[S13]
    ├── 平台內部契約入口
    │   # 內容：內部工程契約總覽，告訴維護者何時該進工程契約區查實作依據
    │   # 來源：[S17]
    ├── Model Card 容器化規範
    │   # 內容：容器化規格頁
    │   # 來源：[S14]
    ├── 授權 Token 流程
    │   # 內容：token 規格頁
    │   # 來源：[S15]
    ├── 發布憑證規範
    │   # 內容：publish grant 規格頁
    │   # 來源：[S16]
    ├── 發布 Callback API
    │   # 內容：callback 契約頁
    │   # 來源：[S18]
    └── Model Card 上架施工規格
        # 內容：上架工程契約頁
        # 來源：[S19]
```

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-01-CP1 | V2 reader contract | 明確列出讀者、任務、成功條件、不在範圍。 | 避免 V2 變成舊文件搬家。 | 依 PM 與 user-facing docs 指令撰寫 reader contract。 | QE 檢查首頁是否能回答讀者要完成什麼。 | `docs/platform-v2/index.md` |
| POV2-01-CP2 | Source governance | 每篇 V2 頁面都有來源或待補標記。 | 防止未驗證內容被包裝成現況。 | 建立來源對照與頁面 front matter / 章節規則。 | 抽查頁面來源是否可回到 S1-S19。 | `docs/platform-v2/index.md`、各 V2 頁 |
| POV2-01-CP3 | Navigation scope | V2 導覽與現有平台維運導覽並存，不取代現有頁。 | 降低破壞性變更風險。 | 規劃 V2 nav 草案與上線邊界。 | 檢查 `mkdocs.yml` 變更是否只新增 V2 區。 | `mkdocs.yml` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-01-CP1 | confirmed | confirmed | confirmed | V2 reader contract, first-day handoff checklist, and six-domain entry path now exist; QE re-verification passed. |
| POV2-01-CP2 | confirmed | confirmed | confirmed | V2 pages now include runbook evidence, readiness inventory, deployment gates, monitoring triage, rollback path, and DB restore gate; QE re-verification passed. |
| POV2-01-CP3 | confirmed | confirmed | confirmed | `mkdocs.yml` preserves the requested six-domain nested V2 nav; MkDocs strict build passed and QE re-verification passed. |

## Verification Evidence

| Evidence ID | Evidence | Result |
| --- | --- | --- |
| E1 | `mkdocs.yml` current Platform Operations V2 nav inspection. | Reproduced flat 9-page nav. |
| E2 | `.github/blueprint/platform-operations-docs-overhaul/2026-06-30-navigation-and-source-governance.md` frozen input contract. | States six functional domains must be preserved. |
| E3 | `.github/blueprint/platform-operations-docs-overhaul/00-manifest.md` Page Inventory. | Shows collapsed 9-page inventory that caused execution drift. |
| E4 | `mkdocs.yml` Platform Operations V2 nav after repair. | Six-domain nested nav is present under `平台維運 V2`. |
| E5 | `docs/platform-v2/foundation/index.md`. | Adds first-day platform maintainer checklist with repo, Actions, Azure, Key Vault, deployment report, health, and DB evidence. |
| E6 | `docs/platform-v2/delivery-deployment/deployment-prerequisites.md`. | Adds redacted GitHub Secrets, GitHub Variables, Key Vault secret names, App Settings, and Deployment job inventory. |
| E7 | `docs/platform-v2/delivery-deployment/deployment-verification-health.md`. | Adds executable deployment checklist for jobs, `deployment-report`, `/healthz`, `/readyz/db`, `/api/model-cards`, `/api/hardware-atlas`, and hardware detail page. |
| E8 | `docs/platform-v2/delivery-deployment/monitoring-troubleshooting.md`. | Adds first 15-minute triage flow and required evidence format. |
| E9 | `docs/platform-v2/delivery-deployment/rollback-recovery.md`. | Replaces placeholder with recovery runbook, recovery path matrix, stop conditions, and post-recovery record format. |
| E10 | `docs/platform-v2/resources-data/database-backup-restore.md`. | Adds formal data protection gates, export/import command templates, count checks, and expanded app-layer validation. |
| E11 | `python -m mkdocs build --clean --strict`. | Passed after runbook and evidence updates; remaining nav warning is unrelated `model-provider/deploy-usability-test-protocol.md`. |
| E12 | `docs/platform-v2/resources-data/azure-resources.md`. | Adds resource readiness matrix and points complete secret / setting / workflow inventory to deployment prerequisites. |
| E13 | `docs/platform-v2/delivery-deployment/deployment-verification-health.md`. | Adds PowerShell endpoint re-check templates for health, DB readiness, catalog, hardware atlas, and hardware detail markers. |

## Blockers and Gate Status

| Gate | Status | Owner | Required Action |
| --- | --- | --- | --- |
| Target IA alignment | pass | product-strategy-manager | Six-domain target tree is implemented in `mkdocs.yml`. |
| Page inventory completeness | pass | product-strategy-manager | Formal V2 page inventory is represented under `docs/platform-v2/`. |
| Docs implementation | pass | senior-software-engineer | Runbook and evidence gaps identified by QE cold-start review have been patched. |
| Verification | pass | testing-quality-engineer | QE re-verification found original blockers lifted; remaining documentation improvements were patched as E12 and E13. |
| Release readiness | pending | product-strategy-manager | Prepare PM closure summary and final go / no-go recommendation for Platform Operations V2 publication. |

## Closure Recommendation

FAE recommendation: ready for PM closure review after QE re-verification.

The original navigation mismatch and cold-start runbook blockers have been repaired. V2 now preserves the CEO-requested six-domain structure, includes runbook evidence for first-day handoff, deployment readiness, deployment verification, monitoring triage, rollback / recovery, and DB backup / restore. Remaining release decision belongs to PM closure summary.

## PM Closure Summary

Pending PM closure summary.

Minimum PM closure content required before this issue can close:

1. Confirm the implemented six-domain structure is the release target.
2. Confirm QE re-verification evidence E4-E13 is sufficient for closure.
3. Record any non-blocking follow-up work separately from this IA mismatch issue.
4. Define go/no-go recommendation for Platform Operations V2 publication.
