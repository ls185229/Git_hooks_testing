#!/usr/bin/bash

#$Id: run_all-I-E.sh 1700 2012-03-27 20:48:08Z ajohn $

if [ $# == 0 ]
then

	tclsh all-I-E.tcl 101 &

	tclsh all-I-E.tcl 107 &

	tclsh all-I-E.tcl 112 &

	tclsh all-I-E.tcl 113 &

	tclsh all-I-E.tcl 114 &

	tclsh all-I-E.tcl 115 &

	tclsh all-I-E.tcl 116 &

	tclsh all-I-E.tcl &

else

	tclsh all-I-E.tcl 101 $1 &

	tclsh all-I-E.tcl 107 $1 &

	tclsh all-I-E.tcl 112 $1 &

	tclsh all-I-E.tcl 113 $1 &

	tclsh all-I-E.tcl 114 $1 &

	tclsh all-I-E.tcl 115 $1 &

	tclsh all-I-E.tcl 116 $1 &

	tclsh all-I-E.tcl $1 &

fi

