#!/usr/bin/env tclsh

################################################################################
# $Id: all-delay-statement.tcl 2822 2015-03-18 16:35:09Z mitra $
# $Rev: 2822 $
################################################################################
#
# File Name:  all-delay-statement.tcl
#
# Description:  This program generates delayed funding reports by institution.
#              
# Script Arguments:  institution_num = Instution ID (ALL or individual 
#                                      institution.  Required
#                    dt = Run date (e.g., YYYYMMDD).  Optional.  
#                         Defaults to current date.
#
# Output:  Delayed funding reports by institution.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

#set clrdb $env(CLR4_DB)
set clrdb $env(IST_DB)

package require Oratcl

if {[catch {set handler [oralogon masclr/masclr@$clrdb ]} result]} {
     exec echo "all-delay-statement.tcl failed to run" | mutt -s "$box: all-delay-statement.tcl failed to run" $mailtolist
     puts "Error encountered on database logon"
     exit 1
}

set fetch_cursor1  [oraopen $handler]
set fetch_cursor2  [oraopen $handler]

proc report {value} {
	global fetch_cursor1 fetch_cursor2
	global date CUR_JULIAN_DATEX file_name_date first_set_day 
	
	#----------------Format Institutions Args-------------
	set sql_inst_args ""
	foreach x $value {
		set sql_inst_args "${sql_inst_args}'${x}',"
	}
	set sql_inst_args [string trimright $sql_inst_args ", "]
	#------------------------------------------------
	
	
	set SETTLED_BC 0
	set SETTLED_NONBC 0
	set CHARGEBACK_AMOUNT 0
	set REJECTS 0
	set REFUNDS 0
	set SALE_REVERSALS 0
	set MISC_ADJUSTMENTS 0
	set ACH_RESUB 0
	set RESERVES 0
	set DISCOUNT 0
	set NETDEPOSIT 0

	set GRAND_NON_C 0
	set GRAND_NON_D 0
	set GRAND_BCC   0
	set GRAND_BCD   0
	set GRAND_SETTLED_BC 0
	set GRAND_SETTLED_NONBC 0
	set GRAND_CHARGEBACK_AMOUNT 0
	set GRAND_REJECTS 0
	set GRAND_REFUNDS 0
	set GRAND_SALE_REVERSALS 0
	set GRAND_MISC_ADJUSTMENTS 0
	set GRAND_ACH_RESUB 0
	set GRAND_RESERVES 0
	set GRAND_DISCOUNT 0
	set GRAND_NETDEPOSIT 0
	set SUB_SETTLED_BC 0
	set SUB_SETTLED_NONBC 0
	set SUB_CHARGEBACK_AMOUNT 0
	set SUB_REJECTS 0
	set SUB_REFUNDS 0
	set SUB_SALE_REVERSALS 0
	set SUB_MISC_ADJUSTMENTS 0
	set SUB_ACH_RESUB 0
	set SUB_RESERVES 0
	set SUB_DISCOUNT 0
	set SUB_NETDEPOSIT 0
	set SUB_CHARGBACK     0

	set dtroll {}
	set eroll()  {}
	
	set ENTITY_ID      0
	set SETTLED_C_BC   0
	set SETTLED_D_BC   0
	
        set mail_to "Reports-clearing@jetpay.com"

#       set rollpath "/clearing/filemgr/JOURNALS/ROLLUP/UPLOAD"
	set rollpath "/clearing/filemgr/JOURNALS/ROLLUP/ARCHIVE"
	#set rollpath "./"
	
	set cur_file_name   "$rollpath/ROLLUP.REPORT.PAYABLES.${CUR_JULIAN_DATEX}.${file_name_date}.001.csv"
	set file_name       "ROLLUP.REPORT.PAYABLES.${CUR_JULIAN_DATEX}.${file_name_date}.001.csv"
	set cur_file        [open "$cur_file_name" w]

	set merinfo "select institution_id, entity_dba_name, parent_entity_id, entity_id 
		     from acq_entity 
		     where institution_id in ($sql_inst_args) 
		     and entity_level = '70'"
                          
	orasql $fetch_cursor2 $merinfo
	
	while {[orafetch $fetch_cursor2 -dataarray mer -indexbyname] != 1403} {
            set dbaname($mer(ENTITY_ID)) $mer(ENTITY_DBA_NAME)
            set peid($mer(ENTITY_ID)) $mer(PARENT_ENTITY_ID)
            set inst($mer(ENTITY_ID)) $mer(INSTITUTION_ID)
	}
      
	set chabk "'010003010102','010003010101','010003015201','010003015102','010003015101','010003015210','010003015301'"
	
	set query_str_cur "
            SELECT m.institution_id, m.date_to_settle, m.entity_id, 
		   SUM(CASE WHEN( m.tid_settl_method = 'C' and card_scheme <> '12') 
                            THEN m.amt_original ELSE 0 END ) AS SETTLED_C_BC, 
		   SUM(CASE WHEN( m.tid_settl_method = 'D' and card_scheme <> '12') 
                            THEN m.amt_original ELSE 0 END ) as SETTLED_D_BC, 
		   SUM(CASE WHEN( m.tid = '010003005102') 
                            THEN m.amt_original*-1 ELSE 0 END ) AS REFUND, 
		   SUM(CASE WHEN( m.tid = '010003005201') 
                            THEN m.amt_original ELSE 0 END ) AS SALES_REVERSAL, 
		   SUM(CASE WHEN( m.tid_settl_method = 'C' and m.tid IN($chabk))  
                            THEN m.amt_original else 0 end ) as CHARGBACK_C, 
		   SUM(CASE WHEN( m.tid_settl_method = 'D' and m.tid IN($chabk))  
                            THEN m.amt_original else 0 end ) as CHARGBACK_D 
	    FROM mas_trans_log m 
	    WHERE (m.tid, settl_plan_id) IN (SELECT unique tid, settl_plan_id 
					     FROM settl_plan_tid 
				    	     WHERE delay_factor0 <> '0' 
					       AND delay_factor1 <> '0' 
					       AND tid not in ('010007050000','010070010000','010070010017') 
					       AND tid not like '010004%' 
					       AND institution_id IN ($sql_inst_args)) 
              AND m.institution_id in ($sql_inst_args) 
              AND m.date_to_settle > '$date' 
              AND m.gl_date < '$first_set_day' 
	    GROUP BY m.institution_id, rollup(m.date_to_settle), rollup( m.entity_id) 
	    ORDER BY m.institution_id, m.date_to_settle"
	
	orasql $fetch_cursor1 $query_str_cur
 	
        while {[orafetch $fetch_cursor1 -dataarray clr -indexbyname] != 1403} {
		set eid	$clr(ENTITY_ID)
		set instid $clr(INSTITUTION_ID)
		set setdt $clr(DATE_TO_SETTLE)
		
		#declare institution array eg. e101()
		if {![info exists [subst e$instid] ]} {
			set "[subst e$instid]()" {}
		}
		
		if {![info exists [subst dt$instid]]} {
			set "[subst dt$instid]" {}
		}
		
		if {[string length $instid] == "3" && [string length $eid] == "15" && [string length $setdt] > "1"} {
                     set eeid($instid.$setdt)            $clr(ENTITY_ID)
                     set enid($instid.$setdt.$eid)       $clr(ENTITY_ID)
                     set refund($instid.$setdt.$eid)     $clr(REFUND)
                     set salerev($instid.$setdt.$eid)    $clr(SALES_REVERSAL)
                     set chgbk($instid.$setdt.$eid)      [expr $clr(CHARGBACK_C) - $clr(CHARGBACK_D)]
                     set set_c_bc($instid.$setdt.$eid)   $clr(SETTLED_C_BC)
                     set set_d_bc($instid.$setdt.$eid)   $clr(SETTLED_D_BC)
                     set netdeposit($instid.$setdt.$eid) [expr $clr(SETTLED_C_BC) - $clr(SETTLED_D_BC)]
                     set set_bc($instid.$setdt.$eid)     [expr ($clr(SETTLED_C_BC) - $clr(SETTLED_D_BC)) - $clr(REFUND) \
                					  + $clr(SALES_REVERSAL) - ($clr(CHARGBACK_C) - $clr(CHARGBACK_D))]
		     lappend "e${instid}($setdt)" $eeid($instid.$setdt)
		     lappend eroll($setdt)  $eeid($instid.$setdt)
		} elseif {[string length $instid] == "3" && [string length $eid] == "0" && [string length $setdt] > "1"} {
		     set subrefund($instid.$setdt)     	$clr(REFUND)
                     set subsalerev($instid.$setdt)    	$clr(SALES_REVERSAL)
                     set subchgbk($instid.$setdt)      	[expr $clr(CHARGBACK_C) - $clr(CHARGBACK_D)]
                     set subset_c_bc($instid.$setdt)   	$clr(SETTLED_C_BC)
                     set subset_d_bc($instid.$setdt)   	$clr(SETTLED_D_BC)
                     set subnetdeposit($instid.$setdt) 	[expr $clr(SETTLED_C_BC) - $clr(SETTLED_D_BC)]
                     set subset_bc($instid.$setdt)	[expr ($clr(SETTLED_C_BC) - $clr(SETTLED_D_BC)) - $clr(REFUND) \
                					 + $clr(SALES_REVERSAL) - ($clr(CHARGBACK_C) - $clr(CHARGBACK_D))]            
                     set [subst dt${instid}] "[subst $[subst dt${instid}]] $setdt"
                     lappend dtroll $setdt
		} elseif {[string length $instid] == "3" && [string length $eid] == "0" && [string length $setdt] == "0"} {
		     set grandrefund($instid)     	$clr(REFUND)
                     #set grandsalerev($instid)    	$clr(SALES_REVERSAL)
                     set grandchgbk($instid)      	[expr $clr(CHARGBACK_C) - $clr(CHARGBACK_D)]
                     #set grandset_c_bc($instid)   	$clr(SETTLED_C_BC)
                     #set grandset_d_bc($instid)   	$clr(SETTLED_D_BC)
                     set grandnetdeposit($instid) 	[expr $clr(SETTLED_C_BC) - $clr(SETTLED_D_BC)]
                     set grandset_bc($instid)     	[expr ($clr(SETTLED_C_BC) - $clr(SETTLED_D_BC)) - $clr(REFUND) \
                					 + $clr(SALES_REVERSAL) - ($clr(CHARGBACK_C) - $clr(CHARGBACK_D))]
		}
	}
	
	foreach institution $value {
	   puts $cur_file " "
	   puts $cur_file "INSTITUTION:,$institution"
           puts $cur_file "PAYABLES REPORT"
           puts $cur_file "Date:,$date\n"
           puts $cur_file "   "
           set headline "Settle Date,,Parent Merchant ID,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards"
           puts $cur_file ",$headline,Chargeback Amount,Rejects,Refunds,Misc Adj.,ACH Resub.,Reserves,\
                           Discount( Misc. Fees),Net Deposit\r\n"
        
           if {![info exists [subst dt${institution}]]} {
               puts "NO DATA FOR [subst dt${institution}]].."
	       puts $cur_file " "
	       puts $cur_file ",TOTAL:,,,,,0,0,0,0,0,0,0,0,0,0\r"
	       puts $cur_file " "
               continue
           }
        
           set dt1 [subst "$[subst dt${institution}]"]
        
           if {[string length $dt1] != "0"} {
        	foreach dt $dt1 {      	
        	   foreach eid [subst "$[subst e${institution}($dt)]"] {
                      if {![info exists dbaname($eid)]} {
                          set dbaname($eid)     " "
                      }
                      if {![info exists peid($eid)]} {
                          set peid($eid)     " "
                      }
                      if {![info exists enid($institution.$dt.$eid)]} {
                          set peid($eid)     " "
                      } else {
                  	   puts $cur_file ",$dt, ,$peid($eid),$enid($institution.$dt.$eid),$dbaname($eid),\
                                           $set_bc($institution.$dt.$eid) ,$SETTLED_NONBC,$chgbk($institution.$dt.$eid),\
                                           $REJECTS,$refund($institution.$dt.$eid),$MISC_ADJUSTMENTS,$ACH_RESUB,$RESERVES,\
                                           $DISCOUNT,$netdeposit($institution.$dt.$eid)\r"
                  	     }
        	   }
        	   puts $cur_file " "
            	   puts $cur_file ",Subtotal on $dt:,,,,,$subset_bc($institution.$dt) ,$SUB_SETTLED_NONBC,\
                                   $subchgbk($institution.$dt),$SUB_REJECTS,$subrefund($institution.$dt),\
                                   $SUB_MISC_ADJUSTMENTS,$SUB_ACH_RESUB,$SUB_RESERVES,$SUB_DISCOUNT,\
                                   $subnetdeposit($institution.$dt)\r"
            	   puts $cur_file " "
            	
        	}
           }
        
        if {![info exists grandset_bc($institution)]} {
	    set grandset_bc($institution) 0
	}
        
        if {![info exists grandchgbk($institution)]} {
            set grandchgbk($institution) 0
        }
        
        if {![info exists grandrefund($institution)]} {
            set grandrefund($institution) 0
        }
        
        if {![info exists grandnetdeposit($institution)]} {
            set grandnetdeposit($institution) 0
        }
        
        puts $cur_file " "
        puts $cur_file ",TOTAL:,,,,,$grandset_bc($institution),$GRAND_SETTLED_NONBC,$grandchgbk($institution),\
                        $GRAND_REJECTS,$grandrefund($institution),$GRAND_MISC_ADJUSTMENTS,$GRAND_ACH_RESUB,\
                        $GRAND_RESERVES,$GRAND_DISCOUNT,$grandnetdeposit($institution)\r"
        puts $cur_file " "
	}
	
	#-------------------------------------------ROLLUP----------------------------------------------
	puts $cur_file " "
	puts $cur_file "INSTITUTION:,ROLLUP 101 107"
	puts $cur_file " "
	puts $cur_file " "
	puts $cur_file "PAYABLES REPORT"
	puts $cur_file "Date:,$date\n"
	set headline "Settle Date,,Parent Merchant ID,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards"
	puts $cur_file ",$headline,Chargeback Amount,Rejects,Refunds,Misc Adj.,ACH Resub.,Reserves,\
                        Discount( Misc. Fees),Net Deposit\r\n"
	set dt1 $dtroll
		
	foreach dt $dt1 {
	   set roll_enid($dt)		0
	   set roll_set_bc($dt)		0
	   set roll_chgbk($dt)		0
	   set roll_refund($dt)		0
	   set roll_netdeposit($dt)	0
	
	   foreach eid [lsort -unique $eroll($dt)] {
              set roll_enid($dt.$eid)		0
	      set roll_set_bc($dt.$eid)		0
	      set roll_chgbk($dt.$eid)		0
	      set roll_refund($dt.$eid)		0
	      set roll_netdeposit($dt.$eid)	0
				
	      foreach institution $value {
		 if {[info exists enid($institution.$dt.$eid)]} {
		      set roll_enid($dt.$eid)   [expr $roll_enid($dt.$eid) + $enid($institution.$dt.$eid)]
		 }
				
		 if {[info exists set_bc($institution.$dt.$eid)]} {
		      set roll_set_bc($dt.$eid)	[expr $roll_set_bc($dt.$eid) + $set_bc($institution.$dt.$eid)]
		 }
				
		 if {[info exists chgbk($institution.$dt.$eid)]} {
		      set roll_chgbk($dt.$eid)	[expr $roll_chgbk($dt.$eid) + $chgbk($institution.$dt.$eid)]
		 }
				
		 if {[info exists refund($institution.$dt.$eid)]} {
		      set roll_refund($dt.$eid)	[expr $roll_refund($dt.$eid) + $refund($institution.$dt.$eid)]
		 }
				
		 if {[info exists netdeposit($institution.$dt.$eid)]} {
		      set roll_netdeposit($dt.$eid)  [expr $roll_netdeposit($dt.$eid) + $netdeposit($institution.$dt.$eid)]
		 }
	      }
		
	      set roll_enid($dt)       [expr $roll_enid($dt) + $roll_enid($dt.$eid)]
	      set roll_set_bc($dt)     [expr $roll_set_bc($dt) + $roll_set_bc($dt.$eid)]
	      set roll_chgbk($dt)      [expr $roll_chgbk($dt) + $roll_chgbk($dt.$eid)]
	      set roll_refund($dt)     [expr $roll_refund($dt) + $roll_refund($dt.$eid)]
	      set roll_netdeposit($dt) [expr $roll_netdeposit($dt) + $roll_netdeposit($dt.$eid)]
		
	      puts $cur_file ",$dt, ,$peid($eid),$roll_enid($dt.$eid),$dbaname($eid),$roll_set_bc($dt.$eid) ,\
                              $SETTLED_NONBC,$roll_chgbk($dt.$eid),$REJECTS,$roll_refund($dt.$eid),\
                              $MISC_ADJUSTMENTS,$ACH_RESUB,$RESERVES,$DISCOUNT,$roll_netdeposit($dt.$eid)\r"
	   }
	
	   #set roll_set_bc(grand)	[expr $roll_set_bc(grand) + $roll_set_bc($dt)]
	   #set roll_chgbk(grand)	[expr $roll_chgbk(grand) + $roll_chgbk($dt)]
	   #set roll_refund(grand)	[expr $roll_refund(grand) + $roll_refund($dt)]
	   #set roll_netdeposit(grand)	[expr $roll_netdeposit(grand) + $roll_netdeposit($dt)]
	
	   puts $cur_file " "
	   puts $cur_file ",Subtotal on $dt:,,,,,$roll_set_bc($dt),$SUB_SETTLED_NONBC,$roll_chgbk($dt),\
                           $SUB_REJECTS,$roll_refund($dt),$SUB_MISC_ADJUSTMENTS,$SUB_ACH_RESUB,$SUB_RESERVES,\
                           $SUB_DISCOUNT,$roll_netdeposit($dt)\r"
	   puts $cur_file " "	
	}
	
	set roll_grandset_bc(GRAND)	0
	set roll_netdeposit(GRAND)	0
	set roll_refund(GRAND)		0
	set roll_chgbk(GRAND)		0

	foreach institution $value {
	   if {[info exists grandset_bc($institution)]} {
		set roll_grandset_bc(GRAND) [expr $roll_grandset_bc(GRAND) + $grandset_bc($institution) ]
	   }
	   if {[info exists grandnetdeposit($institution)]} {
		set roll_netdeposit(GRAND) [expr $roll_netdeposit(GRAND) + $grandnetdeposit($institution)]
	   }
	   if {[info exists grandrefund($institution)]} {
		set roll_refund(GRAND) [expr $roll_refund(GRAND) + $grandrefund($institution)]
	   }
	   if {[info exists grandchgbk($institution)]} {
		set roll_chgbk(GRAND) [expr $roll_chgbk(GRAND) + $grandchgbk($institution)]
	   }
	}

	puts $cur_file " "
	puts $cur_file ",REPORT TOTAL:,,,,,$roll_grandset_bc(GRAND),$SUB_SETTLED_NONBC,$roll_chgbk(GRAND),\
             $SUB_REJECTS,$roll_refund(GRAND),$SUB_MISC_ADJUSTMENTS,$SUB_ACH_RESUB,$SUB_RESERVES,$SUB_DISCOUNT,\
             $roll_netdeposit(GRAND)\r"
	puts $cur_file " "

	close $cur_file

        exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" -- "$mail_to"
}


