# CEO 操作指南

本文件說明 CEO 在 Connect AI 這套協作機制中的工作方式。這是一份給人看的操作文件，不是 agent 規範檔。

如果你是第一次使用這套 runtime，先看本頁；如果你要查正式規則，再看下列真相源：

- `cross-team.instructions.md`：跨部門邊界與 CEO 權限
- `start-to-planning.instructions.md`：SOP1 正式完成條件
- `planning-to-execution.instructions.md`：SOP2 正式完成條件
- `execution-to-verification.instructions.md`：SOP3 正式完成條件

## 你會在這份文件中完成什麼

看完本頁後，你應該能做到三件事：

1. 知道什麼時候該由你出場，什麼時候不該越權接手。
2. 知道如何啟動一個新任務，並讓團隊沿著 SOP1、SOP2、SOP3 往下走。
3. 知道如何提供真人測試、正式環境核准、授權拍板等只有人類能提供的輸入。

## 開始之前

在你啟動任何任務前，先記住這三個原則：

1. 你負責商務真相，不負責代替工程師拆實作。
2. 你負責核准少數需要人類拍板的事項，不負責逐項審核技術細節。
3. 你負責提供外部資源，不負責替團隊編造原本不存在的證據。

## 啟動一個新任務

當你準備開始一個新任務時，先把需求交給 PM，不要直接跳給工程師。

### 準備你的輸入

在開始之前，先整理以下資訊：

1. 這件事要解決誰的什麼問題。
2. 最低成功標準是什麼。
3. 哪些範圍明確不做。
4. 你要的交付形式是什麼，例如內部驗證、客戶可用 MVP 或對外簡報。

### 啟動 SOP1

1. 在 Chat 中選擇 `product-strategy-manager` 與 `architecture-research-developer`，或直接貼上下面的指令。
2. 要求團隊先把需求凍結成 blueprint，不要直接開始施工。
3. 檢查是否有任何前提仍需要你提供，例如真人測試資源、正式環境政策或法律限制。

```text
/product-strategy-manager /architecture-research-developer
這是一個新需求。請先不要寫程式，依 SOP1 幫我把需求收斂成 blueprint。
你們要先確認：
1. 這是替誰解決什麼問題。
2. 最低驗收標準是什麼。
3. 明確不做的範圍是什麼。
4. 需要哪些角色交接。
5. 哪些前提仍待我這個 CEO 提供或拍板。
輸出請以 blueprint package 為主，不要跳到施工方案或 issue closure。
```

## 在 SOP1 結束時確認

當團隊告訴你 blueprint 已完成時，用下面的檢查方式確認是否真的可以進入 SOP2。

### 檢查什麼

確認以下四件事：

1. 需求與 out-of-scope 已凍結。
2. 各角色 handoff package 已齊全。
3. 每個查核點都有 owner、完成條件與驗證方式。
4. PM 已把你的輸入轉成可驗證條件，而不是願景口號。

### 使用這條結束指令

```text
/product-strategy-manager
請檢查目前 blueprint 是否已達 SOP1 結束條件。
若已達成，請明確列出：
1. 已凍結的需求與 out-of-scope。
2. 各角色的 handoff package 是否齊全。
3. 哪些查核點已定義 owner、完成條件、驗證方式。
4. 哪些事項仍待 CEO 提供資源或裁決。
若未達成，只列缺口與下一步，不要提前進入 SOP2。
```

## 推進 SOP2

當 blueprint 已凍結後，再讓工程與驗證角色進入 SOP2。

### 你在 SOP2 要做什麼

1. 讓團隊依 blueprint 回填 checked、signoff 與偏差說明。
2. 不要重新討論需求。
3. 只在團隊回報前提失效、需要正式環境核准，或需要外部資源時出場。

### 使用這條開始指令

```text
/senior-software-engineer /testing-quality-engineer
請依已凍結 blueprint 進入 SOP2。
要求如下：
1. 只在 blueprint 對應查核點內回填 checked、signoff 與偏差說明。
2. 不要重定義需求，也不要提前開 issue 取代 blueprint。
3. 若發現 blueprint 前提失效、需要正式環境核准或需要外部資源，再回報給我。
4. 完成後請指出哪些項目已可進入 SOP3 驗收。
```

## 在 SOP2 結束時確認

當團隊回報施工完成時，先確認它是否真的達到進入 SOP3 的條件。

### 檢查什麼

確認以下四件事：

1. 每個 blueprint 查核點都對應到具體檔案或程式變更。
2. 每個完成項都有施工 signoff。
3. 偏差已回寫到 blueprint，而不是留在聊天裡。
4. 若還缺真人受測管道、正式環境核准或其他人類輸入，已被明確標成待決條件。

### 使用這條結束指令

```text
/senior-software-engineer /testing-quality-engineer
請用 SOP2 的標準幫我做結束檢查。
我只要知道：
1. 哪些 blueprint 查核點已完成並有 signoff。
2. 哪些偏差已回寫到 blueprint。
3. 哪些項目仍缺 CEO 專屬輸入。
4. 哪些成果已具備進入 SOP3 的驗收前提。
不要輸出 closure recommendation，那是 SOP3 才做的事。
```

## 推進 SOP3

SOP3 的目的是驗收、派工與關單，不是補做 SOP2 的施工簽署。

