#!/usr/bin/env tclsh
#/clearing/filemgr/.profile


################################################################################
#
#    File Name - 
#
#    Description - 
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
#    Note - The original code was modified to meet the needs of 2012 1099K format.
#           The select query was corrected to get the merchants that were
#           terminated or scheduled to terminate next year but had volumnes 
#           for the year the 1099 is generated.
#
################################################################################
# $Id: create_1099K_file_IPPAY_new.tcl 4012 2017-01-06 18:13:25Z millig $
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
    global createDate procDate version  encoding  xmlns  programName year instId month creditTids institutionIds

    foreach {opt} [split $argv -] {
		switch -exact -- [lindex $opt 0] {
			"c" {
			   set cfgFile [lrange $opt 1 end] 
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
	set creditTids "'010003005101', '010003005202', '010123005102', '010003005104'"
	
	if {$month == "01" || $month == "02" } {
	   set year [expr {$year - 1}]
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
 

 set merchantInfoCur "select distinct trim(to_char(tax_id, '000000009')) tin
               , substr(entity_dba_name, 1, 40)                 nameline2
               , phone1                                      phone
               , phone_ext                                   phoneext
               , contact_id
               , substr(entity_name, 1, 40)                  nameline1
               , address1                                    addr1
               , address2                                    addr2
               , city                                        city
               , trim(decode(cntry_code, '840', prov_state_abbrev, ' '))            usstate
               , trim(decode(cntry_code, '840', substr(postal_cd_zip, 1, 5), ' '))  uszipcode
               , trim(decode(cntry_code, '840', ' ', prov_state_abbrev))            foreignstateorprovince
               , trim(decode(cntry_code, '840', ' ', substr(postal_cd_zip, 1, 5)))  foreignpostalcode
               , ae.entity_id                               acctnumbermid
               , trim(default_mcc)                          merchantcategorycode
               , replace(email_address, chr(38), chr(38)||'amp;') emailaddress
               , ae.institution_id
          from acq_entity ae
          join acq_entity_address aea on (aea.entity_id = ae.entity_id and aea.institution_id = ae.institution_id)
          join acq_entity_contact aec on (aec.entity_id = ae.entity_id and aec.institution_id = ae.institution_id)
          join master_address ma on (aea.address_id = ma.address_id and ma.institution_id = ae.institution_id)
          join master_contact mc on (aec.contact_id = mc.contact_id and mc.institution_id = ae.institution_id)
          join entity_to_auth eta on (eta.entity_id = ae.entity_id and eta.institution_id = ae.institution_id)
          join country c on (c.cntry_code = mc.cntry_code)
          where contact_role = 'DEF'
            and address_role = 'BIL'
            and (ae.entity_id like '45404527400%' or ae.entity_id like '45404547400%')
             and (ae.entity_status = 'A'
                or ae.termination_date between to_date('01/01/2013', 'mm/dd/yyyy') and to_date('01/20/2014', 'mm/dd/yyyy'))
                and ae.entity_level = 70
            and ae.institution_id in ('107')"

    oraparse $clrHandle $merchantInfoCur

        set creditTids "'010003005101', '010003005202', '010123005102', '010003005104'"

        set merchantTrans "select posting_entity_id
                         , sum(MAYPAYMENT)  MAYPAYMENT
                         , sum(JUNPAYMENT)  JUNPAYMENT
                         , sum(JULPAYMENT)  JULPAYMENT
                         , sum(AUGPAYMENT)  AUGPAYMENT
                         , sum(SEPPAYMENT)  SEPPAYMENT
                         , sum(OCTPAYMENT)  OCTPAYMENT
                         , sum(NOVPAYMENT)  NOVPAYMENT
                         , sum(DECPAYMENT)  DECPAYMENT
                         , sum(MAYCOUNT) MAYCOUNT
                         , sum(JUNCOUNT) JUNCOUNT
                         , sum(JULCOUNT) JULCOUNT
                         , sum(AUGCOUNT) AUGCOUNT
                         , sum(SEPCOUNT) SEPCOUNT
                         , sum(OCTCOUNT) OCTCOUNT
                         , sum(NOVCOUNT) NOVCOUNT
                         , sum(DECCOUNT) DECCOUNT
                    from (select posting_entity_id
                         , nvl(decode(to_char(gl_date, 'mm'), '05', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) MAYPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '06', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) JUNPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '07', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) JULPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '08', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) AUGPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '09', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) SEPPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '10', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) OCTPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '11', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) NOVPAYMENT
                         , nvl(decode(to_char(gl_date, 'mm'), '12', amt_billing * decode(tid_settl_method, 'D', -1, 1), 0), 0) DECPAYMENT
                         , decode(to_char(gl_date, 'mm'), '05', 1, 0)  MAYCOUNT
                         , decode(to_char(gl_date, 'mm'), '06', 1, 0)  JUNCOUNT
                         , decode(to_char(gl_date, 'mm'), '07', 1, 0)  JULCOUNT
                         , decode(to_char(gl_date, 'mm'), '08', 1, 0)  AUGCOUNT
                         , decode(to_char(gl_date, 'mm'), '09', 1, 0)  SEPCOUNT
                         , decode(to_char(gl_date, 'mm'), '10', 1, 0)  OCTCOUNT
                         , decode(to_char(gl_date, 'mm'), '11', 1, 0)  NOVCOUNT
                         , decode(to_char(gl_date, 'mm'), '12', 1, 0)  DECCOUNT
                                        from mas_trans_log
                                        where institution_id = '107'
                                         and posting_entity_id = :ENTITY
                                              and tid in ('010003005101', '010003005202', '010123005102', '010003005104')
                                        and (gl_date >= '31-MAY-13' and gl_date < '01-JAN-14'))
                                                        group by posting_entity_id"

    oraparse $clrHandle2 $merchantTrans

}

