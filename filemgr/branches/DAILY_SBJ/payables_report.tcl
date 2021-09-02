#!/usr/local/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: payables_report.tcl 4649 2018-07-20 21:10:32Z bjones $
# $Rev: 4649 $
################################################################################
#
#    File Name   -  payables_report.tcl
#
#    Description -  This script generates payables or delayed funding reports
#                   by institution.
#
#    Arguments   -f config file
#                -d Date to run the report, optional  e.g. 20140521
#                   This scripts can run with or without a date. If no date
#                   provided it will use sysdate to run the report.
#                   With a date argument, the script will run the report for a
#                   given date.
#
#    Usage       -  payables_report.tcl -D yyyymmdd -F config_file.cfg
#
#                   e.g.  payables_report.tcl -d 20150315 -f test.cfg
#
################################################################################

package require Oratcl

################################################################################

proc readCfgFile {} {
   global clr_db_logon
   global clr_db
   global argv mail_to mail_err inst_list

   set clr_db_logon ""
   set clr_db ""

   if { [regexp {(-[fF])[ ]+([A-Za-z_-]+\.[A-Za-z]+)} $argv dummy1 dummy2 cfg_file_name] } {
         puts " Config file argument: $cfg_file_name"
   } else {
          set cfg_file_name payables_report.cfg 
          puts " Default Config File: $cfg_file_name"
   }

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts " *** File Open Err: Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
       set line_parms [split $line ~]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "CLR_DB" {
            set clr_db [lindex $line_parms 1]
         }
         "MAIL_ERR" {
            set mail_err [lindex $line_parms 1]
         }
         "MAIL_TO" {
            set mail_to [lindex $line_parms 1]
            puts " mail_to: $mail_to"
         }
         "INST_LIST" {
            set inst_list [lindex $line_parms 1]
            puts " inst_list: $inst_list"
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
       puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }
}

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
   global clr_logon_handle
   global clr_db_logon
   global clr_db

   if {[catch {set clr_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        puts " Connected to clr_db"
   }
}

proc arg_parse {} {
   global argv date_arg 

   #scan for Date
   if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
         puts " Date argument:   $arg_date"
         set date_arg $arg_date
   }
}

proc init_dates {val} {
    global curdate requested_date today tomorrow filedate  

    set curdate        [clock format   [clock seconds] -format %b-%d-%Y]
    set requested_date [clock format   [clock scan "$val"] -format %b-%d-%Y]

    set today          [string toupper [clock format [clock scan "$val" -format %Y%m%d] -format %d-%b-%Y]]   
    set tomorrow       [string toupper [clock format [clock scan "$today +1 day"] -format %d-%b-%Y]]

    set filedate       [clock format   [clock scan "$today"] -format %Y%m%d]                                

    puts " Generated Date:  $curdate" 
    puts " Requested Date:  $requested_date" 
    puts " Start Date:      $today" 
    puts " End Date:        $tomorrow"
}