### 你在 SOP3 要做什麼

1. 要求團隊把驗收、blocker、evidence 與 closure state 集中到 work order issue。
2. 若仍有施工缺口，要求團隊回寫成有 owner 的 action items。
3. 若涉及真人 usability 驗證，拆開 CEO resource action 與 QE findings action。

### 使用這條開始指令

```text
/field-application-engineer /site-reliability-engineer /usability-test-coordinator
請依 SOP3 接手目前成果。
你們要做的事是：
1. 把驗收、blocker、evidence、closure state 集中到新的或既有的 work order issue。
2. 若發現問題仍屬施工缺口，請回寫成有 owner 的 action items。
3. 若涉及真人 usability 驗證，請把 CEO resource action 與 QE findings action 拆開，不要寫成共同 owner。
4. 若目前只有文件或沙盤推演證據，請明確標示那不是真人 findings。
輸出要是一張可繼續派工的 issue，不是零散評論。
```

## 在 SOP3 結束時確認

SOP3 結束時，你不需要自己閱讀多份技術證據包。你要的是一份可以做決策的 closure summary。

### 檢查什麼

確認 PM 回給你的 closure summary 至少包含：

1. 驗收結論。
2. blocking gate。
3. issue 內可追溯的證據連結。
4. go / no-go 建議。
5. 若 no-go，下一位 owner 與你還要提供的資源。

### 使用這條結束指令

```text
/product-strategy-manager /field-application-engineer
請依 SOP3 幫我做最後收斂。
我只接受一份 PM 整理過的 closure summary，內容至少要有：
1. 驗收結論。
2. blocking gate。
3. issue 內可追溯的證據連結。
4. go / no-go 建議。
5. 若 no-go，下一位 owner 與我還要提供的資源。
不要讓我自己去讀多份平行證據包拼結論。
```

## 提供只有你能提供的輸入

下列事項需要你親自提供或核准：

| 項目 | 何時提供 | 誰會等你 |
|------|----------|----------|
| 商務真相與成功標準 | 任務開始前 | `product-strategy-manager` |
| 正式環境破壞性操作核准 | 進入正式環境變更前 | `site-reliability-engineer` |
| 真人受測者管道、beta 名單、招募預算 | 進入真人 usability 驗證前 | `usability-test-coordinator` |
| LICENSE 草案正式生效 | 對外發布前 | `tech-stack-curator` |
| `pip install`、`npm install`、`submodule add` 等實際安裝動作 | 依賴審查通過後 | `tech-stack-curator` |
| skill / agent 考核是否啟動與是否採納 | 需要檢討 runtime 時 | `skill-quality-auditor` |

## 你不需要親自做的事

大多數技術分歧不需要你直接下場。

| 情境 | 正確去向 |
|------|----------|
| RD 和 QE 對 scope 有分歧 | 回 PM 裁決 |
| 架構與實作方式有分歧 | 由 RD 內部收斂 |
| 發現資安疑慮 | 交給 `security-engineer` |
| 發現部署與維運問題 | 交給 `site-reliability-engineer` |
| 需要真人回饋 | 交給 `usability-test-coordinator`，由你補人類資源 |

## 當你要做冷啟動沙盤推演

如果你還沒有真人受測者，但想先把新手最可能卡住的步驟收斂成 issue，可以用下面的指令。

這個流程只產出 heuristic / cold-start simulation，不會取代真人 findings。

```text
/field-application-engineer /site-reliability-engineer /usability-test-coordinator
請你做個沙盤推演，假設你們正在審查一位從未使用過本專案的新手，他照著 blueprint 設計的理想使用情境操作，最可能在哪些步驟卡住。
要求如下：
1. 先從現有 blueprint、quickstart、deploy-use 文件與驗收路徑找出具體阻塞點。
2. 區分哪些是文件問題、哪些是工程問題、哪些是維運 / 驗收問題。
3. 為每個問題設計解決方案與具體工程項目。
4. 產出新的 `.github/issues/*-workorder.md` 工單。
5. 明確標示這是 heuristic / cold-start simulation，不是真人 usability findings。
6. 若要進入真人驗收，另外拆出 CEO resource action 與 `usability-test-coordinator` findings action。
```

## 快速檢查清單

在你結束這次任務前，快速檢查以下項目：

- [ ] 任務有先經過 PM 定義 What / Why 與驗收標準。
- [ ] 涉及新依賴、框架或模型時，已先經過 `tech-stack-curator`。
- [ ] 規模大到可能跨 session 時，已建立 `blueprint/<feature-name>/`。
- [ ] 涉及正式環境變更、真人受測者或 LICENSE 生效時，你已提供必要核准。
- [ ] 若這次暴露的是協作規範問題，而不是產品缺陷，你已決定是否要交給 `skill-quality-auditor`。

## 下一步

如果你要繼續往下操作，使用這些文件：

- 想查正式跨部門規則：看 `cross-team.instructions.md`
- 想查 SOP1 的正式完成條件：看 `start-to-planning.instructions.md`
- 想查 SOP2 的正式完成條件：看 `planning-to-execution.instructions.md`
- 想查 SOP3 的正式完成條件：看 `execution-to-verification.instructions.md`
- 想看目前的驗收與派工狀態：看 `.github/issues/*.md`
