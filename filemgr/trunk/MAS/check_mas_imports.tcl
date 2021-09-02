#!/usr/bin/env tclsh

# $Id: check_mas_imports.tcl 4905 2019-10-13 03:05:36Z bjones $

################################################################################
#
#    File Name - check_mas_imports.tcl
#
#    Description - This scripts checks to see if the neccesary files were
#                  imported into the MAS or not.
#
#    Arguments   -i = institution_id
#                -g = Group, this is user defined, optional.
#                     Currently it supports OKDMV.
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    EXAMPLE = check_mas_imports.tcl -i 107 -g OKDMV -d 20130910
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - Error related to Program parameters/arguments
#           2 - Found missing file
#           3 - DB Error
#           4 - Warning Message
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

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################

proc usage {} {
   global programName

   puts "Usage:   $programName <-i institution> <-g group> <-d run date>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "           -i = institution"
   puts "           -g = Group, user defined, optional. Presently supports OKDMV"
   puts "EXAMPLE = check_mas_imports.tcl -i 107 -g OKDMV -d 20130910"
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
   global group
   global cycle

   set runDate ""
   set inst ""
   set group ""


   foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
         "i" {
            set inst [lrange $opt 1 end]
         }
         "g" {
            set group [lrange $opt 1 end]
         }
         ""  { puts "blank at end of >$argv<"}
         default {
            puts "Unknown parameter >$opt<"
         }
      }
   }


   if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
   }

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
   global mftc_tb
   global mfl_tb
   global verify_tb


   ## MASCLR and TIEHOST connection ##
   if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
      puts "Encountered error $result while trying to connect to the $prod_db database "
      exit 3
   }

   if {[catch {
           set mftc_tb               [oraopen $clr_db_logon_handle]
           set mfl_tb                 [oraopen $clr_db_logon_handle]
           set verify_tb                [oraopen $clr_db_logon_handle]
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
   global auth_db_logon

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
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
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
#    Description - Gets the expected file count, actual file count and compares the values
#
#    Return - 2 - if actual < expected
#             4 - if actual > expected, this is just a warning/notification
#
###############################################################################
proc process {} {
   global programName
   global mfl_tb
   global mftc_tb
   global verify_tb
   global inst
   global runDate
   global group
   global error
   global warning

   set error 0
   set warning 0
   set other ""

   if {$group != ""} {
      set other "and category = '$group'"
   }


   set query "select count(1) as CNT,sum(file_count) as EXPECTED_COUNT
              from mas_file_type_count
              where institution_id = '$inst'
              $other"


   orasql $mftc_tb $query

   while {[orafetch $mftc_tb -dataarray mftc -indexbyname] != 1403} {
       if {$mftc(CNT) == 0} {
          puts "Could not find the expected values for this group $group in mas_file_type_count"
          set error 1
       }
   } ; # endof while mftc

   if {$group == "OKDMV"} {
      set query "select count(1) as ACTUAL_COUNT
                 from mas_file_log
                 where institution_id = '$inst'
                 and receive_date_time between to_date('$runDate'||'181500', 'YYYYMMDDHH24MISS') and to_date('$runDate', 'YYYYMMDD') + 1"
   } else {
     ### This section is simply a filler for future use. Modify the query as per the requirement.
     set query "select count(1) as ACTUAL_COUNT
                 from mas_file_log
                 where institution_id = '$inst'
                 and receive_date_time between to_date('$runDate','YYYYMMDD') and to_date('$runDate', 'YYYYMMDD') + 1"

   }

   orasql $mfl_tb $query

   while {[orafetch $mfl_tb -dataarray mfl -indexbyname] != 1403} {
       if {$mfl(ACTUAL_COUNT) == 0} {
          puts "No file has been imported into MAS for this group $inst $group. Query used \n$query"
          set error 1
       }
   } ; #endof while mfl

   if {$mfl(ACTUAL_COUNT) < $mftc(EXPECTED_COUNT)} {
      puts "Number of files imported into MAS do not match expected"
      puts "EXPECTED = $mftc(EXPECTED_COUNT), ACTUAL = $mfl(ACTUAL_COUNT)"
      set error 1
   }

   if {$mfl(ACTUAL_COUNT) > $mftc(EXPECTED_COUNT)} {
      puts "WARNING:Number of files imported into MAS do not match expected"
      puts "EXPECTED = $mftc(EXPECTED_COUNT), ACTUAL = $mfl(ACTUAL_COUNT)"
      puts "Update the mas_file_type_count table if neccessary"
      set warning 1
   }

   if {$error != 1} {
      puts "EXPECTED = $mftc(EXPECTED_COUNT), ACTUAL = $mfl(ACTUAL_COUNT)"
   }

   return
}

##########
## MAIN ##
##########

init "$argv"
process
puts "programName.tcl end [clock format [clock seconds] -format "%Y%m%d%H%M%S"]\n"
if {$error == 1} {
  puts "ERROR:- Program did not run successfully for $inst $group"
   exit 2
}
if {$warning == 1} {
   exit 4
}
puts "=====================END SUCCESS=================================="
