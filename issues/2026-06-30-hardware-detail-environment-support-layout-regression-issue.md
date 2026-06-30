# Issue: Hardware Detail 環境安裝與支援版面回歸異常

- Date: `2026-06-30`
- Issue Type: `production UI regression`
- Reporter: `field-application-engineer`
- Severity: `high`
- Current Status: `open`

## Issue Classification

| Field | Value |
| --- | --- |
| Problem Class | Layout regression |
| Affected Surface | `/hardware/<slug>` public detail page |
| User Impact | `Overview` 與 `環境安裝與支援` 切換後的版面結構異常，使用者看到不符合預期的主內容排版 |
| Reproduction Status | Reproduced from live site screenshot |

## Reproduction Summary

1. 開啟 `https://ai-hub-portal.azurewebsites.net/hardware/asus-expertcenter-pn54-pn54-ai7-350#overview`。
2. 觀察 `Overview` 畫面與主內容區塊。
3. 再切換到 `https://ai-hub-portal.azurewebsites.net/hardware/asus-expertcenter-pn54-pn54-ai7-350#environment-support`。
4. 實際結果：`環境安裝與支援` 畫面仍包在深色 hero 區塊風格中，主內容尺寸、留白與區塊層次和預期不一致；使用者明確回報「版面壞掉了」。

## Expected Behavior

1. `Overview` 與 `環境安裝與支援` 應作為上方主內容切換區。
2. `環境安裝與支援` 不應看起來像殘留在舊 hero 容器或與下方固定支援區混疊。
3. 下方區塊應固定是 `技術支援與合作`，視覺上獨立於上方主內容切換區。

## Evidence

| Evidence ID | Description |
| --- | --- |
| EV-01 | 使用者提供 live site screenshot：`Overview` 畫面與 `環境安裝與支援` 畫面皆顯示在深色 hero card 視覺內，使用者明確判定版面異常。 |
| EV-02 | 目前 repo 內已有針對切換式主內容的本地修正，但 live 畫面仍呈現異常，疑似部署版本與預期 IA / CSS 呈現未對齊。 |
| EV-03 | 先前內容編碼問題已分流到另一張 issue；本單只處理 live layout regression。 |

## Suspected Owners And Action Items

| Owner | Action Item | Done When | Verification |
| --- | --- | --- | --- |
| `senior-software-engineer` | 比對 live 版面與 repo 內目標版面，確認是 template、CSS、JS 還是部署版本不一致造成的 regression | 已可明確指出 root cause，並完成修正 | Local render review + live page compare |
| `ui-ux-designer` | 重新確認 `Overview / 環境安裝與支援 / 技術支援與合作` 三者的視覺層級與區塊邊界 | 有一份可驗證的目標排版結論 | Screenshot review |
| `testing-quality-engineer` | 補一條針對 hardware detail 主內容切換版面的驗收檢查 | Regression 不再重現 | Narrow test + live smoke |
| `field-application-engineer` | 維持本 issue 作為使用者回報與 closure recommendation 真相源 | Issue 欄位與證據完整 | Issue completeness review |

## Closure Criteria

1. live `/hardware/<slug>` 的 `Overview` 與 `環境安裝與支援` 視覺層級符合設計預期。
2. `環境安裝與支援` 不再呈現「版面壞掉」的主觀異常狀態。
3. 下方 `技術支援與合作` 區塊和上方主內容切換區有明確分離。
4. 修正後需附 live screenshot 或同等級可追溯證據。