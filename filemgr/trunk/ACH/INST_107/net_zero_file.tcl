#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: net_zero_file.tcl 4718 2018-09-27 18:13:03Z skumar $
# $Rev: 4718 $
################################################################################

#
# TCL script to net zero out an EFunds ACH file since Bancorp
# will no longer accept unbalanced files.  This code is based
# on the block_file.tcl script.
#
# TCL script to reformat an EFunds ACH settlement file by
# properly 10 blocking the file and adding CR to each line
# that Bancorp requires.
#
# Version 0.00 10/11/05 Joe Cloud
#
# Version 0.01 09/05/06 Jackie Young
# Updated to process with Merrick Bank

lappend auto_path $env(MASCLR_LIB)
source $env(MASCLR_LIB)/masclr_tcl_lib

set debug true
set debug_level 4
set MASCLR::DEBUG_LEVEL 4

#package require Mpexpr

# bump precision as high as we can go
set tcl_precision 17

set programName "[lindex [split [file tail $argv0] .] 0]"

#*** Global variables ***
set VERSION 0.01
set LINE_COUNT 0
set CR_LINE_COUNT 0
set DB_LINE_COUNT 0
set ONE_LINE_COUNT 0
set CR_ENTRY_COUNT 0
set DB_ENTRY_COUNT 0
set ONE_ENTRY_COUNT 0
set CR_SEQ_NBR 0
set DB_SEQ_NBR 0
set ONE_SEQ_NBR 0
set CR_AMT_TOTAL 0
set DB_AMT_TOTAL 0
set ONE_AMT_TOTAL 0
set CR_HASH_TOTAL 0
set DB_HASH_TOTAL 0
set ONE_HASH_TOTAL 0
#set ORIG_NAME "JETPAY"
#set ORIG_ROUTING_NUMBER "11300554"
#set ORIG_ID " 202948242"
#set DESTINATION_BANK "113005549"
#set T2_ACCOUNT "2031000109"
#set ORIG_ROUTING_NUMBER "111000753" ; #new/correct FirstPremier ABA
#set T2_ACCOUNT "1882143785" ; ##new/correct FirstPremier DDA
set SETTLE_DATE ""
set JULIAN_SETTLE_DATE ""
set DESC_DATE ""
set INSTITUTION_ID ""
#************************

set dr_hash 0
set file_item_count 0
#RHK add

#set outfile "[lindex $argv 1]"

#set environment variables FIXME
#set clrdb $env(IST_DB)    FIXME

