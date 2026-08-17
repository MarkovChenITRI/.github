# 我的 SBIR × Matt Pocock Skills 工作手冊（VS Code Claude Code 版）

跟著下面的步驟裝一次之後，不管背後是 Matt-Pocock-skills 這個 plugin，還是 sbir-grants 這個 MCP server，都會變成你個人的 Claude Code skill，統一用 `/<名稱>` 呼叫。

---

## 一、安裝步驟

### Step 0｜安裝前置工具（Windows）

**git**：

```powershell
winget install --id Git.Git -e --source winget
```

**uv**：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Claude Code CLI**：

```powershell
irm https://claude.ai/install.ps1 | iex
```

### Step 1｜Fork 並 Clone 兩個上游 repo 到本機

先在 GitHub 網頁上，把這兩個上游 repo 各自 fork 一份到你自己的帳號：[backtrue/sbir-grants](https://github.com/backtrue/sbir-grants)、[mattpocock/skills](https://github.com/mattpocock/skills)。

Fork 完，把下面的 `<your-username>` 換成你自己的 GitHub 帳號，在你的 GitHub 資料夾底下執行：

```bash
git clone https://github.com/<your-username>/sbir-grants.git
git -C sbir-grants remote add upstream https://github.com/backtrue/sbir-grants.git

git clone https://github.com/<your-username>/skills.git Matt-Pocock-skills
git -C Matt-Pocock-skills remote add upstream https://github.com/mattpocock/skills.git
```

`origin` 指你自己的 fork，`upstream` 指原專案，之後改 skill 內容直接在本機 clone 裡改、`git push` 回 `origin` 即可。

### Step 2｜（可選）同步上游更新

Fork 不會自動跟著上游變動，對 `sbir-grants` 和 `Matt-Pocock-skills` 這兩個資料夾各自執行以下指令（將 `<repo>` 換成對應的資料夾名稱），可確保本機內容為最新版本：

```bash
cd <repo>
git fetch upstream && git merge upstream/main && git push origin main
```

如果你自己也改過 skill 內容，`merge` 這步可能會有衝突要處理。同步完不用重新連結——Step 3 是用目錄連結接到這兩個本機 clone，`/mattpocock` 系列指令跟 `/sbir-grants` 會直接吃到更新後的內容。

### Step 3｜請 Claude Code 安裝所有 skill

目錄連結的具體做法在 Windows／Mac／Linux 不一樣（junction／symlink），不用自己記指令，直接在 VS Code 的 Claude Code 對話框依序跟它說：

連結 Matt Pocock 的官方 skill：

> 把 Matt-Pocock-skills 這個 fork 裡，`plugin.json` 列出的 25 個官方 skill（不要 `skills/in-progress/` 和 `skills/misc/` 裡未收錄的那些），用我作業系統對應的目錄連結方式連到我的個人 Claude Code skills 目錄（`~/.claude/skills/`）。其中 `code-review` 改名成 `mp-code-review`——Claude Code 內建就有一個 `/code-review`（含雲端多 agent 的 `/code-review ultra`），同名會蓋掉內建指令，所以兩者並存、互不影響。

新增 sbir 互動功能的封裝 skill（`sbir-grants` 本身沒有問答生成計畫書這類互動功能的 skill，那些是 MCP server 的工具，需要另外寫 4 個薄封裝）：

> 在我的個人 Claude Code skills 目錄新增 4 個 skill：`sbir-write`（互動問答生成計畫書）、`sbir-check`（送件前健檢、資格核對、ROI 試算）、`sbir-market`（查產業統計數據）、`sbir-export`（彙整/匯出 Word），內容都是指示 Claude 呼叫 `sbir-data` 這個 MCP server 對應的工具（`start_proposal_generator`、`get_progress`、`calculate_roi`…）。

Claude Code 會自己判斷用 symlink 還是 junction，並讀 `Matt-Pocock-skills/.claude-plugin/plugin.json` 取得正確的 25 個官方清單；4 個封裝 skill 的細節可直接開對應的 `SKILL.md` 看。做完後可以先用 `ls ~/.claude/skills`（PowerShell 用 `dir`）確認底下多了 29 個項目（25 個官方 + 4 個封裝），不用等到 Step 6 才知道有沒有裝對。

### Step 4｜請 Claude Code 連結 sbir-grants 的知識庫 skill

> 把 `sbir-grants` fork 裡 `sbir-grants/sbir-grants`（裡面有 `SKILL.md`）這個資料夾，連結到我的個人 Claude Code skills 目錄，取名 `sbir-grants`。

做完後 `ls ~/.claude/skills/sbir-grants`（PowerShell 用 `dir`）應該能看到連結指向該資料夾，確認成功再繼續 Step 5。

### Step 5｜接上 sbir-data 這個 MCP server

Step 3 新增的 4 個封裝 skill 要靠這個 server 才有工具可呼叫。在 VS Code 的 Claude Code 對話框跟它說：

> 幫我把 `sbir-grants` fork 裡 `sbir-grants/sbir-grants/mcp-server` 這個資料夾註冊成一個叫 `sbir-data` 的 MCP server（stdio，用 `uv` 啟動 `server.py`），scope 設成 user。

Claude Code 會用你實際 clone 下來的路徑組出對應的 `claude mcp add` 指令並執行。跑完用 `/mcp` 確認 `sbir-data` 顯示 `✔ Connected`。

### Step 6｜重啟 Claude Code session

`~/.claude/skills/` 是這次新建的頂層目錄，執行中的 session 不會自動偵測，重啟 VS Code（或開一個新 session）後打 `/skills`，應該能看到下面全部 30 個。

---

裝完以上 6 步（Step 2 是可選的），**標準用法只有一句話：不管背後是連到 Matt Pocock 的 skill 檔案，還是封裝 MCP 工具的薄 skill，一律打 `/<名稱>` 呼叫。**

---

## 二、完整指令清單

### 寫 SBIR 計畫書

| 指令 | 用途 |
|---|---|
| `/sbir-grants` | 查詢方法論與審查標準知識庫 |
| `/sbir-write` | 用問答生成計畫書（Phase 1/2） |
| `/sbir-market` | 查詢官方產業統計數據 |
| `/sbir-check` | 檢查送件前完整度、資格、ROI |
| `/sbir-export` | 把已寫段落匯出成 Word |

### 開發實作

| 指令 | 用途 |
|---|---|
| `/ask-matt` | 不知道用哪個 skill 時問它，取得路由建議 |
| `/grill-with-docs` | 拷問講清楚計畫，寫進 CONTEXT.md/ADR |
| `/domain-modeling` | 打磨領域字彙，寫進 CONTEXT.md/ADR |
| `/codebase-design` | 設計模組介面與 seam 該放哪 |
| `/to-spec` | 把討論彙整成規格書，發到 issue tracker |
| `/to-tickets` | 把規格拆成垂直切片 ticket |
| `/wayfinder` | 把大型工作拆成決策 ticket 地圖 |
| `/implement` | 依規格／ticket 動手實作 |
| `/tdd` | 用紅-綠-重構流程測試驅動開發 |
| `/mp-code-review` | 依規格對齊與程式碼規範兩軸審查程式碼 |
| `/improve-codebase-architecture` | 掃描 codebase 找出可加深的模組 |
| `/diagnosing-bugs` | 診斷難搞的 bug／效能退化 |
| `/triage` | 把 issue／外部 PR 分類整理成 agent-ready brief |
| `/resolving-merge-conflicts` | 處理進行中的 merge/rebase 衝突 |
| `/prototype` | 做一個用完即丟的 prototype 驗證設計 |
| `/research` | 查一手資料，寫成 Markdown 存進 repo |
| `/wizard` | 產生互動 bash 精靈，帶你走人類專屬步驟 |
| `/setup-matt-pocock-skills` | 幫新專案初始化 issue tracker 與標籤 |

### 非工程／溝通類

| 指令 | 用途 |
|---|---|
| `/grilling`、`/grill-me` | 對想法做連環拷問，壓力測試思路 |
| `/handoff` | 把對話濃縮成交接文件 |
| `/teach` | 教你一個新技能／概念 |
| `/to-questionnaire` | 把決策轉成問卷給別人填 |
| `/wait-what` | 覺得 AI 沒聽懂時喊停重新表述 |
| `/writing-for-agents` | 撰寫或編輯 skill／AGENTS.md／CLAUDE.md |
