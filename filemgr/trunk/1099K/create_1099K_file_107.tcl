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
# $Id: create_1099K_file_107.tcl 4012 2017-01-06 18:13:25Z millig $
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
	
##	if {$month == "01"} {
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
               , address1 addr1
               , nvl(address2, ' ') addr2
               , city city
               , prov_state_abbrev usstate
               , substr(postal_cd_zip, 1, 5) as uszipcode
               , substr(postal_cd_zip, 6, 9) as uszipext
               , null foreignstateorprovince
               , null foreignpostalcode
               , cntry_code_alpha2 countrycode
               , ae.entity_id  acctnumbermid
			   , default_mcc as merchantcategorycode
          from acq_entity ae
          join acq_entity_address aea on (aea.entity_id = ae.entity_id and aea.institution_id = ae.institution_id)
          join acq_entity_contact aec on (aec.entity_id = ae.entity_id and aec.institution_id = ae.institution_id)
          join master_address ma on (aea.address_id = ma.address_id and ma.institution_id = ae.institution_id)
          join master_contact mc on (aec.contact_id = mc.contact_id and mc.institution_id = ae.institution_id)
          join country c on (c.cntry_code = mc.cntry_code)
          where contact_role = 'DEF'
            and address_role = 'BIL'
            and ae.entity_id in ('454045211000103',
'454045211000121',
'454045211000124',
'454045211000128',
'454045211000129',
'454045211000135',
'454045211000151',
'454045211000197',
'454045213000014',
'454045213000016',
'454045213000017',
'454045213000019',
'454045213000020',
'454045213000022',
'454045213000025',
'454045282000010',
'454045413000015',
'454045427000010',
'454045427000011',
'454045471000010',
'454045471000011')
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
                    	 , sum(JUNPAYMENT)  JUNPAYMENT
                    	 , sum(JULPAYMENT)  JULPAYMENT
                    	 , sum(AUGPAYMENT)  AUGPAYMENT
                    	 , sum(SEPPAYMENT)  SEPPAYMENT
                    	 , sum(OCTPAYMENT)  OCTPAYMENT
                    	 , sum(NOVPAYMENT)  NOVPAYMENT
                    	 , sum(DECPAYMENT)  DECPAYMENT
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
                                        from mas_trans_log
                                        where institution_id = :INST
                                          and posting_entity_id in ('454045211000103',
'454045211000121',
'454045211000124',
'454045211000128',
'454045211000129',
'454045211000135',
'454045211000151',
'454045211000197',
'454045213000014',
'454045213000016',
'454045213000017',
'454045213000019',
'454045213000020',
'454045213000022',
'454045213000025',
'454045282000010',
'454045413000015',
'454045427000010',
'454045427000011',
'454045471000010',
'454045471000011') 
                     	   	              and tid in ('010003005101', '010003005202', '010123005102', '010003005104')
                                        and to_char(gl_date, 'yyyy') = :YEAR)
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
    
    set fileName [format "%i_1099K.csv"  $instId]
    
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

puts $filePtr "ISO_ID,FORM_TYPE,TIN,NAMELINE2,PHONE,PHONEEXT,NAMELINE1,ADDR1,ADDR2,CITY,USSTATE,USZIPCODE,USZIPEXT,FOREIGNSTATEORPROVINCE,FOREIGNPOSTALCODE,COUNTRYCODE,ACCTNUMBERMID,GROSSPAYMENTAMT,MERCHANTCATEGORYCODE,JANUARYPAYMENTS,FEBRUARYPAYMENTS,MARCHPAYMENTS,APRILPAYMENTS,MAYPAYMENTS,JUNEPAYMENTS,JULYPAYMENTS,AUGUSTPAYMENTS,SEPTEMBERPAYMENTS,OCTOBERPAYMENTS,NOVEMBERPAYMENTS,DECEMBERPAYMENTS"

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
   set acctnumbermid               "$ds(ACCTNUMBERMID)"
   set merchantcategorycode        "$ds(MERCHANTCATEGORYCODE)"

   set grossPaymentAmt 0
 	  orabind $clrHandle2 :INST $instId :YEAR $year
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
    }

	if {$grossPaymentAmt != 0} {
	  set detailLine "\"$iso_id\",\"$form_type\",\"$tin\",\"$nameline2\",\"$phone\",\"$phoneext\",\"$nameline1\",\"$addr1\",\"$addr2\",\"$city\",\"$usstate\",\"$uszipcode\",\"$uszipext\",\"$foreignstateorprovince\",\"$foreignpostalcode\",\"$countrycode\",\"$acctnumbermid\","
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
