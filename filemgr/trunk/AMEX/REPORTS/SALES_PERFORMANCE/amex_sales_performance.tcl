#!/usr/bin/tclsh
#/clearing/filemgr/.profile

######################################################################################################################
# $Id: amex_sales_performance.tcl 3694 2016-02-25 17:10:37Z fcaron $
# $Rev: 3694 $
######################################################################################################################
#
#    File Name:    amex_sales_performance.tcl
#
#    Description:  American Express Sales Performance Report
#                  Reports every active merchant boarded in the previous month for instututions 101, 105, 107, 117, 121
#                  and has a value in CORE.ENTITY_ADDON.AMEX_OPT_BLUE_SALES_DISPOSITION
#                  of Y or N
#
#    Return:       0 = Success
#                  1 = Fail
#
######################################################################################################################
package require Oratcl

#System variables
set box $env(SYS_BOX)
set sysinfo "System: $box\n Location: $env(PWD) \n\n"
set core_db $env(CORE_DB)
set core_db_username $env(CORE_DB_USERNAME)
set core_db_password $env(CORE_DB_PASSWORD)
set email_file $env(ALERT_NOTIFICATION)
set mailtolist $env(ALERT_EMAIL)
set mailtolist_test $env(ALERT_NOTIFICATION)
set mailfromlist $env(MAIL_FROM)

global outputfilewasopened

# fileheaderDefaults, filetrailerDefaults, detailDefaults
# these three arrays define the fixed length record layouts of the sales performance report
# H, D, and T
set fileheaderDefaults {
    RecordType 1 R "H" S
    Filler1 4 O "" S
    ParticipantCAPNumber 10 R "" S
    Filler2 335 O "" S
}

set filetrailerDefaults {
    RecordType 1 R "T" S
    FileSequenceNumber 9 R "" N
    FileTransmissionDate 8 R "" S
    RecordCount 9 R "" N
    Filler1 323 O "" S
}
set detailDefaults {
    RecordType 1 R "D" S
    SellerID 20 R "" S
    IndustrySENumber 10 R "" S
    Filler1 8 O "" S
    AmexSignDate 8 R "" S
    SellerDBA 25 R "" S
    Filler2 50 O "" S
    SellerStateCode 2 R "" S
    Filler3 9 O "" S
    MerchantCategoryCode 4 R "" N
    Filler4 18 O "" S
    Disposition 2 R "" S
    SalesChannelIndicator 2 R "" S
    SalesChannelName 25 R "" S
    SalesRepresentativeID 25 R "" S
    ISORegistrationNumber 25 R "" N
    Filler5 72 O "" S
    SellerCountryCode 2 R "US" S
    SellerIDErrorFlag 1 O "" S
    IndustrySENumberErrorFlag 1 O "" S
    AmexSignDateErrorFlag 1 O "" S
    SellerDBAErrorFlag 1 O "" S
    SellerStateCodeErrorFlag 1 O "" S
    SellerCountryCodeErrorFlag 1 O "" S
    SellerMerchantCategoryCodeErrorFlag 1 O "" S
    DispositionCodeErrorFlag 1 O "" S
    SalesChannelIndicatorErrorFlag 1 O "" S
    SalesChannelNameErrorFlag 1 O "" S
    SalesRepresentativeIDErrorFlag 1 O "" S
    ISORegistrationNumberErrorFlag 1 O "" S
    Filler6 30 O "" S
}


################################################################################
#
#    Procedure Name:  InitDictionaries
#
#    Description:     This populates the fixed length record data structions with
#                     the fields default values and lengths using ResetDictionary
#
################################################################################
proc InitDictionaries {} {

  global fileheaderDefaults detailDefaults filetrailerDefaults
  global fileheader detail filetrailer

  ResetDictionary fileheader fileheaderDefaults
  ResetDictionary filetrailer filetrailerDefaults
  ResetDictionary detail detailDefaults

}


################################################################################
#
#    Procedure Name:  ResetDictionary
#
#    Description:     This creates each field based on the data structure
#                     passed in (defaultvalues), forming the record layout
#
#    Return:          1 if any error
#
################################################################################
proc ResetDictionary {dicttoreset defaultvalues} {
  upvar 1 $dicttoreset localvar
  upvar 1 $defaultvalues defaults

  if {[info exists localvar]} {
    unset localvar
  }
  set localvar [dict create]
  foreach {fn len req defvalue ftype} $defaults {
    if {($req != "R" && $req != "O") || ($ftype != "S" && $ftype != "N")} {
      log_msg "Reading defaults array error.\nValues: Name: >$fn< Length: >$len<  Required: >$req< Default: >$defvalue< Type: >$ftype<" E
      exit_prog 1
    }
    dict set localvar $fn value $defvalue
    dict set localvar $fn maxlen $len
    dict set localvar $fn required $req
    dict set localvar $fn fieldtype $ftype
  }

}


