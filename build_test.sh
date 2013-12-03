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
gitdir="`pwd`"
lib_a="libgfsclient.a.3.6.2.20130723_dca0cce"
svn_include_path="http://10.10.16.252/bin_svn/xl_download/download_server/gfs/pkg/release/gfs_3.6/3.6.2.20130723_dca0cce/include"
svn_lib_path="http://10.10.16.252/bin_svn/xl_download/download_server/gfs/pkg/release/gfs_3.6/3.6.2.20130723_dca0cce/lib/${lib_a}"
mkdir -p "$gitdir/testcases/compat/lib"
svn export "$svn_include_path" "$gitdir/testcases/compat/include"
svn export "$svn_lib_path" "$gitdir/testcases/compat/lib/$lib_a"
cd "$gitdir/testcases/compat/lib/"
chmod a+x "$lib_a"
ln -fs "$lib_a" libgfsclient.a

cd "$gitdir"
make -C testcases/perf clean && make -C testcases/perf
make -C testcases/auto clean && make -C testcases/auto
make -C testcases/compat clean && make -C testcases/compat

exit 0
