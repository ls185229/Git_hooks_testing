#!/usr/bin/env tclsh
#/clearing/filemgr/.profile


################################################################################
#
#    File Name - create_1099K
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
# $Id: create_OKDMV_1099K_file-0101-0530.tcl 4012 2017-01-06 18:13:25Z millig $
# $Rev: 4012 $
# $Author: millig $
################################################################################


package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_clr_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
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
			"c" {
			   set cfgFile [lrange $opt 1 end] 
			    } 
			"i" {
			   set instId [lrange $opt 1 end]
			    } 
		}
    }
    #### Verify the Arguments passed

    if {$cfgFile == ""} {
		puts "ERR:Insufficient Arguments Passed"
		usage
		exit 2
    }
    #### Read the Config File 
    readCfgFile $cfgFile 

    #### Initialize the Database parameters
    initDB
    
    #### Initialize program varaiables
    set systemTime [clock seconds]
    set procDate "[clock format $systemTime -format %Y%m%d]"

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
    global prod_clr_db clrDBLogin authDBLogin prod_auth_db clrHandle clrHandle2 merchantInfoCur merchantTrans

    if {[catch {set clrDBLoginHandle [oralogon $clrDBLogin@$prod_clr_db]} result ] } {
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

    set merchantInfoCur "select distinct institution_id iso_id
               , trim(to_char(tax_id, '000000009')) tin
               , entity_dba_name nameline2
               , phone1  phone
               , phone_ext phoneext
               , entity_name nameline1
               ,null uszipext
               , null foreignstateorprovince
               , null foreignpostalcode
               , ae.entity_id  acctnumbermid
			   , default_mcc as merchantcategorycode
          from acq_entity ae
          join acq_entity_contact aec on (aec.entity_id = ae.entity_id and aec.institution_id = ae.institution_id)
          join master_contact mc on (aec.contact_id = mc.contact_id and mc.institution_id = ae.institution_id)
          join entity_to_auth eta on (eta.entity_id = ae.entity_id and eta.institution_id = ae.institution_id)
          where contact_role = 'DEF'
            and ae.entity_id like '45404547777%'
            and (ae.entity_status = 'A'
               or ae.termination_date between to_date('01/01/2013', 'mm/dd/yyyy') and to_date('01/29/2014', 'mm/dd/yyyy'))
          	and ae.entity_level = 70 
            and ae.institution_id = :INST"

    oraparse $clrHandle $merchantInfoCur

	set creditTids "'010003005101', '010003005202', '010123005102', '010003005104'"
	
	set merchantTrans "select posting_entity_id
                    	 , sum(JANPAYMENT)  JANPAYMENT
                    	 , sum(FEBPAYMENT)  FEBPAYMENT
                    	 , sum(MARPAYMENT)  MARPAYMENT
                    	 , sum(APRPAYMENT)  APRPAYMENT
                    	 , sum(MAYPAYMENT)  MAYPAYMENT
                         , sum(JANCOUNT) JANCOUNT
                         , sum(FEBCOUNT) FEBCOUNT
                         , sum(MARCOUNT) MARCOUNT
                         , sum(APRCOUNT) APRCOUNT
                         , sum(MAYCOUNT) MAYCOUNT
                    from (select posting_entity_id
                         , nvl(decode(to_char(gl_date, 'mm'), '01', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) JANPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '02', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) FEBPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '03', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) MARPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '04', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) APRPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '05', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) MAYPAYMENT
                         , decode(to_char(gl_date, 'mm'), '01', 1, 0)  JANCOUNT
                         , decode(to_char(gl_date, 'mm'), '02', 1, 0)  FEBCOUNT
                         , decode(to_char(gl_date, 'mm'), '03', 1, 0)  MARCOUNT
                         , decode(to_char(gl_date, 'mm'), '04', 1, 0)  APRCOUNT
                         , decode(to_char(gl_date, 'mm'), '05', 1, 0)  MAYCOUNT
                                        from mas_trans_log
                                        where institution_id = :INST
                                          and posting_entity_id = :ENTITY 
                     	   	              and tid in ('010003005101', '010003005202', '010123005102', '010003005104')
                                           and (gl_date >= '01-JAN-13' and gl_date < '31-MAY-13'))
                    					group by posting_entity_id"
 
    oraparse $clrHandle2 $merchantTrans
}

