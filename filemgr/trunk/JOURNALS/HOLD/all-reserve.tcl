#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: all-reserve.tcl 2822 2015-03-18 16:35:09Z mitra $
# $Rev: 2822 $
################################################################################
#
# File Name:  template.tcl
#
# Description:  This program generates a reserve report by institution.
#              
# Script Arguments:  -D = Run date (e.g., YYYYMMDD).  Optional.  
#                         Defaults to current date.
#
# Output:  Reserve report by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

#===============================================================================
#                            ENVIRONMENT VERIABLES
#===============================================================================
#set box $env(SYS_BOX)
#set clrpath $env(CLR_OSITE_ROOT)
#set maspath $env(MAS_OSITE_ROOT)
#set mailtolist $env(MAIL_TO)
#set mailfromlist $env(MAIL_FROM)
#set NON_PRIORITY_EMAIL_LIST $env(ml2_clearing_np)

#set clrdb $env(CLR4_DB)
set clrdb $env(IST_DB)
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
}

proc init_dates {val} {
	global date fdate filedate today tomorrow CUR_JULIAN_DATEX
	set date      [string toupper [clock format [clock scan "$val"] -format %d-%b-%y]] 
	set fdate     [string toupper [clock format [clock scan " $date -0 day"] -format %b-%y]]     ;# MAR-08
	set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m%d]                   ;# 20080321
	set today     [string toupper [clock format [clock scan " $date +0 day"] -format %d-%b-%y]]
	set tomorrow  [string toupper [clock format [clock scan " $date +1 day"] -format %d-%b-%y]]
	set CUR_JULIAN_DATEX [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
}


package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
     exec echo "all-reserve.tcl failed to run" | mutt -s "$box: all-reserve.tcl failed to run" $mailtolist
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
		set valDesc "ROLLUP $value"
		foreach x $value {
		set qry_instit "$qry_instit '$x',"
		}		
	} else {
		set valDesc $value
		set qry_instit "'$value'"
	}

	set qry_instit [string trimright $qry_instit ,]
	
	puts $cur_file "INSTITUTION:, $valDesc"
	puts $cur_file "RESERVE REPORT"
	puts $cur_file "Date:,$date\n"
	puts $cur_file ",Parent Merchant ID, Merchant ID, Merchant Name,Status Code, Contract Date,Pay Status,Reserve,CBR Rate\n"
 
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

	set sql_entlist	[string trimright $sql_entlist ,]
      
	set detail_str "
            select mtl.entity_id, 
	           sum(CASE WHEN( mtl.tid_settl_method = 'C' ) then mtl.AMT_ORIGINAL else 0 end) as RELEASE_C,
		   sum(CASE WHEN( mtl.tid_settl_method <> 'C' ) then -1*mtl.AMT_ORIGINAL else 0 end) as RELEASE_D
	    from mas_trans_log mtl
	    where (mtl.institution_id, mtl.payment_seq_nbr) 
                   in (select institution_id, payment_seq_nbr
		       from acct_accum_det 
		       where (institution_id, entity_acct_id) 
                              in (select institution_id, entity_acct_id
                                  from entity_acct 
                                  where OWNER_ENTITY_ID in ($sql_entlist) 
                                     and acct_posting_type = 'R')
				     and (payment_status is null or payment_status='C' or 
                                         (payment_status='P' and trunc(payment_proc_dt) > '$today')))
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
	       puts $cur_file ",$PARENT($eid),$eid,$NAME($eid),$STATUS_CODE($eid),$CONTRACT_DATE($eid),\
                               $PAY_STATUS($eid),$RESERVE($eid),$CBR_RATE($eid)"
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
     set file_name "ROLLUP.REPORT.RESERVE.$CUR_JULIAN_DATEX.$filedate.TEST.csv"

} elseif { $mode == "PROD" } {
#    set pathprefix "/clearing/filemgr/JOURNALS/ROLLUP/UPLOAD/"
     set pathprefix "/clearing/filemgr/JOURNALS/ROLLUP/ARCHIVE/"
     set file_name "ROLLUP.REPORT.RESERVE.$CUR_JULIAN_DATEX.$filedate.001.csv"
}

set mail_err "clearing@jetpay.com"
set mail_to  "Reports-clearing@jetpay.com,risk@jetpay.com"

set cur_file_name	"${pathprefix}$file_name"
set cur_file		[open "$cur_file_name" w]

run_report 101
run_report 105
run_report 107
run_report 121
run_report {101 107}
run_report {105 117}
     
close $cur_file

if {$mode == "TEST"} {
    exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" -- "$mail_err" 
} elseif {$mode == "PROD"} {
    exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" -- "$mail_to"
}

oraclose $fetch_cursor1
oraclose $fetch_cursor2
oralogoff $handler


