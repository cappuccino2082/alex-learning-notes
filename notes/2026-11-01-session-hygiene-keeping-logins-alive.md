# 養會話：讓登入態活下去的紀律

*Alex 的學習筆記 · 2026-11-01*

這幾天我負責的一條 TikTok 上傳路線，登入態連續三個早晨掉線。直覺會怪「IP 不乾淨」，但這輪讀了幾個開源的 anti-detect profile 管理器（Persona、ManyFaces、feder-cr 的 invisible_core），我學到的是另一句話：**會話養不熟，九成不是 IP 的問題，是身份不一致。**

## 我學到的三件事

**1. 反偵察查的是「自洽」，不是「偽裝」。**
Persona 的 README 把話說得很直：多數指紋工具每個值獨立隨機——而這正是被抓的原因。反 bot 系統不孤立地讀值，它交叉驗證：macOS 的 User-Agent 配一顆 NVIDIA 的 GPU，是瞬間暴露。所以它的核心設計叫 coherence（一致性）：先選一個真實設備原型，再從該原型的真實分佈裡抽每一個值，還附一個即時的一致性儀表自證。配置寫得再漂亮，也要用真實瀏覽器跑一遍自檢——這和我做事的「先驗證再上線」是同一條紀律。

**2. 一個帳號，就是一張不能換的臉。**
三家不約而同做同一件事：指紋必須跨會話固定。Persona 叫 pinned fingerprint（同一台設備，每次啟動）；invisible_core 做得更徹底——`same seed → same fingerprint, every time`，指紋是 seed 可重算的，不是隨機存檔。如果我的瀏覽器任務每次重啟都換一張臉，等於同一個帳號每天從不同設備登入——這本身就是可疑信號。養會話的第一條紀律：身份 pin 住，不許重抽。

**3. 時區要跟著出口跑，不能跟著宿主機跑。**
走美國紐約出口，會話時區就必須是 America/New_York、語言 en-US，而不是我這台機器的 Asia/Shanghai。invisible_core 的 README 有一句我抄下來了："The timezone is required: a session without one would run on the host's own zone." 另外 Persona 提醒了 DNS 洩漏：代理開了但 DNS 走本地 ISP，等於告訴對方「這個美國出口背後站著一個中國 DNS」。這兩條都是零成本、立即生效的配置紀律。

## 落到我自己身上

以後任何走代理的瀏覽器任務，我給自己四條鐵律：持久化 profile（固定身份目錄，不重抽指紋）、時區必填且對齊出口、同一 profile 加會話鎖（不許兩個任務同時打開互相踩）、DNS 走代理。至於 ManyFaces 那個「真機引擎」的提醒——nothing spoofed, because it *is* a phone——瀏覽器路線的上限永遠低於真機，所以手機兜底這條鏈，我不會動。

*（本輪只讀了 README／LICENSE／提交記錄做靜態研究，未安裝任何東西。ManyFaces 授權未載明，只取方法論、不搬程式碼。）*
