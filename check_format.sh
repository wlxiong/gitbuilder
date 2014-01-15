#!/bin/bash -x
DIR=$(dirname $0)
cd "$DIR/build"

cur_commit=$1
last_commit=$(git rev-list --first-parent --max-count=1 --skip=1 $cur_commit)

pass=1

# check if received illegal files
illegalfiles=`git diff --name-status $last_commit $cur_commit | grep ^[AM] | awk '/\.(orig|pyc|log|a|so|swp)$/{print $2}'`
if [ "$illegalfiles" != "" ]; then
  echo -e "\nillegal files not allowed, please remove:"
  for file in $illegalfiles;
  do
    echo $file
  done
  echo " "
  pass=0
fi

# use astyle to check code style
tmpfile=/tmp/astyle.$$
newfiles=`git diff --name-status $last_commit $cur_commit | grep ^[AM] | awk '/\.(c|h|cc|cpp|cxx|hpp|ipp)$/{print $2}'`
file_num=0
max_file=3
file_list=""
for file in $newfiles
do
  m1=`git cat-file blob $cur_commit:$file | tee /tmp/astyle.$$ | md5sum`
  m2=`astyle -NjA1 -z2 < /tmp/astyle.$$ | md5sum`
  diff=`astyle -NjA1 -z2 < /tmp/astyle.$$ | diff /tmp/astyle.$$ -`
  if [ "$m1" != "$m2" ]; then
    pass=0
    [ $file_num -lt $max_file ] && file_list="$file $file_list"
    file_num=$(( $file_num + 1 ))
  fi
done

echo -n "Check file type and style: "
if [ $pass -eq 0 ]; then
  echo "FAIL"
else
  echo "PASS"
fi

if [ -n "$file_list" ]; then
  echo " Apply 'astyle -NjA1 -z2 FILE' to:"
  echo "   $file_list... $file_num file(s) in total."
fi
# rm -fr /tmp/astyle.$$

[ $pass -eq 0 ] && exit 1
exit 0
