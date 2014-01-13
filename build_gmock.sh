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

# Actually build the project
[[ -d build_gmock ]] && rm -rf build_gmock
mkdir build_gmock

gmock=testcases/unit/gmock
git --git-dir=gfs/.git --work-tree=build_gmock/ checkout HEAD -- $gmock
make -C build_gmock/$gmock clean && make -C build_gmock/$gmock gmock CXX="ccache g++" || exit 3

exit 0
