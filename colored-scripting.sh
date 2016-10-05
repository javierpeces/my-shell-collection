#!/bin/bash

#
# color the world, one ping at a time
#

domain="vsphere.local"
redtext="\e[00;31m"
stdtext="\e[00m"
hostlist="proxy nsdir rep01 web01 app09 alf01 alf02 sql01 sql02"

for host in ${hostlist}
do
        rc=`ping -c1 ${host}.${domain} >/dev/null 2>&1; echo $?`
        test "${rc}" -eq "0"  &&  text="[ OK ]"  ||  text="${redtext}[ KO ]${stdtext}"
        echo -e "${host} ......: ${text}"
done

# Credits: http://hacktux.com/bash/colors
