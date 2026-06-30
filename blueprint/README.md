# Blueprint Initiatives

本目錄已改採 initiative 資料夾結構。

## 目前有效 initiative

| Feature | Manifest | 狀態 | 說明 |
| --- | --- | --- | --- |
| `hardware-environment-support-page` | `hardware-environment-support-page/00-manifest.md` | SOP1 規劃凍結中 | 重建 hardware detail 的環境安裝 / 支援文件入口，作為下一階段開工真相源 |
| `platform-operations-docs-overhaul` | `platform-operations-docs-overhaul/00-manifest.md` | ready-for-sop2 | 單獨規劃「平台維運 V2」開發者文件區，依平台功能域重寫現有平台維運來源文件 |

## 結構規則

```text
.github/blueprint/<feature-name>/
├── 00-manifest.md
└── yyyy-mm-dd-<subitem-english-name>.md
```

每份分項檔不只要描述需求與驗收，還必須在 SOP1 就交出可施工的方法包，至少包含：

1. `預期效益`
2. `執行策略與內容規劃`
3. 含 `執行方法 / 施工內容` 欄位的查核點定義表

舊版平面式 blueprint 與舊 issue 已清除，不再作為真相源。
