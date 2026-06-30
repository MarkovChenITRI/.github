---
description: "Use when planning multi-employee tasks, designing handoffs between PM/RD/QE/HR, resolving role conflicts, or determining which agent owns a given action. Defines V-Model alignment, handoff interfaces, and inter-departmental taboos for the Connect AI four-department company structure."
---

# 跨部門協作準則（Cross-Team SOP）

本檔只放跨部門共通規則：CEO 與團隊的互動模型、三段 SOP 的分工、跨部門交接、關單輸出格式與越權邊界。部門內 workflow 與角色細節請回各自的 `instructions/`、`agents/`、`skills/`。

## 一、CEO 與團隊的正確互動模型

CEO 在這套流程中只做三件事：

1. 提供商務真相：為誰解決什麼問題、最低成功標準、明確不做的範圍、外部限制。
2. 提供只有人類能提供的資源或核准：正式環境變更、真人受測管道、預算、法律或授權拍板。
3. 在 PM 整理完成的 closure summary 上做最終 go / no-go，而不是逐項接管工程或驗收細節。

這個互動模型固定沿三段 SOP 運作：

1. SOP1：CEO 只給商務真相，團隊把需求凍結成 blueprint。
2. SOP2：團隊回 blueprint 做 checked 與簽核，CEO 不插手施工細節。
3. SOP3：團隊把驗收與 closure 集中到 issue，CEO 只補人類資源與做最終 go / no-go。

CEO 不應直接接收多份平行證據包做技術仲裁。SOP3 的最終對 CEO 輸出必須是 **PM 整理過的 closure summary**，其內容可引用 issue 內的證據，但不應要求 CEO 逐份比對 QE / FAE / SRE / Usability 的原始包後自行拼湊結論。

## 二、三段 SOP 的真相源與邊界

本專案的執行過程分為 `啟動`、`規劃`、`執行`、`交付驗收` 四個階段；操作上收斂為三段 SOP。

| SOP | 真相源 | 責任重點 | 對應檔案 |
|-----|--------|---------|---------|
| SOP1 | blueprint | 把需求外部化為可交接的規劃包、可施工的方法包與查核點 | `.github/instructions/start-to-planning.instructions.md` |
| SOP2 | blueprint | 依 blueprint 的施工藍圖完成執行、checked 填報、施工簽核與偏差揭露 | `.github/instructions/planning-to-execution.instructions.md` |
| SOP3 | `.github/issues/*-workorder.md` | 集中管理驗收證據、blocker、closure state、重新派工 | `.github/instructions/execution-to-verification.instructions.md` |

請只在需要的階段載入對應 instruction，不要同時混入其他兩段。

### Blueprint 與 Work Order 的分工

1. blueprint 負責需求、前提、施工藍圖、查核點與施工簽署。
2. work order issue 負責驗收、blocker、`veto_status`、closure recommendation 與重新派工。
3. SOP2 不得提前用 issue 取代 blueprint 的 checked 填報。
4. SOP3 不得把 closure state 反向散寫回 blueprint 當成第二份狀態板。
5. 只有當驗收或施工結果否定 blueprint 原始前提時，才回到 blueprint 重開規劃。

### 施工藍圖責任鏈

1. PM 在 SOP1 不負責寫程式實作，但必須把每個分項整理成下游可執行的施工藍圖，而不是只留下需求口號。
2. RD 在 SOP1 凍結前若已被拉入規劃，必須補足會影響開工判定的執行方法、觸碰面、交付物與依賴，避免 SOP2 才臨時發明施工路徑。
3. QE 在 SOP1 凍結前必須確認驗證方式能對應到已規劃的施工內容；若驗證無法對應施工方法，視為 blueprint 尚未 ready。
4. SOP2 允許 RD 依現場狀況微調實作技巧，但不得脫離 blueprint 已凍結的施工藍圖；若需要改變施工內容、觸碰面、交付物型態或角色責任，必須先回寫 blueprint。

### 簽核原則

任何階段都不得只寫「已完成」而沒有 owner、完成條件與驗證方式。
若簽核欄位缺失，視為尚未完成，不可直接進入下一階段。

### 規劃權限邊界

任何負責需求收斂、blueprint、驗收條件或工單規劃的角色，都不得自行承諾「幾天完成」「幾週完成」「分幾階段落地」這類時間與排程敘述。
規劃角色只負責定義問題、範圍、查核點、owner、依賴與 blocking gate；時程、週期、分段交付順序是否成立，屬 CEO 的裁決範圍。

## 三、跨部門交接總則

下表只列跨部門必要交接；部門內細節仍看各角色自己的 agent.md。