################################################################################
#
#    Procedure Name:  CreateHeader
#
#    Description:      These "fill in the blanks" with the data retrieved
#                      from the main query for the record layout specified
#
################################################################################
proc CreateHeader {CAP} {

  global fileheader

  dict with fileheader {
    dict set RecordType value "H"
    dict set ParticipantCAPNumber value $CAP
  }
  set tmp [AddRecord $fileheader]
  return "$tmp\n"

}


################################################################################
#
#    Procedure Name:  CreateTrailer
#
################################################################################
proc CreateTrailer {filecounter rowcount includeCR} {

  global filetrailer curdate
  set curdate [clock format [clock seconds] -format %m%d%Y]
  dict with filetrailer {
    dict set RecordType value "T"
    dict set FileSequenceNumber value $filecounter
    dict set FileTransmissionDate value $curdate
    dict set RecordCount value $rowcount
  }
  set tmp [AddRecord $filetrailer]
  if {$includeCR == 1} {
    append tmp "\n"
  }
  return $tmp

}


################################################################################
#
#    Procedure Name:  CreateDetail
#
################################################################################
proc CreateDetail {} {
  global detail mainqueryrow
  dict with detail {
    dict set RecordType value "D"
    switch -exact [string toupper $mainqueryrow(OPT_BLUE_SALES_DISPOSITION)] {
      "Y" {
        dict set SellerID value $mainqueryrow(SELLER_ID)
        dict set Disposition value "1C"
        if {[catch {set asd [clock scan $mainqueryrow(AMEX_BOARD_DATE)]}] == 0} {
          dict set AmexSignDate value [clock format $asd -format %m%d%Y]
        } else {
          log_msg "WARNING: Invalid AMEX_BOARD_DATE value: >$mainqueryrow(AMEX_BOARD_DATE)< Entity ID: >$mainqueryrow(ENTITY_ID)<" W
          dict set AmexSignDate value "00000000"
        }
        dict set SalesChannelIndicator value "DS"
        dict set SalesChannelName value "Direct"
        dict set SalesRepresentativeID value "JETPAY"
      }
      "N" {
        dict set SellerID value " "
        dict set Disposition value "2F"
        dict set AmexSignDate value "00000000"
        dict set SalesChannelIndicator value " "
        dict set SalesChannelName value " "
        dict set SalesRepresentativeID value " "
      }
      default {
        log_msg "WARNING: Invalid OPT_BLUE_SALES_DISPOSITION value: >$mainqueryrow(OPT_BLUE_SALES_DISPOSITION)< Entity ID: >$mainqueryrow(ENTITY_ID)<" W
        dict set SellerID value " "
        dict set Disposition value "2F"
        dict set AmexSignDate value "00000000"
        dict set SalesChannelIndicator value " "
        dict set SalesChannelName value " "
        dict set SalesRepresentativeID value " "
      }
    }
    dict set IndustrySENumber value [GetSENumber $mainqueryrow(INSTITUTION_ID) [GetMerchantType $mainqueryrow(MCC)]]
    dict set SellerDBA value $mainqueryrow(DBA)
    dict set SellerStateCode value $mainqueryrow(STATE)
    dict set MerchantCategoryCode value $mainqueryrow(MCC)
    dict set ISORegistrationNumber value "0"
    dict set SellerCountryCode value $mainqueryrow(COUNTRY_CODE)
  }
  set tmp [AddRecord $detail]
  return $tmp
}


