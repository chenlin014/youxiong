-include custom.mk
include default.mk

all: $(foreach engine,$(input-engines),$(engine)_all)

build:
	mkdir $@

daima: build
	$(dm-maker) $(main-mb) > build/daima.tsv

jianma-%: build
	awk -F'\t' '$$2 ~ /.{3,}/ {print $$1"\t"$$2}' $(scheme-dir)/common-$*.tsv | \
		$(jianma-gen) 0:0,0,0:$(jianma-methods) --freq-table $(char-freq-$(*)) | \
		sed -E 's/\t(.)..$$/\t空\1/' > build/jianma-$*.tsv

dict-%: daima
	cat build/daima.tsv | \
		python mb-tool/apply_priority.py $(scheme-dir)/priority-table/$(dm-tag)-$*.tsv -u ',重,能,能重' | \
		perl script/preprocess.pl | \
		$(dict-gen) $(system-$(*)) $(chordmap) > build/dict-$*.tsv

jm-dict-%: jianma-%
	cat build/jianma-$*.tsv | sed -E 's/$$/简/' | \
		perl script/preprocess.pl | \
		$(dict-gen) $(system-$(*)) $(chordmap) > build/jm-dict-$*.tsv

rime_all: $(foreach std,$(char-standards),rime-$(std))

rime-%: dict-% jm-dict-%
	cat build/dict-$*.tsv | \
		mb-tool/format.sh rime > build/rime-$*.tsv
	printf "\n# $(jm-name-$(*))\n" >> build/rime-$*.tsv
	cat build/jm-dict-$*.tsv | \
		mb-tool/format.sh rime >> build/rime-$*.tsv

clean:
	rm build/*

check_priority:
	$(eval cs ?= zt)
	python mb-tool/check_priority.py $(scheme-dir)/priority-table/$(dm-tag)-$(cs).tsv build/daima.tsv

check_chordmap: code_freq
	python mb-tool/find_duplicate.py $(chordmap)
	python mb-tool/subset.py -d stat/code_freq/$(jz-scheme)/$(word 1,$(char-standards)) $(chordmap)

no_jianma:
	$(eval cs ?= zt)
	python mb-tool/subset.py $(scheme-dir)/common-$(cs).tsv build/jianma-$(cs).tsv -d | \
		awk -F'\t' '$$2 !~ /.{3,}/ {next}1'

code_freq: $(foreach std,$(char-standards),code-freq-$(std))

code-freq-%: daima jianma-% stat/code_freq/$(jz-scheme)
	# 全码
	python mb-tool/code_freq.py $(scheme-dir)/common-$*.tsv --freq-table $(char-freq-$(*)) > stat/code_freq/$(jz-scheme)/$*
	# 代码
	$(dm-maker) $(scheme-dir)/common-$*.tsv | \
		python mb-tool/code_freq.py --freq-table $(char-freq-$(*)) > stat/code_freq/$(jz-scheme)/$(dm-tag)-$*
	# 简码
	awk -F'\t' 'length($$2) > 2 {next} 1' $(scheme-dir)/common-$*.tsv > build/tmp
	cat build/jianma-$*.tsv >> build/tmp
	python mb-tool/code_freq.py build/tmp --freq-table $(char-freq-$(*)) > stat/code_freq/$(jz-scheme)/jm-$*
	rm build/tmp

stat/code_freq/%:
	mkdir $@
