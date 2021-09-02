#!/usr/bin/env tclsh

################################################################################
# $Id: test_luhn.tcl  bjones $
# $Rev:  $
################################################################################

package require Tcl 8.5
proc luhn {digitString  {test 0}} {
    regsub -all {[^0-9]} $digitString {} newstring
    if {$test > 2} {puts "len [string length $digitString]: $digitString : len [string length $newstring] $newstring" }
    if {[string length $digitString] >= [expr [string length $newstring] * 2] } {
        return 0
    }
    if {[regexp {[^0-9]} $newstring]} {error "not a number"}
    set sum 0
    set flip 1
    foreach ch [lreverse [split $newstring {}]] {
        incr sum [lindex {
            {0 1 2 3 4 5 6 7 8 9}
            {0 2 4 6 8 1 3 5 7 9}
        } [expr {[incr flip] & 1}] $ch]
    }
    return [expr {($sum % 10) == 0}]
}

proc mask_card {testlist {test 0}} {
    set pattern {(?:(?:^|[^.,=])\y([1-9](?:[ \.\-\,\_\t]*\d){9,18})\y)}

    if {$test} {puts "Pattern: $pattern\nBefore:\n $testlist"}
    set newlist $testlist
    foreach mtch_index [regexp -all -inline -indices $pattern $testlist] {
        set mtch [string range $testlist [lindex $mtch_index 0] [lindex $mtch_index 1]]
        set found_one [luhn $mtch $test]
        if $found_one {
            set    new_mtch [string range $mtch 0 5]
            append new_mtch [string repeat {*} [expr [string length $mtch] - 10]]
            append new_mtch [string range $mtch end-3 end]
            set newlist [
                string range $newlist 0 [expr [lindex $mtch_index 0] - 1]
                ]$new_mtch[
                string range $newlist [expr [lindex $mtch_index 1] + 1] end
                ]
        }
    }
    if {$test} {puts "After:\n$newlist"}
    return $newlist
}

set testlist {
            49927398716         .  49927398717        .
            1234-5678                              1234 5670 .  "alke23451234"     .
            1234-5678             1234 5670 .  "alke23451234"     .
            1234567812345678    .  "alke2345123da4"   .

101,447474200000104,WEB HOSTING PAD     ,24-JAN-17,25-JAN-17,VISA,4000300020001000,24474745269171420302350,,19.95,Fee Collection,412063,447474,PARB  40003000 20001000 ROL#001488654155 2017006002101                 ,840
101,447474200000104,WEB HOSTING PAD     ,24-JAN-17,25-JAN-17,VISA,447409xxxxxx9948,24474746296227800247931,,52.88,Fee Collection,447409,447474,RO CASE NUMBER 1493517897 PRE ARB PST TIME FRAME                      ,840
101,447474210000293,GEEKS ONSITE        ,26-JAN-17,27-JAN-17,VISA,4000100020003000,24474746308243210120374,,87.44,Fee Collection,412063,447474,PARB  4000100020003000 ROL#001488407027 2016366000012                 ,840
101,447474210000293,GEEKS ONSITE        ,30-JAN-17,31-JAN-17,VISA,441712xxxxxx0811,24474746289259890146334,,297,Fee Collection,412063,447474,PARB  2333333333333333 ROL#001487189735 2017004000268                 ,840
101,447474210000293,GEEKS ONSITE        ,30-JAN-17,31-JAN-17,VISA,441712xxxxxx0811,24474746300026410135229,,89,Fee Collection,412063,447474,PARB  2333333333333333 ROL#001487189742 2017004000269                 ,840
101,,,06-JAN-17,07-JAN-17,VISA,400030xxxxxx6942,,,49,Fee Collection,412063,447474,PARB  4000300010002000 ROL#001482412628 2016350002711                 ,840
101,,,06-JAN-17,07-JAN-17,VISA,400030xxxxxx9636,,,34.95,Fee Collection,412063,447474,PARB  4000301234567893 ROL#001483459242 2016350002807                 ,840
101,,,06-JAN-17,07-JAN-17,VISA,222222xxxxxx3402,,,954.95,Fee Collection,412063,447474,PARB  2222222233333333 ROL#001482680744 2016347006619                 ,840
101,,,09-JAN-17,10-JAN-17,VISA,447409xxxxxx8800,,,88.88,Fee Collection,447409,447474,ROL CASE NUMBER 1485836263 PRE ARB PST TIME FRAME                     ,840

2333333333333330 2333333333333331 2333333333333332 2333333333333333 2333333333333334 2333333333333335 2333333333333336 2333333333333337 2333333333333338 2333333333333339
4000301234567890 4000301234567891 4000301234567892 4000301234567893 4000301234567894 4000301234567895 4000301234567896 4000301234567897 4000301234567898 4000301234567899
}

puts "fblocked stdin: [fblocked stdin]"
puts "eof stdin: [eof stdin]"
puts "argv0: $argv0; argc: $argc; argv: $argv"

  #  while {[eof stdin] == 0 } {
  #      gets stdin row
  #      # puts "row: $row"
  #      set result [mask_card $row 0]
  #      puts "$result"
  #  }

puts "fblocked stdin: [fblocked stdin]"
puts "eof stdin: [eof stdin]"
puts "argv0: $argv0; argc: $argc; argv: $argv"


# if { [fblocked stdin] != 0 } {
#     puts "fblocked stdin is not 0"
# } elseif {$argc > 0} {
#     foreach arg $argv {
#         set result [mask_card $arg 0]
#         puts "$result"
#     }
# } else {
    mask_card $testlist 1
# }

# Before:
#             49927398716         .  49927398717        .
#             1234-5678                              1234 5670 .  "alke23451234"     .
#             1234-5678             1234 5670 .  "alke23451234"     .
#             1234567812345678    .  "alke2345123da4"   .
#
# After:
#             499273*8716         .  49927398717        .
#             1234-5678                              1234 5670 .  "alke23451234"     .
#             1234-5*********************5670 .  "alke23451234"     .
#             1234567812345678    .  "alke2345123da4"   .
