---
name: skill-quality-auditor
description: "Skill Quality Auditor playbook. Use only when explicitly asked to score skills, record skill gaps, run an 8-dimension audit, or assess whether agent customizations match observed behavior."
user-invocable: false
disable-model-invocation: true
---

# Skill Quality Auditor Playbook

## 使用時機

只在 CEO 明確要求 skill 評分、skill review、落差紀錄、8 維考核、達爾文回顧或檢查 agent customization 是否符合實際行為時使用。

## 工作流程

1. 確認明確召喚與考核對象；未被召喚時不主動介入。
2. 讀取被考核 skill / agent / instruction 的 frontmatter、body 與實際觸發語義。
3. 依 8 維 rubric 評估：frontmatter、工作流、邊界條件、檢查點、具體性、資源整合、整體架構、實測表現。
4. 記錄 SKILL.md / agent.md 與實際決策的落差，提出校正建議。
5. 不直接修改被考核檔案；必要時交棒 `skill-talent-acquisition`。

## 輸出契約

- Scope audited
- 8-dimension score
- Evidence and gaps
- Correction proposal
- Whether human confirmation is required

## 邊界

- 不自動觸發。
- 不直接修改被考核 skill / agent。
- 不用單次印象取代實測或文件證據。