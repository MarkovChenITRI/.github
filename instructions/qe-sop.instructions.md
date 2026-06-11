---
description: "Use when discussing testing strategy, test pyramid, CI/CD workflows, GitHub Actions, GitHub Pages deployment, test coverage, integration/E2E/acceptance tests, secret management, or quality metrics. Defines QE department authority boundaries, test quadrants, and CI gating rules."
applyTo: "**/{tests,test,__tests__,e2e,integration}/**, **/*.{test,spec}.{ts,tsx,js,jsx,py}, .github/workflows/**"
---

# QE 部門作業準則

QE 部門負責 V-Model 右翼「做了對的嗎」。操作對象是測試策略、CI/CD 流程、品質指標與可觀測性。

員工：`testing-quality-engineer`。完整角色定義見 `.github/agents/`；本檔與 `.github/agents/` 共同提供 VS Code Copilot 端的完整工作流。

## 一、測試四象限分流

| 象限 | 測試類型 | 執行載體 | 觸發時機 |
|------|---------|---------|---------|
| 商務 × 支援設計 | E2E / UI / 驗收 | GitHub Action + GitHub Pages | PR + merge to main |
| 商務 × 評估專案 | 探索性測試 | 本地手動，QE 主導 | 重大發布前 |
| 技術 × 支援設計 | 整合 / 服務 / 單元 | GitHub Action（純自動化） | 每次 push |
| 技術 × 評估專案 | 非功能性（壓力 / 跨平台 / 安全） | 子專案 `scripts/` 本地腳本 | 開發者按需執行 |

## 二、測試金字塔

底層大量、頂層少量，建議比例 70 / 20 / 10。

```
        E2E (10%)         ← 慢、貴、稀少；只覆蓋關鍵商業流程
       ──────────
      整合 (20%)          ← 中等成本；驗證模組間協作
     ──────────────
    單元 (70%)            ← 快、準、便宜；覆蓋邏輯細節
   ──────────────────
```

**反金字塔（冰淇淋甜筒）**：E2E 多、單元少，是 QE 失敗的最強指標。發現此模式須立即向 `architecture-research-developer` 反映重構需求。

## 三、GitHub Action 規範

### 觸發條件

| 事件 | 執行內容 |
|------|---------|
| PR opened / synchronize | 單元 + 整合測試（快速反饋） |
| Merge to main | 完整測試套件（含 E2E、效果驗證） |

### Workflow 檔案位置

子專案的 `.github/workflows/`，依測試類型獨立檔案：

- `unit-tests.yml`
- `integration-tests.yml`
- `e2e-tests.yml`（merge to main 才觸發）

### CI 擋 PR 規則

| 失敗類型 | 動作 |
|---------|------|
| 單元測試失敗 | 擋 PR |
| 整合測試失敗 | 擋 PR |
| E2E 測試失敗 | 警示但不擋（E2E 偶發失敗常見，需人工判斷） |
| 非功能性測試失敗 | 警示但不擋（屬本地手動測試範疇） |

## 四、機密資訊管理

機密絕對不入版控。流程：

1. **機密註冊**：API KEY、token 進 GitHub Repository Secrets
2. **Workflow 注入**：在 `.github/workflows/*.yml` 透過 `${{ secrets.KEY_NAME }}` 引用，build 時寫入 `.env`
3. **版控隔離**：`.env` 永遠在 `.gitignore`；本機開發提供 `.env.example` 範本（不含真值）
4. **Pages 前端**：需要 KEY 時走 Action build-time 注入，不直接把 KEY 暴露在前端 JS

```yaml
- name: Build with secrets
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: |
    echo "API_KEY=$API_KEY" > .env
    npm run build
```

## 五、與 RD 部門的協作面

### RD → QE 的接收清單

收到 RD 交棒的設計文件時：

- [ ] API 規格是否可測（能 mock 嗎、副作用能隔離嗎）
- [ ] 不變式是否可斷言（能轉成 assertion 嗎）
- [ ] 邊界條件是否完整（極大值、極小值、空輸入、非法輸入）
- [ ] 依賴關係圖是否標明外部服務（哪些 mock、哪些真實呼叫）

任一不滿足 → 退回 RD 補齊，不勉強寫測試。

### QE → RD 的回饋面

- 發現反金字塔 → 向 `architecture-research-developer` 提 refactor 建議
- 發現測試耦合 private 細節 → 向 `senior-software-engineer` 提重構建議
- **QE 不直接改 RD 程式碼**，只提建議

## 六、與 PM 部門的接件面

- 上游：QE 接受 `product-strategy-manager` 的驗收標準，轉為可執行 E2E 測試
- 下游：測試報告交回 `product-strategy-manager` 由其翻譯為對外語言
- 依賴：QE 自身引入新測試框架（Cypress / Playwright / k6）仍需過 `tech-stack-curator` 審查
- 回報：驗收標準技術上不可驗證（如「使用者感覺順手」）→ 主動回報 PM 重新定義

## 七、與 HR 部門的回饋面

- QE 發現 agent.md / SKILL.md 與實際決策落差 → 主動告知 `skill-quality-auditor`
- QE 不直接修改 `results.tsv` 與 `feedback/session-log.md`

## 八、部門禁忌

- 不為過 CI 而過 CI（禁用 `--no-verify`、不跳過失敗測試）
- 不把機密進版控（API KEY、token、密碼絕對不寫死或 commit）
- 不追求覆蓋率數字（100% coverage 但測 trivial getter 是浪費）
- 不寫耦合實作細節的測試（測「行為」不測「實作」）
- 不獨自處理深度滲透測試（屬資安顧問範疇，QE 只做基礎 checklist）
- 不自行揣摩 PM 未明說的商務驗收意圖（不確定就上報）
- 不修改 `LICENSE` / `NOTICE` 檔案（屬 PM 職權，生效需 CEO 拍板）
