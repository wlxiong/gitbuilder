#!/bin/bash
DIR=`pwd`
cd "$DIR/build"

bisect()
{
	(git rev-list --first-parent --bisect-all "$@" ||
	 git rev-list --first-parent "$@" ) |
		while read x y; do
			[ -e $DIR/out/pass/$x -o -e $DIR/out/fail/$x ] && continue
			echo $x
			exit 0
		done
}

$DIR/revlist.sh "$@" | (
	pending=
	while read commit junk; do
		# always return the first commit in this branch
		pending=$commit
		break;
	done
	
	if [ -n "$pending" ]; then
		echo $pending
	fi

	# if we don't print anything at all, it means there's nothing to build!
)
