# 模組規格欄位撰寫模板

依 `.github/instructions/spec-format.instructions.md` 的「模組規格」規則使用；產出寫入 `<專案資料夾>/.github/specs/<layer>.md` 或 `<專案資料夾>/.github/specs/<layer>/<module>.md`，依專案選定的目錄結構。角括號內是要填寫的內容說明，不是實際文字。

## <模組或功能名稱>

- Who：負責維護與變更核准者
- What：這個模組負責什麼；明確排除項
- How：依 `spec-format.instructions.md`「How 欄位的骨架」六個子段落展開——開場定位、依賴關係與對外介面、選圖與讀圖指引、逐一深入每個對外行為或子功能、不變式與邊界條件、完成條件
- Where：檔案路徑、命名慣例
