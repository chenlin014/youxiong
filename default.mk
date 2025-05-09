# 输入引擎
input-engines=rime

# 用字标准
char-standards=zt jt jp
# 并击系统
system-zt=system/abc.json
system-jt=system/abc.json
system-jp=system/abc.json

# 字根方案
jz-scheme=xingyi
scheme-dir=jz-scheme/$(jz-scheme)
main-mb=$(scheme-dir)/main.tsv
# 并击方案
chordmap=$(scheme-dir)/chordmap/zaolin.tsv

# 代码
dm-tag=abyz
dm-maker=python mb-tool/mb_algebra.py --regex $(scheme-dir)/dm-$(dm-tag).yaml

# 生成字典
dict-gen=python mb-tool/steno_dict.py

# 生成简码
jianma-gen=python mb-tool/jianma-gen.py
# 取码法
az=0,-1
ab=0,1
yz=-2,-1
za=-1,0
ba=1,0
zy=-1,-2
jianma-methods=$(az):$(ab):$(yz):$(za):$(ba):$(zy)
# 简码名称
jm-name-zt=簡碼
jm-name-jt=简码
jm-name-jp=略コード
