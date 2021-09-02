#!/usr/bin/env tclsh

# $Id: 

################################################################################
#
#    File Name - merrick_daily_trans_upload.tcl
#
#    Description - Create the daily trans upload CSV for file fro Merrick Bank
#
#    Arguments -c = config file
#              [-d = date {format: yyymmdd}]
#                    
#    Exit - 1 - Unable to opn config file
#           2 -
#           3 - DB Error
#           4 - 
#           5 - Unable to opn config file
#    Note -
#
################################################################################
# $Id: $
# $Rev: $
# $Author: $
################################################################################


package require Oratcl

## Enviornment Variable ##

#set box $env(SYS_BOX)

# set prod_clr_db trnclr1
set prod_clr_db $env(IST_DB)

set prod_auth_db AUTH4
#set mailtolist $env(MAIL_TO)
#set mailfromlist $env(MAIL_FROM)

##set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

#Email Subjects variables Priority wise

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

    puts "Usage: -c configfile [-d date (yyyymmdd format)]"
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
    global clrDBLogin authDBLogin instIds prod_clr_db

    set clrDBLogin ""
    set authDBLogin ""
	set instIds ""

    if {[catch {open $cfgFileName} filePtr]} {
		writeLogRcd 5 "Config file not found"
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
         default {
	      }
	  }
    }

    close $filePtr

    if {$clrDBLogin == ""} {
		writeLogRcd 2 "clrDBLogin not defined
    }

    if {$authDBLogin == ""} {
		writeLogRcd 2 "authDBLogin not defined"
    }

    if {$instIds == ""} {
		writeLogRcd 2 "instIds not defined"
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
    global transDate instIds programName cfgFile mailfromlist mailtolist strt_dt end_dt

    set cfgFile ""
	set transDate ""

    foreach {opt} [split $argv -] {
		switch -exact -- [lindex $opt 0] {
			"c" {
			   set cfgFile [lrange $opt 1 end] 
			    } 
			"d" {
			   set transDate [lrange $opt 1 end] 
			    } 
		}
    }
	
    #### Verify the Arguments passed

    if {$cfgFile == ""} {
      writeLogRcd 2 "Insufficient Arguments Err:$programName.tcl - config file not specified" 
    }
    #### Read the Config File 
    readCfgFile $cfgFile 

    #### Initialize the Database parameters
    initDB
    
    #### Initialize program varaiables

    if {$transDate == ""} {
      set systemTime [clock seconds]
      set systemTime "[clock add $systemTime -1 day]"
      set transDate "[clock format $systemTime -format %Y%m%d]"
	}

    set strt_dt [string toupper [clock format [clock scan "$transDate" -format %Y%m%d] -format 01-%b-%Y]]
    set end_dt [string toupper [clock format [clock scan "$strt_dt +1 month"] -format 01-%b-%Y]]
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

    if {[catch {orasql $handle $query} result]} {
		puts $logFilePtr "SQL Err:$result"
		puts $logFilePtr "$query"
		exit 4
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
    global prod_clr_db clrDBLogin authDBLogin prod_auth_db clrHandle clrHandle2 authHandle
    if {[catch {set clrDBLoginHandle [oralogon $clrDBLogin@$prod_clr_db]} result ] } {
		writeLogRcd 4 "DB login Err:$programName.tcl - $prod_clr_db login Err: $result" 
    }

    if {[catch {set clrHandle [oraopen $clrDBLoginHandle]} result ]} {
		writeLogRcd 4 "Schema access Err:$programName.tcl - Connection Err: $result" 
    }

    if {[catch {set clrHandle2 [oraopen $clrDBLoginHandle]} result ]} {
		writeLogRcd 4 "Schema access Err:$programName.tcl - Connection Err: $result" 
    }
 
    if {[catch {set authDBLoginHandle [oralogon $authDBLogin@$prod_auth_db]} result ] } {
		writeLogRcd 4 "$prod_auth_db login Err: $result "
    }

	if {[catch {set authHandle [oraopen $authDBLoginHandle]} result ]} {
		writeLogRcd 4 "Schema access Err:$programName.tcl - Connection Err: $result" 
    }

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
    global filePtr transDate strt_dt
    
    #### open output file
    
    set fileName [format "merrick_monthly_trans_upload_%s.csv" [clock format [clock scan $strt_dt] -format %Y%m]]
    
    if {[catch {open $fileName w} filePtr]} {
		writeLogRcd 2 "File Open Err:$programName.tcl Cannot open output file $fileName"
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
  
  set logFileName [format "LOGS/merrick_monthly_trans_upload_%s.log" $logDate ]
   
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

init $argc $argv

writeLogRcd 0 "start $programName"

openOutputFile 

set transRcdCur "select trans_ref_data arn
     , idm.auth_cd
     , to_char(proc_dt, 'mm/dd/yyyy') auth_date
     , idm.pan CARD_NBR
     , mtl.CARD_TYPE
     , Transaction_date
     , case mtl.CARD_TYPE
           when 'VISA' then trim(fee_prog_ind)
           when 'MasterCard' then trim(ide.ichg_rate_designat)
           when 'Discover' then trim(acq_ichg_pgm)
		 else null
       end interchange_code
     , mtl.JETPAY_TRANS_ID
     , mtl.LEGAL_NAME
     , trim(mtl.MCC) MCC
     , mtl.MERCHANT_ID
     , mtl.MERCHANT_NAME
     , null MID
     , case idm.pos_ch_present
              when 0 then '4'
              when 9 then '4'
              when 1 then ' '
              when 4 then '2'
              when 5 then '5'
              when 10 then '5'
              when 11 then '5'
              else '1'
          end MOTO
     , to_char(ptd.settl_date, 'mm/dd/yyyy') settle_date
     , trim(to_char(mtl.TRANS_AMOUNT, '9999999.99')) TRANS_AMOUNT
     , mtl.TRANS_TYPE
     , external_trans_nbr
     , mtl.tid
     , mtl.institution_id
from (select ae.institution_id
           ,ae.entity_id  MERCHANT_ID
           ,ae.entity_dba_name legal_Name
           ,ae.entity_name Merchant_Name
           ,ae.default_mcc MCC
           ,decode(mtl.tid_settl_method, 'D', 'Return', 'Sale') TRANS_TYPE
           ,decode(mtl.tid_settl_method, 'D', -1, 1) * amt_billing	TRANS_AMOUNT
           ,to_char(mtl.activity_date_time, 'mm/dd/yyyy') TRANSACTION_DATE
           ,mtl.tid	
           ,case
                when (mtl.tid = '010007050000' and ea.acct_posting_type = 'R') then 'Reserve'
                when mtl.tid in ('010003015101', '010003015102', '010003015201', '010003015210', '010003015301') then 'Charge_Back'
                when mtl.tid in ('010003005301', '010003005401', '010003010102', '010003010101') then 'Representment'
                else cs.card_scheme_name 
              end CARD_TYPE
           , mtl.tid JETPAY_TRANS_ID
           , mtl.external_trans_nbr
           , mtl.trans_ref_data
      from acq_entity ae
      join mas_trans_log mtl on (mtl.posting_entity_id = ae.entity_id and mtl.institution_id = ae.institution_id)
	  join acct_accum_det aad on (aad.payment_seq_nbr = mtl.payment_seq_nbr and mtl.institution_id = aad.institution_id)
      join card_scheme cs on (cs.card_scheme = mtl.card_scheme)
      join entity_acct ea on (ea.entity_acct_id = mtl.entity_acct_id and ea.institution_id = mtl.institution_id)
      where (mtl.gl_date >= '$strt_dt' and mtl.gl_date < '$end_dt') 
        and mtl.tid in ('010003005101', '010003005102', '010003005104', '010003005201', '010003005202',
                        '010003005204', '010003005301', '010003005401', '010003010101', '010003010102',
                        '010003015101', '010003015102', '010003015201', '010003015210', '010003015301',
                        '010123005101', '010123005102', '010007050000','010003005141','010003005142')
        and mtl.settl_flag = 'Y'
        and ae.institution_id in ($instIds)) mtl
left outer join in_draft_main idm on (idm.trans_seq_nbr = mtl.external_trans_nbr)
left outer join in_draft_emc ide on (ide.trans_seq_nbr = mtl.external_trans_nbr)
left outer join visa_adn va on (va.trans_seq_nbr = mtl.external_trans_nbr)
left outer join in_draft_discover idd on (idd.trans_seq_nbr = mtl.external_trans_nbr)
left outer join precs_transaction_detail ptd on (ptd.arn = idm.arn)"

set mid               ""
set settleDate        ""
set authDate          ""
			 

set transRcdCurHandle [executeQuery $transRcdCur $clrHandle ]

puts $filePtr "ARN,AUTH_CODE,AUTH_DATE,CARD_NBR,CARD_TYPE,INTERCHANGE_CODE,JETPAY_TRANS_ID,LEGAL_NAME,MCC,MERCHANT_ID,MERCHANT_NAME,MID,MOTO,SETTLE_DATE,TRANS_AMOUNT,TRANS_TYPE"

set stats [dict create]

while {[orafetch $transRcdCurHandle -dataarray ds -indexbyname] != 1403} {

	if { ![dict exists $stats $ds(INSTITUTION_ID)] } {	
		dict set stats $ds(INSTITUTION_ID) SALE_CNT 0
		dict set stats $ds(INSTITUTION_ID) SALE_AMT 0
	} 
	
	switch $ds(TID) {
		"010003005101" -
		"010003005102" -
		"010003005104" -
		"010003005201" -
		"010003005202" -
		"010003005204" -
		"010123005101" -
		"010123005102" {
			dict set stats $ds(INSTITUTION_ID) SALE_CNT [expr 1 + [dict get $stats $ds(INSTITUTION_ID) SALE_CNT] ]
			dict set stats $ds(INSTITUTION_ID) SALE_AMT [expr $ds(TRANS_AMOUNT) + [dict get $stats $ds(INSTITUTION_ID) SALE_AMT] ]
		}
	}



   set arn               "$ds(ARN)"
   set authCode          "$ds(AUTH_CD)"
   set authDate          "$ds(AUTH_DATE)"
   set cardNbr           "$ds(CARD_NBR)"
   set cardType          "$ds(CARD_TYPE)"
   set interchangeCode   "$ds(INTERCHANGE_CODE)"
   set jetpayTransId     "$ds(JETPAY_TRANS_ID)"
   set legalName         "[string map {, " "} $ds(LEGAL_NAME)]"
   set mcc               "$ds(MCC)"
   set merchantId        "$ds(MERCHANT_ID)"
   set merchantName      "[string map {, " "} $ds(MERCHANT_NAME)]"
   set moto              "$ds(MOTO)"
   set settleDate        "$ds(SETTLE_DATE)"
   set transAmount       "$ds(TRANS_AMOUNT)"
   set transType         "$ds(TRANS_TYPE)"

   if { $arn != ""} {
     set authDataCur "select distinct mid
	                  , to_char(to_date(substr(SETTLE_DATE, 1, 8), 'yyyymmdd'), 'mm/dd/yyyy') SETTLE_DATE
	                  , to_char(to_date(substr(AUTHDATETIME, 1, 8), 'yyyymmdd'), 'mm/dd/yyyy') AUTH_DATE
          from tranhistory
				where arn = '$arn'"
	  
     set authCurHandle [executeQuery $authDataCur $authHandle ]
     if {[orafetch $authCurHandle -dataarray ds2 -indexbyname] != 1403} {
	    set mid               "$ds2(MID)"
	    set settleDate        "$ds2(SETTLE_DATE)"
	    set authDate          "$ds2(AUTH_DATE)"
     }
	 
	 if {$authDate == "" || $settleDate == ""} {
       set authCur "select to_char(proc_dt, 'mm/dd/yyyy') PROC_DT
             , to_char(settl_date, 'mm/dd/yyyy') SETTLE_DATE
        from precs_merchant_record_detail pmrd 
          ,  precs_transaction_detail td
        where pmrd.card_acceptor_id = '$merchantId'
          and pmrd.mh_rec_nbr = td.mh_rec_nbr 
          and td.arn = '$arn'"
	  	
       set authCurHandle [executeQuery $authCur $clrHandle2 ]
       if {[orafetch $authCurHandle -dataarray ds2 -indexbyname] != 1403} {
	      set authDate          "$ds2(PROC_DT)"
	      set settleDate        "$ds2(SETTLE_DATE)"
       }
    } 
  }

  set detailLine "\"$arn\","     
  if {$authCode != ""} {
    append detailLine "\"$authCode\""
  }
  append detailLine ",\"$authDate\""
  append detailLine ",\"$cardNbr\""
  append detailLine ",\"$cardType\""
  append detailLine ",\"$interchangeCode\""
  append detailLine ",\"$jetpayTransId\""
  append detailLine ",\"$legalName\""
  append detailLine ",\"$mcc\""
  append detailLine ",\"$merchantId\""
  append detailLine ",\"$merchantName\","
  if {$mid != ""} {
    append detailLine "\"$mid\""
  }
  append detailLine ",\"$moto\""
  append detailLine ",\"$settleDate\""
  append detailLine ",$transAmount" 
  append detailLine ",\"$transType\""
  
  puts $filePtr $detailLine
  
  flush $filePtr
}

close $filePtr

oraclose $transRcdCurHandle

writeLogRcd 0 "$programName.tcl - Completed successfully"

foreach inst [dict keys $stats] {
	puts "${inst} Sale CNT: [dict get $stats $inst SALE_CNT]"
	puts "${inst} Sale AMT: [dict get $stats $inst SALE_AMT]"

	writeLogRcd 0 "$argv0 Date: $transDate ${inst} Sale CNT: [dict get $stats $inst SALE_CNT]"
	writeLogRcd 0 "$argv0 Date: $transDate ${inst} Sale AMT: [dict get $stats $inst SALE_AMT]"
}

exit 0
