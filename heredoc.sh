#!/bin/bash

#
# quick reminder about the definition of HERE docs
#

cat <<-EOF > data.txt
 all this stuff goes to a data file
   that -surprisingly- is
	named data.txt

EOF
