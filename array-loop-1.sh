#!/bin/bash

declare -a indata=( " " "182910" "1708" "7889182" "hare hare" "71" "1709" "1710" " " "" )
declare -a sorted=( "0" )
echo "Starting..."

#
# "${!indata[@]}" holds the list of incoming values; 
# 'index' and 'inval' are key and value on each iteration
#

for index in "${!indata[@]}"
do
    inval="${indata[index]}"
    [[ -z "${inval:+word}" || "${inval//[0-9]}" ]] && { echo "WARN: Line ${index} has invalid content \"${inval}\"."; continue; } 
    echo -ne "index ${index}: value ${inval}\n"
    
    # 
    # check sorted array items until the current input value fits
    # 'sortidx' and 'sortval' are key and value on each iteration
    #
    
    for sortidx in "${!sorted[@]}"
    do 
    
        #
        # get sorted value for current index; compare to incoming one
        #
    
        sortval="${sorted[sortidx]}"
        echo -ne "\tCompare value \"${inval}\" with sorted \"${sortval}\"\n"
        
        #
        # if greater, insert this value and stop checkin sorted values
        #
        
        if [ "${inval}" -ge "${sortval}" ]
        then
            echo -ne "\t\tInsert value \"${inval}\" before \"${sortval}\"\n"
            sorted=( "${sorted[@]:0:sortidx}" "${inval}" "${sorted[@]:sortidx}" )
            break
        fi
        
        #
        # go for next sorted value if needed
        #
        
        echo -ne "\tAt end of inner loop\n"
    done
    
    echo -ne "At end of main loop\n"
    
    #
    # print current contents at the end of each main iteration
    #
    
    for tempidx in "${!sorted[@]}"
    do 
        tempval="${sorted[tempidx]}"
        echo -ne "${tempidx}: ${tempval}\n"
    done
    
    echo "-"
done

#
# discard the initial "zero" items
#

numitems=$( expr "${#sorted[@]}" - 1 )
sorted=( "${sorted[@]:0:numitems}" )

#
# print final contents at the end of execution
#

echo "At the end, the sorted array holds ${numitems} values..."

for finalidx in "${!sorted[@]}"
do 
    finalval="${sorted[finalidx]}"
    echo -ne "${finalidx}: ${finalval}\n"
done

echo "Finish."
