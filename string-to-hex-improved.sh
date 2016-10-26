#!/bin/bash
#
# convert-to-hex.sh
# string conversion to its hex equivalent
# Playing with bash string handling capabilities… Let’s convert the user supplied string to its hexadecimal equivalent:
#
# First of all, let’s show how to process the full arg string
#

ALLARGS=$@
for (( i=0; i '<' ${#ALLARGS}; i ++ ))
do
   echo "char ${i} is ${ALLARGS:$i:1}"
done

#
# Now that we know how to extract every single char, let’s convert each to hex:
#

ALLARGS=$@
for (( i=0; i '<' ${#ALLARGS}; i ++ ))
do
   echo -n "${ALLARGS:$i:1}" | od -A n -t x1 | tr -d "\n"
done

#
# If we need it into a variable for further process, this trick may fit:
#

HEXPHRASE=`
for (( i=0; i '<' ${#ALLARGS}; i ++ ))
do
   echo -n "${ALLARGS:$i:1}" | od -A n -t x1 | tr -d "\n"
done`

#
# Remove the (annoying) leading whitespace…
#

HEXPHRASE=$(echo ${HEXPHRASE}|sed -e 's/^[ \t]*//')

echo -e "\nThis is the phrase:"
echo "'${HEXPHRASE}'"

# Sample run:
#
#  $ convert-to-hex.sh hello dolly 
#  char 0 is "h"
#  char 1 is "e"
#  char 2 is "l"
#  char 3 is "l"
#  char 4 is "o"
#  char 5 is " "
#  char 6 is "d"
#  char 7 is "o"
#  char 8 is "l"
#  char 9 is "l"
#  char 10 is "y"
#  68 65 6c 6c 6f 64 6f 6c 6c 79
#  This is the phrase:
#  '68 65 6c 6c 6f 64 6f 6c 6c 79'
# 
# That’s it…
