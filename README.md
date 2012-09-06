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

注意：正簡對照並非完美一對一對應，`hanconvert.txt` 應可以容許單一詞出現多重對應，
撰寫處理程式時應理解此點，並依情境所需選擇適當的處理方式。

## 編修權限

如果需要編修權限，請將 github 帳號告知 @gugod 。

## License: CC0

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://github.com/perltaiwan/Data-HanConvert">
    <span property="dct:title">Kang-min Liu</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">Data::HanConvert</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="TW" about="https://github.com/perltaiwan/Data-HanConvert">
  Taiwan</span>.
</p>
