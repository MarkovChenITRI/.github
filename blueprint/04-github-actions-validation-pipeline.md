# 環節 04：GitHub Actions 驗收管線

## 簡述

定義 publish-model-card.yml workflow 如何執行容器鏡像的多階段構建、OCI manifest 驗証、推送到 ACR、簽署與標記、最後觸發 callback 回報。本環節在 GitHub Actions 層執行，產出可驗證的 image URI、digest、labels。

## 啟動

| 項目 | 啟動標準 |
| --- | --- |
| Pipeline 觸發條件 | `publish-model-card` workflow 可由版本或手動觸發。 |
| 機密就緒 | AIHUB_ACR_*、AIHUB_CALLBACK_* secrets 已配置。 |
| 依賴就緒 | 03 preflight 能通過，且 OCI labels 產生器可執行。 |

---

## 規劃

### 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Dockerfile 構建** | 多階段編譯 (builder → runtime)；.so guard 編譯 | 具體的 ML 模型邏輯（model 層） |
| **OCI Manifest 讀取** | 取得鏡像 digest, manifest, config | Docker registry API 實裝（Docker daemon） |
| **ACR Push** | 認証、推送、驗証推送成功 | ACR 帳戶管理、credential 輪替 |
| **OCI Labels 驗証** | 檢查鏡像 labels 與預期一致 | Labels 值產出邏輯（屬環節 03） |
| **Callback 觸發** | 組裝 payload、簽署、POST 到 callback URL | Callback 接收與驗証（屬環節 05） |

---

### 依賴方向

```
GitHub Actions Workflow (publish-model-card.yml)
    ├─→ Checkout & Setup
    ├─→ Preflight 檢查 (環節 03)
    ├─→ Docker Build
    │   ├─→ Builder Stage (compile .so)
    │   └─→ Runtime Stage (base image + .so + python)
    ├─→ Push to ACR
    │   ├─→ ACR 認証 (AIHUB_ACR_USERNAME/PASSWORD)
    │   └─→ Docker push
    ├─→ Extract Image Info
    │   ├─→ Get image digest (sha256:...)
    │   ├─→ Get OCI labels
    │   └─→ Get manifest
    ├─→ Verify OCI Labels
    │   └─→ Compare with expected values
    └─→ Trigger Callback
        ├─→ Build payload
        ├─→ Sign with AIHUB_CALLBACK_TOKEN (HMAC-SHA256)
        └─→ POST to AIHUB_CALLBACK_URL
```

---

## 執行（真的要施工的細部規格）

### Public API Contract

### Workflow Input (from GitHub environment)

```yaml
env:
  # Variables (from GitHub Repository settings)
  AIHUB_ACR_LOGIN_SERVER: ${{ vars.AIHUB_ACR_LOGIN_SERVER }}
  AIHUB_IMAGE_REPOSITORY: ${{ vars.AIHUB_IMAGE_REPOSITORY }}
  AIHUB_IMAGE_TAG: ${{ vars.AIHUB_IMAGE_TAG }}
  AIHUB_CARD_ID: ${{ vars.AIHUB_CARD_ID }}
  AIHUB_PUBLISH_GRANT_ID: ${{ vars.AIHUB_PUBLISH_GRANT_ID }}
  AIHUB_CALLBACK_URL: ${{ vars.AIHUB_CALLBACK_URL }}
  
  # Secrets (from GitHub Repository secrets)
  AIHUB_ACR_USERNAME: ${{ secrets.AIHUB_ACR_USERNAME }}
  AIHUB_ACR_PASSWORD: ${{ secrets.AIHUB_ACR_PASSWORD }}
  AIHUB_CALLBACK_TOKEN: ${{ secrets.AIHUB_CALLBACK_TOKEN }}
  AIHUB_TEST_LICENSE_KEY: ${{ secrets.AIHUB_TEST_LICENSE_KEY }}
```

### Workflow Output (Artifacts & Callback)

**Image URI**：
```
${{ env.AIHUB_ACR_LOGIN_SERVER }}/${{ env.AIHUB_IMAGE_REPOSITORY }}:${{ env.AIHUB_IMAGE_TAG }}
```

**Image Digest**（SHA256）：
```
sha256:abc123def456...
```

**OCI Labels**（在 image 中儲存）：
```json
{
  "model-version": "0.1.0",
  "model-id": "echo-model",
  "model-owner": "example-vendor",
  "model-task": "chat-completion",
  "publish-grant-id": "grant-uuid-5678",
  "aihub.model-version": "0.1.0",
  "aihub.card-id": "echo-model"
}
```

