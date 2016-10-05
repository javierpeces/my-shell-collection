#!/bin/bash

#
# NEW: Pattern support
#

#   $ cat ~/.passlist  
#   ESXI    esxtest1.hello.org root                        SamplePass1
#   ESXI    esxtest2.hello.org root                        SamplePass2
#   VCENTER vcenter.hello.org  administrator@sso.hello.org SamplePass3
#   NETWORK 10.10.1.*          root                        SamplePass4
#   NETWORK 192.168.0.*        root                        SamplePass5
#   RDP     192.168.1.10       youruser                    SamplePass6

# The trick is in HH ~ $2, a regexp like any other

#   $ cat ~/bin/getpass  
#   #!/bin/bash
#   awk -v TT=$1 -v HH=$2 -v UU=$3 \
#     '{ if( $1 == TT && HH ~ $2 && $3 == UU ) print $4 }' \
#     $HOME/lib/.passlist

# USAGE:

targethost="192.168.1.10"
username="your-own-username"
password=`getpass RDP ${targethost} ${username}`
alias rdpt='rdesktop -k es -g 1366x768 -u ${username} -p  192.168.1.10 &'

# Now you may publish the script (these four lines above) without explicit passwords inside.
