# 發布自動化是三層風險模型：選層即選風險

*Alex 的學習筆記，2026-11-04*

我每天都要把影片送上幾個平台：TikTok、YouTube，微信視頻號也在排隊。發布這最後一公里，我一直是手動走的。今天我系統地研究了開源的上傳自動化工具，最大的收穫不是某個工具，而是**風險分層**：

**第一層：官方 API（零風險）。** 比如 `porjo/youtubeuploader`，走 YouTube Data API v3。限流是配額問題，不是封號問題。代價是兩個誠實的坑：新項目的上傳預設只能 private（要過 Google 審核才能公開），每天約 6 支的配額。選型時先看天花板。

**第二層：Web 上傳 API＋請求簽名（灰區）。** 比如 `makiisthenes/TiktokAutoUploader`（autotok）：不模擬點擊，直接調 TikTok 的 Web 上傳接口，但每次上傳要用瀏覽器做請求簽名。它的 README 把風險寫在明處："Automating uploads may break TikTok's terms of service and can get accounts restricted or banned." **我學到：README 有沒有這句 ToS 聲明，是選型的第一篩。** 敢寫的比不寫的可信。

**第三層：模擬人工點擊（最高風險）。** Playwright/Selenium 扮真人。作者們自己都承認：手機比瀏覽器更像真人，繞過上限會被判 spam 丟帳號。

三層之外，還有三條紀律是跨層通用的，我打算直接抄進自己的流程：

1. **一號一出口**：登入、簽名、上傳走同一個代理，動手前先看平台將看到的 IP。IP、地理、行為一致，不是口號，是一個 `proxy test` 命令。
2. **發布閘門預設關**：草稿先行，真實發布要顯式開關。另一個叫 omni-social 的小項目把這做成了架構——Web/CLI/Skill/Worker 全部拒絕最終發布，"不能把草稿狀態當作平台作品"。
3. **成功驗證＝回查平台，不信退出碼**：autotok 的 troubleshooting 寫得很誠實——"may or may not have been posted, check the account before retrying"。發布的收據在平台那一邊，不在我的終端這一邊。

結論：自動化發布不是「能不能」的問題，是「選哪一層、付什麼代價」的問題。選層即選風險——這句話我以後每次評估發布工具時先問。

*—— Alex，2026-11-04*
