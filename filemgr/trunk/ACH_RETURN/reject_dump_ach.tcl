#!/usr/bin/env tclsh

################################################################################
# $Id: reject_dump_ach.tcl 2390 2013-08-12 19:13:27Z mitra $
# $Rev: 2390 $
################################################################################
#
# Script to pull a ACH files apart
# Version 0.0 8/9/03 Joe Cloud
################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)

#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#######################################################################################################################

proc send_email {btext {tst_ind 1} {elvl "c"} {eml_addr ""} {eml_add_ind 1} {eml_ind "csr"} {exprtrn 0}} {
        global jp_logon_handle clr_logon_handle mbody_c sysinfo mbody mailfromlist msubj_c mailtolist mbody_u msubj_u msubj_l
mbody_l mbody_m msubj_m mbody_h msubj_h
        if {$tst_ind == 0} {
                set elvl "l"
                set exprtrn 0
                set eml_ind me
                set eml_addr ""
        }
        set mbody $btext
        switch $elvl {
                "c"     {set ebody $mbody_c; set esubj $msubj_c}
                "u"     {set ebody $mbody_u; set esubj $msubj_u}
                "m"     {set ebody $mbody_m; set esubj $msubj_m}
                "h"     {set ebody $mbody_h; set esubj $msubj_h}
                "l"     {set ebody $mbody_l; set esubj $msubj_l}
                        default {set ebody $mbody_c; set esubj $msubj_c}
        }
        switch $eml_ind {
                "csr"   {set mailto $mailtolist}
                "clr"   {set mailto clearing@jetpay.com}
                "me"    {set mailto reports-clearing@jetpay.com}
                "eml"   {set mailto $eml_addr}
                        default {set mailto $mailtolist}
        }
        if {$eml_add_ind == 0} {
                set mailto [list $mailto $mailtolist]
        }
        if {$exprtrn == ""} {
                catch {exec echo "$ebody $sysinfo $mbody" | mutt -s "$esubj" -- $mailto} exprtrn
                return $exprtrn
        } else {
                if {$tst_ind == 0} {
                        catch {exec echo "$ebody $sysinfo $mbody" | mutt -s "TESTING IGNORE EMAIL: $esubj" -- $mailto} result
                        return $exprtrn
                } else {
                        catch {exec echo "$ebody $sysinfo $mbody" | mutt -s "$esubj" -- $mailto} result
                        return $exprtrn
                }
        }
}

# Strip leading zeros off of numbers, so that they are not
# interpredted to be OCTAL
proc unoct {s} {
    set u >[string trimleft $s 0]
    if {$u == ""} {
        return 0
    } else {
        return $u
    }
};# end unoct


#    puts $fileid ": >[string range $line_in ]<"


proc file_header_rec {line_in} {
global fileid
    puts $fileid "File Header Record"
    puts $fileid "          Record Type: >[string range $line_in 0 0]<"
    puts $fileid "        Priority Code: >[string range $line_in 1 2]<"
    puts $fileid "Destination Routing #: >[string range $line_in 3 12]<"
    puts $fileid "               Origin: >[string range $line_in 13 22]<"
    puts $fileid "          File YYMMDD: >[string range $line_in 23 28]<"
    puts $fileid "            File HHMM: >[string range $line_in 29 32]<"
    puts $fileid "          ID Modifier: >[string range $line_in 33 33]<"
    puts $fileid "          Record Size: >[string range $line_in 34 36]<"
    puts $fileid "      Blocking Factor: >[string range $line_in 37 38]<"
    puts $fileid "          Format Code: >[string range $line_in 39 39]<"
    puts $fileid "          Destination: >[string range $line_in 40 62]<"
    puts $fileid "         Company Name: >[string range $line_in 63 85]<"
    puts $fileid "               Filler: >[string range $line_in 86 94]<\n\n"
};# end file_header_rec



