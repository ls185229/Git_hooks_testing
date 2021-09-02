#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: 

################################################################################
#
#    File Name - monthly_meridian_merchant_list
#
#    Description - 
#
#    Arguments -d = year and month
#                    
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 -
#           2 -
#           3 - DB Error
#
#    Note -
#
################################################################################

package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_clr_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)

##set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[lindex [split [file tail $argv0] .] 0]"

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################
proc usage {} {
    global programName

    puts "Usage: -d date (format yyyymm format)]"
    puts "       "
}

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - open,parse and close the config file
#
#    Arguments - Config file name
#
#    Return - exit 2, if required parameters not found
#
###############################################################################
proc readCfgFile {cfgFileName} {
    global clrDBLogin authDBLogin instIds mailtolist mailfromlist mailtolist prod_clr_db

    set clrDBLogin ""

    if {[catch {open $cfgFileName} filePtr]} {
		writeLogRcd 2 "File Open Err:$programName.tcl Cannot open output file $fileName"
    }

    while { [set line [gets $filePtr]] != {}} {
	  set lineParms [split $line =]
	  switch -exact -- [lindex  $lineParms 0] {
			"CLR_DB_LOGON" { 
				set clrDBLogin [lindex $lineParms 1]
			}
			"AUTH_DB_LOGON" {
				set authDBLogin [lindex $lineParms 1] 
			}
			"INST_IDS" { 
				set instIds [lindex $lineParms 1]
			}
			"PROD_CLR_DB" {
				set prod_clr_db [lindex $lineParms 1]
			}
			"MAIL_TO" {
			    set mailtolist [lindex $lineParms 1]
			}
	     default {
	    	writeLogRcd 0 "Unknown config parameter [lindex $lineParms 0]"
	      }
	   }
    }

    close $filePtr

    if {$clrDBLogin == ""} {
		writeLogRcd 2 "Config Parm Err:$programName.tcl - Unable to find CLR_DB_LOGON params in $cfgFileName"
    }
}
################################################################################
#
#    Procedure Name - init
#
#    Description - Initialize program arguments 
#
###############################################################################
proc init {argc argv} {
    global transDate instIds programName cfgFile mailfromlist mailtolist entity_id
     
	set entity_id ""
	
    set cfgFile "meridian_monthly_merchant_list.cfg"
	set transDate ""

    foreach {opt} [split $argv -] {
		switch -exact -- [lindex $opt 0] {
			"d" {
			   set transDate [lrange $opt 1 end] 
			    } 
		}
    }
	
    #### Read the Config File 
    readCfgFile $cfgFile 

    #### Initialize the Database parameters
    initDB
    
    #### Initialize program varaiables

    if {$transDate == ""} {
      set systemTime [clock seconds]
      set systemTime "[clock add $systemTime -1 month]"
      set transDate "[clock format $systemTime -format %Y%m]"
	}
}

################################################################################
#
#    Procedure Name - executeQuery
#
#    Description - The procedure simply executes the query passed
#
#    Return - The query handle
#
###############################################################################
proc executeQuery {query handle} {
global programName mailfromlist mailtolist

    if {[catch {oraexec $handle} result]} {
		puts [oramsg $handle all]
		writeLogRcd 3  "SQL Err:[oramsg $handle error]\n$query"
	}
    return $handle
}

