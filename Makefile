ifeq ($(config),)
-include custom.mk
else
-include $(config)
endif
include default.mk

all: $(foreach engine,$(input-engines),$(engine)_all)

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
		$(dict-gen) $(system$(ver)) $(chordmap-file) > build/dict$(ver).tsv

jm-dict: jm-dict-.

jm-dict-%: jianma-%
	$(eval ver = $(subst -.,,-$(*)))
	$(eval system$(ver) ?= $(system))
	cat build/jianma$(ver).tsv | sed -E 's/$$/简/' | \
		sed 's/./& /g; s/ $$//; s/ \t /\t/' | \
		$(dict-gen) $(system$(ver)) $(chordmap-file) > build/jm-dict$(ver).tsv

ifeq ($(char-standards),)
rime_all: rime-.
else
rime_all: $(foreach std,$(char-standards),rime-$(std))
endif

rime-%: dict-% jm-dict-%
	$(eval ver = $(subst -.,,-$(*)))
	cat build/dict$(ver).tsv | \
		python mb-tool/apply_priority.py -c $(scheme-dir)/priority-table/$(dm-tag)$(ver).csv -u '9,8,7,6,5,4,3,2,1' | \
		sed -E 's/([[:digit:]])$$/\t\1/' | \
		mb-tool/format.sh rime > build/rime$(ver).tsv
	printf "\n# $(jm-name$(ver))\n" >> build/rime$(ver).tsv
	cat build/jm-dict$(ver).tsv | \
		mb-tool/format.sh rime >> build/rime$(ver).tsv

clean:
	rm build/*

check_priority:
	$(eval cs ?= ft)
	python mb-tool/check_priority.py --char-only $(scheme-dir)/priority-table/$(dm-tag)-$(cs).csv build/daima-$(cs).tsv

check_chordmap: code_freq
	python mb-tool/find_duplicate.py $(chordmap)
	python mb-tool/subset.py -d stat/code_freq/$(jz-scheme)/$(word 1,$(char-standards)) $(chordmap)

no_jianma:
	$(eval cs ?= ft)
	python mb-tool/subset.py $(scheme-dir)/common-$(cs).tsv build/jianma-$(cs).tsv -d | \
		awk -F'\t' '$$2 !~ /.{3,}/ {next}1'

code_freq: $(foreach std,$(char-standards),code-freq-$(std))

code-freq-%: daima-% jianma-% stat/code_freq/$(jz-scheme)
	# 全码
	python mb-tool/code_freq.py $(table-$(*)) --freq-table $(char-freq-$(*)) > stat/code_freq/$(jz-scheme)/$*
	# 代码
	$(dm-maker) $(table-$(*)) | \
		python mb-tool/code_freq.py --freq-table $(char-freq-$(*)) > stat/code_freq/$(jz-scheme)/$(dm-tag)-$*
	# 简码
	awk -F'\t' 'length($$2) > 2 {next} 1' $(table-$(*)) > build/tmp
	cat build/jianma-$*.tsv >> build/tmp
	python mb-tool/code_freq.py build/tmp --freq-table $(char-freq-$(*)) > stat/code_freq/$(jz-scheme)/jm-$*
	rm build/tmp

test-%:
	$(eval ver = $(subst -.,,-$(*)))
	echo table$(ver)

stat/code_freq/%:
	mkdir $@