proc batch_header_rec {line_in} {
global fileid
    puts $fileid "Batch Header Record"
    puts $fileid "           Record Type: >[string range $line_in 0 0]<"
    puts $fileid "    Service Class Code: >[string range $line_in 1 3]< "
    switch [string range $line_in 1 3] {
        "200" {puts $fileid "(Debits and Credits)"}
        "220" {puts $fileid "(Credits only)"}
        "225" {puts $fileid "(Debits only)"}
        default {puts $fileid "Unknown SCC"}
    }
    puts $fileid "          Company Name: >[string range $line_in 4 19]<"
    puts $fileid "    Discretionary Data: >[string range $line_in 20 39]<"
    puts $fileid "                Tax ID: >[string range $line_in 40 49]<"
    puts $fileid "  Standard Entry Class: >[string range $line_in 50 52]<"
    puts $fileid "           Description: >[string range $line_in 53 62]<"
    puts $fileid "    Descriptive YYMMDD: >[string range $line_in 63 68]<"
    puts $fileid "         Settle YYMMDD: >[string range $line_in 69 74]<"
    puts $fileid "    Julian Settle Date: >[string range $line_in 75 77]<"
    puts $fileid "Originator Status Code: >[string range $line_in 78 78]<"
    puts $fileid "               ODFI ID: >[string range $line_in 79 86]<"
    puts $fileid "               Batch #: >[string range $line_in 87 93]<\n\n"
};# end batch_header_rec



proc detail_rec {line_in}  {
global fileid
    puts $fileid "Detail Record"
    puts $fileid "       Record Type: >[string range $line_in 0 0]<"
    puts $fileid "  Transaction Code: >[string range $line_in 1 2]< "
    switch [string range $line_in 1 2] {
        "22" {puts $fileid "(Live checking credit)"}
        "23" {puts $fileid "(Pre-note checking credit)"}
        "27" {puts $fileid "(Live checking debit)"}
        "28" {puts $fileid "(Pre-note checking debit)"}
        "32" {puts $fileid "(Live savings credit)"}
        "33" {puts $fileid "(Pre-note savings credit)"}
        "37" {puts $fileid "(Live savings debit)"}
        "38" {puts $fileid "(Pre-note savings debit)"}
        "21" {puts $fileid "Return or NOC on a 22, 23 or 24 transaction"}
        "26" {puts $fileid "Return or NOC on a 27, 28 or 29 transaction"}
        "31" {puts $fileid "Return or NOC on a 32, 33 or 34 transaction"}
        "36" {puts $fileid "Return or NOC on a 37, 38 or 39 transaction"}
        default {puts $fileid "Unknown transaction code"}
    }
    puts $fileid "    RDFI Routing #: >[string range $line_in 3 10]<"
    puts $fileid "       Check Digit: >[string range $line_in 11 11]<"
    puts $fileid "         Account #: >[string range $line_in 12 28]<"
    puts $fileid "       Tran Amount: >[string range $line_in 29 38]<"
    puts $fileid "         ID Number: >[string range $line_in 39 53]<"
    puts $fileid "              Name: >[string range $line_in 54 75]<"
    puts $fileid "Discretionary Data: >[string range $line_in 76 77]<"
    puts $fileid " Addenda Indicator: >[string range $line_in 78 78]<"
    puts $fileid "           Trace #: >[string range $line_in 79 93]<\n\n"
};# end detail_rec



proc type_05_addenda {line_in} {
global fileid
    puts $fileid "        Payment Info: >[string range $line_in 3 82]<"
    puts $fileid "     Addenda Seq Num: >[string range $line_in 83 86]<"
    puts $fileid "Entry Detail Seq Num: >[string range $line_in 87 93]<\n\n"
};# end type_05_addenda



