#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR/build"

commit=$1

for sub in `git submodule -q foreach pwd`; do
    rm -rf $sub
done

git reset --hard HEAD  # in case there were modified files
git checkout "$commit" &&
git reset --hard $commit || 
git reset --hard $commit || exit 1

git clean -q -f -x -d || 
git clean -q -f -x -d || exit 1
exit 0
