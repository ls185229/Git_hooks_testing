#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: RESPN_builder_B.tcl 2457 2013-10-23 21:45:26Z bjones $

################################################################################
#
#    File Name - RESPN_builder.tcl
#
#    Description - This scripts checks to see if the neccesary files were
#                  imported into the MAS or not.
#
#    Arguments-
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    EXAMPLE = RESPN_builder.tcl -d <YYYYMMDD>
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - Error related to Program parameters/arguments
#           2 -
#           3 - DB Error
#           4 - Warning Message
#
#    Note -
#
################################################################################

package require Oratcl

source $env(MASCLR_LIB)/masclr_tcl_lib
source RESPN_layout.tm

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[lindex [split [file tail $argv0] .] 0]"
set cfg_file params.cfg
set seq_file seq_nbr.txt
## Default values
set said "A57450"
set fileType "CBDIS"
set STARS_FILESEQ_NB "1"
set error 0
set total_records 0

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################

proc usage {} {
   global programName

   puts "Usage:   $programName  <-d run date>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "           -v  incrments the verbosity (debug) level "
   puts "EXAMPLE = RESPN_parser.tcl -d 20130910"
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
   global fileName
   global outFilePtr
   global CCYYDDD
   global HHMMSS
   global createDate
   global createTime

   set runDate ""
   set runTime ""
   set inst ""
   set group ""

   foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
         "v" {
            incr MASCLR::DEBUG_LEVEL
         }
      }
   }

   if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
   }
   set runTime [clock format [clock second] -format "%H%M%S"]

   #### T-1 Need to redifine this in cfg file
   set fileName "JETPAYEAPTST.RESPN.$runDate.$runTime"
   if {[catch {open $fileName w} outFilePtr]} {
      puts "File Open Err:Cannot open outputfile $fileName"
      exit 1
   }

   ### Read the config file to get DB params
   readCfgFile $cfg_file

   ### Intitalize database variables
   initDB

   set CCYYDDD [clock format [clock seconds] -format "%Y%j"]
   set HHMMSS [clock format [clock seconds] -format "0%H%M%S"]
   set createDate [clock format [clock second] -format "%Y%m%d"]
   set createTime [clock format [clock second] -format "%H:%M:%S"]

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
   global adt_updt_tb
   global adt_tb
   global verify_tb

   ## MASCLR and TIEHOST connection ##
   if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
      puts "Encountered error $result while trying to connect to the $prod_db database "
      exit 3
   }

   if {[catch {
         set adt_updt_tb          [oraopen $clr_db_logon_handle]
         set adt_tb               [oraopen $clr_db_logon_handle]
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
   global auth_db_logon
   global said
   global fileType

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
            "SAID" {
               set said [lindex $line_parms 1]
            }
            "DATATYPE" {
               set fileType [lindex $line_parms 1]
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
#    Procedure Name - getSeqNbr
#
#    Description -
#
#    Return -
###############################################################################
proc getSeqNbr {} {
global programName
global runDate
global seq_file
global STARS_FILESEQ_NB

set seq 1

   if {[catch {open $seq_file r+} file_ptr]} {
      puts "File Open Err:Cannot open seq_file $seq_file"
      exit 1
   }

   gets $file_ptr line
   set line_parms [split $line ,]
   MASCLR::log_message "T-1 getSeqNbr runDate=$runDate, file=[lindex  $line_parms 0]" 1
   if {[lindex  $line_parms 0] == "$runDate"} {
      set seq [lindex  $line_parms 1]
      incr seq
      seek $file_ptr 0
      puts -nonewline $file_ptr ""
      seek $file_ptr 0
      puts $file_ptr "$runDate,$seq"

   } else {
      seek $file_ptr 0
      puts -nonewline $file_ptr ""
      seek $file_ptr 0
      puts $file_ptr "$runDate,$seq"
   }

   close $file_ptr

   set STARS_FILESEQ_NB $seq

}

################################################################################
#
#    Procedure Name - process
#
#    Description -
#
#    Return -
###############################################################################
proc process {} {
global programName
global runDate
global fileName
global outFilePtr
global adt_tb
global detail_record
global total_records
global response_pos

   set columns ""
   array set column_used {}
   for {set i 1} {$i <= 3} {incr i} {
      foreach {num name length type start end dflt col fmt} $RESPN::det_rec($i) {
         if {$name == "FILLER" || $name == "SEQ_NUMBER" || $name == "DTL_REC_TYPE"} {
            continue
         }
         if {[info exists column_used($name)]} {
            continue
         } else {
            set column_used($name) 1
            if {$col != {}} {
               if {[info exists column_used($col)]} {
                   continue
               } else {
                   set column_used($col) 1
               }
            }
         }
         if {$type == "d"} {
            append columns "to_char($name,'$fmt') as $name, "
         } elseif {$col != {}} {
            append columns "$col,"
         } else {
            append columns "$name, "
         }
      };#endof foreach
   }

   set columns [string trimright [string trimright $columns] ,]
   MASCLR::log_message "T-1 process columns = $columns" 1

   #### T-1 get this query where caluse accurate
   set query "select $columns
               from amex_dispute_txn
               where file_type = 'RESPN'
               and to_char(log_date,'YYYYMMDD') = '$runDate' "

   MASCLR::log_message  "T-1 QUERY = $query" 1
   #### Build detail Record 1
   orasql $adt_tb $query
   set ora_status [oramsg $adt_tb all]
   MASCLR::log_message "orastatus = \{$ora_status\}" 2
   #foreach {rc error rows peo ocicode sqltype} $ora_status {
   #    if {$rows > 0} {
   buildFileHeader

   while {[orafetch $adt_tb -dataarray adt -indexbyname] != 1403} {
         set ora_status [oramsg $adt_tb all]
         MASCLR::log_message "orastatus = \{$ora_status\}" 2
         set response_pos 0
         for {set i 1} {$i <= 3} {incr i} {
            build_DR adt $i
         }
   }; #end of while orafetch

   buildFileTrailer
    #   } else {
    #       puts "There were no RESPN records for $runDate"
    #   }
    #}
}

################################################################################
#
#    Procedure Name - buildFileHeader
#
#    Description -
#
#    Return -
###############################################################################
proc buildFileHeader {} {
global programName
global fileName
global outFilePtr
global said
global fileType
global createDate
global createTime
global total_records

   ### T-1 possibly do not need uniqe seq nbr
   ##getSeqNbr

   set header ""
   incr total_records

   foreach {num name length type start end dflt col fmt} $RESPN::header_rec {
      switch -exact -- $name {
         "RECORD_TYPE" {
             set hdrBuff(RECORD_TYPE) $dflt
         }
         "APPLICATION_SYSTEM_CODE" {
              set hdrBuff(APPLICATION_SYSTEM_CODE) $dflt
         }
         "FILE_TYPE_CODE" {
             set hdrBuff(FILE_TYPE_CODE)  $dflt
         }
         "DATATYPE" {
             set hdrBuff(DATATYPE) $dflt
         }

      }
   }; #endof foreach

   set hdrBuff(FILE_CREATION_DATE) $createDate
   set hdrBuff(SAID)     "$said"
   set hdrBuff(CLIENT_AREA) "$fileName $createDate $createTime"

   foreach {num name length type start end dflt col fmt} $RESPN::header_rec {
      MASCLR::log_message "T-1 $num $name $length $type $start $end" 3

      if {[info exists hdrBuff($name) ] == 1} {
         MASCLR::log_message "T-1 found var hdrBuff($name)=$hdrBuff($name)" 2
         append header [format "%-*s" $length $hdrBuff($name)]
         MASCLR::log_message "T-1 header=$header" 4
      } else {
         set value " "
         append header [format  "%-*s" $length $value]
      }

   }
   puts $outFilePtr $header
}

################################################################################
#
#    Procedure Name - build_DR($i)
#
#    Description -
#
#    Return -
###############################################################################
proc build_DR {buff i} {
global programName
global fileName
global outFilePtr
global said
global fileType
global createDate
   global createTime
global total_records
global response_pos

   upvar $buff dr_buff
   incr total_records

   foreach {num name length type start end dflt col fmt} $RESPN::det_rec($i) {
      MASCLR::log_message "T-1 $num $name $length $type $start $end $dflt $fmt" 3


      if {[info exists dr_buff($name) ] == 1 || [info exists dr_buff($col) ] == 1 } {
            if {[info exists dr_buff($name) ] == 1} {
               MASCLR::log_message "T-1 found var dr_buff($name)=$dr_buff($name)" 2
            } else {
               MASCLR::log_message "T-1 found var dr_buff($col)=$dr_buff($col)" 2
            }

            if {$dflt != {}} {
               set local($name) $dflt
            }
            switch -exact -- $name {
               "DTL_REC_TYPE" {
                  set local($name) "D"
               }
               "SEQ_NUMBER" {
                  set local($name) "0$i"
               }
            }


            if {$name == "DOLLAR_AMOUNT"} {
               append detail_rec [format "%0*s" $length $dr_buff($name)]
            } elseif {$name == "RESPONSE_EXPLANATION_1"} {
               set response_end [expr $response_pos + $length -1]
               MASCLR::log_message "T-1 before $name $length response_pos=$response_pos, response_end=$response_end" 3
               append detail_rec [format "%-*s" $length [string range $dr_buff($col) $response_pos $response_end ]]
               set response_pos [expr $response_pos + $length]
               MASCLR::log_message "T-1 after $name response_pos=$response_pos, response_end=$response_end" 3
            } elseif {$name == "RESPONSE_EXPLANATION_2"} {
               set response_end [expr $response_pos + $length -1]
               MASCLR::log_message "T-1 before $name $length response_pos=$response_pos, response_end=$response_end" 3
               append detail_rec [format "%-*s" $length [string range $dr_buff($col) $response_pos $response_end ]]
               set response_pos [expr $response_pos + $length]
               MASCLR::log_message "T-1 after $name response_pos=$response_pos, response_end=$response_end" 3
            } elseif {$name == "RESPONSE_EXPLANATION_3"} {
               set response_end [expr $response_pos + $length -1]
               MASCLR::log_message "T-1 before $name $length response_pos=$response_pos, response_end=$response_end" 3
               append detail_rec [format "%-*s" $length [string range $dr_buff($col) $response_pos $response_end ]]
               set response_pos [expr $response_pos + $length]
               MASCLR::log_message "T-1 after $name response_pos=$response_pos, response_end=$response_end" 3
            } else {
               if {[info exists dr_buff($name) ] == 1} {
                  append detail_rec [format "%-*s" $length $dr_buff($name)]
               } else {
                  append detail_rec [format "%-*s" $length $dr_buff($col)]
               }
            }
            MASCLR::log_message "T-1 detail_rec=$detail_rec" 5
      } elseif {[info exists local($name) ] == 1} {
            append detail_rec [format "%-*s" $length $local($name)]
            MASCLR::log_message "T-1 found var local($name)=$local($name)" 2
      } else {
            set value " "
            switch -exact -- $name {
               "DTL_REC_TYPE" {
                  set value "D"
               }
               "SEQ_NUMBER" {
                  set value "0$i"
               }
            }
            append detail_rec [format  "%-*s" $length $value]
      }

   }
   puts $outFilePtr $detail_rec
}


################################################################################
#
#    Procedure Name - buildFileTrailer
#
#    Description -
#
#    Return -
###############################################################################
proc buildFileTrailer {} {
global programName
global fileName
global outFilePtr
global said
global fileType
global createDate
   global createTime
global total_records

   ### T-1 possibly do not need uniqe seq nbr
   ##getSeqNbr

   set trailer ""
   incr total_records

   foreach {num name length type start end dflt col fmt} $RESPN::trailer_rec {
      switch -exact -- $name {
         "RECORD_TYPE" {
             set trlBuff(RECORD_TYPE) $dflt
         }
         "APPLICATION_SYSTEM_CODE" {
              set trlBuff(APPLICATION_SYSTEM_CODE) $dflt
         }
         "FILE_TYPE_CODE" {
             set trlBuff(FILE_TYPE_CODE)  $dflt
         }
         "DATATYPE" {
             set trlBuff(DATATYPE) $dflt
         }

      }
   }; #endof foreach

   set trlBuff(FILE_CREATION_DATE) $createDate
   set trlBuff(SAID)     "$said"

   #### T-1 This is hardcoded because the parser is not populating it in the table.
   ### definately needs to be fixed

   set trlBuff(AMEX_TOTAL_RECORDS) $total_records
   set trlBuff(SE_TOTAL_RECORDS)   $total_records

   foreach {num name length type start end dflt col fmt} $RESPN::trailer_rec {
      MASCLR::log_message "T-1 $num $name $length $type $start $end" 3

      if {[info exists trlBuff($name) ] == 1} {
         MASCLR::log_message "T-1 found var trlBuff($name)=$trlBuff($name)" 2
         if {$name == "AMEX_TOTAL_RECORDS" || $name == "SE_TOTAL_RECORDS"} {
            append trailer [format "%0*s" $length $trlBuff($name)]
         } else {
            append trailer [format "%-*s" $length $trlBuff($name)]
         }
         MASCLR::log_message "T-1 trailer=$trailer" 5
      } else {
         set value " "
         append trailer [format  "%-*s" $length $value]
      }

   }
   puts $outFilePtr $trailer
}

##########
## MAIN ##
##########

init $argv
process

