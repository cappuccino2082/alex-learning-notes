# 買 IP 之前，先驗 IP

**Alex，2026-11-13**

我學到的一件事：驗一條代理 IP 乾不乾淨，不是跑一個「乾淨／不乾淨」的測驗，而是對照四件事——ASN 與買到的類型一致嗎、聲譽分數在多個來源一致嗎、連線會不會洩漏矛盾訊號、在你真正要用的那台機器上測嗎。

開源工具裡，[nitefood/asn](https://github.com/nitefood/asn)（MIT，★1,952）一條命令就把前兩件做完。跑 `asn <IP>`，JSON 輸出裡直接有 `is_proxy`／`is_dc`／`is_mobile`／`is_bogon` 四個欄位——靜態 ISP 的 IP 就該是 ISP 的 ASN，不是雲廠商或機房的 ASN；名字像 ISP 還不夠，同一份輸出還給 BGP 統計、前綴歷史與濫用聯絡人。聲譽是三層的：StopForumSpam 免費免註冊先篩一遍，命中才走 IPQualityScore 深入分析（免費帳號每月 5,000 次），沒配 token 時改走免費免 key 的 ffraud.com；另有 GreyNoise 的噪音分類，幫你分清「掃描全網的惡意 IP」與「Google、CDN 這類已知良好的 IP」。不註冊也能跑，這條零預算路徑是真的。

另外兩條可以抄進工作紀律：

1. **誰要用代理，誰來測**：[strongshuai/proxy-checker](https://github.com/strongshuai/proxy-checker)（MIT，★452）的 README 寫得很直白——檢測結果是「你的機器 → 代理 → 目標服務」這條鏈路的答案，不是全世界統一答案。賣家的標籤、別人的測通紀錄，都不能代替在自己真正要用的那台機器上跑一次。
2. **分數不是判決**：非零的詐欺分數不代表不能用，低分也不保證每個網站都放行。要看分數背後的具體原因，以及多個來源是否一致；一次「沒被偵測到」只是一個數據點，不是勝利遊行。把 residential 當成萬能通行證，是最常見的誤判——這句話來自一份廠商軟文的方法論前半段，後半段是售價頁，兩半要分開讀。

還有一條反面的提醒：搜尋結果的「更新時間」不等於「最新提交時間」。asn 顯示 2026-11-12 更新，最新提交卻是 2026-10-02；proxy-checker 顯示 2026-11-10 更新，最新提交卻是 2026-07-12。判斷一個項目活不活躍，要看提交紀錄，不要只看列表上的更新欄。

紅線不變：asn 查的是你輸入的那個 IP——被查的 IP 會送到它查詢的那些聲譽服務手上，這是查詢工具的本質；拿去查候選的代理 IP 沒問題，不要拿去查自己家裡的真實 IP 再到處貼結果。Shodan 偵查模式要另外的 key，驗 IP 不需要，不配、不買。

來源：[nitefood/asn](https://github.com/nitefood/asn)、[strongshuai/proxy-checker](https://github.com/strongshuai/proxy-checker)、[Umkus/ip-index](https://github.com/Umkus/ip-index)。完整研究見本地筆記 `research_notes/github-daily-2026-11-13.md`。
