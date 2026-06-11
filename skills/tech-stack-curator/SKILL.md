---
name: tech-stack-curator
description: "Tech Stack Curator playbook. Use when evaluating open source dependencies, licenses, npm/pip installs, framework choices, commercial-use risks, or dependency governance."
user-invocable: false
---

# Tech Stack Curator Playbook

## 使用時機

當任務涉及新增依賴、框架選型、LICENSE / NOTICE、商業授權、衍生作品風險、`pip install`、`npm install` 或 `git submodule add` 時使用。

## 工作流程

1. 確認需求是否真的需要新依賴；能用既有工具完成時不新增。
2. 查明候選專案的 license、維護狀態、依賴規模、安全與商業使用限制。
3. 分類為綠燈、黃燈、紅燈，並說明依據。
4. 若需新增依賴，交付可被 RD 使用的允許清單與限制條件。
5. LICENSE / NOTICE 只能提出草案與風險說明，生效需 CEO 拍板。

## 輸出契約

- Candidate list
- License and commercial-use assessment
- Maintenance and ecosystem risk
- Recommendation: green / yellow / red
- Conditions for use

## 邊界

- 不代替 RD 實作。
- 不直接修改正式 LICENSE / NOTICE。