proc do_report {value} {
    
    global curdate requested_date today tomorrow filedate  
    global fetch_cursor1 fetch_cursor2 cur_file sql_inst mail_to 

    set file_name     "$sql_inst.Payables_Report.$filedate.csv"
    set cur_file      [open "$file_name" w]
   
    set SETTLED_BC              0
    set SETTLED_NONBC           0
    set CHARGEBACK_AMOUNT       0
    set REJECTS                 0
    set REFUNDS                 0
    set SALE_REVERSALS          0
    set MISC_ADJUSTMENTS        0
    set ACH_RESUB               0
    set RESERVES                0
    set DISCOUNT                0
    set NETDEPOSIT              0

    set GRAND_NON_C             0
    set GRAND_NON_D             0
    set GRAND_BCC               0
    set GRAND_BCD               0
    set GRAND_SETTLED_BC        0
    set GRAND_SETTLED_NONBC     0
    set GRAND_CHARGEBACK_AMOUNT 0
    set GRAND_REJECTS           0
    set GRAND_REFUNDS           0
    set GRAND_SALE_REVERSALS    0
    set GRAND_MISC_ADJUSTMENTS  0
    set GRAND_ACH_RESUB         0
    set GRAND_RESERVES          0
    set GRAND_DISCOUNT          0
    set GRAND_NETDEPOSIT        0
    set SUB_SETTLED_BC          0
    set SUB_SETTLED_NONBC       0
    set SUB_CHARGEBACK_AMOUNT   0
    set SUB_REJECTS             0
    set SUB_REFUNDS             0
    set SUB_SALE_REVERSALS      0
    set SUB_MISC_ADJUSTMENTS    0
    set SUB_ACH_RESUB           0
    set SUB_RESERVES            0
    set SUB_DISCOUNT            0
    set SUB_NETDEPOSIT          0
    set SUB_CHARGBACK           0

    set ENTITY_ID               0
    set SETTLED_C_BC            0
    set SETTLED_D_BC            0

    set dtroll   {}
    set eroll()  {}

    puts $cur_file "  Institution:, $sql_inst"
    puts $cur_file "  Date Generated:, $curdate"
    puts $cur_file "  Requested Date:, $requested_date"
    puts $cur_file "       "
    puts $cur_file "       "

    set  header    "Settle Date,Parent Merchant ID,Merchant ID,Merchant Name,Settle Bankcards,Settle NonBankcards"
    puts $cur_file "$header,Chargeback Amount,Rejects,Refunds,Misc Adj.,ACH Resub.,Reserves,\
                    Discount( Misc. Fees),Net Deposit\r\n"

    set merinfo "
        select institution_id, entity_dba_name, parent_entity_id, entity_id 
        from  acq_entity 
        where institution_id in ('$sql_inst') 
          and entity_level = '70'  "
                          
    orasql $fetch_cursor1 $merinfo

    while {[orafetch $fetch_cursor1 -dataarray mer -indexbyname] != 1403} {
            set dbaname($mer(ENTITY_ID)) $mer(ENTITY_DBA_NAME)
            set peid($mer(ENTITY_ID))    $mer(PARENT_ENTITY_ID)
            set inst($mer(ENTITY_ID))    $mer(INSTITUTION_ID)
    }
      
    set chabk "'010003010102','010003010101','010003015201','010003015102','010003015101','010003015210','010003015301'"

    set query_str_cur "
        SELECT m.institution_id, m.date_to_settle, m.entity_id, 
               SUM(CASE WHEN( m.tid_settl_method = 'C' and card_scheme <> '12') 
                        THEN m.amt_original ELSE 0 END )                         AS SETTLED_C_BC, 
               SUM(CASE WHEN( m.tid_settl_method = 'D' and card_scheme <> '12') 
                        THEN m.amt_original ELSE 0 END )                         AS SETTLED_D_BC, 
               SUM(CASE WHEN( m.tid = '010003005102') 
                        THEN m.amt_original*-1 ELSE 0 END )                      AS REFUND, 
               SUM(CASE WHEN( m.tid = '010003005201') 
                        THEN m.amt_original ELSE 0 END )                         AS SALES_REVERSAL, 
               SUM(CASE WHEN( m.tid_settl_method = 'C' and m.tid IN ($chabk))  
                        THEN m.amt_original else 0 end )                         AS CHARGBACK_C, 
               SUM(CASE WHEN( m.tid_settl_method = 'D' and m.tid IN ($chabk))  
                        THEN m.amt_original else 0 end )                         AS CHARGBACK_D 
        FROM   mas_trans_log m 
        WHERE (m.tid, settl_plan_id) IN (SELECT unique tid, settl_plan_id 
                                         FROM  settl_plan_tid 
                                         WHERE delay_factor0 <> '0' 
                                           AND delay_factor1 <> '0' 
                                           AND tid not in ('010007050000','010070010000','010070010017') 
                                           AND tid not like '010004%' 
                                           AND institution_id IN ('$sql_inst')) 
          AND m.institution_id in ('$sql_inst') 
          AND m.date_to_settle > '$today' 
          AND m.gl_date < '$tomorrow' 
        GROUP BY m.institution_id, rollup(m.date_to_settle), rollup( m.entity_id) 
        ORDER BY m.institution_id, m.date_to_settle   "
        
#   puts "Query1: $query_str_cur"

    orasql $fetch_cursor2 $query_str_cur

    while {[orafetch $fetch_cursor2 -dataarray clr -indexbyname] != 1403} {
            set eid    $clr(ENTITY_ID)
            set instid $clr(INSTITUTION_ID)
            set setdt  $clr(DATE_TO_SETTLE)
    
    # declare institution array eg. e101()
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
                 set netdeposit($instid.$setdt.$eid) [expr $clr(SETTLED_C_BC)    - $clr(SETTLED_D_BC)]
                 set set_bc($instid.$setdt.$eid)     [expr ($clr(SETTLED_C_BC)   - $clr(SETTLED_D_BC)) - $clr(REFUND) \
                                                          + $clr(SALES_REVERSAL) - ($clr(CHARGBACK_C)  - $clr(CHARGBACK_D))]
                 lappend "e${instid}($setdt)" $eeid($instid.$setdt)
                 lappend  eroll($setdt)       $eeid($instid.$setdt)
            } elseif {[string length $instid] == "3" &&  [string length $eid] == "0" && [string length $setdt] > "1"} {
                 set subrefund($instid.$setdt)     $clr(REFUND)
                 set subsalerev($instid.$setdt)    $clr(SALES_REVERSAL)
                 set subchgbk($instid.$setdt)      [expr $clr(CHARGBACK_C) - $clr(CHARGBACK_D)]
                 set subset_c_bc($instid.$setdt)   $clr(SETTLED_C_BC)
                 set subset_d_bc($instid.$setdt)   $clr(SETTLED_D_BC)
                 set subnetdeposit($instid.$setdt) [expr $clr(SETTLED_C_BC)    - $clr(SETTLED_D_BC)]
                 set subset_bc($instid.$setdt)     [expr ($clr(SETTLED_C_BC)   - $clr(SETTLED_D_BC)) - $clr(REFUND) \
                                                        + $clr(SALES_REVERSAL) - ($clr(CHARGBACK_C)  - $clr(CHARGBACK_D))]            
                 set [subst dt${instid}] "[subst $[subst dt${instid}]] $setdt"
                 lappend dtroll $setdt
            } elseif {[string length $instid] == "3" && [string length $eid] == "0" && [string length $setdt] == "0"} {
                 set grandrefund($instid)       $clr(REFUND)
                 #set grandsalerev($instid)     $clr(SALES_REVERSAL)
                 set grandchgbk($instid)        [expr $clr(CHARGBACK_C) - $clr(CHARGBACK_D)]
                 #set grandset_c_bc($instid)    $clr(SETTLED_C_BC)
                 #set grandset_d_bc($instid)    $clr(SETTLED_D_BC)
                 set grandnetdeposit($instid)   [expr $clr(SETTLED_C_BC)    - $clr(SETTLED_D_BC)]
                 set grandset_bc($instid)       [expr ($clr(SETTLED_C_BC)   - $clr(SETTLED_D_BC)) - $clr(REFUND) \
                                                     + $clr(SALES_REVERSAL) - ($clr(CHARGBACK_C)  - $clr(CHARGBACK_D))]
            }
    }

    foreach institution $value {
         if {![info exists [subst dt${institution}]]} {
               puts "NO DATA FOR [subst dt${institution}]].."
               puts $cur_file " "
               puts $cur_file "Total:,,,,0,0,0,0,0,0,0,0,0,0\r"
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
                              puts $cur_file "$dt,$peid($eid),$enid($institution.$dt.$eid),$dbaname($eid),\
                                              $set_bc($institution.$dt.$eid) ,$SETTLED_NONBC,$chgbk($institution.$dt.$eid),\
                                              $REJECTS,$refund($institution.$dt.$eid),$MISC_ADJUSTMENTS,$ACH_RESUB,$RESERVES,\
                                              $DISCOUNT,$netdeposit($institution.$dt.$eid)\r"
                        }
                   }
              puts $cur_file " "
              puts $cur_file "Subtotal:,,,,$subset_bc($institution.$dt) ,$SUB_SETTLED_NONBC,\
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
        
         puts $cur_file "Total:,,,,$grandset_bc($institution),$GRAND_SETTLED_NONBC,$grandchgbk($institution),\
                         $GRAND_REJECTS,$grandrefund($institution),$GRAND_MISC_ADJUSTMENTS,$GRAND_ACH_RESUB,\
                         $GRAND_RESERVES,$GRAND_DISCOUNT,$grandnetdeposit($institution)\r"
         puts $cur_file " "
    }


    close $cur_file

    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "$mail_to"

    exec mv $file_name ./ARCHIVE
}


##########
# MAIN
##########

readCfgFile

connect_to_db

set fetch_cursor1 [oraopen $clr_logon_handle]

set fetch_cursor2 [oraopen $clr_logon_handle]

arg_parse

if {![info exists date_arg]} {
      init_dates [clock format [clock seconds] -format %Y%m%d]
} else {
      init_dates $date_arg
}

foreach sql_inst $inst_list {
     do_report $sql_inst
}

oraclose $fetch_cursor1

oraclose $fetch_cursor2

oralogoff $clr_logon_handle
