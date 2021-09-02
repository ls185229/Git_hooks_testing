#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: $

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

################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################

proc usage {} {
   global programName

   puts "Usage:   $programName <-d run date>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "EXAMPLE = RESPN_builder.tcl -d 20130910"
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

   set runDate ""
   set inst ""
   set group ""

    foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
       }
    }


    if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
    }

    #### T-1 Need to redifine this in cfg file
    set fileName "JETPAYEAPTST.RESPN.$runDate"
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
   global ami_tb
   global adt_tb
   global verify_tb


    ## MASCLR and TIEHOST connection ##
    if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
       puts "Encountered error $result while trying to connect to the $prod_db database "
       exit 3
    }

    if {[catch {
           set ami_tb               [oraopen $clr_db_logon_handle]
           set adt_tb                [oraopen $clr_db_logon_handle]
           set verify_tb             [oraopen $clr_db_logon_handle]
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
#    Procedure Name -
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
    puts "T-1 runDate=$runDate, file=[lindex  $line_parms 0]"
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

   buildFileHeader
   set columns ""
   foreach {num name length type start end dflt col fmt} $RESPN::det_rec(1) {
      if {$name == "FILLER" || $name == "SEQ_NUMBER" || $name == "DTL_REC_TYPE"} {
         continue
      }
      if {$name == "DATE_ACTION_TAKEN"} {
         append columns "to_char ($name,'YYYYMMDD') as $name, "
      } elseif {$name == "RESPONSE_EXPLANATION_1" || $name == "TRIUMPH_AREA"} {
         append columns "$col as $name,"
      } else {
         append columns "$name, "
      }
   };#endof foreach

   set columns [string trimright [string trimright $columns] ,]
   puts "T-1 columns = $columns"

   #### T-1 get this query where caluse accurate
   set query "select $columns
               from amex_dispute_txn
               where file_type = 'RESPN'
               and to_char(log_date,'YYYYMMDD') = '$runDate' "

   puts "T-1 QUERY= $query"
   #### Build detail Record 1
   orasql $adt_tb $query
   while {[orafetch $adt_tb -dataarray adt -indexbyname] != 1403} {
       buildDR1 adt
       ### T-1 this is bug, using dr1 query to build dr2 and dr3
       buildDR2 adt
       buildDR3 adt
   }; #end of while orafetch

   #### Build Detail record 2


   buildFileTrailer
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

   ### T-1 possibly do not need uniqe seq nbr
   ##getSeqNbr

   set header ""
 
   foreach {num name length type start end dflt col fmt} $RESPN::header_rec {
      switch -exact -- $name {
         "RECORD_TYPE" {
             set hdrBuff(RECORD_TYPE) $dflt
         }
         "APPLICATION_SYSTEM_CODE" {
              set hdrBuff(APPLICATION_SYSTEM_CODE) [string trimleft [string trimright $dflt \"] \"]
         }
         "FILE_TYPE_CODE" {
             set hdrBuff(FILE_TYPE_CODE) [string trimleft [string trimright $dflt \"] \"]
         }
         "DATATYPE" {
             set hdrBuff(DATATYPE) $dflt
         }
       
      }
   }; #endof foreach

   set hdrBuff(FILE_CREATION_DATE) $createDate
   set hdrBuff(SAID)     "$said"

   foreach {num name length type start end dflt col fmt} $RESPN::header_rec {
       #puts "T-1 $num $name $length $type $start $end"

       if {[info exists hdrBuff($name) ] == 1} {
          #puts "T-1 found var hdrBuff($name)=$hdrBuff($name)"
          append header [format "%-*s" $length $hdrBuff($name)]
          #puts "T-1 header=$header"
       } else {
          set value " "
          append header [format  "%-*s" $length $value]
       }

   }
   puts $outFilePtr $header
}

################################################################################
#
#    Procedure Name - buildDR1
#
#    Description -
#
#    Return -
###############################################################################
proc buildDR1 {buff} {
global programName
global fileName
global outFilePtr
global said
global fileType
global createDate


   upvar $buff dr1Buff

   foreach {num name length type start end dflt col fmt} $RESPN::det_rec(1) {
      switch -exact -- $name {
         "DTL_REC_TYPE" {
             set local(DTL_REC_TYPE) $dflt
         }
         "SEQ_NUMBER" {
             set local(SEQ_NUMBER) [string trimleft [string trimright $dflt \"] \"]
         }
      }
   }; #endof foreach

   foreach {num name length type start end dflt col fmt} $RESPN::det_rec(1) {
       #puts "T-1 $num $name $length $type $start $end"

       if {[info exists dr1Buff($name) ] == 1} {
          #puts "T-1 found var dr1Buff($name)=$dr1Buff($name)"
          if {$name == "DOLLAR_AMOUNT"} {
              append detailRec1 [format "%0*s" $length $dr1Buff($name)]
          } else {
              append detailRec1 [format "%-*s" $length $dr1Buff($name)]
          }
          #puts "T-1 detailRec1=$detailRec1"
       } elseif {[info exists local($name) ] == 1} {
          append detailRec1 [format "%-*s" $length $local($name)]
         #  puts "T-1 found var local($name)=$local($name)"
       } else {
          set value " "
          append detailRec1 [format  "%-*s" $length $value]
       }

   }
   puts $outFilePtr $detailRec1
}


################################################################################
#
#    Procedure Name - buildDR2
#
#    Description -
#
#    Return -
###############################################################################
proc buildDR2 {buff} {
global programName
global fileName
global outFilePtr
global said
global fileType
global createDate


   upvar $buff dr2Buff

   foreach {num name length type start end dflt col fmt} $RESPN::det_rec(2) {
      switch -exact -- $name {
         "DTL_REC_TYPE" {
             set local(DTL_REC_TYPE) $dflt
         }
         "SEQ_NUMBER" {
             set local(SEQ_NUMBER) [string trimleft [string trimright $dflt \"] \"]
         }
      }
   }; #endof foreach

   foreach {num name length type start end dflt col fmt} $RESPN::det_rec(2) {
       puts "T-1 $num $name $length $type $start $end"

       if {[info exists dr2Buff($name) ] == 1} {
          puts "T-1 found var dr2Buff($name)=$dr2Buff($name)"

          append detailRec2 [format "%-*s" $length $dr2Buff($name)]

          #puts "T-1 detailRec2=$detailRec2"
       } elseif {$name == "RESPONSE_EXPLANATION_2"} {
          #### T-1 this is shortcut, need a better way to desig
          append detailRec2 [format "%-*s" $length $dr2Buff(RESPONSE_EXPLANATION_1)]
       } elseif {[info exists local($name) ] == 1} {
          append detailRec2 [format "%-*s" $length $local($name)]
         #  puts "T-1 found var local($name)=$local($name)"
       } else {
          set value " "
          append detailRec2 [format  "%-*s" $length $value]
       }

   }
   puts $outFilePtr $detailRec2
}

################################################################################
#
#    Procedure Name - buildDR3
#
#    Description -
#
#    Return -
###############################################################################
proc buildDR3 {buff} {
global programName
global fileName
global outFilePtr
global said
global fileType
global createDate


   upvar $buff dr3Buff

   foreach {num name length type start end dflt col fmt} $RESPN::det_rec(3) {
      switch -exact -- $name {
         "DTL_REC_TYPE" {
             set local(DTL_REC_TYPE) $dflt
         }
         "SEQ_NUMBER" {
             set local(SEQ_NUMBER) [string trimleft [string trimright $dflt \"] \"]
         }
      }
   }; #endof foreach

   foreach {num name length type start end dflt col fmt} $RESPN::det_rec(3) {
       #puts "T-1 $num $name $length $type $start $end"

       if {[info exists dr3Buff($name) ] == 1} {
          puts "T-1 found var dr3Buff($name)=$dr3Buff($name)"

          append detailRec3 [format "%-*s" $length $dr3Buff($name)]

          #puts "T-1 detailRec3=$detailRec3"
       } elseif {$name == "RESPONSE_EXPLANATION_3"} {
          #### T-1 this is shortcut, need a better way to desig
          append detailRec3 [format "%-*s" $length $dr3Buff(RESPONSE_EXPLANATION_1)]
       } elseif {[info exists local($name) ] == 1} {
          append detailRec3 [format "%-*s" $length $local($name)]
         #  puts "T-1 found var local($name)=$local($name)"
       } else {
          set value " "
          append detailRec3 [format  "%-*s" $length $value]
       }

   }
   puts $outFilePtr $detailRec3
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

   ### T-1 possibly do not need uniqe seq nbr
   ##getSeqNbr

   set trailer ""

   foreach {num name length type start end dflt col fmt} $RESPN::trailer_rec {
      switch -exact -- $name {
         "RECORD_TYPE" {
             set trlBuff(RECORD_TYPE) $dflt
         }
         "APPLICATION_SYSTEM_CODE" {
              set trlBuff(APPLICATION_SYSTEM_CODE) [string trimleft [string trimright $dflt \"] \"]
         }
         "FILE_TYPE_CODE" {
             set trlBuff(FILE_TYPE_CODE) [string trimleft [string trimright $dflt \"] \"]
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

   set trlBuff(AMEX_TOTAL_RECORDS) "1"
   set trlBuff(SE_TOTAL_RECORDS)   "1"

   foreach {num name length type start end dflt col fmt} $RESPN::trailer_rec {
       #puts "T-1 $num $name $length $type $start $end"

       if {[info exists trlBuff($name) ] == 1} {
          #puts "T-1 found var trlBuff($name)=$trlBuff($name)"
          if {$name == "AMEX_TOTAL_RECORDS" || $name == "SE_TOTAL_RECORDS"} {
              append trailer [format "%0*s" $length $trlBuff($name)]
          } else {
              append trailer [format "%-*s" $length $trlBuff($name)]
          }
          #puts "T-1 trailer=$trailer"
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

