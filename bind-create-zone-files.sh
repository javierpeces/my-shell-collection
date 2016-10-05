#!/bin/bash

# bind-create-zone-files
# automate creation of per-zone config files

myself=`basename $0`
# bindbase="/etc/bind"
bindbase="."
domain="cloud.local"
iprange="192.168.10"

hostlist=(namesrv1 namesrv2 mailsrv1 mailsrv2 vcenter esxhost1 esxhost2)
addrlist=(10 11 12 13 20 40 41)

#
# Direct string supply ---> read -a array <<< "${iprange}"
#

range=$(echo ${iprange} | tr '.' ' ')
read -a array <<< $(for word in ${range}; do echo ${word}; done | tac)

direct="${bindbase}/db.${domain}"
reverse="${bindbase}/db"

for item in ${array[@]}
do
        # echo ">>> ${item} <<<"
        reverse="${reverse}.${item}"
done

reverse="${reverse}.in-addr.arpa"
echo "### ${myself}: direct \"${direct}\", reverse \"${reverse}\""
echo "### ${#hostlist[@]} hosts"
last=`expr ${#hostlist[@]} - 1`

for i in `seq 0 ${last}`
do
        host="${hostlist[$i]}"
        numb="${addrlist[$i]}"
        fqdn="${host}.${domain}."
        addr="${iprange}.${numb}"
        printf "%-25s\tIN\tA\t%s\n" ${fqdn} ${addr}

done | tee ${direct}

for i in `seq 0 ${last}`
do
        host="${hostlist[$i]}"
        numb="${addrlist[$i]}"
        fqdn="${host}.${domain}."
        printf "%-25s\tIN\tPTR\t%s\n" ${numb} ${fqdn}

done | tee ${reverse}

# end of file
