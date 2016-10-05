#!/bin/bash

prep=(`shuf -n3 /usr/share/dict/spanish`)
phrase=${prep[@]}
echo "The sentence: <<${phrase}>>. Period."

# Run the whole array item by item...

items=`expr ${#prep[@]} - 1`
echo "number of items minus one: ${items}"

for loop in `seq 0 ${items}`
do
        echo "item number ${loop}: ${prep[$loop]}"
done