################################################################################
#
#    Procedure Name:  AddRecord
#
#    Description:     This will create the record based on the datadictionary
#                     passed to the function.
#
################################################################################
proc AddRecord {datadictionary} {

  global entityinfo verboselengthwarnings debugmode mainqueryrow

  set rec ""

  dict for {elementName info} $datadictionary {
    set element ""
    dict with info {
      if {$required == "R" && [string length $value] == 0} {
        log_msg "WARNING: Required element value missing: Entity ID: $mainqueryrow(ENTITY_ID) Element: $elementName Value: >$value<" W
      }
      if {[string length $value] > $maxlen} {
        if {([lsearch {"SellerDBA"} $elementName] == -1) || ($verboselengthwarnings == 1)} {
          log_msg "WARNING: Length exceeded: Entity ID: $mainqueryrow(ENTITY_ID) Element: $elementName Value: >$value< Max Length: $maxlen" W
        }
      }
      switch -exact [string toupper $fieldtype] {
        "S" {
          set element "$value[string repeat " " $maxlen]"
          # Chop it down to size
          set element [string range $element 0 [expr $maxlen - 1]]
        }
        "N" {
          if {(![string is digit $value]) && ($debugmode == 1)} {
            log_msg "WARNING: Value is not numeric: Element: $elementName Value: >$value<" W
          }
          # Pad left side with maxlen worth of 0's.
          set element "[string repeat "0" $maxlen]$value"
          # Chop it down to size from the right side (123 with maxlen of 5 becomes 00000123, which then becomes 00123)
          set element [string range $element end-[expr $maxlen-1] end]
        }
        default {
          log_msg "WARNING: Invalid field type: Element: $elementName Field Type: >$fieldtype<" W
          # treat it like a string
          set element "$value[string repeat " " $maxlen]"
          # Chop it down to size
          set element [string range $value 0 [expr $maxlen - 1]]
        }
      }
      append rec "$element"
    }
  }
  return "$rec"
}

################################################################################
#
#    Procedure Name:  mailsend
#
################################################################################
proc mailsend {email_sender email_subject email_recipient email_body filename} {

  set header_file      [exec mktemp]
  set email_header     [open $header_file w]

  # removing the colon
  set temp_value ""
  regsub -all "\:" $email_body "\72" temp_value
  puts $email_header   "To: $email_recipient\nFrom: $email_sender\nSubject: $email_subject\n$temp_value"
  close $email_header

  if {[string length $filename]} {
    exec mutt -H $header_file -a $filename < /dev/null
  } else {
    exec mutt -H $header_file < /dev/null
  }
  file delete $header_file
}

################################################################################
#
#    Procedure Name:  send_error_email
#
################################################################################
proc send_error_email {errmsg} {

  global warnings box filename argv0 mailfromlist mailtolist mailtolist_test mode

  if {$mode == "TEST"} {
    set mailto $mailtolist_test
  } else {
    set mailto $mailtolist
  }

  log_msg $errmsg E
  set subject "AMEX Opt Blue Sales Performance Report (Normal Business Hours Alert)."
  set body "During business hours, contact a clearing engineer for the following:\n"
  append body "An error occured during the execution of $argv0.\n"
  append body "\nDetails:\nBox: $box\nOutput file name: $filename\n"
  append body "Error message: $errmsg\nWarnings that were detected before the error:\n$warnings\n"
  # emailsend $mailfromlist $subject $mailto $body ""
}

################################################################################
#
#    Procedure Name:  send_success_email
#
################################################################################
proc send_success_email {recordcount ignorecount} {

  global mode mailfromlist mailtolist mailtolist_test box filename argv0 warnings

  if {$mode == "TEST"} {
    set mailto $mailtolist_test
  } else {
    set mailto $mailtolist
  }

  set temp_line ""
  append temp_line "********************************    \n"
  append temp_line "Possible Amex Opt Blue Warnings: \n"
  append temp_line "********************************    \n"
  append temp_line "$argv0 successfully ran.\n"
  append temp_line "Details:\nBox: $box\nOutput filename: $filename\n\n"
  append temp_line "Processed [expr $recordcount + $ignorecount] records. Good: $recordcount   Ignored: $ignorecount\n"
  append temp_line "File should contain $recordcount records (Check trailer).\n\n"
  append temp_line "Warnings that were detected:\n$warnings\n"
  exec echo $temp_line > tempfile.txt
}

################################################################################
#
#    Procedure Name:  LoadMCCs
#
################################################################################
proc LoadMCCs {} {

  global mccresult MCCdict

  set MCCdict [dict create]

  orasql $mccresult "SELECT MCC, amex_opt_blue_merchant_type AS \"MERCHANT_DESCRIPTION\" FROM CORE.MCC_MAP ORDER BY MCC"
  while {[set result [orafetch $mccresult -dataarray mcclist -indexbyname]] == 0} {
    dict set MCCdict [string trim $mcclist(MCC)] [string trim $mcclist(MERCHANT_DESCRIPTION)]
  }
}

