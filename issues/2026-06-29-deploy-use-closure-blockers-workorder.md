# [Work Order] Deploy-and-Use 關單阻塞修正施工單

- Work Order ID: WO-2026-06-29-04
- 日期: 2026-06-29
- Stream ID: consumer
- 範圍: deploy-and-use closure blockers
- 來源: FAE 複檢結論 + `/site-reliability-engineer` + `/usability-test-coordinator`
- 目前狀態: Blocked on external participants
- 目前階段: port 契約與 closure gate normalization 完成；真人 findings 待補
- 下一位 owner: usability-test-coordinator

## 1) Issue Classification

產品型 feedback。這不是新的藍圖需求，而是既有 deploy-and-use 工程在複檢後被確認仍有 closure blockers，需要重新收斂成單一施工單處理。

## 2) Reproduction Status

1. 發證契約主線與 provider template 主線已不再是目前 blocker，本單不再追蹤。
2. deploy-and-use 主線原始疑慮 1-4 大致已有回應，不再拆成獨立舊工單。
3. 目前仍可重現的 blocker 僅剩一類：
   - 真人 usability findings 尚未取得
4. 已於本輪修正並完成簽核的項目：
   - deploy port / gateway 契約不一致
   - 工單 gate / signoff / veto 狀態互相矛盾

## 3) Frozen Input Contract

1. 複檢證據來源
   - `docs/model-provider/packaging-quickstart.md`
   - `docs/model-provider/deploy-usability-test-protocol.md`
   - `model-card-package-template/README.md`
   - `model-card-package-template/docs/troubleshooting.md`
   - `model-card-package-template/Dockerfile`
   - `model-card-package-template/docker-compose.open-webui.yml`
2. FAE 複檢結論來源
   - `/site-reliability-engineer` read-only review
   - `/usability-test-coordinator` read-only review
3. 不在本單內處理
   - grant contract backend feature
   - provider publish workflow feature
   - 編造真人 findings 取代真人測試

## 4) Findings

### `BLK-01` Deploy port / gateway 契約不一致

- 分類: bug / operability
- 現況: consumer quickstart 使用 `8080:80` 與 container port `80` 的敘述，但 template README、Dockerfile、compose 與 runtime 行為走 `8080`。
- 風險: 首次部署、升版驗證、回滾驗證會走到不同指令與不同 port 假設。
- owner: `architecture-research-developer` + `senior-software-engineer` + `documentation-experience-manager`
- 目前狀態: Resolved
- 完成證據: `docs/model-provider/packaging-quickstart.md`、`docs/model-provider/integration/api.md`、`docs/reference/model_card_containerization_standard.md`、`docs/deployer/container-startup.md` 已全部對齊為 container 內 `80`。

### `BLK-02` 工單 closure state 自相矛盾

- 分類: process / acceptance bug
- 現況: 原工單同時存在 `VERIFY-USR-* Pending`、`QE 維運簽核 Completed`、`veto_status fail`。
- 風險: FAE 無法給 closure recommendation，PM / QE / RD 也會誤判是否可關單。
- owner: `site-reliability-engineer` + `field-application-engineer`
- 目前狀態: Resolved
- 完成證據: 舊三張工單已清除，改由本單統一追蹤；本單內的 blocker、階段、owner 與 `veto_status` 已對齊為單一 truth。

### `BLK-03` 真人 usability findings 缺席

- 分類: validation blocker
- 現況: protocol 已有，但 findings package 尚未取得；不能用 AI 模擬或文件完成度取代。
- 風險: 不能宣稱 naive user 真能只拿金鑰完成部署與使用。
- owner: `usability-test-coordinator` + CEO

## 5) Owner Matrix

| 階段 | Owner | 交付物 |
|------|-------|--------|
| 架構收斂 | architecture-research-developer | 單一 deploy port / gateway 契約 |
| 施工實作 | senior-software-engineer | template runtime / compose / docs 對齊變更 |
| 文件回寫 | documentation-experience-manager | 唯一 deploy 指令與驗證路徑 |
| 維運驗收 | site-reliability-engineer | operability gate truth 與 rollback 驗證證據 |
| Issue closure | field-application-engineer | closure recommendation、狀態對齊、metrics 回寫 |
| 真人驗收 | usability-test-coordinator | findings package |
| 外部資源提供 | CEO | beta 名單或真人受測管道 |

## 5.5) 施工狀態

| Action | Owner | 狀態 | 說明 |
|------|-------|------|------|
| `ACT-01` | architecture-research-developer + senior-software-engineer + documentation-experience-manager | Completed | deploy port / gateway 文件與相鄰契約已對齊為 host `8080` -> container `80` |
| `ACT-02` | site-reliability-engineer + field-application-engineer | Completed | closure gate truth 已重整到本單，舊矛盾工單已清除 |
| `ACT-03A` | CEO | Blocked | 尚未提供真人受測者管道、beta 名單或招募資源 |
| `ACT-03B` | usability-test-coordinator | Blocked | 缺可追溯真人 findings package 與原始記錄 |

