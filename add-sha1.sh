#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

action=$1
commit=$2
branch=$3

mkdir -p out/pass out/fail out/ignore out/errcache out/pending out/test out/nightly
chmod a+w out/errcache

( cd build &&
  git remote show &&
  ../timeout.sh 60 git fetch gerrit &&
  ../timeout.sh 60 git fetch gerrit refs/changes/*:refs/remotes/gerrit/changes/* )

echo -n "`date +"%Y-%m-%d %T"` add SHA1 $commit: " >> $DIR/event_log
if [ -e "out/pass/$commit" -o -e "out/fail/$commit" ]; then
    echo "already built $commit!"
    rm -f out/pass/$commit out/fail/$commit
    echo "rebuild" >> $DIR/event_log
else
    echo "accept" >> $DIR/event_log
fi

echo "Add commit in $branch: $commit"
version="$(./get-version.sh $branch $ref)"
echo "$version" > out/pending/$commit

if [ -f "lock.lock" ]; then
    exit 0
fi

./runlock lock $action
exit 0
