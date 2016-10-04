#!/bin/bash

#
# nfs-check-resources
# health check NFS resources
#

DEBUG=""
COMMUNITY="MY_RO_COMMUNITY"
NOW=$(date +%F-%H:%M:%S)
MYSELF=`basename ${0} .sh`
LOCKFILE="/tmp/${MYSELF}.lock"
IFS=$'\n'
echo "${MYSELF}: Executing ${NOW}"

#
# Don't let them stem one on top of another
#

test -f ${LOCKFILE} && { echo "${MYSELF}: KO. Another request is blocking this one"; exit 1; }

#
# Obtain remote mount points
#

MOUNT=(`mount | grep "type nfs"`)
test -z "${DEBUG}" || echo "${MYSELF}: Processing ${#MOUNT[@]} items"
LOOP=0

#
# Act individually on each 'mount point' 
#

for ITEM in ${MOUNT[@]}
do

    #
	  # Variable RMTFS should contain a "1.2.3.4:/REMOTE" and LOCFS "/opt/xxxx"
	  #

	  RMTFS=$(echo ${ITEM} | awk '{print $1}')
	  LOCFS=$(echo ${ITEM} | awk '{print $3}')
	  echo -e "\n${MYSELF}: Iteración ${LOOP}, Check ${LOCFS} in ${RMTFS}"

	  #
	  # Get the IP address of RMTFS and try a PING
	  #

	  IPADDR=$(echo ${RMTFS} | awk -F: '{print $1}')
	  ping -c1 ${IPADDR} > /dev/null

	  if [ "$?"=="0" ]
	  then
  
    		#
		    # Got an answer? run SNMP query
		    #

		    echo "${MYSELF}: Pinging ${IPADDR} returned a correct answer"
        SNMPW=(`snmpwalk -v2c -c ${COMMUNITY} -Oq localhost hrStorageDescr`)

		    if [ "$?"=="0" ]
		    then
        
			      #
			      # Process entries if the SNMP query returned some data
			      #

			      echo "${MYSELF}: SNMP query to ${IPADDR} is OK"

			      for ENTRY in ${SNMPW[@]}
			      do

                # 
				        # Encontrar la entrada que corresponde al FS actual
				        #

				        test -z "${DEBUG}" || echo "${MYSELF}: Entry ${ENTRY}"
				
				        if [[ "${ENTRY}" =~ "${LOCFS}" ]]
				        then
                
					          # 
					          # Obtain the SNMP index for current entry
					          #

					          test -z "${DEBUG}" || echo "${MYSELF}: Encontrado ${LOCFS}"
					          INDEX=$(echo ${ENTRY} | tr ":." "  " | awk '{print $3}')
					          test -z "${DEBUG}" || echo "${MYSELF}: Mount point ${LOCFS}, Index ${INDEX}"

          					#
          					# New SNMP query elements with current index
					          #

					          SNMPX=(`snmpwalk -v2c -c ${COMMUNITY} -Oq localhost hrStorage | grep "\.${INDEX}"`)

					          for ENTRY2 in ${SNMPX[@]}
					          do
						            test -z "${DEBUG}" || echo "${MYSELF}: Entry ${ENTRY2}"

            						#
						            # Description, Size, Used space, Assignment units
						            #

						            if [[ "${ENTRY2}" =~ "hrStorageDescr" ]]
						            then
							              EMPNT=$(echo ${ENTRY2} | awk '{print $NF}')
						            fi

						            if [[ "${ENTRY2}" =~ "hrStorageSize" ]]
						            then
							              ESIZE=$(echo ${ENTRY2} | awk '{print $NF}')
						            fi

						            if [[ "${ENTRY2}" =~ "hrStorageUsed" ]]
						            then
							              EUSED=$(echo ${ENTRY2} | awk '{print $NF}')
						            fi

						            if [[ "${ENTRY2}" =~ "hrStorageAllocationUnits" ]]
						            then
							              EUNIT=$(echo ${ENTRY2} | awk '{print $(NF-1), $NF}')
						            fi

                    done

					          #
					          # Detalle
					          #

					          echo -e "${MYSELF}: ${EMPNT}, Size ${ESIZE}, Used ${EUSED}, Units ${EUNIT}"
				        fi

             done

          else

              #
		        	# Force unmount if the SNMP check fails
			        #

			        echo "${MYSELF}: KO. SNMP check on ${IPADDR} failed"

			        test -z "${DEBUG}" || echo "${MYSELF}: Trying to unmount ${LOCFS}"
			        sudo umount -f ${LOCFS}

	            if [ "$?"=="0" ]
			        then

                  #
	  		  	      # If unmounted properly then try to mount again
		    		      # 

				          echo "${MYSELF}: Unmounted ${LOCFS}"
                  sleep 600
                  sudo mount ${LOCFS}
				
    				      #
		    		      # Show mount status message
				          # 

				          if [ "$?"=="0" ]
                  then
                      echo "${MYSELF}: Muonted ${LOCFS}"
                  else
                      echo "${MYSELF}: KO. Error trying to mount ${LOCFS}"
                  fi
              
			        else

                  #
		    		      # Did not unmount properly, there is not a lot you can do so far
				          #

				          echo "${MYSELF}: KO. Could not unmount ${LOCFS}"

              fi

		      fi

      else

          #
		      # If the system is not reachable then an intervention is required
		      #
		
		      echo "${MYSELF}: KO. Ping ${IPADDR} fails"
      fi

	    LOOP=`expr ${LOOP} + 1`

done

#
# Delete lock file if all was correctly executed
#

rm -f ${LOCKFILE}
echo -e "\n${MYSELF}: Ended on $(date +%F-%H:%M:%S)"
