#!/usr/bin/bash

# This runs the .tcl scripts for Merrick Reject and Returns
# Delay - Payables, and Reserve Reports.

if [ $# == 0 ]
then
	
	nohup tclsh all-delay-statement.tcl &
	
	nohup tclsh all-reserve.tcl &
	
else

	nohup tclsh all-delay-statement.tcl $1	&
	
	nohup tclsh all-reserve.tcl $1 &
	
fi
