#!/bin/bash
#
# the-read-loop.sh
# the true sequential file processing with bash
#

# 
# Let's thihk about the file as a collection of 'rows'.
# Each row is made of space-tab-or-whatever delimited 'cols'.
#
# bash considers that a new data item begins when the IFS
# 'Input Field Separator' is found in an input stream
#
# By default IFS holds a space. Let's set it to 'newline' character
# And let's set the row counter to zero
#

IFS=$'\n'
rowno=0

#
# a loop making one iteration per line inside the file
#

for row in $(cat YOUR-INPUT-FILE.txt)
do
        echo -e "${rowno}: '${row}'"

        #
        # Just for the string-to-array assignment, set Input Field Separator to:
        # - space
        # - tab char, and 
        # - vertical bar
        # Parse contents of variable 'row' into the array 'aline( )'
        # Recover the previous 'newline' field separator
        #

        IFS=$'\t |'
        declare -a aline=(${row})
        IFS=$'\n'

        #
        # now the array has one element per 'word' present in the current row
        # Let's set column counter to zero
        #

        colno=0

        #
        # a second level loop performing one iteration per column inside the line
        #

        for column in ${aline[@]}
        do                        
                #
                # Your process for each column should be below
                # I just print the counters and the column contents
                #

                echo -e "\t${rowno} ${colno}: '${column}'"
                
                #
                # increase the column count
                #
                
                let colno\+=1
        done

        #
        # when all columns processed: 
        # - show totals 
        # - increase the row count
        # - destroy the array
        #

        echo -e "\tTotal cols: ${colno}."
        let rowno\+=1

        unset aline
done

#
# when all rows are done, show totals
#

echo "Total rows: ${rowno}."
echo "Finito."
