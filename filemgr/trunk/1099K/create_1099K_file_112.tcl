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
# $Id: create_1099K_file_112.tcl 4012 2017-01-06 18:13:25Z millig $
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
          join entity_to_auth eta on (eta.entity_id = ae.entity_id and eta.institution_id = ae.institution_id)
          join country c on (c.cntry_code = mc.cntry_code)
          where contact_role = 'DEF'
            and address_role = 'BIL'
            and ae.entity_id in ('000590003000114',
'000590003000288',
'000590003000569',
'000590003000593',
'000590003001401',
'000590003001740',
'000590003002557',
'000590003003092',
'000590003003134',
'000590003003209',
'000590003003282',
'000590003003324',
'000590003003373',
'000590003003720',
'000590003003845',
'000590003003894',
'000590003003969',
'000590003004033',
'000590003004082',
'000590003004124',
'000590003004173',
'000590003004181',
'000590003004199',
'000590003004215',
'000590003004264',
'000590003004272',
'000590003004389',
'000590003004397',
'000590003004405',
'000590003004413',
'000590003004652',
'000590003004660',
'000590003004728',
'000590003004736',
'000590003004751',
'000590007000300',
'000590007000805',
'000590007000847',
'000590007001050',
'000590007001142',
'000590007001241',
'000590008000036',
'000590008000077',
'000590017000100',
'000590025000043',
'000590029000072',
'000590052000825',
'000590052001153',
'000590052001161',
'000590052001328',
'000590052001492',
'000590052001500',
'000590052001617',
'000590052001633',
'000590053000451',
'000590053000881',
'000590053000949',
'000590053000980',
'000590062000021',
'000590063000137',
'000590063000152',
'000590063000244',
'000590063000277',
'000590063000285',
'000590063000301',
'000590063000350',
'000590063000475',
'000590063000525',
'000590063000533',
'000590063000731',
'000590063000939',
'000590063001069',
'000590063001176',
'000590063001382',
'000590063001416',
'000590063001580',
'000590063001598',
'000590063001671',
'000590063002042',
'000590063002117',
'000590065000044',
'000590065000184',
'000590075000026',
'000590075000299',
'000590075000349',
'000590075000356',
'000590081000002',
'000590081000010',
'000590081000119',
'000590083000190',
'000590083000265',
'000590083000349',
'000590083000364',
'000590083000448',
'000590093000131',
'000590093000172',
'000590105000038',
'000590106000003',
'000590108000068',
'000590108000092',
'000590118000009',
'000590118000017',
'000590144000114',
'000590144000288',
'000590144000353',
'000590144000361',
'000590144000478',
'000590144000551',
'000590144000676',
'000590144000783',
'000590144000882',
'000590144000932',
'000590144001021',
'000590144001195',
'000590144001567',
'000590144001625',
'000590144001872',
'000590144001898',
'000590151000007',
'000590152000014',
'000590171000185',
'000590171000193',
'000590226000040',
'000590249000027',
'000590250000007',
'486954200031004',
'486954200031010',
'486954200031012',
'486954200031013',
'486954200031015',
'486954202421005',
'486954202421006',
'486954400031003',
'486954400031005',
'486954401291001',
'486954402261002',
'486954402421001',
'486954402421002',
'486954402421003')	
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
 	  orabind $clrHandle2 :INST $instId :ENTITY $acctnumbermid :YEAR $year
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