################################################################################
#
#    Procedure Name - openOutputFile
#
#    Description - Open the AMMF output file
#                 
#    Return - NA
#
###############################################################################
proc openOutputFile {} {
    global filePtr instId
    
    #### open output file
    
    set fileName "OKDMV_1099K_01012013-05302013.csv"
    
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

puts $filePtr "ISO_ID,FORM_TYPE,TIN,NAMELINE2,PHONE,PHONEEXT,NAMELINE1,ADDR1,ADDR2,CITY,USSTATE,USZIPCODE,USZIPEXT,FOREIGNSTATEORPROVINCE,FOREIGNPOSTALCODE,COUNTRYCODE,EMAILADDRESS,ACCTNUMBERMID,COUNTOFSALES,GROSSPAYMENTAMT,MERCHANTCATEGORYCODE,JANUARYPAYMENTS,FEBRUARYPAYMENTS,MARCHPAYMENTS,APRILPAYMENTS,MAYPAYMENTS,JUNEPAYMENTS,JULYPAYMENTS,AUGUSTPAYMENTS,SEPTEMBERPAYMENTS,OCTOBERPAYMENTS,NOVEMBERPAYMENTS,DECEMBERPAYMENTS"

while {[orafetch $merchantInfoCurHandle -dataarray ds -indexbyname] != 1403} {
   set iso_id                      "$ds(ISO_ID)"
   set form_type                   "1099K"
   set tin                         "$ds(TIN)"
   set nameline2                   "$ds(NAMELINE2)"
   set phone                       "$ds(PHONE)"
   set phoneext                    "$ds(PHONEEXT)"
   set nameline1                   "$ds(NAMELINE1)"
   set addr1                       "Oklahoma Tax Commission"
   set addr2                       "P.O. Box 269061"
   set city                        "Oklahoma City"
   set usstate                     "OK"
   set uszipcode                   "73126"
   set uszipext                    "$ds(USZIPEXT)"
   set foreignstateorprovince      "$ds(FOREIGNSTATEORPROVINCE)"
   set foreignpostalcode           "$ds(FOREIGNPOSTALCODE)"
   set countrycode                 "US"
   set emailaddress                "otcmaster@tax.ok.gov"
   set acctnumbermid               "$ds(ACCTNUMBERMID)"
   set merchantcategorycode        "$ds(MERCHANTCATEGORYCODE)"

   set grossPaymentAmt 0
   set countTotal 0
 	  orabind $clrHandle2 :INST $instId :ENTITY $acctnumbermid 
#	  puts "Inst id: $instId, ENTITY: $acctnumbermid, YEAR: $year"

      set merchantSumCurHandle [executeQuery $merchantTrans $clrHandle2 ]
      if {[orafetch $merchantSumCurHandle -dataarray ds3 -indexbyname] != 1403} {
         set januaryPayments   "$ds3(JANPAYMENT)"
         set februaryPayments  "$ds3(FEBPAYMENT)"
         set marchPayments     "$ds3(MARPAYMENT)" 
         set aprilPayments     "$ds3(APRPAYMENT)" 
         set mayPayments       "$ds3(MAYPAYMENT)"
         set junePayments      "0"
         set julyPayments      "0"
         set augustPayments    "0"
         set septemberPayments "0"
         set octoberPayments   "0"
         set novemberPayments  "0"
         set decemberPayments  "0"
	     set  grossPaymentAmt $januaryPayments    
		 set  grossPaymentAmt [expr $grossPaymentAmt + $februaryPayments   ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $marchPayments      ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $aprilPayments      ]
		 set  grossPaymentAmt [expr $grossPaymentAmt + $mayPayments        ]

         set januaryCount          "$ds3(JANCOUNT)"
         set februaryCount         "$ds3(FEBCOUNT)"
         set marchCount            "$ds3(MARCOUNT)"
         set aprilCount            "$ds3(APRCOUNT)"
         set mayCount              "$ds3(MAYCOUNT)"
                 set  countTotal $januaryCount
                 set  countTotal [expr $countTotal + $februaryCount   ]
                 set  countTotal [expr $countTotal + $marchCount      ]
                 set  countTotal [expr $countTotal + $aprilCount      ]
                 set  countTotal [expr $countTotal + $mayCount        ]
    }

	if {$grossPaymentAmt != 0} {
	  set detailLine "\"$iso_id\",\"$form_type\",\"$tin\",\"$nameline2\",\"$phone\",\"$phoneext\",\"$nameline1\",\"$addr1\",\"$addr2\",\"$city\",\"$usstate\",\"$uszipcode\",\"$uszipext\",\"$foreignstateorprovince\",\"$foreignpostalcode\",\"$countrycode\",\"$emailaddress\",\"$acctnumbermid\","
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

exit 0	  
