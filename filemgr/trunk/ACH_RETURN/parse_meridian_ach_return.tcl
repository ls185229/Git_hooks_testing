#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
#
#    File Name - parse_meridian_ach_return.tcl
#
#    Description - This script will parse JetPay or Revtrak ACH Retrun files 
#                  from Meridian Bank into the C&S table. It does the following
#                  1- Searche the DNLOAD dir for any recent (run date)
#                     downloaded file from Meridian (JetPay or Revtrak)
#                  2- Parse the file into FLMGR_ACH_EMS_TRANS table.
#                  3- The primary key for FLMGR_ACH_EMS_TRANS table are
#                     "orig_dfi_trace" and "status". The combination should be
#                     always unique.
#                  4- Verification - Uses the result file from the
#                     get_meridian_ach_return.exp process, to get the 
#                     number of files downloaded and uses that value to 
#                     confirm if all those files are parsed into the system.
#                  5- Writes the parse file count to the result file from the
#                     get_meridian_ach_return.exp process.
#                  6- Returns 0 if successful execution else
#                     Returns error code to the calling shell script for
#                     notification purposes.
#                   
#    Arguments - $1 = config file. This file should have the login details
#                     for the database
#                $2 = run date - The date when the files were downloaded
#                                (YYYYMMDD) optional, defaults to current
#                    
#    Return - 0 = Success
#             1 = Code/syntax error
#             2 = No files to parse
#             3 = SQL DataBase Error
#             4 = Count do not match
#             5 = Could not find the downloaded file
#
#    Note - Invoke this process using the startup shell script 
#           parse_meridian_ach_return.sh for better log/email functionality
#             
#             
################################################################################
# $Id: parse_meridian_ach_return.tcl 4745 2018-10-12 21:09:48Z bjones $
# $Rev: 4745 $
# $Author: bjones $

package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set base_name "parse_meridian_ach_return"
set loc_path "/clearing/filemgr/ACH_RETURN"
set archive_path "$loc_path/ARCHIVE"
set dnld_path "$loc_path/DNLOAD"
set returnCode_fileName "$loc_path/achReturnCode.txt"
set result_file "$loc_path/achReturnDnld.result"
set jp_file_mask "Jet*ay_returns*"  ; #default values
set rt_file_mask "Rev*rak_returns*" ; #default values

set actvty_date [clock format [clock second] -format "%Y%m%d"]


################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################
proc usage {} {
   global base_name

   puts "Usage: $base_name.tcl <config file> <run_date>"
   puts "       config file - file to initialize program parameter, eg DB parms"
   puts "       run_date - Optional, (YYYYMMDD) date the file was downloded"
   puts "                  Defaults to current"
}


################################################################################
#
#    Procedure Name - init
#
#    Description - 
#
#    Return - None
#
###############################################################################
proc init {argc argv} {
   global base_name
   global run_date
   global clr_db_logon
   global auth_db_logon
   global returnCode_fileName
   global returnCode_filePtr
   global dnldFileCount
   global dnldFileList

   if {$argc < 1} {
      usage 
      exit 1
   } else {
      set cfg_file [lindex $argv 0]
      if {$argc > 1} {
         set run_date [lindex $argv 1] 
      } else {
         set run_date [clock format [clock second] -format "%Y%m%d"]
      }
   }

   readCfgFile $cfg_file

   ### Initialize DataBase
   initDB

   ### Find out how many files were downloaded 
   readResultFile

   #open returnCode-verbose return reason file
   if {[catch {open $returnCode_fileName r} returnCode_filePtr]} {
      puts "File Open Err:Cannot open returnCode file $returnCode_fileName"
      exit 1
   }


}

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - open,parse and close the config file
#
#    Arguments - Config file name
#
#    Return - None
#
###############################################################################
proc readCfgFile {cfg_file_name} {
   global base_name
   global clr_db_logon
   global auth_db_logon
   global jp_file_mask 
   global rt_file_mask 


   set clr_db_logon ""
   set auth_db_logon ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
      puts "File Open Err:$cfg_file_name Cannot open config file $cfg_file_name"
      exit 1
   }


   while { [set line [gets $file_ptr]] != {} } {
      set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
            #T-1 not required for this proc, reserved for future use
         }
         "JP_RETURN_FILE_MASK" {
            set jp_file_mask [lindex $line_parms 1]
         }
         "RT_RETURN_FILE_MASK" {
            set rt_file_mask [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   } 

   close $file_ptr

   if {$clr_db_logon == ""} {
      puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
      exit 3
   }

}



