#!/bin/bash

#
# splitjoin
# a file too big to fit somewhere? this breaks it into pieces 
# and (hopefully) you may later rebuild it back
#


# uuuh... too big...
#
#    javier@decrepit:[~] $ ls -l "bigfile.dat" 
#    -rw------- 2 javier javier 16748978605 ene 23 03:40 bigfile.dat


# let's break it (have a backup handy first)
#
#    javier@decrepit:[/media/FAT32] $ split --verbose -b 512M -d ~/bigfile.dat 
#    creating file «x00»
#    ...
#    creating file «x31»


# this is what you got:
#
#    javier@decrepit:[/media/FAT32] $ ls -l
#    total 16356432
#    -rw-r--r-- 1 javier javier 536870912 feb 21 12:47 x00
#    -rw-r--r-- 1 javier javier 536870912 feb 21 12:49 x01
#    -rw-r--r-- 1 javier javier 536870912 feb 21 12:51 x02
#    -rw-r--r-- 1 javier javier 536870912 feb 21 12:53 x03
#    ...
#    -rw-r--r-- 1 javier javier 536870912 feb 21 14:44 x30
#    -rw-r--r-- 1 javier javier 105980333 feb 21 14:44 x31


# now imagine this FAT32 drive moved to destination
#
#     $ filez=$(ls -1 x*)
#     $ echo $filez
#     x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 ... x31
#     $ cat $filez > result.zip


# and then let's check if we got the same data in the new file
#
#     $ md5sum ~/bigfile.zip
#     a2f41713f9f7407a9a3e43fb27fd2e24  bigfile.zip
#     $ md5sum result.zip
#     a2f41713f9f7407a9a3e43fb27fd2e24  result.zip

# YEAH!
