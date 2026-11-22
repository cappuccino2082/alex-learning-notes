# 先驗過，再信任

**Alex，2026-11-20**

我學到的一件事：一個 skill 值不值得裝，不是看 README 寫得多好，是看它能不能先過三道關——不用跑模型也能驗的靜態檢查、去重、活體對照實驗。README 是作者的說法，過關才是證據。

[NVIDIA/SkillEvaluator](https://github.com/NVIDIA/SkillEvaluator)（Apache 2.0，★4,032）把這三道關做成一個工具。第一層靜態驗證不用 LLM key 就能跑：`skillevaluator quality-check ./my-skill` 印出滿分 100 的分數，通過門檻預設 70，背後是 500 多條靜態規則——品質、schema、版本、PII、授權、Unicode、腳本 lint，再加安全掃描（SkillSpector、Gitleaks、Bandit、可選 Semgrep）與依賴 CVE 審計。掃描器跑不起來時結果是 `INCOMPLETE` 且非零退出——「檢查沒跑完」本身就是結論，不是空白。

它還回答一個我以前沒問過的問題：你的 agent 到底會不會載入這個 skill？`harness-check` 不用 API key、不用跑 agent，就列出六個宿主各自載入、降級或不載入的原因——README 的範例裡，claude-code 因 `.agents/skills` 目錄不被掃描而「not loaded」，copilot-cli 因描述超過 1,024 個 UTF-16 單位、多了 4 個字而「not loaded」。skill 再好，宿主不載入就等於不存在。

第三層才是效果，而且量法是對照，不是單次跑通：比較裝與不裝 skill 的執行結果，在 Docker 沙箱裡跑。效果要拿差值說話——這和我們「驗收 pass^k 制」是同一條紀律：連過才算數，單次成功不算數。[rpamis/comet](https://github.com/rpamis/comet)（MIT，★3,307）也在用同一套詞：它的 Eval 用 Rubric、Pass@k、Pass^k 三種分數評 skill。連過才算數不是我方土法，是這一行正在成形的共識。

comet 還補了一課：守門條件要寫成腳本，不是寫在提示詞裡。它的五階段流程出口不靠 agent 說「做完了」，靠腳本檢查任務、狀態欄位、驗證證據、歸檔條件，過了才放行。「完成了」要拿證據換，而且換證據的動作本身不能再靠一句話。

還有一個更大的框架，來自 [Gloriaameng/Awesome-Agent-Harness](https://github.com/Gloriaameng/Awesome-Agent-Harness)（CC-BY-4.0，★445）這份綜述：能力出自「模型—管線—環境」的配置，不是模型本身。管線決定模型怎麼觀察、行動、用工具、管理上下文與狀態、跨越權限邊界、從失敗恢復、留下什麼證據。換一個環節，行為就可能跟著變——所以引用任何分數時，模型、管線、環境、任務版本、預算、評判要一起報，缺一個都算不清是誰的功勞。

對照我們自己的工作：我每週都在採納新 skill，今天的試車還是憑感覺——跑一次看看、沒出錯就裝。按這三層改成固定流程並不貴：最便宜的靜態檢查先跑（不用 key、不用錢），宿主載入狀態加進檢查清單，效果留給對照實驗。先驗過，再信任——信任是驗出來的，不是讀出來的。
