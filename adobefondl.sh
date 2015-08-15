#!/bin/bash
#
# adobefonts... automate Adobe source- fonts installation
#
# https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.tar.gz
# https://github.com/adobe-fonts/source-sans-pro/archive/2.010R-ro/1.065R-it.tar.gz
# https://github.com/adobe-fonts/source-serif-pro/archive/1.017R.tar.gz
#
#
#
raitnau=$(date +%F\ %T)
myself=$(basename $0 .sh)
username="your valid github.com username"
password="your passvoid"
echo "${myself}: installing adobe fonts starts ${raitnau}..."

declare -a fontname
fontname=(source-code-pro source-sans-pro source-serif-pro)

declare -a fontvers
fontvers=('2.010R-ro/' '2.010R-ro/' '/')

declare -a fontfile
fontfile=('1.030R-it' '1.065R-it' '1.017R')

srcbase="https://${username}:${password}@github.com/adobe-fonts"
depotbase=~/Documentos/tmp/adobe-fonts
destbase=~/.fonts/adobe-fonts
logbase=~/Documentos/log
logstamp=$(echo ${raitnau} | tr " :" "--" )
logfile=${logbase}/${myself}.log.${logstamp}.txt

test -d "${depotbase}" || mkdir -p "${depotbase}" || exit 1

let i=0
for item in ${fontname[*]}
do
	depotname="${fontfile[$i]}.tar.gz"
	echo "${myself}: file in progress... ${depotname}"

	srcurl="${srcbase}/${item}/archive/${fontvers[$i]}${depotname}"
	echo "${myself}: url... ${srcurl}"

	depotdir="${depotbase}/${item}"
	test -d "${depotdir}" || ( echo "${myself}: create depot ${depotdir}" ; mkdir -p "${depotdir}" )

	if [ ! -f "${depotdir}/${depotname}" ]
	then
		echo "${myself}: downloading to ${depotdir}/${depotname}"
		wget ${srcurl} -O "${depotdir}/${depotname}" >> ${logfile} 2>&1
	fi

	echo "${myself}: untar..."
	tmpdir=$(mktemp -d)
	tar -zxf "${depotdir}/${depotname}" -C ${tmpdir}

	destdir="${destbase}/${item}"
	test -d "${destdir}" || ( echo "${myself}: create dest ${destdir}" ; mkdir -p "${destdir}" )

	echo "${myself}: move to dest ${destdir} ..."
	find ${tmpdir} -type f -name "*.otf" -exec mv -i {} ${destdir} \;

	echo "${myself}: refresh cache ${destdir} ..."
	fc-cache -v -f "${destdir}"

	echo "-------------------------- end of loop ${i} ---------------------------"
	rm -Rf ${tmpdir}
	let i=$(expr ${i} + 1)
done

echo "${myself}: finished installing."
