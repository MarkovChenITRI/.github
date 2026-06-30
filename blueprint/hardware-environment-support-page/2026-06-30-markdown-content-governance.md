# Subitem: Markdown Content Governance

## Problem Statement

現有 hardware detail 頁只能放外部資源連結，無法由平台持續維護裝置級安裝文件。若不先凍結內容責任邊界，後續很容易把平台文件寫成原廠文件鏡像、支援工單集散地，或反過來仍退回只有 link 卡片的半成品。

## Target User / Stakeholder

- 平台內容維護者
- RD / 架構 owner
- FAE
- 模型開發者與部署者

## Scope

1. 凍結平台文件要承載的內容類型。
2. 凍結平台與原廠責任邊界。
3. 凍結 Markdown 原文可維護、前台可閱讀渲染為正式產品要求。

## Acceptance Criteria

1. 明確寫出平台文件最少必須包含的資訊類型：前置軟體、版本前提、安裝順序、外部依據。
2. 明確寫出平台不負責的範圍：原廠驅動錯誤、第三方套件故障、正式商務合作支援。
3. 明確寫出這不是一次性文案，而是持續治理的裝置級內容面。

## Out Of Scope

1. 不決定 Markdown 存哪裡。
2. 不決定編輯器 UI 長相。
3. 不決定審批流程與版控機制。

## Delivery Form

- Reader / product context package
- 平台責任邊界
- 內容最低欄位定義

## Decision Freeze

1. 平台必須提供 Markdown 原文編修能力。
2. 前台必須把該內容渲染成裝置級可閱讀文件。
3. 外部官方連結只能作為佐證與下載入口，不再是唯一內容主體。

## 交付驗收（查核點 Checklist）

`Checked` 可接受值：`Y / N / N/A`

| Checkpoint ID | Owner | 完成條件 | 驗證方式 | 證據位置 | Blocking Gate | Signoff |
| --- | --- | --- | --- | --- | --- | --- |
| GOV-01 | PM | 已定義平台文件的最低內容類型 | 人工審閱 Acceptance Criteria | 本檔 Acceptance Criteria；`templates/pages/hardware/detail.html` admin Markdown textarea placeholder 已對應前置軟體、版本前提、安裝順序 | 若無最低內容類型則不得開工 | Evidence backfilled in SOP2 |
| GOV-02 | PM / FAE | 已分清平台與原廠責任邊界 | 人工審閱 Problem / Scope / Decision Freeze | 本檔全文；`templates/pages/hardware/detail.html` 將官方連結降為「支援資源」而非唯一主體 | 若責任邊界混寫則 no-go | Evidence backfilled, PM / FAE signoff pending |
| GOV-03 | RD | 已接收「Markdown 原文 + 前台渲染」作為產品要求而非建議 | RD handoff review | `utils/db.py`、`utils/hardware/__init__.py`、`utils/hardware/markdown_support.py`、`static/js/hardware-detail.js`、`templates/pages/hardware/detail.html` | 若 RD 未確認產品要求則不得進 SOP2 | Signed by RD via implementation |
| GOV-04 | FAE | 已確認該內容可作為一線支援入口，而非另開臨時文件 | FAE review | `templates/pages/hardware/detail.html` 空狀態文案與支援資源區；`docs/platform/uxui_architecture.md` | 若無法作為支援入口則 no-go | Evidence backfilled, FAE signoff pending |
