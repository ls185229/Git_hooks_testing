#!/usr/bin/bash

#$Id: Merrick_Rejects_Returns_Payables_Reserve.sh 1812 2012-08-20 19:47:12Z ajohn $

# This runs the .tcl scripts for Merrick Reject and Returns
# Delay - Payables, and Reserve Reports.
echo "Merrick Returns/Paybles/Reserve"
echo `date +\%Y\%m\%d\%T`

. /clearing/filemgr/.profile

if [ $# == 0 ]
then
	
	nohup tclsh all-reject-return.tcl &
	
	nohup tclsh all-delay-statement.tcl &
	
	nohup tclsh all-reserve.tcl &
	
else

	nohup tclsh all-reject-return.tcl $1 &
	
	nohup tclsh all-delay-statement.tcl $1	&
	
	nohup tclsh all-reserve.tcl $1 &
	
fi
