# 環節 03：模板 Repository 自動化

## 簡述

定義 model-card-package-template 如何自動載入 Portal 下發的 Variables/Secrets、執行環境檢查、產出 OCI labels。本環節在開發者機器或 GitHub Actions 層執行，負責 preflight 檢查、config.yaml 讀取、環境變數驗証。

---

## 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Preflight 檢查器** | 驗証 config.yaml 存在、Variables 完整、Secrets 已填 | GitHub Actions 實際執行（屬環節 04） |
| **config.yaml 讀取器** | 解析 yaml；驗証結構；讀取 model_id, model_version 等 | Yaml 版本管理、升級策略（屬環節 07） |
| **OCI Labels 產生器** | 根據 config.yaml 與環境變數產出 Docker 構建參數 | Docker build 實際執行（屬環節 04） |
| **環境變數驗証器** | 檢查 GitHub Variables 與 Secrets 都已設定 | Secret 洩露檢測（屬環節 01） |

---

## 依賴方向

```
Template Repo 開發者機器或 GitHub Actions
    ↓
Preflight 檢查器 (tools/preflight.py)
    ├─→ config.yaml 讀取器
    ├─→ 環境變數驗証器
    └─→ OCI Labels 產生器 (tools/generate_oci_labels.py)
        ↓
GitHub Actions workflow (04 環節使用)
```

---

## Public API Contract

### 1. Preflight 檢查

**Executable**：`python -m tools.preflight`

**執行環境**：開發者機器或 GitHub Actions

**Input**：
- 環境變數：`AIHUB_*` variables from `variables.env`
- 秘密值：`AIHUB_*` secrets from GitHub Secrets (或本機 `.env`)
- config.yaml：repo 根目錄

**Output (Exit Code 0 Success)**：
```
✓ config.yaml found and valid
✓ model_id: echo-model
✓ model_version: 0.1.0
✓ AIHUB_ACR_LOGIN_SERVER: model-cards.azurecr.io
✓ AIHUB_IMAGE_REPOSITORY: model-cards/echo-model
✓ AIHUB_IMAGE_TAG: 0.1.0
✓ AIHUB_CARD_ID: echo-model
✓ AIHUB_PUBLISH_GRANT_ID: grant-uuid-5678
✓ AIHUB_CALLBACK_URL: https://api.example.com/model-card-publish/callback
✓ AIHUB_ACR_USERNAME: ••••••
✓ AIHUB_ACR_PASSWORD: ••••••
✓ AIHUB_CALLBACK_TOKEN: ••••••
✓ AIHUB_TEST_LICENSE_KEY: ••••••

All preflight checks passed. Ready to publish.
```

**Output (Exit Code 1 Failure)**：
```
✗ AIHUB_ACR_LOGIN_SERVER not set
✗ config.yaml model_version does not match AIHUB_IMAGE_TAG

Fix the above issues and try again.
```

---

### 2. 產出 OCI Labels

**Executable**：`python -m tools.generate_oci_labels --format docker-build-args`

**Input**：
- config.yaml
- 環境變數（AIHUB_CARD_ID, AIHUB_PUBLISH_GRANT_ID 等）

**Output (stdout)**：
```
--label="model-version=0.1.0" \
--label="model-id=echo-model" \
--label="model-owner=example-vendor" \
--label="model-task=chat-completion" \
--label="publish-grant-id=grant-uuid-5678" \
--label="aihub.model-version=0.1.0" \
--label="aihub.card-id=echo-model"
```

**Usage in Dockerfile**：
```dockerfile
ARG LABELS
docker build ${LABELS} -t $IMAGE_REGISTRY/$IMAGE_REPOSITORY:$IMAGE_TAG .
```

---

### 3. 驗證 Publish 環境

**Executable**：`python -m tools.validate_config --check-publish-env`

**Input**：
- config.yaml
- 環境變數

**Output**：
```
✓ config.yaml valid
✓ Required fields present: model, deployment, license, image
✓ model_version in config matches AIHUB_IMAGE_TAG
✓ model_id in config matches AIHUB_CARD_ID
✓ All AIHUB_* variables set
Ready to build and push image.
```

---

## 環境變數邊界

### GitHub Variables (可見，不含秘密)

| 變數名 | 來源 | 必須值 | 例子 |
|--------|------|--------|------|
| `AIHUB_ACR_LOGIN_SERVER` | Portal (環節 01) | registry 欄位 | `model-cards.azurecr.io` |
| `AIHUB_IMAGE_REPOSITORY` | Portal 組裝 | owner/model_id 組成 | `model-cards/echo-model` |
| `AIHUB_IMAGE_TAG` | Portal (環節 01) | model_version | `0.1.0` |
| `AIHUB_CARD_ID` | Portal (環節 01) | model_id | `echo-model` |
| `AIHUB_PUBLISH_GRANT_ID` | 環節 02 簽發 | grant ID | `grant-uuid-5678` |
| `AIHUB_CALLBACK_URL` | Portal (環節 01) | 開發者輸入或自動 | `https://api.example.com/model-card-publish/callback` |

