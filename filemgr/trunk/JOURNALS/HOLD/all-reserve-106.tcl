#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

#$Id: all-reserve.tcl 1739 2012-05-16 19:20:37Z ajohn $

##
#								Usage: all-reserve.tcl \[-D yyyymmdd\]"
#
#								eg. all-ach-statement.tcl 
#									all-ach-statement.tcl -D 20120421
###

#===============================================================================
#                           MODIFICATION HISTORY
#===============================================================================
# Version G2.2 Sunny Yang 04-06-2010
# -------- WJS is out of business, so for now, delay on reserve is  no longer
# -------- needed.
#
# Version G2.1 Sunny Yang 03-19-2010
# -------- Performance tuning
#
# Version G2.0 Sunny Yang 03-19-2010
# -------- Based on all-reserve.tcl-newreserve, which excluded out the delayed 
# -------- reserves.
# -------- Rewrite for better performance.
#
# Version G1.02 Sunny Yang 09-16-2009
# ------- Updated for the situation Rolling Reserve merchant switch to regular
# ------- reserve merchant
# ------- Add back Tammy and Kelly on email list
#
## Version GL1.00 Sunny Yang 07-22-2009
## -------- This copy will run for all insitutions
##
# Version 2.01 Sunny Yang 06-18-2009
# -------- Add in Rolling Reserve paying out.
# -------- Performance tune up
# -------- Add in ability to report on previous dates
##
## Version 2.00 Sunny Yang 05-13-2008
## -------- Added inst 105
## -------- pull complete list of ISO for inst107. The previous version does not
## -------- pull any 107 ISO out
## -------- Currently, this script will only run for inst 105. need uncomment  script
## -------- when global run is available

## Version 1.0 Myke Sanders ?????

#===============================================================================
#                            ENVIRONMENT VERIABLES
#===============================================================================
#set box $env(SYS_BOX)
#set clrpath $env(CLR_OSITE_ROOT)
#set maspath $env(MAS_OSITE_ROOT)
#set mailtolist $env(MAIL_TO)
#set mailfromlist $env(MAIL_FROM)
#set NON_PRIORITY_EMAIL_LIST $env(ml2_clearing_np)

set clrdb $env(CLR4_DB)
#set clrdb trnclr4

#===============================================================================
#                                   USAGE
#===============================================================================
## 1. take arguments
## 2. mode
     #set mode "TEST"
     set mode "PROD"
#===============================================================================

proc arg_parse {} {
    global argv institutions_arg date_arg

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }

    #scan for Institutions
    #set institutions_arg ""
    #set numInst 0
    #set numInst [regexp -all -- {[-i -I][ ]+([0-9]{3})} $argv]
    
	#if { $numInst > 0 } {
	#
	# 	set res_lst [regexp -all -inline -- {[-i -I][ ]+([0-9]{3})} $argv]
	# 	
	# 	for {set x 0} {$x<$numInst} {incr x} {
	# 		set institutions_arg "$institutions_arg [lrange $res_lst [expr ($x * 2) + 1] [expr ($x * 2) + 1]]"
	# 	}
	#	
	#	set institutions_arg [string trim $institutions_arg]
	#	puts "Institutions: $institutions_arg"
	#}
}

proc init_dates {val} {
	global date fdate filedate today tomorrow CUR_JULIAN_DATEX
	set date    [string toupper [clock format [clock scan "$val"] -format %d-%b-%y]] 
	set fdate     [string toupper [clock format [clock scan " $date -0 day"] -format %b-%y]]     ;# MAR-08
	set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m%d]                     ;# 20080321
	set today     [string toupper [clock format [clock scan " $date +0 day"] -format %d-%b-%y]]
	set tomorrow  [string toupper [clock format [clock scan " $date +1 day"] -format %d-%b-%y]]
	set CUR_JULIAN_DATEX [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
}

#set fail_msg "merric-reserve.tcl failed to run"
package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
  #exec echo $fail_msg | mailx -r mailfromlist -s $fail_msg $mailtolist
  exit
}

set fetch_cursor1 [oraopen $handler]
set fetch_cursor2 [oraopen $handler]

