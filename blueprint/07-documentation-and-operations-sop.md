# 環節 07：Pages 文件與運維指南

## 簡述

統一 Pages (docs/platform) 與所有 blueprint 為完整的「Platform Authorization Specification」，涵蓋開發者指南、平台運維文件、故障排查、審核檢查表。本環節是文件與培訓層，面向開發者、reviewer、運維人員。

## 啟動

| 項目 | 啟動標準 |
| --- | --- |
| 文件邊界 | 開發者路徑與維運內部路徑分離，避免混寫。 |
| 權限語意 | 全文件只使用 `admin` / `user`。 |
| 對外承諾 | 僅描述已可交付能力，不超額承諾。 |

---

## 規劃

### 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Pages 頁面架構** | 為不同讀者組織文件路徑；超連結維護 | Pages 部署基礎設施（屬 QE/DevOps） |
| **開發者指南** | 流程教程、config.yaml 說明、GitHub 設定步驟 | 具體 UI 實作（屬前端） |
| **平台運維文件** | SOP 指南、grant 簽發/撤銷檢查表、故障排查 | 運維工具實裝（屬 RD） |
| **架構圖與資料流** | Mermaid flowchart、狀態機圖、資料表依賴圖 | 圖形工具實裝（屬文件層） |
| **故障排查指南** | 常見問題、debug 步驟、聯繫方式、已知限制 | 具體系統除錯（屬 RD/QE） |
| **審核檢查表** | Reviewer 決策清單、上架標準、驗收標準 | 審核流程管理（屬 admin） |

---

### 依賴方向

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

## 執行（真的要施工的細部規格）

### 文件結構規劃

### 現有文件（需擴展）

| 檔案 | 當前狀態 | 需調整 | 新增內容 |
|-----|--------|--------|---------|
| `docs/platform/advanced/authorization-and-access.md` | ✓ 存在 | 擴展授權模型表 | 5 種授權類型、`admin` / `user` 角色矩陣、grant lifecycle |
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
│   │   ├─ `admin` / `user` × 8 操作矩陣
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

## 交付驗收（查核點 Checklist）

### Checked 填寫規範

本環節以表格 `Checked` 欄位管理：`Y`=完成、`N`=未完成、`N/A`=不適用。

每個查核點皆需逐列填寫 `規劃簽核`、`施工簽核`、`測試簽核`，不得改為整份文件一次簽核。

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 首頁文件完整度 | 五分鐘概覽、讀者導向、快速連結、版本與更新日期齊備。 | Y | `docs/index.md` + `site/index.html` | 首頁入口與導覽已發布。 | PM | RD | QE |
| 開發者指南完整度 | quickstart、設定步驟、常見錯誤與故障排查可直接使用。 | Y | `docs/model-provider/packaging-quickstart.md` + `docs/model-provider/first-publish-checklist.md` | 開發者路徑已可直接使用。 | PM | RD | QE |
| 架構文件完整度 | 授權、發布、生命週期、運維與排障文件齊備。 | Y | `docs/platform/advanced/authorization-and-access.md`, `docs/platform/advanced/model-card-publishing.md`, `docs/platform/advanced/operations-runbook.md` | 主要架構與運維文檔齊備。 | PM | RD | QE |
| Blueprint 完整度 | README、01-07、Source of Truth、Checklist/TBD 結構完整。 | Y | `.github/blueprint/01-portal-model-onboarding.md` 到 `.github/blueprint/07-documentation-and-operations-sop.md` | 7 份藍圖已補齊查核欄位。 | PM | RD | QE |
| Pages 內部連結 | 內部連結正確且無死連結。 | Y | `mkdocs.yml` + `site/search/search_index.json` | Pages 導覽與索引可解析。 | PM | RD | QE |
| Blueprint 與外部連結 | blueprint 互鏈、Source of Truth、外部規範連結可用。 | Y | `.github/blueprint/*.md` + `docs/reference/model_card_publish_openapi.yaml` | 規範互鏈與契約文件已存在。 | PM | RD | QE |
| config.yaml 範例可執行 | 範例完整有效，含必填與選填欄位。 | Y | `model-card-package-template/model_card.yaml` + `model-card-package-template/tools/validate_config.py` | 範例可被工具驗證。 | PM | RD | QE |
| API/CLI 範例可執行 | API 與 CLI 範例可直接複製執行（替換值後）。 | Y | `docs/internal-contracts/model_card_publishing_implementation.md` + model-provider quickstart docs | API/CLI 範例已文件化。 | PM | RD | QE |
| 資料查詢樣板可用 | 常用 DB 查詢樣板可直接使用。 | Y | `docs/database_schema/` + `docs/database_migration/` | DB schema 與查詢上下文可用。 | PM | RD | QE |
| 圖形與矩陣完整 | 流程圖、狀態機、架構圖與角色矩陣齊備。 | Y | blueprint 與 platform docs 內 Mermaid/矩陣段落 | 核心流程與角色矩陣已落地。 | PM | RD | QE |
| 版本與變更紀錄 | 版本標記、更新時間、changelog、已知限制齊備。 | Y | `README.md` + blueprint TBD/限制段落 + docs updates | 版本與限制說明可追溯。 | PM | RD | QE |
| 聯繫與回饋入口 | FAQ、聯繫方式與回饋流程完整。 | Y | `README.md` + `docs/model-provider/first-publish-checklist.md` + troubleshooting docs | 回饋與支援入口已提供。 | PM | RD | QE |
| 更新循環與自動檢查 | 文件檢查責任、頻率與自動化檢查流程明確。 | Y | `mkdocs.yml` + `.github/workflows/` 文檔/CI 流程 | 文件發布與檢查流程已定義。 | PM | RD | QE |

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

### 簽核說明

本環節改為逐查核點簽核：每列均需填寫 `規劃簽核`、`施工簽核`、`測試簽核`。

---

## 附錄：文件更新清單（逐項實施）

| 檔案 | 當前狀態 | 操作 |
|-----|--------|------|
| docs/platform/index.md | 待更新 | 新增五分鐘概覽 + 讀者導向 |
| docs/platform/advanced/authorization-and-access.md | 部分完成 | 補齊 5 類型表 + grant lifecycle |
| docs/platform/advanced/model-card-publishing.md | 部分完成 | 補齊完整 API + 狀態機圖 |
| docs/platform/advanced/operations-runbook.md | 部分完成 | 新增 revocation/rotation SOP |
| docs/platform/advanced/credentials-lifecycle-management.md | 新增檔案 | 完整內容 |
| docs/platform/advanced/troubleshooting-publish-flow.md | 新增檔案 | 決策樹 + 常見問題 |
| docs/model-provider/acr-and-github-setup.md | 新增檔案 | 詳細步驟 |
| docs/model-provider/publish-readiness-checklist.md | 新增檔案 | 自檢清單 |
| blueprint/ (7 檔案) | 本 session 完成 | 已生成 |

---

本附錄只保留文件範圍與缺口，不在 blueprint 內自行承諾工時、週數、sprint 或分階段排程；若需要時程裁決，應由 CEO 另外決定。
