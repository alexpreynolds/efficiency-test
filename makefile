SHELL := /bin/bash
WINDOW = 150
TRIALS = 5

all: bedgraph_parent

bedgraph_parent: bedgraph_multiple
	./starch_comp.R --inFnPrefix="results/bedgraph.ratios" --outFn="results/merged.bedgraph" --elementsStr="10000,20000,40000,80000,100000,200000,400000,800000,1000000,2000000,4000000,8000000,10000000"

bedgraph_multiple:
	ELEMENTS=1000 $(MAKE) -f makefile bedgraph
	ELEMENTS=2000 $(MAKE) -f makefile bedgraph
	ELEMENTS=4000 $(MAKE) -f makefile bedgraph
	ELEMENTS=8000 $(MAKE) -f makefile bedgraph
	ELEMENTS=10000 $(MAKE) -f makefile bedgraph
	ELEMENTS=20000 $(MAKE) -f makefile bedgraph
	ELEMENTS=40000 $(MAKE) -f makefile bedgraph
	ELEMENTS=80000 $(MAKE) -f makefile bedgraph
	ELEMENTS=100000 $(MAKE) -f makefile bedgraph
	ELEMENTS=200000 $(MAKE) -f makefile bedgraph
	ELEMENTS=400000 $(MAKE) -f makefile bedgraph
	ELEMENTS=800000 $(MAKE) -f makefile bedgraph
	ELEMENTS=1000000 $(MAKE) -f makefile bedgraph
	ELEMENTS=2000000 $(MAKE) -f makefile bedgraph
	ELEMENTS=4000000 $(MAKE) -f makefile bedgraph
	ELEMENTS=8000000 $(MAKE) -f makefile bedgraph
	ELEMENTS=10000000 $(MAKE) -f makefile bedgraph

bedgraph:
	mkdir -p results
	mkdir -p /tmp/$@-test
	rm -rf /tmp/$@-test/size_table.${ELEMENTS}.txt
	TRIAL=1; while [[ $$TRIAL -le ${TRIALS} ]]; do \
		echo "trial: $$TRIAL"; \
		TRIAL_FN=/tmp/$@-test/bedgraph.${ELEMENTS}.$${TRIAL}.bed; \
		./rand.bedgraph.bash -e=${ELEMENTS} -w=${WINDOW} | sort-bed - > $$TRIAL_FN; \
                ARCHIVE_BZ2_FN=$$TRIAL_FN.bz2; \
                bzip2 --stdout $$TRIAL_FN > $$ARCHIVE_BZ2_FN; \
		ARCHIVE_BZ2_STARCH_FN=$$TRIAL_FN.bz2starch; \
		starch --bzip2 $$TRIAL_FN > $$ARCHIVE_BZ2_STARCH_FN; \
                ARCHIVE_GZ_FN=$$TRIAL_FN.gz; \
                gzip --stdout $$TRIAL_FN > $$ARCHIVE_GZ_FN; \
		ARCHIVE_GZ_STARCH_FN=$$TRIAL_FN.gzstarch; \
		starch --gzip $$TRIAL_FN > $$ARCHIVE_GZ_STARCH_FN; \
		paste <(wc -c < $$TRIAL_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_STARCH_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_STARCH_FN | sed 's/ //g') >> /tmp/$@-test/size_table.${ELEMENTS}.txt; \
		((TRIAL = TRIAL + 1)); \
	done
	./starch_eff.R --inFn=/tmp/$@-test/size_table.${ELEMENTS}.txt --outFn=results/$@.ratios.${ELEMENTS}.txt --elements=${ELEMENTS}

bed4_int_multiple:
	ELEMENTS=1000 $(MAKE) -f makefile bed4_int
	ELEMENTS=10000 $(MAKE) -f makefile bed4_int
	ELEMENTS=100000 $(MAKE) -f makefile bed4_int
	ELEMENTS=1000000 $(MAKE) -f makefile bed4_int
	ELEMENTS=10000000 $(MAKE) -f makefile bed4_int

bed4_int:
	mkdir -p results
	mkdir -p /tmp/$@-test
	rm -rf /tmp/$@-test/size_table.${ELEMENTS}.txt
	TRIAL=1; while [[ $$TRIAL -le ${TRIALS} ]]; do \
		echo "trial: $$TRIAL"; \
		TRIAL_FN=/tmp/$@-test/bed4_int.${ELEMENTS}.$${TRIAL}.bed; \
		./rand.bed4_int.bash -e=${ELEMENTS} -w=${WINDOW} | sort-bed - > $$TRIAL_FN; \
                ARCHIVE_BZ2_FN=$$TRIAL_FN.bz2; \
                bzip2 --stdout $$TRIAL_FN > $$ARCHIVE_BZ2_FN; \
		ARCHIVE_BZ2_STARCH_FN=$$TRIAL_FN.bz2starch; \
		starch --bzip2 $$TRIAL_FN > $$ARCHIVE_BZ2_STARCH_FN; \
                ARCHIVE_GZ_FN=$$TRIAL_FN.gz; \
                gzip --stdout $$TRIAL_FN > $$ARCHIVE_GZ_FN; \
		ARCHIVE_GZ_STARCH_FN=$$TRIAL_FN.gzstarch; \
		starch --gzip $$TRIAL_FN > $$ARCHIVE_GZ_STARCH_FN; \
		paste <(wc -c < $$TRIAL_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_STARCH_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_STARCH_FN | sed 's/ //g') >> /tmp/$@-test/size_table.${ELEMENTS}.txt; \
		((TRIAL = TRIAL + 1)); \
	done
	./starch_eff.R --inFn=/tmp/$@-test/size_table.${ELEMENTS}.txt --outFn=results/$@.ratios.${ELEMENTS}.txt --elements=${ELEMENTS}

