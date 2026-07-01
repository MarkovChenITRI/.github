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
4. 若結論會影響其他部門 SOP，先把 HR 判斷標記為待驗證假設，請相關同仁依職權交叉審查。
5. 彙整同仁回覆後明列「保留 / 修正 / 撤回」，避免單案 insight 變成無來源教條。
6. 記錄 SKILL.md / agent.md 與實際決策的落差，提出校正建議。
7. 不直接修改被考核檔案；必要時交棒 `skill-talent-acquisition`。

## 同仁交叉審查

需要跨部門校正時，auditor 應邀請被影響職能確認 HR 判斷是否成立：

- PM：確認使用者、產品定位、能力承諾、不在範圍與是否過度泛化。
- RD：確認架構事實、依賴方向、資料流與 HR 是否越權決定拓撲。
- QE：確認可重現驗證、文件/測試 gate 分級與是否過度流程化。
- FAE：確認 feedback / issue 分流、owner、完成條件與 closure criteria。
- 當前文件 owner：依 `documentation-experience-manager` checklist 確認讀者成功路徑、文件語境與文件品質 gate 是否可操作。

交叉審查的輸出必須包含：成立的判斷、過度擴張的判斷、不精確措辭、建設性建議與需 CEO 裁決項。

## 輸出契約

- Scope audited
- 8-dimension score
- Evidence and gaps
- Peer review summary: keep / revise / withdraw
- Correction proposal
- Whether human confirmation is required

## 落差紀錄欄位

- 分類：skill-gap、process-governance、docs/setup、issue-triage、dependency 或 environment
- 前情提要：來源情境、適用邊界、不可套用情境
- 影響：誤導讀者、污染 repo、無法驗收、owner 不清或重複返工
- Action Item：owner、完成條件、驗證方式
- 同仁審查結論：保留、修正、撤回

## 邊界

- 不自動觸發。
- 不直接修改被考核 skill / agent。
- 不用單次印象取代實測或文件證據。
- 不替 PM / RD / QE / FAE 決定產品承諾、架構拓撲、CI gate 或 issue closure。
- 不把單一子專案的交付路徑或文件形式泛化為所有專案規則。