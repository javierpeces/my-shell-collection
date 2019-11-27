#!/bin/bash
# set -x
test -f "${1}" || { echo "ERROR: input file does not exist."; exit 1; }
test -r "${1}" || { echo "ERROR: input file is not readable."; exit 1; }
test -z "${2}" && { echo "ERROR: bad maximum number of top results."; exit 1; }
infile="${1}"
num="${2}"

if [ "${num}" -le 0 ]
then
        echo "ERROR: Number of top results must be bigger than 0."
        exit 1
fi

if [ "${num}" -gt 30000000 ]
then
        echo "ERROR: Maximum number of top results must be less or equal than 30000000."
        exit 1
fi

echo "INFO: Looks like arg 2 (${num}) is valid"

rank=( [0]=0 )

# for item in "${rank[*]}"
# do
#       echo ${item}
# done

# for i in $( seq 0 ${num} )
# do
#       echo ${i}
# done

#
# read input file contents line by line
#

lineno=0

while IFS= read -r line
do
        echo "INFO: Line ${lineno}: \"${line}\""

        # [[ -z "${line//[0-9]}" ]] \
        #   || echo "WARN: At line ${lineno}, \"${line}\" is not a number."
        # [[ -z "${line:+word}" ]] \
        #   && echo "WARN: At line ${lineno} is empty."

        [[ -z "${line:+word}" || "${line//[0-9]}" ]] && echo "WARN:    Line ${lineno} is invalid."
        lineno=$( expr ${lineno} + 1 )

done < "${infile}"
