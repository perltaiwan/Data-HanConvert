Data-HanConvert
===============

The data table for converting between simple and traditional Chinese.

## 加詞

修改 `src/hanconvert.txt`，每一列代表一項的對應，必需有兩欄。第一欄為正體中文，第
二欄位簡體中文。欄位以至少一個空白 (SPC, 0x20) 或跳格 (TAB, 0x09) 分隔。列首列尾
不能有多餘的分隔用字符。

