# 有熊打字法
「有熊」结合了速录的并击法和形码的编码法。

先将要用的字分解成字根、再为每个字根配个并击手势。左右手各打一个字根、一击能打两个字根。

两个字根以内的字一击便能打出、故称单击字。多于两个字根的字需多击完成、故称多击字。简码能把多击字变成单击字。

理论上只要简码记得全、大部分常用字都能一击完成。如果再做到一秒两击、每分钟就能打120字了。

## 可更换
- 解字方案
- 并击系统
- 按式映射
- 简码生成法
- 单字频率

## 输入方案
[中州韻](https://github.com/chenlin014/rime-youxiong)

## 生成字典
[Make](https://www.gnu.org/software/make/manual/make.html)可用来生成字典、生成的文件会被放入build/。

## 解字方案

## 并击

### 并击系统
放于`system/`、json格式。

```yaml
"+2": "123890" # 上上排、一般键盘的数字键一排。
"+1": "abcCBA" # 上排、一般键盘的QWERTY一排。
"0":  "ghiIHG" # 中排、一般键盘的ASDFGH一排、双排速录机的下排。
"-1": "mnoONM" # 下排、一般键盘的ZXCVBN一排。
"thumb_keys": "stTS" # 拇指键
"key_order":  "1agm2bhn3cio0AGM9BHN8CIOstST" # 键序
```

### 并击表

## 简码

## 字频来源
- 正體：
    - [教育部語文成果網](https://language.moe.gov.tw/)
    - [字頻總表](https://language.moe.gov.tw/001/Upload/files/SITE_CONTENT/M0001/PIN/biau1.htm?open)
- 简体：
    - 北京语言大学，邢红兵 <xinghb@blcu.edu.cn>
    - [25亿字语料汉字字频表](https://faculty.blcu.edu.cn/xinghb/zh_CN/article/167473/content/1437.htm#article)
- 日文：
    - [文化庁](https://www.bunka.go.jp/)
    - [漢字出現頻度数調査](https://www.bunka.go.jp/seisaku/bunkashingikai/kokugo/nihongokyoiku_hyojun_wg/04/pdf/91934501_08.pdf)