################################################################################
#
#    Procedure Name - initDB
#
#    Description - Initialize DataBase parameters
#                 
#    Return - None
#
###############################################################################
proc initDB {} {
   global base_name
   global run_date
   global prod_db
   global clr_db_logon
   global auth_db_logon
   global clr_db_logon_handle
   global flmgr_ach_ems_trans_tb


   if {[catch {set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db]} result] } {
      puts "$prod_db login Err: $result "
      exit 3
   }

   if {[catch {
           set flmgr_ach_ems_trans_tb [oraopen $clr_db_logon_handle]
        } result ]} {
      puts "Table access Err:$result"
      exit 3
   }
}


################################################################################
#
#    Procedure Name - process
#
#    Description - check if file present, parse it and populate the table 
#
#    Return - None
#
###############################################################################
proc process {} {
   global base_name
   global jp_file_mask
   global rt_file_mask
   global archive_path
   global dnld_path
   global run_date
   global flmgr_ach_ems_trans_tb
   global dnldFileCount
   global dnldFileList

   set file_list ""
   set file_count 0


   ### Find the downloaded file for the run_date
   set file_list [glob -nocomplain $dnld_path/$jp_file_mask*-$run_date]
   set file_list "$file_list [glob -nocomplain $dnld_path/$rt_file_mask*-$run_date]"


   if {$file_list == " "} {
      if {$dnldFileCount != 0} {
         puts "Could not find the downloaded file with date stamp $run_date"
         writeToResultFile $file_count $file_list
         exit 5
      } else {
         puts "No files matched glob pattern $jp_file_mask*-$run_date or $rt_file_mask*-$run_date"
         writeToResultFile $file_count $file_list
         exit 2
      }
   }

   ### Start parsing the files into the table
   foreach file $file_list {
      resetTblElements
      incr file_count
      if {[catch {open $file r} ach_file_ptr]} {
         puts "File Open Err:Cannot open ACH return file $file"
         exit 1
      }
      parseFile $ach_file_ptr

      ### Move the file to archive
      if {[catch {exec mv $file $archive_path} result]} {
         puts "File Move Err : $result"
      }
   }

   writeToResultFile $file_count $file_list

   ### Verify to see all the downloaded files are parsed into the table
   if {$file_count != $dnldFileCount} {
      puts "Count Err:Number of Files downloaded and Files parsed do not match"
      puts "Downloded - $dnldFileCount files. Files - $dnldFileList"
      puts "Parsed - $file_count files. Files - $file_list"
      exit 4
   }

}


################################################################################
#
#    Procedure Name - resetTblElements
#
#    Description - Set Default values
#
#    Return -
#
###############################################################################
proc resetTblElements {} {
   global elem
   global run_date
   global actvty_date
   array set elem {
      reportDt      ""
      msgType       "RET"
      name          ""
      idivilID      ""
      acctNum       ""
      tranCode      ""
      amt           ""
      settleType    ""
      effectDt      ""
      retCode       ""
      rcvDFI        ""
      corpTrace     ""
      batchCtlNum   ""
      orgDFITrace   ""
      fileCtlID     ""
      returnTrace   ""
      reason        ""
      info          ""
      status        "NEW"
      activityDt    ""
      processDt     ""
      processBy     ""
      comments      ""
   }

   set elem(activityDt) "$actvty_date"

   #T-1
   #foreach {element value} [array get elem] {
   #   puts "Element - $element Value= $value"
   #}

}