### GitHub Secrets (不可見，注入後隱蔽)

| 變數名 | 來源 | 用途 | 例子 |
|--------|------|------|------|
| `AIHUB_ACR_USERNAME` | 環節 02 簽發 | ACR 登入帳號 | `acruser@model-cards` |
| `AIHUB_ACR_PASSWORD` | 環節 02 簽發 | ACR 登入密碼 | `password-hash-xyz` |
| `AIHUB_CALLBACK_TOKEN` | 環節 02 簽發 | Callback 簽章 token | `callback-token-xyz` |
| `AIHUB_TEST_LICENSE_KEY` | 平台配置 | 測試環境 license | `test-key-abc123` |

---

## 不變式（Invariants）

1. **config.yaml 結構必須合法**  
   包含 model, deployment, license, image 四個頂層章節；各章節必填欄位完整。

2. **model_version 與 AIHUB_IMAGE_TAG 一致**  
   config.yaml 中的 model.version 必須等於環境變數 AIHUB_IMAGE_TAG；preflight 檢查時必驗證。

3. **model_id 與 AIHUB_CARD_ID 一致**  
   config.yaml 中的 model.id 必須等於 AIHUB_CARD_ID。

4. **Secrets 不可在 GitHub Actions log 中洩露**  
   Workflow 使用 `${{ secrets.AIHUB_* }}` 注入；print 或 echo secrets 時自動遮蔽。

5. **OCI Labels 必完全由 config.yaml 驅動**  
   不手動維護 Dockerfile 中的 LABEL 指令；只在 tools/generate_oci_labels.py 中產出。

---

## 邊界條件（Boundary Conditions）

### 支持

- ✅ Preflight 檢查可在本機執行（開發者驗證前提交）
- ✅ Preflight 檢查可在 GitHub Actions 中執行（自動驗証）
- ✅ 環境變數可從 .env 檔案讀取（本機開發）
- ✅ Secrets 支援本機 .env 與 GitHub Secrets 雙源
- ✅ OCI Labels 格式支援 Docker build args 與 Dockerfile LABEL

### 不支持

- ❌ config.yaml 動態版本（無 schema version 升級機制）
- ❌ 多個 config.yaml 檔案（只支援 repo 根目錄單一 config.yaml）
- ❌ Secrets 在 GitHub Actions log 中可見（禁止）
- ❌ 自動產出 config.yaml（只有讀取和驗証；產出屬環節 01）

---

## Source of Truth

| 項目 | 位置 | 備註 |
|-----|------|------|
| Preflight 檢查 | [model-card-package-template/tools/preflight.py](../../../model-card-package-template/tools/preflight.py) | 主要檢查邏輯 |
| config.yaml 讀取 | [model-card-package-template/tools/validate_config.py](../../../model-card-package-template/tools/validate_config.py) | yaml 解析與驗証 |
| OCI Labels 產出 | [model-card-package-template/tools/generate_oci_labels.py](../../../model-card-package-template/tools/generate_oci_labels.py) | labels 產生邏輯 |
| Workflow 呼叫 | [model-card-package-template/.github/workflows/publish-model-card.yml](../../../model-card-package-template/.github/workflows/publish-model-card.yml) | 實際執行點 |

---

## 待確認項（TBD）

1. **Preflight 檢查失敗時的 workflow 行為**  
   - 是否應中止後續 build/push 步驟，還是僅警告？
   - **決策方**：RD / QE（失敗策略）
   - **Priority**：P1

2. **secrets.env 檔案管理**  
   - 本機開發時若使用 .env 檔案，是否納入 .gitignore？
   - **決策方**：RD（安全實踐）
   - **Priority**：P1

3. **OCI Labels 格式擴展**  
   - 若未來 ACR 或 Platform 要求新增 labels，是否在 tools/ 中中央化維護？
   - **決策方**：PM / RD（長期規劃）
   - **Priority**：P2

---

## 查核清單（Checklist）

### config.yaml 讀取與驗証

- [ ] **config.yaml 存在檢查**：repo 根目錄必存在 model_card.yaml，若無拒絕並給出提示
- [ ] **YAML 結構驗証**：parse yaml；檢查四個頂層章節 (model, deployment, license, image) 存在
- [ ] **必填欄位驗証**：
  - model: id, name, version, task, sdk_profile
  - deployment: vendor, accelerator, gateway_port
  - license: required, features
  - image: registry
- [ ] **欄位值格式驗証**：model_version 符合 semver；gateway_port 為整數 1-65535；task 在許可清單
- [ ] **config.yaml 與環境變數一致性**：
  - model.version == AIHUB_IMAGE_TAG
  - model.id == AIHUB_CARD_ID
  - image.registry == AIHUB_ACR_LOGIN_SERVER

