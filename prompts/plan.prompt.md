---
description: "從 0 協助使用者為一個新模組或功能撰寫規格，透過問答收斂 Who/What/How/Where，寫入 .github/specs/<layer>.md"
---

# 規格書撰寫 SOP

依 `.github/instructions/ddd-architecture.instructions.md` 的四層定義與規格書欄位，透過問答協助使用者建立一個新模組的規格。

## 開始之前

1. 確認要建立規格的模組或功能名稱；使用者未提供時，先詢問。
2. 判斷這個模組屬於使用者介面層、應用層、領域層、基礎設施層哪一層：依模組描述的職責，對照 `ddd-architecture.instructions.md` 的四層定義判斷，跟使用者確認判斷結果。
3. 開啟 `.github/specs/<layer>.md`，確認這個模組是否已有段落：
   - 已有段落：告知使用者已存在，詢問要不要改走 `ddd-architecture.instructions.md` 的 Implementation SOP 更新既有內容，而不是在這裡重複建立。
   - 沒有段落：依下方問答建立新段落。

## 問答步驟

依序詢問使用者，逐一取得下列四個欄位的內容，每個欄位問完先覆誦使用者的回答，確認理解正確後再問下一個：

1. Who：這個模組由誰負責維護、變更需要誰核准。
2. What：這個模組要做什麼；哪些事明確排除在外。
3. How：
   - 依賴方向：這個模組依賴誰、誰可以依賴它。
   - Public API：對外暴露的方法簽章、輸入輸出契約。
   - 不變式：任何狀態下必須成立的約束。
   - 邊界條件：合法輸入範圍、例外處理策略。
4. Where：檔案放在 `src/<layer>/` 底下哪個子目錄，檔名慣例是什麼。

## 寫入規格書

1. 依規格書欄位格式，把四個欄位的內容整理成一段：

   ```markdown
   ## <模組名稱>

   - Who：...
   - What：...
   - How：...
   - Where：...
   ```

2. 開啟 `.github/specs/<layer>.md`，把這段加進去；檔案不存在時先建立。
3. 在對話中貼出寫入的完整段落，請使用者確認內容正確。

## 完成條件

1. `.github/specs/<layer>.md` 已包含這個模組的段落，四個欄位都有具體內容。
2. 使用者已確認過寫入的內容。
3. 使用者接著要求開始實作時，交給 `.github/instructions/ddd-architecture.instructions.md` 的 Implementation SOP 接手。
