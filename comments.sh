#!/bin/bash
#
# imagine a file with commented, uncommented and blank lines
#
#     $ cat victim.txt
#     # comment
#       0 1 2 * go hard 
#     99 * this and that    
#     # another comment
#
#     # There is a blank line above
#     12 34 56 /tmp
#            hello
#	a tab char contained in this line
#
# this oneliner adds a mark to all non-commented and non-blank lines:
#

sed -i -e 's/^[^#]/### MARK ###/' victim.txt

#
# hint: for your convenience, choose a ### MARK ### not already present in data
# use the following command to undo changes:
#

sed -i -e 's/### MARK ###//' victim.txt

# that\'s all folks
