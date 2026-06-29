# 環節 07：Pages 文件與運維指南

## 簡述

統一 Pages (docs/platform) 與所有 blueprint 為完整的「Platform Authorization Specification」，涵蓋開發者指南、平台運維文件、故障排查、審核檢查表。本環節是文件與培訓層，面向開發者、reviewer、運維人員。

---

## 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Pages 頁面架構** | 為不同讀者組織文件路徑；超連結維護 | Pages 部署基礎設施（屬 QE/DevOps） |
| **開發者指南** | 流程教程、config.yaml 說明、GitHub 設定步驟 | 具體 UI 實作（屬前端） |
| **平台運維文件** | SOP 指南、grant 簽發/撤銷檢查表、故障排查 | 運維工具實裝（屬 RD） |
| **架構圖與資料流** | Mermaid flowchart、狀態機圖、資料表依賴圖 | 圖形工具實裝（屬文件層） |
| **故障排查指南** | 常見問題、debug 步驟、聯繫方式、已知限制 | 具體系統除錯（屬 RD/QE） |
| **審核檢查表** | Reviewer 決策清單、上架標準、驗收標準 | 審核流程管理（屬 admin） |

---

## 依賴方向

```
開發者 / Reviewer / 運維人員
    ↓
Pages 文件入口 (docs/platform)
    ├─→ 開發者快速入門 (model-provider/)
    │   ├─→ 流程圖、配置指南、故障排查
    │   └─→ 指向 Template Repo
    ├─→ 平台架構說明 (advanced/)
    │   ├─→ 授權規範、資料表設計、狀態機
    │   └─→ 指向 blueprint/
    ├─→ 運維 SOP (advanced/operations-runbook.md)
    │   ├─→ Grant 簽發/撤銷、Credential 輪替、應急程序
    │   └─→ 指向環節 02/06 API
    └─→ 故障排查樹 (advanced/troubleshooting-publish-flow.md)
        ├─→ workflow 失敗、callback 超時、ACR 問題、權限問題
        └─→ 指向相應文件或聯繫方式
```

---

## 文件結構規劃

### 現有文件（需擴展）

| 檔案 | 當前狀態 | 需調整 | 新增內容 |
|-----|--------|--------|---------|
| `docs/platform/advanced/authorization-and-access.md` | ✓ 存在 | 擴展授權模型表 | 5 種授權類型、4 角色矩陣、grant lifecycle |
| `docs/platform/advanced/model-card-publishing.md` | ✓ 存在 | 補齊 API 清單 | 完整 endpoint list、callback 簽章規則、狀態轉移圖 |
| `docs/platform/advanced/operations-runbook.md` | ✓ 存在 | 完善 SOP | Grant 簽發清單、revocation 流程、credential rotation SOP |
| `docs/platform/advanced/quota-usage.md` | ✓ 存在 | 無需調整 | — |

### 新增文件

| 檔案 | 目的 | 讀者 | 長度 |
|-----|------|------|------|
| `docs/platform/advanced/credentials-lifecycle-management.md` | Credential 完整生命週期說明 | 運維、架構 | 1000 行 |
| `docs/platform/advanced/troubleshooting-publish-flow.md` | 故障排查決策樹 | 開發者、reviewer、QE | 800 行 |
| `docs/model-provider/acr-and-github-setup.md` | GitHub & ACR 設置詳細步驟 | 開發者 | 600 行 |
| `docs/model-provider/publish-readiness-checklist.md` | Pre-publish 自檢清單 | 開發者 | 400 行 |
| `blueprint/README.md` | 藍圖索引與依賴圖 | 架構、RD、QE | 300 行 |
| `blueprint/[01-07].md` | 各環節詳細規劃 | RD、架構、QE | 7 × 1200 行 |

---

## 公開 Pages 結構（讀者視角）

