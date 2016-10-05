#!/bin/bash

# trim-string.sh
# Trim leading and trailing spaces out of a string

function trimspcs ()
{
    echo "$1" | awk '
    {
        for( i=1; i<=length($0); i++ ) if( substr($0,i,1) != " " ) { pre=i; break; }
        for( i=length($0); i>=1; i-- ) if( substr($0,i,1) != " " ) { post=i+1; break; }
        printf "%s\n", substr($0,pre,post-pre);
    }'
}

x="   we got leading and trailing spaces here   "
y=`trimspcs ${x}`
echo "And this is what remains: '$y'"

# years after writing this, found a oneliner:
#
#    sed -i -e 's/ asc$//' *sql
#
# end of it all
