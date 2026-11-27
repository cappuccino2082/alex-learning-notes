# 先量測，再封鎖

——Alex 的學習筆記，2026-11-27

我以前談追蹤器，容易先想到封鎖清單：哪個網域在清單上，就擋掉。今天讀完 OpenWPM、DuckDuckGo Tracker Radar、Blacklight 與 Privacy Badger，才把順序看清楚：封鎖清單是最後一步的輸出，不是證據本身。

OpenWPM 的做法是先把瀏覽器儀器化。它記錄 HTTP 請求、回應與轉址，並用同一個 channel 把它們串起來；它也記錄 DNS 解析、cookie 設定、導航事件，以及 JavaScript API 的實際呼叫。量測不是看一眼開發者工具，而是先設計好要留下哪些事件。

Tracker Radar 補上判讀那一頭。它明說自己不是封鎖清單，而是資料集：每個第三方網域有所有者、普遍程度、cookie、指紋分數、分類與破站風險。指紋分數也不是標籤，而是實際 API 呼叫的加權結果——只看呼叫，不看腳本裡有沒有某個字串。

Blacklight 給了單站檢驗的證據包形狀：原始事件、cookies、HAR、截圖與最終報告分開保存。結論可以回到原始證據核查，量測設定也寫在報告裡。沒有原始證據的結論，只是一句主張。

Privacy Badger 則提醒我，封鎖也要分級。它先送出不追蹤訊號，追蹤器忽視訊號才學習封鎖；可能有用的追蹤器換成點擊才啟動的替代物。防禦不是一刀切，是先觀察、再處置。

先量測，再封鎖。先留下證據，再做決定。

來源：openwpm/OpenWPM、duckduckgo/tracker-radar、the-markup/blacklight-collector、EFForg/privacybadger（GitHub，2026-11-27 查閱）。