proc run_report {value} {
	global fetch_cursor1 fetch_cursor2 cur_file
	global today tomorrow date CUR_JULIAN_DATEX filedate

	set entlist ""
	set qry_instit ""

	if {[llength $value] > 1} {
		set valDesc "ROLLUP"
		foreach x $value {
			set qry_instit "$qry_instit '$x',"
		}		
	} else {
		set valDesc $value
		set qry_instit "'$value'"
	}

	set qry_instit [string trimright $qry_instit ,]
	
	puts $cur_file "ISO: $valDesc"
	puts $cur_file "RESERVE REPORT"
	puts $cur_file "Date:,$date\n"
	puts $cur_file ",Merchant ID, Merchant Name,Status Code, Contract Date,Pay Status,Reserve,CBR Rate\n"
 
	set entity_str "select unique ae.institution_id,
                                      ae.entity_id,
                                      ae.rsrv_percentage,
                                      ae.parent_entity_id,
                                      ae.entity_dba_name,
                                      ae.creation_date,
                                      ae.rsrv_fund_status,
                                      substr(aea.user_defined_1,1,7) as flag,
                                      ae.entity_status
                        from acq_entity ae, acq_entity_add_on aea
                        where ae.entity_id = aea.entity_id
                          and substr(aea.user_defined_1,1,7) in ('ROLLING','RESERVE')
                          and ae.institution_id in ($qry_instit)
                        order by ae.institution_id, ae.entity_id"
	puts $entity_str
	orasql $fetch_cursor1 $entity_str
	while {[orafetch $fetch_cursor1 -dataarray s -indexbyname] != 1403} {

		set ent $s(ENTITY_ID)
		lappend sql_entlist '$s(ENTITY_ID)',
		lappend entlist $s(ENTITY_ID)
	
		#lappend entlist($value) $s(ENTITY_ID), 
		#lappend entlist(roll) $s(ENTITY_ID), 

		set NAME($ent) $s(ENTITY_DBA_NAME)
		set CONTRACT_DATE($ent) $s(CREATION_DATE)
		set STATUS_CODE($ent) $s(RSRV_FUND_STATUS)
		set CBR_RATE($ent) $s(RSRV_PERCENTAGE)
		set PARENT($ent) $s(PARENT_ENTITY_ID)

		if {$s(ENTITY_STATUS) == "A"} {
			if {$STATUS_CODE($ent) != "F"} {
				set PAY_STATUS($ent) ACTIVE
			} else {
				set PAY_STATUS($ent) FULFILLED
			}
		} else {
              set PAY_STATUS($ent) INACTIVE
		}
	}
      
	if {[string length $entlist] == "0"} {
		puts "Nothing to do for $valDesc - $qry_instit"
		puts $cur_file "\n"
		return
	}

	set sql_entlist		[string trimright $sql_entlist ,]
      
	set detail_str "select mtl.entity_id, 
				sum(CASE WHEN( mtl.tid_settl_method = 'C' ) then mtl.AMT_ORIGINAL else 0 end) as RELEASE_C,
				sum(CASE WHEN( mtl.tid_settl_method <> 'C' ) then -1*mtl.AMT_ORIGINAL else 0 end) as RELEASE_D
				from mas_trans_log mtl
				where (mtl.institution_id, mtl.payment_seq_nbr) in ( 
											select institution_id, payment_seq_nbr
											from acct_accum_det 
											where (institution_id, entity_acct_id) in (select institution_id, entity_acct_id
																	from entity_acct
																   where OWNER_ENTITY_ID in ($sql_entlist)
																	 and acct_posting_type = 'R')
											and (payment_status is null or payment_status='C' or (payment_status='P' and trunc(payment_proc_dt)  > '$today')))
				and mtl.gl_date < '$tomorrow'
				and mtl.tid in ('010007050000')
				and mtl.ENTITY_ID in ($sql_entlist)
				group by mtl.entity_id"
				
	puts  $detail_str       
	orasql $fetch_cursor2 $detail_str
	while {[orafetch $fetch_cursor2 -dataarray amt -indexbyname] != 1403} {
		set MID $amt(ENTITY_ID)
		set RESERVE($MID) [expr $amt(RELEASE_C) + $amt(RELEASE_D)]
		puts "RESERVE($MID): $RESERVE($MID)"
	}
	
	set cnt 0

	foreach eid $entlist {

		set eid [string trimright $eid ,]
		if {![info exists RESERVE($eid)]} {
			set RESERVE($eid) 0 
		}

		if {$RESERVE($eid) != 0} {
			incr cnt
			puts $cur_file "$PARENT($eid),$eid,$NAME($eid),$STATUS_CODE($eid),$CONTRACT_DATE($eid),$PAY_STATUS($eid),$RESERVE($eid),$CBR_RATE($eid)"
		}
	}
	
	if {$cnt == 0} {
		puts "Nothing to do for $valDesc - $qry_instit"
		puts $cur_file "\n"
	}
	
	puts $cur_file ""
	puts $cur_file ""
}      

#MAIN

arg_parse

if {![info exists date_arg]} {
	init_dates [clock format [clock scan "-0 day"] -format %d-%b-%Y]
} else {
	init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

if {$mode == "TEST"} {
	set pathprefix "./"
	set file_name "ROLLUP.REPORT.RESERVE.106.$CUR_JULIAN_DATEX.$filedate.TEST.csv"

} elseif { $mode == "PROD" } {
	#if {$value == "'105'"} {
	#	set pathprefix "/clearing/filemgr/JOURNALS/INST_105/UPLOAD/"
	#} else {
		set pathprefix "/clearing/filemgr/JOURNALS/INST_106/UPLOAD/"
	#}

	set file_name "ROLLUP.REPORT.RESERVE.106.$CUR_JULIAN_DATEX.$filedate.001.csv"
}

set cur_file_name	"${pathprefix}$file_name"
set cur_file		[open "$cur_file_name" w]



run_report 106
       
close $cur_file

if {$mode == "TEST"} {
	#exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name $NON_PRIORITY_EMAIL_LIST
       #exec uuencode $cur_file_name $file_name | mailx -r clearing@jetpay.com -s $file_name $NON_PRIORITY_EMAIL_LIST
} elseif {$mode == "PROD"} {
	#exec uuencode $cur_file_name105 $file_name105 | mailx -r clearing@jetpay.com -s $file_name105 clearing@jetpay.com tammy@jetpay.com
	exec uuencode $cur_file_name $file_name | mailx -r reports-clearing@jetpay.com -s $file_name reports-clearing@jetpay.com risk@jetpay.com  
}

oraclose $fetch_cursor1
oraclose $fetch_cursor2
oralogoff $handler


