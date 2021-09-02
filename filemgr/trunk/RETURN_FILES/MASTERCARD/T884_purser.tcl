#!/usr/bin/env tclsh
#
# Version 36.0 Rifat Khan 
#
# Code pulls Mas Counting file data an parses it.
#
# Version 37.0 Rifat Khan 04/27/06
# Changes made to Mas Couning file to reduce lenght of trans_ref_data to 23 bytes.


# Global Variable
set LINE_SIZE 168.0

package require Oratcl
#package require Mpexpr


# Transaction Detail
set TCR(01) {
	brand_id a 3 {Acceptance Brand or Financial network}
	bus_ser a 1 {Business Service Arrangement Type}
	bus_ser_id a 6 {Business Service ID Code}
	ird a 2 {Original IRD}
	bus_date a 6 {Clearing Systems Processing Date. Format: YYMMDD}
	bus_cycle a 2 {Represents the Clearing Cycle}
	member_id a 11 {Acquirer's MasterCard Member Identification Number}
	pri_acct_num a 16 {Card used for this Transaction}
	filler a 3 {filler}
	mcc a 4 {MCC}
	app_cd a 6 {Approval Code. (auth code)}
	auth_trans_date a 5 {Authorization Date. Format: YYDDD, DDD - Julian date}
	auth_trans_time a 6 {Authorization Time. Format: HHMMSS}
	trans_amt n 12 {Clearing Transaction Amount}
	auth_trans_amt n 12 {Authorization Transaction Amount}
	trans_sett_dt a 6 {Clearing Time. Format: HHMMSS}
	filler a 76 {filler}
	arn a 23 {Acquirer Reference Number ARN}
	ia_fee n 8 {Intrechange Fee Amount}
	new_ia_fee n 8 {New Interchange Fee Amount} 
	ird a 2 {Interchange Rate Designator IRD}
	adj_ia_fee n 8 {Difference between the new and submitted Interchange fee Amount}
	ca_nm a 22 {Card Acceptor Name}
	ca_city a 13 {Card Acceptor City}
	ca_st_pv a 3 {Card Acceptor State, Province or Region (Clearing)}
	ca_cntry_cd a 3 {Card Acceptor Country Code}
	ca_id a 15 {Card Acceptor Id}
	ca_ter_id a 8 {Card Acceptor Terminal Id}
	new_ird a 2 {New IRD}
	banknet_ref_num a 9 {Assigned by the MasterCard Authorization System (MIP)}
	banknet_dt a 4 {Date of Transmission. Format: MMDD}
	adj_resn_cd a 5 {Adjustment Reason Code}
	tmlins_cd a 1 {Result of timeliness test. 0= Failed, 1 = Passed validation}
	msc a 1 {Result of Megnetic stripe code test}
	mcc_tst a 1 {Result of MCC test. 0= Failed, 1 = Passed validation}
	auth_cd_tst a 1 {Result of Authorization Code test. 0= Failed, 1 = Passed validation}
	trans_amt_cd_tst a 1 {Result of Transaction Amount test. 0= Failed, 1 = Passed validation}
	prdct_cls_ovrid a 1 {Product Class Override}
	clr_prdct_typ_cd a 1 {Clearing Product Type Code}
	filler a 18 {Filler}
};# end set TCR(01)


proc parse_tc {tc line_in} {
    global TCR

    foreach {index type length comment} $TCR($tc)  {	
        if {$index == "pri_acct_num"} {
	set value "[string range $line_in 0 3]XXXXXXXX[string range $line_in 12 15]"
	} else {
	set value [string range $line_in 0 [expr $length - 1]]
	}
	puts [format "%-30.30s  >%s<" $comment $value]
        set line_in [string range $line_in $length end]
    }
    puts "\n"
};# end parse_tc



#proc determine_which_57 {line_in}\{
#    set rec_type [string range $line_in 0 1]
#    set tc57 "$rec_type"
#    parse_tc $tc57 $line_in
#};# end determine_which_57



proc determine_rec_type {line_in} {
    set tc_type [string range $line_in 0 1]
    switch $tc_type {
        "FH" {puts "*** File Header ***"}
        "BT" {puts "*** Batch Trailer ***"}
        "FT" {puts "*** File Trailer ***"}
	"BH" {puts "*** Batch Heaher ***"}
	"01" {puts "*** Msg Detail ***"}
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

#while {[set line [read $input_file $LINE_SIZE]] != {} } {
while {[set line [gets $input_file]] != {} } {
    puts "line is [string length $line] long"
    set tc_type [string range $line 0 1]
	if {[string length $line] == 330} {
		parse_tc 01 $line
	   }
}

close $input_file


exit 0
