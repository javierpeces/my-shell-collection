Y ficheros con nombres de longitud determinada...

#!/bin/bash
# files-w-name-longer-than.sh
# Find files with name longer than...

IFS=$'\n'
maxlen=200
total=0

export infile="~/doc/list-of-files.txt"
echo "processing ${infile}"

for L in `cat ${infile}`
do
    test "${#L}" -gt "${maxlen}" \
        && { total=`expr ${total} + 1`; printf "%6d: %4d '%s'\n" ${total} ${#L} ${L}; }
done

echo "total ${total} files with more than ${maxlen} chars in filename."
