#!/usr/bin/env tclsh
#
# $Id: seek-encrypt-ach-file.tcl 4242 2017-07-25 14:08:04Z lmendis $
# $Log: encrypt-file.tcl,v $
# Revision 1.2  2003/08/12 21:13:35  gscogin
# fixed a bug when the .sent file already exists -- ges
#
# Revision 1.1  2003/07/08 15:43:20  gscogin
# Initial check in.  Encrypts a file using gpg.  Original written by jcloud
#
# Revision 1.2  2006/05/02 09:48:20 rkhan
# modifiled to work for one customer.

set customer "Clearing.JetPayTX@ncr.com"
set infile ""
set pth ""
set x ""
set box "PD"


#Institution Profile Information-------------------------------------------------
                set inst_name [open "../inst_profile.cfg" "r+"]
                set line [split [set orig_line [gets $inst_name] ] ,]
                set inst_id [string trim [lindex $line 0]]
                set vbin [string trim [lindex $line 1]]
                set mbin [string trim [lindex $line 2]]
                set ica [string trim [lindex $line 3]]
                set cib [string trim [lindex $line 4]]
                set edpt [string trim [lindex $line 5]]
                puts "$inst_id $vbin $mbin $ica $cib $edpt"



if {$argc == 1} {
set infile [lindex $argv 0]
#set outfile [lindex $argv 1]
#set customer [lindex $argv 2]
set outfile "$box-$infile.gpg"

if {[file exists $infile]} {
    exec sum $infile >> ach_chk_sum.log
    if {[file exists $outfile]} {
        set outfile $outfile.[clock format [clock seconds] -format "%Y%m%d"]
    }
    set dummy [exec gpg --output $outfile --encrypt --recipient $customer $infile]
    if {[llength $dummy]} {
        puts "Failed to encrypt response file $infile"
    }
    if {$dummy == ""} {
        exec rm $infile
    }
}



} else {

catch {set x [exec find . -name $inst_id.ACH*]} result

if {$x == ""} {
        exec echo "$env(PWD) \nNO FILES FOUND" | mailx -r Clearing.JetPayTX@ncr.com -s "No files found to encrypt" Clearing.JetPayTX@ncr.com
#        exit 1
}
set i 0
foreach file $x {
set infile [string range [lindex $x $i] 2 end]
set outfile "en-$box-$infile.gpg"
puts "$infile :: $outfile :: $customer"
set fsize [file size $infile]
if {$fsize != 0} {
if {[file exists $infile]} {
    exec sum $infile >> ach_chk_sum.log
    if {[file exists $outfile]} {
    set outfile $outfile.[clock format [clock seconds] -format "%Y%m%d"]
    }
    set dummy [exec gpg --output $outfile --encrypt --recipient $customer $infile]
    if {[llength $dummy]} {
    puts "Failed to encrypt response file $infile"
    }
    if {$dummy == ""} {
    exec rm $infile
    }
}
}
set i [expr $i + 1]
}

catch {set x [exec find . -name sent-107-ACH*]} result

if {$x == ""} {
        exec echo "$env(PWD) \nNO FILES FOUND" | mailx -r Clearing.JetPayTX@ncr.com -s "No files found to encrypt" Clearing.JetPayTX@ncr.com
#        exit 1
}
set i 0
foreach file $x {
set infile [string range [lindex $x $i] 2 end]
set outfile "en-$box-$infile.gpg"
puts "$infile :: $outfile :: $customer"
set fsize [file size $infile]
if {$fsize != 0} {
if {[file exists $infile]} {
        exec sum $infile >> ach_chk_sum.log
    if {[file exists $outfile]} {
        set outfile $outfile.[clock format [clock seconds] -format "%Y%m%d"]
    }
    set dummy [exec gpg --output $outfile --encrypt --recipient $customer $infile]
    if {[llength $dummy]} {
        puts "Failed to encrypt response file $infile"
    }
    if {$dummy == ""} {
        exec rm $infile
    }
}
}
set i [expr $i + 1]
}

}
