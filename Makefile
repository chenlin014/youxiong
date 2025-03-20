include default.Makefile
-include custom.Makefile
-include hidden.Makefile

all: $(foreach engine,$(input-engines),$(engine)_all)

build:
	mkdir $@

daima: build
	$(dm-maker) $(main-mb) > build/daima.tsv

jianma-%: build
	awk -F'\t' '$$2 ~ /.{3,}/ {print $$1"\t"$$2}' $(scheme-dir)/common-$*.tsv | \
		$(jianma-gen) 0:0,0,0:$(jianma-methods) --char-freq $(char-freq-$(*)) | \
		sed -E 's/\t(.)..$$/\t空\1/' > build/jianma-$*.tsv

dict-%: daima
	cat build/daima.tsv | \
		python mb-tool/apply_priority.py $(scheme-dir)/priority-table/$(dm-tag)-$*.tsv -u ',重,能,能重' | \
		perl script/preprocess.pl | \
		$(dict-gen) $(system-$(*)) $(chordmap) > build/$(dict-name)-$*.tsv

jm-dict-%: jianma-%
	cat build/jianma-$*.tsv | sed -E 's/$$/简/' | \
		perl script/preprocess.pl | \
		$(dict-gen) $(system-$(*)) $(chordmap) > build/$(dict-name)-jm-$*.tsv

rime_all: $(foreach std,$(char-standards),rime-$(std))

rime-%: dict-% jm-dict-%
	cat build/$(dict-name)-$*.tsv | \
		mb-tool/format.sh rime > build/rime-$(dict-name)-$*.tsv
	printf "\n# $(jm-name-$(*))\n" >> build/rime-$(dict-name)-$*.tsv
	cat build/$(dict-name)-jm-$*.tsv | \
		mb-tool/format.sh rime >> build/rime-$(dict-name)-$*.tsv

clean:
	rm build/*

check_priority:
	$(eval cs ?= zt)
	python mb-tool/check_priority.py $(scheme-dir)/priority-table/$(dm-tag)-$(cs).tsv build/daima.tsv