################################################################################
#
#    Procedure Name - parseFile
#
#    Description - File is parse based on following logic
#                  File Header 
#                  BatchHeader - Line 1
#                    Batch Detail - Line 2
#                    Batch Detail - Line 3
#                    Batch Detail- Line 4
#                  Batch Header - Line 1 
#                    ....
#
#    Return - None
#
###############################################################################
proc parseFile {file_ptr} {
   global elem

   ### name        {offset length end-offset}
   set lcl_rptDt      {123 8 130}
   # Batch Header line1 fields
   set lcl_effDate    {64 8 71}
   set lcl_batchNum   {83 7 89}
   ###Batch Header line2 - empty
   ###Batch Header line3 fields
   set lcl_acctNum    {2 9 10}
   set lcl_transCd    {12 2 13}
   set lcl_CoName     {15 22 36}
   set lcl_amt        {37 10 46}
   set lcl_stlType    {48 1 48}
   set lcl_indivID    {50 15 64}
   set lcl_retTrace   {66 15 80}
   set lcl_CoID       {82 10 91}
   ###Batch Header line4 fields
   set lcl_retCd      {2 3 4}
   set lcl_origTrace  {15 15 29}
   set lcl_RDFIID     {53 8 60}

   set line_num 0 
   set batch_cnt 0
   set insert_flag 0
   set header_mask "ACH AUTOMATED RETURNS"

   while {[gets $file_ptr line] >= 0 } {
  
      if {[string first $header_mask $line]!= -1} {
         set var [string range $line [lindex $lcl_rptDt 0] [lindex $lcl_rptDt 2]]
         set elem(reportDt) [string trim $var]
         set var "" 
      }

      if {[string range $line 1 12] == "BATCH HEADER"} {
         set line_num 1
         incr batch_cnt
      }

      if {$line_num == 1} {
         set var [string range $line [lindex $lcl_effDate 0] [lindex $lcl_effDate 2]]
         # date format in ach return file is YY/MM/DD 
         set elem(effectDt) [string trim $var]
            
         set var [string range $line [lindex $lcl_batchNum 0] [lindex $lcl_batchNum 2]] 
         set elem(batchCtlNum) [string trim $var]

         incr line_num

      } elseif {$line_num == 2} {
         if {$line == ""} {
            ### This is an empty line under the Batch Header, do nothing
         }
         incr line_num
      } elseif {$line_num == 3} {
         set var [string range $line [lindex $lcl_acctNum 0] [lindex $lcl_acctNum 2]]
         set elem(acctNum) [string trim $var]
         
         set var [string range $line [lindex $lcl_transCd 0] [lindex $lcl_transCd 2]]
         set elem(tranCode) [string trim $var]

         set var [string range $line [lindex $lcl_CoName 0] [lindex $lcl_CoName  2]]
         set elem(name) [string trim $var]

         set var [string range $line [lindex $lcl_amt 0] [lindex $lcl_amt 2]]
         set elem(amt) [string trim $var]

         set var [string range $line [lindex $lcl_stlType 0] [lindex $lcl_stlType 2]]
         if {$var == "C"} {
            set elem(settleType) "CREDIT"
         } elseif {$var == "D"} {
            set elem(settleType) "DEBIT"
         }

         set var [string range $line [lindex $lcl_indivID 0] [lindex $lcl_indivID 2]]
         set elem(idivilID) [string trim $var]

         set var [string range $line [lindex $lcl_retTrace 0] [lindex $lcl_retTrace 2]]
         set elem(returnTrace) [string trim $var]

         incr line_num

      } elseif {$line_num == 4} {
         set var [string range $line [lindex $lcl_retCd 0] [lindex $lcl_retCd 2]]
         set elem(retCode) [string trim $var]

         set elem(reason) [translateReturnCode $elem(retCode) ]

         if {[string equal -length 1 $elem(retCode) "R"]} {
            set elem(msgType) "RET"
         } else {
            set elem(msgType) "NOC"
         } 

         set var [string range $line [lindex $lcl_origTrace 0] [lindex $lcl_origTrace 2]]
         set elem(orgDFITrace) [string trim $var]

         set var [string range $line [lindex $lcl_RDFIID 0] [lindex $lcl_RDFIID 2]]
         set elem(rcvDFI) [string trim $var]

         set line_num 0
         set insert_flag 1
      } else {
         #incr line_num
      }
      set var ""

      if {$insert_flag == 1} {
         if {$batch_cnt > 0} {
            set query "INSERT INTO MASCLR.FLMGR_ACH_EMS_TRANS
                       (ACH_EMS_NBR,
                        RPT_DT,MSG_TYPE,NAME_VAR_ID,
                        INDIVL_ID,ACCT_NUM,TRANS_CODE,
                        AMOUNT,SETTL_TYPE,EFFECTIVE_DT,
                        RETURN_CODE,RECV_DFI,CORP_TRACE,
                        BATCH_CTRL_NBR,ORIG_DFI_TRACE,FILE_CTRL_ID,
                        RETURN_TRACE,REASON,ADTL_OR_CORR_INFO,
                        STATUS,ACTIVITY_DT,PROCESS_DT,
                        PROCESSED_BY,COMMENTS)
                        VALUES (SEQ_ACH_EMS_NBR.nextval,
                         to_date('$elem(reportDt)','MM/DD/YY'),
                         '$elem(msgType)','$elem(name)',
                         '$elem(idivilID)','$elem(acctNum)','$elem(tranCode)',
                         '$elem(amt)','$elem(settleType)',
                         to_date('$elem(effectDt)','YY/MM/DD'),
                         '$elem(retCode)','$elem(rcvDFI)','$elem(corpTrace)',
                         '$elem(batchCtlNum)','$elem(orgDFITrace)',
                         '$elem(fileCtlID)',
                         '$elem(returnTrace)','$elem(reason)','$elem(info)',
                         '$elem(status)',
                         to_date('$elem(activityDt)','YY/MM/DD'),
                         '$elem(processDt)',
                         '$elem(processBy)','$elem(comments)')"

            populateTable $query 
         }
         set insert_flag 0
      }
   }
 
}

