#!/bin/bash

# The insane guy who made legal the space char in filenames...
# (And the one who left the classic eight char length... but that's another story)

IFS=$'\n'

for F in `find ~/tmp`
do
        echo "<$F>"
done

echo "done"

# Sample run
#    me@motherbox:~/tmp$ ~/bin/files-w-spaced-names.sh 
#    </home/me/tmp>
#    </home/me/tmp/un dir con espacios>
#    </home/me/tmp/un dir con espacios/otro fichero con espacios en el nombre.txt>
#    </home/me/tmp/un dir con espacios/un fichero con blancos.txt>
#    </home/me/tmp/filez.txt>
#    </home/me/tmp/otro dir con espacios en el nombre>
#    </home/me/tmp/otro dir con espacios en el nombre/más ficheros con espacios.txt>
#    </home/me/tmp/otro dir con espacios en el nombre/más y más ficheros.txt>
#    done
