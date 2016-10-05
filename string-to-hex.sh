#!/bin/bash
# string-to-hex
# convert string into hex equivalent

test -z ${1} && read PALABRA || PALABRA=${1}
HEXWORD=`

for (( i = 0; i '<' ${#PALABRA}; i ++ ))
do 
    echo -n ${PALABRA:$i:1} | od -A n -t x1 | tr -d "\n"; 
done`

echo $HEXWORD

# sample runs:
#
#    $ string-to-hex.sh MyWpaKeyIsThis
#    4d 79 57 70 61 4b 65 79 49 73 54 68 69 73
#
#    $ hexword.sh MyWpaKeyIsThis | tr " " ":"
#    4d:79:57:70:61:4b:65:79:49:73:54:68:69:73
