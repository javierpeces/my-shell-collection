#!/bin/bash
#
# all the loops in shell script lang
#

#
# one by one
# 

echo "One by one"

for i in {1..10}
do
	echo -ne " $i "
done

echo ""

#
# one by one, C-Style
#

echo "One by one, C lang style"

for (( i=1; i<=10; i++ ))
do
	echo -ne " $i "
done

echo ""

#
# stepping every two, C-style again
#

echo "Two by two, C-style"

for (( i=1; i<=10; i+=2 ))
do
	echo -ne " $i "
done

echo ""

#
# sequence
#

echo "Two by two, SEQ style"

for i in $(seq 1 2 10)
do
	echo -ne " $i "
done

echo ""

#
# backwards
# 

echo "Two by two, SEQ style, backwards"

for i in $(seq 10 -2 1)
do
	echo -ne " $i "
done

echo ""

#
# the end
#

echo finito
