#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: cat_merrick.tcl 4054 2017-02-06 23:16:14Z millig $

##
# USAGE:
#       cat_merrick.tcl ?-d YYYYMMDD
# If no date is provided, the script uses the current system date
###


##
# This script searches in the current directory for daily detail 
# files with the given date signature in the file name.
# Once the files are found having the correct signature (date, institution), 
# it is added to the list. Before finally concating the list of files,
# the size of the files are checked to verify that they are complete.
# Also, the list is checked to ensure that all expected intitution files are present.
# The final procedure that must be done before concating the files is to 
# figure out what the index of the rollup should be. This index is added to
# the output filename (eg. ROLLUP.REPORT.DETAIL.2228.20120815.001.csv if it's the first).
###

##
# The folowing defines the expected files that will be concatinated
###
set institutions {101 107 ALL}

set mail_to "reports-clearing@jetpay.com"
set mail_err "clearing@jetpay.com"

proc init_dates {val} {
    global date filedate CUR_JULIAN_DATEX

    set date      [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]]  ;# 21-MAR-08
    set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m%d]                     ;# 20080321
    set CUR_JULIAN_DATEX [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
}

proc arg_parse {} {
    global argv argv0 argc date_arg

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }

    if {![info exists date_arg] && $argc > 0 } {
        puts "Incorrect date format\nUSAGE: $argv0 \[-d YYYYmmdd\]\n"
        exit
    }

}


##
# MAIN
###

arg_parse

if {[info exists date_arg]} {
    init_dates $date_arg
    puts "Concat script running for date: $date"
} else {
    init_dates [clock format [clock seconds] -format %Y%m%d]
    puts "Concat script running for TODAY <$date>"
}

#Search for only files belonging to the given day
set filelist [glob -nocomplain -directory "./" -types f "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.*"]

set cat_lst ""

foreach fl $filelist {

    #Check if this file name matches the pattern we're expecting
    if {[regexp -- "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.((1\[0-9 \]{2})|(ALL))" $fl]>0} {

        #extract institution_id from the file name. Check if it is in our list
        set inst_identifier [lindex [regexp -inline -- "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.((1\[0-9 \]{2})|(ALL))" $fl] 1]

        #If it's one of the institutions belonging to this group, add to list
        if {[lsearch $institutions $inst_identifier] != -1} {
            set cat_lst "$cat_lst [file tail $fl]"
        }
    }
}

if {[llength $cat_lst] > 0} {

    ##
    # lets figure out the index of the rollup
    # we increment the index of the run for the rollup filename
    ################################################################################################
    set FINALS_filelist [glob -nocomplain -directory "./FINALS/" -types f "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.0*"]
    
    #COUNT the number of cat files generated for today in ./FINALS
    set rollup_indx [expr [llength $FINALS_filelist] + 1]
    ################################################################################################


    ##
    # Check the cat list for any files that looks incomplete
    ################################################################################################
    foreach fl $cat_lst {
        puts "$fl - size: [file size $fl]"
        if {[file size $fl] < 200} {
            puts "$fl is not complete. Aborting..."
            eval exec echo "/JOURNALS/DD/$fl size is < 200. Check file size." | mutt -s "Merrick Cat file aborted.." $mail_err
            exit
        }
    }
    ################################################################################################


    ##
    # Check that all expected institution files plus the 'ALL' are present
    ################################################################################################
    foreach inst $institutions {
        if {[lsearch $cat_lst "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.$inst.csv"] == -1} {
            puts "The expected file <ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.$inst.csv> is missing. Aborting..."
            eval exec echo "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.$inst.csv is missing." | mutt -s "Merrick Cat file aborted.." $mail_err
            exit
        }
    }
    ################################################################################################

    set cat_lst [lsort $cat_lst]
    puts "cat'ing the following files: $cat_lst"
    set cat_fname "ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.[format %03.3d $rollup_indx].csv"
    eval exec "cat $cat_lst > $cat_fname"
    puts "\nGenerated filename: $cat_fname"
    
    #email
    eval exec echo "Please see attached.." | mutt -a "$cat_fname" -s "$cat_fname" $mail_to
    
    #Remove all other cat'ed files for today from the UPLOADS dir
    puts "Removing other cat'ed files for today from ../ROLLUP/UPLOADS/:"
    foreach fl $FINALS_filelist {
        puts [file tail $fl]
        eval exec "rm -rf ../ROLLUP/UPLOAD/[file tail $fl]"
    }
    
    eval exec "cp $cat_fname ../ROLLUP/UPLOAD/"
    eval exec "mv $cat_fname ./FINALS/"
    
    foreach inst $institutions {
        eval exec "mv ROLLUP.REPORT.DETAIL.$CUR_JULIAN_DATEX.$filedate.$inst.csv ./SEPARATE/"
    }
}




