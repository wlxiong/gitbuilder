#!/bin/bash
DIR="$(dirname $0)"
cd "$DIR"

BRANCH=$1
COMMIT=$2

# collect version info
pushd ./build
COMMIT_DATE=`git show -s --pretty=format:%ci $COMMIT | sed 's/-//g'`
COMMIT_DATE=${COMMIT_DATE:0:8}
COMMIT_HASH=`git show -s --pretty=format:%h $COMMIT --abbrev=4`
VERSION="${BRANCH}.${COMMIT_DATE}_${COMMIT_HASH}"
popd
echo "$VERSION"
