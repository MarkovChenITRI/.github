# 環節 04：GitHub Actions 驗收管線

## 簡述

定義 publish-model-card.yml workflow 如何執行容器鏡像的多階段構建、OCI manifest 驗証、推送到 ACR、簽署與標記、最後觸發 callback 回報。本環節在 GitHub Actions 層執行，產出可驗證的 image URI、digest、labels。

---

## 元件責任邊界

| 元件 | 責任 | 不負責 |
|-----|------|--------|
| **Dockerfile 構建** | 多階段編譯 (builder → runtime)；.so guard 編譯 | 具體的 ML 模型邏輯（model 層） |
| **OCI Manifest 讀取** | 取得鏡像 digest, manifest, config | Docker registry API 實裝（Docker daemon） |
| **ACR Push** | 認証、推送、驗証推送成功 | ACR 帳戶管理、credential 輪替 |
| **OCI Labels 驗証** | 檢查鏡像 labels 與預期一致 | Labels 值產出邏輯（屬環節 03） |
| **Callback 觸發** | 組裝 payload、簽署、POST 到 callback URL | Callback 接收與驗証（屬環節 05） |

---

## 依賴方向

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

## Public API Contract

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

## 查核清單（Checklist）

### Workflow 基本結構

- [ ] **Trigger 條件**：workflow 在 push to main / PR / manual_dispatch 時觸發
- [ ] **Runtime 環境**：使用 ubuntu-latest (或指定版本，確保 Docker 與 Azure CLI 可用)
- [ ] **Step 順序**：
  1. Checkout
  2. Setup Docker (if needed)
  3. Preflight (環節 03)
  4. Build image
  5. Push to ACR
  6. Extract image info
  7. Verify labels
  8. Trigger callback
  9. (Optional) Upload logs

### Dockerfile 構建

- [ ] **多階段構建**：
  - Builder stage：編譯 .so guard module、安裝構建工具
  - Runtime stage：基礎鏡像（python:3.11 或類似）+ .so + python app
- [ ] **Builder stage 完整性**：
  - 安裝編譯工具 (gcc, python-dev 等)
  - Clone 與編譯 guard module (.so)
  - 生成 artifact 供 runtime stage 複製
- [ ] **Runtime stage 完整性**：
  - 使用精簡的基礎鏡像 (避免包含構建工具)
  - COPY .so 與 app 代碼
  - ENTRYPOINT 指向 main.py 或 app 入口
- [ ] **OCI Labels 設置**：Dockerfile 中使用 ARG 傳遞 labels（由 workflow 注入）
- [ ] **License Key 處理**：Runtime 支援 AIHUB_LICENSE_KEY 環境變數注入（不硬編碼）

### ACR Push 步驟

- [ ] **認証**：使用 AIHUB_ACR_USERNAME 與 AIHUB_ACR_PASSWORD 登入 ACR
- [ ] **Push 命令**：`docker push $IMAGE_URI` 成功
- [ ] **Retry 邏輯**：push 失敗時重試 3 次（exponential backoff）
- [ ] **Push 成功驗証**：確認 image 在 ACR 中可拉取

### Image Metadata 提取

- [ ] **Digest 計算**：使用 Docker 或 ACR API 取得完整 image digest (sha256:...)
- [ ] **Manifest 取得**：pull image config，讀取 config.json 中的 labels 欄位
- [ ] **OCI Labels 驗証**：
  - 檢查所有預期 labels 存在
  - 檢查值與環境變數一致
  - 例如：labels['model-id'] == AIHUB_CARD_ID
- [ ] **完整性檢查**：若 label 缺漏或值不匹配，記錄警告（不中止 workflow，由環節 05 決定接受/拒絕）

### Callback 觸發

- [ ] **Payload 組裝**：
  ```json
  {
    "publish_grant_id": env.AIHUB_PUBLISH_GRANT_ID,
    "build_status": "success" | "failure",
    "image_uri": "$ACR/$REPO:$TAG",
    "image_digest": "sha256:...",
    "image_labels_json": JSON.stringify(labels),
    "workflow_run_url": github.server_url + github.repository + ...
  }
  ```
- [ ] **簽章計算**：`HMAC-SHA256(JSON.stringify(payload), env.AIHUB_CALLBACK_TOKEN)`
- [ ] **Header 設置**：
  - `Authorization: Bearer $CALLBACK_TOKEN`
  - `X-Callback-Signature: <簽章>`
  - `Content-Type: application/json`
- [ ] **POST 發送**：使用 curl 或 GitHub Action (如 `dawidd6/action-send-webhook`) 發送
- [ ] **Response 處理**：記錄 HTTP status；若失敗記錄日誌但不中止 workflow

### 錯誤處理

- [ ] **Preflight 失敗**：中止 workflow，不進行後續步驟
- [ ] **Build 失敗**：標記 build_status=failure；若啟用失敗 callback，發送 status=failure + logs_url
- [ ] **Push 失敗**：重試 3 次；若全部失敗，標記 build_status=failure
- [ ] **Label 驗証失敗**：記錄警告；發送 callback 並在 image_labels_json 中標記驗証失敗
- [ ] **Callback 失敗**：記錄日誌，不重試（允許手動觸發）

### 監測與日誌

- [ ] **監測指標**：
  - workflow 執行次數
  - build 成功率
  - push 成功率
  - callback 送達率 (workflow 層送出 ≠ Platform 層接收，但可追蹤)
  - 平均 build 耗時
- [ ] **日誌記錄**：
  - Build step 時間戳
  - Docker build 日誌（partial；不洩露 secrets）
  - Push 命令執行時間
  - Digest 與 labels 值
  - Callback 請求與回應狀態

### 文件與培訓

- [ ] **Workflow README**：publish-model-card.yml 執行流程、輸入/輸出、常見失敗原因
- [ ] **Dockerfile 註解**：各 stage 用途、.so 編譯步驟、OCI labels 設置方式
- [ ] **故障排查**：常見失敗（build fail, push fail, label mismatch）與調試步驟
- [ ] **回傳 log**：當 callback 失敗時，workflow log 包含 payload 與簽章（用於調試）

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

**查核完成日期**：_____________  
**完成者**：_____________  
**審核者**：_____________  