#MAIN

if { $argc == 0 } {
     set institution_num  "ALL"
     set file_name_date   [clock format [clock scan "-0 day"] -format %Y%m%d]                    ;# used in output file name
     set date             [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%Y]] ;#05-MAR-08
     set first_set_day    [string toupper [clock format [clock scan "+1 day"] -format %d-%b-%Y]] ;#06-MAR-08
     set CUR_JULIAN_DATEX [string range [clock format [clock seconds ] -format "%y%j"] 1 4]
} elseif { $argc == 1} {
    if {[string length [ lindex $argv 0 ] ] == 3} {
	 set institution_num  [lindex $argv 0]
	 set file_name_date   [clock format [clock scan "-0 day"] -format %Y%m%d]                    ;# used in output file name
	 set date             [string toupper [clock format [clock scan "-0 day"] -format %d-%b-%Y]] ;#05-MAR-2008
	 set first_set_day    [string toupper [clock format [clock scan "+1 day"] -format %d-%b-%Y]] ;#06-MAR-2008
	 set CUR_JULIAN_DATEX [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
    } elseif {[string length  [lindex $argv 0 ] ] == 8} {
         set institution_num  "ALL"
	 set dt [string toupper [clock format [clock scan "[ lindex $argv 0 ]" -format %Y%m%d] -format %d-%b-%Y]]
	 set file_name_date     [clock format [clock scan "$dt" ] -format %Y%m%d]
	 set date               [string toupper [clock format [clock scan "$dt"] -format %d-%b-%Y]]        ;#05-MAR-08
	 set first_set_day      [string toupper [clock format [clock scan "$dt +1 day"] -format %d-%b-%Y]] ;#06-MAR-08
	 set CUR_JULIAN_DATEX   [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
      }
} elseif { $argc == 2} {
    set institution_num [ lindex $argv 0 ]
    set dt [string toupper [clock format [clock scan "[ lindex $argv 1 ]" -format %Y%m%d] -format %d-%b-%Y]]
    set file_name_date     [clock format [clock scan "$dt" ] -format %Y%m%d]
    set date               [string toupper [clock format [clock scan "$dt"] -format %d-%b-%Y]]        ;#05-MAR-08
    set first_set_day      [string toupper [clock format [clock scan "$dt +1 day"] -format %d-%b-%Y]] ;#06-MAR-08
    set CUR_JULIAN_DATEX   [string range [clock format [clock scan "$date"] -format "%y%j"] 1 4]
}

 puts "date is $date ..first_set_day is $first_set_day.. JUlian_date is $CUR_JULIAN_DATEX"

if {$institution_num == "ALL"} {
    report "101 107"
} else {
    report $institution_num
}

oraclose $fetch_cursor1
oraclose $fetch_cursor2
oralogoff $handler
