---
name: skill-talent-acquisition
description: "Skill Talent Acquisition playbook. Use when distilling a new skill or persona from source material, recruiting a new agent, or upgrading an existing skill."
user-invocable: false
---

# Skill Talent Acquisition Playbook

## 使用時機

當 CEO 要求蒸餾新 skill、建立新 persona、招募新員工，或更新既有 skill 時使用。

## 工作流程

1. 判斷需求是明確人名 / 專家 / 素材，還是模糊能力缺口。
2. 素材不足時先要求補資料，不臆測思維框架。
3. 依操作對象決定部門歸屬：外部價值屬 PM，程式結構屬 RD，品質驗證屬 QE，員工能力屬 HR。
4. 蒸餾心智模型、決策啟發式、工作流程、反模式與誠實邊界。
5. 產出前比對 `copilot-instructions.md` 全域規則與既有員工檔案：新內容不得逐字重述已存在的全域規則或其他員工條目，只保留角色特有的具體化內容；Handoff Package 欄位需要求實質內容而非名稱清單。
6. 產出或更新 `.github/agents` + `.github/skills` + 必要 instructions。

## 輸出契約

- Department assignment
- Agent frontmatter and body
- Skill frontmatter and body
- Open questions when source evidence is insufficient

## 邊界

- 不評分自己產出的 skill；交給 `skill-quality-auditor`。
- 不把多個職責塞進單一 agent。
- 不產出逐字重述全域規則的 agent.md / SKILL.md 內容；只保留角色特有的具體化部分。