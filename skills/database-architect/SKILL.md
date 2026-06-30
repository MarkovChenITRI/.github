---
name: database-architect
description: "Database Architect playbook. Use when designing database schema, ER models, normalization level, indexing strategy, data integrity constraints, transaction boundaries, migration compatibility, or choosing SQL/NoSQL data stores."
user-invocable: false
---

# Database Architect Playbook

## 使用時機

當任務涉及資料表結構、ER 模型、正規化、索引策略、資料完整性約束、migration 相容性規劃或資料庫選型時使用。

## 工作流程

1. 確認架構事實包是否已說明持久層邊界（誰讀寫什麼、一致性要求）；未說明則先向架構師確認。
2. 畫出 ER 模型：實體、屬性、主鍵、外鍵與關聯基數（1:1 / 1:N / N:N）。
3. 先把關聯式 schema 設計到至少三階正規化（3NF），再決定是否需要基於效能、相容性或外部產品限制進行刻意反正規化；所有偏離 3NF 的地方都必須標明讀效能、寫效能與儲存成本的取捨。
4. 定義完整性約束（NOT NULL、UNIQUE、CHECK、FK 行為）與交易邊界。
5. 交棒 `senior-software-engineer` 寫 migration 與 ORM model，交棒 `testing-quality-engineer` 設計資料完整性測試。

## Schema Facts Package

交給工程師或 QE 時，不只列資料表名稱。Schema 事實包至少包含：

- 實體與關係：每個資料表代表什麼、與誰關聯。
- 鍵與約束：主鍵、外鍵、唯一性、必填欄位。
- 正規化說明：各核心表至少滿足 3NF 的依據；若有反正規化，需寫明原因、風險與回退條件。
- 索引策略與取捨：哪些查詢路徑需要索引、為何需要。
- 一致性與交易邊界：哪些操作必須是原子性的。
- 遷移路徑：新 schema 與既有資料的相容性，是否需要 backfill 或分階段遷移。
- 待確認項：效能門檻、資料量級、保留政策，需 PM 或 CEO 裁決者不得寫成定案。

## 輸出契約

- ER model
- 3NF decision and tradeoffs
- Index strategy
- Integrity constraints and transaction boundaries
- Migration compatibility notes
- Schema facts package for engineer / QE handoff

## 邊界

- 不寫 migration 程式碼或 ORM 實作。
- 不寫 query 邏輯。
- 不得在沒有明確理由時交付低於 3NF 的關聯式 schema。
- 不為未驗證的未來需求過度正規化。
- 不在缺乏資料量級資訊時把索引策略當成定案。
- 不略過 `tech-stack-curator` 自行選定資料庫產品。
