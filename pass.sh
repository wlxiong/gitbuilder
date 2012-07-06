#!/bin/sh

commit="$1"
out="out/output"

#
# rsync each pass as we complete it.  that means the sha1/$ref dir
# and symlinks for refs that refer to it.
#

[ -e "../rsync-target" ] || exit 0

target=`cat ../rsync-target`
echo "rsync $commit to $target"


# stage all output in $out/tmp
rm -rf $out/tmp
mkdir -p $out/tmp/sha1
mkdir -p $out/tmp/ref
mkdir -p $out/ref

# sha1 dir
mv $out/sha1/$commit $out/tmp/sha1

# branches
./branches.sh -v | while read sha1 branch; do
    branch="$(printf '%s' "$branch"|tr -c 'a-zA-Z0-9_.-' '_'|sed 's/^\./_/')"
    branch="${branch#origin_}"
    if [ "$sha1" = "$commit" ]; then
	echo "branch $branch is $sha1"
	ln -sf ../sha1/$commit $out/tmp/ref/$branch

	# update it in the shared dir, too
	rm -f $out/ref/$branch
	ln -s ../sha1/$commit $out/ref/$branch
    fi
done

echo "sync sha1 and refs"
rsync -av -e "ssh -i ../rsync-key -o StrictHostKeyChecking=no" \
    $out/tmp/ $target
rm -rf $out/tmp

