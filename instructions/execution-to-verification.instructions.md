---
description: "Use when a blueprint task is in the 執行 → 驗證 stage. Define the input contract, standard output package, and acceptance gate for verifying deliverables from a user and QE perspective."
applyTo: ".github/blueprint/**/*.md,blueprint/**/*.md,.github/issues/*-workorder.md"
---

# Blueprint SOP3：執行到驗證

SOP3 只處理驗證，不再承接施工決策；它的作用是確認成果是否真的可交付。驗證與 closure tracking 的單一真相源應是對應的 work order issue，而不是把驗收過程回寫成 blueprint 狀態日誌。

## 標準輸入

| 項目 | 內容 |
|------|------|
| 施工完成物 | SOP2 完成後的所有可交付內容 |
| 驗收條件 | blueprint 中已定義的查核點與完成標準 |
| 施工藍圖 | blueprint 中已凍結的 `執行策略與內容規劃` 與 `執行方法 / 施工內容` |
| Work order issue | `.github/issues/*.md` 中已建立的施工單與其 current state |
| 證據素材 | 測試結果、log、截圖、錄影、重現步驟、連結 |
| 風險清單 | 已知但尚未修正的限制與缺口 |

## 標準產出

| 項目 | 內容 |
|------|------|
| 驗收結論 | 通過、部分通過、失敗、阻擋 |
| 施工對照 | 已交付內容與原施工藍圖是否一致、哪些差異已回寫 |
| 證據包 | 可回查的驗收證據與測試紀錄 |
| 缺口清單 | 尚未達標的項目、原因、擁有者 |
| 回寫動作 | 回到 work order issue、docs 或重新派工；若規劃前提失效才回上游重開 blueprint |
| Closure summary | 由 PM 整理給 CEO 的總結輸出 |

## Verification Issue 規則

1. SOP3 不另開第二份驗收狀態檔；應直接在同一份 work order issue 內補齊驗收結論、證據包、缺口清單、gate、`veto_status` 與 closure recommendation 所需欄位。
2. FAE、QE、SRE、Usability 等 closure 相關角色，應以該 issue 內的 blocker、signoff、metrics、owner、stage 為唯一真相源，不平行維護一份 blueprint 驗收摘要。
3. 若驗證失敗但仍屬施工缺口，回到同一份 issue 重新派工；若失敗原因是否定 blueprint 前提，才回到 SOP1 / SOP2 重開規劃。

### Work Order 檔名規範

1. 每份 work order issue 檔名固定格式為 `yyyy-mm-dd-<feature-english-name>-<subitem-english-name>-workorder.md`。
2. `<subitem-english-name>` 必須與 blueprint 分項檔 `yyyy-mm-dd-<subitem-english-name>.md` 的英文名完全一致。
3. `<feature-english-name>` 應與 `blueprint/<feature-name>/` 的 feature slug 對齊；由 PM 在 manifest 中統一定義。
4. 禁止使用 `followup`、`new`、`latest`、`final` 這類缺乏結構語意的命名作為唯一標識。

### Work Order 固定章節

每份 `yyyy-mm-dd-<feature-english-name>-<subitem-english-name>-workorder.md` 至少包含以下段落，順序不可顛倒：

1. 標題
2. Metadata bullets
3. Issue Classification
4. Objective and Scope
5. Frozen Input Contract
6. 角色指派表
7. 查核點定義表
8. 查核點簽核表
9. Verification Evidence
10. Blockers and Gate Status
11. Closure Recommendation
12. PM Closure Summary

Metadata bullets 至少包含：`Work Order ID`、`Date`、`Stream ID`、`Source Blueprint File`、`Source Checkpoint IDs`、`Current Stage`、`Next Owner`。

`角色指派表` 固定欄位為：`Planner | Executor | Validator`。

`查核點定義表` 必須沿用來源 blueprint 分項檔的凍結欄位；固定欄位為：`Checkpoint ID | Item | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置`。

`查核點簽核表` 固定欄位為：`Checkpoint ID | Planner | Executor | Validator | Notes`。

其中 `查核點定義表` 與來源 blueprint 分項檔必須一一對應，不得在 SOP3 另改完成條件、預期效益、執行方法或驗證方式；SOP3 只允許更新 `查核點簽核表` 與驗收證據。

`Planner`、`Executor`、`Validator` 三欄直接表示各角色的簽核狀態；允許值固定為：`pending`、`confirmed`、`blocked`、`rejected`、`n/a`。

## CEO 與 PM 的關單輸出規則

1. FAE 可以提出 closure recommendation。
2. QE / SRE / Usability 可以提出各自的證據包。
3. 但對 CEO 的最終輸出必須是 **PM 整理過的 closure summary**，而不是要求 CEO 直接閱讀多份平行證據自行拼圖。
4. closure summary 至少包含：驗收結論、blocking gate、issue 證據連結、go / no-go 建議、若 no-go 則下一位 owner 與 CEO 尚待提供的資源。

## 真人 usability blocker 拆分規則

凡是涉及真人 usability 驗證的 blocker，必須拆成兩個 action，不得把 CEO 與 `usability-test-coordinator` 合寫成一句共同 owner：

1. CEO 資源 action：提供受測者管道、beta 名單、測試平台或招募預算。
2. QE findings action：由 `usability-test-coordinator` 依 protocol 執行並產出 findings package。

若第一個 action 未完成，第二個 action 不得被當成 QE 延誤；若第二個 action 未完成，也不得把已提供受測者管道誤報為「已完成真人驗證」。

## 完成判定

1. 驗收結論可被證據支持。
2. 驗收證據能回指到 blueprint 的施工藍圖，而不只是證明某個結果存在。
3. 阻擋項目已明確回寫到 work order issue，且 `查核點簽核表`、blocker 紀錄與 `Current Stage` 一致。
4. 若未通過，必須能指出下一個 owner 與下一步行動。
5. 提交給 CEO 的輸出已被 PM 收斂為 closure summary，而不是平行證據包堆疊。
6. work order issue 已回填 `Source Blueprint File` 與 `Source Checkpoint IDs`，且可從 `00-manifest.md` 反向索引。