package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$env(IST_DB)]} result]} {
   if { [catch { exec echo "DB connection error. netzero script failed to run" | mutt -s "ACH Netzero Script Error" -- Clearing.JetPayTX@ncr.com } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
   exit
}

set cursor [oraopen $handler]


# Strip leading zeros off of numbers, so that they are not
# interpredted to be OCTAL
proc unoct {s} {
    set u [string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct



# formatted record according to the record_id.  This uses handler arry
# for figure out the formatting
proc format_record {aname} {
global fileid inst_id cycl alt_data

    global handler_array

    upvar $aname a

    set mtype $a(record_id)

    set out ""

    foreach i $handler_array($mtype) {
# puts $i

    set fname   [lindex $i 0]
    set flength [lindex $i 1]
    set ftype   [lindex $i 2]
    switch $ftype {
        l {set temp [lindex $i 3] }
        t {set temp $a($fname)}
        a {set temp [format "%-${flength}s" $a($fname)] }
        m -
        n {set temp [format "%0${flength}.0f" [unoct $a($fname)] ]}
        f {set temp [format "%-${flength}s" " "] }
        default {
        #this should NEVER happen
        puts oops
                puts "Encountered error while processing <$mtype>"
                puts "fname is <$fname>"
                puts "flength is <$flength>"
                puts "ftype is <$ftype>"
                bailout
        }

    }
#   puts $temp
#   set out "$out$temp\n"
    set out "$out$temp"
#   puts "end of i"
    }
    return "$out\r"
};# end format_record

#RHK add
# File Header Record
set handler_array(FHR) {
    {rec_type 1 l "1"}
    {prty_cd 2 n}
    {imm_dest 10 a}
    {imm_origin 10 a}
    {file_dt 6 a}
    {file_time 4 a}
    {f_id_mod 1 a}
    {rec_size 3 a "094"}
    {blk_fctr 2 a "10"}
    {frmt_cd 1 a "1"}
    {imm_dest_nm 23 a}
    {imm_orig_nm 23 a}
    {ref_cd 8 a "00000000"}
};# end file_header_rec

# Batch Header Record
set handler_array(BHR) {
    {rec_type 1 l "5"}
    {srv_class 3 n}
    {company_name 16 a}
    {disc_data 20 a}
    {tax_id 10 a}
    {entry_class 3 a}
    {entry_desc 10 a}
    {desc_date 6 a}
    {settle_date 6 a}
    {julian_sett_date 3 a}
    {orig_status 1 l "1"}
    {orig_dfi_id 8 a}
    {batch_num 7 n}
};# end set handler_array(BH)



# Entry Detail Record
set handler_array(DR) {
    {rec_type 1 l "6"}
    {tran_code 2 n}
    {route_id_cd 9 a}
    {accnt_num 17 a}
    {tran_amt 10 n}
    {id_num 15 a}
    {name 22 a}
    {disc_data 2 a}
    {addenda_ind 1 a}
    {trace_num 15 n}
};# end set handler_array(DR)



# Batch Control Record (Batch Trailer Record)
set handler_array(BTR) {
    {rec_type 1 l "8"}
    {srv_class 3 n}
    {addenda_cnt 6 n}
    {entry_hash 10 n}
    {debit_total 12 n}
    {credit_total 12 n}
    {company_id 10 a}
    {filler1 25 f}
    {orig_routing_num 8 a}
    {batch_num 7 n}
};# end set handler_array(BT)



# File Control Record (File Trailer Record)
set handler_array(FTR) {
    {rec_type 1 l "9"}
    {batch_cnt 6 n}
    {block_cnt 6 n}
    {item_cnt 8 n}
    {hash_num 10 n}
    {debit_total 12 n}
    {credit_total 12 n}
    {filler 39 f}
};# end set handler_array(FT)

proc alt_ach_data {} {
global fileid inst_id cycl alt_data
global INSTITUTION_ID cursor inst_id

set data_sql "select INSTITUTION_ID,ACH_CYCLE,ACH_RECORD_TYPE,IDENTIFIER,FIELD_NAME,FIELD_VALUE from MASCLR.FLMGR_ACH_FIELD_VALUE_CTRL"
   orasql $cursor $data_sql
   while {[set x [orafetch $cursor -dataarray extnl_data -indexbyname]] == 0 } {
    set alt_data($extnl_data(INSTITUTION_ID)-$extnl_data(ACH_CYCLE)-$extnl_data(ACH_RECORD_TYPE)-$extnl_data(IDENTIFIER)-$extnl_data(FIELD_NAME)) [string toupper $extnl_data(FIELD_VALUE)]
    #puts "alt_data($extnl_data(INSTITUTION_ID)-$extnl_data(ACH_CYCLE)-$extnl_data(ACH_RECORD_TYPE)-$extnl_data(IDENTIFIER)-$extnl_data(FIELD_NAME)) [string toupper $extnl_data(FIELD_VALUE)]"

   }

}

proc generate_hash_value {hash_total} {
global fileid inst_id cycl alt_data
    if {[string length $hash_total] <= 10} {
        return $hash_total
    } else {
        set temp_length [string length $hash_total]
        set temp_end [expr $temp_length - 1]
        set temp_start [expr $temp_length - 10]
        return [string range $hash_total $temp_start $temp_end]
    }
};# end generate_hash_value

proc modify_detail { line_in file type} {
global fileid inst_id cycl alt_data
global INSTITUTION_ID cursor fileid
global CR_LINE_COUNT
global DB_LINE_COUNT
global ONE_LINE_COUNT
global CR_ENTRY_COUNT
global DB_ENTRY_COUNT
global ONE_ENTRY_COUNT
global CR_SEQ_NBR
global DB_SEQ_NBR
global ONE_SEQ_NBR
global CR_AMT_TOTAL
global DB_AMT_TOTAL
global ONE_AMT_TOTAL
global CR_HASH_TOTAL
global DB_HASH_TOTAL
global ONE_HASH_TOTAL

if {$cycl != "002"} {

   set trans_code [string range $line_in 1 2]
   set routing_nbr [string range $line_in 3 11]

   set account_nbr [string range $line_in 12 28]

   set trans_amt [unoct [string range $line_in 29 38]]

   set payment_seq_nbr [unoct [string range $line_in 39 53]]
   set cust_name [string range $line_in 54 75]

   #JSG#set trace_num1 [string range $line_in 79 86]
   #JSG#set trace_num2 [format %07d $payment_seq_nbr]
   #JSG#set trace_num1 [string range $line_in 79 93]
   set bank_rout_nbr [string range $line_in 79 86]
   set trace_num2 ""
   set sql_string "select owner_entity_id from payment_log p, entity_acct e
                   where p.payment_seq_nbr='$payment_seq_nbr'
                   and p.institution_id in ('$inst_id')
                   and e.institution_id in ('$inst_id')
                   and e.entity_acct_id=p.entity_acct_id"
   orasql $cursor $sql_string
   orafetch $cursor -dataarray s -indexbyname
   set entity_id $s(OWNER_ENTITY_ID)

   if { $routing_nbr == ""} {
          if { [catch { exec echo "Routing Number is missing for the merchant: $entity_id" | mutt  \
                 -s "$env(SYS_BOX):::: Priority : Critical - Clearing and Settlement - ACH Netzero Script Error" -- clearing@jetpay.com } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
          exit 1
   }
   if { $account_nbr == ""} {
          if { [catch { exec echo "Account Number is missing for the merchant: $entity_id" | mutt \
                     -s "$env(SYS_BOX):::: Priority : Critical - Clearing and Settlement - ACH Netzero Script Error" -- clearing@jetpay.com } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
          exit 1
   }

   if { $trans_amt == ""} {
          if { [catch { exec echo "Transaction Amount is missing for the merchant: $entity_id ,payment sequence number: $payment_seq_nbr"
                      | mutt -s "$env(SYS_BOX):::: Priority : Critical - Clearing and Settlement - ACH Netzero Script Error" -- clearing@jetpay.com } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
          exit 1
   }

   if {$type == "CR"} {
      incr CR_SEQ_NBR
      set trace_num2 [format %07d $CR_SEQ_NBR]
   } elseif {$type == "DB"} {
      incr DB_SEQ_NBR
      set trace_num2 [format %07d $DB_SEQ_NBR]
   } elseif {$type == "ONE"} {
      incr ONE_SEQ_NBR
      set trace_num2 [format %07d $ONE_SEQ_NBR]
   }  else {
      set trace_num2 [string range $line_in 87 93]
   }

   set a(record_id) "DR"
   set a(tran_code) "$trans_code"
   set a(route_id_cd) $routing_nbr
   set a(accnt_num) $account_nbr
   set a(tran_amt) $trans_amt
   set a(id_num) "$entity_id"
   set a(name) "$cust_name"
   set a(disc_data) [string range $line_in 76 77]
   set a(addenda_ind) "0"
   set a(trace_num) "$bank_rout_nbr$trace_num2"

   # TODO if account_nbr or routing_nbr is null or all space - raise error and abort
   #        the ach is unusable

   ### Start calculating hash value
   if {$type == "CR"} {
      set CR_HASH_TOTAL [expr [unoct $CR_HASH_TOTAL] + [unoct [string range $line_in 3 10]]]
      set CR_AMT_TOTAL [expr $CR_AMT_TOTAL + $trans_amt]
      incr CR_LINE_COUNT
      incr CR_ENTRY_COUNT
   } elseif {$type == "DB"} {
      set DB_HASH_TOTAL [expr [unoct $DB_HASH_TOTAL] + [unoct [string range $line_in 3 10]]]
      set DB_AMT_TOTAL [expr $DB_AMT_TOTAL + $trans_amt]
      incr DB_LINE_COUNT
      incr DB_ENTRY_COUNT
   } elseif {$type == "ONE"} {
      # Use the default values from the ACH generated by efunds
      incr LINE_COUNT
   }

} else {

   set trans_code [string range $line_in 1 2]
   set routing_nbr [string range $line_in 3 11]
   set account_nbr [string range $line_in 12 28]
   set trans_amt [unoct [string range $line_in 29 38]]
   set payment_seq_nbr "0"
   set cust_name [string range $line_in 54 75]
   set trace_num1 [string range $line_in 79 93]
   set trace_num2 ""
   set a(record_id) "DR"
   set a(tran_code) "$trans_code"
   set a(route_id_cd) $routing_nbr
   set a(accnt_num) $account_nbr
   set a(tran_amt) $trans_amt
   set a(id_num) [unoct [string range $line_in 39 53]]
   set a(name) "$cust_name"
   set a(disc_data) [string range $line_in 76 77]
   set a(addenda_ind) "0"
   set a(trace_num) "$trace_num1$trace_num2"
}

   if {[catch {puts  $file "[format_record a]"} result ] } {
          puts"Error encountered writing modified Detail Record $result"
   }

}

proc modify_file_header {line_in file type} {
global INSTITUTION_ID cursor inst_id cycl LINE_COUNT
global ORIG_NAME ORIG_ROUTING_NUMBER ORIG_ID TRACE_NO DESTINATION_BANK T2_ACCOUNT alt_data
global SETTLE_DATE JULIAN_SETTLE_DATE DESC_DATE
global CR_LINE_COUNT
global DB_LINE_COUNT
global ONE_LINE_COUNT

set a(record_id) "FHR"
set a(rec_type) [string range $line_in 0 0]
set a(prty_cd) [string range $line_in 1 2]
set a(imm_dest) [string range $line_in 3 12]
set a(imm_origin) [string range $line_in 13 22]
set a(imm_dest_nm) [string range $line_in 40 62]
set a(imm_orig_nm) [string range $line_in 63 85]
set a(file_dt) [string range $line_in 23 28]
set a(file_time) [string range $line_in 29 32]
set a(f_id_mod) [string range $line_in 33 33]
set a(rec_size) [string range $line_in 34 36]
set a(blk_fctr) [string range $line_in 37 38]
set a(frmt_cd) [string range $line_in 39 39]
set a(ref_cd) [string range $line_in 86 93]

if {[catch {puts $file "[format_record a]"} result ] } {
   puts "Error encountered writing File Header Record - $result"
}

if {$type == "CR"} {
   incr CR_LINE_COUNT
} elseif {$type == "DB"} {
   incr DB_LINE_COUNT
} else {
   incr LINE_COUNT
}

}; #end of modify_file_header

proc modify_batch_header {line_in file type} {
global INSTITUTION_ID cursor inst_id cycl LINE_COUNT
global ORIG_NAME ORIG_ROUTING_NUMBER ORIG_ID TRACE_NO DESTINATION_BANK T2_ACCOUNT alt_data
global SETTLE_DATE JULIAN_SETTLE_DATE DESC_DATE fileid
global CR_LINE_COUNT
global DB_LINE_COUNT
global ONE_LINE_COUNT

set a(record_id) "BHR"

set a(rec_type) [string range $line_in 0 0]
set a(company_name) [string range $line_in 4 19]
set a(disc_data) [string range $line_in 20 39]
set a(tax_id) [string range $line_in 40 49]
set a(entry_desc) [string range $line_in 53 62]
set a(orig_dfi_id) [string range $line_in 79 86]
set a(entry_class) [string range $line_in 50 52]
set a(desc_date) [string range $line_in 63 68]
set a(settle_date) [string range $line_in 69 74]
set a(julian_sett_date) [string range $line_in 75 77]
set a(orig_status) [string range $line_in 78 78]
set a(batch_num) [string range $line_in 87 93]

if {$type == "CR"} {
   incr CR_LINE_COUNT
   set a(srv_class) "220"
} elseif {$type == "DB"} {
   incr DB_LINE_COUNT
   set a(srv_class) "225"
} else {
   incr LINE_COUNT
   set a(srv_class) [string range $line_in 1 3]
}


if {[catch {puts  $file "[format_record a]"} result ] } {
   puts "Error encountered writing File Header Record $result"
}

} ; #end of modify_batch_header

proc modify_batch_trailer {line_in file type} {
global fileid inst_id cycl alt_data dr_hash file_item_count dr_hash
global LINE_COUNT ORIG_NAME ORIG_ROUTING_NUMBER ORIG_ID TRACE_NO DESTINATION_BANK T2_ACCOUNT
global SETTLE_DATE JULIAN_SETTLE_DATE DESC_DATE
global CR_LINE_COUNT
global DB_LINE_COUNT
global ONE_LINE_COUNT
global CR_ENTRY_COUNT
global DB_ENTRY_COUNT
global ONE_ENTRY_COUNT
global CR_SEQ_NBR
global DB_SEQ_NBR
global ONE_SEQ_NBR
global CR_AMT_TOTAL
global DB_AMT_TOTAL
global ONE_AMT_TOTAL
global CR_HASH_TOTAL
global DB_HASH_TOTAL
global ONE_HASH_TOTAL

set a(record_id) "BTR"

   set a(rec_type) [string range $line_in 0 0]
   #set a(srv_class) [string range $line_in 1 3]

   if {$cycl == "002"} {
   set a(srv_class) [string range $line_in 1 3]
   set a(addenda_cnt) $file_item_count
   set btch_hash [expr [unoct [string range $line_in 10 19]] + [unoct $dr_hash]]
   set a(entry_hash) [generate_hash_value $btch_hash]
   set a(debit_total) [expr [unoct [string range $line_in 20 31]] +  [unoct [string range $line_in 32 43]]]
   set a(credit_total) [expr [unoct [string range $line_in 20 31]] +  [unoct [string range $line_in 32 43]]]
   } else {
       if {$type == "CR"} {
           set a(srv_class) "220"
           set a(addenda_cnt) $CR_ENTRY_COUNT
           set a(entry_hash) [generate_hash_value $CR_HASH_TOTAL]
           set a(debit_total) 0
           set a(credit_total) $CR_AMT_TOTAL
           incr CR_LINE_COUNT
       } elseif {$type == "DB"} {
           set a(srv_class) "225"
           set a(addenda_cnt) $DB_ENTRY_COUNT
           set a(entry_hash) [generate_hash_value $DB_HASH_TOTAL]
           set a(debit_total) $DB_AMT_TOTAL
           set a(credit_total) 0
           incr DB_LINE_COUNT
       } else {
           set a(srv_class) [string range $line_in 1 3]
           set a(addenda_cnt) [string range $line_in 4 9]
           set a(entry_hash) [string range $line_in 10 19]
           set a(debit_total) [string range $line_in 20 31]
           set a(credit_total) [string range $line_in 32 43]
           incr LINE_COUNT
       }
   }
   set a(company_id) $ORIG_ID
   set a(orig_routing_num) [string range $line_in 79 86]
   set a(filler1) [string range $line_in 54 78]
   set a(orig_routing_num) [string range $line_in 79 86]
   set a(batch_num) [string range $line_in 87 93]

    if {[catch {puts  $file "[format_record a]"} result ] } {
      puts $result "Error encountered writing Batch Trailer record"
    }

} ; #end of modify_batch_trailer

proc ach_create_offsetting_detail_transactions {line_in file}  {
global fileid inst_id cycl alt_data file_item_count
global LINE_COUNT ORIG_NAME ORIG_ROUTING_NUMBER ORIG_ID TRACE_NO DESTINATION_BANK T2_ACCOUNT ORIG_DESC
global SETTLE_DATE JULIAN_SETTLE_DATE DESC_DATE

   set credit_total [unoct [string range $line_in 32 43]] ; # Debit total assigned to credit total
   set debit_total  [unoct [string range $line_in 20 31]] ; # Credit total assigned to debit total
   set file_item_count [unoct [string range $line_in 4 9]]
   set TRACE_NO $file_item_count
   set tmp_hash 0

# Do the net zero debit (match the credits to zero them out)
    if {$credit_total > 0} {
        incr file_item_count
        incr batch_entry_count
        incr TRACE_NO
        set a(record_id) "DR"
        set a(tran_code) "27"
        set a(route_id_cd) "111000753"
        set a(accnt_num) "1882143785"
        set a(tran_amt) $credit_total
        set a(id_num) [clock format [clock seconds] -format "%Y%m%d%H%M%S" ]
        set a(name) "JETPAY OFFSET CREDIT"
        set a(disc_data) " "
        set a(addenda_ind) "0"
        set tmp_str "11100075"
        set tmp_str2 [format %07d $TRACE_NO]
        set a(trace_num) "$tmp_str$tmp_str2"
        if {[catch {puts  $fileid "[format_record a]"} result ] } {
          puts "Error encountered writing zero net debit Detail Record - $result"
        }
        incr LINE_COUNT
    set tmp_hash [expr $tmp_hash + 11100075]
   }



# Do the next zero credit (match the debits to zero them out)
    if {$debit_total > 0} {
        incr file_item_count
        incr batch_entry_count
        incr TRACE_NO
        set a(record_id) "DR"
        set a(tran_code) "22"
        set a(route_id_cd) "111000753"
        set a(accnt_num) "1882143785"
        set a(tran_amt) $debit_total
        set a(id_num) [clock format [clock seconds] -format "%Y%m%d%H%M%S" ]
        set a(name) "JETPAY OFFSET DEBIT"
        set a(disc_data) " "
        set a(addenda_ind) "0"
        set tmp_str "11100075"
        set tmp_str2 [format %07d $TRACE_NO]
        set a(trace_num) "$tmp_str$tmp_str2"
        if {[catch {puts  $file "[format_record a]"} result ] } {
          puts "Error encountered writing zero net credit Detail Record - $result"
        }
        incr LINE_COUNT
        set tmp_hash [expr $tmp_hash + 11100075]
   }

return $tmp_hash

}; #end ach_create_offsetting_detail_transactions


proc create_offsetting_transactions {line_in}  {
global fileid inst_id cycl alt_data
global LINE_COUNT ORIG_NAME ORIG_ROUTING_NUMBER ORIG_ID TRACE_NO DESTINATION_BANK T2_ACCOUNT ORIG_DESC
global SETTLE_DATE JULIAN_SETTLE_DATE DESC_DATE

    set batch_count [unoct [string range $line_in 1 6]]
    set block_count [unoct [string range $line_in 7 12]]
    set file_item_count [unoct [string range $line_in 13 20]]
    set TRACE_NO $file_item_count
    set hash_total [unoct [string range $line_in 21 30]]
    set debit_total [unoct [string range $line_in 31 42]]
    set credit_total [unoct [string range $line_in 43 54]]

#    puts "File Trailer Record"
#    puts "    Record Type: >[string range $line_in 0 0]<"
#    puts "    Batch Count: >$batch_count<"
#    puts "    Block Count: >$block_count<"
#    puts "     Item Count: >$file_item_count<"
#    puts "RDFI Hash Total: >$hash_total<"
#    puts "    Debit Total: >$debit_total<"
#    puts "   Credit Total: >$credit_total<"
#    puts "         Filler: >[string range $line_in 55 93]<\n\n"

# Do the net zero batch header
#    incr file_item_count
    incr batch_count
    set batch_debit_total 0         ;# Keep track of debits per batch for Batch Trailer Record
    set batch_credit_total 0        ;# Keep track of credits per batch for Batch Trailer Record
    set batch_entry_count 0         ;# Keep track of number of entrys per batch for Batch Trailer Record
    set batch_rdfi_hash 0           ;# Init RDFI Hash total for Batch Trailer Record
    set a(record_id) "BHR"
    set a(srv_class) "200"
    set a(company_name) [string range $ORIG_NAME 0 15]
    set a(disc_data) "                    "
    set a(tax_id) "$ORIG_ID"
    set a(entry_class) "CCD"
    set a(entry_desc) [string range $ORIG_DESC 0 9]
    set a(desc_date) $DESC_DATE
    set a(settle_date) $SETTLE_DATE
    set a(julian_sett_date) $JULIAN_SETTLE_DATE
    set a(orig_dfi_id) $ORIG_ROUTING_NUMBER
    set a(batch_num) $batch_count
    if {[catch {puts  $fileid "[format_record a]"} result ] } {
      puts $result "Error encountered writing zero net Batch Header Record"
    }
    incr LINE_COUNT
    set original_file_debit_total $debit_total     ;# save since we bugger this up below

# Do the net zero debit (match the credits to zero them out)
    if {$credit_total > 0} {
        incr file_item_count
        incr batch_entry_count
        incr TRACE_NO
        set temp_amount $credit_total
        set a(record_id) "DR"
        set a(tran_code) "27"
        set batch_debit_total [expr $batch_debit_total + $temp_amount]
        set debit_total [expr $debit_total + $temp_amount]
        set a(route_id_cd) $DESTINATION_BANK
        set a(accnt_num) $T2_ACCOUNT
        set batch_rdfi_hash [expr $batch_rdfi_hash + [unoct [string range $DESTINATION_BANK 0 7]]]
        set hash_total [expr  $hash_total + [unoct [string range $DESTINATION_BANK 0 7]]]
        set a(tran_amt) $temp_amount
        set a(id_num) [clock format [clock seconds] -format "%Y%m%d%H%M%S" ]
        set a(name) "NET ZERO DEBIT"
# FIXME?
        set a(disc_data) " "
# FIXME?
        set a(addenda_ind) "0"
        set tmp_str $ORIG_ROUTING_NUMBER
        set tmp_str2 [format %07d $TRACE_NO]
        set a(trace_num) "$tmp_str$tmp_str2"
        if {[catch {puts  $fileid "[format_record a]"} result ] } {
          settle_error $result "Error encountered writing zero net debit Detail Record"
        }
        incr LINE_COUNT
   }



# Do the next zero credit (match the debits to zero them out)
    if {$original_file_debit_total > 0} {
        incr file_item_count
        incr batch_entry_count
        incr TRACE_NO
        set temp_amount $original_file_debit_total          ;# use saved value since we stepped on original value up above
        set a(record_id) "DR"
        set a(tran_code) "22"
        set batch_credit_total [expr $batch_credit_total + $temp_amount]
        set credit_total [expr $credit_total + $temp_amount]
        set a(route_id_cd) $DESTINATION_BANK
        set a(accnt_num) $T2_ACCOUNT
        set batch_rdfi_hash [expr $batch_rdfi_hash + [unoct [string range $DESTINATION_BANK 0 7]]]
        set hash_total [expr  $hash_total + [unoct [string range $DESTINATION_BANK 0 7]]]
        set a(tran_amt) $temp_amount
        set a(id_num) [clock format [clock seconds] -format "%Y%m%d%H%M%S" ]
        set a(name) "NET ZERO CREDIT"
# FIXME?
        set a(disc_data) " "
# FIXME?
        set a(addenda_ind) "0"
        set tmp_str $ORIG_ROUTING_NUMBER
        set tmp_str2 [format %07d $TRACE_NO]
        set a(trace_num) "$tmp_str$tmp_str2"
        if {[catch {puts $fileid "[format_record a]"} result ] } {
          settle_error $result "Error encountered writing zero net credit Detail Record"
        }
        incr LINE_COUNT
   }



# Do the next zero batch trailer
#    incr file_item_count
    set a(record_id) "BTR"
    set a(srv_class) "200"
    set a(addenda_cnt) $batch_entry_count
    set a(entry_hash) [generate_hash_value $batch_rdfi_hash]
    set a(debit_total) $batch_debit_total
    set a(credit_total) $batch_credit_total
    set a(company_id) "$ORIG_ID"
    set a(orig_routing_num) $ORIG_ROUTING_NUMBER
    set a(batch_num) $batch_count
    if {[catch {puts  $fileid "[format_record a]"} result ] } {
      settle_error $result "Error encountered writing net zero Batch Trailer Record"
    }
   incr LINE_COUNT


# Do the new File Trailer
#    incr file_item_count

    set a(record_id) "FTR"

    set a(batch_cnt) $batch_count

    set temp_blk_count [expr $LINE_COUNT / 10]
    incr temp_blk_count
    set a(block_cnt) $temp_blk_count

    set a(item_cnt) $file_item_count
    set a(hash_num) [generate_hash_value $hash_total]
    set a(debit_total) $debit_total
    set a(credit_total) $credit_total

    if {[catch {puts $fileid "[format_record a]"} result ] } {
      settle_error $result "Error encountered writing File Trailer Record"
    }
   incr LINE_COUNT


};# end create_offsetting_transactions

proc create_file_trailer {line_in file type}  {
global fileid
global LINE_COUNT
global TRACE_NO
global CR_LINE_COUNT
global DB_LINE_COUNT
global ONE_LINE_COUNT
global CR_ENTRY_COUNT
global DB_ENTRY_COUNT
global ONE_ENTRY_COUNT
global CR_SEQ_NBR
global DB_SEQ_NBR
global ONE_SEQ_NBR
global CR_AMT_TOTAL
global DB_AMT_TOTAL
global ONE_AMT_TOTAL
global CR_HASH_TOTAL
global DB_HASH_TOTAL
global ONE_HASH_TOTAL

    set batch_count [unoct [string range $line_in 1 6]]
    set block_count [unoct [string range $line_in 7 12]]

    #JSG#incr file_item_count

    if {$type == "CR"} {
       set temp_blk_count [expr $CR_LINE_COUNT / 10]
       incr temp_blk_count
       set file_item_count $CR_ENTRY_COUNT
       set hash_total [generate_hash_value $CR_HASH_TOTAL]
       set credit_total $CR_AMT_TOTAL
       set debit_total 0
       incr CR_LINE_COUNT
    } elseif {$type == "DB"} {
       set temp_blk_count [expr $DB_LINE_COUNT / 10]
       incr temp_blk_count
       set file_item_count $DB_ENTRY_COUNT
       set hash_total [generate_hash_value $DB_HASH_TOTAL]
       set debit_total $DB_AMT_TOTAL
       set credit_total 0
       incr DB_LINE_COUNT
    } else {
       set temp_blk_count [expr $LINE_COUNT / 10]
       incr temp_blk_count
       set file_item_count [unoct [string range $line_in 13 20]]
       set hash_total [unoct [string range $line_in 21 30]]
       set debit_total [unoct [string range $line_in 31 42]]
       set credit_total [unoct [string range $line_in 43 54]]
       incr LINE_COUNT
    }

    set a(record_id) "FTR"
    set a(batch_cnt) $batch_count
    set a(block_cnt) $temp_blk_count
    set a(item_cnt) $file_item_count
    set a(hash_num) [generate_hash_value $hash_total]
    set a(debit_total) $debit_total
    set a(credit_total) $credit_total

    if {[catch {puts $file "[format_record a]"} result ] } {
      settle_error $result "Error encountered writing File Trailer Record"
    }

    puts "File Trailer Record"
    puts "    Record Type: >[string range $line_in 0 0]<"
    puts "    Batch Count: >$batch_count<"
    puts "    Block Count: >$temp_blk_count<"
    puts "     Item Count: >$file_item_count<"
    puts "RDFI Hash Total: >$hash_total<"
    puts "    Debit Total: >$debit_total<"
    puts "   Credit Total: >$credit_total<"
    puts "         Filler: >[string range $line_in 55 93]<\n\n"
} ; ### end of create_file_trailer


proc ach_create_offsetting_transactions {line_in file}  {
global fileid inst_id cycl alt_data dr_hash file_item_count
global LINE_COUNT ORIG_NAME ORIG_ROUTING_NUMBER ORIG_ID TRACE_NO DESTINATION_BANK T2_ACCOUNT ORIG_DESC
global SETTLE_DATE JULIAN_SETTLE_DATE DESC_DATE

    set batch_count [unoct [string range $line_in 1 6]]
    set block_count [unoct [string range $line_in 7 12]]
#    set file_item_count [unoct [string range $line_in 13 20]]
    set TRACE_NO $file_item_count
    if {$cycl == "002"} {
    set hash_total [expr [unoct [string range $line_in 21 30]] + [unoct $dr_hash]]
    set debit_total [expr [unoct [string range $line_in 31 42]] + [unoct [string range $line_in 43 54]]]
    set credit_total [expr [unoct [string range $line_in 31 42]] + [unoct [string range $line_in 43 54]]]
    } else {
    set hash_total [unoct [string range $line_in 21 30]]
    set debit_total [unoct [string range $line_in 31 42]]
    set credit_total [unoct [string range $line_in 43 54]]
    }

#    puts "File Trailer Record"
#    puts "    Record Type: >[string range $line_in 0 0]<"
#    puts "    Batch Count: >$batch_count<"
#    puts "    Block Count: >$block_count<"
#    puts "     Item Count: >$file_item_count<"
#    puts "RDFI Hash Total: >$hash_total<"
#    puts "    Debit Total: >$debit_total<"
#    puts "   Credit Total: >$credit_total<"
#    puts "         Filler: >[string range $line_in 55 93]<\n\n"


# Do the new File Trailer
#    incr file_item_count

    set a(record_id) "FTR"

    set a(batch_cnt) $batch_count

    set temp_blk_count [expr $LINE_COUNT / 10]
    incr temp_blk_count
    set a(block_cnt) $temp_blk_count

    set a(item_cnt) $file_item_count
    set a(hash_num) [generate_hash_value $hash_total]
    set a(debit_total) $debit_total
    set a(credit_total) $credit_total

    if {[catch {puts $file "[format_record a]"} result ] } {
      settle_error $result "Error encountered writing File Trailer Record"
    }
   incr LINE_COUNT


};# end ach_create_offsetting_transactions



proc set_effective_date {line_in} {
global fileid inst_id cycl alt_data
global DESC_DATE SETTLE_DATE JULIAN_SETTLE_DATE fileid

    set DESC_DATE [string range $line_in 63 68]
    set SETTLE_DATE [string range $line_in 69 74]
    set JULIAN_SETTLE_DATE [string range $line_in 75 77]
};# end set_effective_date



proc finish_blocking_file {file type} {
global LINE_COUNT  alt_data
global fileid inst_id cycl
global CR_LINE_COUNT
global DB_LINE_COUNT
global ONE_LINE_COUNT

    set blocking_line "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999\r"
    if {$type == "CR"} {
       set LINE_COUNT [expr $CR_LINE_COUNT % 10]
    } elseif {$type == "DB"} {
       set LINE_COUNT [expr $DB_LINE_COUNT % 10]
    } else {
       set LINE_COUNT [expr $LINE_COUNT % 10]
    }

    if {$LINE_COUNT > 0} {
       set LINE_COUNT [expr 10 - $LINE_COUNT]
    }
    for {set cntr 0} {$cntr < $LINE_COUNT} {incr cntr 1} {
        puts $file $blocking_line
    }
};# end finish_blocking_file

################################################################################
#
#    Procedure Name - init_file
#
#    Description -
#
###############################################################################
proc init_file {file} {

   if [catch {open $file {WRONLY CREAT APPEND}} fileId] {
        puts stderr "Cannot open $file : $fileId"
        exit 1
   }
   return $fileId
}

proc init_arg {argc argv} {
   global inst_id
   global file_cat
   global file_type
   global fbank
   global fjdate
   global fseq
   global filename
   global cr_outfile
   global db_outfile
   global one_outfile
   global cycl
   global cr_filePtr
   global db_filePtr
   global one_filePtr
   global splitFlag
   global input_file
   global INSTITUTION_ID
   global programName

   set inst_id 0
   set INSTITUTION_ID 0
   set file_cat ""
   set file_type 0
   set fbank ""
   set fjdate 0
   set fseq 0
   set cycl 0
   set cr_outfile ""
   set db_outfile ""
   set one_outfile ""
   set input_file ""
   set filename ""
   set cr_filePtr ""
   set db_filePtr ""
   set one_filePtr ""
   set splitFlag 0

   if {$argc < 2} {
        puts "'Usage for One file  : net_zero_file.tcl <infilename>  <outfilename>"
        puts "'Usage for split file: net_zero_file.tcl <infilename>  <Credit outfilename> <Debit outfilename>'"
        exit 1
   }

    foreach {opt} [split $argv -] {
        switch -exact -- [lindex $opt 0] {
            "i" {
                set filename [lindex $opt 1 end]
            }
            "o" {
                set one_outfile [lrange $opt 1 end]
            }
            "c" {
                set cr_outfile [lrange $opt 1 end]
            }
            "d" {
                set db_outfile [lrange $opt 1 end]
            }
            "v" {
                set MASCLR::DEBUG_LEVEL [lrange $opt 1 end]
            }
        }
    }

   # parse filename
   set varlist [split [set orig_line $filename ] .]
   MASCLR::log_message "Parsing filename $filename"
   set inst_id [lindex $varlist 0]
   set INSTITUTION_ID [lindex $varlist 0]
   set file_cat [lindex $varlist 1]
   set file_type [lindex $varlist 2]
   set fbank [lindex $varlist 3]
   set fjdate [lindex $varlist 4]
   set fseq [lindex $varlist 5]

   if { ($inst_id == "101" || $inst_id == "107") && ($file_type == "62") } {
      if {$one_outfile == "" } {
         puts "ERROR: Incorrect output file provided for input file type 62"
         exit 1
      } else {
         set one_filePtr [init_file $one_outfile]
         set splitFlag 0
      }
   }

   if { ($inst_id == "101" || $inst_id == "107") && (($file_type == "52") || ($file_type == "92")) } {
      if { ($cr_outfile == "") || ($db_outfile == "" ) } {
          puts "ERROR: Incorrect output file provided for input file type $file_type"
          exit 1
      } else {
         set cr_filePtr [init_file $cr_outfile]
         set db_filePtr [init_file $db_outfile]
         set splitFlag 1
      }
   } else {
      if {$one_outfile == ""} {
         puts "ERROR: Incorrect output file provided for input file type $file_type"
         exit 1
      } else {
         set one_filePtr [init_file $one_outfile]
      }
   }

   if {$inst_id == "811"} {
      switch $file_type {
        "52" {set cycl "001"}
        "62" {set cycl "002"}
        "72" {set cycl "003"}
        default {set cycl "001"}
      }
   } elseif {$inst_id == "105"} {
      switch $file_type {
        "52" {set cycl "001"}
        "62" {set cycl "002"}
        "72" {set cycl "001"}
                default {set cycl "001"}
      }
   } else {
      switch $file_type {
        "52" {set cycl "001"}
        "62" {set cycl "002"}
        "72" {set cycl "003"}
                default {set cycl "001"}
      }
   }

   MASCLR::log_message "$programName : Cycle set to $cycl"


   if {[catch {open $filename r} input_file]} {
      MASCLR::log_message "ERROR: $programName Cannot open input file $filename"
      exit 1
   }


} ; #endof init_arg

#### MAIN FUNCTION ####

init_arg $argc $argv

# PULLING EXTERNAL ACH CONFIG DATA FROM DB
alt_ach_data

set ORIG_NAME $alt_data($inst_id-$cycl-NET-D-ORIG_NAME)
set ORIG_DESC $alt_data($inst_id-$cycl-NET-D-ORIG_DESC)
set ORIG_ROUTING_NUMBER $alt_data($inst_id-$cycl-NET-D-ORIG_ROUTING_NUMBER)
set ORIG_ID $alt_data($inst_id-$cycl-NET-D-ORIG_ID)
set DESTINATION_BANK $alt_data($inst_id-$cycl-NET-D-DESTINATION_BANK)
set T2_ACCOUNT $alt_data($inst_id-$cycl-NET-D-T2_ACCOUNT)

set continue 1

while {[gets $input_file line] >=0 && $continue == 1} {

    switch [string range $line 0 0] {
        "1" {
            if {$splitFlag == 1 } {
                modify_file_header $line $cr_filePtr CR
                modify_file_header $line $db_filePtr DB
            } else {
                modify_file_header $line $one_filePtr ONE
            }
        }
        "8" {
            if {$cycl == "002"} {
                set dr_hash [ach_create_offsetting_detail_transactions $line $one_filePtr]
            }
            if {$splitFlag == 1 } {
                modify_batch_trailer $line $cr_filePtr CR
                modify_batch_trailer $line $db_filePtr DB
            } else {
                modify_batch_trailer $line $one_filePtr ONE
            }
        }
        "5" {
            set_effective_date $line
            if {$splitFlag == 1 } {
                modify_batch_header $line $cr_filePtr CR
                modify_batch_header $line $db_filePtr DB
            } else {
                modify_batch_header $line $one_filePtr ONE
            }
        }
        "9" {
            set continue 0
            set file_trailer $line
        }
        "6" {
            if {$splitFlag == 1 } {
                set code [string range $line 1 2]
                if {($code == "22") || ($code == "32") || ($code == "42")} {
                    modify_detail $line $cr_filePtr CR
                } elseif {($code == "27") || ($code == "37") || ($code == "47")} {
                    modify_detail $line $db_filePtr DB
                } else {
                    MASCLR::log_message "ERROR:-$programName : Do not know the transaction code $code"
                }
            } else {
                modify_detail $line $one_filePtr ONE
            }
        }
        default {
            incr LINE_COUNT
            MASCLR::log_message $line\r
        }
    }
};# end while. . .

if {$cycl == "002"} {
   ach_create_offsetting_transactions $file_trailer $one_filePtr
} else {
   #JSG# create_offsetting_transactions $file_trailer
   if {$splitFlag == 1 } {
       create_file_trailer $file_trailer $cr_filePtr CR
       create_file_trailer $file_trailer $db_filePtr DB
   } else {
       create_file_trailer $file_trailer $one_filePtr ONE
   }
}


if {$splitFlag == 1 } {
    finish_blocking_file $cr_filePtr CR
    finish_blocking_file $db_filePtr DB
} else {
    finish_blocking_file $one_filePtr ONE
}

MASCLR::log_message "Script net_zero_file.tcl complete [clock format [clock seconds] -format "%Y%m%d%H%M%S" ]"
