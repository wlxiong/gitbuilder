#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

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
  timeout 60 git remote update )

for branch in $(./branches.sh); do
	ref=$(./next-rev.sh $branch)
	if [ -z "$ref" ]; then
		echo "$branch: already up to date."
		continue;
	fi
	echo -n "`date --rfc-3339=seconds` add change $ref: " >> $DIR/event_log
	if [ -e "out/pass/$ref" -o -e "out/fail/$ref" ]; then
		echo "$branch: weird, already built $ref!"
		echo "already built" >> $DIR/event_log
		continue
	fi
	echo "accept" >> $DIR/event_log
	echo "Add commit $branch: $ref"
	touch "out/pending/$ref"
	echo "git" > out/pending/$ref
done

if [ -f "lock.lock" ]; then
	exit 0
fi

./runlock lock ./autobuild.sh
exit 0
