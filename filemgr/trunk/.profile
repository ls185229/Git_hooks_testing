################################################################
# This is built from the default standard profile provided
# for the filemgr user.
# $Id: .profile
################################################################

export MAIL=/usr/mail/${LOGNAME:?}

################################################################
# Function to append to PATH
# Listed in http://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
################################################################
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$1"
    fi
}

libpathadd() {
    if [ -d "$1" ] && [[ ":$LD_LIBRARY_PATH:" != *":$1:"* ]]; then
        export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+"$LD_LIBRARY_PATH:"}$1"
    fi
}

manpathadd() {
    if [ -d "$1" ] && [[ ":$MANPATH:" != *":$1:"* ]]; then
        export MANPATH="${MANPATH:+"$MANPATH:"}$1"
    fi
}

################################################################
# System Configurations, Environmental Variables & Aliases
################################################################
export MANPATH=/usr/man:/usr/bin/man:/usr/share/man:/usr/dt/man:/Osrc/tools/man:/usr/local/man

export ARCH=sparc
export OS=SOL
export OS_REV=5.11
export MACHINE="_${OS}${OS_REV}_${ARCH}"
export A=$MACHINE
export JAVA_HOME=/usr/java
#export PYATHDEV=

export EDITOR=vi
export HISTORY=128
export TERM=vt100

set -o vi
alias chkalert='ls -l /clearing/alerts/* ~/*process.stop*'
alias chkfile='ls -lth {$CLR_OSITE_DATA,$MAS_OSITE_DATA}/{in,out,process,reject,done,ach,ftp}{,/*}/* 2>&1 | grep -v '\''No such'\'' | head'
alias chkhold='~/MTHEND/check_hold_files.sh | grep -v total'
alias cls='clear'
alias js='cd /export/arch/jumpstart'
alias ll='ls -ltr'
alias lt='ls -tog --time-style=+%Y%m%d_%H%M%S'
alias trace='traceroute'
alias xa='cd /export/arch'


################################################################
# Source .kshrc if it exists to set local user preferences
################################################################
if [ -f $HOME/.kshrc ] ; then
  . $HOME/.kshrc
fi

################################################################
# Set prompt (Line 1: username@hostname
#             Line 2: current_working_directory history_list > )
################################################################
if [ -f $HOME/.prompt ] ; then
  . $HOME/.prompt
fi

export PS1="\$PWD>
[${LOGNAME}@$(hostname)] # "

################################################################
# Default PATH
################################################################

SITE=${HOSTNAME:0:3}
SITE=${SITE^^}

case $SITE in
    "S01" | "DFW")
        export SITE="S01"
        ;;
    "S02" | "HQZ")
        export SITE="S02"
        ;;
    "DC2" )
        # Ashburn
        export SITE="S03"
        ;;
    "DC3" )
        export SITE="S04"
        # Las Vegas
        ;;
    *)
        echo "The machine does not corform to SITE naming conventions"
        echo "The first three characters should determine the data center"
        exit 1
        ;;
esac

pathadd /bin
pathadd /usr/dt/bin
pathadd /sbin
pathadd /usr/sbin
pathadd /usr/bin
pathadd /usr/local/sbin
pathadd /usr/local/lib
pathadd /usr/local/etc
pathadd /usr/openwin/bin
pathadd /usr/ucb

HOST=`uname -m`

pathadd /usr/platform/$HOST/sbin
pathadd /usr/proc/bin
pathadd /opt/bin
pathadd /usr/lib
pathadd /usr/ccs/bin
pathadd /usr/local/apache/bin
pathadd $HOME/scripts
pathadd $HOME/scripts/bin
pathadd /usr/local/bin
pathadd /usr/local/teTeX/bin/sparc-sun-solaris2.11

################################################################
# Oracle 11g Path
################################################################
export DBDIR="dbm.oci"
export ORACLE_BASE=/clearing/oracle
export ORACLE_HOME=$ORACLE_BASE/app/oracle/product/11.2.0/client_1
#export ORACLE_HOME=$ORACLE_BASE/app/oracle/product/12.2.0.1.0/instantclient_12_2

case $SITE in
    "S01" )
        export ORACLE_SID=clear3
        export TWO_TASK=clear3
        ;;
    "S02" )
        export ORACLE_SID=clear2
        export TWO_TASK=clear2
        ;;
    "DC2" )
        # Ashburn
        ;;
    "DC3" )
        # Las Vegas
        ;;
    *)
        echo "The machine does not corform to SITE naming conventions"
        echo "The first three characters should determine the data center"
        exit 1
        ;;
esac

export ORACLE_TERM=vt220
export ORAENV_ASK=NO

