#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: INQ02_parser.tcl 2854 2015-04-20 20:40:39Z jkruse $

################################################################################
#
#    File Name - INQ02_parser.tcl
#
#    Description - This scripts checks to see if the neccesary files were
#                  imported into the MAS or not.
#
#    Arguments-  -f = file to parse
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    EXAMPLE = INQ02_parser.tcl -f <filename> -d <YYYYMMDD>
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
   puts "EXAMPLE = INQ02_parser.tcl -f file -d 20130910"
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
   set inputFile ""

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
   global gsc_tb
   global eel_tb
   global ifl_tb
   global idm_tb


    ## MASCLR and TIEHOST connection ##
    if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
       puts "Encountered error $result while trying to connect to the $prod_db database "
       exit 3
    }

    if {[catch {
           set ami_tb                [oraopen $clr_db_logon_handle]
           set adt_tb                [oraopen $clr_db_logon_handle]
           set verify_tb             [oraopen $clr_db_logon_handle]
		   set gsc_tb               [oraopen $clr_db_logon_handle]
		   set eel_tb               [oraopen $clr_db_logon_handle]
		   set ifl_tb               [oraopen $clr_db_logon_handle]
		   set idm_tb               [oraopen $clr_db_logon_handle]
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

source INQ02_layout.tm
source RESPN_layout.tm

################################################################################
#
#    Procedure Name - getRecordCount
#
#    Description - This proc scan the CBNSP file and gets a count of CBs
#                  The count is later used to block trans_seq_nbr for IDM
#
#    Return - Exit 0, if CBNSP is an empty file
###############################################################################
proc getRecordCount {} {
global programName
global inputFile
global rcdCnt

set rcdCnt 0

   if {[catch {open $inputFile r} filePtr]} {
        puts "File Open Err:Cannot open file $inputFile"
        exit 1
   }

   while { [gets $filePtr line] >= 0 } {
        switch -exact -- [ string range $line 0 0 ] {
            "D" {
               incr rcdCnt
            }
        }; #endof switch case
    }
    puts "T-1 rcdCnt=$rcdCnt"

    close $filePtr

    if {$rcdCnt == 0} {
       puts "No Amex Inquiries today in $inputFile"
       exit 0
    } else {
       puts "$rcdCnt Amex Inquiries today in $inputFile"
    }
}

################################################################################
#
#    Procedure Name - getNextLastSeqNbr
#
#    Description - It gets the last seq nbr used by in_draft_main and
#                  ep_event_log from GLOBAL_SEQ_CTRL table
#                  It then increments the seq to the number of CB in the file
#                  to block the range. This range will be used to insert rows in IDM.
#                  This will eliminate any primary key constraints violations during inserts
#
#    Return -
###############################################################################
proc getNextLastSeqNbr {} {
global programName
global rcdCnt
global gsc_tb
global nextLastTransNbr
global nextLastInBatchNbr
global nextLastInFileNbr
global nextlastEEId
global lastTransSeqNbr
global lastInBatchNbr
global lastEEId

   set query "SELECT seq_name, last_seq_nbr
              FROM global_seq_ctrl
              WHERE seq_name in ('trans_seq_nbr', 'in_batch_nbr', 'in_file_nbr', 'ep_event_id') "

   orasql $gsc_tb $query

   while {[orafetch $gsc_tb -dataarray seq -indexbyname] != 1403} {
       switch -exact -- $seq(SEQ_NAME) {
          "trans_seq_nbr" {
              set lastTransSeqNbr $seq(LAST_SEQ_NBR)
          }
          "in_batch_nbr" {
              set lastInBatchNbr $seq(LAST_SEQ_NBR)
          }
          "in_file_nbr" {
              set lastInFileNbr $seq(LAST_SEQ_NBR)
          }
          "ep_event_id" {
              set lastEEId $seq(LAST_SEQ_NBR)
          }
       }
   }
   set nextLastTransNbr [expr { $lastTransSeqNbr + $rcdCnt + 1 } ]
   set nextLastInBatchNbr [expr {$lastInBatchNbr + $rcdCnt + 1} ]
   set nextLastInFileNbr [expr {$lastInFileNbr +1} ]
   set nextlastEEId [expr { $lastEEId + $rcdCnt + 1 } ]

   set query "update global_seq_ctrl
              set last_seq_nbr =
              case when seq_name = 'trans_seq_nbr'
                   then '$nextLastTransNbr'
                   when seq_name = 'in_batch_nbr'
                   then '$nextLastInBatchNbr'
                   when seq_name = 'in_file_nbr'
                   then '$nextLastInFileNbr'
                   when seq_name = 'ep_event_id'
                   then '$nextlastEEId'
              end
              where seq_name in ('trans_seq_nbr', 'in_batch_nbr', 'in_file_nbr', 'ep_event_id') "


   if {[catch {orasql $gsc_tb $query} result]} {
      oraroll $gsc_tb
      puts "ERROR: Encoutered error while update LAST_SEQ_NBR in GLOBAL_SEQ_CTRL table"
      puts "ERROR REASON: $result"
      puts "The CBNSP file $inputFile will not be processd until this is resolved."
      puts "Once Resolved rerun the code"
      puts "ERROR QUERY - $query"
      exit 4
   }

}

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
	global idm_tb
	global eel_tb
	global nextLastTransNbr
	global nextLastInBatchNbr
	global nextLastInFileNbr
	global nextlastEEId
	global ifl_tb
	global lastTransSeqNbr
	global lastInBatchNbr
	global lastEEId

    set logDate [clock format [clock second] -format "%Y%m%d%H%M%S"]

    set cntr 0
    set institution_id ""
    set entity_id ""
    set insertValue ""
    set insertColumn ""
	set cardScheme "03"
	set tid "010103020101"
	set msgtype "2440"
	set transSeqNbr $lastTransSeqNbr
	set inBatchNbr $lastInBatchNbr
	set epEventId $lastEEId
	set currency_code "840"

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
	
	### Add the file to in_file_log

    set query "insert
               into in_file_log
				(in_file_nbr, 
				institution_id, 
				file_type, 
				incoming_dt, 
				end_dt, 
				in_file_status, 
				external_file_name
				)
           values ('$nextLastInFileNbr', 
					'$cardScheme', 
					'31', 
					sysdate, 
					sysdate, 
					'C', 
					'$inputFile'
					)"

    if {[catch {orasql $ifl_tb $query} result]} {
        puts "ERROR: Encoutered error while inserting row into IN_FILE_LOG table"
        puts "ERROR REASON: $result"
        puts "ERROR RESOLUTION: Fix the problem and rerun the code"
        puts "ERROR QUERY:  $query"
        exit 3
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
				}
				 #end of for loop
			}
            " " -
            "D" {
                MASCLR::log_message  "\nParsing Detail Record" 2

                foreach {num name length type start end dflt col fmt} $INQ02::detail_front {
                    MASCLR::log_message  "T-1 $num $name $length $type $start $end $dflt $col $fmt" 4
                    set DetailValue($name) [string range $line [expr $start - 1] [expr $end - 1]]
                    MASCLR::log_message  "T-1 DetailValue($name) len [string length $DetailValue($name)] = >>$DetailValue($name)<<" 3
                    if { $DetailValue(CASE_TYPE) == "FRAUD" &&
                            [string range $name 0 4] == "NOTE_" } {
                        if { [string trim $DetailValue($name)] != "" } {
                            switch -exact -- $name {
                                NOTE_1 -
                                NOTE_2 {
                                    # no operation
                                }
                                NOTE_3 -
                                NOTE_4 -
                                NOTE_5 -
                                NOTE_6 -
                                NOTE_7 {
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

					} ; #end of for loop
				
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

                } ; #end of for loop
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
        } ; #endof switch case

        ### Data Edits on detail record
        if { [ string range $line 0 0 ] == "D" || [ string range $line 0 0 ] == " " } {
            ### Get the institution and visa_id
            set institution_id ""
            set entity_id ""

            set query "select institution_id,entity_id
                        from alt_merchant_id
                        where card_scheme = '03'
                        and cs_merchant_id = trim('$DetailValue(SELLER_ID)')"

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
			
			set DetailValue(SELLER_ID) [string trimright "$DetailValue(SELLER_ID)" "     "]

            foreach {num name length type start end dflt col fmt} $INQ02::detail_front {
                if { [string range $name 0 5] == "FILLER" || $name == "DTL_REC_TYPE" || $name == "REC_TYPE"} {
                    continue
                }
                append insertColumn "$name,"
                if {$type == "d"} {
                    ### incoming date format YYMMDD or YYYYMMDD
                    if { [string trim $DetailValue($name)] == ""} {
                        append insertValue "null,"
                    } else {
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
                    ### incoming date format YYMMDD or YYYYMMDD
                    if { [string trim $DetailValue($name)] == ""} {
                        append insertValue "null,"
                    } else {
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
        
		
	
	
           ### Add Record to in_draft_main and ep_event_log and in_file_log tables
           set transSeqNbr [expr {$transSeqNbr + 1} ]
           if { $transSeqNbr > $nextLastTransNbr} {
              puts "ERROR: Unable to use trans_seq_nbr = $transSeqNbr when inserting row in in_draft_main"
              puts "ERROR RESOLUTION: Run the below insert query using an unique transSeqNbr"
              set errFlag 1
           }

           set inBatchNbr [expr {$inBatchNbr +1}]
           if { $inBatchNbr > $nextLastInBatchNbr} {
              puts "ERROR: Unable to use in_batch_nbr = $inBatchNbr when inserting row in in_draft_main"
              puts "ERROR RESOLUTION: Run the below insert query using an unique in_batch_nbr on SQL Developer"
              set errFlag 1
           }

          set epEventId [expr {$epEventId +1}]
            puts "T-1 epEventId=$epEventId"
           if { $epEventId > $nextlastEEId} {
              puts "ERROR: Unable to use ep_event_id = $epEventId when inserting row in ep_event_log"
              puts "ERROR RESOLUTION: Run the below insert query using an unique ep_event_log on SQL Developer"
              set errFlag 1
           }


           

           set query "insert into in_draft_main
                      (TRANS_SEQ_NBR, 
						MSG_TYPE, 
						TID, 
						CARD_SCHEME,
						IN_FILE_NBR, 
						IN_BATCH_NBR, 
						PRI_DEST_INST_ID,
						PAN, 
						AMT_TRANS,
						TRANS_CCD,
						TRANS_EXP, 
                        AMT_RECON, 
                        RECON_CCD, 
                        RECON_EXP, 
						TRANS_DT,
						ARN,
						ACQ_INST_ID,
						MERCH_ID, 
						SETTL_METHOD_IND,
						MSG_TEXT_BLOCK,
						TRANS_CLR_STATUS,
                        TC_QUALIFIER,
						ORIG_REASON_CD,
						ACTIVITY_DT
						)
                       values
                       ('$transSeqNbr', 
						'$msgtype', 
						'$tid', 
						'$cardScheme',
                        '$nextLastInFileNbr', 
						'$inBatchNbr', 
						'$institution_id',
                        '$DetailValue(CM_ORIG_ACCT_NUM)', 
						'$DetailValue(CHARGE_AMOUNT)',
						'$currency_code',
						'2',
						'$DetailValue(DISPUTE_AMOUNT)',
						'$currency_code',
						'2',
						to_date\(\'$DetailValue(DATE_OF_CHARGE)\', \'YYMMDD\'\),
                        RTRIM('$DetailValue(IND_REF_NUMBER)'),
						'0',
                        '$entity_id',
						'0',
						'$DetailValue(NOTE5)',
						'X',
						'0',
						'$DetailValue(REASON_CODE)',
						to_date\(\'$logDate\', \'YYYYMMDDHH24MISS\'\)
						)"

				if {[catch {orasql $idm_tb $query} result]} {
					puts "ERROR: Encoutered error while inserting row into IN_DRAFT_MAIN table"
					puts "ERROR REASON: $result"
					puts "ERROR RESOLUTION: Fix the query and rerun the query only on SQL Developer"
					puts "ERROR QUERY:  $query"
				}
				
				set query "insert into ep_event_log
						(EP_EVENT_ID, 
						INSTITUTION_ID,
						TRANS_SEQ_NBR, 
						EMS_ITEM_TYPE, 
						CARD_SCHEME,
						PAN,
						PAN_SEQ,
						ARN,
						SEND_ID,
						RECEIVE_ID, 
						TRANS_DT,
						MERCH_ID,
						AMT_CH_BILL,
						CH_BILL_EXP,
						AMT_TRANS,
						TRANS_CCD,
						TRANS_EXP,
						EMS_OPER_AMT_CR,
						EMS_OPER_AMT_DB,
						EMS_OPER_EXP,
						PROCESS,
						EVENT_STATUS,
						EVENT_REASON,
						EVENT_LOG_DATE,
						EMS_SPEC_DATA1,
						IN_FILE_NBR,
						ISS_ACQ_IND
                       )
                       values
                       ('$epEventId',
						'$institution_id',
						'$transSeqNbr', 
						'RR1', 
						'$cardScheme',
						'$DetailValue(CM_ORIG_ACCT_NUM)',
						'0',
						RTRIM('$DetailValue(IND_REF_NUMBER)'),
                        '03',
						'$institution_id',
						to_date\(\'$DetailValue(DATE_OF_CHARGE)\', \'YYMMDD\'\),
						'$entity_id',
						'0',
						'0',
						'$DetailValue(CHARGE_AMOUNT)',
						'$currency_code',
						'2',
						'0',
						'0',
						'0',
                        'CLEAR',
						'NOTIFY',
						'EINC',
                        to_date\(\'$logDate\', \'YYYYMMDDHH24MISS\'\),
						'$DetailValue(REASON_CODE)',
						'$nextLastInFileNbr',
                        'ACQ'
                        )"

           if {[catch {orasql $eel_tb $query} result]} {
              puts "ERROR: Encoutered error while inserting row into EP_EVENT_LOG table"
              puts "ERROR REASON: $result"
              puts "ERROR RESOLUTION: Fix the query and rerun the query only on SQL Developer"
              puts "ERROR QUERY:  $query"
           }
		   
		} ; #end of if detail record	
	} ; #end of while fileptr		
		if { [info exists Trl_Value(SAID)] } {
			MASCLR::log_message "hdr_value(SAID): $hdr_value(SAID), Trl_Value(SAID): $Trl_Value(SAID)" 1
			if {$hdr_value(SAID) == $Trl_Value(SAID)} {
				# valid file
			MASCLR::log_message "Header and Trailer match - valid file" 1
			} else {
			# invalid file
			MASCLR::log_message "Header and Trailer do not match - invalid file"
			}
		} else {
		# No Trailer Record
		MASCLR::log_message "Trailer Record does not exist"
		}

}; #end of INQ02_validate 

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
            " " -
            "D" {
                switch -exact -- $name {
                    MASCLR::log_message  "\nParsing Detail Record" 2
                    foreach {num name length type start end dflt col fmt} $RESPN::detail_front {
                        MASCLR::log_message  "T-1 $num $name $length $type $start $end $col $fmt $dflt" 4
                        set DetailValue($name) [string range $line [expr $start - 1] [expr $end - 1]]
                        MASCLR::log_message  "T-1 DetailValue($name) len [string length $DetailValue($name)] = >>$DetailValue($name)<<" 3
                        if { $DetailValue(CASE_TYPE) == "FRAUD" &&
                                [string range $name 0 4] == "NOTE" } {
                            switch -exact -- $name {
                                NOTE_1 -
                                NOTE_2 {
                                    # no operation
                                }
                                NOTE_3 -
                                NOTE_4 -
                                NOTE_5 -
                                NOTE_6 -
                                NOTE_7 {
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
getRecordCount
getNextLastSeqNbr
INQ02_validate
