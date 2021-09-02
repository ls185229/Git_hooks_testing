#!/usr/bin/env tclsh

################################################################################
# $Id: $
# $Rev: $
################################################################################
#
# File Name:  mas_counting_parser_v13.tcl
#
# Description:  This program MAS files.
#              
# Script Arguments:  filename = File to be parsed.  Required.
#
# Output:  Parsed contents of the MAS file.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

# Global Variable
set LINE_SIZE 168.0

package require Oratcl
#package require Mpexpr

# File Header
set TCR(FH) {
    fh_type a 2 {Transaction Type}
    file_type n 2 {File Type}
    file_date n 16 {File Date}
    activity_src a 16 {Activity Source}
    jod_name a 8 {Activity Job Name}
    sus_levl a 1 {Suspend Level}
};# end set TCR(FH)

# 1st Batch Header
set TCR(BH) {
    bh_type a 2 {Transaction Type}
    batch_curr n 3 {Batch Currency Code}
    bh_act_dt n 16 {Batch Activity Date and Time}
    merchantid a 30 {Merchant id}
    inbatchnbr n 9 {Batch Number}
    infilenbr n 9 {File Number}
    billind a 1 {Bill index}
    orig_batch_id n 9 {Original Batch Id}
    orig_file_id n 9 {Original File Id}
    ext_batch_id a 25 {External Batch Id}
    ext_file_id a 25 {External File Id}
    sender_id a 25 {Sender Id}
    microfilmnbr n 30 {Microfilm Number}
    institution_id n 10 {Institution Id}
    batch_capture_dt n 16 {Batch Capture Date}
};# end set TCR(BH)

# Transaction Detail
set TCR(01) {
    msg_type n 2 {Transaction Type}
    trans_id a 12 {Transaction Id}
    entity_id a 18 {Entity Id}
    card_schme n 2 {Card scheme}
    mas_cd a 25 {Mas Code}
    mas_cd_dngd a 25 {Mas Code Downgrade}
    nbr_of_itm n 10 {Number of Items}
    amt_orig n 12 {Original Amount}
    add_cnt1 n 10 {Add Count Number 1}
    add_amt1 n 12 {Add Amount Number 1}
    add_cnt2 n 10 {Add Count Number 2}
    add_amt2 n 12 {Add Amount Number 2}
    ext_tran_id a 25 {External Transaction Id}
    trans_ref_data a 23 {Transaction Reference Data}
    suspend_reason a 2 {Suspend Reason}
};# end set TCR(01)

# Batch Trailer
set TCR(BT) {
    bh_tran n 2 {Transaction Type}
    batchamt n 12 {Batch Amount}
    batchcnt n 10 {Batch Count}
    bct_add_amt1 n 12 {Batch Add Amount 1}
    bct_add_cnt1 n 10 {Batch Add Count 1}
    bct_add_amt2 n 12 {Batch Add Amount 2}
    bct_add_cnt2 n 10 {Batch Add Count 2}
};# end set tct(BT)

# File Trailer
set TCR(FT) {
    fttrans_type n 2 {Transaction Type}
    file_amt n 12 {File Amount}
    file_cnt n 10 {File Count}
    file_add_amt1 n 12 {File Add Amonut 1}
    file_add_cnt1 n 10 {File Add Count 1}
    file_add_amt2 n 12 {File Add Amonut 2}
    file_add_cnt2 n 10 {File Add Count 2}
};# end set TCR(FT)


proc parse_tc {tc line_in} {
    global TCR

    foreach {index type length comment} $TCR($tc)  {	
		set value [string range $line_in 0 [expr $length - 1]]
		puts [format "%-30.30s  >%s<" $comment $value]
        set line_in [string range $line_in $length end]
    }
    puts "\n"
};# end parse_tc


proc determine_rec_type {line_in} {
    set tc_type [string range $line_in 0 1]
    switch $tc_type {
        "FH" 	{puts "*** File Header ***"}
        "BT" 	{puts "*** Batch Trailer ***"}
        "FT" 	{puts "*** File Trailer ***"}
		"BH" 	{puts "*** Batch Heaher ***"}
		"01" 	{puts "*** Msg Detail ***"}
        default {puts "Unknown TC type: $tc_type"}
    }
};# end determine_rec_type


########
# MAIN #
########

set filename "[lindex $argv 0]"
if {$argc != 1} {
    puts "Error invoking script"
    puts "Usage: tc57_parser.tcl filename_to_parser"
    exit 1
}

puts "Opening file <$filename>"

set input_file [open $filename r]

while {[set line [gets $input_file]] != {} } {
    puts "line is [string length $line] long"
    set tc_type [string range $line 0 1]

    determine_rec_type $line

    switch $tc_type {
        "FH"	{ parse_tc $tc_type $line }
        "FT"	{ parse_tc $tc_type $line }
        "BH" 	{ parse_tc $tc_type $line }
        "BT" 	{ parse_tc $tc_type $line }
		"01"	{ parse_tc $tc_type $line }
        default {puts "Unknown TC type: <$tc_type>"}
    }
}

close $input_file

puts "mas_counting_parser_v13.tcl program complete"

exit 0