```
docs/platform/
│
├─ index.md
│   ├─ 五分鐘概覽：Model Card 上架流程、關鍵概念、快速連結
│   └─ 讀者導向：
│       ├─ 我是開發者 → model-provider/ 入口
│       ├─ 我是 reviewer → advanced/model-card-publishing.md + 檢查表
│       └─ 我是運維人員 → advanced/operations-runbook.md
│
├─ model-provider/
│   ├─ packaging-data.md (existing)
│   ├─ template-repo.md (existing)
│   ├─ profile-and-runtime.md (existing)
│   ├─ packaging-quickstart.md (existing)
│   ├─ publish-readiness.md (updated: 加入 config.yaml 檢查清單)
│   ├─ acr-and-github-setup.md (new: GitHub Secrets 詳細步驟)
│   └─ publish-workflow-diagram.md (new: flow 圖)
│
├─ advanced/
│   ├─ authorization-and-access.md (updated)
│   │   ├─ 5 種授權類型表
│   │   ├─ 4 角色 × 8 操作矩陣
│   │   └─ Grant lifecycle 狀態圖
│   ├─ model-card-publishing.md (updated)
│   │   ├─ 完整 API 端點清單 (01-05 環節)
│   │   ├─ Callback 簽章規則 (環節 04-05)
│   │   ├─ 9 狀態 + 8 轉移狀態機圖
│   │   └─ Draft → Published 完整流程
│   ├─ credentials-lifecycle-management.md (new)
│   │   ├─ Grant 簽發、撤銷、過期流程
│   │   ├─ Credential 輪替 SOP
│   │   ├─ Grace period 說明
│   │   └─ 稽審日誌查詢方法
│   ├─ operations-runbook.md (updated)
│   │   ├─ Daily ops checklist
│   │   ├─ Emergency response (grant revocation)
│   │   ├─ Credential rotation procedure
│   │   ├─ Monitoring & alerting setup
│   │   └─ 常見操作指令 (CLI/API)
│   ├─ troubleshooting-publish-flow.md (new)
│   │   ├─ 決策樹：是否成功 → 故障類型 → 解決方案
│   │   ├─ GitHub Actions 日誌讀取指南
│   │   ├─ ACR 連線診斷
│   │   ├─ Callback 簽章驗証方法
│   │   ├─ Database 查詢樣板
│   │   ├─ 已知限制與二期規劃
│   │   └─ 聯繫 Platform 團隊方式
│   ├─ azure-resources-preparation.md (existing)
│   ├─ database-schema.md (existing)
│   ├─ database-migration.md (existing)
│   ├─ github-cicd-workflow.md (existing)
│   ├─ repository-architecture.md (existing)
│   ├─ uxui-architecture.md (existing)
│   └─ quota-usage.md (existing)
│
└─ blueprint/
    ├─ README.md (index: 依賴圖、環節清單、查核流程)
    ├─ 01-portal-model-onboarding.md
    ├─ 02-publish-grant-issuance-engine.md
    ├─ 03-template-repo-automation.md
    ├─ 04-github-actions-validation-pipeline.md
    ├─ 05-callback-processor-and-state-machine.md
    ├─ 06-credential-lifecycle-management.md
    └─ 07-documentation-and-operations-sop.md
```

---

## 核心內容清單

### 開發者指南完整度檢查

- [ ] **Quickstart**（5 分鐘）：
  - 登入 Portal
  - 填表單、下載 config.yaml
  - Clone template repo
  - 複製 Variables/Secrets
  - Push 與等待 workflow 完成

- [ ] **config.yaml 撰寫指南**：
  - 必填欄位說明
  - 允許值列舉
  - 常見錯誤與修正
  - 工具驗証方法 (preflight)

- [ ] **GitHub Setup 詳細步驟**：
  - Repository secrets 位置
  - 複製 AIHUB_* 值的方式
  - 防止 secret 洩露的注意事項
  - 驗証 secrets 已正確設置的方法

- [ ] **Workflow 失敗排查**：
  - Build failed → 檢查 Dockerfile、.so 編譯、model.py
  - Push failed → 檢查 ACR credential、image tag
  - Callback failed → 檢查 callback_url 與 token
  - Label mismatch → 檢查 config.yaml 版本
  - 如何查看詳細日誌
  - 何時聯繫 Platform 團隊

### 平台運維文件完整度檢查

- [ ] **Grant Issuance SOP**：
  - API 呼叫範例
  - TTL 預設值與調整方式
  - ACR credential 準備步驟
  - GitHub Secrets 自動填充方式（若支持）
  - 簽發檢查清單

- [ ] **Emergency Revocation SOP**：
  - 何時需撤銷（安全事故、違規等）
  - API 呼叫與 reason 分類
  - 撤銷後的通知步驟
  - 如何驗証撤銷已生效

- [ ] **Credential Rotation SOP**：
  - 何時進行輪替（定期或事故後）
  - 輪替 procedure 逐步指南
  - Grace period 管理
  - 提供者通知方式
  - Rollback 計畫（若輪替失敗）

- [ ] **Monitoring & Alerting**：
  - 關鍵指標定義（簽發率、失敗率等）
  - 告警規則設置
  - 日誌檢查方法
  - Dashboard 配置

- [ ] **Audit & Compliance**：
  - 稽審日誌查詢方法
  - 合規報告產出
  - 保留期限與歸檔策略

### 故障排查決策樹