################################################################################
#
#    Procedure Name - openOutputFile
#
#    Description - 
#                 
#    Return - NA
#
###############################################################################
proc openOutputFile {} {
    global filePtr year
    
    #### open output file
       set fileName "IPPAY_1099K_20140122.csv" 
    
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

orabind $clrHandle

set merchantInfoCurHandle [executeQuery $merchantInfoCur $clrHandle ]

set TYPE_OF_FILER_IND "1"
set TRANS_REP_IND  "2"
set PSE_NAME_TELEPHONE "JETPAY LLC 9725038900"


puts $filePtr "Correction,RecipientTaxID,AccountNum,ForeignCountry,Recipient Name1,Recipient Name2,Address1,City,State,ZipCode,EmailAddress,TypeOfFilerInd,PSENameAndTelNumber,TransRepInd,CountOfSales,BOX1,BOX2,BOX3,BOX5a,BOX5b,BOX5c,BOX5d,BOX5e,BOX5f,BOX5g,BOX5h,BOX5i,BOX5j,BOX5k,BOX5l"

while {[orafetch $merchantInfoCurHandle -dataarray ds -indexbyname] != 1403} {
   set EE_TIN                           "$ds(TIN)"
   set EE_NameLine2                     "$ds(NAMELINE2)"
   set EE_Phone                         "$ds(PHONE)"
   set EE_AssociationName               "$ds(NAMELINE1)"
   set EE_Addr1                         "$ds(ADDR1)"
   set EE_Addr2                         "$ds(ADDR2)"
   set EE_City                          "$ds(CITY)"
   set EE_USState                       "$ds(USSTATE)"
   set EE_USZipCode                     "$ds(USZIPCODE)"
   set EE_ForeignStateOrProvince        "$ds(FOREIGNSTATEORPROVINCE)"
   set EE_ForeignPostalCode             "$ds(FOREIGNPOSTALCODE)"
   set Form1099K_AcctNumber             "$ds(ACCTNUMBERMID)"
   set Form1099K_MerchantCategoryCode   "$ds(MERCHANTCATEGORYCODE)"
   set emailaddress                     "$ds(EMAILADDRESS)"
   set instId                           "$ds(INSTITUTION_ID)"

   set Form1099K_GrossPaymentAmt 0
   set countTotal 0

    orabind $clrHandle2 :ENTITY $Form1099K_AcctNumber

       set merchantSumCurHandle [executeQuery $merchantTrans $clrHandle2 ]
       if {[orafetch $merchantSumCurHandle -dataarray ds3 -indexbyname] != 1403} {
            set Form1099K_JanuaryPayments     "0"
            set Form1099K_FebruaryPayments    "0"
            set Form1099K_MarchPayments       "0"
            set Form1099K_AprilPayments       "0"
            set Form1099K_MayPayments         "$ds3(MAYPAYMENT)"
            set Form1099K_JunePayments        "$ds3(JUNPAYMENT)"
            set Form1099K_JulyPayments        "$ds3(JULPAYMENT)"
            set Form1099K_AugustPayments      "$ds3(AUGPAYMENT)"
            set Form1099K_SeptemberPayments   "$ds3(SEPPAYMENT)"
            set Form1099K_OctoberPayments     "$ds3(OCTPAYMENT)"
            set Form1099K_NovemberPayments    "$ds3(NOVPAYMENT)"
            set Form1099K_DecemberPayments    "$ds3(DECPAYMENT)"
                 set  Form1099K_GrossPaymentAmt $Form1099K_MayPayments
                 set  Form1099K_GrossPaymentAmt [expr $Form1099K_GrossPaymentAmt + $Form1099K_JunePayments       ]
                 set  Form1099K_GrossPaymentAmt [expr $Form1099K_GrossPaymentAmt + $Form1099K_JulyPayments       ]
                 set  Form1099K_GrossPaymentAmt [expr $Form1099K_GrossPaymentAmt + $Form1099K_AugustPayments     ]
                 set  Form1099K_GrossPaymentAmt [expr $Form1099K_GrossPaymentAmt + $Form1099K_SeptemberPayments  ]
                 set  Form1099K_GrossPaymentAmt [expr $Form1099K_GrossPaymentAmt + $Form1099K_OctoberPayments    ]
                 set  Form1099K_GrossPaymentAmt [expr $Form1099K_GrossPaymentAmt + $Form1099K_NovemberPayments   ]
                 set  Form1099K_GrossPaymentAmt [expr $Form1099K_GrossPaymentAmt + $Form1099K_DecemberPayments   ]

            set mayCount          "$ds3(MAYCOUNT)"
            set juneCount         "$ds3(JUNCOUNT)"
            set julyCount         "$ds3(JULCOUNT)"
            set augustCount       "$ds3(AUGCOUNT)"
            set septemberCount    "$ds3(SEPCOUNT)"
            set octoberCount      "$ds3(OCTCOUNT)"
            set novemberCount     "$ds3(NOVCOUNT)"
            set decemberCount     "$ds3(DECCOUNT)"
                 set  countTotal $mayCount
                 set  countTotal [expr $countTotal + $juneCount      ]
                 set  countTotal [expr $countTotal + $julyCount      ]
                 set  countTotal [expr $countTotal + $augustCount    ]
                 set  countTotal [expr $countTotal + $septemberCount ]
                 set  countTotal [expr $countTotal + $octoberCount   ]
                 set  countTotal [expr $countTotal + $novemberCount  ]
                 set  countTotal [expr $countTotal + $decemberCount  ]

    }

	if {$Form1099K_GrossPaymentAmt != 0} {
      set detailLine ","
      set detailLine "$detailLine$EE_TIN,"
      set detailLine "$detailLine$Form1099K_AcctNumber,"
      set detailLine "$detailLine,"
      set detailLine "$detailLine\"$EE_AssociationName\","
      set detailLine "$detailLine\"$EE_NameLine2\","
      set detailLine "$detailLine\"$EE_Addr1\","
      set detailLine "$detailLine$EE_City,"
      set detailLine "$detailLine$EE_USState,"
      set detailLine "$detailLine$EE_USZipCode,"
      set detailLine "$detailLine$emailaddress,"
      set detailLine "$detailLine$TYPE_OF_FILER_IND,"
      set detailLine "$detailLine$PSE_NAME_TELEPHONE,"
      set detailLine "$detailLine$TRANS_REP_IND,"
      set detailLine "$detailLine$countTotal,"
      set detailLine "$detailLine$Form1099K_GrossPaymentAmt,"
      set detailLine "$detailLine$Form1099K_MerchantCategoryCode,"
      set detailLine "$detailLine,"
      set detailLine "$detailLine$Form1099K_JanuaryPayments,"
      set detailLine "$detailLine$Form1099K_FebruaryPayments,"
      set detailLine "$detailLine$Form1099K_MarchPayments,"
      set detailLine "$detailLine$Form1099K_AprilPayments,"
      set detailLine "$detailLine$Form1099K_MayPayments,"
      set detailLine "$detailLine$Form1099K_JunePayments,"
      set detailLine "$detailLine$Form1099K_JulyPayments,"
      set detailLine "$detailLine$Form1099K_AugustPayments,"
      set detailLine "$detailLine$Form1099K_SeptemberPayments,"
      set detailLine "$detailLine$Form1099K_OctoberPayments,"
      set detailLine "$detailLine$Form1099K_NovemberPayments,"
      set detailLine "$detailLine$Form1099K_DecemberPayments"
      
      puts $filePtr $detailLine
    }
	flush $filePtr
}

close $filePtr

oraclose $merchantSumCurHandle
oraclose $merchantInfoCurHandle

exit 0	  
