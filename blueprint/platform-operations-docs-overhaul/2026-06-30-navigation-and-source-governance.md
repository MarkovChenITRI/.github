# POV2-01 導覽與來源治理

## Metadata 表

| Subitem ID | Parent Initiative | Depends On | Planned Workorder Filename |
| --- | --- | --- | --- |
| POV2-01 | platform-operations-docs-overhaul | none | `.github/issues/platform-operations-v2-navigation-workorder.md` |

## 角色指派表

| Planner | Executor | Validator |
| --- | --- | --- |
| product-strategy-manager | senior-software-engineer | testing-quality-engineer |

## 問題陳述與分項目標

現有平台維運導航依「基礎理解 / 進階維運 / 規格」切分，讀者需要自行拼接平台功能域。V2 需要一個獨立入口與來源治理規則，讓每篇新文件可追溯來源並明確標示已驗證事實、規劃中契約與待補資料。

分項目標是規劃 `docs/platform-v2/index.md` 與 V2 導覽策略，並定義所有 V2 文件共同遵守的來源標註與重寫規則。

## 預期效益

1. 維護者進入 V2 後能先理解六個功能域，而不是先讀內部分類。
2. 文件 owner 可依固定來源標註規則重寫內容，避免直接搬移舊頁。
3. QE 可用來源清單與待補標記驗證文件沒有發明未驗證事實。

## In Scope

1. 規劃 V2 首頁的讀者任務、成功路徑與功能域入口。
2. 定義來源標註規則：來源 ID、來源文件、可宣稱內容、待補內容。
3. 定義 V2 與現有平台維運頁的並存邊界。
4. 規劃 `mkdocs.yml` 中 V2 導覽的最終資訊架構，但不在 SOP1 修改導覽。

## Out of Scope

1. 不改現有 `docs/platform/` 內容。
2. 不新增或移動實際 `docs/platform-v2/` 文件。
3. 不驗證正式 production 狀態。
4. 不承諾 V2 何時成為預設平台維運入口。

## 前置依賴與輸入契約

| 輸入 | 來源 | 要求 |
| --- | --- | --- |
| V2 目錄架構 | CEO 提供的計畫架構圖 | 六個功能域需保留。 |
| 文件寫作規則 | `.github/instructions/user-facing-docs.instructions.md` | V2 是開發者網站文件，需以讀者任務為中心。 |
| PM 邊界 | `.github/instructions/pm-team.instructions.md` | PM 定義 reader contract，不發明未驗證架構或驗證結果。 |
| 現有來源清單 | S1-S19 | 每篇文件需明確引用來源或標待補。 |

## SOP1 修正 Handoff

Status: pending-ceo-mapping-review.

本分項不得再依舊 9 頁 flat Page Inventory 施工。下一輪 SOP2 必須以 `00-manifest.md` 的 `CEO Immutable Acceptance Source`、`CEO IA to Page Inventory Mapping` 與 `Formal Page Inventory 與寫作契約` 為最高契約。

本分項的施工範圍是 V2 root、六大功能域導覽與全站來源治理；至少需覆蓋 `PV2-ROOT` 與全部 `PV2-F*`、`PV2-A*`、`PV2-P*`、`PV2-R*`、`PV2-D*`、`PV2-C*` 頁面在 `mkdocs.yml` 的巢狀導覽。舊 `docs/platform-v2/operating-map.md` 只能作為歷史草稿參考，不得作為正式導覽契約。

## 執行策略與內容規劃

| Workstream | Owner | 執行方法 / 施工內容 | 觸碰面 | 交付物 | 依賴 / Blocking Gate | 完成訊號 |
| --- | --- | --- | --- | --- | --- | --- |
| Reader contract | product-strategy-manager | 定義 V2 首頁要服務的平台維護者與接手開發者任務。 | `docs/platform-v2/index.md` 規劃 | Reader / product context package | CEO 未確認 V2 並存策略時不得宣稱上線策略。 | 首頁讀者、任務、成功條件與不在範圍已凍結。 |
| Source governance | product-strategy-manager | 建立 S1-S19 來源對照與待補標記規則。 | 全部 V2 文件 | 來源治理規則 | 每篇文件需至少列來源或待補。 | 每篇分項都有來源欄位與待補 gate。 |
| Navigation blueprint | product-strategy-manager | 將六個功能域整理成可放入 `mkdocs.yml` 的導覽概念。 | `mkdocs.yml` 規劃面 | 導覽草案 | 不在 SOP1 直接改導覽。 | 導覽順序與頁面名稱可交給 SOP2 實作。 |

## 交付物清單

1. `docs/platform-v2/index.md` 的重寫規劃。
2. V2 全站來源標註規則。
3. V2 導覽資訊架構草案。

## 查核點定義表

| Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 |
| --- | --- | --- | --- | --- | --- | --- |
| POV2-01-CP1 | V2 reader contract | 明確列出讀者、任務、成功條件、不在範圍。 | 避免 V2 變成舊文件搬家。 | 依 PM 與 user-facing docs 指令撰寫 reader contract。 | QE 檢查首頁是否能回答讀者要完成什麼。 | `docs/platform-v2/index.md` |
| POV2-01-CP2 | Source governance | 每篇 V2 頁面都有來源或待補標記。 | 防止未驗證內容被包裝成現況。 | 建立來源對照與頁面 front matter / 章節規則。 | 抽查頁面來源是否可回到 S1-S19。 | `docs/platform-v2/index.md`、各 V2 頁 |
| POV2-01-CP3 | Navigation scope | V2 導覽與現有平台維運導覽並存，不取代現有頁。 | 降低破壞性變更風險。 | 規劃 V2 nav 草案與上線邊界。 | 檢查 `mkdocs.yml` 變更是否只新增 V2 區。 | `mkdocs.yml` |

## 查核點簽核表

| Checkpoint ID | Planner | Executor | Validator | Notes |
| --- | --- | --- | --- | --- |
| POV2-01-CP1 | confirmed | confirmed | blocked | 已依 manifest 重寫 `docs/platform-v2/index.md`，建立 V2 root 與六大功能域入口；待 SOP3 驗證。 |
| POV2-01-CP2 | confirmed | confirmed | blocked | 已建立 Formal Page Inventory 對應 34 頁正式文件，舊 9 頁已從 `docs/platform-v2/` 移除；待 SOP3 驗證來源與待補標示。 |
| POV2-01-CP3 | confirmed | confirmed | blocked | 已將 `mkdocs.yml` 的「平台維運 V2」改為 CEO 指定六大功能域巢狀 IA；MkDocs strict build 通過。 |

## CEO 待提供資源

| 項目 | 內容 |
| --- | --- |
| V2 導覽策略 | 確認 V2 是否先公開並列，或先保留為草稿文件。 |

## 風險與待確認事項

1. 若現有 `mkdocs.yml` 已有舊版 V2 條目，SOP2 需判斷是否覆蓋、調整或移除。
2. 若 production CI/CD 實況未確認，V2 首頁只能寫「來源文件宣稱」或「待確認」，不得寫成已驗證現況。