################################################################################
#
#    Procedure Name:  LoadCAPs
#
################################################################################
proc LoadCAPs {} {

  global capresult CAPdict

  set CAPdict [dict create]

  orasql $capresult "SELECT UNIQUE INSTITUTION_ID, CAP FROM CORE.AMEX_SE_MAP ORDER BY INSTITUTION_ID"
  while {[set result [orafetch $capresult -dataarray caplist -indexbyname]] == 0} {
    dict set CAPdict [string trim $caplist(INSTITUTION_ID)] [string trim $caplist(CAP)]
  }
}

################################################################################
#
#    Procedure Name:  LoadSEs
#
################################################################################
proc LoadSEs {} {

  global SEresult SEdict

  set SEdict [dict create]

  orasql $SEresult "SELECT INSTITUTION_ID, amex_opt_blue_merchant_type AS \"MERCHANT_DESCRIPTION\", amex_opt_blue_se_number AS \"SENumber\" FROM CORE.AMEX_SE_MAP ORDER BY INSTITUTION_ID, AMEX_OPT_BLUE_MERCHANT_TYPE"
  while {[set result [orafetch $SEresult -dataarray SElist -indexbyname]] == 0} {
    dict set SEdict [string trim "$SElist(INSTITUTION_ID)-$SElist(MERCHANT_DESCRIPTION)"] [string trim $SElist(SENumber)]
  }

}

################################################################################
#
#    Procedure Name:  GetCAPNumber
#
################################################################################
proc GetCAPNumber {inst_id} {

  global CAPdict

  if {![dict exists $CAPdict $inst_id]} {
    log_msg "WARNING: CAP does not exist in list: >$inst_id<" W
    return "0000000000"
  }
  return [dict get $CAPdict $inst_id]
}

################################################################################
#
#    Procedure Name:  GetSENumber
#
################################################################################
proc GetSENumber {inst_id merchant_type} {

  global SEdict

  if {![dict exists $SEdict "$inst_id-$merchant_type"]} {
    log_msg "WARNING: Inst ID-merchant_type combo does not exist in list: INSTITUTION_ID: >$inst_id< Merchant Type: >$merchant_type<" W
    return "0000000000"
  }
  return [dict get $SEdict "$inst_id-$merchant_type"]
}

################################################################################
#
#    Procedure Name:  GetMerchantType
#
################################################################################
proc GetMerchantType {mcc} {

  global MCCdict

  if {![dict exists $MCCdict $mcc]} {
    return ""
  }
  return [dict get $MCCdict $mcc]
}

################################################################################
#
#    Procedure Name:  init_log
#
################################################################################
proc init_log {} {
  global log_fd log_folder argv0
  global script_version

  set nme "[file rootname [file tail $argv0]].log"

  if {![file isdirectory $log_folder]} {
    if [catch {file mkdir $log_folder} result] {
      puts "init_log: Couldn't create folder $log_folder"
      exit 1
    }
  }
  set log_fd [open "[set log_folder]/$nme" {WRONLY CREAT APPEND}]
  log_msg "Script started... $argv0 Version: $script_version" N
}

################################################################################
#
#    Procedure Name:  cleanup_log
#
################################################################################
proc cleanup_log {} {

  global log_fd

  if {[info exists log_fd]} {
    log_msg "Closing log." N
    close $log_fd
  } else {
    puts "WARNING: Log was not opened."
  }
}

################################################################################
#
#    Procedure Name:  trace_msg
#
################################################################################
proc trace_msg {msg} {

  global tracemessages

  if {$tracemessages == 1} {
    log_msg $msg D
  }
}

################################################################################
#
#    Procedure Name:  log_msg
#
################################################################################
proc log_msg {msg msgtype} {

  global log_fd debugmode warnings

  # msgtype: N = Normal W = Warning E = Error D = Debug
  if {$debugmode == 1} {
    puts $msg
  }

  if {[info level] == 1} {
    set caller MAIN
  } else {
    set caller [lrange [info level -1] 0 0]
  }

  if {[info exists log_fd]} {
    puts $log_fd "[clock format [clock seconds] -format %Y%m%d%H%M%S] $caller - $msg"
    flush $log_fd
  }

  if {$msgtype == "W"} {
    append warnings "$msg\n"
  }
}

################################################################################
#
#    Procedure Name:  exit_prog
#
################################################################################
proc exit_prog {exitlevel} {

  log_msg "Ending script. Exit level: $exitlevel" N
  closedatabase
  closeoutputfile
  cleanup_log
  exit $exitlevel
}

