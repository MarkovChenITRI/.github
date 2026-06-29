# 環節 03：模板 Repository 自動化

## 簡述

定義 model-card-package-template 如何自動載入 Portal 下發的 Variables/Secrets、執行環境檢查、產出 OCI labels。本環節在開發者機器或 GitHub Actions 層執行，負責 preflight 檢查、config.yaml 讀取、環境變數驗証。

## 啟動

| 項目 | 啟動標準 |
| --- | --- |
| 輸入資產 | 已取得 `model_card.yaml` 與 AIHUB_* Variables/Secrets。 |
| 最小工具鏈 | 可執行 `python -m tools.preflight` 與 `python -m tools.generate_oci_labels`。 |
| 邊界共識 | 本環節只做自動化檢查與標籤產生，不做推送與 callback。 |

---

## 規劃

### 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Preflight 檢查器** | 驗証 config.yaml 存在、Variables 完整、Secrets 已填 | GitHub Actions 實際執行（屬環節 04） |
| **config.yaml 讀取器** | 解析 yaml；驗証結構；讀取 model_id, model_version 等 | Yaml 版本管理、升級策略（屬環節 07） |
| **OCI Labels 產生器** | 根據 config.yaml 與環境變數產出 Docker 構建參數 | Docker build 實際執行（屬環節 04） |
| **環境變數驗証器** | 檢查 GitHub Variables 與 Secrets 都已設定 | Secret 洩露檢測（屬環節 01） |

---

### 依賴方向

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

## 執行（真的要施工的細部規格）

### Public API Contract

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

## 交付驗收（查核點 Checklist）

### Checked 填寫規範

本環節以表格 `Checked` 欄位管理：`Y`=完成、`N`=未完成、`N/A`=不適用。

每個查核點皆需逐列填寫 `規劃簽核`、`施工簽核`、`測試簽核`，不得改為整份文件一次簽核。

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| config.yaml 存在與結構驗證 | 檔案存在，且四個頂層章節與必填欄位完整。 | Y | `model-card-package-template/tools/validate_config.py` + `model-card-package-template/tests/test_validate_config.py` | 結構檢查已落地。 | PM | RD | QE |
| 欄位格式與對映一致 | 版本、port、task 格式正確，且與指定環境變數一致。 | Y | `model-card-package-template/tools/validate_config.py` | 欄位與環境變數對映已驗證。 | PM | RD | QE |
| Variables 完整性 | 所有必要 Variables 均已設置。 | Y | `model-card-package-template/tools/preflight.py` (`REQUIRED_VARIABLES`) | 缺漏會 fail-fast。 | PM | RD | QE |
| Secrets 完整性與遮蔽 | 必要 Secrets 可取得，且輸出不洩露原文。 | Y | `model-card-package-template/tools/preflight.py` (`REQUIRED_SECRETS`) | secrets 只檢存在、不印原文。 | PM | RD | QE |
| OCI Labels 完整性 | 必要 labels 鍵存在且值正確。 | Y | `model-card-package-template/tools/generate_oci_labels.py` + tests | labels 鍵值由工具統一產生。 | PM | RD | QE |
| OCI Labels 格式合法 | Docker build args / Dockerfile LABEL 格式可用。 | Y | `model-card-package-template/tools/generate_oci_labels.py` (`--format docker-build-args`) | 已提供 build-args 格式輸出。 | PM | RD | QE |
| Labels 來源不硬編碼 | labels 全由 config.yaml 與環境變數驅動。 | Y | `model-card-package-template/tools/generate_oci_labels.py` | 中央化來源，無 Dockerfile 重複硬編碼。 | PM | RD | QE |
| preflight 工具可執行 | `tools.preflight` 可執行且 exit code 正確。 | Y | `model-card-package-template/tools/preflight.py` + CI workflow | preflight 已納入自動化。 | PM | RD | QE |
| labels 工具可執行 | `tools.generate_oci_labels` 可輸出預期格式。 | Y | `model-card-package-template/tools/generate_oci_labels.py` + `model-card-package-template/tests/test_validate_config.py` | 輸出格式已測。 | PM | RD | QE |
| config 驗證工具可執行 | `tools.validate_config --check-publish-env` 可產出驗證結果。 | Y | `model-card-package-template/tools/validate_config.py` + tests | 驗證路徑可執行。 | PM | RD | QE |
| 本機開發支持 | `.env` 支持、`.gitignore` 防洩露、README 操作說明齊備。 | Y | `model-card-package-template/README.md` + `model-card-package-template/docs/github-variables-and-secrets.md` | 本機與 CI 操作路徑已文件化。 | PM | RD | QE |
| 錯誤處理一致 | 錯誤訊息清晰可修復，成功/失敗 exit code 一致。 | Y | `model-card-package-template/tools/preflight.py` + `model-card-package-template/tools/validate_config.py` | 失敗訊息與 exit 行為一致。 | PM | RD | QE |
| 監測與日誌 | 指標可觀測，日誌可追溯 preflight 與 labels 產出。 | Y | `model-card-package-template/.github/workflows/validate-model-card-container.yml` | workflow 保存 preflight/labels 產出。 | PM | RD | QE |
| 文件與故障排查 | 工具說明、欄位註解、操作步驟與故障排查完整。 | Y | `model-card-package-template/docs/provider-workflow.md` + `model-card-package-template/docs/troubleshooting.md` | 開發者排障文件已就位。 | PM | RD | QE |

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

### 簽核說明

本環節改為逐查核點簽核：每列均需填寫 `規劃簽核`、`施工簽核`、`測試簽核`。
