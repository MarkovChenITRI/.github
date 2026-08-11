---
description: "Use when implementing or modifying code under the presentation, application, domain, or infrastructure layers — layer placement rules, dependency direction, and the Implementation SOP."
applyTo: "src/presentation/**, src/application/**, src/domain/**, src/infrastructure/**"
---

# 撰寫與建置（Code、Build）

## 依賴方向

1. 領域層只依賴標準函式庫與同層物件（entity、value object 等）。
2. 基礎設施層實作領域層定義的介面（repository、gateway），完成與外部系統的整合。
3. 應用層依賴領域層的介面與模型；呼叫基礎設施能力時，一律透過依賴反轉呼叫基礎設施層已實作的介面。
4. 使用者介面層透過應用層的 use case 取得資料與觸發行為。
5. 具業務意義的數值（逾時、閾值、上限）寫在專案的設定檔（例如 `.env`、`config.yaml`、`settings.py`）中，程式碼從設定讀取。

## 分層放置規則

### 使用者介面層

1. 這層放：輸入輸出轉換、路由、controller、view、DTO、request 格式驗證。
2. 業務判斷放在應用層或領域層。
3. 透過應用層的 use case 取得資料與觸發行為。
4. 檔案放在 `<專案資料夾>/src/presentation/`（或專案既有的 `interfaces/`、`api/` 慣例），依用途分到 `controllers/`、`views/`、`dto/`、`routes/`。

### 應用層

1. 這層放：use case / application service、交易邊界、呼叫 repository 介面、發送 domain event。
2. 業務規則本體放在領域層。
3. 依賴領域層的介面與模型；資料庫存取與 HTTP client 呼叫的實作放在基礎設施層，這層只透過依賴反轉呼叫它。
4. 檔案放在 `<專案資料夾>/src/application/`，依用途分到 `use-cases/`、`services/`、`dto/`。

### 領域層

1. 這層放：Entity、Value Object、Aggregate、Domain Service、Repository 介面（不是實作）、Domain Event、不變式。
2. 只依賴標準函式庫與同層物件。
3. 不變式用程式碼（例如建構子檢查、setter 檢查）在 entity 或 aggregate 內部強制成立。
4. 檔案放在 `<專案資料夾>/src/domain/`，依用途分到 `entities/`、`value-objects/`、`aggregates/`、`domain-services/`、`repositories/`（介面）、`events/`。

### 基礎設施層

1. 這層放：Repository 實作、外部 API client、訊息佇列、快取、檔案系統、第三方 SDK 整合。
2. 業務規則定義在領域層；這層負責實作領域層定義的 interface。
3. 連線字串、timeout、閾值寫在設定檔中，程式碼從設定讀取。
4. 檔案放在 `<專案資料夾>/src/infrastructure/`，依用途分到 `persistence/`、`external-services/`、`messaging/`。

## src 目錄結構

```text
src/
├── presentation/
│   ├── controllers/
│   ├── views/
│   ├── dto/
│   └── routes/
├── application/
│   ├── use-cases/
│   ├── services/
│   └── dto/
├── domain/
│   ├── entities/
│   ├── value-objects/
│   ├── aggregates/
│   ├── domain-services/
│   ├── repositories/        # 介面
│   └── events/
└── infrastructure/
    ├── persistence/         # repository 實作
    ├── external-services/
    └── messaging/
```

## Implementation SOP

使用者要求新增或修改的程式碼落在使用者介面層、應用層、領域層、基礎設施層其中之一時，走這段：

1. 判斷這次異動屬於哪一層；橫跨多層時，依層拆開，逐層走完下列步驟。
2. 開啟 `<專案資料夾>/.github/specs/<layer>.md`，確認要異動的模組是否已有段落：
   - 沒有段落：呼叫 `/plan` 先建立這個模組的規格，完成後回到這裡繼續。
   - 已有段落：讀取該段落的 What／How，作為這次異動的邊界依據。
3. 依「分層放置規則」，把程式碼放進對應層的正確目錄。
4. 依「依賴方向」確認呼叫路徑：本層依賴誰、被誰依賴，跟規則一致。
5. 這次異動改變了模組的 What、How 或 Where 時，回到 `<專案資料夾>/.github/specs/<layer>.md` 更新對應段落。