################################################################################
#
#    Procedure Name - translateReturnCode
#
#    Description - This procedure returns the verbose description for a 
#                  passed R** code from the returnCode file.
#                  If it does not find the R** value, it will return the
#                  R** string.
#
#    Return - Verbose Description of the return code passed R**.
#             R** if it does not find the value in the file.
#
###############################################################################
proc translateReturnCode {code} {
   global returnCode_filePtr

   set text ""

   while { [set line [gets $returnCode_filePtr]] > 0 } {
      set line_parms [split $line :]
      if {[string equal [lindex $line_parms 0] "$code" ]} {
         set text [lindex $line_parms 1]
         seek $returnCode_filePtr 0
         break
      }
   }

   if {$text == ""} {
      return $code
   } else {
      return $text
   }
}

################################################################################
#
#    Procedure Name - populateTable
#
#    Description - Takes the query that is passed and executes it
#
#    Return - None
#
###############################################################################
proc populateTable {insertQuery} {
   global flmgr_ach_ems_trans_tb  

   if {[catch {orasql $flmgr_ach_ems_trans_tb $insertQuery} result]} {
      puts "SQL Insert Err:$result"
      puts "$insertQuery"
      exit 3
   }
}


################################################################################
#
#    Procedure Name - writeToResultFile
#
#    Description - The Result file keeps a count of files downloaded and
#                  parsed. After the main process has completed parsing,it
#                  calls this procedure to write the final count and file name 
#                  to the output file.
#
#    Return - None
#
###############################################################################
proc writeToResultFile {parseFileCount parseFileList} {
   global result_file

   if {[catch {open $result_file a} file_ptr]} {
      puts "File Open Err - Cannot open file $result_file for verification"
      exit 1
   }

   puts $file_ptr "PARSE_FILE_COUNT:$parseFileCount"
   puts $file_ptr "PARSE_FILE_LIST:$parseFileList"

   close $file_ptr

}

################################################################################
#
#    Procedure Name - readResultFile
#
#    Description - The result file (output from get_meridian_ach_return.tcl)
#                  keeps a count of the files downloaded and parsed for
#                  a given run date. 
#                  This procedure reads the file and provides the count
#                  of files downloaded which is then used by the 
#                  main process for verfication
#
#    Return - None
#
###############################################################################
proc readResultFile {} {
   global result_file
   global dnldFileCount
   global dnldFileList

   set dnldFileList ""
   set dnldFileCount 0


   if {[catch {open $result_file r} file_ptr]} {
      puts "File Open Err:Cannot open file $result_file for verification"
      exit 1
   }

   while { [set line [gets $file_ptr]] != {} } {
      set line_parms [split $line :]
      switch -exact -- [lindex  $line_parms 0] {
         "DNLD_FILE_COUNT" {
            set dnldFileCount [lindex $line_parms 1]
         }
         "DNLD_FILE_LIST" {
            set dnldFileList [lindex $line_parms 1]
         }
         default {
            puts "Other parameters [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr
}


################################################################################
#
#    Procedure Name - shutdown
# 
#    Description - Close down any open DB and files
#
#    Return - None
#
###############################################################################
proc shutdown {} {
   global clr_db_logon
   global clr_db_logon_handle
   global flmgr_ach_ems_trans_tb
   global returnCode_filePtr

   ### database logoff
   if {[catch { oralogoff $clr_db_logon_handle } result ]} {
      puts "Encountered error $result while trying to logoff from DB"
   }

   ### Close file pointer
   close $returnCode_filePtr
}


##########
## MAIN ##
##########

init $argc $argv
process
shutdown
exit 0