| From | To | 交付物 | 觸發時機 |
|------|----|--------|---------|
| CEO | PM | 商務願景、模糊需求、外部訊號、不可變更限制 | 啟動新需求 |
| PM | RD | 問題陳述、驗收標準、out of scope、交付形式、施工藍圖骨架 | blueprint 進入規劃 |
| RD | QE | 可測 API / 邊界條件 / 不變式 / operability 前提、施工內容與變更面 | 進入驗收設計 |
| GitHub Issue / 使用者回報 | FAE | 外部問題、log、環境資訊、重現線索 | issue 開啟或使用者回報 |
| PM | CEO | closure summary（基於 issue 證據整理） | SOP3 收斂後 |
| tech-stack-curator | CEO | LICENSE 草案（含 NOT FOR RELEASE 註記） | 草案產出後 |

### Blueprint Handoff Package 最低契約

每個分項在宣告 `Ready for SOP2` 前，必須至少交出以下四類資訊；缺任一類都不應進入開工：

1. 問題與範圍：問題陳述、預期效益、in scope、out of scope。
2. 施工藍圖：執行方法、預計觸碰面、交付物、相依與 blocking gate。
3. 驗證契約：每個查核點的完成條件、驗證方式、證據位置。
4. 角色責任：planner、executor、validator 與需要 CEO 補的人類資源。

### 文件交付 Handoff Package

需要產出 README、onboarding、quickstart、部署指南、維運文件或系統文件時，當前任務 owner 不接收只有抽象名稱的交付物；上游需提供可追溯來源。各 package 的必填內容仍以對應 owner 的 agent.md 為真相源，此處只列索引：

- Reader / product context package：`product-strategy-manager.agent.md`
- Architecture facts package：`architecture-research-developer.agent.md`
- Schema facts package：`database-architect.agent.md`
- Design facts package：`ui-ux-designer.agent.md`
- Security review package：`security-engineer.agent.md`
- Operability facts package：`site-reliability-engineer.agent.md`
- Usability findings package：`usability-test-coordinator.agent.md`
- Issue / feedback action package：`field-application-engineer.agent.md`

唯一例外是 Verification evidence package：目前仍由 `testing-quality-engineer` 與 SOP3 共同約束，必填內容為已驗證命令、驗收路徑、gate 分級、殘餘風險與證據連結。

### 使用者文件表達責任鏈

當交付物包含 README、開發者文件、Pages 文件、維運手冊或產品中的使用者可見文字時，責任鏈固定如下：

1. PM 定義 reader / product context package。
2. RD 提供 architecture / schema / design facts package。
3. QE 提供 verification evidence package。
4. 一般情況由當前任務 owner 依 `user-facing-docs.instructions.md` 直接完成；若跨頁、跨來源或資訊架構重整，則由 `product-strategy-manager` 協調 reader contract，並由相關 owner 共同收斂。

任何角色都可以提供內容，但不得直接以內部交接語氣定稿面向使用者的最終文字表達。

## 四、SOP3 的關單輸出規則

SOP3 對 CEO 的最終輸出不是平行證據包的堆疊，而是 PM 整理過的 closure summary。其最低內容為：

1. 驗收結果
2. 失敗原因或 blocking gate
3. issue 內可追溯的證據連結
4. go / no-go 建議
5. 若 no-go，下一位 owner 與 CEO 是否還有待提供資源

FAE 可提供 closure recommendation，QE / SRE / Usability 可提供證據包，但只有 PM 負責把這些結果翻譯為 CEO 可直接裁決的總結。

### 真人 usability blocker 拆分規則

凡是涉及真人 usability 驗證的 blocker，不得以「CEO + usability-test-coordinator 共同 owner」一句帶過，必須拆成兩個 action：

1. **CEO 資源 action**：提供受測者管道、beta 名單、測試平台或招募預算。
2. **QE findings action**：由 `usability-test-coordinator` 依 protocol 產出 findings package。

若第一個 action 未完成，第二個 action 不得被寫成 QE 延誤；若第二個 action 未完成，也不得把 CEO 已提供資源誤寫成「已完成真人驗證」。

## 五、否決規則與統一欄位

### 固定節奏（Trigger-Based Cadence）

團隊採事件觸發節奏，不假設固定日曆時間點。

1. 任務啟動：PM 確認 What / Why，定義 acceptance criteria 與 blocking gate。
2. 中期確認：路徑 lead 交付後，PM 確認指標趨勢是否偏離門檻。
3. 關單審查：連續達標門檻達成後，PM 輸出 go / no-go 建議給 CEO。

### 否決規則（Veto Rules）

任一條件成立，PM 必須標記 no-go，不得以文字承諾替代：

1. 任一 blocking gate 未達標。
2. 證據包缺欄位（owner、完成條件、驗證方式、closure criteria）。
3. 指標未達連續穩定門檻。

### 指標輸出單一契約（Unified Metrics Contract）

所有 RD / QE / Documentation 週報必須使用相同欄位，禁止各自定義格式：

1. reporting_week
2. stream_id（provider / maintainer / consumer）
3. owner
4. metric_name
5. baseline
6. target
7. current
8. trend（up / flat / down）
9. evidence_links
10. blocker
11. veto_status（pass / fail）