################################################################################
#
#    Procedure Name - initDB
#
#    Description - Setup the DB, tables and handles
#
#    Return - exit 3 if any error
#
###############################################################################
proc initDB {} {
    global prod_clr_db clrDBLogin authDBLogin prod_auth_db clrHandle clrHandle2 authHandle 3 
	global entity_id instIds transInfoCur merchantInfoCur

    if {[catch {set clrDBLoginHandle [oralogon $clrDBLogin@$prod_clr_db]} result ] } {
		writeLogRcd 3 "DB login Err:$programName.tcl - $prod_clr_db login Err: $result"
    }

    if {[catch {set clrHandle [oraopen $clrDBLoginHandle]} result ]} {
		writeLogRcd 3 "Schema access Err:$programName.tcl - Connection Err: $result"
    }

    if {[catch {set clrHandle2 [oraopen $clrDBLoginHandle]} result ]} {
		writeLogRcd 3 "Schema access Err:$programName.tcl - Connection Err: $result"
    }
 
    if {[catch {set authDBLoginHandle [oralogon $authDBLogin@$prod_auth_db]} result ] } {
	   puts $authDBLogin@$prod_auth_db
		writeLogRcd 3 "$prod_auth_db login Err: $result "
    }

	if {[catch {set authHandle [oraopen $authDBLoginHandle]} result ]} {
		writeLogRcd 3 "Schema access Err:$programName.tcl - Connection Err: $result"
    }

    set sales_tids "'010103005101','010103005103','010103005104','010123005101'"
    set cb_tids    "'010103015101', '010103015102', '010103015104', '010103015107', '010103015201', '010103015202', '010103015301'"
    set return_tids "'010103005102', '010103005201', '010103005204', '010103005401', '010123005102', '010123005202'"
  	 
	set merchantInfoCur "select distinct replace(entity_name, ',') ENTITY_NAME
                                  , replace(trim(address1||' '||address2), ',') ADDRESS
                                  , CITY
                                  , PROV_STATE_ABBREV
                                  , POSTAL_CD_ZIP
                                  , null ABA_ACCOUNT_NUMBER
                                  , ae.ENTITY_ID
                                  , trim(mc.first_name||' '||mc.last_name) NAME
                                  , ae.DEFAULT_MCC
                                  , to_char(actual_start_date, 'mm/dd/yyyy') ACTUAL_START_DATE
                                  , decode(entity_status, 'C', to_char(termination_date, 'mm/dd/yyyy'), null) TERMINATION_DATE
                     from acq_entity ae
                     join acq_entity_address aea on (ae.institution_id = aea.institution_id 
					                             and ae.entity_id = aea.entity_id)
                     join master_address ma on (aea.address_id = ma.address_id 
                                           and ma.institution_id = aea.institution_id)
                     join acq_entity_contact aec on (ae.institution_id = aec.institution_id 
                                                 and ae.entity_id = aec.entity_id)
                     join master_contact mc on (aec.contact_id = mc.contact_id
                                            and mc.institution_id = aec.institution_id)
                     where institution_id in ($instIds)
                       and entity_level = 70
                       and address_role = 'LOC'
                       and contact_role = 'DEF'
                       and lower(entity_name) not like '%test%'"

	oraparse $clrHandle $merchantInfoCur

	set transInfoCur "select sum(case when idm.tid in ($sales_tids)
             then (decode(idm.tid, '010123005101', -1, 1) * amt_trans) / 100 
             else 0
             end) sales_amt
     , sum(case when idm.tid in ($sales_tids)
             then decode(idm.tid, '010123005101', -1, 1)
             else 0
             end) sales_cnt
     , sum(case when idm.tid in ($sales_tids)
                and nvl(pos_crd_present, 0) = 1
             then (decode(idm.tid, '010123005101', -1, 1) * amt_trans) / 100 
             else 0
             end) Card_Present_amt
     , sum(case when idm.tid in ($sales_tids)
                and nvl(pos_crd_present, 0) = 1
             then decode(idm.tid, '010123005101', -1, 1)
             else 0
             end) Card_Present_cnt
     , sum(case when idm.tid in ($sales_tids)
                and nvl(pos_crd_present, 0) != 1
             then (decode(idm.tid, '010123005101', -1, 1) * amt_trans) / 100 
             else 0
             end) Card_not_Present_amt
     , sum(case when idm.tid in ($sales_tids)
                and nvl(pos_crd_present, 0) != 1
             then decode(idm.tid, '010123005101', -1, 1)
             else 0
             end) Card_not_Present_cnt
     , sum(case when idm.tid in ($cb_tids)
              then (decode(tid_settl_method, 'C', -1, 1) * amt_trans) / 100 
              else 0
            end) chargeback_amt
     , sum(case when idm.tid in ($cb_tids)
              then decode(tid_settl_method, 'C', -1, 1)
              else 0
            end) chargeback_cnt
     , sum(case when idm.tid in ($return_tids)
             then (decode(tid_settl_method, 'D', -1, 1) * amt_trans) / 100 
             else 0
             end) return_amt
     , sum(case when idm.tid in ($return_tids)
             then decode(tid_settl_method, 'D', -1, 1)
             else 0
             end) return_cnt
     from in_draft_main idm
       , tid t
     where t.tid = idm.tid
       and merch_id = :ENTITY_ID
       and activity_dt between to_date(:TRANS_DATE_1, 'yyyymm') and last_day(to_date(:TRANS_DATE_2, 'yyyymm'))"

    oraparse $clrHandle2 $transInfoCur
  
}

