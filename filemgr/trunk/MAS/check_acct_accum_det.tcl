#!/usr/bin/env tclsh

# $Id: check_acct_accum_det.tcl 3577 2015-11-13 18:15:11Z bjones $

################################################################################
#
#    File Name - check_acct_accum_det.tcl
#
#    Description - This scripts check the acct_accum_det table for any pending
#                  payments that did not make the ACH cut for a given run date.
#
#    Arguments   -i = institution_id
#                -s = short name
#                -d = run date YYYYMMDD optional, defaults to sysdate
#                -c = payment cycle,optional. Defaults to cycle = 1
#
#    EXAMPLE = check_acct_accum_det.tcl -i 107 -s OKDMV -d 20130910 -c 5
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - Error related to Program parameters/arguments
#           2 - Found pending payments that did not go out
#           3 - DB Error
#
#    Note - This script should be ran only on business days, if ran on weekend
#           will result in false alarms.
#           Also will not work on APPLE since day on 5 days delay
#
################################################################################

package require  Oratcl

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

   puts "Usage:   $programName <-i institution> <-s shortname> <-d date> <-c cycle>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "           -i = institution"
   puts "           -s = shortname"
   puts "           -c = Payment cycle, optional. Defaults to 1"
   puts "EXAMPLE = check_acct_accum_det.tcl -i 107 -s OKDMV -d 20130910 -c 5"
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
   global shortname
   global cycle

   set runDate ""
   set inst ""
   set shortname ""
   set cycle ""

   foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
         "i" {
            set inst [lrange $opt 1 end]
         }
         "s" {
            set shortname [lrange $opt 1 end]
         }
         "c" {
            set cycle [lrange $opt 1 end]
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

   if {$shortname == ""} {
      puts "Insufficient Arguments"
      usage
      exit 1
   }

   if {$cycle == ""} {
      set cycle 1
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
   global prod_auth_db
   global clr_db_logon
   global auth_db_logon
   global e2a_tb
   global aad_tb
   global ea_tb
   global merchant_tb


   ## MASCLR and TIEHOST connection ##
   if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
      puts "Encountered error $result while trying to connect to the $prod_db database "
      exit 3
   }

   if {[catch {set auth_db_logon_handle [oralogon $auth_db_logon@$prod_auth_db]} result ]  } {
      puts "Encountered error $result while trying to connect to the $prod_auth_db database "
      exit 3
   }

   if {[catch {
           set merchant_tb           [oraopen $auth_db_logon_handle]
           set verify_handle         [oraopen $auth_db_logon_handle]
           set e2a_tb                [oraopen $clr_db_logon_handle]
           set ea_tb                 [oraopen $clr_db_logon_handle]
           set aad_tb                [oraopen $clr_db_logon_handle]
        } result ]} {
      puts "Encountered error $result while creating db handles"
      exit 3
   }

}

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - parses the config file to get DB attributes
#
#    Return - exits with rc=1 if any error
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

   if {$auth_db_logon == ""} {
      puts "Unable to find AUTH_DB_LOGON params in $cfg_file_name, exiting..."
      exit 1
   }

}


################################################################################
#
#    Procedure Name - process
#
#    Description - Checks acct_accum_det table for any non ached payments for the
#                  given run date
#
#    Return - exit rc=2 if any non ached payments found
#
###############################################################################
proc process {} {
   global programName
   global e2a_tb
   global aad_tb
   global ea_tb
   global merchant_tb
   global inst
   global runDate
   global shortname
   global cycle
   global error

   set error 0

   set query "select unique entity_id
              from entity_to_auth
              where institution_id in ('$inst')
              and file_group_id in ('$shortname')
              and status = 'A'
              and entity_id not in ('447474210000133', '447474210000135', '447474310000100',
                                    '447474310000101', '447474310000102', '447474210000139')"

   ###puts "T-1 e2a query - $query"

   orasql $e2a_tb $query

   while {[orafetch $e2a_tb -dataarray e2a -indexbyname] != 1403} {
      set query "select aad.Institution_Id as iid,
                         ea.customer_name as name,
                         ea.Owner_Entity_Id as eid,
                         aad.Settl_Date as sdate,
                         aad.payment_proc_dt as pdate,
                         aad.Payment_Seq_Nbr as psn,
                         aad.Amt_Pay as samt,
                         Aad.Amt_Fee as famt,
                         ea.entity_acct_desc as acct
                   From Acct_Accum_Det aad, Entity_Acct ea
                   Where aad.Institution_Id = '$inst'
                   and ea.Institution_Id = aad.institution_id
                   and ea.Entity_Acct_Id = aad.Entity_Acct_Id
                   and to_char(aad.Settl_Date,'YYYYMMDD') ='$runDate'
                   and aad.payment_cycle = '$cycle'
                   and aad.Payment_Status Is Null
                   and ea.Owner_Entity_Id = '$e2a(ENTITY_ID)'
                   and ea.Acct_Posting_Type <> 'R'
                   and ea.stop_pay_flag is null"

      ###puts "T-1 aad - $query"

       orasql $aad_tb $query

       while  {[orafetch $aad_tb -dataarray aad -indexbyname] != 1403} {
          set error 1
          puts "Inst-$aad(IID),Customer-$aad(NAME),ID-$aad(EID),Account-$aad(ACCT)"
          puts "PaySeqNbr=$aad(PSN),SettleDate=$aad(SDATE),Amount=$aad(SAMT),Fees=$aad(FAMT)\n"
       }; #endof while aad


   } ; # endof while e2a

   if {$error == 1} {
      puts "ERROR:- Found payments that did not make the ACH. Please check the log file"
   }

}

##########
## MAIN ##
##########

init $argv
process
puts "programName.tcl end [clock format [clock seconds] -format "%Y%m%d%H%M%S"]\n"
if {$error == 1} {
   puts "ERROR:- Found payments that did not make the ACH. Please check the log file"
   exit 2
}
puts "=====================END=================================="
