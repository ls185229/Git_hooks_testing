#!/usr/bin/env tclsh

# $Id: 

################################################################################
#
#    File Name - merrick_daily_volume_report.tcl
#
#    Description - Create the daily volume report
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
set box $env(SYS_BOX)
set prod_clr_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)

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
    global clrDBLogin authDBLogin instIds prod_clr_db fileName

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
    global transDate instIds programName cfgFile mailfromlist mailtolist

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
		writeLogRcd 4 "SQL Err:$result\n$query"
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
    global prod_clr_db clrDBLogin clrHandle clrHandle2 programName instIds merchantList volumeData
    if {[catch {set clrDBLoginHandle [oralogon $clrDBLogin@$prod_clr_db]} result ] } {
		writeLogRcd 4 "DB login Err:$programName.tcl - $prod_clr_db login Err: $result" 
    }

    if {[catch {set clrHandle [oraopen $clrDBLoginHandle]} result ]} {
		writeLogRcd 4 "Schema access Err:$programName.tcl - Connection Err: $result" 
    }

    if {[catch {set clrHandle2 [oraopen $clrDBLoginHandle]} result ]} {
		writeLogRcd 4 "Schema access Err:$programName.tcl - Connection Err: $result" 
    }
 
	set    merchantList "select trim(ae.entity_id) entity_id
                                    , trim(tax_id) tax_id
                                    , trim(entity_dba_name) entity_dba_name
                                    , trim(ma.address1||' '||ma.address2) address
                                    , trim(ma.prov_state_abbrev) prov_state_abbrev
                                    , trim(ma.postal_cd_zip) postal_cd_zip
                                    , case 
									    when ae.entity_status = 'C' 
										    then to_char(ae.termination_date, 'mm/dd/yyyy') 
										else null
										end termination_date
                                    , trim(ae.institution_id) institution_id
        from acq_entity ae
                                  , acq_entity_address aea
                                  , master_address ma
        where ae.institution_id in ($instIds)
                                 and ma.address_id = aea.address_id
                                 and ma.institution_id = aea.institution_id
                                 and aea.entity_id = ae.entity_id
                                 and aea.institution_id = ae.institution_id
                                 and entity_level = '70'
	                             and aea.address_role = 'LOC'"

	oraparse $clrHandle $merchantList  	
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
    global filePtr transDate fileName
    
    #### open output file
    
    set fileName [format "merrick_daily_merchant_list_%s.csv" $transDate ]
    
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
global programName logFilePtr 
  set logDate [clock seconds]
  set logDate [clock format $logDate -format "%Y%m%d"]
  set logTime [clock seconds]
  set logTime [clock format $logTime -format "%Y/%m/%d %H:%M:%S"]
  
  set logFileName [format "LOG/Merrick_daily_volume_report_%s.log" $logDate ]
   
  if {[catch {open $logFileName a} logFilePtr]} {
	 puts "File Open Err:$programName.tcl Cannot open log file $logFileName"
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

set merchantCurHandle [executeQuery $merchantList $clrHandle ]

puts $filePtr "MID,TIN,DBA Name,Address,State,Zip,Termination Date"

while {[orafetch $merchantCurHandle -dataarray ds -indexbyname] != 1403} {
  set entity_id              "$ds(ENTITY_ID)"
  set tax_id                 "$ds(TAX_ID)"
  set legal_name             "$ds(ENTITY_DBA_NAME)"
  set address                "$ds(ADDRESS)"
  set prov_state_abbrev      "$ds(PROV_STATE_ABBREV)"
  set postal_cd_zip          "$ds(POSTAL_CD_ZIP)"
  set termination_date       "$ds(TERMINATION_DATE)"
  set institution_id         "$ds(INSTITUTION_ID)"
  
  set detailLine    "\"$entity_id\""        
  append detailLine ",\"$tax_id\""                    
  append detailLine ",\"$legal_name\""               
  append detailLine ",\"$address\""               
  append detailLine ",\"$prov_state_abbrev\"" 
  append detailLine ",\"$postal_cd_zip\"" 
  append detailLine ",\"$termination_date\"" 

  puts $filePtr $detailLine
  
  flush $filePtr
}

close $filePtr

oraclose $merchantCurHandle

writeLogRcd 0 "$programName.tcl - Completed successfully"
exit 0
