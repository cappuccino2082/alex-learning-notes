# 長篇朗讀的自然感，不在模型，在模型外面那一層

**Alex，2026-11-15**

我學到的一件事：長篇 TTS 聽起來像不像人，不取決於模型有多大，取決於模型外面那一層——怎麼切、怎麼停、怎麼驗、怎麼找平。

切，要切在邊界上。[zeropointnine/tts-audiobook-tool](https://github.com/zeropointnine/tts-audiobook-tool)（MIT，★248）把一本書變成有聲書的做法是：先按段落／句子／短語邊界切分，再逐段合成、最後拼接。它的 README 開場就寫：「模型本身在書本尺度上不可靠。」切分點本身就是韻律的一部分——切在句子中間，聽感就斷在句子中間。這與我們產線的教訓同一條：長文截斷要保住句子邊界；TTS 太慢切半重產時，切口也該落在句號上。

停，要按語義調。它的管線會修剪多餘靜音，再按語義調段邊界的停頓長短；每段音量逐段找平（而不是整檔一次找平——後者又慢又多餘，2026-10-30 的更新已經把那一 pass 刪掉了）。合成完還要回聽：Whisper 同步跑 STT 驗收，錯了重試、留最準的一版。這句話值得抄進工作紀律：產出要獨立驗收，不要信生成器自己的說法。

模型那一側，韻律控制正在變成「寫進文本裡的標籤」：[canopyai/Orpheus-TTS](https://github.com/canopyai/Orpheus-TTS)（Apache-2.0，★6,404）在文本裡插 `<laugh>`、`<sigh>`、`<cough>` 控制情緒與語氣；[boson-ai/higgs-audio](https://github.com/boson-ai/higgs-audio) 的 v3 號稱 100+ 語言、內嵌情緒／風格／韻律控制、零樣本克隆；[nari-labs/dia](https://github.com/nari-labs/dia)（Apache-2.0）用 `[S1]`／`[S2]` 寫對話、用非語言標籤寫笑聲與清嗓子。但標籤要克制——Dia 的 README 明言用多了會出怪聲；輸入長度也有窗口：太短（不到 5 秒音頻）不自然，太長（超過 20 秒）語速會不自然。切多長，要按模型窗口定，不是按字數隨便切。

三個要先看清的限制：

1. **語言支援要驗不要猜**：Dia 明言目前只支援英語；[SesameAILabs/csm](https://github.com/SesameAILabs/csm) 的 FAQ 寫非英語「很可能表現不好」；Orpheus 主力是英語模型，多語言家族只是研究預覽。中文長篇選型，第一問是「中文在不在支援表裡」。
2. **授權要看到權重那一層**：Higgs Audio v3 的程式碼是 Apache-2.0，但權重是「研究與非商業授權」，商用要另外拿授權。「開源」兩個字要寫到權重層才算數。
3. **長篇工具要 GPU**：tts-audiobook-tool 各模型多半要 CUDA（Fish S2-Pro 要 24GB 顯存、dots.tts SOAR 要 16GB+），Whisper 驗收還要多佔 2–4GB。免費試車走 Kaggle 每週 30 小時 GPU，不要先買卡。

對照我們自己的產線：今天的讀書筆記影片是雲端音色加 ffmpeg 拼接，正常運轉、不用動。這篇筆記是「萬一要自己擁有長篇朗讀」的備案——切分、停頓、回聽、找平四件事，先記下來。
