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
[[ ! -h lib/3rd ]] && rm -rf lib/3rd
[[ ! -d lib/3rd ]] && ln -sf ../../build_lib/lib/3rd lib/3rd

../build_gfs.sh && ../build_test.sh
ret=$?
rm lib/3rd

if [ $ret == 0 ]; then
	exit 0
else
	exit 3
fi