################################################################################
#
#    Procedure Name - openOutputFile
#
#    Description - Open the output file
#                 
#    Return - NA
#
###############################################################################
proc openOutputFile {} {
    global filePtr transDate
    
    #### open output file
    
    set fileName [format "meridian_merchant_list_%s.csv" $transDate ]
    
    if {[catch {open $fileName w} filePtr]} {
		writeLogRcd 3 "File Open Err:$programName.tcl - cannot open $fileName for output "
    }
}
################################################################################
#
#    Procedure Name - writeLogRcd
#
#    Description - Write message to the log file. If the proc code is gt 0 then
#                  the script with that code.
#                 
#    Return - NA
#
###############################################################################
proc writeLogRcd {proc_cd message} {
    
  set logDate [clock seconds]
  set logDate [clock format $logDate -format "%Y%m%d"]
  set logTime [clock seconds]
  set logTime [clock format $logTime -format "%Y/%m/%d %H:%M:%S"]
  
  set logFileName [format "LOG/meridian_merchant_list_%s.log" $logDate ]
   
  if {[catch {open $logFileName a} logFilePtr]} {
	 puts "File Open Err:$programName.tcl Cannot open log file $fileName"
     exit 3
  }
  puts $logFilePtr "$logTime - $message"
  close $logFilePtr
  if {$proc_cd > 0} {
    exit $proc_cd
  }
}

##########
## MAIN ##
##########

  writeLogRcd 0 "Start:$programName.tcl "
  
  init $argc $argv

  openOutputFile 
 
  puts $filePtr "Merchant Name, Address, City, State, Zip, Bank Routing Number, Merchant ID, Owner name, DOB, MCC, Open Date, Closed Date, Total sales Ct, Total sales $, Card Present CT, Card Present $, Card not Present CT, Card not Present $, Refund Ct, Refund $, Chargeback Ct, Chargeback $"
  flush $filePtr	
  
  set merchRcdCurHandle [executeQuery $merchantInfoCur $clrHandle ]

  while {[orafetch $merchRcdCurHandle -dataarray ds -indexbyname] != 1403} {
    set entity_name              "$ds(ENTITY_NAME)"
    set address                  "$ds(ADDRESS)"
    set city                     "$ds(CITY)"
    set prov_state_abbrev        "$ds(PROV_STATE_ABBREV)"
    set postal_cd_zip            "$ds(POSTAL_CD_ZIP)"
    set entity_id                "$ds(ENTITY_ID)"
    set name                     "$ds(NAME)"
    set default_mcc              "$ds(DEFAULT_MCC)"
    set actual_start_date        "$ds(ACTUAL_START_DATE)"
    set termination_date         "$ds(TERMINATION_DATE)"
#	set institution_id           "$ds(INSTITUTION_ID)"

	set sales_cnt        0
    set sales_amt       0
    set card_present_ct       0
    set card_present_amt      0
    set card_not_present_ct   0
    set card_not_present_amt  0
    set return_ct             0
    set return_amt            0
    set chargeback_ct         0
    set chargeback_amt        0
    set aba_routing_nbr       ""
    set DOB                   ""

    orabind $clrHandle2 :ENTITY_ID $entity_id :TRANS_DATE_1 $transDate :TRANS_DATE_2 $transDate
    set transRcdCurHandle [executeQuery $transInfoCur $clrHandle2 ]

    if {[orafetch $transRcdCurHandle -dataarray ds2 -indexbyname] != 1403} {
							 
      set sales_cnt                "$ds2(SALES_CNT)"
      set sales_amt                "$ds2(SALES_AMT)"
      set card_present_ct          "$ds2(CARD_PRESENT_CNT)"
      set card_present_amt         "$ds2(CARD_PRESENT_AMT)"
      set card_not_present_ct      "$ds2(CARD_NOT_PRESENT_CNT)"
      set card_not_present_amt     "$ds2(CARD_NOT_PRESENT_AMT)"
      set return_ct                "$ds2(RETURN_CNT)"
      set return_amt               "$ds2(RETURN_AMT)"
      set chargeback_ct            "$ds2(CHARGEBACK_CNT)"
      set chargeback_amt           "$ds2(CHARGEBACK_AMT)"
    }
 
    set    detailLine "\"$entity_name\""
    append detailLine ",\"$address\""
    append detailLine ",\"$city\""
    append detailLine ",\"$prov_state_abbrev\""
    append detailLine ",\"$postal_cd_zip\""
    append detailLine ",\"$aba_routing_nbr\""      
    append detailLine ",\"$entity_id\""
    append detailLine ",\"$name\""
    append detailLine ",\"$DOB\""
    append detailLine ",\"$default_mcc\""
    append detailLine ",\"$actual_start_date\""
    append detailLine ",\"$termination_date\""
    append detailLine ",$sales_cnt"
    append detailLine ",$sales_amt"
    append detailLine ",$card_present_ct"
    append detailLine ",$card_present_amt"
    append detailLine ",$card_not_present_ct"
    append detailLine ",$card_not_present_amt"
    append detailLine ",$return_ct"
    append detailLine ",$return_amt"
    append detailLine ",$chargeback_ct"
    append detailLine ",$chargeback_amt"
    
    puts $filePtr $detailLine
    flush $filePtr	
  }
close $filePtr

writeLogRcd 0 "Complete:$programName.tcl "

oraclose $transRcdCurHandle

exit 0	  
