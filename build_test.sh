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

# build unit test
gmock=testcases/unit/gmock
[[ ! -h $gmock ]] && rm -rf $gmock
[[ ! -d $gmock ]] && ln -sf $PWD/../build_gmock/testcases/unit/gmock $gmock
make -C testcases/unit clean && make -j 8 -C testcases/unit CXX="ccache g++" || exit 3

# build ci test
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
make -C testcases clean && make -j 8 -C testcases CXX="ccache g++" || exit 3

exit 0