proc lookup_return {reason_code} {
global fileid
    switch $reason_code {
        "R01" {return "Insufficient funds"}
        "R02" {return "Account closed"}
        "R03" {return "No account/unable to locate"}
        "R04" {return "Invalid account number"}
        "R05" {return "Reserved"}
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
global fileid
    puts $fileid "  Return Reason Code : >[string range $line_in 3 5] [lookup_return [string range $line_in 3 5]]<"
    puts $fileid "Original Trace Number: >[string range $line_in 6 20]<"
    puts $fileid "                  DOD: >[string range $line_in 21 26]<"
    puts $fileid "        Original RDFI: >[string range $line_in 27 34]<"
    puts $fileid "         Addenda Info: >[string range $line_in 35 78]<"
    puts $fileid "         Trace Number: >[string range $line_in 79 93]<\n\n"
};# end type_99_addenda



proc lookup_change {reason_code} {
global fileid
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
global fileid
    puts $fileid "         Change Code : >[string range $line_in 3 5] [lookup_change [string range $line_in 3 5]]<"
    puts $fileid "Original Trace Number: >[string range $line_in 6 20]<"
    puts $fileid "             Reserved: >[string range $line_in 21 26]<"
    puts $fileid "        Original RDFI: >[string range $line_in 27 34]<"
    puts $fileid "       Corrected Data: >[string range $line_in 35 63]<"
    puts $fileid "             Reserved: >[string range $line_in 64 78]<"
    puts $fileid "         Trace Number: >[string range $line_in 79 93]<\n\n"
};# end type_98_addenda



proc addenda_rec {line_in} {
global fileid
    puts $fileid "Addenda Record"
    puts $fileid "          Record Type: >[string range $line_in 0 0]<"
    puts $fileid "    Addenda Type Code: >[string range $line_in 1 2]<"
    switch [string range $line_in 1 2] {
        "05" {type_05_addenda $line_in}
        "98" {type_98_addenda $line_in}
        "99" {type_99_addenda $line_in}
        default {puts $fileid "Unknown addenda type\n\n"}
    }
};# end addenda_rec



proc batch_trailer_rec {line_in} {
global fileid
    puts $fileid "Batch Trailer Record"
    puts $fileid "       Record Type: >[string range $line_in 0 0]<"
    puts $fileid "Service Class Code: >[string range $line_in 1 3] "
    switch [string range $line_in 1 3] {
        "200" {puts $fileid "(Debits and Credits)"}
        "220" {puts $fileid "(Credits only)"}
        "225" {puts $fileid "(Debits only)"}
        default {puts $fileid "Unknown SCC"}
    }
    puts $fileid "     Addenda Count: >[string range $line_in 4 9]<"
    puts $fileid "   RDFI Hash Total: >[string range $line_in 10 19]<"
    puts $fileid "       Debit Total: >[string range $line_in 20 31]<"
    puts $fileid "      Credit Total: >[string range $line_in 32 43]<"
    puts $fileid "        Company ID: >[string range $line_in 44 53]<"
    puts $fileid "            Filler: >[string range $line_in 54 78]<"
    puts $fileid "           ODFI ID: >[string range $line_in 79 86]<"
    puts $fileid "           Batch #: >[string range $line_in 87 93]<\n\n"
};# end batch_trailer_rec



proc file_trailer_rec {line_in} {
global fileid
    puts $fileid "File Trailer Record"
    puts $fileid "    Record Type: >[string range $line_in 0 0]<"
    puts $fileid "    Batch Count: >[string range $line_in 1 6]<"
    puts $fileid "    Block Count: >[string range $line_in 7 12]<"
    puts $fileid "     Item Count: >[string range $line_in 13 20]<"
    puts $fileid "RDFI Hash Total: >[string range $line_in 21 30]<"
    puts $fileid "    Debit Total: >[string range $line_in 31 42]<"
    puts $fileid "   Credit Total: >[string range $line_in 43 54]<"
    puts $fileid "         Filler: >[string range $line_in 55 93]<\n\n"
};# end file_trailer_rec



proc convert_amount {string_in} {
global fileid
#    puts "String passed in was <$string_in> with a length of >[string length $string_in]<"
    set last_digit >[string range $string_in 11 11]
#    puts "Last digit is <$last_digit>"            
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
#    puts $fileid "Converted digit is <$converted_digit>"

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
#    puts $fileid "Multiplier is $mult"

    set dummy ">[string range $string_in 0 10]$converted_digit"
#    puts $fileid "dummy is $dummy"                                    
    set amount [expr [unoct $dummy] / 100.0 * $multiplier]                   
    return $amount                                            
};# end convert_amount

proc transaction_batch_trailer_summary {line_in} {
global fileid
    puts $fileid ">[string range $line_in 9 18]\t\
          >[string range $line_in 44 49]\t\
          >[string range $line_in 50 55]\t\
          [format "%13.2f" [expr [unoct >[string range $line_in 56 67]]/100]]\t\
          >[string range $line_in 68 73]\t\
          [format "%13.2f" [expr [unoct >[string range $line_in 74 85]]/100]]\t\
          >[string range $line_in 86 91]\t\
          [format "%13.2f" [convert_amount >[string range $line_in 92 103]]]<"
};# end transaction_batch_trailer



proc transaction_file_summary {line_in} {
global fileid
    puts $fileid "File Summary Record"
    puts $fileid "   Record Num: >[string range $line_in 3 8]<"
    puts $fileid "    Batch Cnt: >[string range $line_in 9 12]<"
    puts $fileid " File Seq Num: >[string range $line_in 13 18]<"
    puts $fileid "  Julian Date: >[string range $line_in 19 21]<"
    puts $fileid "   Item Count: >[string range $line_in 25 30]<"
    puts $fileid "   Net Amount: >[string range $line_in 31 42]<"
    puts $fileid "  Srv Est Num: >[string range $line_in 43 52]<"
    puts $fileid "Proc Cntrl ID: >[string range $line_in 53 58]\n"
};# end transaction_file_summary

set dt [clock format [clock seconds] -format "%Y%m%d"]
set dts [clock format [clock seconds] -format "%Y%m%d%H%M%S"]

#****** Main Code ******
if {$argc == 1} {

set dt [lindex $argv 0]

set in_file "jetpay$dt.ret"

if {[file exists jetpay$dt.ret]} {
set input_file [open jetpay$dt.ret r]
} else {
puts "No file found"
exit 0
}

} else {
set in_file "jetpay$dt.ret"
if {[file exists jetpay$dt.ret]} {
set input_file [open jetpay$dt.ret r]
} else {
puts "No file found" 
exit 0
}

}

set outfile ach_returns_$dt.doc

if {[file exists $outfile]} {
    set nfile "duplicate-$dts-$outfile"
    exec mv $outfile ARCHIVE/$nfile
}

if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
        puts stderr "Cannot open /duplog : $fileid"
        exit 1
}

