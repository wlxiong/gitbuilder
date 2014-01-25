#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

action=$1
commit=$2
force=$3

mkdir -p out/pass out/fail out/ignore out/errcache out/pending out/test out/nightly
chmod a+w out/errcache

( cd build &&
  git remote show &&
  ../timeout.sh 60 git remote update &&
  ../timeout.sh 60 git fetch gerrit refs/changes/*:refs/remotes/gerrit/changes/* )

echo -n "`date +"%Y-%m-%d %T"` add SHA1 $commit: " >> $DIR/event_log
if [ -e "out/pass/$commit" -o -e "out/fail/$commit" ]; then
    echo "already built $commit!"
    if [ "$force" == "-f" ]; then
        rm -f out/pass/$commit out/fail/$commit
        echo "force rebuild" >> $DIR/event_log
    else
        echo "already built" >> $DIR/event_log
        exit 0
    fi
else
    echo "accept" >> $DIR/event_log
fi

echo "Add commit: $commit"
touch "out/pending/$commit"
echo "gerrit" > out/pending/$commit

if [ -f "lock.lock" ]; then
    exit 0
fi

./runlock lock $action
exit 0