################################################################################
#
#    Procedure Name:  openoutputfile
#
################################################################################
proc openoutputfile {filename} {

  global outfile file_folder outputfilewasopened

  set outputfilewasopened 0

  if {![file isdirectory $file_folder]} {
    if [catch {file mkdir $file_folder} result] {
      # send_error_email "ERROR: Couldn't create folder $file_folder"
      exit_prog 1
    }
  }
  set outfile [open "$file_folder/$filename" w]
  set outputfilewasopened 1
}

################################################################################
#
#    Procedure Name:  init_dates
#
################################################################################

proc init_dates {val} {
    global start_date end_date file_date curdate report_month rpt_type argv
    set curdate [clock format [clock seconds] -format %d-%b-%Y]
    puts "Date Generated: $curdate"
    set report_date [clock format [clock scan $val -format %Y%m%d] -format %Y%m]
    set start_date $report_date
    append start_date "01"
    set end_date [clock format [clock seconds] -format "%Y%m"]
    append end_date "01"
}

################################################################################
#
#    Procedure Name:  closeoutputfile
#
################################################################################
proc closeoutputfile {} {

  global outfile
  global outputfilewasopened

  #if {$outputfilewasopened == 1} {
    catch {
      flush $outfile
      close $outfile
    }
  #}
}

################################################################################
#
#    Procedure Name:  opendatabase
#
################################################################################
proc opendatabase {} {

  global coredbhandle
  global mainqueryresult
  global mccresult
  global capresult
  global SEresult
  global dbswereopened
  global clr_db
  global clr_db_username
  global clr_db_password
  global core_db core_db_username core_db_password

  set dbswereopened 0
  trace_msg "Opening databases"

  if {[catch {set coredbhandle [oralogon $core_db_username/$core_db_password@$core_db]} result]} {
    # send_error_email "Error connecting to core database: $core_db: $result"
    exit_prog 1
  } else {
    puts "COnnected"
  }
  # indicate we opened the database (for closedatabases use)
  set dbswereopened 1
  set mainqueryresult [oraopen $coredbhandle]
  set SEresult [oraopen $coredbhandle]
  set mccresult [oraopen $coredbhandle]
  set capresult [oraopen $coredbhandle]
}

################################################################################
#
#    Procedure Name:  closedatabase
#
################################################################################
proc closedatabase {} {

  global coredbhandle
  global mainqueryresult
  global mccresult
  global capresult
  global SEresult
  global dbswereopened

  # only try to close if we actually opened them
  if {$dbswereopened == 1} {
    if {[catch {
      oraclose $mainqueryresult
      oraclose $capresult
      oraclose $SEresult
      oraclose $mccresult
      oralogoff $coredbhandle
    } result]} {
      #send_error_email "Error closing connections: $result"
      # direct exit so we don't loop infinitely through exit_prog being called again which calls this routine
      exit 1
    }
  }
}

##########
## MAIN ##
##########
global start_date end_date cur_date clr_db

set curdate [clock format [clock seconds] -format %m%d%Y]
set last_institution_id ""
set last_entity_id ""
set mode "PROD" ;# TEST for testing, PROD for production
set rowcount 0
set filecount 0
set sendsuccessemails 1 ;# Only send success messages for this script if there are warnings to look at
set tracemessages 1
set debugmode 1
set verboselengthwarnings 0
set box [exec hostname]
#set clr_db "clear2"
set clr_db $env(IST_DB)
set MAIN_DIR [file dir $argv0]
set log_folder "$MAIN_DIR/LOG"
set file_folder "$MAIN_DIR/UPLOAD"
set script_version "1.0"
set recordcount 0
set ignorecount 0
set dupcount 0
set dbswereopened 0

if {$mode == "TEST"} {
  # set filename "TEST.[clock format [clock seconds] -format "JETPAYPRD.SALES.%Y%m%d.%H%M%S"]"
  set filename "TEST.[clock format [clock seconds] -format "JETPAYPRD.SALES"]"
} else {
  # set filename [clock format [clock seconds] -format "JETPAYPRD.SALES.%Y%m%d.%H%M%S"]
  set filename [clock format [clock seconds] -format "JETPAYPRD.SALES"]
}

set warnings ""

init_log
InitDictionaries
opendatabase
openoutputfile $filename
arg_parse

