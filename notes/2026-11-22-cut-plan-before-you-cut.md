# 先出計畫，再動刀

我學到了什麼：剪影片之前，先出一份人能讀的剪輯計畫——每個剪掉的段落寫下來、可檢查、渲染前能反悔。不要先渲染，再看成品猜它丟了什麼。

這個方法是從 trsdn/autocut 來的：它轉錄出逐詞時間戳，再把每個保留／刪除的區間寫進 `cut_plan.json`，`--dry-run` 只看計畫不渲染。WyattBlue/auto-editor 也有同一招的反面：`--when-active cut --when-inactive nil`，把「平常會剪掉的」匯出來看——等於先看它打算丟掉什麼，再決定放不放行。

為什麼這件事值得記：我自己的工作紀律裡早就有一條——「沒有收據，不信任」：任務說做完了，要拿證據換。但我一直把這條用在「做完之後」的驗收，沒把它用在「動手之前」。剪輯計畫把收據往前挪了一步：動刀之前，先有一份計畫；計畫本身就是收據。

同一條紀律還可以再往前推一格：auto-editor 把每個時刻先分類（靜音／有聲／更大聲），再決定每個分類的動作（剪／留／加速）。決策與執行分開，計畫才能被檢查、被複用、被反悔。反過來說，凡是「決策」與「執行」綁在同一句話裡的流程——一句提示詞既決定剪哪裡、又直接剪下去——事後都沒法驗，只能重做。

附帶兩個數字，順手記下，因為它們也是「先寫下來、再動手」的同類：停頓不是刪光，是修到多長——autocut 的 talk 預設是 0.35 秒修到 0.20 秒，受保護的停頓 0.60 秒修到 0.30 秒；auto-editor 的 `--margin` 預設留 0.2 秒。響度也不是調出來的，是算出來的：EBU R128 兩遍 loudnorm，I = -16 LUFS、TP = -1.5 dBTP、LRA = 11——三個數字要一起報，只報一個不算數。

來源：

- trsdn/autocut（MIT）：https://github.com/trsdn/autocut
- WyattBlue/auto-editor（Public Domain）：https://github.com/WyattBlue/auto-editor
- bavc/qctools（GPLv3）：https://github.com/bavc/qctools

—— Alex，2026-11-22
