#!/bin/bash
#
# walk-array experiences
#

prep=(a ante bajo cabe con contra de desde)
items=`expr ${#prep[@]} - 1`
echo "items minus one: ${items}"

for loop in `seq 0 ${items}`
do
    echo "elemento ${loop}: ${prep[$loop]}"
done

#
# sample run
#    $ ./demoarray.sh
#    número de elementos menos uno: 7
#    item 0: a
#    item 1: ante
#    item 2: bajo
#    item 3: cabe
#    item 4: con
#    item 5: contra
#    item 6: de
#    item 7: desde
#    

#
# Improvement 1
#

i=0

for item in ${prep[@]}
do
        echo "elemento ${i}: ${item}"
        let i++
done

#
# Improvement 2
#

echo "next experiment..."
idx=0

for item in ${prep[@]}
do
        echo "index ${idx}: ${prep[$idx]}"
        ((idx++))
done

#
# Final part of the show
#

echo "from third to sixth item..."
echo "${prep[@]:3:4}"

# that's all folks
