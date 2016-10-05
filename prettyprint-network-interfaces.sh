#!/bin/bash

#
# improve legibility of ifconfig or ip addr or...
#

function pretty( )
{
        dotted=${1}
        spaced=$(echo ${dotted}|tr "." " ")
        result=""
        for item in ${spaced}
        do
                if [[ ${item} =~ ^[0-9]+$ ]]
                then
                        item3=$(printf "%03d" ${item})
                else
                        item3="000"
                fi
                result="${result}.${item3}"
        done
        echo -ne "${result:1:$(expr ${#result} - 1)}"
}

output=($(ip addr))
j=1
for (( i = 0; i < ${#output[@]}; i ++ ))
do
        thisword="${output[${i}]}"
        nodots=$(echo "${thisword}" | tr -d ':')

        next="$(expr ${i} + 1)"
        nextword="${output[${next}]}"

        jump="$(expr ${i} + 3)"
        jumpword="${output[${jump}]}"

        if [ "${j}" == "${nodots}" ]
        then
                if [ "${j}" -gt "1" ]
                then
                        phrase=($(echo -ne ${addmsk}|tr "/" " "))
                        ipaddr=$(pretty ${phrase[0]})
                        ipmask=${phrase[1]}
                        ipcast=$(pretty ${ipcast})
                        ipgate=$(pretty $(netstat -rn|grep ${ifname}|awk '{print $2}'))

                        if [ "${ipgate}" == "000.000.000.000" ]
                        then
                               ipgate=" "
                        fi

                        printf "%8s %s %s /%2s %s %s\n" \
                        ${ifname} ${hwaddr} ${ipaddr} ${ipmask} ${ipcast} ${ipgate}
                fi

                ifname=$(echo "${nextword}" | tr -d ':')
                hwaddr="00:00:00:00:00:00"
                hwcast="00:00:00:00:00:00"
                addmsk="0.0.0.0/0"
                ipcast="0.0.0.0"
                j=$(expr ${j} + 1)
        fi

        # echo -ne "$i >>> ${output[$i]} "

        if [[ "${thisword}" == link/* ]]
        then
                hwaddr="${nextword}"
                hwcast="${jumpword}"
        fi

        if [ "${thisword}" == "inet" ]
       then
                addmsk="${nextword}"
                ipcast="${jumpword}"
        fi

done
echo -ne "\n"

# Sample output
#
#  javier@oximoron:~/bin$ ./prettyprint-network-interfaces.sh
#          lo 00:00:00:00:00:00 127.000.000.001 / 8 000 
#        eth0 bc:ae:c5:9f:46:70 000.000.000.000 / 0 000.000.000.000 
#       wlan0 48:5d:60:97:ae:32 192.168.001.130 /24 192.168.001.255 192.168.001.001
#      vmnet1 00:50:56:c0:00:01 192.168.020.001 /24 192.168.020.255 
#      vmnet8 00:50:56:c0:00:08 192.168.010.001 /24 192.168.010.255 
#     vmnet11 00:50:56:c0:00:0b 010.010.050.001 /24 010.010.050.255
# 
#  some love this output, some find it confusing...
