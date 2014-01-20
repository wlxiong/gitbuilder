#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

project=$1
force=$2

[ "$project" == "gfs" ] || exit 0

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
  ../timeout.sh 60 git remote update )

for branch in $(./branches.sh); do
	ref=$(./next-rev.sh $branch)
	echo -n "`date --rfc-3339=seconds` add HEAD $ref: " >> $DIR/event_log
	if [ -e "out/pass/$ref" -o -e "out/fail/$ref" ]; then
		echo "$branch: already built $ref!"
		if [ "$force" == "-f" ]; then
		    rm -f out/pass/$ref out/fail/$ref
		    echo "force rebuild" >> $DIR/event_log
		else
			echo "$branch: already up to date."
		    echo "already built" >> $DIR/event_log
		    continue
		fi
	else
		echo "accept" >> $DIR/event_log
	fi
	echo "Add HEAD $branch: $ref"
	touch "out/pending/$ref"
	echo "git" > out/pending/$ref
done

if [ -f "lock.lock" ]; then
	exit 0
fi

./runlock lock ./autobuild.sh
exit 0
