---
description: "協助使用者建立或更新 .github/specs/overview.md（系統架構）：四層模組清單、技術堆疊、Benchmark 開源專案庫，以及三者之間的閉環邏輯"
---

# 系統架構撰寫 SOP

依 `.github/instructions/spec-format.instructions.md` 的「系統架構」格式，透過問答協助使用者建立或更新 `.github/specs/overview.md`。

## 開始之前

1. 開啟 `.github/specs/overview.md`，確認是否已存在：
   - 已存在：詢問這次是要更新哪一層、還是全部重新盤點。
   - 不存在：這是第一次使用 `plan`，先依 `spec-format.instructions.md` 的「目錄結構」，把兩種規格檔案結構（一層一檔／一模組一檔）攤給使用者選，選定後才繼續下面的問答。

## 問答步驟

依四層（使用者介面層、應用層、領域層、基礎設施層）逐層詢問，每層問完先覆誦使用者的回答，確認理解正確後再問下一層：

1. What：這層目前規劃有哪些模組（模組名稱＋一句話說明）。
2. Where：這層主要使用的技術堆疊；這層設計時參考或依附的 Benchmark 開源專案庫。
3. Who：這層服務的對象。
4. How：這層跟其他層怎麼互動；這層的模組、Benchmark 專案庫、技術堆疊三者怎麼形成閉環邏輯。

四層都問完後，額外確認一次：整個專案有沒有跨層的閉環邏輯要補充說明。

## 寫入系統架構

1. 依 `spec-format.instructions.md` 的格式整理四層內容，附一張 Mermaid 圖固定四層的相對位置與互動關係。
2. 每層有提到閉環邏輯時，附一張 Mermaid 圖示範這個閉環。
3. 開啟 `.github/specs/overview.md`，把整理好的內容寫入；檔案不存在時先建立。
4. 每一層 What 欄位列出的模組，附連結指到該模組實際的規格位置；模組還沒有規格時，附註「規格待建立」，不要留空連結。
5. 在對話中貼出寫入的完整內容，請使用者確認。

## 完成條件

1. `.github/specs/overview.md` 四層都有 What／Where／How／Who 四項內容。
2. 附了固定四層關係的 Mermaid 圖。
3. 使用者已確認過寫入的內容。