if {[info exists date_given]} {
   init_dates [clock format [clock scan $date_given -format %Y%m%d] -format %Y%m%d]     
} else {
   init_dates [clock format [clock scan "-1 month" -base [clock seconds]] -format %Y%m01]  
}

LoadMCCs
LoadCAPs
LoadSEs
set mainquery "SELECT e.INSTITUTION_ID, e.ENTITY_ID, m.MID, m.me_dba_name as \"DBA\", c.STATE_CD as \"STATE\", m.SIC_CODE as \"MCC\",
                      eao.amex_board_date, eao.alt_merchant_id as \"SELLER_ID\", eao.OPT_BLUE_SALES_DISPOSITION,
                      DECODE(cntry_cd, 'USA', 'US', '840', 'US', 'CAN', 'CA', '124', 'CA', '826', 'GB', 'GBR', 'GB', 'UK', 'GB', 'MEX', 'MX', '484', 'MX', 'US') AS \"COUNTRY_CODE\"
                 FROM CORE.ENTITY e
           INNER JOIN CORE.entity_to_merchant e2m ON e.institution_id = e2m.institution_id AND e.entity_id = e2m.entity_id
           INNER JOIN CORE.MERCHANT m ON e2m.MID = m.MID
           INNER JOIN CORE.ENTITY_ADD_ON eao ON e.ENTITY_ID = eao.ENTITY_ID
           INNER JOIN CORE.ENTITY_CONTACT ec ON e.ENTITY_ID = ec.entity_foodchain_name AND ec.entity_foodchain_id = 'EN'
           INNER JOIN CORE.CONTACT C ON c.CONTACT_ID = ec.contact_id AND ec.contact_type = 'DEFAULT'
                WHERE e.institution_id IN ('101', '105', '107', '117', '121') AND e.active = 'A' AND
                e.BOARD_DATE >= to_date($start_date,'YYYYMMDDHH24MISS') AND e.BOARD_DATE < to_date($end_date,'YYYYMMDDHH24MISS') AND
                  (eao.amex_type = 'OPTBLUE' OR UPPER(eao.OPT_BLUE_SALES_DISPOSITION) IN ('Y', 'N'))
             ORDER BY e.INSTITUTION_ID, e.ENTITY_ID, m.MID"
puts $mainquery
# trace_msg $mainquery
orasql $mainqueryresult $mainquery
while {[set fetch_result [orafetch $mainqueryresult -dataarray mainqueryrow -indexbyname]] == 0} {
  if {$last_institution_id != $mainqueryrow(INSTITUTION_ID)} {
    if {$last_institution_id != ""} {
      incr rowcount
      puts -nonewline $outfile [CreateTrailer $filecount $rowcount 1]
    }
    incr filecount
    set rowcount 1
    set last_institution_id $mainqueryrow(INSTITUTION_ID)
    puts -nonewline $outfile [CreateHeader [GetCAPNumber $last_institution_id]]
  }

  if {$last_entity_id != $mainqueryrow(ENTITY_ID)} {
    set last_entity_id $mainqueryrow(ENTITY_ID)
    if {[GetMerchantType $mainqueryrow(MCC)] != ""} {
      incr rowcount
      incr recordcount
      puts -nonewline $outfile "[CreateDetail]\n"
    } else {
      log_msg "WARNING: Merchant has MCC that does not have an AMEX merchant type: INST ID: >$mainqueryrow(INSTITUTION_ID)< Entity_ID: >$mainqueryrow(ENTITY_ID)< MCC: >$mainqueryrow(MCC)<" W
      incr ignorecount
    }
  } else {
    incr dupcount
  }

  # every 100 records, flush the buffer
  if {$recordcount % 100 == 0} {
    flush $outfile
    # this is for people who can't stand to wait while a script runs to see if it is doing anything
    if {$debugmode == 1} {
      puts $recordcount
    }
  }
}

if {$last_institution_id != ""} {
  incr rowcount
  # Pass a 0 for 'includeCR' so we don't append a linefeed at the end of the file
  puts -nonewline $outfile [CreateTrailer $filecount $rowcount 0]
}

trace_msg "Detail records in file: $recordcount Ignored: $ignorecount Duplicates: $dupcount"

if {$sendsuccessemails == 1 && [string length $warnings] > 0} {
  # send_success_email $recordcount $ignorecount
}

# Exit program. This routine closes all DB connections, closes the output file, and closes the log file as well
# Exit with 0 to indicate success
exit_prog 0
