#!/bin/bash
DIR=$(dirname $0)
cd "$DIR/build"

nrev=1
mrev=10
passed=0
#ls ../out/pass/* |
#	sed -e 's,^\(.*/\)*\([0-9a-f]*\).*$,^\2^,g' |
git rev-list --first-parent --pretty='format:%H %ae %s' "$@" |
	while read commit email comment; do
		[ "$commit" = "commit" ] && continue
		if [ -f ../out/ignore/$commit ]; then
			# never print an ignored commit
			exit 0;
		fi
		echo "$commit $email $comment"
		if [ -f ../out/pass/$commit ]; then
			passed=1
		fi
		if [ $nrev -ge $mrev ] && [ $passed == 1 ]; then
			exit 0;
		fi
		nrev=$(( $nrev + 1 ))
	done
