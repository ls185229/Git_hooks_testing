#!/usr/bin/tclsh
#/clearing/filemgr/.profile


################################################################################
#
#    File Name - create_1099K for INST 121 for year 2015
#
#    Description - Read the MASCLR db to build the 1099K records to be sent to 
#                  Merrick Bank
#
#    Arguments -c = config file
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
# $Id: $
# $Rev: $
# $Author: $
################################################################################


package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_clr_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set clrdb_username $env(IST_DB_USERNAME)
set clrdb_password $env(IST_DB_PASSWORD)
set authdb_username $env(ATH_DB_USERNAME)
set authdb_password $env(ATH_DB_PASSWORD)
set cur_loc $env(PWD)
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

    puts "Usage: -c configfile"
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
    global clrDBLogin authDBLogin rptFileMask cardScheme

    set clrDBLogin ""

    if {[catch {open $cfgFileName} filePtr]} {
		puts "File Open Err:$programName.tcl Cannot open config file $cfgFileName"
		exit 1
    }

    while { [set line [gets $filePtr]] != {}} {
	  set lineParms [split $line ,]
	  switch -exact -- [lindex  $lineParms 0] {
			"CLR_DB_LOGON" { 
				set clrDBLogin [lindex $lineParms 1]
			}
	     default {
			puts "Unknown config parameter [lindex $lineParms 0]"
	      }
	  }
    }

    close $filePtr

    if {$clrDBLogin == ""} {
		puts "Unable to find CLR_DB_LOGON params in $cfgFileName, exiting..."
		exit 2
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
    global createDate procDate version  encoding  xmlns  programName year instId month creditTids

    foreach {opt} [split $argv -] {
		switch -exact -- [lindex $opt 0] {
			"i" {
			   set instId [lrange $opt 1 end]
			    } 
		}
    }
    #### Verify the Arguments passed

    if {$instId == ""} {
		puts "ERR:Insufficient Arguments Passed"
		usage
		exit 2
    }

    #### Initialize the Database parameters
    initDB
    
    #### Initialize program varaiables
    set systemTime [clock seconds]
    set procDate "[clock format $systemTime -format %Y%m%d]"
    set createDate "[clock format $systemTime -format %Y%m%d%H%M%S]"

    set prevVisaBin ""
 	set year [string range $procDate 0 3]
	set month [string range $procDate 4 5]
        set year [expr {$year - 1}] 
	
##	if {$month == "01" || $month == "02"} {
##	   set year [expr {$year - 1}]
##	 }
	

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

    if {[catch {oraexec $handle} result]} {
		puts "SQL Err:$result"
		puts "$query"
		exit 3
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
    global prod_clr_db clrDBLogin authDBLogin prod_auth_db authHandle clrHandle clrHandle2 merchantInfoCur merchantTrans cardNotPresentCnt
    global clrdb_username
    global clrdb_password
    global authdb_username
    global authdb_password

    if {[catch {set authDBLoginHandle [oralogon $authdb_username/$authdb_password@$prod_auth_db]} result ] } {
                puts "$prod_auth_db login Err: $result "
                exit 3
    }

    if {[catch {set authHandle [oraopen $authDBLoginHandle]} result ]} {
                puts "Table access Err:$result"
                exit 3
    }



    if {[catch {set clrDBLoginHandle [oralogon $clrdb_username/$clrdb_password@$prod_clr_db]} result ] } {
                puts "$prod_clr_db login Err: $result "
                exit 3
    }



    if {[catch {set clrHandle [oraopen $clrDBLoginHandle]} result ]} {
                puts "Table access Err:$result"
                exit 3
    }

    if {[catch {set clrHandle2 [oraopen $clrDBLoginHandle]} result ]} {
                puts "Table access Err:$result"
                exit 3
    }


    set merchantInfoCur "select distinct ae.institution_id iso_id
               , trim(to_char(tax_id, '000000009')) tin
               , entity_dba_name nameline2
               , mc.phone1  phone
               , mc.phone_ext phoneext
               , entity_name nameline1
               , ma.address1 addr1
               , nvl(ma.address2, ' ') addr2
               , ma.city city
               , ma.prov_state_abbrev usstate
               , substr(ma.postal_cd_zip, 1, 5) as uszipcode
               , substr(ma.postal_cd_zip, 6, 9) as uszipext
               , null foreignstateorprovince
               , null foreignpostalcode
               , cntry_code_alpha2 countrycode
               , ae.entity_id  acctnumbermid
	       , default_mcc as merchantcategorycode
               , replace(ma.email_address, chr(38), chr(38)||'amp;') emailaddress
          from acq_entity ae
          join acq_entity_address aea on (aea.entity_id = ae.entity_id and aea.institution_id = ae.institution_id)
          join acq_entity_contact aec on (aec.entity_id = ae.entity_id and aec.institution_id = ae.institution_id)
          join master_address ma on (aea.address_id = ma.address_id and ma.institution_id = ae.institution_id)
          join master_contact mc on (aec.contact_id = mc.contact_id and mc.institution_id = ae.institution_id)
          join entity_to_auth eta on (eta.entity_id = ae.entity_id and eta.institution_id = ae.institution_id)
          join country c on (c.cntry_code = mc.cntry_code)
          where contact_role = 'DEF'
            and address_role = 'BIL'
            and (ae.entity_status = 'A'
               or ae.termination_date between to_date('01/01/2015', 'mm/dd/yyyy') and to_date('01/12/2015', 'mm/dd/yyyy'))
          	and ae.entity_level = 70 
            and ae.institution_id = :INST"

    oraparse $clrHandle $merchantInfoCur

	set creditTids "'010003005101', '010003005202', '010123005102', '010003005104'"

        set cardNotPresentCnt "select NVL(sum(amount), 0) cnp_count
                                  from tranhistory th inner join merchant_addenda_rt mar on th.MID = mar.MID
                                  where th.mid in(select mid from merchant where visa_id = :ENTITY)
                                    and ((th.card_present = '0') or (th.other_data2 not like '%CP:1%'))
                                    and th.settle_date between '20150101' and '20160101'
                                    and (mar.flags like '%w%' or (mar.flags not like '%w%' and th.card_type <> 'AX')) and th.request_type like '02%'"

    oraparse $authHandle $cardNotPresentCnt

	
	set merchantTrans "select posting_entity_id
                         , sum(JANPAYMENT)  JANPAYMENT
                    	 , sum(FEBPAYMENT)  FEBPAYMENT
                    	 , sum(MARPAYMENT)  MARPAYMENT
                    	 , sum(APRPAYMENT)  APRPAYMENT
                    	 , sum(MAYPAYMENT)  MAYPAYMENT
                    	 , sum(JUNPAYMENT)  JUNPAYMENT
                    	 , sum(JULPAYMENT)  JULPAYMENT
                    	 , sum(AUGPAYMENT)  AUGPAYMENT
                    	 , sum(SEPPAYMENT)  SEPPAYMENT
                    	 , sum(OCTPAYMENT)  OCTPAYMENT
                    	 , sum(NOVPAYMENT)  NOVPAYMENT
                    	 , sum(DECPAYMENT)  DECPAYMENT
                         , sum(JANCOUNT) JANCOUNT
                         , sum(FEBCOUNT) FEBCOUNT
                         , sum(MARCOUNT) MARCOUNT
                         , sum(APRCOUNT) APRCOUNT
                         , sum(MAYCOUNT) MAYCOUNT
                         , sum(JUNCOUNT) JUNCOUNT
                         , sum(JULCOUNT) JULCOUNT
                         , sum(AUGCOUNT) AUGCOUNT
                         , sum(SEPCOUNT) SEPCOUNT
                         , sum(OCTCOUNT) OCTCOUNT
                         , sum(NOVCOUNT) NOVCOUNT
                         , sum(DECCOUNT) DECCOUNT
                    from (select posting_entity_id
                         , nvl(decode(to_char(gl_date, 'mm'), '01', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) JANPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '02', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) FEBPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '03', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) MARPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '04', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) APRPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '05', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) MAYPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '06', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) JUNPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '07', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) JULPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '08', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) AUGPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '09', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) SEPPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '10', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) OCTPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '11', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) NOVPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '12', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) DECPAYMENT
                         , decode(to_char(gl_date, 'mm'), '01', 1, 0)  JANCOUNT
                         , decode(to_char(gl_date, 'mm'), '02', 1, 0)  FEBCOUNT
                         , decode(to_char(gl_date, 'mm'), '03', 1, 0)  MARCOUNT
                         , decode(to_char(gl_date, 'mm'), '04', 1, 0)  APRCOUNT
                         , decode(to_char(gl_date, 'mm'), '05', 1, 0)  MAYCOUNT
                         , decode(to_char(gl_date, 'mm'), '06', 1, 0)  JUNCOUNT
                         , decode(to_char(gl_date, 'mm'), '07', 1, 0)  JULCOUNT 
                         , decode(to_char(gl_date, 'mm'), '08', 1, 0)  AUGCOUNT
                         , decode(to_char(gl_date, 'mm'), '09', 1, 0)  SEPCOUNT
                         , decode(to_char(gl_date, 'mm'), '10', 1, 0)  OCTCOUNT
                         , decode(to_char(gl_date, 'mm'), '11', 1, 0)  NOVCOUNT
                         , decode(to_char(gl_date, 'mm'), '12', 1, 0)  DECCOUNT
                                        from mas_trans_log
                                        where institution_id = :INST
                                          and posting_entity_id = :ENTITY
                     	   	              and tid in ('010003005101', '010003005202', '010123005102', '010003005104')
                                        and to_char(gl_date, 'yyyy') = :YEAR)
                    					group by posting_entity_id"
 
    oraparse $clrHandle2 $merchantTrans 
}

