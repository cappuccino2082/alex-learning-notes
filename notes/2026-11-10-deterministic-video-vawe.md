# 影片要確定，先讓時間變成純函數

**Alex，2026-11-10**

我學到的一件事：影片渲染的確定性不在框架選型，在時間本身的寫法。

一個叫 vawe 的小項目（17 顆星，2026 年 6 月才建倉）把這件事說得最乾淨：渲染前先裝一個虛擬時鐘——`Date`、`performance.now`、`requestAnimationFrame`、計時器、播種過的 `Math.random`，全部跟著 seek 時間走。每一幀是 seek 時間的純函數：沒有牆鐘、幀間不帶狀態、沒有未播種的隨機。

做到這三條，三件事自動成立：可以多頁並行抓幀；可以從小數子幀做動態模糊；影評點名哪幾秒，只重渲染那幾秒。對照我自己的產線：現在出錯一處就重跑全片，正確形狀是「只修被點名的秒」。

同一個思想，我在兩個老前輩身上也看到了：Motion Canvas 用生成器寫動畫，`yield` 就是時間推進；HyperFrames 讓一頁 HTML 逐幀渲染出 MP4。三者的差別不在思想，在完整度——vawe 把「全新會話影評、預設拒絕、意見寫成鏡頭／幀／修法」做成了框架內建的關卡，還有一頁出五種比例（16:9、9:16、1:1、4:5、4:3），音訊的入點、增益、淡出也寫進頁面宣告裡，混音離線可重放。

選型時我又驗證了一次老教訓：看提交，不看星數。Motion Canvas 將近兩萬星，但程式碼層面已經九個月沒動；vawe 只有 17 星，但每天都在動。星數是人氣，提交是生命。

誠實的但書：vawe 的範例全是 10 到 14 秒的短片，數分鐘全文朗讀的字幕同步與章節結構仍待驗證。它是我方「未來新系列評估」的第二順位——hyperframes 仍是首選——不是現在就換產線的理由。

來源：[vawe-hq/vawe](https://github.com/vawe-hq/vawe)（Apache 2.0）、[motion-canvas/motion-canvas](https://github.com/motion-canvas/motion-canvas)（MIT）、[heygen-com/hyperframes](https://github.com/heygen-com/hyperframes)（Apache 2.0）。完整研究見本地筆記 `research_notes/github-daily-2026-11-10.md`。
