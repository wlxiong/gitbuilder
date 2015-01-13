#!/bin/bash
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

if [ -z "$1" ]; then
	echo "usage: $0 <path> [commit]" >&2
	echo "example: $0 lib/3rd gerrit/dev" >&2
	exit 1
fi
path=$1
ref="${2:-gerrit/dev}"
cmd="${3:-build.sh}"

rm -rf "build_lib/${path}"
mkdir -p build_lib

# Actually build the project
set -x
git --git-dir=build/.git --work-tree=build_lib/ checkout "$ref" -- "$path"
cd "build_lib/${path}" && ./$cmd || exit 3

exit 0