### Callback Payload（POST to AIHUB_CALLBACK_URL）

```json
{
  "publish_grant_id": "grant-uuid-5678",
  "build_status": "success",
  "image_uri": "model-cards.azurecr.io/model-cards/echo-model:0.1.0",
  "image_digest": "sha256:abc123def456...",
  "image_labels_json": "{\"model-version\": \"0.1.0\", ...}",
  "workflow_run_url": "https://github.com/owner/repo/actions/runs/12345",
  "workflow_logs_url": "https://github.com/owner/repo/actions/runs/12345/attempts/1"
}
```

**Callback Header**：
```
Authorization: Bearer ${{ secrets.AIHUB_CALLBACK_TOKEN }}
X-Callback-Signature: HMAC-SHA256(payload, token)
Content-Type: application/json
```

---

## 資料流與狀態

### Build Success Path

```
Checkout ✓
  ↓
Preflight ✓ (環節 03 檢查通過)
  ↓
Docker Build ✓ (所有 stage 成功)
  ↓
Push to ACR ✓ (image 推送成功)
  ↓
Extract Digest ✓ (取得 SHA256)
  ↓
Verify Labels ✓ (OCI labels 一致)
  ↓
Trigger Callback ✓ (payload 簽署後送出)
  ↓
[workflow_status = success]
```

### Build Failure Path

```
Checkout ✓
  ↓
Preflight ✗ (環變缺漏)
  ↓
[workflow_status = cancelled] → Callback 可選擇不送或送 status=cancelled
  
OR

Docker Build ✗ (編譯失敗)
  ↓
[workflow_status = failure] → Callback 送 status=failure + logs_url
```

---

## 不變式（Invariants）

1. **Image URI 格式一致**  
   `$ACR_LOGIN_SERVER / $IMAGE_REPOSITORY : $IMAGE_TAG`  
   其中 IMAGE_TAG 必與 config.yaml model.version 相同。

2. **Digest 必為 OCI 標準格式**  
   `sha256:` 前綴 + 64 個十六進位字元。

3. **OCI Labels 必完全存儲在 image 中**  
   不放在 layer metadata，而是 image config 的 labels 欄位（Docker inspect 可見）。

4. **Callback 簽章必使用 HMAC-SHA256**  
   `X-Callback-Signature = HMAC-SHA256(json_payload, callback_token)`。

5. **Workflow Log 不可洩露 Secrets**  
   GitHub Actions 自動遮蔽 ${{ secrets.* }} 值；無額外 echo 秘密邏輯。

---

## 邊界條件（Boundary Conditions）

### 支持

- ✅ CPU 與 CUDA 兩種 runtime 環境
- ✅ 多階段 Dockerfile 構建（builder stage + runtime stage）
- ✅ .so guard module 編譯與注入
- ✅ Callback 失敗時記錄日誌，但不中止 workflow（允許手動重試）
- ✅ Build success 時自動觸發 callback；build failure 時可選擇性觸發

### 不支持

- ❌ 多架構鏡像（only AMD64；ARM 支援屬二期）
- ❌ Image 跨 registry push（只支援 AIHUB_ACR_LOGIN_SERVER）
- ❌ Callback 重試機制（GitHub Actions 層無重試；若需要屬環節 06）
- ❌ Image signature（cosign / notary；當前無簽署機制）

---

## Source of Truth

| 項目 | 位置 | 備註 |
|-----|------|------|
| Workflow 定義 | [model-card-package-template/.github/workflows/publish-model-card.yml](../../../model-card-package-template/.github/workflows/publish-model-card.yml) | 完整 workflow |
| Dockerfile | [model-card-package-template/Dockerfile](../../../model-card-package-template/Dockerfile) | 多階段構建配置 |
| OCI Labels 產出 | [model-card-package-template/tools/generate_oci_labels.py](../../../model-card-package-template/tools/generate_oci_labels.py) | labels 產生邏輯 |
| ACR 推送邏輯 | 標準 Docker push + ACR auth | Docker daemon 與 GitHub Actions 整合 |

---

## 待確認項（TBD）

1. **Image 簽署與驗証**  
   - 未來是否使用 cosign 或 notary 簽署 image？
   - 當前無簽署機制；屬二期安全加固
   - **決策方**：安全審查 / PM
   - **Priority**：P2

2. **Callback 失敗重試**  
   - 若 callback POST 失敗（網路超時、HTTP 5xx），是否自動重試？
   - 當前無重試；若需要可在環節 06 或此層加 exponential backoff
   - **決策方**：RD / QE（可靠性決策）
   - **Priority**：P2

