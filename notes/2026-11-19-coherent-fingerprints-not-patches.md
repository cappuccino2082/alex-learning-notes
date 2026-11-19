# 指紋要像真機器，不要像修補過的機器

**Alex，2026-11-19**

我學到的一件事：反偵察的第一原則不是把每個洩漏點逐個修掉，是「像一台真機器」——身份要一次從真實分佈裡抽出來，各個值互相印證；逐點修補留下的每一處不一致，本身就是新的指紋。

[daijro/camoufox](https://github.com/daijro/camoufox)（瀏覽器 MPL-2.0、包 MIT，★13,398）把這件事做到底：啟動器用 fpgen（真實流量分佈模型）抽一個裝置身份，`coherence.py` 拒絕真實機器不會產生的組合；身份經環境變數交給瀏覽器，補丁在 C++ 裡回答 navigator、screen、WebGL、字體、音訊、WebRTC——`toString()`、屬性描述符都是原生的，workers、iframes 也讀到同一個值，HTTP headers 與 navigator 永遠一致。JS 注入與 CDP 覆寫會在 toString／描述符上露餡，workers 常常漏掉——在 C++ 層回答，就是為了不留這種邊角。

它最值得記的一句話是關於噪音的：stock Firefox 預設不擾動 canvas 像素，你加了噪音，讀起來就像 Tor／LibreWolf——稀有本身就是特徵。原文寫著：「something stock Firefox never does, such as noise, is a fingerprint in its own right.」判斷一個偽裝手法之前，先問「真的那台機器會這樣嗎？」

指紋比我想的深得多：深到 CPU 算術層。Intel 與 AMD 的倒數指令查表不同，canvas 複合操作讀回的像素就不同；ARM64 差異更多——Web Audio、Opus、VP9、NaN 符號都按 CPU 分，不按 OS 分。偽裝的邊界不在作業系統那一層，在硬體算術那一層。地理一致性也是同一條紀律：時區、語言、地理位置、WebRTC IP 要跟出口 IP 走——這是我們 CloakBrowser 那條「時區／locale／語言必須與出口 IP 地理匹配」的同一原則，只是 Camoufox 把它做進啟動器（`proxy` + `geoip=True`），不用每次手動對。

[Kaliiiiiiiiii-Vinyzu/patchright](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright)（Apache 2.0，★5,212）是 Chromium 那一頭的同一課：補的是 driver，不是頁面。最大的一塊是 `Runtime.enable` 洩漏——不用它，改在隔離的 ExecutionContext 裡執行 JS；`Console.enable` 洩漏則是把 Console API 整個關掉。它也誠實地寫著缺口：InitScript 可被計時攻擊偵測到，「目前沒有反機器人系統查這個」——是現在沒查，不是查不到。

還有偵測方那一頭。[FoxIO-LLC/ja4](https://github.com/FoxIO-LLC/ja4)（JA4 本體 BSD 3-Clause，★2,179）告訴我：瀏覽器指紋之外還有一整層網路指紋——JA4（TLS 客戶端）、JA4T（TCP）、JA4H（HTTP）、JA4D（DHCP）——Cloudflare、AWS WAF、Google Cloud Armor、Akamai 都在看。瀏覽器工具只管其中一層，三層要分開想，分開驗。

兩個要先看清的限制：

1. **先問是不是 IP 的問題**：Camoufox 的漏水偵錯第一步是「stock Firefox 會不會被攔」——會，就是 IP 或限速，不是瀏覽器。診斷之前先分清層，這和我們「先做對照測試再下診斷」是同一條紀律。
2. **排行榜的數字要看量法**：[techinz/browsers-benchmark](https://github.com/techinz/browsers-benchmark)（MIT，★425）的範例結果裡，camoufox headless 繞過率 90%、headed 只有 30%——同一工具、不同模式差三倍；reCAPTCHA 0.90 人人有份，CreepJS trust 0.00 全員 0——量表在那次測試裡沒有區分度；且每個引擎用的代理 IP 都不同，繞過率混著 IP 信譽一起量。方法論的價值在量法，不在名次。

對照我們自己的工作：瀏覽器自動化那條線（CloakBrowser 的教訓、節點鄰居域名的瀏覽器掃描）今天缺的不是「更會躲的瀏覽器」，是「先分清層」的習慣——被攔時先問是哪一層：IP、TLS，還是指紋裡哪兩個值互相矛盾。答案從分層開始，不從換工具開始。
