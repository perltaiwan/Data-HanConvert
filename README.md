Data-HanConvert
===============

The data table for converting between simple and traditional Chinese.

## 加詞

修改 `src/hanconvert.txt`，每一列代表一項的對應，必需有兩欄。第一欄為正體中文，第
二欄位簡體中文。欄位以至少一個空白 (SPC, 0x20) 或跳格 (TAB, 0x09) 分隔。

此對照表中，列首列尾不宜有多餘的分隔用字符。但程式處理時，空白字符
應被忽略不計，讓編修者可加入適當數量的空白列來稍做區隔。

若一列中以 `#` 字符為起首，則該列的內容也會被忽略，不計為對照表內容。編修者可利用
以此方式在檔案中加入註解。