bed3_multiple:
	ELEMENTS=1000 $(MAKE) -f makefile bed3
	ELEMENTS=10000 $(MAKE) -f makefile bed3
	ELEMENTS=100000 $(MAKE) -f makefile bed3
	ELEMENTS=1000000 $(MAKE) -f makefile bed3
	ELEMENTS=10000000 $(MAKE) -f makefile bed3

bed3:
	mkdir -p results
	mkdir -p /tmp/$@-test
	rm -rf /tmp/$@-test/size_table.${ELEMENTS}.txt
	TRIAL=1; while [[ $$TRIAL -le ${TRIALS} ]]; do \
		echo "trial: $$TRIAL"; \
		TRIAL_FN=/tmp/$@-test/bed3.${ELEMENTS}.$${TRIAL}.bed; \
		./rand.bed3.bash -e=${ELEMENTS} -w=${WINDOW} | sort-bed - > $$TRIAL_FN; \
                ARCHIVE_BZ2_FN=$$TRIAL_FN.bz2; \
                bzip2 --stdout $$TRIAL_FN > $$ARCHIVE_BZ2_FN; \
		ARCHIVE_BZ2_STARCH_FN=$$TRIAL_FN.bz2starch; \
		starch --bzip2 $$TRIAL_FN > $$ARCHIVE_BZ2_STARCH_FN; \
                ARCHIVE_GZ_FN=$$TRIAL_FN.gz; \
                gzip --stdout $$TRIAL_FN > $$ARCHIVE_GZ_FN; \
		ARCHIVE_GZ_STARCH_FN=$$TRIAL_FN.gzstarch; \
		starch --gzip $$TRIAL_FN > $$ARCHIVE_GZ_STARCH_FN; \
		paste <(wc -c < $$TRIAL_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_STARCH_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_STARCH_FN | sed 's/ //g') >> /tmp/$@-test/size_table.${ELEMENTS}.txt; \
		((TRIAL = TRIAL + 1)); \
	done
	./starch_eff.R --inFn=/tmp/$@-test/size_table.${ELEMENTS}.txt --outFn=results/$@.ratios.${ELEMENTS}.txt --elements=${ELEMENTS}

association_multiple:
	ELEMENTS=1000 $(MAKE) -f makefile association
	ELEMENTS=10000 $(MAKE) -f makefile association
	ELEMENTS=100000 $(MAKE) -f makefile association
	ELEMENTS=1000000 $(MAKE) -f makefile association
	ELEMENTS=10000000 $(MAKE) -f makefile association

association:
	mkdir -p results
	mkdir -p /tmp/$@-test
	rm -rf /tmp/$@-test/size_table.${ELEMENTS}.txt
	TRIAL=1; while [[ $$TRIAL -le ${TRIALS} ]]; do \
		echo "trial: $$TRIAL"; \
		TRIAL_FN=/tmp/$@-test/assoc.${ELEMENTS}.$${TRIAL}.bed; \
		paste <(./rand.bed3.bash -e=${ELEMENTS} -w=${WINDOW}) <(./rand.bedgraph.bash -e=${ELEMENTS} -w=${WINDOW}) | sort-bed - > $$TRIAL_FN; \
                ARCHIVE_BZ2_FN=$$TRIAL_FN.bz2; \
                bzip2 --stdout $$TRIAL_FN > $$ARCHIVE_BZ2_FN; \
		ARCHIVE_BZ2_STARCH_FN=$$TRIAL_FN.bz2starch; \
		starch --bzip2 $$TRIAL_FN > $$ARCHIVE_BZ2_STARCH_FN; \
                ARCHIVE_GZ_FN=$$TRIAL_FN.gz; \
                gzip --stdout $$TRIAL_FN > $$ARCHIVE_GZ_FN; \
		ARCHIVE_GZ_STARCH_FN=$$TRIAL_FN.gzstarch; \
		starch --gzip $$TRIAL_FN > $$ARCHIVE_GZ_STARCH_FN; \
		paste <(wc -c < $$TRIAL_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_BZ2_STARCH_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_FN | sed 's/ //g') <(wc -c < $$ARCHIVE_GZ_STARCH_FN | sed 's/ //g') >> /tmp/$@-test/size_table.${ELEMENTS}.txt; \
		((TRIAL = TRIAL + 1)); \
	done
	./starch_eff.R --inFn=/tmp/$@-test/size_table.${ELEMENTS}.txt --outFn=results/$@.ratios.${ELEMENTS}.txt --elements=${ELEMENTS}

clean:
	rm -rf *~
	rm -rf results
	rm -rf /tmp/{association,bed3,bedgraph,bed4_int}-test