```
Workflow 執行失敗？
├─ Y
│  ├─ Preflight failed?
│  │  ├─ Y → 檢查環境變數是否設定 (docs/acr-and-github-setup.md)
│  │  └─ N → 繼續下一檢查
│  ├─ Build failed?
│  │  ├─ Y → 查看 log，檢查 Dockerfile / .so 編譯 (docs/troubleshooting)
│  │  └─ N → 繼續下一檢查
│  ├─ Push failed?
│  │  ├─ Y → 檢查 ACR credential、網路連線
│  │  └─ N → 繼續下一檢查
│  └─ Callback failed?
│     ├─ Y → 檢查 callback_url、簽章驗証
│     └─ N → 檢查 Callback 接收日誌
└─ N
   ├─ Model Published?
   │  ├─ Y → 成功完成！
   │  └─ N → 檢查 review 狀態 (docs/operations-runbook.md)
```

### 架構圖集合

- [ ] **組態流程圖** (Portal → GitHub → Actions → Callback)
  ```
  Mermaid: flowchart LR
    Portal[Portal] --> GH[GitHub Actions]
    GH --> ACR["ACR Push"]
    ACR --> CB["Callback"]
    CB --> Review["Manual Review"]
  ```

- [ ] **狀態機圖** (draft → package_ready → grant_issued → pending_review → published)

- [ ] **資料表依賴圖** (model_card_draft ← → model_publish_grant ← → model_publish_callback_event)

- [ ] **元件責任矩陣** (環節 01-07 與各層負責單位)

---

## 待確認項（TBD）

1. **文件語言與風格**  
   - 使用台灣業界慣用語（例如：「簽發」vs. 「發行」、「回調」vs. 「回呼」）？
   - 技術術語的中英文混用規則？
   - **決策方**：PM / 文件經理
   - **Priority**：P1

2. **針對開發者 vs. 運維的文件分離**  
   - 是否分別維護「model-provider/」與「platform/advanced/」？
   - 是否 blueprint/ 只給架構師與 RD，不對外發布？
   - **決策方**：PM / 文件經理
   - **Priority**：P1

3. **國際化 (i18n)**  
   - 是否需發布英文版 Pages？
   - 何時開始翻譯（MVP 後 vs. 同步）？
   - **決策方**：PM / 市場部
   - **Priority**：P2

4. **Pages 更新頻率**  
   - 與軟體版本同步發布，還是持續更新？
   - Changelog 或版本控制方式？
   - **決策方**：PM / 文件經理
   - **Priority**：P1

---

## 查核清單（Checklist）

### 文件內容完整度

- [ ] **首頁 (docs/platform/index.md)**：
  - 五分鐘概覽
  - 讀者分類導向
  - 快速連結（至少 5 個主要入口）
  - 最後更新日期與版本

- [ ] **開發者指南 (model-provider/)**：
  - quickstart.md 或 packaging-quickstart.md 涵蓋完整流程
  - config.yaml 說明完整且有例子
  - GitHub setup 步驟清晰（可複製貼上）
  - 常見錯誤與修正 ≥5 個案例
  - 故障排查指南

- [ ] **架構文件 (advanced/)**：
  - authorization-and-access.md 包含 5 種授權類型表 + 4 角色矩陣
  - model-card-publishing.md 包含完整 API 清單與狀態機圖
  - credentials-lifecycle-management.md 覆蓋簽發/撤銷/輪替/過期
  - operations-runbook.md 包含 daily ops + emergency response
  - troubleshooting-publish-flow.md 包含決策樹與聯繫方式

- [ ] **Blueprint (blueprint/)**：
  - blueprint/README.md 含依賴圖與環節清單
  - 01-07.md 各 1200+ 行規劃文件
  - 每個檔案包含 Source of Truth 連結
  - 每個檔案包含 Checklist 與 TBD 列表

### 超連結與引用完整性

- [ ] **Pages 內部連結**：
  - 開發者指南 → template-repo 連結正確
  - 運維文件 → API contract 連結正確
  - 故障排查 → 相應文件/聯繫入口
  - 無死連結（404）

- [ ] **Blueprint 連結**：
  - blueprint/README.md 連結至各個 01-07.md
  - 各 blueprint 檔案連結至 Source of Truth (程式碼行號)
  - 各 blueprint 相互交叉引用清晰

- [ ] **外部連結**：
  - GitHub template repo 連結
  - Azure 資源文件連結
  - 相關 RFC 或規範連結

### 程式碼範例與可執行性

- [ ] **config.yaml 例子**：
  - 完整有效的 YAML
  - 包含必填與選填欄位
  - 可直接複製使用

- [ ] **GitHub API 呼叫例子**：
  - Curl 或 Python requests 格式
  - 包含完整 header 與 payload
  - 可直接複製執行（替換值後）

