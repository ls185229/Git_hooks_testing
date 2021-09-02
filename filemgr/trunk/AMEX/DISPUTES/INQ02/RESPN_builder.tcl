#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: RESPN_builder.tcl 2457 2013-10-23 21:45:26Z bjones $

################################################################################
#
#    File Name - RESPN_parser.tcl
#
#    Description - This scripts checks to see if the neccesary files were
#                  imported into the MAS or not.
#
#    Arguments-  -f = file to parse
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    EXAMPLE = RESPN_parser.tcl -f <filename> -d <YYYYMMDD>
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

source INQ02_layout.tm
source RESPN_layout.tm

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[file tail $argv0]"
set cfg_file params.cfg
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

   puts "Usage:   $programName <-f file to parse> <-d run date>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "           -f = file to parse "
   puts "           -v  incrments the verbosity (debug) level "
   puts "EXAMPLE = RESPN_parser.tcl -f file -d 20130910"
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
   global inputFile

   set runDate ""
   set inst ""
   set group ""

    foreach {opt} [split $argv -] {
        switch -exact -- [lindex $opt 0] {
            "d" {
                set runDate [lrange $opt 1 end]
            }
            "f" {
                set inputFile [lrange $opt 1 end]
            }
            "v" {
                incr MASCLR::DEBUG_LEVEL
            }
        }
    }

    if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
    }

    if {$inputFile == ""} {
      puts "Insufficient Arguments:Need file name to parse"
      usage
      exit 1
    }

    ### Read the config file to get DB params
    readCfgFile $cfg_file

    ### Intitalize database variables
    initDB

    MASCLR::log_message "============================START=========================="
    MASCLR::log_message "$programName started at [clock format [clock seconds] -format "%Y%m%d%H%M%S"]\n"
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
   global ami_tb        # ami = alt_merchant_id table
   global adt_tb        # adt = amex_dispute_txn table
   global verify_tb

   global mftc_tb
   global mfl_tb
   global verify_tb


    ## MASCLR and TIEHOST connection ##
    if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
       puts "Encountered error $result while trying to connect to the $prod_db database "
       exit 3
    }

    if {[catch {
           set ami_tb                [oraopen $clr_db_logon_handle]
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
#    set the structure for record layout
#
###############################################################################


################################################################################
#
#    Procedure Name - process
#
#    Description - Gets the expected file count, actual file count and compares the values
#
#    Return -
###############################################################################
proc INQ02_validate {} {
    global programName
    global inputFile
    global maxHdrFld
    global maxDetailFld
    global Trl_Value
    global hdr_value
    global ami_tb        # ami = alt_merchant_id table
    global adt_tb        # adt = amex_dispute_txn table

    set logDate [clock format [clock second] -format "%Y%m%d%H%M%S"]

    set cntr 0
    set institution_id ""
    set entity_id ""
    set insertValue ""
    set insertColumn ""

    ## Reset the header buffer
    foreach {num name length type start end dflt col fmt} $INQ02::header_rec {
       set hdr_value($name) ""
    }

    ## Reset the detail record buffer
    foreach {num name length type start end dflt col fmt} $INQ02::detail_front {
       MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 2
       set DetailValue($name) ""
    }

    if {[catch {open $inputFile r} filePtr]} {
        puts "File Open Err:Cannot open file $inputFile"
        exit 1
    }

    MASCLR::log_message  "Parsing file : $inputFile"
    while { [gets $filePtr line] >= 0 } {
        MASCLR::log_message  "Inside file loop" 5
        switch -exact -- [ string range $line 0 0 ] {
            "H" {
                MASCLR::log_message  "Parsing Header Record" 1
                foreach {num name length type start end dflt col fmt} $INQ02::header_rec {
                   MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 4
                   set hdr_value($name) [string range $line [expr $start - 1] [expr $end - 1]]
                   set    l_msg "T-1 hdr_value($name) "
                   append l_msg "len [string length $hdr_value($name)] = "
                   append l_msg ">>$hdr_value($name)<<"
                   MASCLR::log_message  $l_msg 3
                }; #end of for loop
            }
            "D" {
                MASCLR::log_message  "\nParsing Detail Record" 2

                foreach {num name length type start end dflt col fmt} $INQ02::detail_front {
                    MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 4
                    set DetailValue($name) [string range $line [expr $start - 1] [expr $end - 1]]
                    MASCLR::log_message  "T-1 DetailValue($name) len [string length $DetailValue($name)] = >>$DetailValue($name)<<" 3
                    if { $DetailValue(CASE_TYPE) == "FRAUD" &&
                            [string range $name 0 3] == "NOTE" } {
                        if { [string trim $DetailValue($name)] != "" } {
                            switch -exact -- $name {
                                NOTE1 -
                                NOTE2 {
                                    # no operation
                                }
                                NOTE3 -
                                NOTE4 -
                                NOTE5 -
                                NOTE6 -
                                NOTE7 {
                                    set note_nbr [string range $name end-1 end]
                                    foreach {f_num f_name f_length f_type f_start f_end f_dflt f_col f_fmt} $INQ02::detail_fraud($name) {
                                        MASCLR::log_message  "T-1 $f_num $f_name $f_length $f_type $f_start $f_end $f_end $f_dflt $f_col $f_fmt" 4
                                        set DetailValue($f_name$note_nbr) [string range $line [expr $f_start - 1] [expr $f_end - 1]]
                                        set    l_msg "T-1 DetailValue($f_name$note_nbr) "
                                        append l_msg "len "
                                        append l_msg "[string length $DetailValue($f_name$note_nbr)] "
                                        append l_msg "= >>$DetailValue($f_name$note_nbr)<<"
                                        append l_msg ""
                                        MASCLR::log_message $l_msg 1
                                    }
                                }
                            }
                        }
                    }

                }; #end of for loop

                # CASE_TYPE CRCDW  will be ignored for now.
                switch -exact -- $DetailValue(CASE_TYPE) {
                    AIRDS -
                    AIRLT -
                    AIRRT -
                    AIRTB -
                    AREXS -
                    CARRD -
                    GSDIS -
                    NAXMG -
                    NAXMR -
                    SEDIS -
                    FRAUD {
                        set detail_back $INQ02::detail_rec($DetailValue(CASE_TYPE))
                    }
                    default {
                        puts "\nUnknown CASE_TYPE: $DetailValue(CASE_TYPE)\n"
                        exit 1
                    }
                }
                foreach {num name length type start end dflt col fmt} $detail_back {
                    MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 4
                    set DetailValue($name) [string range $line [expr $start - 1] [expr $end - 1]]
                    MASCLR::log_message  "T-1 DetailValue($name) len [string length $DetailValue($name)] = >>$DetailValue($name)<<" 3

                }; #end of for loop
            }
            "T" {
                MASCLR::log_message  "Parsing trailer_rec" 1
                foreach {num name length type start end dflt col fmt} $INQ02::trailer_rec {
                   MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 4
                   set Trl_Value($name) [string range $line [expr $start - 1] [expr $end - 1]]
                   set    l_msg "T-1 Trl_Value($name) "
                   append l_msg "len [string length $Trl_Value($name)] = "
                   append l_msg ">>$Trl_Value($name)<<"
                   MASCLR::log_message  $l_msg 3
                }
            }
        }; #endof switch case

        ### Data Edits on detail record
        if { [ string range $line 0 0 ] == "D" } {
            ### Get the institution and visa_id
            set institution_id ""
            set entity_id ""

            set query "select institution_id,entity_id
                        from alt_merchant_id
                        where card_scheme = '03'
                        and cs_merchant_id = '$DetailValue(SELLER_ID)'"

            orasql $ami_tb $query

            while {[orafetch $ami_tb -dataarray ami -indexbyname] != 1403} {
                set institution_id "$ami(INSTITUTION_ID)"
                set entity_id "$ami(ENTITY_ID)"
            }; #endof while for ami_tb

            if {$institution_id == "" || $entity_id == "" } {
                MASCLR::log_message "ERROR: Could not find the institution and visa id for seller id = $DetailValue(SELLER_ID) in alt_merchant_id table"
            }

            ### Build the insert statement
            ### NOTE the insertColumn and insertValue go in pair. The sequence is absolutely cruicial to maintain data integrity

            set insertValue ""
            set insertColumn ""

            append insertColumn "INSTITUTION_ID,"
            append insertValue "\'$institution_id\',"

            append insertColumn "VISA_ID,\n"
            append insertValue "\'$entity_id\',"

            append insertColumn "FILE_NAME,"
            append insertValue "\'$inputFile\',"

            append insertColumn "FILE_TYPE,"
            append insertValue "\'$hdr_value(DATATYPE)\',"

            append insertColumn "SAID,"
            append insertValue "\'$hdr_value(SAID)\',"

            append insertColumn "LOG_DATE,"
            append insertValue "to_date\(\'$logDate\',\'YYYYMMDDHH24MISS\'\),"

            foreach {num name length type start end dflt col fmt} $INQ02::detail_front {
                if { [string range $name 0 5] == "FILLER" || $name == "DTL_REC_TYPE" || $name == "REC_TYPE"} {
                    continue
                }
                append insertColumn "$name,"
                if {$type == "d"} {
                    if {    $name == "AMEX_PROCESS_DATE"    ||
                            $name == "DATE_OF_CHARGE"       ||
                            $name == "LTA_FILED_DATE"       ||
                            $name == "RES_CANCELLED_DATE"   ||
                            $name == "RESERVATION_MADE_FOR" ||
                            $name == "RESERVATION_MADE_ON"  ||
                            $name == "RETURN_DATE"          ||
                            $name == "RETURNED_DATE"        ||
                            $name == "SE_REPLY_BY_DATE"            } {
                        ### incoming date format YYMMDD
                        append insertValue "to_date\(\'$DetailValue($name)\',\'$fmt\'\),"
                    } else {
                        ### incoming date format YYYYMMDD
                        append insertValue "to_date\(\'$DetailValue($name)\',\'$fmt\'\),"
                    }
                } else {
                    append insertValue "\'$DetailValue($name)\',"
                }
            }
            foreach {num name length type start end dflt col fmt} $detail_back {
                if { [string range $name 0 5] == "FILLER" || $name == "DTL_REC_TYPE" || $name == "REC_TYPE"} {
                    continue
                }
                append insertColumn "$name,"
                if {$type == "d"} {
                    if {    $name == "AMEX_PROCESS_DATE"    ||
                            $name == "DATE_OF_CHARGE"       ||
                            $name == "LTA_FILED_DATE"       ||
                            $name == "RES_CANCELLED_DATE"   ||
                            $name == "RESERVATION_MADE_FOR" ||
                            $name == "RESERVATION_MADE_ON"  ||
                            $name == "RETURN_DATE"          ||
                            $name == "RETURNED_DATE"        ||
                            $name == "SE_REPLY_BY_DATE"            } {
                        ### incoming date format YYMMDD
                        append insertValue "to_date\(\'$DetailValue($name)\',\'$fmt\'\),"
                    } else {
                        ### incoming date format YYYYMMDD
                        append insertValue "to_date\(\'$DetailValue($name)\',\'$fmt\'\),"
                    }
                } else {
                    append insertValue "\'$DetailValue($name)\',"
                }
            }; #endof foreach


            set insertColumn [string trimright [string trimright $insertColumn] ,]
            set insertValue [string trimright [string trimright $insertValue] ,]

            set query "insert into AMEX_DISPUTE_TXN
                        \($insertColumn\)
                        values \($insertValue\)"
            #puts "T-1 $query"

            if {[catch {orasql $adt_tb $query} result]} {
                puts "ERROR: Encoutered error while inserting row into AMEX_DISPUTE_TXN table"
                puts "ERROR REASON: $result"
                puts "ERROR RESOLUTION: Fix the query and rerun the query only on SQL Developer"
                puts "ERROR QUERY - $query"
            }
        }
    }
    MASCLR::log_message "hdr_value(SAID): $hdr_value(SAID), Trl_Value(SAID): $Trl_Value(SAID)" 1
    if {$hdr_value(SAID) == $Trl_Value(SAID)} {
        # valid file
        MASCLR::log_message "Header and Trailer match - valid file" 1
    } else {
        # invalid file
        MASCLR::log_message "Header and Trailer do not match - invalid file"
    }

}; # end of INQ02_validate

################################################################################
#
#    Procedure Name - RESPN_validate
#
#    Description - Gets the expected file count, actual file count and compares the values
#
#    Return -
###############################################################################
proc RESPN_validate {} {
    global programName
    global inputFile
    global maxHdrFld
    global maxDetailFld
    global Trl_Value
    global hdr_value

    set cntr 0

    ## Reset the header buffer
    foreach {num name length type start end dflt col fmt} $RESPN::header_rec {
       set hdr_value($name) ""
    }

    ## Reset the detail record buffer
    for {set i 1} {$i <= 3} {incr i} {
        foreach {num name length type start end dflt col fmt} $RESPN::detail_rec($i) {
           MASCLR::log_message  "T-1 $num $name $length $type $start $end $col $fmt $dflt" 2
           set DetailValue($name) ""
        }
    }

    if {[catch {open $inputFile r} filePtr]} {
        puts "File Open Err:Cannot open file $inputFile"
        exit 1
    }

    while { [gets $filePtr line] >= 0 } {
        switch -exact -- [ string range $line 0 0 ] {
            "H" {
                MASCLR::log_message  "Parsing Header Record" 1
                foreach {num name length type start end dflt col fmt} $RESPN::header_rec {
                   MASCLR::log_message  "T-1 $num $name $length $type $start $end $col $fmt $dflt" 4
                   set hdr_value($name) [string range $line [expr $start - 1] [expr $end - 1]]
                   set    l_msg "T-1 hdr_value($name) "
                   append l_msg "len [string length $hdr_value($name)] = "
                   append l_msg ">>$hdr_value($name)<<"
                   MASCLR::log_message  $l_msg 3
                }; #end of for loop
            }
            "D" {
                switch -exact -- $name {
                    MASCLR::log_message  "\nParsing Detail Record" 2
                    foreach {num name length type start end dflt col fmt} $RESPN::detail_front {
                        MASCLR::log_message  "T-1 $num $name $length $type $start $end $col $fmt $dflt" 4
                        set DetailValue($name) [string range $line [expr $start - 1] [expr $end - 1]]
                        MASCLR::log_message  "T-1 DetailValue($name) len [string length $DetailValue($name)] = >>$DetailValue($name)<<" 3
                        if { $DetailValue(CASE_TYPE) == "FRAUD" &&
                                [string range $name 0 11] == "INQUIRY_NOTE" } {
                            switch -exact -- $name {
                                INQUIRY_NOTE_1 -
                                INQUIRY_NOTE_2 {
                                    # no operation
                                }
                                INQUIRY_NOTE_3 -
                                INQUIRY_NOTE_4 -
                                INQUIRY_NOTE_5 -
                                INQUIRY_NOTE_6 -
                                INQUIRY_NOTE_7 {
                                    set note_nbr [string range $name end-1 end]
                                    foreach {f_num f_name f_length f_type f_start f_end f_dflt f_col f_fmt} $RESPN::detail_fraud($name) {
                                        MASCLR::log_message  "T-1 $f_num $f_name $f_length $f_type $f_start $f_end $f_dflt $f_col $f_fmt" 4
                                        set DetailValue($f_name$note_nbr) [string range $line [expr $f_start - 1] [expr $f_end - 1]]
                                        set    l_msg "T-1 DetailValue($f_name$note_nbr) "
                                        append l_msg "len "
                                        append l_msg "[string length $DetailValue($f_name$note_nbr)] "
                                        append l_msg "= >>$DetailValue($f_name$note_nbr)<<"
                                        append l_msg ""
                                        MASCLR::log_message $l_msg 3
                                    }
                                }
                            }
                        }

                    }; #end of for loop

                    # CASE_TYPE CRCDW  will be ignored for now.
                    switch -exact -- $DetailValue(CASE_TYPE) {
                        AIRDS -
                        AIRLT -
                        AIRRT -
                        AIRTB -
                        AREXS -
                        CARRD -
                        GSDIS -
                        NAXMG -
                        NAXMR -
                        SEDIS -
                        FRAUD {
                            set detail_back $RESPN::detail_rec($DetailValue(CASE_TYPE))
                        }
                        default {
                            puts "\nUnknown CASE_TYPE: $DetailValue(CASE_TYPE)\n"
                            exit 1
                        }
                    }
                    foreach {num name length type start end dflt col fmt} $detail_back {
                        MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 4
                        set DetailValue($name) [string range $line [expr $start - 1] [expr $end - 1]]
                        MASCLR::log_message  "T-1 DetailValue($name) len [string length $DetailValue($name)] = >>$DetailValue($name)<<" 3

                    }; #end of for loop
                }
            }
            "T" {
                MASCLR::log_message  "Parsing trailer_rec" 1
                foreach {num name length type start end dflt col fmt} $RESPN::trailer_rec {
                   MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 4
                   set Trl_Value($name) [string range $line [expr $start - 1] [expr $end - 1]]
                   set    l_msg "T-1 Trl_Value($name) "
                   append l_msg "len [string length $Trl_Value($name)] = "
                   append l_msg ">>$Trl_Value($name)<<"
                   MASCLR::log_message  $l_msg 3
                }
            }
        }; #endof switch case
    }
    if {$hdr_value(SAID) == $Trl_Value(SAID)} {
        # valid file
        MASCLR::log_message "Header and Trailer match on SAID - possible valid file" 1
    } else {
        # invalid file
        MASCLR::log_message "Header and Trailer do not match on SAID - invalid file"
    }

}; # end of RESPN_validate


##########
## MAIN ##
##########

init $argv
RESPN_build
