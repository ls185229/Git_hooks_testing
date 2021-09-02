#!/usr/bin/env tclsh

################################################################################
# $Id: discover_ari.tcl 2690 2014-08-29 21:08:16Z mitra $
# $Rev: 2690 $
################################################################################
# Description:  This program parses through the incoming Discover reports 
#               for different bins
#
# Script Arguments:  logdate = Report date.  Required.
#                    Default = Today's date
#
# Output:  Reports by Bin.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

set mode "PROD"
#set mode "TEST"

proc load_config {src} {
    global banks
    
    set cfg_file [open $src r]
    fconfigure $cfg_file -buffering line
    set line_rd ""
    
    while {[gets $cfg_file line_rd]} {
        if { [string range $line_rd 0 0]!="#"} {
            
            set bank_cnfig [split $line_rd {,}]

            if {[llength $bank_cnfig] > 0} {
                if {[llength $bank_cnfig] == 5} {
                    foreach cfg_data $bank_cnfig {
                        lappend banks [string trim $cfg_data]
                    }
                    
                } else {
                    puts "Error. Wrong number of fields. Config line is corrupted: $line_rd"
                }
            }
        }
    }
}

proc parse_Destination_HDr_Rec {rec} {
    global file_processingDT

    set file_processingDT [string range $rec 1 8 ]
}

proc parse_File_HDr_Rec {rec} {
    global acquirers dict_acquirer gbl_state activity_ending_dt

    set activity_ending_dt [string toupper [clock format [clock scan "[string range $rec 1 8]" -format %Y%m%d] -format %b-%d-%y]]
    set curr_acq [ string trimleft [string range $rec 17 27] 0]
    set gbl_state(current_acq) $curr_acq
    
    dict set dict_acquirer $curr_acq name [string range $rec 28 67]

    set acquirers "$acquirers $curr_acq"
    upvar \#0 ${curr_acq} acq
    set acq(name) [string range $rec 28 67]
}

proc parse_Section_rec {rec} {
    switch -exact [string range $rec 1 2 ] {
        01  { parse_Settle_Summary $rec }
    }
}

proc parse_Settle_Summary {rec} {
    global dict_acquirer gbl_state
    set count 0
    #set amt 0
    
    #Looking for: 50<1> - Settlement Summary
    if {[string range $rec 3 3] == 1} {

        ##
        # Get activity type
        # -------------------------------
        # Card Transactions
        # Disputes
        # Acquirer Interchange Assessed
        # Cash Reimbursement
        # Acquirer Assessments
        # Acquirer Fees
        # Corrections
        # MERCHANT FUNDS DISBURSEMENT
        ###
        
        set activityType [string trimright [string range $rec 4 33] " " ]

        #limit trim in case the value is 0
        set count [string range $rec 34 44]
        set count "[string trimleft [string range $count 0 end-1] 0][string range $count end end]"

        set amt [string range $rec 45 59]
        set amt "[string trimleft [string range $amt 0 end-1] 0][string range $amt end end]"
        set amt [cobol_value_convert $amt]

        dict set dict_acquirer $gbl_state(current_acq) "ACTIVITY_TYPE" $activityType "$count [format "%.2f" $amt]"
    }
}

proc cobol_value_convert {value} {
    set PNIND [string range $value end end]
    
    switch -exact $PNIND {
        "\{"    {return format "%0.2f" [expr "[string range $value 0 end-1]0" / 100.00]}
        "A"     {return format "%0.2f" [expr "[string range $value 0 end-1]1" / 100.00]}
        "B"     {return format "%0.2f" [expr "[string range $value 0 end-1]2" / 100.00]}
        "C"     {return format "%0.2f" [expr "[string range $value 0 end-1]3" / 100.00]}
        "D"     {return format "%0.2f" [expr "[string range $value 0 end-1]4" / 100.00]}
        "E"     {return format "%0.2f" [expr "[string range $value 0 end-1]5" / 100.00]}
        "F"     {return format "%0.2f" [expr "[string range $value 0 end-1]6" / 100.00]}
        "G"     {return format "%0.2f" [expr "[string range $value 0 end-1]7" / 100.00]}
        "H"     {return format "%0.2f" [expr "[string range $value 0 end-1]8" / 100.00]}
        "I"     {return format "%0.2f" [expr "[string range $value 0 end-1]9" / 100.00]}

        "\}"    {return format "%0.2f" [expr "[string range $value 0 end-1]0" / -100.00]}
        "J"     {return format "%0.2f" [expr "[string range $value 0 end-1]1" / -100.00]}
        "K"     {return format "%0.2f" [expr "[string range $value 0 end-1]2" / -100.00]}
        "L"     {return format "%0.2f" [expr "[string range $value 0 end-1]3" / -100.00]}
        "M"     {return format "%0.2f" [expr "[string range $value 0 end-1]4" / -100.00]}
        "N"     {return format "%0.2f" [expr "[string range $value 0 end-1]5" / -100.00]}
        "O"     {return format "%0.2f" [expr "[string range $value 0 end-1]6" / -100.00]}
        "P"     {return format "%0.2f" [expr "[string range $value 0 end-1]7" / -100.00]}
        "Q"     {return format "%0.2f" [expr "[string range $value 0 end-1]8" / -100.00]}
        "R"     {return format "%0.2f" [expr "[string range $value 0 end-1]9" / -100.00]}
        default {puts "ERROR!! Bad value passed to cobol converter: $value"}
    }
}

########
# MAIN
########

set home "/clearing/filemgr"
set mail_to  "reports-clearing@jetpay.com"
set mail_err "clearing@jetpay.com"

