#!/usr/bin/env bash

for i in $*
do
case $i in
    -e=*|--elements=*)
    ELEMENTS=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    -w=*|--window=*)
    WINDOW=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    *)
            # unknown option
    ;;
esac
done

set -e
if [ -z "${ELEMENTS}" ]; then echo "Error: Set the --elements=n variable"; exit; fi
if [ -z "${WINDOW}" ]; then WINDOW=$(( ( RANDOM % 1000 )  + 1 )); fi

mysql -N --user=genome --host=genome-mysql.cse.ucsc.edu -A -D hg19 << EOF
	SET @rank:=0;
	SELECT DISTINCT chrom as chromcol,
		@start:=ROUND(RAND()*(size-100)) as startcol,
		@start+${WINDOW} as stopcol
	FROM
		chromInfo, kgXref 
	LIMIT ${ELEMENTS}

EOF