3. **Build Log 保留期限**  
   - GitHub Actions log 預設 90 天；是否外傳至長期儲存 (如 Azure Blob Storage)？
   - **決策方**：Infrastructure / PM
   - **Priority**：P2

---

## 交付驗收（查核點 Checklist）

### Checked 填寫規範

本環節以表格 `Checked` 欄位管理：`Y`=完成、`N`=未完成、`N/A`=不適用。

每個查核點皆需逐列填寫 `規劃簽核`、`施工簽核`、`測試簽核`，不得改為整份文件一次簽核。

| 查核點 | 完成條件 | Checked | 證據 | 備註 | 規劃簽核 | 施工簽核 | 測試簽核 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Workflow 觸發與執行順序 | 觸發條件、runtime 與 step 順序符合設計。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` | workflow 觸發條件與 step 序已落地。 | PM | RD | QE |
| Docker 多階段構建 | builder/runtime 分層清楚，runtime 不含多餘構建工具。 | Y | `model-card-package-template/Dockerfile` | 多階段構建已實作。 | PM | RD | QE |
| OCI Labels 注入 | labels 透過 workflow 注入且格式合法。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` + `tools/generate_oci_labels.py` | workflow 以 labels args 注入。 | PM | RD | QE |
| License Key 注入策略 | runtime 以環境變數注入，無硬編碼。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` + `model-card-package-template/README.md` | 以 secret/env 注入。 | PM | RD | QE |
| ACR 認證與 Push | ACR 登入、push 成功，失敗具重試機制。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` | ACR login + push 步驟已配置。 | PM | RD | QE |
| Image Metadata 提取 | digest、manifest、labels 能穩定提取。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` | digest 與 labels 提取步驟存在。 | PM | RD | QE |
| OCI Labels 驗證 | 必要 labels 存在且值與環境變數一致。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` + `validate-model-card-container.yml` | labels 檢查已自動化。 | PM | RD | QE |
| Callback Payload 與簽章 | payload 欄位完整，HMAC 簽章與 header 正確。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` + `utils/model_card/publishing.py` | callback token/HMAC 契約一致。 | PM | RD | QE |
| Callback 發送與回應處理 | callback 可送出並可追蹤 response，失敗有可查日誌。 | Y | `model-card-package-template/.github/workflows/publish-model-card.yml` + `docs/model-provider/publish-evidence.md` | 回應與失敗路徑可追蹤。 | PM | RD | QE |
| 錯誤分支處理 | preflight/build/push/label/callback 失敗分支處理一致。 | Y | `model-card-package-template/.github/workflows/validate-model-card-container.yml` + troubleshooting docs | 失敗分支有統一處理策略。 | PM | RD | QE |
| 監測與日誌 | workflow 指標齊備，日誌不洩露秘密且可追溯。 | Y | GitHub Actions run logs + `model-card-package-template/docs/troubleshooting.md` | logs 可追溯且 secrets 遮蔽。 | PM | RD | QE |
| 文件與故障排查 | workflow 說明、Dockerfile 註解與故障排查可直接落地。 | Y | `model-card-package-template/README.md` + `model-card-package-template/docs/troubleshooting.md` | 操作與排障文件可直接使用。 | PM | RD | QE |

---

## 依賴於此環節的下游

| 下游環節 | 依賴點 | 需求 |
|---------|--------|------|
| **環節 05** (Callback 處理器) | Image URI、Digest、OCI Labels、Callback Payload | 簽章驗証、ACR artifact 驗証 |
| **環節 07** (Pages 文件) | Workflow 說明、故障排查 | 完整文件化供開發者調試 |

---

## 關鍵決策總結

| 決策項 | 當前值 | 理由 | 變更影響 |
|--------|--------|------|---------|
| 多階段構建 | 強制 | 減小 runtime image 大小；隱藏構建邏輯 | 若改單階段，image 大小增加 |
| Callback 重試 | 無（workflow 層） | 簡化邏輯；可靠性由平台層保障 | 若加重試，workflow 複雜度增加 |
| Image 簽署 | 無（當前） | MVP 不強制簽署 | 若加簽署，額外 workflow step |
| Build Log 保留 | GitHub Actions 默認 (90天) | 成本與便利平衡 | 若需更長保留，需外傳儲存 |

---

### 簽核說明

本環節改為逐查核點簽核：每列均需填寫 `規劃簽核`、`施工簽核`、`測試簽核`。
