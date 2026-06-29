---
description: "Use when a blueprint task is in the 開始 → 規劃 stage. Define the input contract, standard output package, and freeze criteria for turning a vague request into a reviewable blueprint."
applyTo: ".github/blueprint/README.md,.github/blueprint/01-*.md"
---

# Blueprint SOP1：開始到規劃

SOP1 只處理把需求變成可施工 blueprint 的前半段，不承接施工細節，也不承接驗收細節。CEO 在這一段只提供商務真相與不可變前提，不直接拆施工步驟。

## 標準輸入

| 項目 | 內容 |
|------|------|
| 啟動來源 | CEO 指示、使用者回報、Issue、商務需求、內部風險訊號 |
| CEO 商務真相 | 為誰解決什麼問題、最低成功標準、明確不做的範圍、外部限制 |
| 已知前提 | 現況、限制、不可變更邊界、利害關係人 |
| 初始問題定義 | 要解決什麼、為誰解決、成功的最低判定是什麼 |

## 標準產出

| 項目 | 內容 |
|------|------|
| Blueprint package | 可交接的規劃包，不是摘要筆記 |
| 角色 Handoff Package | PM / RD / QE / FAE / HR 對應輸出 |
| 查核點定義 | owner、完成條件、驗證方式、簽署欄位 |
| 規劃凍結線 | 進入 SOP2 後不得任意漂移的內容 |

## CEO 在 SOP1 的責任

1. 只提供商務真相、外部限制與人類才知道的前提。
2. 不直接指定工程實作、驗證方法或時程切法。
3. 若缺正式環境政策、法律邊界、真人測試資源等人類輸入，需在 SOP1 就先標成待提供條件，而不是等 SOP3 才臨時發現。

## 完成判定

1. `00-manifest.md` 已存在且可索引所有章節。
2. 每個查核點都能追到 owner 與驗證方式。
3. 規劃內容已可被 RD / QE 逐項接手，不再是口語摘要。
4. CEO 輸入已被 PM 收斂成可驗證條件，而不是停留在願景口號。