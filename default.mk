# 输入引擎
input-engines?=rime

# 字体标准
char-standards?=ft jt jp
# 并击系统
system?=system/abc.json

# 解字方案
jz-scheme?=xingyi
scheme-dir?=jz-scheme/$(jz-scheme)
table?=$(scheme-dir)/$(jz-scheme).tsv
# 并击方案
chordmap?=$(scheme-dir)/chordmap/zaolin.tsv

# 代码
dm-tag?=abyz
dm-maker?=python mb-tool/mb_algebra.py --regex algebra/dm-$(dm-tag).yaml

# 生成字典
dict-gen?=python mb-tool/steno_dict.py

# 生成简码
jianma-gen?=python mb-tool/jianma-gen.py
# 取码法
az?=0,-1
ab?=0,1
yz?=-2,-1
za?=-1,0
ba?=1,0
zy?=-1,-2
jianma-methods?=$(az):$(ab):$(yz):$(za):$(ba):$(zy)
# 简码名称
jm-name-ft?=簡碼
jm-name-jt?=简码
jm-name-jp?=略コード
