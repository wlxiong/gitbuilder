#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

action=$1
branch_list=$2

if [ ! -d build/. ]; then
	echo >&2
	echo "We need a directory named build/ in this directory." >&2
	echo "You should 'git clone' the project you want to test," >&2
	echo "like this:" >&2
	echo >&2
	echo "    git clone /path/to/myproject.git build" >&2
	echo >&2
	exit 2
fi

mkdir -p out/pass out/fail out/ignore out/errcache out/pending out/test out/nightly
chmod a+w out/errcache

( cd build &&
  git remote show &&
  ../timeout.sh 60 git fetch gerrit )

if [ -z "$branch_list" ]; then
	branch_list="$(./branches.sh)"
fi
for branch in $branch_list; do
	ref=$(./next-rev.sh gerrit/$branch)
	echo -n "`date +"%Y-%m-%d %T"` add HEAD $ref: " >> $DIR/event_log
	if [ -e "out/pass/$ref" -o -e "out/fail/$ref" ]; then
		echo "$branch: already built $ref!"
	    rm -f out/pass/$ref out/fail/$ref
	    echo "rebuild" >> $DIR/event_log
	else
		echo "accept" >> $DIR/event_log
	fi
	echo "Add HEAD in $branch: $ref"
	echo "$branch" > out/pending/$ref
done

if [ -f "lock.lock" ]; then
	exit 0
fi

./runlock lock $action
exit 0
