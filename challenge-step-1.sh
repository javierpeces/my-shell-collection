#!/bin/bash
# set -x
# step-1: find biggest numbers in a sequential file
# input data
#    arg 1: input file (sorry, must be in the current directory)
#    arg 2: maximum number of displayed results, must be gt 0 and lt 30 million
# output data
#    stdout: biggest (arg 2) numbers in input, sorted by size descending
# test data
#    cat /usr/share/dict/cracklib-small | tr abcdefghij 0123456789 > test-1.txt
# limitations
#    bash cannot handle integers greater than 9223372036854775807

DEBUG=""

test -f "${1}" || { echo "ERROR: input file does not exist."; exit 1; }
test -r "${1}" || { echo "ERROR: input file is not readable."; exit 1; }
test -z "${2}" && { echo "ERROR: maximum number of top results not specified."; exit 1; }
[[ -z "${2:+word}" || "${2//[0-9]}" ]] { echo "ERROR: maximum number of top results is NaN."; exit 1; }

infile="${1}"
maxnotr="${2}"

if [ "${maxnotr}" -le 0 ]
then
        echo "ERROR: Number of top results must be bigger than 0."
        exit 1
fi

if [ "${maxnotr}" -gt 30000000 ]
then
        echo "ERROR: Maximum number of top results must be less or equal than 30000000."
        exit 1
fi

test -z "${DEBUG}" || echo "INFO: Looks like arg 2 (${maxnotr}) is valid"
let "maxnotr--"
ranking=( 0 )
lineno=0
matches=0
invalid=0

#
# Process input lines one by one
#

while IFS= read -r line
do
        test -z "${DEBUG}" || echo "INFO: Line ${lineno}: \"${line}\""

        #
        # Check incoming value not greater than 9223372036854775807
        #

        if [ "${line}" -eq "${line}" ] 2>/dev/null
        then
                #
                # Remove leading zeros (bash interprets as octal) 
                #
        
                line=$(expr ${line} + 0)
                
                #
                # compare incoming to existing items already in ranking
                #
                
                for i in "${!ranking[@]}"
                do
                        current="${ranking[i]}"
                        
                        #
                        # if this value is greater than the current ranking item, insert it here and leave the loop
                        #
                        
                        if [ "${line}" -ge "${current}" ] 2>/dev/null
                        then
                                test -z "${DEBUG}" || echo -e "\tINFO: Line ${lineno} (${line}) match ${matches}."
                                ranking=( "${ranking[@]:0:i}" "${line}" "${ranking[@]:i}" )
                                let "matches++"
                                break
                        fi
                        
                        #
                        # go for the next item in ranking
                        #
                done
        else
                test -z "${DEBUG}" || echo -e "\tWARN: Line ${lineno} (${line}) is invalid."
                let "invalid++"
        fi
        
        #
        # go for the next incoming value
        #

        let "lineno++"

done < "${infile}"

test -z "${DEBUG}" || echo "INFO: Invalid lines ${invalid}"
test -z "${DEBUG}" || echo "INFO: Matched lines ${matches}"

#
# Print requested values
#

echo "Results..."

for item in "${!ranking[@]}"
do
        printf "FINAL: %5d %20d\n" ${item} ${ranking[item]}
        [[ "${item}" -ge "${maxnotr}" ]] && break
done   

echo "Done."
