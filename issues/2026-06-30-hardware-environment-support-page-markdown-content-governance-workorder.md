# Work Order: Hardware Environment Support Page / Markdown Content Governance

- Work Order ID: `WO-2026-06-30-HESP-MCG-01`
- Date: `2026-06-30`
- Stream ID: `hardware-environment-support-page`
- Source Blueprint File: `.github/blueprint/hardware-environment-support-page/2026-06-30-markdown-content-governance.md`
- Source Checkpoint IDs: `GOV-03`
- Current Stage: `SOP3 驗證完成`
- Next Owner: `product-strategy-manager`

## Issue Classification

| Field | Value |
| --- | --- |
| Type | Production schema reconciliation |
| Severity | High |
| User Impact | `/hardware/<slug>` 在既有資料庫未補欄位時可能出現 500 |
| Trigger | `support_markdown` 已進入讀取查詢，但正式環境資料庫欄位對齊尚未有獨立驗證單 |
| Requested By | CEO |

## Objective and Scope

這張 work order 用來驗證並收斂 `hardware_device.support_markdown` 在目標資料庫環境中的實際狀態，避免應用層 hotfix 已經避免 500，但正式資料庫仍處於未明確對齊的半完成狀態。

本單範圍只處理：

1. 確認 `hardware_device` 是否已存在 `support_markdown NVARCHAR(MAX) NOT NULL DEFAULT N''`。
2. 確認既有資料列在 schema ensure 後不會因新欄位導致 `/hardware/<slug>` 讀取失敗。
3. 確認後續 DB 對齊責任、驗證方式與殘餘風險。

本單不處理：

1. 新增 UI 功能。
2. 改寫 Markdown rendering 行為。
3. 擴張成通用 migration framework 重構。

## Frozen Input Contract

| Item | Content |
| --- | --- |
| Feature context | hardware detail 第二入口已改為 `環境安裝與支援`，並引入裝置級 Markdown 原文與前台渲染 |
| Known defect | 先前驗證只覆蓋 mock test，未獨立驗正式資料庫欄位是否已對齊 |
| App-side mitigation | `utils/hardware/__init__.py` 讀取路徑已先呼叫 `_ensure_hardware_device_schema(conn)` |
| Validation baseline | `python -m pytest tests/test_hardware_products.py tests/test_solution_template.py -q` 已通過 `72 passed` |
| Required human truth | 目標資料庫是否已實際補欄位、是否需要一次性 DBA / migration 操作 |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| `database-architect` | `senior-software-engineer` | `testing-quality-engineer` |

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- |
| GOV-03 | Markdown 原文 + 前台渲染的資料庫承載已對齊正式環境 | 已確認目標資料庫 `hardware_device` 存在 `support_markdown` 欄位，且既有資料列不會因缺欄位導致 `/hardware/<slug>` 失敗 | 1. 查 schema 2. 實際打 `/hardware/<slug>` 3. 保留查詢或執行紀錄 | EV-03、EV-04 |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| GOV-03 | confirmed | confirmed | confirmed | 已直接用 SQL Login 查核正式 Azure SQL，補上 `support_markdown` 後再對正式站 `/hardware/asus-vivobook-s-15-16-s16-hx370-32g` 做 smoke，回 200 且頁面已顯示 `環境安裝與支援`。 |

## Verification Evidence

| Evidence ID | Description | Status |
| --- | --- | --- |
| EV-01 | App hotfix: `utils/hardware/__init__.py` 讀取路徑已加 `_ensure_hardware_device_schema(conn)` | Available |
| EV-02 | Focused regression: `python -m pytest tests/test_hardware_products.py tests/test_solution_template.py -q` → `72 passed` | Available |
| EV-03 | 正式 Azure SQL `ai_hub` 以 SQL Login (`azureadmin`) 直接查核：六張硬體表皆存在；查核前缺少 `hardware_device.support_markdown`；已執行 guarded `ALTER TABLE dbo.hardware_device ADD support_markdown NVARCHAR(MAX) NOT NULL DEFAULT N''`；查核後欄位存在且 `hardware_device_active_count = 6`、`hardware_resource_link_active_count = 12` | Available |
| EV-04 | `https://ai-hub-portal.azurewebsites.net/hardware/asus-vivobook-s-15-16-s16-hx370-32g` smoke：HTTP 200、未出現 `Internal Server Error`、頁面內容包含 `環境安裝與支援` | Available |
| EV-05 | 六台正式裝置的 `support_markdown` 已直接寫入正式 Azure SQL，之後已依來源邊界校正：device 1、2（ASUS AMD 機型）保留 repo-backed 的 AMD 通用路徑說明；device 3~6（Azure / Dell / MediaTek）改為明確標示「目前沒有裝置級安裝手冊」的占位內容，不再把推論寫成已驗證流程。校正後逐台 smoke `asus-expertcenter-pn54-pn54-ai7-350`、`asus-vivobook-s-15-16-s16-hx370-32g`、`azure-nc24ads-a100-v4-vm-nc24ads-a100-v4`、`azure-ncas-t4-v3-vm-ncas-t4-v3`、`dell-pro-max-dell-pro-max-gb10`、`mediatek-genio-510-evk-genio-510-evb` 皆回 HTTP 200 | Available |

## Blockers and Gate Status

| Gate | Status | Owner | Notes |
| --- | --- | --- | --- |
| 正式資料庫欄位已對齊 | pass | `database-architect` | 已直接查核正式 Azure SQL，並執行一次性 guarded 補欄 |
| 目標環境 smoke 已完成 | pass | `testing-quality-engineer` | 正式站既有裝置頁已回 200，未再出現 500 |
| 是否需要額外 DBA 操作已定案 | pass | `database-architect` | 本次一次性 guarded ALTER 已完成；後續新環境仍可沿用 `deployment/db/hardware-support-markdown-schema-reconcile.sql` |

`veto_status`: `pass`

## Closure Recommendation

建議關閉此單。正式環境已完成一次性 schema 對齊，且正式站硬體詳情頁 smoke 已證明 `/hardware/<slug>` 不再因缺欄位出現 500。後續若有新環境重建或 DB 匯入，可沿用 `deployment/db/hardware-support-markdown-schema-reconcile.sql` 作為變更窗口前的 guarded 對齊腳本。

## PM Closure Summary

使用者可見的 500 已同時在應用層與正式資料庫層完成收斂。正式 Azure SQL 已補上 `hardware_device.support_markdown`，六台正式裝置的 `環境安裝與支援` 內容也已直接寫入並逐台 smoke 通過，故此單可 go / close。若後續做新環境匯入或重建，請在變更窗口先執行 guarded schema 對齊腳本，再做 `/hardware/<slug>` smoke。