pathadd /opt/SUNWspro/bin
pathadd /usr/ucb
pathadd /usr/local/bin
pathadd /usr/openwin/bin
pathadd /usr/ccs/bin
pathadd /usr/lib
pathadd /usr/ccs/lib
pathadd /usr/bin
pathadd /opt/SUNWspro/bin
pathadd $ORACLE_HOME/bin
pathadd $ORACLE_HOME/lib
pathadd /clearing/masadmin
pathadd /usr/local/bin
pathadd $JAVA_HOME/bin
pathadd $JAVA_HOME/lib

libpathadd $ORACLE_HOME/lib
libpathadd $ORACLE_HOME/network/lib
libpathadd $ORACLE_HOME/lib32

pathadd $ORACLE_BASE
pathadd $ORACLE_HOME
pathadd $ORACLE_HOME/scripts
pathadd $ORACLE_HOME/bin
pathadd $ORACLE_HOME/lib32
pathadd $ORACLE_HOME/network

################################################################
# Default MANPATH
################################################################
tmp=`echo ${MANPATH}`
if [ -z $tmp ] ; then
    MANPATH=/usr/share/man
fi

tmp=`echo ${MANPATH} | grep "/usr/share/man"`
if [ -z $tmp ] && [ -d /usr/share/man ] ; then
    MANPATH=$MANPATH:/usr/share/man
fi

tmp=`echo ${MANPATH} | grep "/usr/dt/share/man"`
if [ -z $tmp ] && [ -d /usr/dt/share/man ] ; then
    MANPATH=$MANPATH:/usr/dt/share/man
fi

tmp=`echo ${MANPATH} | grep "/usr/local/man"`
if [ -z $tmp ] && [ -d /usr/local/man ] ; then
    MANPATH=$MANPATH:/usr/local/man
fi

tmp=`echo ${MANPATH} | grep "/usr/openwin/share/man"`
if [ -z $tmp ] && [ -d /usr/openwin/share/man ] ; then
    MANPATH=$MANPATH:/usr/openwin/share/man
fi

tmp=`echo ${MANPATH} | grep "/usr/demo/SOUND/man"`
if [ -z $tmp ] && [ -d /usr/demo/SOUND/man ] ; then
    MANPATH=$MANPATH:/usr/demo/SOUND/man
fi

tmp=`echo ${MANPATH} | grep "/usr/local/apache/man"`
if [ -z $tmp ] && [ -d /usr/local/apache/man ] ; then
    MANPATH=$MANPATH:/usr/local/apache/man
fi

################################################################
# Default LD_LIBRARY_PATH
################################################################
libpathadd /usr/lib
libpathadd /usr/dt/lib
libpathadd /usr/openwin/lib
libpathadd /usr/ccs/lib

HOST=`uname -m`

libpathadd /usr/platform/$HOST/lib
libpathadd /usr/sfw/lib
libpathadd /usr/local/lib

libpathadd $HOME/scripts/lib

################################################################
# Clearing & MAS Environmental Variables
################################################################
CLRPDIR="pdir"
export CLR_OLOGDIR=/clearing/apps/clearing/$CLRPDIR/log
export CLR_OSITE_DATA=/clearing/apps/clearing/$CLRPDIR/ositeroot/data
export CLR_OSITE_ROOT=/clearing/apps/clearing/$CLRPDIR/ositeroot

MASPDIR="pdir"
export MAS_OSITE_ROOT=/clearing/apps/mas/$MASPDIR/ositeroot
export MAS_OSITE_DATA=/clearing/apps/mas/$MASPDIR/ositeroot/data
export MAS_OLOGDIR=/clearing/apps/mas/$MASPDIR/log

export ALERTS_DIR=/clearing/alerts
export MASCLR_LIB=/clearing/filemgr/MASCLRLIB

case $SITE in
    "S01" )
        export CLEARING_BOX="dfw-prd-clr-01"
        export MAS_BOX="dfw-prd-mas-01"
        ;;
    "S02" )
        export CLEARING_BOX="hqz-prd-clr-01"
        export MAS_BOX="hqz-prd-mas-01"
        ;;
    "DC2" )
        # Ashburn
        ;;
    "DC3" )
        # Las Vegas
        ;;
    *)
        echo "The machine does not corform to SITE naming conventions"
        echo "The first three characters should determine the data center"
        exit 1
        ;;
esac

export SYS_BOX="$SITE-PRD-MAS"

export ARCHIVE_ENCRYPT_KEY=7DDAE50B
export ARCHIVE_BOX=hex

PREFIXDIR=$OPRODUCT_ROOT
export PREFIXDIR

################################################################
# Windows Boxes
################################################################

