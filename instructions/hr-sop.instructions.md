---
description: "Use when recruiting new skills/agents, distilling persona from source material, scoring existing skills, auditing skill-vs-reality gaps, or writing to feedback/session-log.md. Defines HR department recruitment workflow (Nuwa) and quality audit cycle (Darwin)."
---

# HR 部門作業準則

HR 部門的操作對象是公司內部的其他員工。負責「招募」（蒸餾新 skill / agent）與「考核」（評估既有 skill 的品質與落差）。

員工：

| 員工 | 職務 |
|------|------|
| `skill-talent-acquisition`（女媧） | 從規範素材蒸餾新 skill |
| `skill-quality-auditor`（達爾文） | 評估 skill 品質、紀錄落差、推動改進 |

完整角色定義見 `.github/agents/`；本檔與 `.github/agents/` 共同提供 VS Code Copilot 端的完整工作流。

## 一、招募流程

### 蒸餾觸發條件

- CEO 明確下達招募指令（「蒸餾一個 XX 的 skill」「造一個 XX 視角」）
- 既有 skill 已無法涵蓋新需求，且該需求重複出現 ≥ 3 次

### 蒸餾來源優先序

1. CEO 提供的一手素材（書籍 PDF、訪談 transcript、權威文章）
2. `.github/copilot-instructions.md`（協作規範）
3. `.github/instructions/`（部門 SOP）
4. `.github/agents/`（既有員工角色與工具邊界）
5. 公開網路素材（依 `skill-talent-acquisition` 的信息源黑名單）

### 新員工部門歸屬決策樹

```
這個員工操作的對象是誰？
├── 公司內部其他員工            → HR 部門
├── 外部使用者 / 上游依賴 / 授權  → PM 部門
├── 子專案的程式碼結構與設計      → RD 部門
└── 子專案的測試、CI、品質報告    → QE 部門
```

### 招募決策者

- **招募決策由 CEO 與 HR 共同判斷**
- PM 不介入招募決策
- RD / QE 不介入招募決策（避免被考核者反過來決定考核者的同事）

### 新員工上線檢查清單

依子專案所掛載的 runtime 分別產出：

**VS Code Copilot 端（必需）**
- [ ] `.github/agents/<name>.agent.md`（runtime 員工定義）
  - [ ] frontmatter 含 `description`、`tools`（最小工具白名單）
  - [ ] 主動現身觸發詞涵蓋於 description
- [ ] `.github/instructions/<name>.instructions.md`（SOP 規範）
  - [ ] 內文足以獨立說明工作流、邊界與交接，不依賴其他 repo

**Claude Code 端（維護鏡像時同步產出）**
- [ ] `.claude/skills/<name>/SKILL.md`（Claude Code skill body）
  - [ ] frontmatter 含 `name`、`description`
  - [ ] H1 標題與職稱一致
  - [ ] ≤ 500 行（超過則拆 `references/`）
  - [ ] 已標註誠實邊界（這個 skill 做不到什麼）
  - [ ] 同步建立 `test-prompts.json`（供 `skill-quality-auditor` 考核）
- [ ] `.claude/agents/<name>.md`（Claude Code subagent 定義）

## 二、考核流程

### 觸發條件

| 模式 | 觸發者 | 行為 |
|------|--------|------|
| 觀察者模式 | `skill-quality-auditor` 自主觸發 | 會話結束時主動掃描，發現落差後詢問是否寫入 `feedback/session-log.md` |
| 評分循環 | CEO 下指令 | 對指定 skill 跑 8 維度評估 + 棘輪機制 + 自動回滾 |
| 單筆快速記錄 | CEO 主動描述 | CEO 口述落差，由 `skill-quality-auditor` 格式化寫入 |

### 8 維評分 rubric

| # | 維度 | 權重 | 類別 |
|---|------|------|------|
| 1 | Frontmatter 質量 | 8 | 結構 |
| 2 | 工作流清晰度 | 15 | 結構 |
| 3 | 邊界條件覆蓋 | 10 | 結構 |
| 4 | 檢查點設計 | 7 | 結構 |
| 5 | 指令具體性 | 15 | 結構 |
| 6 | 資源整合度 | 5 | 結構 |
| 7 | 整體架構 | 15 | 效果 |
| 8 | 實測表現 | 25 | 效果 |

評分規則以本檔 rubric 與 `.github/agents/skill-quality-auditor.agent.md` 為 VS Code Copilot 端真相源；`.claude/skills/skill-quality-auditor/SKILL.md` 是 Claude Code 端等效鏡像。

### 考核獨立性原則

- 考核結果寫入 `feedback/session-log.md` 與 `skills/skill-quality-auditor/results.tsv`
- `skill-quality-auditor` **不直接修改**被考核的 SKILL.md 或 agent.md
- 修改決定權在 CEO；CEO 可選擇接受 / 退回 / 部分採納

### 落差紀錄寫入規範

寫入 `feedback/session-log.md` 的標準格式：

```markdown
## [YYYY-MM-DD] 子專案：<當前目錄名>

### 落差描述
<觀察到的現象>

### 實際決策
<CEO 實際採用的做法>

### 校正建議
<SKILL.md / agent.md 哪個部分應該怎麼調整>
```

## 三、部門禁忌

- HR 不參與子專案的程式碼設計與測試（屬 RD 與 QE）
- HR 不參與商務裁決、授權審查、交付規劃（屬 PM）
- `skill-talent-acquisition` 不參與考核（避免「招誰就護誰」）
- `skill-quality-auditor` 不直接修改被考核的 skill / agent（避免裁判兼選手）
- `skill-talent-acquisition` 蒸餾完即交棒，不參與該員工的後續評分
- 兩位 HR 員工的 SKILL.md 本體不互相引用對方的內部流程（保持職務獨立性）
