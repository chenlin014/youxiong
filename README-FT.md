[简体中文](README.md) | 繁體中文

# 有熊打字法
「有能」結合了速錄的並擊法和形碼的編碼法。

先將漢字分解成字根、再爲每個字根配個按式。左右手各打一个字根、一擊能打兩個字根。

## 可更換
- 解字方案
- 並击系統
- 按式映射
- 簡码生成法
- 單字頻率

## 輸入方案
[中州韻](https://github.com/chenlin014/rime-youxiong)

## 生成字典
[Make](https://www.gnu.org/software/make/manual/make.html)可用來生成字典、生成的文件会被放入build/。

## 解字方案

## 並擊

### 並擊系統
存于：`system/`。格式：`json`。

```yaml
"+2": "123890" # 上上排、一般鍵盤的數字鍵一排。
"+1": "abcCBA" # 上排、一般鍵盤的QWERTY一排。
"0":  "ghiIHG" # 中排、一般鍵盤的ASDFGH一排、雙排速錄機的下排。
"-1": "mnoONM" # 下排、一般鍵盤的ZXCVBN一排。
"thumb_keys": "stTS" # 拇指鍵
"key_order":  "1agm2bhn3cio0AGM9BHN8CIOstST" # 鍵序
```

### 並擊表
存于：`jz-scheme/(解字方案)/chordmap/`。格式：`tsv`。

並擊表的職責是爲解字方案中的每個字根和編碼分配按式。表中的每一行都有三個部分、開頭的字根或編碼、中間的制表符、和最後的並擊碼。

```yaml
艹    1100 # 左右手都能按
䒑    1100a
能    <00001 # 「<」开头的只能左手按
重    >00001 # 「>」开头的只能右手按
```

```
0112
○●●○    ○●●○    qwer    uiop
○○○●    ●○○○    asdf    jkl;

0312
○●●○    ○●●○    qwer    uiop
○●○●    ●○●○    asdf    jkl;
```

並擊碼中的每個數字都對應着鍵盤上的一行。第一个數字對應小指一行、第二个數字對應無名指一行、以此類推。

#### 行列碼
|   | 0 | 1 | 2 | 3 | 4 | 5 |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 上 | |X| |X| | |
| 中 | | |X|X| |X|
| 下 | | | | |X|X|

#### 拇指碼
|   | 內 | 中 | 外 |
|:-:|:-:|:-:|:-:|
| a |X| | |
| b | |X| |
| c |X|X| |
| d | |X| |
| e | |X|X|

## 簡碼

## 可用字頻
- 繁體：
    - [教育部語文成果網](https://language.moe.gov.tw/)
    - [字頻總表](https://language.moe.gov.tw/001/Upload/files/SITE_CONTENT/M0001/PIN/biau1.htm?open)
- 简体：
    - 北京语言大学，邢红兵 <xinghb@blcu.edu.cn>
    - [25亿字语料汉字字频表](https://faculty.blcu.edu.cn/xinghb/zh_CN/article/167473/content/1437.htm#article)
- 日文：
    - [文化庁](https://www.bunka.go.jp/)
    - [漢字出現頻度数調査](https://www.bunka.go.jp/seisaku/bunkashingikai/kokugo/nihongokyoiku_hyojun_wg/04/pdf/91934501_08.pdf)
