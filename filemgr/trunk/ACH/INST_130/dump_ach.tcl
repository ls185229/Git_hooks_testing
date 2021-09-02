#!/usr/bin/env tclsh

# Script to pull a ACH files apart

# Version 0.0 8/9/03 Joe Cloud

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


#    puts ": >[string range $line_in ]<"


proc file_header_rec {line_in} {
    puts "File Header Record"
    puts "          Record Type: >[string range $line_in 0 0]<"
    puts "           Record Nbr: >[string range $line_in 1 9]<"
    puts "        Originator ID: >[string range $line_in 10 19]<"
    puts "    File Creation Nbr: >[string range $line_in 20 23]<"
    puts " Creation Date 0YYDDD: >[string range $line_in 24 29]<"
    puts "    Destinaton Centre: >[string range $line_in 30 34]<"
    puts "        Currency Code: >[string range $line_in 55 57]<\n\n"

};# end file_header_rec


proc detail_credit_rec {line_in}  {
    puts "Detail Record"
    puts "          Record Type: >[string range $line_in 0 0]<"
    puts "           Record Nbr: >[string range $line_in 1 9]<"
    puts "        Originator ID: >[string range $line_in 10 19]<"
    puts "    File Creation Nbr: >[string range $line_in 20 23]<"
    puts "     Transaction Type: >[string range $line_in 24 26]<"
    puts "          Tran Amount: >[string range $line_in 27 36]<"
    puts "   Funding Date 0YDDD: >[string range $line_in 37 42]<"
    puts " Payee Institution ID: >[string range $line_in 43 51]<"
    puts "    Payee Account Nbr: >[string range $line_in 52 63]<"
    puts "Originator Short Name: >[string range $line_in 89 103]<"
    puts "           Payee Name: >[string range $line_in 104 133]<"
    puts " Originator Long Name: >[string range $line_in 134 163]<"
    puts "          Merchant ID: >[string range $line_in 174 192]<"
    puts "      Returns Inst ID: >[string range $line_in 193 201]<"
    puts "  Returns Account Nbr: >[string range $line_in 202 213]<\n\n"

};# end detail_credit_rec

proc detail_debit_rec {line_in}  {
    puts "Detail Record"
    puts "          Record Type: >[string range $line_in 0 0]<"
    puts "           Record Nbr: >[string range $line_in 1 9]<"
    puts "        Originator ID: >[string range $line_in 10 19]<"
    puts "    File Creation Nbr: >[string range $line_in 20 23]<"
    puts "     Transaction Type: >[string range $line_in 24 26]<"
    puts "          Tran Amount: >[string range $line_in 27 36]<"
    puts " Withdraw Date 0YYDDD: >[string range $line_in 37 42]<"
    puts "Drawee Institution ID: >[string range $line_in 43 51]<"
    puts "   Drawee Account Nbr: >[string range $line_in 52 63]<"
    puts "Originator Short Name: >[string range $line_in 89 103]<"
    puts "          Drawee Name: >[string range $line_in 104 133]<"
    puts " Originator Long Name: >[string range $line_in 134 163]<"
    puts "          Merchant ID: >[string range $line_in 174 192]<"
    puts "      Returns Inst ID: >[string range $line_in 193 201]<"
    puts "  Returns Account Nbr: >[string range $line_in 202 213]<\n\n"
}; #end detail_debit_rec

proc file_trailer_rec {line_in} {
    puts "File Trailer Record"
    puts "         Record Type: >[string range $line_in 0 0]<"
    puts "          Record Nbr: >[string range $line_in 1 9]<"
    puts "       Originator ID: >[string range $line_in 10 23]<"
    puts "  Total Debit Amount: >[string range $line_in 24 37]<"
    puts "   Total Debit Count: >[string range $line_in 38 45]<"
    puts " Total Credit Amount: >[string range $line_in 46 59]<"
    puts "  Total Credit Count: >[string range $line_in 60 67]<\n\n"
};# end file_trailer_rec

############################################################
proc convert_amount {string_in} {
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
#    puts "Converted digit is <$converted_digit>"

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
#    puts "Multiplier is $mult"

    set dummy ">[string range $string_in 0 10]$converted_digit"
#    puts "dummy is $dummy"                                    
    set amount [expr [unoct $dummy] / 100.0 * $multiplier]                   
    return $amount                                            
};# end convert_amount

#****** Main Code ******
if {$argc != 1} {
	error "Usage: dump_ach.tcl filename"
}

set input_file [open [lindex $argv 0] r]

while {[gets $input_file line] >=0} {
#   puts $line
    set rec_type [string range $line 0 0]

    switch $rec_type {
        "A" {file_header_rec $line}
        "C" {detail_credit_rec $line}
        "D" {detail_debit_rec $line}
        "Z" {file_trailer_rec $line}
        default { puts "Unknown record type - $rec_type"}
        }
}

close $input_file
puts "\nScript dump_ach.tcl complete\n\n"

exit 0
