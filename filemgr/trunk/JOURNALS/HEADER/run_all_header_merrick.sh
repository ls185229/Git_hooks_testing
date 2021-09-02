#!/usr/bin/bash

# $Id: run_all_header_merrick.sh 2301 2013-05-16 18:52:30Z mitra $

if [ $# == 0 ]
then

	tclsh all-header-merrick.tcl 101 &

	tclsh all-header-merrick.tcl 107 &

	tclsh all-header-merrick.tcl 112 &

	tclsh all-header-merrick.tcl &

else

	tclsh all-header-merrick.tcl 101 $1 &

	tclsh all-header-merrick.tcl 107 $1 &

        tclsh all-header-merrick.tcl $1 &

fi
  