### 環境變數驗証

- [ ] **Variables 完整性檢查**：
  - AIHUB_ACR_LOGIN_SERVER 已設
  - AIHUB_IMAGE_REPOSITORY 已設
  - AIHUB_IMAGE_TAG 已設
  - AIHUB_CARD_ID 已設
  - AIHUB_PUBLISH_GRANT_ID 已設
  - AIHUB_CALLBACK_URL 已設
- [ ] **Secrets 完整性檢查**：
  - AIHUB_ACR_USERNAME 已設（即使值為空也要存在）
  - AIHUB_ACR_PASSWORD 已設
  - AIHUB_CALLBACK_TOKEN 已設
  - AIHUB_TEST_LICENSE_KEY 已設（可選，但若 license.required=true 建議設）
- [ ] **Secrets 不洩露**：preflight 輸出中不顯示 secret 原文，只顯示 `••••` 或提示「已設」

### OCI Labels 產出

- [ ] **Labels 完整性**：
  - `model-version`: model.version
  - `model-id`: model.id
  - `model-owner`: deployment.vendor
  - `model-task`: model.task
  - `publish-grant-id`: AIHUB_PUBLISH_GRANT_ID
  - `aihub.model-version`: model.version
  - `aihub.card-id`: model.id
- [ ] **Labels 格式**：
  - Docker build args 格式：`--label="key=value"` （必須 URL-safe 或用引號）
  - Dockerfile LABEL 格式：`LABEL key=value` 或 `LABEL key="value"`
- [ ] **Labels 來源**：完全由 config.yaml 與環境變數驅動；無硬編碼

### 工具可執行性

- [ ] **preflight.py 執行**：`python -m tools.preflight` 執行無誤；exit code 反映結果（0=success, 1=failure）
- [ ] **generate_oci_labels.py 執行**：`python -m tools.generate_oci_labels --format docker-build-args` 輸出正確的 Docker 參數
- [ ] **validate_config.py 執行**：`python -m tools.validate_config --check-publish-env` 輸出驗証結果

### 本機開發支持

- [ ] **.env 檔案支持**（可選）：允許開發者在 .env 檔案中設置 Variables 與 Secrets 進行本機測試
- [ ] **.gitignore**：.env 檔案在 .gitignore 中，防止 secrets 洩露
- [ ] **README 說明**：tools/ 目錄或 README 說明如何使用 preflight, 如何在本機設置環境變數

### 錯誤處理

- [ ] **錯誤訊息清晰**：缺漏的環境變數或配置時給出明確提示（「AIHUB_ACR_USERNAME not found」）
- [ ] **建議修正**：錯誤訊息包含如何修正（「Set AIHUB_ACR_USERNAME in GitHub Repository secrets」）
- [ ] **Exit Code**：成功 exit(0)；失敗 exit(1)；無其他異常代碼

### 監測與日誌

- [ ] **監測指標**：
  - preflight 檢查執行次數
  - preflight 失敗計數與失敗原因分佈
  - OCI labels 產出成功率
- [ ] **日誌記錄**：
  - preflight 執行時記錄：timestamp, result (success/failure), failure reasons
  - OCI labels 產出時記錄：labels 清單、版本信息

### 文件與培訓

- [ ] **tools/ README**：說明各工具用途、執行方式、參數、輸出格式
- [ ] **config.yaml 註解**：template 中各欄位有清楚的註解說明必填/選填、允許值
- [ ] **開發者指南**（Pages）：本機執行 preflight 的步驟、在 GitHub 中設置環境變數的步驟
- [ ] **故障排查**：常見環境變數缺漏問題與解決方案

---

## 依賴於此環節的下游

| 下游環節 | 依賴點 | 需求 |
|---------|--------|------|
| **環節 04** (GitHub Actions) | Preflight 檢查結果、OCI Labels 產出 | 檢查需快速完成（<10s）、labels 格式穩定 |
| **環節 07** (Pages 文件) | Tools 說明、環境變數清單 | 完整文件化供開發者參考 |

---

## 關鍵決策總結

| 決策項 | 當前值 | 理由 | 變更影響 |
|--------|--------|------|---------|
| config.yaml 位置 | Repo 根目錄 (固定) | 簡化查找邏輯 | 若支援多個檔案或位置，複雜度增加 |
| Preflight 失敗行為 | 中止 workflow | 確保環境完整再進行後續步驟 | 若改警告，風險增加 |
| OCI Labels 維護點 | tools/generate_oci_labels.py (中央化) | 單一來源；易升級 | 若分散到 Dockerfile，易失同步 |
| Secrets 洩露防護 | GitHub Actions 自動遮蔽 + 工具層不輸出 | 雙層防護 | 若去除任一層，安全性下降 |

---

**查核完成日期**：_____________  
**完成者**：_____________  
**審核者**：_____________  
