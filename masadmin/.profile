#!/usr/bin/ksh

export PS1="\$PWD>
$LOGNAME@`uname -n`$ "

MAIL=/usr/mail/${LOGNAME:?}
HOME=/clearing/masadmin

### Set up oracle environment ###

export DBDIR="dbm.oci"
export ORACLE_TERM=vt220
export ORAENV_ASK=NO
export ORACLE_BASE=/home/oracle
export ORACLE_HOME=/home/oracle/product/10.2.0
export ORACLE_SID=trnclr1
export TWO_TASK=trnclr1
export JAVA_HOME=/usr/java

export PATH=$PATH:/opt/SUNWspro/bin:/usr/ucb:/usr/local/bin:/usr/openwin/bin:/usr/ccs/bin:/usr/lib:/usr/ccs/lib:/usr/bin:/opt/SUNWspro/bin:$ORACLE_HOME/bin:$ORACLE_HOME/lib:/clearing/masadmin:/usr/local/bin::$JAVA_HOME/bin:$JAVA_HOME/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib32:$ORACLE_HOME/network/lib
export MANPATH=/usr/man:/usr/bin/man:/usr/share/man:/usr/dt/man:/Osrc/tools/man:/usr/local/man

PYATHDEV=
OS=SOL
ARCH=sparc
OS_REV=5.10
MACHINE=_${OS}${OS_REV}_${ARCH}
A=$MACHINE ; export A
export OS
export OS_REV
export ARCH
export MACHINE
export MANPATH=$MANPATH
export PATHDEV

EDITOR=vi
export EDITOR

# Add the following entry
PREFIXDIR=$OPRODUCT_ROOT
export PREFIXDIR

# For MAS Server add the following
TVSRepositoryName=$OSITE_ROOT/cfg/TVSRepository
export TVSRepositoryName

# Add the following UA entry
UA_BASE=$OSITE_ROOT/ua
export UA_BASE

# Optional Entries - useful for shortcuts to various directories.
alias pdir='cd $OPRODUCT_ROOT'
alias site='cd $OSITE_ROOT'
alias cfg='cd $OSITE_ROOT/cfg'
alias data='cd $OSITE_ROOT/data'
alias debug='cd $OLOGDIR/debug'
alias dbutil='cd $OSITE_ROOT/dbutil'
alias jgui='cd $OPRODUCT_ROOT/javagui'

. ./profile20070119