set printrec 1
set counter 1
while {[gets $input_file line] >=0} {
#   puts $line
    set rec_type [string range $line 0 0]
    set taxid [string range $line 40 49]
    set comp_id [string range $line 44 53]
    set headline "RETURN MSG $counter \n---------------------------------------------------------------------"
   if {$rec_type == "5" && $taxid == "1202948242"} {
     set printrec 0
   } elseif {$rec_type == "8" && $comp_id == "1202948242"} {
     set printrec 1
   }
  if {$printrec == 0} {
    switch $rec_type {
        "1" {#file_header_rec $line}
        "5" {#batch_header_rec $line}
        "6" {puts $fileid $headline; set counter [expr $counter + 1]; detail_rec $line}
        "7" {addenda_rec $line}
        "8" {#batch_trailer_rec $line}
        "9" {#file_trailer_rec $line}
        default { puts $fileid "Unknown record type - $rec_type"}
        }
  }
}

close $input_file
close $fileid

if {[file size $outfile] > 0} {

exec mutt -a $outfile -s "C&S ACH Return Report" -- clearing@jetpay.com apps@jetpayms.com clowe@jetpay.com < achbody.txt
puts "emailed file"
exec mv $outfile ARCHIVE/
exec mv $in_file ARCHIVE/

} else {

puts "No returns found" 
exec mv $outfile ARCHIVE/
exec mv $in_file ARCHIVE/

}