任一欄位缺失即視為無效回報，不可進入關單流程。

## 六、跨部門禁忌

| 禁忌 | 違反原則 |
|------|---------|
| PM 寫程式碼 / 改 agent.md 或 SKILL.md | 越權；PM 只管 What/Why |
| 任何規劃角色自行承諾工時、天數、週數、sprint 或分階段落地順序 | 越權；時程裁決屬 CEO |
| RD / QE 自行揣摩 CEO 商務意圖並擴張範圍 | 越權；商務裁決屬 PM |
| 任何 owner 在 user-facing docs 中自行發明產品承諾、架構契約或驗證結果 | 越權；產品屬 PM、架構屬 RD、驗證屬 QE |
| QE 直接改 RD 的程式碼 | 越權；QE 提建議，RD 決定是否採納 |
| FAE 沒有重現或驗證證據就建議關閉 issue | 越權；issue closure 必須有證據與 owner 回覆 |
| QE（usability-test-coordinator）自行招募、聯繫或支付真人受測者 | 越權；真人測試管道需 CEO 提供 |
| QE（usability-test-coordinator）沒有真人原始資料就編造或推測使用者反饋 | 誠信；不得冒充真人反應 |
| 把冷啟動測試（AI 模擬）對外宣稱等同已完成真人可用性測試 | 誤導；兩者互補不互相取代 |
| 在 SOP2 提前用 issue 取代 blueprint checked 填報 | 違反階段分工 |
| 在 SOP3 仍把 closure state 維護在 blueprint 而非 issue | 違反單一真相源 |
| 讓 CEO 直接面對多份平行證據包自行做技術拼圖 | 違反 PM 翻譯責任 |

## 七、Blueprint 觸發條件與結構

當規劃一個新功能、且預期施工規模會超過單輪對話的處理能力時，先在 `blueprint/<feature-name>/` 建立計劃書資料夾，把跨角色的分工與查核點顯式寫成檔案，避免任何角色在實作過程中獨自發散或臆測其他角色的決定。

符合下列任一項即啟動 Blueprint：

| 判準 | 具體徵兆 |
|------|---------|
| 預測對話將被自動壓縮 | 預期內容量會在完成前觸發 compaction |
| 預測需要開新 session 才能完成 | 工作無法在當前 session 結束前收斂 |
| 預測角色交接會隔代失真 | 下游拿到的是被轉述的二手敘述 |

Blueprint 資料夾最小結構：

```text
blueprint/<feature-name>/
├── 00-manifest.md
├── yyyy-mm-dd-<subitem-english-name>.md
├── yyyy-mm-dd-<subitem-english-name>.md
└── ...
```

其中：

1. `00-manifest.md` 是 initiative 母檔，負責期目標、計畫架構圖、分項索引與凍結線。
2. 每個分項固定一份 `yyyy-mm-dd-<subitem-english-name>.md`，由 PM 統一命名。
3. 每份分項檔的查核點沿用固定欄位：`Checkpoint ID | Owner | 完成條件 | 預期效益 | 執行方法 / 施工內容 | 驗證方式 | 證據位置 | Blocking Gate | Signoff`。

## 九、Blueprint / Issue 真相源順序

導入分項規劃檔後，三類工件的真相源順序如下：

1. **CEO 計畫架構圖**：商務結構真相，定義期目標、分項、依賴、資源級別與不做範圍。
2. **`00-manifest.md`**：PM formalize 後的 initiative 索引真相，負責分項命名、owner、凍結線與索引。
3. **分項規劃檔**：施工前規劃真相，定義該分項的施工藍圖、查核點、交付物與驗證方式。
4. **work order issue**：SOP3 驗收與 closure 真相，定義 blocker、證據、closure recommendation 與 PM closure summary。

禁止情況：

1. 用 work order issue 取代 SOP2 的 blueprint checked 填報。
2. 在分項規劃檔內平行維護 closure state。
3. 讓 CEO 計畫架構圖直接包含 RD 的技術 How。

## 八、CEO 核准事項總表

下表只收斂所有需要 CEO 明確核准的事項，不新增規則：

| 事項 | 範圍 | 核准人 |
|------|------|--------|
| 移除 LICENSE 草案的 NOT FOR RELEASE 註記 | tech-stack-curator | 僅 CEO |
| 執行 `pip install` / `npm install` / `submodule add` 等安裝指令 | tech-stack-curator | CEO 確認後手動執行 |
| 對正式環境做破壞性操作 | site-reliability-engineer | CEO 或 change window 核准 |
| 提供真人測試管道（beta 名單 / 測試平台 / 招募預算） | usability-test-coordinator | CEO |
| 啟動 skill / agent 考核 | skill-quality-auditor | 僅 CEO 明確召喚 |
| 修改 `LICENSE` / `NOTICE` 重大條文 | 全公司 | CEO 核准 |
| push 到 `main` 分支 | 全公司 | 需每次重新明確授權 |
