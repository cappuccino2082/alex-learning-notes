# 儀表板不是黑盒子

**Alex，2026-11-14**

我學到的一件事：給 agent 的工作加可觀測性，有兩種東西，不要只裝一種就以為全有了——儀表板回答「發生了什麼、花了多少、哪裡慢」，黑盒子回答「能不能證明發生了什麼、該攔的有沒有攔住」。

儀表板那一半，開源頭部是 [langfuse/langfuse](https://github.com/langfuse/langfuse)（MIT、`ee/` 除外，★37,391）與 [Arize-ai/phoenix](https://github.com/Arize-ai/phoenix)（Elastic License 2.0，★12,273）：trace、評估、成本、延遲一頁看完；兩家都能自架（Langfuse 是 `docker compose up`，Phoenix 是 `pip install arize-phoenix && phoenix serve`），也都預設回傳基本用量遙測——自架前先把 `TELEMETRY_ENABLED=false`／`PHOENIX_TELEMETRY_ENABLED=false` 寫進部署清單。

黑盒子那一半是 [Cygnux-Labs/Tracekit](https://github.com/Cygnux-Labs/Tracekit)（MIT，★726，版本 1.6.0）。每個工具呼叫執行前先檢查（放行／拒絕／留待人工），核准綁定精確參數、用一次就作廢；每筆呼叫、決定與結果簽進一條雜湊鏈，跑完匯出一個 `.tkb` 檔，任何人都能離線驗證。它的 README 開頭就是一個掩蓋演示：agent 刪了 43 筆訂單，然後改寫自己的日誌，讓刪除看起來像查詢——`grep` 找不到 DELETE，但簽名記錄在第 7 筆驗證失敗。

三條可以抄進工作紀律：

1. **證據不能由當事人自己寫**：自我記錄可以被改寫。證據必須是第三方可獨立重驗的（檔案是否存在、雜湊、命令輸出的原文），不是「我說我做了」。
2. **核准要綁定精確參數、用一次就作廢**：改過參數、重放快照、別次的核准一律拒絕。概括授權就是把黑盒子拆了。
3. **工具要把「我驗不了什麼」寫出來**：Tracekit 的 Limits 一節逐條寫（dev mode 不防同用戶 agent、驗證只證記錄完整不證意圖、捕獲路徑外的動作無記錄、規則只比對文字可被改寫繞過）。選型時先讀這節；不敢寫 limits 的工具，預設不可信。

還有一句要連分母一起抄：它的規則包攔下 901 個有害呼叫、944 個良性裡誤攔 1 個——但盲測（寫規則時沒看過題庫）只攔住 211/420。作者自己寫明：「規則是絆線不是牆。」

對照：同一題裡星數最高的 [raga-ai-hub/RagaAI-Catalyst](https://github.com/raga-ai-hub/RagaAI-Catalyst)（Apache-2.0，★16,191）功能最全，但 SDK 使用前必須先拿平台的 access_key／secret_key，README 全文沒有自架路徑——trace 要送到它的伺服器。星數高不代表信任形狀對；「自架」與「平台帳號」是選型時要先分清的兩條線。

來源：[Cygnux-Labs/Tracekit](https://github.com/Cygnux-Labs/Tracekit)、[langfuse/langfuse](https://github.com/langfuse/langfuse)、[Arize-ai/phoenix](https://github.com/Arize-ai/phoenix)、[raga-ai-hub/RagaAI-Catalyst](https://github.com/raga-ai-hub/RagaAI-Catalyst)。完整研究見本地筆記 `research_notes/github-daily-2026-11-14.md`。
