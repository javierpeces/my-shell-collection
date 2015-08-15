#!/bin/bash
#
# adobefonts... automate Adobe source- fonts installation
#
# https://github.com/adobe-fonts/source-code-pro.git
# https://github.com/adobe-fonts/source-sans-pro.git
# https://github.com/adobe-fonts/source-serif-pro.git
#
#
raitnau=$(date +%F\ %T)
myself=$(basename $0 .sh)
username="your github dot com user"
password="your github dot com passvoid"
echo "${myself}: installing adobe fonts starts ${raitnau}..."

declare -a fontname
fontname=(source-code-pro source-sans-pro source-serif-pro)

srcbase="https://${username}:${password}@github.com/adobe-fonts"
destbase=~/.fonts/adobe-fonts
logfile=~/${myself}.log.$(echo ${raitnau} | tr " :" "--" ).txt

# para instalar en todo el sistema...
# destbase="/usr/share/fonts/opentype/adobe-fonts"

test -d "${destbase}" || mkdir -p "${destbase}" || exit 1

for item in ${fontname[*]}
do
	srcgit="${srcbase}/${item}.git"
	destdir="${destbase}/${item}"
	echo "${myself}: installing ${item}"
	mkdir -p ${destdir}
	git clone ${srcgit} ${destdir} > ${logfile} 2>&1
	fc-cache -f -v ${destdir} > ${logfile} 2>&1
done

echo "${myself}: finished installing."
