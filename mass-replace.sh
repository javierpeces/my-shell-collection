#!/bin/bash
#
# mass-replace 
# change user and password in all (magnolia cms) config files
# carefully adjust parms below
#

DBHOST="database.server.org"
DBPORT="3306"
MAGBASE="/opt/magnoliaAuthor"
DBNAME="dbauthor"
DBUSER="uauthor"
DBPASS="Auth0rP4ssw0rd"

#
# MAGBASE="/opt/magnoliaPublic"
# DBNAME="dbpublic"
# DBUSER="upublic"
# DBPASS="U53rP4ssw0rd"
#

#
# don't edit below this point
#

DBCONN="jdbc:mysql://${DBHOST}:${DBPORT}/${DBNAME}"
declare -a NAMES=('url' 'user' 'password')
declare -a VALUES=("${DBCONN}" "${DBUSER}" "${DBPASS}")
cd ${MAGBASE}

for I in 0 1 2
do
        echo "--------------- Loop ${I} ---------------"
        SEARCHFOR="\"${NAMES[$I]}\""
        REPLACEBY="\"${VALUES[$I]}\""
        FILEZ=`find . -name "*xml" \
                | sudo xargs grep -i "name=${SEARCHFOR}" \
                | awk -F: '{print $1}'`

        for F in ${FILEZ}
        do
                echo "${F}"
                SOURCE="name=${SEARCHFOR} value=\".*\""
                TARGET="name=${SEARCHFOR} value=${REPLACEBY}"
                echo -e "\t_${TARGET}_"
                sudo sed -i -e "s_${SOURCE}_${TARGET}_" ${F}
        done
done

# That's it
