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
# $Id: create_1099K_file_105.tcl 4012 2017-01-06 18:13:25Z millig $
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
	set institutionIds "'105'"
	
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

    if {[catch {orasql $handle $query} result]} {
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
    global prod_clr_db clrHandle clrHandle2

    if {[catch {set clrDBLoginHandle [oralogon masclr/masclr@$prod_clr_db]} result ] } {
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
       set fileName [format "JetPay_1099K_for_%4i.csv"  $year]
    
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
             and (ae.entity_status = 'A'
                or ae.termination_date between to_date('01/01/$year', 'mm/dd/yyyy') and to_date('$procDate', 'YYYYMMDD')) 
          	and ae.entity_level = 70 
            and ae.institution_id in ($institutionIds)
			and substr(parent_entity_id, 1, 6) <> '440339'
			and ae.entity_id not in ('475076100000310',
'402529294250040',
'402529294250026',
'402529294250033',
'402529294250152',
'402529294250055',
'402529294250042',
'402529294250041',
'447474400000322')"
			
set merchantInfoCurHandle [executeQuery $merchantInfoCur $clrHandle ]

###puts $filePtr "UniqueFormKey,FormName,ER_TIN,ER_TypeOfTIN,ERC_Name1,ERC_Addr1,ERC_Addr2,ERC_City,ERC_USState,ERC_USZipCode,ERC_Phone,EE_TIN,EE_TypeOfTIN,EE_NameLine2,EE_Phone,EE_AssociationName,EE_Addr1,EE_Addr2,EE_City,EE_USState,EE_USZipCode,EE_ForeignStateOrProvince,EE_ForeignPostalCode,Form1099K_AcctNumber,Form1099K_Filer_PSE_EPF_TPP,Form1099K_PSEName,Form1099K_PSETelephone,Form1099K_MerchCardOrThirdPartyGrossPaymentAmt,Form1099K_MerchantCategoryCode,Form1099K_JanuaryPayments,Form1099K_FebruaryPayments,Form1099K_MarchPayments,Form1099K_AprilPayments,Form1099K_MayPayments,Form1099K_JunePayments,Form1099K_JulyPayments,Form1099K_AugustPayments,Form1099K_SeptemberPayments,Form1099K_OctoberPayments,Form1099K_NovemberPayments,Form1099K_DecemberPayments"
###set UniqueFormKey                0
###set FormName                     "Form1099K"
###set ER_TIN                       "320116054"
###set ER_TypeOfTIN                 "E"
###set ERC_Name1                    "Meridian Bank"
###set ERC_Addr1                    "92 Lancaster Ave"
###set ERC_Addr2                    "Suite 180"
###set ERC_City                     "Devon"
###set ERC_USState                  "PA"
###set ERC_USZipCode                "19333"
###set ERC_Phone                    "9725038900"
###set Form1099K_Filer_PSE_EPF_TPP  "PSE"
###set Form1099K_PSEName            "JETPAY LLC"
###set Form1099K_PSETelephone       "9725038900" 
###set EE_TypeOfTIN                 "U"

##T-1
puts $filePtr "Merch Number,Corp Name,Merch DBA Name,Address1,Address2,City,State,Zip,Phone_number,Fed_Tax id FEIN,MCC Code,January-$year Volume,February-$year Volume,March-$year Volume,April-$year Volume,May-$year Volume,June-$year Volume,July-$year Volume,August-$year Volume,September-$year Volume,October-$year Volume,November-$year Volume,December-$year Volume,YTD Total-$year Volume,Email address"

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
   set instId                           "$ds(INSTITUTION_ID)"
   
    ###set sqlStmt "select trim(to_char(nvl(sum(amt_billing), 0), '99999999.99')) GROSSPAYMENTAMT
    ###             from mas_trans_log
    ###             where institution_id = '$instId'
    ###               and posting_entity_id = '$Form1099K_AcctNumber'
    ###	   	           and tid in ($creditTids)
    ###               and gl_date between to_date('01/01/$year', 'mm/dd/yyyy') and to_date('12/31/$year', 'mm/dd/yyyy')"

    set sqlStmt "select sum(amt_billing) GROSSPAYMENTAMT
                 from mas_trans_log
                 where institution_id = '$instId'
                   and posting_entity_id = '$Form1099K_AcctNumber'
                           and tid in ($creditTids)
                   and gl_date between to_date('01/01/$year', 'mm/dd/yyyy') and to_date('12/31/$year', 'mm/dd/yyyy')"
       
    set merchantSumCurHandle [executeQuery $sqlStmt $clrHandle2 ]

    if {[orafetch $merchantSumCurHandle -dataarray ds3 -indexbyname] != 1403} {
      set Form1099K_GrossPaymentAmt   "$ds3(GROSSPAYMENTAMT)"
      ###puts "T-1 Merchant-$Form1099K_AcctNumber, Form1099K_GrossPaymentAmt-$Form1099K_GrossPaymentAmt"
    }
 
    for {set iMonth 1} {$iMonth <= 12} {incr iMonth} {
       set sqlStmt "select trim(to_char(nvl(sum(amt_billing), 0), '99999999.99')) Payments
                    from mas_trans_log
                    where institution_id = '$instId'
                      and posting_entity_id = '$Form1099K_AcctNumber'
 	   	              and tid in ($creditTids)
                      and gl_date between to_date(to_char($iMonth, '09')||'/01/$year', 'mm/dd/yyyy') and last_day(to_date(to_char($iMonth, '09')||'/01/$year', 'mm/dd/yyyy'))" 

       set merchantSumCurHandle [executeQuery $sqlStmt $clrHandle2 ]
       if {[orafetch $merchantSumCurHandle -dataarray ds3 -indexbyname] != 1403} {
	     case $iMonth {
	          1  { set Form1099K_JanuaryPayments     "$ds3(PAYMENTS)" }
              2  { set Form1099K_FebruaryPayments    "$ds3(PAYMENTS)" }
              3  { set Form1099K_MarchPayments       "$ds3(PAYMENTS)" }
              4  { set Form1099K_AprilPayments       "$ds3(PAYMENTS)" }
              5  { set Form1099K_MayPayments         "$ds3(PAYMENTS)" }
              6  { set Form1099K_JunePayments        "$ds3(PAYMENTS)" }
              7  { set Form1099K_JulyPayments        "$ds3(PAYMENTS)" }
              8  { set Form1099K_AugustPayments      "$ds3(PAYMENTS)" }
              9  { set Form1099K_SeptemberPayments   "$ds3(PAYMENTS)" }
              10 { set Form1099K_OctoberPayments     "$ds3(PAYMENTS)" }
              11 { set Form1099K_NovemberPayments    "$ds3(PAYMENTS)" }
              12 { set Form1099K_DecemberPayments    "$ds3(PAYMENTS)" }
	     }
	   }
    }
	if {$Form1099K_GrossPaymentAmt != 0} {
      ### set detailLine "$UniqueFormKey,"
      ###set detailLine "$detailLine$FormName,"
      ###set detailLine "$detailLine$ER_TIN,"
      ###set detailLine "$detailLine$ER_TypeOfTIN,"
      ###set detailLine "$detailLine[string toupper $ERC_Name1],"
      ###set detailLine "$detailLine$ERC_Addr1,"
      ###set detailLine "$detailLine$ERC_Addr2,"
      ###set detailLine "$detailLine$ERC_City,"
      ###set detailLine "$detailLine$ERC_USState,"
      ###set detailLine "$detailLine$ERC_USZipCode,"
      ###set detailLine "$detailLine$ERC_Phone,"
      ###set detailLine "$detailLine$EE_TIN,"
      ###set detailLine "$detailLine$EE_TypeOfTIN,"
      ###set detailLine "$detailLine\"$EE_NameLine2\","
      ###set detailLine "$detailLine$EE_Phone,"
      ###set detailLine "$detailLine\"$EE_AssociationName\","
      ###set detailLine "$detailLine\"$EE_Addr1\","
      ###if {$EE_Addr2 == ""} {
         ###set detailLine "$detailLine,"
      ###} else {
        ###set detailLine "$detailLine\"$EE_Addr2\","
      ###}
      ###set detailLine "$detailLine$EE_ForeignStateOrProvince,"
      ###set detailLine "$detailLine$EE_ForeignPostalCode,"
      ###set detailLine "$detailLine$Form1099K_AcctNumber,"
      ###set detailLine "$detailLine$Form1099K_Filer_PSE_EPF_TPP,"
      ###set detailLine "$detailLine$Form1099K_PSEName,"
      ###set detailLine "$detailLine$Form1099K_PSETelephone,"
      ###set detailLine "$detailLine$Form1099K_GrossPaymentAmt,"
      ###set detailLine "$detailLine$Form1099K_MerchantCategoryCode,"
      ###set detailLine "$detailLine$Form1099K_JanuaryPayments,"
      ###set detailLine "$detailLine$Form1099K_FebruaryPayments,"
      ###set detailLine "$detailLine$Form1099K_MarchPayments,"
      ###set detailLine "$detailLine$Form1099K_AprilPayments,"
      ###set detailLine "$detailLine$Form1099K_MayPayments,"
      ###set detailLine "$detailLine$Form1099K_JunePayments,"
      ###set detailLine "$detailLine$Form1099K_JulyPayments,"
      ###set detailLine "$detailLine$Form1099K_AugustPayments,"
      ###set detailLine "$detailLine$Form1099K_SeptemberPayments,"
      ###set detailLine "$detailLine$Form1099K_OctoberPayments,"
      ###set detailLine "$detailLine$Form1099K_NovemberPayments,"
      ###set detailLine "$detailLine$Form1099K_DecemberPayments"
      ###puts $filePtr $detailLine
      ###set UniqueFormKey "[expr $UniqueFormKey + 1]"


      ###T-1
      set detailLine "$Form1099K_AcctNumber,"
      set detailLine "$detailLine\"$EE_AssociationName\","
      set detailLine "$detailLine\"$EE_NameLine2\","
      set detailLine "$detailLine\"$EE_Addr1\"," 
      if {$EE_Addr2 == ""} {
         set detailLine "$detailLine,"
      } else {
        set detailLine "$detailLine\"$EE_Addr2\","
      }
      set detailLine "$detailLine$EE_City,"
      set detailLine "$detailLine$EE_USState,"
      set detailLine "$detailLine$EE_USZipCode,"
      set detailLine "$detailLine$EE_Phone,"
      set detailLine "$detailLine$EE_TIN,"
      set detailLine "$detailLine$Form1099K_MerchantCategoryCode,"
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
      set detailLine "$detailLine$Form1099K_DecemberPayments,"
      set detailLine "$detailLine$Form1099K_GrossPaymentAmt"

      puts $filePtr $detailLine
    }
	flush $filePtr
}

close $filePtr

oraclose $merchantSumCurHandle
oraclose $merchantInfoCurHandle

exit 0	  
