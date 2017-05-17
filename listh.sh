#!/bin/bash

# listh.sh -- list data file in the classic mainframe hex fashion

function usage() {
        echo "usage: $0 inputfile recordlen"
}

# require two args, the data file and the record length to be used.


if [ -z "$1" -o -z "$2" ]
then 
        usage
        exit 1
fi

# use the newline character as input field separator

IFS=$'\n'

# count the bytes to be read
# start with an empty ruler

count=1
ruler=""

# loop adding chars to the ruler
# char added depends on the modulus of division by 10

for i in $(seq 1 $2)
do
        if [ "$(expr ${i} % 10)" -eq "0" ]
        then
                str="$(expr ${i} / 10)"
                nchar="${str:$((${#str}-1)):1}"
        else
                if [ "$(expr ${i} % 5)" -eq "0" ]
                then
                        nchar="+"
                else
                        nchar="."
                fi
        fi

        ruler="${ruler}${nchar}"
done

# now process data. Start with an empty line.

data=""
hex1=""
hex2=""

# set a byte count

count=1
limit=$(expr ${2} - 1)

while read -n 1 byte
do
    # get the hexadecimal value for the current char
    # should be two hex digits long, from 00 to FF
    # put both in separate variables
        
    hstr=$(printf "%02X" "'${byte}")
    hex1="${hex1}${hstr:0:1}"
    hex2="${hex2}${hstr:1:1}"
        
    # add the char depending on type
        
    case "${byte}" in
         [[:print:]]) 
             data="${data}${byte}"
         ;;
         
         [^[:print:]])
             data="${data}·"
         ;;
         
         [[:space:]])
             data="${data} "
         ;;
         
         *) 
             data="${data} "
         ;;
    esac
        
    # when limit is reached, dump stuff and begin again
    # otherwise increment count and go up for a new iteration

    if [ "${count}" -gt "${limit}" ]
    then
         echo "${ruler}"
         echo "${data}"
         echo "${hex1}"
         echo "${hex2}"
         data=""
         hex1=""
         hex2=""
         count=1
    else
         count=$(expr ${count} + 1)
    fi

done < "$1"

# check if some content remains in the "data" variable after leaving the loop
# process it before terminating

if [ ${#data} -gt "0" ]
then
    echo "${ruler}"
    echo "${data}"
    echo "${hex1}"
    echo "${hex2}"
else
    echo
fi

# the end
