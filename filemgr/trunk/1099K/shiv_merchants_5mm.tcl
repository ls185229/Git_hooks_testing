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
# $Id: shiv_merchants_5mm.tcl 4012 2017-01-06 18:13:25Z millig $
# $Rev: 4012 $
# $Author: millig $
################################################################################


package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_clr_db $env(IST_DB)
set prod_auth_db $env(REPORT_ATH_DB)
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
			"AUTH_DB_LOGON" { 
				set clrDBLogin [lindex $lineParms 1]
			}
	     default {
			puts "Unknown config parameter [lindex $lineParms 0]"
	      }
	  }
    }

    close $filePtr

    if {$clrDBLogin == ""} {
		puts "Unable to find AUTH_DB_LOGON params in $cfgFileName, exiting..."
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
    global createDate procDate version  encoding  xmlns  programName 

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

    if {[catch {set clrDBLoginHandle [oralogon $clrDBLogin@$prod_auth_db]} result ] } {
		puts "$prod_clr_db login Err: $result "
		exit 3
    }


    if {[catch {set clrHandle2 [oraopen $clrDBLoginHandle]} result ]} {
		puts "Table access Err:$result"
		exit 3
    }

       set merchantTrans "select m.visa_id,
                long_name nameline1
               , phone_no  phone
               , address_1 addr1
               , nvl(address_2, ' ') addr2
               , city city
               , state usstate
               , substr(zip, 1, 5) as uszipcode
               , visa_id  as acctnumbermid
                        ,sum (case WHEN (th.card_type = 'VS' and request_type in ('0200', '0250'))  then amount else 0 end) AS VSPAYMENT
                        ,sum (case WHEN (th.card_type = 'MC' and request_type in ('0200', '0250'))  then amount else 0 end) AS MCPAYMENT
                        ,sum (case WHEN (th.card_type = 'DS' and request_type in ('0200', '0250'))  then amount else 0 end) AS DSPAYMENT
                    FROM MERCHANT m 
                        INNER JOIN TRANHISTORY th ON m.mid = th.mid
                        INNER JOIN MASTER_MERCHANT mm on m.mmid = mm.mmid
                        WHERE authdatetime BETWEEN '20120401' AND '20130401999999' 
                        AND REQUEST_TYPE IN ('0200', '0250')
                        AND LENGTH(m.visa_id) = 15
                        and ((substr(m.visa_id,1,11) != '45404527400') and (substr(m.visa_id,1,11) != '45404547400'))
                        and m.active = 'A'
                        and m.amex_se_no = ' '
                        and mm.shortname = 'JETPAYSQ'
                        and ((th.card_type = 'VS') or (th.card_type = 'MC') OR (th.card_type = 'DS'))
                        and amount > 0
                        group by m.visa_id,long_name,phone_no,address_1,address_2,city,state,zip"
 
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
    
    set fileName [format "shiv_5mm.csv"]
    
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

puts $filePtr "ACCTNUMBERMID,GROSSAMT,VISAAMT,MASTERCARDAMT,DISCOVERAMT,NAMELINE1,PHONE,ADDR1,ADDR2,CITY,USSTATE,USZIPCODE"


   set grossPaymentAmt 0
  orabind $clrHandle2  

      set merchantSumCurHandle [executeQuery $merchantTrans $clrHandle2 ]
while {[orafetch $merchantSumCurHandle -dataarray ds3 -indexbyname] != 1403} {
         set acctnumbermid               "$ds3(ACCTNUMBERMID)"
         set nameline1                   "$ds3(NAMELINE1)"
         set phone                       "$ds3(PHONE)"
         set addr1                       "$ds3(ADDR1)"
         set addr2                       "$ds3(ADDR2)"
         set city                        "$ds3(CITY)"
         set usstate                     "$ds3(USSTATE)"
         set uszipcode                   "$ds3(USZIPCODE)"
         set visa                        "$ds3(VSPAYMENT)"
         set master                      "$ds3(MCPAYMENT)"
         set discover                    "$ds3(DSPAYMENT)"
	     set  gross $visa   
		 set  gross [expr $gross + $master    ]
		 set  gross [expr $gross + $discover  ]

	if {(($gross > 0) && ($gross <= 5000000))} {
	  set detailLine "\"$acctnumbermid\",\"$gross\",\"$visa\",\"$master\",\"$discover\",\"$nameline1\",\"$phone\",\"$addr1\",\"$addr2\",\"$city\",\"$usstate\",\"$uszipcode\","
      puts $filePtr $detailLine
  } 
}

flush $filePtr
close $filePtr

oraclose $merchantSumCurHandle
##oraclose $merchantInfoCurHandle

exit 0	  