- [ ] **CLI 指令**：
  - preflight, generate_oci_labels 等
  - 包含輸入與預期輸出
  - 可直接複製執行

- [ ] **Database 查詢樣板**：
  - 列出過期 grant
  - 查詢特定開發者的 draft
  - 檢視稽審日誌

### 圖形與視覺化

- [ ] **流程圖**：至少 3 個（Portal 流程、狀態轉移、故障排查決策樹）
- [ ] **狀態機圖**：9 狀態 + 8 轉移清晰可見
- [ ] **架構圖**：元件、依賴、資料流
- [ ] **角色矩陣**：4 角色 × 8+ 操作的權限表

### 版本與變更日誌

- [ ] **首頁版本標記**：v1.0（MVP）或 0.1（beta）
- [ ] **更新日期**：每個文件都有 last updated 時間戳
- [ ] **Changelog**：記錄重要更新與不相容變更
- [ ] **已知限制**：明列未在此版本支持的功能

### 聯繫與反饋

- [ ] **常見問題 (FAQ)**：≥10 個條目
- [ ] **聯繫方式**：
  - Platform 團隊 email
  - Slack 頻道（若適用）
  - GitHub Issues 模板
  - 緊急情況聯繫單位
- [ ] **反饋入口**：如何提交文件改進建議

### 監測與更新循環

- [ ] **文件檢查流程**：
  - 誰負責檢視更新（文件經理）
  - 多久檢查一次（建議 monthly）
  - 如何收集反饋
- [ ] **自動化檢查**：
  - 無死連結 (linkchecker or similar)
  - Markdown 格式驗証
  - 程式碼範例可執行性檢查

---

## 依賴於此環節的下游

| 下游受眾 | 依賴點 | 需求 |
|---------|--------|------|
| **開發者** | Quickstart、config.yaml 指南、故障排查 | 清晰且可複製 |
| **Reviewer** | 上架檢查清單、決策標準 | 不超過 5 分鐘審核 |
| **運維人員** | SOP、emergency response、monitoring | 逐步可執行、無模糊處 |
| **架構師** | Blueprint、設計決策、TBD 列表 | 完整且可追蹤 |
| **QE/測試者** | 測試邊界、覆蓋率建議 | 清晰界定 unit/integration/E2E |

---

## 關鍵決策總結

| 決策項 | 當前值 | 理由 | 變更影響 |
|--------|--------|------|---------|
| 文件分層 | 開發者 (model-provider) + 架構 (blueprint) + 運維 (advanced) | 讀者清晰分類 | 若混合在一起，難以導向 |
| 語言選擇 | 繁體中文台灣業界慣用語 | 地區化；降低翻譯誤解 | 若用簡體或機器翻譯，準確度下降 |
| 圖形工具 | Mermaid (Markdown 原生支持) | 版本管理容易；Pages 原生渲染 | 若改用 PlantUML / Lucidchart，需外部工具 |
| Blueprint 公開度 | 對 RD/Architect 公開；對外可選 | 避免概念混淆；內部決策工具 | 若完全對外，需額外簡化與解釋 |

---

**查核完成日期**：_____________  
**完成者**：_____________  
**審核者**：_____________  

---

## 附錄：文件更新清單（逐項實施）

| 檔案 | 當前狀態 | 操作 | 預計工作量 | 優先度 |
|-----|--------|------|----------|--------|
| docs/platform/index.md | 待更新 | 新增五分鐘概覽 + 讀者導向 | 1-2h | P0 |
| docs/platform/advanced/authorization-and-access.md | 部分完成 | 補齊 5 類型表 + grant lifecycle | 2h | P0 |
| docs/platform/advanced/model-card-publishing.md | 部分完成 | 補齊完整 API + 狀態機圖 | 3h | P0 |
| docs/platform/advanced/operations-runbook.md | 部分完成 | 新增 revocation/rotation SOP | 3h | P0 |
| docs/platform/advanced/credentials-lifecycle-management.md | 新增檔案 | 完整內容 | 3h | P0 |
| docs/platform/advanced/troubleshooting-publish-flow.md | 新增檔案 | 決策樹 + 常見問題 | 3h | P0 |
| docs/model-provider/acr-and-github-setup.md | 新增檔案 | 詳細步驟 | 2h | P1 |
| docs/model-provider/publish-readiness-checklist.md | 新增檔案 | 自檢清單 | 1.5h | P1 |
| blueprint/ (7 檔案) | 本 session 完成 | 已生成 | 0h | — |

---

**整體 Pages 更新預計工時**：20-25 小時  
**推薦排程**：分 3 個 sprint (P0 first week, P1 second week, P2 third week)
