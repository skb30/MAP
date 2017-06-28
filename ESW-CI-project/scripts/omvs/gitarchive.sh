#!/bin/bash
# Script to get an archive from a git repository
#
# $1 - ssh path to git repository
# $2 - product name
# $3 - branch name
#
echo PWD: $PWD
#
branch=$3
zosbranch=$(echo $branch| cut -d'/' -f 2)
echo storing archive in: $2-$zosbranch.zip
git archive --format=zip --remote $1 $3 > $2-$zosbranch.zip
if [ $? -eq 0 ]
then
  echo "Successfully created $2-$zosbranch.zip"
else
  echo "Could not create $2-$zosbranch.zip" >&2
  exit 1
fi
echo storing archive completed.
date > gittomvs_start.txt
rm -r $2
mkdir $2
cd $2
echo unzipping...
jar xf ../$2-$zosbranch.zip
if [ $? -eq 0 ]
then
  echo "Successfully unzipped $2-$zosbranch.zip into direcotry $2"
else
  echo "Could not unzip $2-$zosbranch.zip" >&2
  exit 1
fi
date > gittomvs_end.txt