if {$mode == "PROD"} {
    set inpath "$home/RETURN_FILES/DISCOVER/DNLOAD/"
    set apath  "$home/RETURN_FILES/DISCOVER/ARCHIVE/"
    set cnfig_source "./CONFIG/ari_config.tc"
} else {
    set inpath "./DNLOAD/"
    set apath "./ARCHIVE/"
    set cnfig_source "./CONFIG/ari_test_config.tc"
}

###
# Search for files matching the file for the given day
###

set ari_infiles ""
set ari_infiles [glob -nocomplain ${inpath}INDS.NERSARI8.[clock format [clock seconds] -format %Y%m%d]*]

if {$ari_infiles == ""} {
    puts "$argv0 did not find the input file matching: ${inpath}INDS.NERSARI8.[clock format [clock seconds] -format %Y%m%d]*"
    exec echo "$argv0 could not find today's INDS.NERSARI8 file." | mutt -s "$argv0 - File not found" -- $mail_err
    exit 1
}

###
# Normally, there should only be one file. But just in case, we choose
# the file with the highest sequence number by sorting the filelist
###

set ari_infiles [lsort $ari_infiles]

foreach fl $ari_infiles {
    puts $fl
    set infile_name $fl
}


###
# Use a regex to parse the date from the filename
###

if { [regexp -- {INDS.NERSARI8.([0-9]{14,14}).} $infile_name dummy1 parsed_infile_dt] } {
      puts "Date parsed from infile name: $parsed_infile_dt"
} else {
      puts "Error parsing date from infile.. $argv0 did not find an input file matching format: INDS.NERSARI8.([0-9]{14,14}).###"
      exit 1
}

###
# Load the config file
###

load_config "$cnfig_source"

set acquirers ""
set rpt_date  [string toupper [clock format [ clock scan "-0 day " ] -format %b-%d-%y ]]
set inFile [open $infile_name r]
fconfigure $inFile -buffering line
set record ""

while {[gets $inFile record]} {
    switch -exact [string range $record 0 0] {
        1   { parse_Destination_HDr_Rec $record }
        2   { parse_File_HDr_Rec $record }
        5   { parse_Section_rec $record }
        8   {  }
        9   { break }
        default {}
    }
}

##
# Go through the banks declared in the config file
# Generate each file with whatever data we got for their bins
# The filename scheme and upload path
# for each is also in the config file
###

foreach {Iso bins up_path archive_path gen_filenm} $banks {
    
    set shortname [string map "yyyymmddHHMMSS $parsed_infile_dt" $gen_filenm]
    set filename "$up_path$shortname"
    set cur_file [open "$filename" w]

    puts $cur_file "DISCOVER NETWORK"
    puts $cur_file "ACQUIRER DAILY SUMMARY REPORT"
    puts $cur_file " "
    puts $cur_file "PROGRAM NAME:,NERSARI8"
    puts $cur_file "SYSTEM DATE:,$rpt_date"
    puts $cur_file "PROCESSING DATE:,$activity_ending_dt"
    puts $cur_file " "
    puts $cur_file " "

    foreach acq $bins {
        if {[dict exists $dict_acquirer $acq]} {
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "ACQUIRER ID:,[format %011d $acq]"
            puts $cur_file "ACQUIRER NAME:,[dict get $dict_acquirer $acq name]"
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file ",Card Transaction Count,Card Transaction Volume"
            
            set ntamt 0
            set ntcnt 0
            
            if {[dict exists $dict_acquirer $acq ACTIVITY_TYPE]} {
                dict for {type columns} [dict get $dict_acquirer $acq ACTIVITY_TYPE] {

                    switch -exact $type {
                        "CARD TRANSACTIONS"             {puts $cur_file "Card Sales,           [lindex $columns 0], $[lindex $columns 1] "}
                        "DISPUTES"                      {puts $cur_file "Disputes,             [lindex $columns 0], $[lindex $columns 1] "}
                        "CASH REIMBURSEMENT"            {puts $cur_file "Cash Reimbursement,   [lindex $columns 0], $[lindex $columns 1] "}
                        "ACQUIRER INTERCHANGE ASSESSED" {puts $cur_file "Acquirer Interchange, [lindex $columns 0], $[lindex $columns 1] "}
                        "ACQUIRER ASSESSMENTS"          {puts $cur_file "Acquirer Assessments, [lindex $columns 0], $[lindex $columns 1] "}
                        "ACQUIRER FEES"                 {puts $cur_file "Acquirer Fees,        [lindex $columns 0], $[lindex $columns 1] "}
                        "CORRECTIONS"                   {puts $cur_file "Miscellaneous,        [lindex $columns 0], $[lindex $columns 1] "}
                        "MERCHANT FUNDS DISBURSEMENT"   {puts $cur_file "Funds Disbursement,   [lindex $columns 0], $[lindex $columns 1] "}
                    }
                    
                    set ntcnt [expr $ntcnt + [lindex $columns 0]]
                    set ntamt [expr $ntamt + [lindex $columns 1]]
                }
            }
            puts $cur_file " "
            puts $cur_file " "
            puts $cur_file "TOTAL NET SETTLEMENT, $ntcnt,$$ntamt"
            puts $cur_file " "
            puts $cur_file " "
        }
    }
    
    close $cur_file
    if {$mode == "PROD"} {
        exec echo "" | mutt -a $filename -s "$shortname" -- $mail_to
    } else {
        exec echo "" | mutt -a $filename -s "$shortname" -- $mail_err
    }
}

close $inFile
exec mv $infile_name $apath





