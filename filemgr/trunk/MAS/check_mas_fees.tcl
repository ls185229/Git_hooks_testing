#!/usr/bin/env tclsh

# $Id: check_mas_fees.tcl 3577 2015-11-13 18:15:11Z bjones $

################################################################################
#
#    File Name - check_mas_fees.tcl
#
#    Description - This code checks transaction in  mas_trans_log table
#                  for all the daily fees being computed or not.
#
#
#    Arguments   -i = institution_id
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    EXAMPLE = check_mas_fees.tcl -i 107 -d 20130910
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - Error related to Program parameters/arguments
#           2 - Found transaction with missing fees
#           3 - DB Error
#
#    Note -
#
################################################################################

package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[lindex [split [file tail $argv0] .] 0]"
set cfg_file db_params.cfg
set error 0
set cutoffTime "070000"

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################

proc usage {} {
   global programName

   puts "Usage:   $programName <-i institution> <-d run date>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "           -i = institution"
   puts "EXAMPLE = check_mas_fees.tcl -i 107 -d 20130910"
}

################################################################################
#
#    Procedure Name - init
#
#    Description - Initialize program arguments
#
###############################################################################
proc init {argv} {
   global programName
   global cfg_file
   global inst
   global runDate
   global cycle
   global dayBefore

   set runDate ""
   set inst ""
   set dayBefore ""


   foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
         "i" {
            set inst [lrange $opt 1 end]
         }
      }
   }


   if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
   }

   set dayBefore [clock format [clock scan "$runDate -1 day"] -format "%Y%m%d"]

   puts "T-1 runDate = $runDate dayBefore $dayBefore"

   if {$inst == ""} {
      puts "Insufficient Arguments"
      usage
      exit 1
   }


   ### Read the config file to get DB params
   readCfgFile $cfg_file

   ### Intitalize database variables
   initDB

   puts "============================START=========================="
   puts "$programName.tcl started at [clock format [clock seconds] -format "%Y%m%d%H%M%S"]\n"
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
   global programName
   global prod_db
   global clr_db_logon
   global mtl_tb
   global mfl_tb
   global verify_tb


   ## MASCLR and TIEHOST connection ##
   if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
      puts "Encountered error $result while trying to connect to the $prod_db database "
      exit 3
   }

   if {[catch {
           set mtl_tb               [oraopen $clr_db_logon_handle]
           set mfl_tb               [oraopen $clr_db_logon_handle]
           set verify_tb            [oraopen $clr_db_logon_handle]
        } result ]} {
      puts "Encountered error $result while creating db handles"
      exit 3
   }

}

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - Gets the DB parameters
#
#    Return - 3 if any error
#
###############################################################################
proc readCfgFile {cfg_file_name} {
   global programName
   global clr_db_logon

   set clr_db_logon ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
      puts "File Open Err:Cannot open config file $cfg_file_name"
      exit 1
   }


   while { [set line [gets $file_ptr]] != {}} {
      set line_parms [split $line ,]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
      puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
      exit 1
   }

}


################################################################################
#
#    Procedure Name - process
#
#    Description - Counts the rows for each tran_seq_nbr, if its less than 2,
#                  generates an error.
#
#    Return - 2 - If finds transactions with missing fees
#
###############################################################################
proc process {} {
   global programName
   global mfl_tb
   global mtl_tb
   global verify_tb
   global inst
   global runDate
   global dayBefore
   global cutoffTime
   global error

   set cnt 0
   set error 0

   set query "select unique institution_id,mas_code
              from mas_trans_log
              where (institution_id ,trans_seq_nbr) in (
              select institution_id,trans_seq_nbr
              from mas_trans_log
              where institution_id = '$inst'
              and substr(tid,1,6) in ('010004')
              and trans_seq_nbr in (select unique trans_seq_nbr
                                    from mas_trans_log
                                    where institution_id = '$inst'
                                    and tid in('010003005101','010003005104')
                                    and file_id in (select file_id from mas_file_log
                                                    where institution_id = '$inst'
                                                    and substr(file_name,5,8) in ('CLEARING','DEBITRAN')
                                                    and to_char(receive_date_time,'YYYYMMDDHH24MISS')
                                                        between '$dayBefore'||'$cutoffTime'
                                                        and '$runDate'||'$cutoffTime'))
             group by institution_id,trans_seq_nbr
             having count(1) < 2 )"

   puts "Check Query = $query"
   puts "MAS CODE  that did not have all the fees calculated for $inst"
   puts "Count = $cnt"

   orasql $mtl_tb $query

   while {[orafetch $mtl_tb -dataarray mtl -indexbyname] != 1403} {
      incr cnt
      if {$cnt <= 10} {
         puts "Institution=$mtl(INSTITUTION_ID), MasCode = $mtl(MAS_CODE)"
         set error 1
      } else  {
         puts "Above is the list of first 10 mas code with missing fees"
         puts "Use the check query to get the complete listing for $inst"
         set error 1
         break
      }
   }

   return
}

##########
## MAIN ##
##########

init $argv
process
puts "programName.tcl end [clock format [clock seconds] -format "%Y%m%d%H%M%S"]\n"
if {$error == 1} {
   puts "Found transactions with missing fees in mas_trans_log"
   exit 2
}

puts "=====================END SUCCESS=================================="
