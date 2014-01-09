#!/bin/bash -x

cur_commit=$1
last_commit=$(git rev-list --first-parent --max-count=1 --skip=1 $cur_commit)

echo "Check file type and style"

# check if received illegal files
illegalfiles=`git diff --name-status $last_commit $cur_commit | grep ^[AM] | awk '/\.(orig|pyc|log|a|so|swp)$/{print $2}'`
if [ "$illegalfiles" != "" ]; then
  echo -e "\nillegal files not allowed, please remove them:"
  for file in $illegalfiles;
  do
    echo $file
  done
  echo " "
  exit 1
fi

# use astyle to check code style
styleok=1
tmpfile=/tmp/astyle.$$
newfiles=`git diff --name-status $last_commit $cur_commit | grep ^[AM] | awk '/\.(c|h|cc|cpp|cxx|hpp|ipp)$/{print $2}'`
for file in $newfiles
do
  m1=`git cat-file blob $cur_commit:$file | tee /tmp/astyle.$$ | md5sum`
  m2=`/usr/local/bin/astyle -NjA1 -z2 < /tmp/astyle.$$ | md5sum`
  if [ "$m1" != "$m2" ]
  then
    styleok=0
    echo "$file: astyle check fail, please use <astyle -NjA1 -z2 $file> to restyle"
   fi
done

rm -fr /tmp/astyle.$$
[ $styleok -eq 1 ] || exit 1
