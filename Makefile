# = 載入設置文件 =
# -include: 有的話就載入、沒有就算了
ifeq ($(config),) # 如果沒有指定設置文件
-include custom.mk
else
-include $(config)
endif
# 默認設置、不更改先前載入的設置
include default.mk

all: $(foreach engine,$(input-engines),$(engine)_all)

# 創建build目錄
build:
	mkdir $@

daima: daima-.

daima-%: build
	$(eval ver = $(subst -.,,-$(*)))
	$(eval table$(ver) ?= $(scheme-dir)/$(jz-scheme)$(ver).tsv)
	$(dm-maker) $(table$(ver)) > build/daima$(ver).tsv

jianma: jianma-.

jianma-%: build
	$(eval ver = $(subst -.,,-$(*)))
	$(eval table$(ver) ?= $(scheme-dir)/$(jz-scheme)$(ver).tsv)
	$(eval common$(ver) ?= char_set/common$(ver))
	awk -F'\t' '$$2 ~ /.{3,}/ {print $$1"\t"$$2}' $(table$(ver)) | \
		python mb-tool/subset.py --second-table $(common$(ver)) | \
		$(jianma-gen) 0:0,0,0:$(jianma-methods) --freq-table $(char-freq$(ver)) | \
		sed -E 's/\t(.)..$$/\t空\1/' > build/jianma$(ver).tsv

dict: dict-.

dict-%: daima-%
	$(eval ver = $(subst -.,,-$(*)))
	$(eval system$(ver) ?= $(system))
	cat build/daima$(ver).tsv | \
		sed 's/./& /g; s/ $$//; s/ \t /\t/' | \
		python mb-tool/apply_priority.py -c $(scheme-dir)/priority-table/$(dm-tag)$(ver).csv -u '9,8,7,6,5,4,3,2,1' | \
		sed -E 's/\t(.)\t8$$/\t空 \1\t8/' | \
		$(dict-gen) $(system$(ver)) $(chordmap-file) > build/dict$(ver).tsv

jm-dict: jm-dict-.

jm-dict-%: jianma-%
	$(eval ver = $(subst -.,,-$(*)))
	$(eval system$(ver) ?= $(system))
	cat build/jianma$(ver).tsv | \
		sed 's/./& /g; s/ $$//; s/ \t /\t/' | \
		sed -E 's/$$/简/' | \
		$(dict-gen) $(system$(ver)) $(chordmap-file) > build/jm-dict$(ver).tsv

ifeq ($(char-standards),)
rime_all: rime-.
else
rime_all: $(foreach std,$(char-standards),rime-$(std))
endif

rime-%: dict-% jm-dict-%
	$(eval ver = $(subst -.,,-$(*)))
	cat build/dict$(ver).tsv | \
		script/format.sh rime > build/rime$(ver).tsv
	printf "\n# $(jm-name$(ver))\n" >> build/rime$(ver).tsv
	cat build/jm-dict$(ver).tsv | \
		script/format.sh rime >> build/rime$(ver).tsv

clean:
	rm build/*

check-priority: check-priority-.

check-priority-%:
	$(eval ver = $(subst -.,,-$(*)))
	python mb-tool/check_priority.py --char-only $(scheme-dir)/priority-table/$(dm-tag)$(ver).csv build/daima$(ver).tsv

check-chordmap:
	python mb-tool/find_duplicate.py $(chordmap-file)
ifeq ($(char-standards),)
	python mb-tool/code_freq.py $(table) | \
		python mb-tool/subset.py --sym-diff $(chordmap-file)
else
	$(eval cs ?= $(word 1,$(char-standards)))
	$(eval table-$(cs) ?= $(scheme-dir)/$(jz-scheme)-$(cs).tsv)
	python mb-tool/code_freq.py $(table-$(cs)) | \
		python mb-tool/subset.py --sym-diff $(chordmap-file)
endif

no-jianma: no-jianma-.

no-jianma-%: jianma-%
	$(eval ver = $(subst -.,,-$(*)))
	python mb-tool/subset.py $(table$(ver)) $(common$(ver)) | \
		awk -F'\t' '$$2 !~ /.{3,}/ {next}1' | \
		python mb-tool/subset.py build/jianma$(ver).tsv --diff --second-table

ifeq ($(char-standards),)
code_freq: code-freq-.
else
code_freq: $(foreach std,$(char-standards),code-freq-$(std))
endif

code-freq-%: daima-% jianma-% stat/code_freq/$(jz-scheme)
	$(eval ver = $(subst -.,,-$(*)))
	# 全码
	python mb-tool/code_freq.py $(table$(ver)) --freq-table $(char-freq$(ver)) > stat/code_freq/$(jz-scheme)/full$(ver)
	# 代码
	$(dm-maker) $(table$(ver)) | \
		python mb-tool/code_freq.py --freq-table $(char-freq$(ver)) > stat/code_freq/$(jz-scheme)/$(dm-tag)$(ver)
	# 简码
	awk -F'\t' 'length($$2) > 2 {next} 1' $(table$(ver)) > build/tmp
	cat build/jianma$(ver).tsv >> build/tmp
	python mb-tool/code_freq.py build/tmp --freq-table $(char-freq$(ver)) > stat/code_freq/$(jz-scheme)/jm$(ver)
	rm build/tmp

stat/code_freq/%:
	mkdir $@
