################################################################################
# $Id: turnOn_cron.txt 4415 2017-11-06 17:20:59Z skumar $
################################################################################

# Sample .profile for SuSE Linux
# rewritten by Christian Steinruecken <cstein@suse.de>
#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && . /etc/profile || true

# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
# This overwrites the system default set in /etc/sysconfig/language
# in the variable RC_LANG.
#
#export LANG=de_DE.UTF-8    # uncomment this line for German output
#export LANG=fr_FR.UTF-8    # uncomment this line for French output
#export LANG=es_ES.UTF-8    # uncomment this line for Spanish output


# Some people don't like fortune. If you uncomment the following lines,
# you will have a fortune each time you log in ;-)

#if [ -x /usr/bin/fortune ] ; then
#    echo
#    /usr/bin/fortune
#    echo
#fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/12.2/client64/lib
export TNS_ADMIN=/clearing/filemgr/tnsnames.ora

ORACLE_SID=clear3
ORACLE_BASE=/usr/lib/oracle
ORACLE_TERM=vt220
ORACLE_HOME=/usr/lib/oracle/12.2/client64

alias cls=clear
alias rm='rm -i'
alias lt='ls -l --time-style="+%Y%m%d-%H%M"'

################################################################
# Remote Servers
################################################################
export MAS_HOST_NAME=dfw-prd-mas-01
export CLEARING_HOST_NAME=dfw-prd-clr-01


################################################################
# DB Logons
################################################################
export ATH_DB_USERNAME="teihost"
export ATH_DB_PASSWORD="quikdraw"
export IST_DB_USERNAME="masclr"
export CLR2_DB_USERNAME="masclr"
export IST_DB_PASSWORD="masclr"
export CLR2_DB_PASSWORD="masclr"
export PORT_DB_USERNAME="port"
export PORT_DB_PASSWORD="tawny"

export ATH_DB="auth3"
export IST_DB="clear3"
export TSP4_DB="auth2"
export SEC_DB="clear2"
export CLR2_DB="clear2"
export PORT_DB="clear2"

export ATH_HOST="dfw-prd-db-06.jetpay.com"
export ATH2_HOST="auth2.jetpay.com"
export IST_HOST="clear3.jetpay.com"
# export CLR2_HOST="s02-prd-clr-db-m01.jetpay.com"
export CLR2_HOST="clear2.jetpay.com"
export PORT_HOST="clear2.jetpay.com"
export SFTP_HOST="sftp.jetpay.com"

export IST_SERVERNAME="clear3.jetpay.com"
export CLR2_SERVERNAME="clear2.jetpay.com"
export PORT_SERVERNAME="clear2.jetpay.com"
export ATH2_SERVICE_NAME="auth2"

export TNS_ADMIN=/clearing/filemgr/tnsnames.ora

export PATH=$PATH:/clearing/filemgr/scripts
export MASCLRLIB_PATH=/clearing/filemgr/MASCLRLIB

export ARCHIVE_ENCRYPT_KEY=7DDAE50B
export B2B_ENCRYPT_KEY=35931066
export DAS_ENCRYPT_KEY=29282E63
export PTC_ENCRYPT_KEY=F10EE2FA
export SBC_ENCRYPT_KEY=B4EF748B
export WEPAY_ENCRYPT_KEY=B8D03B21
export HOSTNAME=s01-prd-cm-fmgr-m01

################################################################
# MasterCard edit package connectivity
################################################################
export MAST_EDIT_HOST=dfw-prd-clr-02
export MAST_EDIT_USERNAME=filemgr
export MAST_EDIT_PASSWORD='$u3_veRe'
