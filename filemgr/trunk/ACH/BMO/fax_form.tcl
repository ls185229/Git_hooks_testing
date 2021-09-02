#!/usr/bin/env tclsh

################################################################################
# $Id: fax_form.tcl 4676 2018-08-30 21:36:28Z skumar $
# $Rev: 4676 $
################################################################################
#
# File Name:  fax_form.tcl
#
# Description:  This program parses the contents of a specified ACH file for
#               faxing.
#              
# Script Arguments:  FILE_NAME = Name of file to parse.
#					 file_type = ACH file type.
#					 inst_id = Institution ID.
#
# Output:  None.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
# Script to generate the data that Bancorp requires T2 to
# Fax in each day prior to their releasing our ACH file.
# Code based on the dump_ach.tcl script.
# Version 0.00 12/23/04 Joe Cloud
#
# Script to pull a ACH files apart
#
# Version 0.0 8/9/03 Joe Cloud
# Version 0.1 10/17/06 Jackie Young
# Updated to work for Merrick
#
################################################################################

#package require Mpexpr
package require Oratcl
if {[catch {set db_logon_handle [oralogon masclr/masclr@$env(IST_DB)]} result]} {
    if { [catch { exec echo "ACH Transmittal failed to run $0 DB logon" | mutt -s "ACH Transmittal" -- Clearing.JetPayTX@ncr.com } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
  exit
}



set add_rec [oraopen $db_logon_handle]
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


#    puts ": [string range $line_in ]"


proc file_header_rec {line_in} {
    global ORIGINATOR_NAME ORIGINATOR_ID FILE_NUMBER FILE_DATE

#    puts "File Header Record"
#    puts "          Record Type: [string range $line_in 0 0]"
#    puts "        Priority Code: [string range $line_in 1 2]"
#    puts "Destination Routing #: [string range $line_in 3 12]"
#    puts "               Origin: [string range $line_in 13 22]"
    set ORIGINATOR_ID [string range $line_in 13 22]
#    puts "          File YYMMDD: [string range $line_in 23 28]"
    set temp_str [string range $line_in 23 28]
    set FILE_DATE "[string range $temp_str 2 3]/[string range $temp_str 4 5]/[string range $temp_str 0 1]"

#    puts "            File HHMM: [string range $line_in 29 32]"
#    puts "          ID Modifier: [string range $line_in 33 33]"
    scan [string range $line_in 33 33] %c FILE_NUMBER
    set FILE_NUMBER [expr $FILE_NUMBER - 64]
#    puts "          Record Size: [string range $line_in 34 36]"
#    puts "      Blocking Factor: [string range $line_in 37 38]"
#    puts "          Format Code: [string range $line_in 39 39]"
#    puts "          Destination: [string range $line_in 40 62]"
#    puts "         Company Name: [string range $line_in 63 85]"
    set ORIGINATOR_NAME [string range $line_in 63 85]
#    puts "               Filler: [string range $line_in 86 94]\n\n"
};# end file_header_rec



proc batch_header_rec {line_in} {
    global EFFECTIVE_DATE COMPANY_ID
#    puts "Batch Header Record"
#    puts "           Record Type: [string range $line_in 0 0]"
#    puts -nonewline "    Service Class Code: [string range $line_in 1 3] "
#    switch [string range $line_in 1 3] {
#        "200" {puts "(Debits and Credits)"}
#        "220" {puts "(Credits only)"}
#        "225" {puts "(Debits only)"}
#        default {puts "Unknown SCC"}
#    }
#    puts "          Company Name: [string range $line_in 4 19]"
#    puts "    Discretionary Data: [string range $line_in 20 39]"
#    puts "                Tax ID: [string range $line_in 40 49]"
   set COMPANY_ID [string range $line_in 40 49]
#    puts "  Standard Entry Class: [string range $line_in 50 52]"
#    puts "           Description: [string range $line_in 53 62]"
#    puts "    Descriptive YYMMDD: [string range $line_in 63 68]"
#    puts "         Settle YYMMDD: [string range $line_in 69 74]"
   set temp_str [string range $line_in 69 74]
   set EFFECTIVE_DATE "[string range $temp_str 2 3]/[string range $temp_str 4 5]/[string range $temp_str 0 1]"

#    puts "    Julian Settle Date: [string range $line_in 75 77]"
#    puts "Originator Status Code: [string range $line_in 78 78]"
#    puts "               ODFI ID: [string range $line_in 79 86]"
#    puts "               Batch #: [string range $line_in 87 93]\n\n"
};# end batch_header_rec



proc detail_rec {line_in}  {
    global DEBIT_TOTAL CREDIT_TOTAL DEBIT_COUNT CREDIT_COUNT
#    puts "Detail Record"
#    puts "       Record Type: [string range $line_in 0 0]"
#    puts -nonewline "  Transaction Code: [string range $line_in 1 2] "
    set tran_amount [unoct [string range $line_in 29 38]]
    switch [string range $line_in 1 2] {
        "22" { set CREDIT_TOTAL [expr $CREDIT_TOTAL + $tran_amount]
               incr CREDIT_COUNT}
        "27" { set DEBIT_TOTAL [expr $DEBIT_TOTAL + $tran_amount]
               incr DEBIT_COUNT}
        "32" { set CREDIT_TOTAL [expr $CREDIT_TOTAL + $tran_amount]
               incr CREDIT_COUNT}
        "37" { set DEBIT_TOTAL [expr $DEBIT_TOTAL + $tran_amount]
               incr DEBIT_COUNT}
        "42" { set CREDIT_TOTAL [expr $CREDIT_TOTAL + $tran_amount]
               incr CREDIT_COUNT}
        "47" { set DEBIT_TOTAL [expr $DEBIT_TOTAL + $tran_amount]
               incr DEBIT_COUNT}
        default {puts "Unknown transaction code [string range $line_in 1 2]"}
    }

#    switch [string range $line_in 1 2] {
#        "21" {puts "Return or NOC on a 22, 23 or 24 transaction"}
#        "22" {puts "(Live checking credit)"}
#        "23" {puts "(Pre-note checking credit)"}
#        "26" {puts "Return or NOC on a 27, 28 or 29 transaction"}
#        "27" {puts "(Live checking debit)"}
#        "28" {puts "(Pre-note checking debit)"}
#
#        "31" {puts "Return or NOC on a 32, 33 or 34 transaction"}
#        "32" {puts "(Live savings credit)"}
#        "33" {puts "(Pre-note savings credit)"}
#        "36" {puts "Return or NOC on a 37, 38 or 39 transaction"}
#        "37" {puts "(Live savings debit)"}
#        "38" {puts "(Pre-note savings debit)"}
#
#        "42" {puts "(General Ledger credit)"}
#        "43" {puts "(Pre-note General Ledger credit)"}
#        "47" {puts "(General Ledger debit)"}
#        default {puts "Unknown transaction code"}
#    }
#    puts "    RDFI Routing #: [string range $line_in 3 10]"
#    puts "       Check Digit: [string range $line_in 11 11]"
#    puts "         Account #: [string range $line_in 12 28]"
#    puts "       Tran Amount: [string range $line_in 29 38]"
#    puts "         ID Number: [string range $line_in 39 53]"
#    puts "              Name: [string range $line_in 54 75]"
#    puts "Discretionary Data: [string range $line_in 76 77]"
#    puts " Addenda Indicator: [string range $line_in 78 78]"
#    puts "           Trace #: [string range $line_in 79 93]\n\n"
};# end detail_rec



proc type_05_addenda {line_in} {
#    puts "        Payment Info: [string range $line_in 3 82]"
#    puts "     Addenda Seq Num: [string range $line_in 83 86]"
#    puts "Entry Detail Seq Num: [string range $line_in 87 93]\n\n"
};# end type_05_addenda



proc lookup_return {reason_code} {
    switch $reason_code {
        "R01" {return "Insufficient funds"}
        "R02" {return "Account closed"}
        "R03" {return "No account/unable to locate"}
        "R04" {return "Invalid account number"}
        "R05" {return "Unauthorized Debit to Consumer Account Using Corporate SEC Code"}
        "R06" {return "Returned per ODFI's request"}
        "R07" {return "Authorization revoked by customer"}
        "R08" {return "Payment stopped"}
        "R09" {return "Uncollected funds"}
        "R10" {return "Customer advises not authorized"}
        "R11" {return "Check truncation entry return"}
        "R12" {return "Branch sold to other DFI"}
        "R13" {return "RDFI not qualified to participate"}
        "R14" {return "Representative payee deceased or unable to continue in that capacity"}
        "R15" {return "Beneficiary deceased"}
        "R16" {return "Account frozen"}
        "R17" {return "File record edit criteria"}
        "R18" {return "Improper effective entry date"}
        "R19" {return "Amount field error"}
        "R20" {return "Non-transaction account"}
        "R21" {return "Invalid company ID"}
        "R22" {return "Invalid individual ID"}
        "R23" {return "Credit entry refused by Receiver"}
        "R24" {return "Duplicate entry"}
        "R25" {return "Addenda error"}
        "R26" {return "Mandatory field error"}
        "R27" {return "Trace number error"}
        "R28" {return "Transit/Routing check digit error"}
        "R29" {return "Corporate customer advises not authorized"}
        "R30" {return "RDFI not a participant in check truncation program"}
        "R31" {return "Permissable return entry"}
        "R32" {return "RDFI - non-settlement"}
        "R33" {return "Return for XCK"}
        "R34" {return "Limited particpation DFI"}
        "R50" {return "State law affecting RCK acceptance"}
        "R51" {return "Item is ineligible, notice not provided, signature not genuine, or item altered"}
        "R52" {return "Stop payment on item for which an RCK item was received"}
        "R80" {return "Cross border coding error"}
        default {return "Unrecognized reason code"}
    }
};# end lookup_return



proc type_99_addenda {line_in} {
#    puts "  Return Reason Code : [string range $line_in 3 5] [lookup_return [string range $line_in 3 5]]"
#    puts "Original Trace Number: [string range $line_in 6 20]"
#    puts "                  DOD: [string range $line_in 21 26]"
#    puts "        Original RDFI: [string range $line_in 27 34]"
#    puts "         Addenda Info: [string range $line_in 35 78]"
#    puts "         Trace Number: [string range $line_in 79 93]\n\n"
};# end type_99_addenda



proc lookup_change {reason_code} {
    switch $reason_code {
        "C01" {return "Incorrect DFI account number"}
        "C02" {return "Incorrect routing/transit number"}
        "C03" {return "Incorrect routing/transit number and incorrect account number"}
        "C04" {return "Incorrect individual name"}
        "C05" {return "Incorrect transaction code"}
        "C06" {return "Incorrect account number and incorrect transaction code"}
        "C07" {return "Incorrect routing/transit, account and transaction code"}
        "C09" {return "Incorrect individual ID number"}
        "C10" {return "Incorrect company name"}
        "C11" {return "Incorrect company ID"}
        "C12" {return "Incorrect company name and ID"}
        "C13" {return "Addenda format error"}
        default {return "Unrecognized change code"}
    }
};# end lookup_change



proc type_98_addenda {line_in} {
#    puts "         Change Code : [string range $line_in 3 5] [lookup_change [string range $line_in 3 5]]"
#    puts "Original Trace Number: [string range $line_in 6 20]"
#    puts "             Reserved: <[string range $line_in 21 26]>"
#    puts "        Original RDFI: [string range $line_in 27 34]"
#    puts "       Corrected Data: [string range $line_in 35 63]"
#    puts "             Reserved: <[string range $line_in 64 78]>"
#    puts "         Trace Number: [string range $line_in 79 93]\n\n"
};# end type_98_addenda



proc addenda_rec {line_in} {
#    puts "Addenda Record"
#    puts "          Record Type: [string range $line_in 0 0]"
#    puts "    Addenda Type Code: [string range $line_in 1 2]"
#    switch [string range $line_in 1 2] {
#        "05" {type_05_addenda $line_in}
#        "98" {type_98_addenda $line_in}
#        "99" {type_99_addenda $line_in}
#        default {puts "Unknown addenda type\n\n"}
#    }
};# end addenda_rec



proc batch_trailer_rec {line_in} {
#global COMPANY_ID
#    puts "Batch Trailer Record"
#    puts "       Record Type: [string range $line_in 0 0]"
#    puts -nonewline "Service Class Code: [string range $line_in 1 3] "
#    switch [string range $line_in 1 3] {
#        "200" {puts "(Debits and Credits)"}
#        "220" {puts "(Credits only)"}
#        "225" {puts "(Debits only)"}
#        default {puts "Unknown SCC"}
#    }
#    puts "     Addenda Count: [string range $line_in 4 9]"
#    puts "   RDFI Hash Total: [string range $line_in 10 19]"
#    puts "       Debit Total: [string range $line_in 20 31]"
#    puts "      Credit Total: [string range $line_in 32 43]"
#    puts "        Company ID: [string range $line_in 44 53]"
#set COMPANY_ID [string range $line_in 44 53]
#    puts "            Filler: [string range $line_in 54 78]"
#    puts "           ODFI ID: [string range $line_in 79 86]"
#    puts "           Batch #: [string range $line_in 87 93]\n\n"
};# end batch_trailer_rec



proc file_trailer_rec {line_in} {
#    puts "File Trailer Record"
#    puts "    Record Type: [string range $line_in 0 0]"
#    puts "    Batch Count: [string range $line_in 1 6]"
#    puts "    Block Count: [string range $line_in 7 12]"
#    puts "     Item Count: [string range $line_in 13 20]"
#    puts "RDFI Hash Total: [string range $line_in 21 30]"
#    puts "    Debit Total: [string range $line_in 31 42]"
#    puts "   Credit Total: [string range $line_in 43 54]"
#    puts "         Filler: [string range $line_in 55 93]\n\n"
};# end file_trailer_rec



proc convert_amount {string_in} {
##    puts "String passed in was <$string_in> with a length of [string length $string_in]"
    set last_digit [string range $string_in 11 11]
##    puts "Last digit is <$last_digit>"
    switch $last_digit {
        "\{" -
        "\}" {set converted_digit "0"}
        "A" -
        "J" {set converted_digit "1"}
        "B" -
        "K" {set converted_digit "2"}
        "C" -
        "L" {set converted_digit "3"}
        "D" -
        "M" {set converted_digit "4"}
        "E" -
        "N" {set converted_digit "5"}
        "F" -
        "O" {set converted_digit "6"}
        "G" -
        "P" {set converted_digit "7"}
        "H" -
        "Q" {set converted_digit "8"}
        "I" -
        "R" {set converted_digit "9"}
       }
##    puts "Converted digit is <$converted_digit>"

    switch $last_digit {
        "\{" -
        "A" -
        "B" -
        "C" -
        "D" -
        "E" -
        "F" -
        "G" -
        "H" -
        "I" {set multiplier 1.0}
        default {set multiplier -1.0}
       }
##    puts "Multiplier is $mult"

    set dummy "[string range $string_in 0 10]$converted_digit"
##    puts "dummy is $dummy"
    set amount [expr [unoct $dummy] / 100.0 * $multiplier]
    return $amount
};# end convert_amount

proc transaction_batch_trailer_summary {line_in} {
#    puts "[string range $line_in 9 18]\t\
          [string range $line_in 44 49]\t\
          [string range $line_in 50 55]\t\
          [format "%13.2f" [expr [unoct [string range $line_in 56 67]]/100]]\t\
          [string range $line_in 68 73]\t\
          [format "%13.2f" [expr [unoct [string range $line_in 74 85]]/100]]\t\
          [string range $line_in 86 91]\t\
          [format "%13.2f" [convert_amount [string range $line_in 92 103]]]"
};# end transaction_batch_trailer



proc transaction_file_summary {line_in} {
#    puts "File Summary Record"
#    puts "   Record Num: [string range $line_in 3 8]"
#    puts "    Batch Cnt: [string range $line_in 9 12]"
#    puts " File Seq Num: [string range $line_in 13 18]"
#    puts "  Julian Date: [string range $line_in 19 21]"
#    puts "   Item Count: [string range $line_in 25 30]"
#    puts "   Net Amount: [string range $line_in 31 42]"
#    puts "  Srv Est Num: [string range $line_in 43 52]"
#    puts "Proc Cntrl ID: [string range $line_in 53 58]\n"
};# end transaction_file_summary



#****** Main Code ******
if {$argc != 3} {
    error "Usage: fax_form.tcl filename institution_id file_type"
}

set ORIGINATOR_NAME ""
set ORIGINATOR_ID ""
set FILE_NAME [lindex $argv 0]
set file_type [lindex $argv 2]
set inst_id [lindex $argv 1]
set str_pos [string first "/" $FILE_NAME]
if {$str_pos > 0} {
    incr str_pos
    set FILE_NAME [string range $FILE_NAME $str_pos end]
}
set FILE_NUMBER ""
set FILE_DATE ""
set DEBIT_TOTAL 0
set DEBIT_COUNT 0
set CREDIT_TOTAL 0
set CREDIT_COUNT 0
set EFFECTIVE_DATE ""
set COMPANY_ID ""
set EFFECTIVE_DATE_IN ""
set input_file [open [lindex $argv 0] r]

while {[gets $input_file line] >=0} {
#   puts $line
    set rec_type [string range $line 0 0]

    switch $rec_type {
        "1" {file_header_rec $line}
        "5" {batch_header_rec $line}
        "6" {detail_rec $line}
        "7" {addenda_rec $line}
        "8" {batch_trailer_rec $line}
        "9" {file_trailer_rec $line}
        default { puts "Unknown record type - $rec_type"}
        }
}

close $input_file

if {$file_type == "62"} {

set rightnow [clock seconds]
set curdate [clock format $rightnow -format "%Y/%m/%d"]
set curtime [clock format $rightnow -format "%H:%M:%S"]


puts " FIRST PREMIER BANK"
puts " ACH TRANSMITTAL LETTER"
puts ""
puts ""
puts " Fax To: (605) 978-9759 or (605) 357-3420"
puts ""
puts " Attention: ACH Department"
puts ""
puts " NAME OF ORGANIZATION: NCR PS"
puts ""
puts ""
puts " DATE: $curdate TIME: $curtime"
puts ""
puts " TOTAL DOLLAR AMOUNT OF CREDITS: [format %0.2f [expr $CREDIT_TOTAL/100.0]]"
puts " NUMBER OF CREDIT TRANSACTIONS: $CREDIT_COUNT"
puts ""
puts ""
puts " TOTAL DOLLAR AMOUNT OF DEBITS: [format %0.2f [expr $DEBIT_TOTAL/100.0]]"
puts " NUMBER OF DEBIT TRANSACTIONS: $DEBIT_COUNT"
puts ""
puts ""
puts ""
puts " SIGNATURE: ____________________________"
puts ""
puts ""
puts " In case of transmissions questions: Signature's Phone Number: 1-800-834-4405"

} else {


puts "ORIGINATOR_NAME: NCR PS TX"
puts "   Point Name: NCR TX"
puts "   Payment Type:  ACH"
puts "   Originator ID: $COMPANY_ID"
puts " "
puts "         File Name: $FILE_NAME"
puts "       File_Number: $FILE_NUMBER"
puts "         File Date: $FILE_DATE"
puts " "
puts "       Debit Count: $DEBIT_COUNT"
puts "       Debit Total: [format %0.2f [expr $DEBIT_TOTAL/100.0]]"
puts "    Effective Date: $EFFECTIVE_DATE"
puts " "
puts "      Credit Count: $CREDIT_COUNT"
puts "      Credit Total: [format %0.2f [expr $CREDIT_TOTAL/100.0]]"
puts "    Effective Date: $EFFECTIVE_DATE"
puts " "
puts "    Number of Prenotes: 0"
puts " "
puts "     Authorized By: Pretexa Patel"
puts " "
puts "      Senders Name: NCR PS"
puts "     Senders Phone: 800-834-4405"
puts "     Senders Email: clearing@NCR PS.com"
}
set sql1 "insert into ach_transmittal (INSTITUTION_ID, FILE_NAME, ORIGINATOR_NAME, ORIGINATOR_ID, FILE_NUMBER, FILE_DATE, DEBIT_COUNT, DEBIT_TOTAL, DEBIT_EFFECTIVE_DATE, CREDIT_COUNT, CREDIT_TOTAL, CREDIT_EFFECTIVE_DATE, NO_PRENOTES, AUTHORIZED_BY, SENDER_NAME, SENDER_PHONE, SENDER_EMAIL) values ('$inst_id', '$FILE_NAME', 'NCR PS LLC', '$COMPANY_ID', '$FILE_NUMBER', sysdate, '$DEBIT_COUNT', '[format %0.2f [expr $DEBIT_TOTAL/100.0]]', sysdate, '$CREDIT_COUNT', '[format %0.2f [expr $CREDIT_TOTAL/100.0]]', sysdate, '0', 'Pretexa Patel', 'NCR PS', '800-834-4405', 'clearing@NCR PS.com')"


#catch {orasql $add_rec $sql1} result
set result 0
if {$result != 0} {
    if { [catch { exec echo "Failed to insert into ACH Transmittal \n $result" | mutt -s "Failed insert into ACH Transmittal" -- clearing@NCR PS.com  } result] != 0 } {
           if { [string range $result 0 21] == "Waiting for fcntl lock" } {
              puts "Ignore mutt file control lock $result"
           } else {
              error "mutt error message: $result"
           }
    }
  exit 1
}

oralogoff $db_logon_handle

#puts "\nScript fax_form.tcl complete\n\n"