## 6) Action Items

### `ACT-01` 對齊 deploy port / gateway 真相源

- Owner: `architecture-research-developer` + `senior-software-engineer` + `documentation-experience-manager`
- 輸入資料:
  - `docs/model-provider/packaging-quickstart.md`
  - `model-card-package-template/README.md`
  - `model-card-package-template/Dockerfile`
  - `model-card-package-template/docker-compose.open-webui.yml`
- 完成條件: container 內 gateway port 與所有 deploy / verify / Open WebUI 文件敘述一致，只保留一個契約。
- 驗證方式: 同一組指令可完成 `docker run`、`/healthz`、`/v1/models`、一次推論與 Open WebUI 連線。
- 狀態: Completed

### `ACT-02` 對齊 closure gate truth

- Owner: `site-reliability-engineer` + `field-application-engineer`
- 輸入資料:
  - 本工單
  - 原本 `.github/issues` 舊單的 closure 欄位矛盾點
- 完成條件: 驗收 gate、簽核表、blocker、current、trend、`veto_status` 不再互相矛盾。
- 驗證方式: FAE 能依同一份工單給出單一 closure recommendation，不需額外口頭補充。
- 狀態: Completed

### `ACT-03A` 提供真人受測管道

- Owner: `CEO`
- 輸入資料:
   - `docs/model-provider/deploy-usability-test-protocol.md`
   - 本工單的 closure criteria 與 blocker 狀態
- 完成條件: 提供可實際執行的受測者來源，例如 beta 名單、測試平台、招募預算或內部非核心維護者名單。
- 驗證方式: 工單內可列出受測者管道來源、可聯絡狀態與預定測試批次。
- 狀態: Blocked

### `ACT-03B` 補齊真人 usability findings

- Owner: `usability-test-coordinator`
- 輸入資料:
  - `docs/model-provider/deploy-usability-test-protocol.md`
  - deploy-and-use 文件與真實測試環境
- 完成條件: 至少產出一份可追溯的 findings package，包含受測者輪廓、樣本量、任務完成率、卡點、情緒訊號與分流 owner。
- 驗證方式: findings package 能對應 protocol 的輸出欄位，且有原始記錄來源。
- 狀態: Blocked on `ACT-03A`

## 7) Verification Evidence Required

1. 冷啟動部署證據
   - 同一組 deploy 指令、`/healthz`、`/v1/models`、一次推論與 Open WebUI 連線紀錄。
2. Operability 證據
   - 升版與回滾演練紀錄，且指令與文件一致。
3. Usability 證據
   - 真人 findings package；protocol 本身不算 findings。
4. Issue closure 證據
   - 工單內 signoff、gate、metrics、blocker、`veto_status` 一致。

## 7.6) 真人 Findings 填寫表

本區塊是 SOP3 驗收證據的一部分。真人測試完成後，請直接在本工單內回填摘要；原始錄影、逐字稿、表單回覆或訪談筆記請保存在受控位置，並在本區塊填入可追溯位置。未填完本區塊，不得宣稱 `BLK-03` 已解除。

### A. 測試批次摘要

| 欄位 | 填寫內容 |
|------|----------|
| 測試批次 ID | `UT-YYYYMMDD-01` |
| 測試日期 | `YYYY-MM-DD` |
| 主持人 | `usability-test-coordinator` 或指定主持人姓名 |
| 受測者來源 | beta 名單 / 內部非核心維護者 / 外部測試平台 |
| 測試環境 | Windows / WSL2 / Linux / 其他；主機硬體與 runtime 摘要 |
| 原始紀錄位置 | 錄影、逐字稿、表單、筆記所在受控位置 |
| 樣本量 | 共 `__` 人；有效樣本 `__` 人 |
| 已知偏誤 | 例如 Docker 熟練度偏高、皆為內部人員、皆使用同一硬體 |

### B. 受測者輪廓總表

| 受測者代號 | 是否第一次接觸 AI Hub | Docker 熟悉度 | 是否熟悉 env var / HTTP | 作業系統 / Host | 備註 |
|------------|------------------------|---------------|---------------------------|------------------|------|
| `P01` | 是 / 否 | 低 / 中 / 高 | 低 / 中 / 高 | `Windows 11 + Docker Desktop` | - |
| `P02` | 是 / 否 | 低 / 中 / 高 | 低 / 中 / 高 | `Ubuntu 24.04` | - |

### C. 任務結果總表

| 受測者代號 | Task 1 憑證分辨 | Task 2 首次部署 | Task 3 一次推論 | Task 4 修正金鑰誤用 | Task 5 升版 / 回滾理解 | 求助次數 | 備註 |
|------------|------------------|-----------------|------------------|----------------------|------------------------|----------|------|
| `P01` | 成功 / 失敗 | 成功 / 失敗 | 成功 / 失敗 | 成功 / 失敗 | 成功 / 失敗 | `__` | - |
| `P02` | 成功 / 失敗 | 成功 / 失敗 | 成功 / 失敗 | 成功 / 失敗 | 成功 / 失敗 | `__` | - |