################################################################################
#
#    Procedure Name - openOutputFile
#
#    Description - Open the 1099 output file
#                 
#    Return - NA
#
###############################################################################
proc openOutputFile {} {
    global filePtr instId createDate
    
    #### open output file
    
    set fileName [format "inst_121_1099K_%s.csv"  $createDate]
    
    if {[catch {open $fileName w} filePtr]} {
		puts "File Open Err:$programName.tcl Cannot open output file $fileName"
		exit 1
    }
}

##########
## MAIN ##
##########

init $argc $argv

puts "start $programName"

openOutputFile 

orabind $clrHandle :INST $instId

set merchantInfoCurHandle [executeQuery $merchantInfoCur $clrHandle ]

puts $filePtr "ISO_ID,FORM_TYPE,TIN,NAMELINE2,PHONE,PHONEEXT,NAMELINE1,ADDR1,ADDR2,CITY,USSTATE,USZIPCODE,USZIPEXT,FOREIGNSTATEORPROVINCE,FOREIGNPOSTALCODE,COUNTRYCODE,EMAILADDRESS,ACCTNUMBERMID,TOTALCARDNOTPRESENT,COUNTOFSALES,GROSSPAYMENTAMT,MERCHANTCATEGORYCODE,JANUARYPAYMENTS,FEBRUARYPAYMENTS,MARCHPAYMENTS,APRILPAYMENTS,MAYPAYMENTS,JUNEPAYMENTS,JULYPAYMENTS,AUGUSTPAYMENTS,SEPTEMBERPAYMENTS,OCTOBERPAYMENTS,NOVEMBERPAYMENTS,DECEMBERPAYMENTS"

