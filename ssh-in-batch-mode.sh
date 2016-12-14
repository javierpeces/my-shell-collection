#!/bin/bash
#
# proc-check-running
# chequeo de salud de los procesos críticos
#

DEBUG=""
AHORA=$(date +%F-%H:%M:%S)
MYSELF=`basename ${0} .sh`
LOCKFILE="/tmp/${MYSELF}.lock"
# IFS=$'\n'
SHOUT="0"
echo "${MYSELF}: Ejecución de ${AHORA}"

#
# Este bloqueo impide que se acumulen peticiones
#

test -f ${LOCKFILE} && { echo "${MYSELF}: KO. Hay otra petición pendiente"; exit 1; }

#
# Se supone que tenemos un fichero con la lista de máquinas a procesar y los procesos a vigilar
#

SYSLIST="${HOME}/proc-check-syslist.txt"
ITEM=0

while read -r
do
        LINE=${REPLY}
        echo "<<< ${LINE} >>> Length: ${#LINE}"
        WORDNO=0
        for WORD in ${LINE}
        do
                if [ "${WORDNO}" -eq "0" ]
                then
                        SYSTEM="${WORD}"
                        IPADDR=$(dig +short ${SYSTEM})
                        echo "Host: ${SYSTEM} (${IPADDR})"
                else
                        PARMS=( $(echo ${WORD} | tr "=\(,\)" "    ") )
                        DAEMON=${PARMS[0]}
                        MINVAL=${PARMS[1]}
                        MAXVAL=${PARMS[2]}
                        LIVEOP=$(ssh -o 'BatchMode yes' ${SYSTEM} "ps ajxw | grep ${DAEMON} | grep -v grep | wc -l")
                        if [ "${LIVEOP}" -lt "${MINVAL}" -o "${LIVEOP}" -gt "${MAXVAL}" ]
                        then
                                ALERT="ALERT"
                        else
                                ALERT="....."
                        fi
                        printf "(%4s) [%s] %10s: Min: %3s, Max: %3s, Live: %3s\n" \
                            ${ITEM} ${ALERT} ${DAEMON} ${MINVAL} ${MAXVAL} ${LIVEOP}
                fi
                WORDNO=`expr ${WORDNO} + 1`
        done
        ITEM=`expr ${ITEM} + 1`
done < ${SYSLIST}

#
# Si todo ha ido bien, borrar bloqueo
#

rm -f ${LOCKFILE}
echo -e "\n${MYSELF}: Terminado $(date +%F-%H:%M:%S)"
