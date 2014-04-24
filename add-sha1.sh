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
  git fetch gerrit &&
  git fetch gerrit refs/changes/*:refs/remotes/gerrit/changes/* )

echo "`date +"%Y-%m-%d %T"` add SHA1 $commit: $action" >> $DIR/event_log
if [ -e "out/pass/$commit" -o -e "out/fail/$commit" ]; then
    echo "already built $commit!"
    rm -f out/pass/$commit out/fail/$commit
fi

echo "Add commit in $branch: $commit"
echo "$branch sha1 $commit $action" > out/pending/$commit

if [ -f "lock.lock" ]; then
    exit 0
fi

./runlock lock ./autorun.sh

exit 0
