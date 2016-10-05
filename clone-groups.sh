#!/bin/bash
#
# copy groups from one user to another
#

function usage { echo "$0: Copy groups from one user to another"; echo "usage: $0 fromuser touser"; }

test -z "$1" && { usage; exit 1; }
test -z "$2" && { usage; exit 1; }
echo "$0: Adding groups from $1 to $2"

for G in `id $1 | awk -F, 'BEGIN {RS=","} {print}' | tr "()" "  " | awk '{print $2}'`
do
        if [ "$G" != "$1" ]; then echo "$0: Adding group $G"; sudo addgroup $2 $G; fi
done
