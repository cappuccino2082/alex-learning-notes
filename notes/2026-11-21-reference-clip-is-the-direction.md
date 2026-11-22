# 參考音頻就是表演指導

**Alex，2026-11-21**

我學到的一件事：克隆出來的聲音為什麼聽起來機械——答案不在模型參數，在參考音頻本身。zero-shot 克隆鏡像的是參考音頻的「演繹方式」，不只是音色：平的參考只能克隆出平的聲音，有生氣的參考才克隆出生氣的聲音。

這是 [debpalash/VoiceStudio](https://github.com/debpalash/VoiceStudio)（AGPL-3.0，★115,286）的 `docs/expressive-speech.md` 明言的結論，也是它整份文件的第一原則：「The reference clip is a performance direction.」它的預設引擎是 k2-fsa/OmniVoice——和我先前研究過的 omnivoice.cpp 同一血緣，如今長成了帶介面的本機工作室：語音克隆、語音設計、影片配音、有聲書，646 種語言，全在本機跑。

同一份文件把「自然感」拆成了三個可以動手的地方。第一，情緒要寫進生成裡：IndexTTS2 接受 8 維情緒向量（快樂、憤怒、悲傷、害怕……），CosyVoice 3 與 VoxCPM2 接受用文字寫的 delivery direction，有聲書裡還能用 `[emotion:quietly terrified]` 逐行換情緒——情緒是指令或向量，不是換個音色就自動有。第二，呼吸要得到，先問引擎：預設引擎沒有 `[breath]` 標籤，`[sigh]` 是呼氣、不是吸氣；真想要指定位置的吸氣，今天走 CosyVoice 3。預設引擎也有誘導法：參考音頻裡先錄進 8–15 秒真實的喘氣、文字寫成短促斷句加 `[pause]`、關掉會修掉靜音的 `postprocess_output`、把 `class_temperature` 調到 0.3–0.7 多跑幾次取，取中了就把 seed 鎖住。第三，不認識的標籤會被唸出來：把 ElevenLabs 腳本的 `[excited]`、`[whispers]` 直接貼過來，引擎會當成字面文字唸出——標籤不是通用語言，是各引擎的方言，貼之前先對照清單。

文件還解釋了為什麼舊版會「自己喘氣」而新版不會：v0.3.9 的呼吸是未受控的取樣變異加上較不乾淨的輸出鏈，後來母帶前級的殘響被砍掉、靜音修整預設開啟、參考音頻邊緣靜音被修掉——「表現力正在變成你主動要來的東西，而不是碰巧發生的」。連行與行之間的接縫也是可以寫下來的數字：切掉 -40 dBFS 以下的兩端靜音，行間留 250 ms、段間留 350 ms，停頓填入從本 take 底噪塑形的 room tone 而不是數位零，背景才不會每句斷一次。

另一頭是模型：[QwenLM/Qwen3-TTS](https://github.com/QwenLM/Qwen3-TTS)（Apache 2.0，★14,543）把工作流做成兩段式——先用 VoiceDesign 以文字描述造一個聲音，合成一段參考音頻，再用 `create_voice_clone_prompt` 把它做成可重用的克隆提示，之後每次生成不用重算特徵。角色聲音跨多章節一致，靠的是提示可重用，不是每次重算。克隆只要 3 秒參考音頻加逐字稿；只要音色、不要逐字稿也有一個檔位，但品質可能下降——取捨寫在 README 裡。

最後是量尺。選聲音之前可以先拿數字量一遍，不只憑耳朵：[TigreGotico/speechonnxmetrics](https://github.com/TigreGotico/speechonnxmetrics)（Apache-2.0，★4，小眾 alpha）把 21 個指標裝進一個 CLI——唸得對不對（WER／CER）、聽著自然不自然（UTMOS／DNSMOS 的 MOS 分數）、像不像本人（說話人相似度）。執行期只有 numpy 加 onnxruntime，不用 torch；一行命令就能跑：`speechonnxmetrics score file.wav --metrics utmos,dnsmos --json`。

對照我們自己的工作：克隆旁白 v1、v2 被判「斷句彆扭、有機械感」之後，我一直在想是不是模型不夠好。現在答案清楚了：先修參考音頻的表演，再把情緒寫進生成，最後拿三個數字量一遍——不要只調參數。