while {[orafetch $merchantInfoCurHandle -dataarray ds -indexbyname] != 1403} {
   set iso_id                      "$ds(ISO_ID)"
   set form_type                   "1099K"
   set tin                         "$ds(TIN)"
   set nameline2                   "$ds(NAMELINE2)"
   set phone                       "$ds(PHONE)"
   set phoneext                    "$ds(PHONEEXT)"
   set nameline1                   "$ds(NAMELINE1)"
   set addr1                       "$ds(ADDR1)"
   set addr2                       "$ds(ADDR2)"
   set city                        "$ds(CITY)"
   set usstate                     "$ds(USSTATE)"
   set uszipcode                   "$ds(USZIPCODE)"
   set uszipext                    "$ds(USZIPEXT)"
   set foreignstateorprovince      "$ds(FOREIGNSTATEORPROVINCE)"
   set foreignpostalcode           "$ds(FOREIGNPOSTALCODE)"
   set countrycode                 "$ds(COUNTRYCODE)"
   set emailaddress                "$ds(EMAILADDRESS)"
   set acctnumbermid               "$ds(ACCTNUMBERMID)"
   set merchantcategorycode        "$ds(MERCHANTCATEGORYCODE)"

   set grossPaymentAmt 0
   set countTotal 0
 	  orabind $clrHandle2 :INST $instId :ENTITY $acctnumbermid :YEAR $year
          orabind $authHandle :ENTITY $acctnumbermid
#	  puts "Inst id: $instId, ENTITY: $acctnumbermid, YEAR: $year"

      set merchantSumCurHandle [executeQuery $merchantTrans $clrHandle2 ]
      if {[orafetch $merchantSumCurHandle -dataarray ds3 -indexbyname] != 1403} {
         set januaryPayments   "$ds3(JANPAYMENT)"
         set februaryPayments  "$ds3(FEBPAYMENT)"
         set marchPayments     "$ds3(MARPAYMENT)"
         set aprilPayments     "$ds3(APRPAYMENT)"
         set mayPayments       "$ds3(MAYPAYMENT)"
         set junePayments      "$ds3(JUNPAYMENT)"
         set julyPayments      "$ds3(JULPAYMENT)"
         set augustPayments    "$ds3(AUGPAYMENT)"
         set septemberPayments "$ds3(SEPPAYMENT)"
         set octoberPayments   "$ds3(OCTPAYMENT)"
         set novemberPayments  "$ds3(NOVPAYMENT)"
         set decemberPayments  "$ds3(DECPAYMENT)"
	         set  grossPaymentAmt $januaryPayments   
		 set  grossPaymentAmt [expr $grossPaymentAmt + $februaryPayments  ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $marchPayments     ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $aprilPayments     ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $mayPayments       ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $junePayments      ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $julyPayments      ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $augustPayments    ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $septemberPayments ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $octoberPayments   ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $novemberPayments  ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $decemberPayments  ]

         set januaryCount      "$ds3(JANCOUNT)"
         set februaryCount     "$ds3(FEBCOUNT)"
         set marchCount        "$ds3(MARCOUNT)"
         set aprilCount        "$ds3(APRCOUNT)"
         set mayCount          "$ds3(MAYCOUNT)"
         set juneCount         "$ds3(JUNCOUNT)"
         set julyCount         "$ds3(JULCOUNT)"
         set augustCount       "$ds3(AUGCOUNT)"
         set septemberCount    "$ds3(SEPCOUNT)"
         set octoberCount      "$ds3(OCTCOUNT)"
         set novemberCount     "$ds3(NOVCOUNT)"
         set decemberCount     "$ds3(DECCOUNT)"
                 set  countTotal $januaryCount
                 set  countTotal [expr $countTotal + $februaryCount  ]
                 set  countTotal [expr $countTotal + $marchCount     ]
                 set  countTotal [expr $countTotal + $aprilCount     ]
                 set  countTotal [expr $countTotal + $mayCount       ]
                 set  countTotal [expr $countTotal + $juneCount      ]
                 set  countTotal [expr $countTotal + $julyCount      ]
                 set  countTotal [expr $countTotal + $augustCount    ]
                 set  countTotal [expr $countTotal + $septemberCount ]
                 set  countTotal [expr $countTotal + $octoberCount   ]
                 set  countTotal [expr $countTotal + $novemberCount  ]
                 set  countTotal [expr $countTotal + $decemberCount  ]
    }

	if {$grossPaymentAmt != 0} {
          set cnp_cnt 0
          set cardNotPresentCntrHandle [executeQuery $cardNotPresentCnt $authHandle ]
              if {[orafetch $cardNotPresentCntrHandle -dataarray ds4 -indexbyname] != 1403} {
                  set cnp_cnt     "$ds4(CNP_COUNT)"
              }
              if { $cnp_cnt > $grossPaymentAmt } {
                     set cnp_cnt  $grossPaymentAmt
              }
	  set detailLine "\"$iso_id\",\"$form_type\",\"$tin\",\"$nameline2\",\"$phone\",\"$phoneext\",\"$nameline1\",\"$addr1\",\"$addr2\",\"$city\",\"$usstate\",\"$uszipcode\",\"$uszipext\",\"$foreignstateorprovince\",\"$foreignpostalcode\",\"$countrycode\",\"$emailaddress\",\"$acctnumbermid\","
          append detailLine "$cnp_cnt,"
	  append detailLine "$countTotal,"
          append detailLine "$grossPaymentAmt,"
	  append detailLine "$merchantcategorycode," 
	  append detailLine "$januaryPayments,"
	  append detailLine "$februaryPayments,"
	  append detailLine "$marchPayments,"
	  append detailLine "$aprilPayments,"
	  append detailLine "$mayPayments,"
	  append detailLine "$junePayments,"
	  append detailLine "$julyPayments,"
	  append detailLine "$augustPayments,"    
	  append detailLine "$septemberPayments,"
	  append detailLine "$octoberPayments,"
	  append detailLine "$novemberPayments,"
	  append detailLine "$decemberPayments,"
      puts $filePtr $detailLine
    }
 
	flush $filePtr
}

close $filePtr

oraclose $merchantSumCurHandle
oraclose $merchantInfoCurHandle
oraclose $cardNotPresentCntrHandle
exit 0	  
