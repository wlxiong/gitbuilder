#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

project=$1
commit=$2

( cd build && 
  git remote show | timeout 60 xargs git remote prune && 
  timeout 60 git remote update )

if [ -e "out/pass/$commit" -o -e "out/fail/$commit" ]; then
    echo "'$change': weird, already built $commit!"
    exit 0
fi

echo "Add change: $commit"
touch "out/pending/$commit"

if [ -f "lock.lock" ]; then
    exit 0
fi

./runlock lock ./autobuilder.sh
exit 0
