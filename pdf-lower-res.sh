#!/bin/bash
#
# run in an empty directory
# or at least check absence of foo*.jpeg files
#
SOURCE="hi-res-source.pdf"
TARGET="lo-res-target.pdf"
convert -density 150 $SOURCE foo.jpeg
export FILELIST=$(ls -1 foo*jpeg | sort -t "-" -k 2 -n)
convert -quality 4 $FILELIST $TARGET