### D. 逐受測者觀察記錄

請每位受測者各複製一份。

#### 受測者 `P__`

| 欄位 | 填寫內容 |
|------|----------|
| 受測者代號 | `P__` |
| 測試日期 | `YYYY-MM-DD` |
| 任務 1 是否完成 | 是 / 否 |
| 任務 1 完成時間 | `__ 分 __ 秒` |
| 任務 1 卡點 | 例如把 `AIHUB_CALLBACK_TOKEN` 當 runtime key |
| 任務 1 原話 / 情緒訊號 | 例如「我不知道這個 key 要填 GitHub 還是容器」 |
| 任務 2 是否完成 | 是 / 否 |
| 任務 2 完成時間 | `__ 分 __ 秒` |
| 任務 2 卡點 | - |
| 任務 2 原話 / 情緒訊號 | - |
| 任務 3 是否完成 | 是 / 否 |
| 任務 3 完成時間 | `__ 分 __ 秒` |
| 任務 3 卡點 | - |
| 任務 3 原話 / 情緒訊號 | - |
| 任務 4 是否完成 | 是 / 否 |
| 任務 4 完成時間 | `__ 分 __ 秒` |
| 任務 4 卡點 | - |
| 任務 4 原話 / 情緒訊號 | - |
| 任務 5 是否完成 | 是 / 否 |
| 任務 5 完成時間 | `__ 分 __ 秒` |
| 任務 5 卡點 | - |
| 任務 5 原話 / 情緒訊號 | - |
| 最不確定的值 | Publish Grant / ACR credential / `AIHUB_LICENSE_KEY` / `OPENAI_API_KEY` / 其他 |
| 最想回頭問維護者的步驟 | - |
| 最難理解的錯誤訊息 | - |
| 下次最想保留的文件 | - |

### E. 缺陷與改善分流

| 類型 | 觀察摘要 | 影響任務 | 建議 owner | 對應檔案 / 區塊 | 優先度 |
|------|----------|----------|------------|------------------|--------|
| 文件問題 | - | Task __ | documentation-experience-manager | `docs/...` | 高 / 中 / 低 |
| 功能缺陷 | - | Task __ | senior-software-engineer | `utils/...` / `app/...` | 高 / 中 / 低 |
| 維運 / 部署問題 | - | Task __ | site-reliability-engineer | workflow / deploy docs | 高 / 中 / 低 |
| 平台流程問題 | - | Task __ | field-application-engineer / product-strategy-manager | issue / status flow | 高 / 中 / 低 |

### F. Closure 用摘要

| 欄位 | 填寫內容 |
|------|----------|
| 有效樣本數 | `__` |
| Task 1 完成率 | `__ / __` |
| Task 2 完成率 | `__ / __` |
| Task 3 完成率 | `__ / __` |
| Task 4 完成率 | `__ / __` |
| Task 5 完成率 | `__ / __` |
| 最主要 3 個卡點 | 1. `...` 2. `...` 3. `...` |
| 是否仍需擴大測試 | 是 / 否 |
| 若需擴大測試，原因 | - |
| `BLK-03` 建議狀態 | Resolved / Partially resolved / Blocked |
| 建議 closure recommendation | close / conditional-close / no-go |

## 7.5) 目前已完成驗證證據

1. Port 契約已對齊
   - `docs/model-provider/packaging-quickstart.md`
   - `docs/model-provider/integration/api.md`
   - `docs/reference/model_card_containerization_standard.md`
   - `docs/deployer/container-startup.md`
2. Template runtime 真相源
   - `model-card-package-template/model_card.yaml`
   - `model-card-package-template/app/entrypoint.py`
   - `model-card-package-template/docker-compose.open-webui.yml`
3. 工單 closure truth 已對齊
   - `.github/issues/README.md`
   - 本工單

## 8) Closure Criteria

1. `BLK-03` 有可追溯真人 findings 證據。
2. FAE 能給 `Closure recommendation: close`，且不再需要口頭保留條件。
3. `veto_status = pass`。

## 9) Unified Metrics Contract

- reporting_week: `2026-W27`
- stream_id: `consumer`
- owner: `architecture-research-developer` / `senior-software-engineer` / `documentation-experience-manager` / `site-reliability-engineer` / `field-application-engineer` / `usability-test-coordinator`
- metric_name: `consumer_deploy_success_rate`
- baseline: `docs and closure package were inconsistent`
- target: `>= 80% first deployment success with traceable real-user findings`
- current: `engineering blockers cleared; only real-user findings remain`
- trend: `up`
- evidence_links: `docs/model-provider/packaging-quickstart.md`, `docs/model-provider/integration/api.md`, `docs/reference/model_card_containerization_standard.md`, `docs/deployer/container-startup.md`, `docs/model-provider/deploy-usability-test-protocol.md`
- blocker: `real-user findings unavailable until CEO provides participant channel`
- veto_status: `fail`