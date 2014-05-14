#!/bin/bash -x
#
# Copy this file to build.sh so that gitbuilder can run it.
#
# What happens is that gitbuilder will checkout the revision of your software
# it wants to build in the directory called gitbuilder/build/.  Then it
# does "cd build" and then "../build.sh" to run your script.
#
# You might want to run ./configure here, make, make test, etc.
#
source env.sh
ref="gerrit/dev"
[ -n "$1" ] && ref="$1"

# Actually build the project
[[ -d build_fuse ]] && rm -rf build_fuse
mkdir build_fuse

git --git-dir=build/.git --work-tree=build_fuse/ checkout "$ref" -- fuse_client
cd build_fuse/fuse_client && ./build_fuse.sh || exit 3

exit 0
