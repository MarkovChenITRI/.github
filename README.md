# `.github` —— Connect AI 的 VS Code Copilot Runtime

本 repo 是 Connect AI 公司化開發規範的 **VS Code Copilot 端自足 runtime**。子專案只需掛載本 repo，即可在 VS Code Copilot 取得完整的 agent organization、部門 SOP、深度 skill playbook 與公司憲法。

> **擇一掛載原則**：使用 VS Code Copilot → 掛 `.github/`；使用 Claude Code → 掛 `.claude/`。兩個 repo 互為內容等效鏡像，同一個工具不需要兩個都掛。

## 目錄結構

```
.github/
├── README.md                       # 本檔
├── copilot-instructions.md         # 公司憲法（VS Code Copilot 全域常駐）
├── instructions/                   # 部門 SOP（依 applyTo 條件自動載入）
│   ├── cross-team.instructions.md
│   ├── pm-sop.instructions.md
│   ├── rd-sop.instructions.md
│   ├── qe-sop.instructions.md
│   └── hr-sop.instructions.md
├── agents/                         # 員工 custom agents（角色、工具白名單、handoffs）
    ├── product-strategy-manager.agent.md
    ├── tech-stack-curator.agent.md
    ├── architecture-research-developer.agent.md
    ├── senior-software-engineer.agent.md
    ├── testing-quality-engineer.agent.md
    ├── skill-talent-acquisition.agent.md
    └── skill-quality-auditor.agent.md
└── skills/                         # 深度 playbook（按需載入）
    ├── product-strategy-manager/SKILL.md
    ├── tech-stack-curator/SKILL.md
    ├── architecture-research-developer/SKILL.md
    ├── senior-software-engineer/SKILL.md
    ├── testing-quality-engineer/SKILL.md
    ├── skill-talent-acquisition/SKILL.md
    └── skill-quality-auditor/SKILL.md
```

## 安裝

在子專案根目錄執行一次：

```bash
git submodule add https://github.com/MarkovChenITRI/.github.git .github
git commit -m "chore: add .github submodule (VS Code Copilot runtime)"
```

掛載後，VS Code Copilot 會偵測：
- `.github/copilot-instructions.md`（全域常駐，公司憲法）
- `.github/instructions/*.instructions.md`（依 `applyTo` 或語意匹配注入）
- `.github/agents/*.agent.md`（員工 custom agents，透過 agent picker、`@`、handoff 或 subagent 使用）
- `.github/skills/*/SKILL.md`（深度 playbook，先讀 metadata，任務相關時按需載入全文）

## VS Code 1.99+ 載入行為

| 機制 | 來源路徑 | 預設行為 |
|------|----------|---------|
| 全域指令 | `.github/copilot-instructions.md` | 自動載入 |
| 條件式 SOP | `.github/instructions/` | `applyTo` 比對後注入 |
| 員工 Agent | `.github/agents/` | `@agent-name` 呼叫 |
| 深度 Skill | `.github/skills/` | 依 `name` / `description` 按需載入 |
| 跨工作流 handoffs | agent frontmatter 的 `handoffs:` | 對話結束後顯示按鈕 |

## 邊緣情境：同時使用 VS Code Copilot 與 Claude Code

若子專案同時需要兩個工具，可分別掛載兩個 repo：

```bash
git submodule add https://github.com/MarkovChenITRI/.github.git .github
git submodule add https://github.com/MarkovChenITRI/.claude.git .claude
git commit -m "chore: add both runtime submodules"
```

兩個 repo 互為內容等效鏡像，各自為自己工具的單一真相源。決策指南詳見 [docs/dual-repo-workflow.md](docs/dual-repo-workflow.md)。

## 維護注意

- 修改 `instructions/` 時注意 `applyTo` glob 寬度，避免污染所有對話 context。
- 修改 `agents/` 的 `tools` 白名單需明確權衡：寬鬆容易越權，過嚴 agent 無法工作。
- 修改 `skills/` 時保持 `name` 與資料夾名稱一致，並把高頻規則留在 instructions，避免 skill 變成常駐憲法。
- 本 repo 不應作為 nested submodule 出現在 `.claude/` 內，反之亦然。
