#!/bin/sh

outputdir=/PLEASE_SET_ME

hostname="`hostname`"

# We wrap both mongostat and vmstat, as they both don't print the date/time.
mongostat_wrapper() {
	date "+%Y%m%d-%H%M%S-%z"
	mongostat -n 86400 1 "$@"
}

vmstat_wrapper() {
	date "+%Y%m%d-%H%M%S-%z"
	vmstat 1 86400
}

program="$1"
case "$program" in
	iostat)  set -- iostat -xt 1 86400 ;;
	mongostat)  set -- mongostat_wrapper "$@" ;;
	mongotop)  set -- mongotop "$@" ;;
	vmstat) set -- vmstat_wrapper ;;
	sar_pagefaults) set -- sar -B 1 ;;
	serverstatus) set -- mongo --eval "while(true) {print(JSON.stringify(db.serverStatus({tcmalloc:1}))); sleep(1000)}" ;;
	*)
		echo "$0: ERROR: outputdir \"$outputdir\" is not writable, ABORTING" 1>&2
		exit 1
		;;
esac

# Check that the given output directory is writable.
testfile="$outputdir/$program-$hostname-$$-`date "+%Y%m%d-%H%M%S-%z" | sed -e 's/+//'`.testfile"
if ! touch "$testfile"; then
	echo "$0: ERROR: outputdir \"$outputdir\" is not writable, ABORTING" 1>&2
	exit 1
fi
rm -f "$testfile"

# Run $program repeatedly, rotating into a new output file periodically.
while :; do
	fname="$outputdir/$program-$hostname-$$-`date "+%Y%m%d-%H%M%S-%z" | sed -e 's/+//'`.out"
	"$@" > "$fname" 2>&1
done
