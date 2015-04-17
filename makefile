SHELL := /bin/bash
WINDOW = 150
TRIALS = 10

all: bedgraph_multiple

bed3_multiple:
	ELEMENTS=1000 $(MAKE) -f makefile bed3
	ELEMENTS=10000 $(MAKE) -f makefile bed3
	ELEMENTS=100000 $(MAKE) -f makefile bed3
	ELEMENTS=1000000 $(MAKE) -f makefile bed3

bed3:
	mkdir -p results
	mkdir -p /tmp/$@-test
	rm -rf /tmp/$@-test/size_table.${ELEMENTS}.txt
	TRIAL=1; while [[ $$TRIAL -le ${TRIALS} ]]; do \
		TRIAL_FN=/tmp/$@-test/bed3.${ELEMENTS}.$${TRIAL}.bed; \
		./rand.bed3.bash -e=${ELEMENTS} -w=${WINDOW} | sort-bed - > $$TRIAL_FN; \
		ARCHIVE_BZ2_FN=$$TRIAL_FN.bz2starch; \
		starch --bzip2 $$TRIAL_FN > $$ARCHIVE_BZ2_FN; \
		ARCHIVE_GZ_FN=$$TRIAL_FN.gzstarch; \
		starch --gzip $$TRIAL_FN > $$ARCHIVE_GZ_FN; \
		paste <(wc -c < $$TRIAL_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_FN | sed 's/ //g') >> /tmp/$@-test/size_table.${ELEMENTS}.txt; \
		((TRIAL = TRIAL + 1)); \
	done
	./starch_eff.R --inFn=/tmp/$@-test/size_table.${ELEMENTS}.txt --outFn=results/ratios.${ELEMENTS}.txt --elements=${ELEMENTS}

bedgraph_multiple:
	ELEMENTS=1000 $(MAKE) -f makefile bedgraph
	ELEMENTS=10000 $(MAKE) -f makefile bedgraph
	ELEMENTS=100000 $(MAKE) -f makefile bedgraph
	ELEMENTS=1000000 $(MAKE) -f makefile bedgraph

bedgraph:
	mkdir -p results
	mkdir -p /tmp/$@-test
	rm -rf /tmp/$@-test/size_table.${ELEMENTS}.txt
	TRIAL=1; while [[ $$TRIAL -le ${TRIALS} ]]; do \
		TRIAL_FN=/tmp/$@-test/bedgraph.${ELEMENTS}.$${TRIAL}.bed; \
		./rand.bedgraph.bash -e=${ELEMENTS} -w=${WINDOW} | sort-bed - > $$TRIAL_FN; \
		ARCHIVE_BZ2_FN=$$TRIAL_FN.bz2starch; \
		starch --bzip2 $$TRIAL_FN > $$ARCHIVE_BZ2_FN; \
		ARCHIVE_GZ_FN=$$TRIAL_FN.gzstarch; \
		starch --gzip $$TRIAL_FN > $$ARCHIVE_GZ_FN; \
		paste <(wc -c < $$TRIAL_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_FN | sed 's/ //g') >> /tmp/$@-test/size_table.${ELEMENTS}.txt; \
		((TRIAL = TRIAL + 1)); \
	done
	./starch_eff.R --inFn=/tmp/$@-test/size_table.${ELEMENTS}.txt --outFn=results/ratios.${ELEMENTS}.txt --elements=${ELEMENTS}

association_multiple:
	ELEMENTS=1000 $(MAKE) -f makefile association
	ELEMENTS=10000 $(MAKE) -f makefile association
	ELEMENTS=100000 $(MAKE) -f makefile association
	ELEMENTS=1000000 $(MAKE) -f makefile association

association:
	mkdir -p results
	mkdir -p /tmp/$@-test
	rm -rf /tmp/$@-test/size_table.${ELEMENTS}.txt
	TRIAL=1; while [[ $$TRIAL -le ${TRIALS} ]]; do \
		TRIAL_FN=/tmp/$@-test/assoc.${ELEMENTS}.$${TRIAL}.bed; \
		paste <(./rand.bed3.bash -e=${ELEMENTS} -w=${WINDOW}) <(./rand.bedgraph.bash -e=${ELEMENTS} -w=${WINDOW}) | sort-bed - > $$TRIAL_FN; \
		ARCHIVE_BZ2_FN=$$TRIAL_FN.bz2starch; \
		starch --bzip2 $$TRIAL_FN > $$ARCHIVE_BZ2_FN; \
		ARCHIVE_GZ_FN=$$TRIAL_FN.gzstarch; \
		starch --gzip $$TRIAL_FN > $$ARCHIVE_GZ_FN; \
		paste <(wc -c < $$TRIAL_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_FN | sed 's/ //g') >> /tmp/$@-test/size_table.${ELEMENTS}.txt; \
		((TRIAL = TRIAL + 1)); \
	done
	./starch_eff.R --inFn=/tmp/$@-test/size_table.${ELEMENTS}.txt --outFn=results/ratios.${ELEMENTS}.txt --elements=${ELEMENTS}

clean:
	rm -rf results
	rm -rf /tmp/{association,bed3,bedgraph}-test