case $SITE in
    "S01" )
        export FILE_XCHNGR_MC="dfw-prd-clr-02"
        export FILE_XCHNGR_MC_USERNAME="filemgr"
        export FILE_XCHNGR_MC_PASSWORD="\$u3_veRe"

        export FILE_XCHNGR_VS="dfw-prd-clr-02"
        export FILE_XCHNGR_VS_USERNAME="filemgr"
        export FILE_XCHNGR_VS_PASSWORD="\$u3_veRe"

        ;;
    "S02" )
        export FILE_XCHNGR_MC="s02-prd-clr-m02"
        export FILE_XCHNGR_MC_USERNAME="filemgr"
        export FILE_XCHNGR_MC_PASSWORD="\$u3_veRe"

        export FILE_XCHNGR_VS="s02-prd-clr-m02"
        export FILE_XCHNGR_VS_USERNAME="filemgr"
        export FILE_XCHNGR_VS_PASSWORD="\$u3_veRe"
        ;;
    "DC2" )
        # Ashburn
        ;;
    "DC3" )
        # Las Vegas
        ;;
    *)
        echo "The machine does not corform to SITE naming conventions"
        echo "The first three characters should determine the data center"
        exit 1
        ;;
esac

################################################################
# DB Logons
################################################################
export ATH_DB_USERNAME="teihost"
export ATH_DB_PASSWORD="quikdraw"
export IST_DB_USERNAME="masclr"
export IST_DB_PASSWORD="masclr"
export PORT_RO_USERNAME="port_ro"
export PORT_RO_PASSWORD="port_ro"

################################################################
# DB Settings for Processing
################################################################
case $SITE in
    "S01" )
        export ATH_DB="auth3"
        export CORE_DB="clear3"
        export IST_DB="clear3"
        export TSP4_DB="auth3"

        export PORT_RO_DB="clear3"

        export CLR4_DB="clear3"
        export REPORT_ATH_DB="auth3"
        export RPT_DB="auth3"
        export SEC_DB="clear3"

        ;;
    "S02" )
        export ATH_DB="auth2"
        export CORE_DB="clear2"
        export IST_DB="clear2"
        export TSP4_DB="auth2"

        export PORT_RO_DB="clear2"

        export CLR4_DB="clear2"
        export REPORT_ATH_DB="auth2"
        export RPT_DB="auth2"
        export SEC_DB="clear2"

        ;;
    "DC2" )
        # Ashburn
        ;;
    "DC3" )
        # Las Vegas
        ;;
    *)
        echo "The machine does not corform to SITE naming conventions"
        echo "The first three characters should determine the data center"
        exit 1
        ;;
esac

################################################################
# DB Settings for QA
################################################################
#export ATH_DB="authqa"
#export CORE_DB="authqa"
#export IST_DB="authqa"
#export TSP4_DB="authqa"


################################################################
# Disaster Recovery DB Settings for Processing
################################################################
#export ATH_DB="auth2"
#export CORE_DB="clear2"
#export IST_DB="clear2"
#export TSP4_DB="auth2"

################################################################
# Normal DB Settings for Reporting
################################################################
#export CLR4_DB="authqa"
#export REPORT_ATH_DB="authqa"
#export RPT_DB="authqa"
#export SEC_DB="authqa"

#export CLR4_DB="clear2"
#export REPORT_ATH_DB="auth2"
#export RPT_DB="auth2"
#export SEC_DB="clear2"


################################################################
# Disaster Recovery DB Settings for Reporting
################################################################
#export CLR4_DB="clear1"
#export REPORT_ATH_DB="auth3"
#export RPT_DB="auth3"
#export SEC_DB="clear1"

################################################################
# Email Environmental Variables
################################################################
export ALERT_EMAIL="clearing@jetpay.com,assist@jetpay.com"
export ALERT_NOTIFICATION="clearing@jetpay.com"

export MAIL_TO="clearing@jetpay.com,assist@jetpay.com"
export MAIL_FROM="clearing@jetpay.com"

export ml2_alerts="Alerts-clearing@jetpay.com"
export ml2_assist="assist@jetpay.com"
export ml2_clearing="clearing@jetpay.com"
export ml2_clearing_np="clearing-np@jetpay.com"
export ml2_notify="notifications-clearing@jetpay.com"
export ml2_readme="Readme-clearing@jetpay.com"
export ml2_reports="reports-clearing@jetpay.com"

export statement_runner="reports-clearing@jetpay.com"

################################################################
# Email Environmental Variables
################################################################
export CORE_DB_PASSWORD=jetpay
export CORE_DB_USERNAME=core
export CORE_DB=clear1

echo "---------------------------"
echo "  FILEMGR Profile Loaded   "
echo "      PROD MAS SYSTEM      "
echo "                           "
echo "        SunOS 5.11         "
echo "        Oracle 11g         "
echo "                           "
echo "---------------------------"



# site specific template
case $SITE in
    "S01" )
        ;;
    "S02" )
        ;;
    "DC2" )
        # Ashburn
        ;;
    "DC3" )
        # Las Vegas
        ;;
    *)
        echo "The machine does not corform to SITE naming conventions"
        echo "The first three characters should determine the data center"
        exit 1
        ;;
esac
