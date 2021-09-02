#!/usr/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: create_bmo_eft_file.tcl 4301 2017-08-23 19:00:18Z skumar $
# $Rev: 4301 $
################################################################################
#
# File Name:  create_bmo_eft_file.tcl
#
# Description:  This program generates an ACH file for BMO by 
#               institution.
#              
# Script Arguments:  ACH file name.
#
# Output:  BMO ACH files for debit and credit transactions.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

package require Oratcl 

#Environment variables
set clrdb $env(CLR4_DB)

#Global variables for file processing
global date_from
global locpath
global acq_entity_cursor
global acq_entity_cursor2
global acq_entity_contact_cursor
global acq_entity_address_cursor
global entity_to_auth_cursor
global oracle_logon_handle
global current_entity_id
global entity_id_list
global institution_id
global entity_contact_id
global entity_address_id
global acq_entity_result
global entity_to_auth_result
global acq_entity_address_result
global acq_entity_contact_result
global master_contact_result
global master_address_result
global output_file_name

global output_file_extension
global output_file_id
global loopcounter
global filelist
global fp
global file_data
global data
global tran_code_ch
global tran_code_sv
global tran_amt
global entity_id
global line_cnt
global dba
global tot_credit_cnt
global tot_credit_amt
global tot_debit_amt
global tot_debit_cnt
global julain_file_date
global julian_date_value
global inst_id
global payee_acct
global nextDrFileNbr
global nextCrFileNbr
global lastDrFileNbr
global lastCrFileNbr
global masclr_cursor
global oracle_logon_handle
global inst_id
global curr_cd
global originator_id_cr
global originator_id_dr
global dest_data_ctr
global tran_type_cr
global tran_type_dr
global orig_shrt_name
global orig_long_name
global inst_id_return
global acct_num_return
global output_fname_cr
global output_fname_dr
global curr_code_ca
global curr_code_us
global tran_code_ch
global tran_code_sv
 
global env

set line_cnt 0 
set tot_credit_amt 0 
set tot_credit_cnt 0 
set tot_debit_cnt 0 
set tot_debit_amt 0 

#################################################################
# procs
#################################################################

#################################################################
# Get next file creation number for debits andcredits
#################################################################
proc getNextFileNumber {} {

  global nextDrFileNbr
  global nextCrFileNbr
  global lastDrFileNbr
  global lastCrFileNbr
  global masclr_cursor
  global oracle_logon_handle
  global env    
  global gsc_tb
  global inst_to_run

  set nextDrFileNbr 0
  set nextCrFileNbr 0
  set lastCrFileNbr 0
  set lastDrFileNbr 0

  if {[catch {set oracle_logon_handle [oralogon masclr/masclr@$env(CLR4_DB)]} result]} {
    puts "Could not open database connections.  Result: $result"
    exit 1
  }

  set gsc_tb [oraopen $oracle_logon_handle]

  set query "SELECT seq_name, last_seq_nbr
          FROM seq_ctrl
          WHERE institution_id = '$inst_to_run' and seq_name in ('cr_file_create_nbr', 'dr_file_create_nbr') "

   orasql $gsc_tb $query

   while {[orafetch $gsc_tb -dataarray seq -indexbyname] != 1403} {
     switch -exact -- $seq(SEQ_NAME) {
      "cr_file_create_nbr" {
          set lastCrFileNbr $seq(LAST_SEQ_NBR)
      }
      "dr_file_create_nbr" {
          set lastDrFileNbr $seq(LAST_SEQ_NBR)
      }
    }
  }

  set nextCrFileNbr [ expr { $lastCrFileNbr + 1 } ] 
  set nextDrFileNbr [ expr { $lastDrFileNbr + 1 } ] 

  set query "update seq_ctrl
      set last_seq_nbr =
          case when seq_name = 'cr_file_create_nbr'
             then '$nextCrFileNbr'
          when seq_name = 'dr_file_create_nbr'
             then '$nextDrFileNbr'
          end
      where institution_id = '$inst_to_run' and seq_name in ('cr_file_create_nbr', 'dr_file_create_nbr') "

   orasql $gsc_tb $query
   if {[catch {orasql $gsc_tb $query} result]} {
      oraroll $gsc_tb
      puts "ERROR: Encoutered error while updating LAST_SEQ_NBR in SEQ_CTRL table for BMO"
      puts "ERROR REASON: $result"
      puts "The BMO file $inputFile will not be processd until this is resolved."
      puts "Once Resolved rerun the code"
      puts "ERROR QUERY - $query"
      exit 4
  }
  oracommit $oracle_logon_handle
}

 #################################################################
 # Credit Transactions - Detail Line 622 632
 #################################################################
proc get_bmo_eft_credit {} {
    #set s_curr [lindex $argv 0]
    global env
    #set locpath $env(MAS_OSITE_ROOT)
    #set locpath "$locpath/data/ach"
    #set locpath "/clearing/apps/mas/pdir/ositeroot/data/ach/" 
    set locpath $env(PWD) 
    global output_file_id
    global s_curr
    global tot_credit_cnt
    global tot_credit_amt
    global tot_debit_amt
    global tot_debit_cnt
    global hdr_rec
    global argv
    global nextDrFileNbr
    global nextCrFileNbr
    global lastDrFileNbr
    global lastCrFileNbr
    global inst_id
    global curr_cd
    global originator_id_cr
    global originator_id_dr
    global dest_data_ctr
    global tran_type_cr
    global tran_type_dr
    global orig_shrt_name
    global orig_long_name
    global inst_id_return
    global acct_num_return
    global output_fname_cr
    global output_fname_dr
    global curr_code_ca
    global curr_code_us
    global tran_code_ch
    global tran_code_sv
    global inst_to_run
    
    set tot_credit_amt 0 
    set tot_credit_cnt 0
    set tot_debit_amt 0
    set tot_debit_cnt 0

    set julian_file_date [expr [clock format [clock scan seconds] -format "%y%j"]]
    set julian_date_value [expr [clock format [clock scan seconds] -format "%y%j"]] 
    # set up the output file
    set temp_date [clock format [clock seconds] -format "_%Y%m%d%H%M"]
    
    #set output_file_name "/clearing/apps/mas/pdir/ositeroot/data/ach/DEFT-RPTCADCR-A_$temp_date"
    #set locpath $env(MAS_OSITE_ROOT)
    #set locpath "$locpath/data/ach"
    set locpath $env(PWD)
    set inst_dir "INST_$inst_to_run"
    set output_file_name "$locpath/$inst_dir/$output_fname_cr"
    append output_file_name "$temp_date"
    
    if {[catch {open $output_file_name {WRONLY CREAT EXCL} } output_file_id ]} {
        puts "Cannot open or create $output_file_name: $output_file_id"
        exit 1
    }
    #if {$curr_cd == "127"} {  
    #    set s_curr "CAD"
    #else
    #    set s_curr "USD"    
    #}
    set tran_code_ch "622"
    set tran_code_sv "632" 
    set line_cnt 0 
    set hdr_rec "520" 
    
    ################################################
    # Header Record                                 
    ################################################
    
    # 01 Record Type                                                        01 (Always "A")
    puts -nonewline $output_file_id "A" 
    
    # 02 Logical Record Count                                               02 - 10 (Always "1")    
    incr line_cnt 1
    set line_cnt [format %09i $line_cnt]
    puts -nonewline $output_file_id $line_cnt
    
    # 03 Assigned Originator ID                                             11 - 20
    puts -nonewline $output_file_id  $originator_id_cr
	
    # 04 File Creation #                                                    21 - 24
    puts -nonewline $output_file_id [format %04i $nextCrFileNbr]
	
    # 05 Julian File Create Date                                            25 - 30
    puts -nonewline $output_file_id "0"
    puts -nonewline $output_file_id $julian_date_value
    
    # 06 Destination Data Centre                                            31 - 35
    puts -nonewline $output_file_id $dest_data_ctr         
    
    # 07 Filler                                                             36 - 55
    puts -nonewline $output_file_id [string repeat " " 20]
    
    # 08 Currency Code                                                      56 - 58
    puts -nonewline $output_file_id $curr_cd         
    
    # 09 Filler                                                             59 - 1464
    puts $output_file_id [string repeat " " 1405]
    set locpath "" 
    # set locpath $env(MAS_OSITE_ROOT)
    # set locpath "$locpath/data/ach"
    set locpath $env(PWD) 
    set fileName [lindex $argv 1]
    set filelist "$locpath/$inst_dir/$fileName"
    puts "Inside get_bmo_eft_credit ACH file name : $fileName filelist:$filelist"
    set fp [open $filelist r]
    set file_data [read $fp]
    close $fp
    set data [split $file_data "\n"]
    foreach line $data {
        
        set var1 [string range $line 0 2]
        if { $var1 == $hdr_rec } {
          set var2 [string range $line 69 74]
          set eff_date [clock format [clock scan $var2] -format %y%j]
        }

       if { ($var1  == $tran_code_ch) || ($var1 == $tran_code_sv )} {
            # 01 Record Type                                                01 (Always "C")
            puts -nonewline $output_file_id "C" 
            
            # 02 Logical Record Count                                       02 - 10 (Always "1")    
            set line_cnt [string trimleft $line_cnt 0]
            incr line_cnt 1
            set line_cnt [format %09i $line_cnt]
            puts -nonewline $output_file_id $line_cnt
            
            # 03 Originator ID                                              11 - 24
            puts -nonewline $output_file_id  $originator_id_cr

            #03a File Creation Number
            puts -nonewline $output_file_id  [format %04i $nextCrFileNbr]
            
            # 04 Transaction Type                                           25 - 27
            puts -nonewline $output_file_id  $tran_type_cr
            
            # 05 Transaction Amount                                         28 -  37
            set tran_amt [string range $line 29 38]
            set tran_amt [string trimleft $tran_amt 0]
            incr tot_credit_amt $tran_amt
            incr tot_credit_cnt 1
            set tran_amt [format %010i $tran_amt]
            puts -nonewline $output_file_id $tran_amt
            puts -nonewline $output_file_id [string repeat " " [expr 10 - {[string length [string range $tran_amt 0 10]]}]]
            
            # 06 Julian Date Funds are Payable                              38 - 43
            puts -nonewline $output_file_id "0"
            puts -nonewline $output_file_id $eff_date
            
            # 07 Payee Institution ID                                       44 - 52
            set inst_id [string range $line 3 11]
            set inst_id [string trim $inst_id]
            if { [string length $inst_id] == 8 } {
                set inst_id "0$inst_id"
            } elseif { [string length $inst_id] != 9 } {
                # raise error and skip line
                # write to log file and send out email error message
                continue
            }
            puts -nonewline $output_file_id $inst_id

            
            # 08 Payee Account #                                            053 - 64
            set payee_acct [string range $line 12 23]
            set payee_acct [string trimleft $payee_acct]
            set payee_acct [format "%-12s" $payee_acct]
            puts -nonewline $output_file_id $payee_acct
            
            # 09 Zeroes                                                     065 - 89
            puts -nonewline $output_file_id [string repeat "0" 25]
            
            # 10 Originator Short Name                                      090 - 104
            set shrt_name [format "%-15s" $orig_shrt_name]
            puts -nonewline $output_file_id $shrt_name
            
            # 11 Drawee Name                                                105 - 134 
            set dba [string range $line 54 77]
            set dba [format "%-30s" $dba]
            puts -nonewline $output_file_id $dba
            
            # 12 Originator Long Name                                       135 - 164
            set lng_name $orig_long_name
            set lng_name [format "%-30s" $lng_name]
            puts -nonewline $output_file_id $lng_name
            
            # 13 Blanks                                                     165 - 174
            puts -nonewline $output_file_id [string repeat " " 10]
            
            # 14 Cross Reference # 		varchar 16	            175 - 193
            set entity_id [string range $line 39 53]
            puts -nonewline $output_file_id $entity_id
            puts -nonewline $output_file_id [string repeat " " [expr 19 - {[string length [string range $entity_id 0 19]]}]]
            
            # 15 Institution ID for Returns                                 194 - 202
            puts -nonewline $output_file_id $inst_id_return
            
            # 16 Account # for Returns                                      203 - 214
            puts -nonewline $output_file_id $acct_num_return    
            puts -nonewline $output_file_id [string repeat " " 5]
            
            # 17 Blanks                                                     215 - 253
            puts -nonewline $output_file_id [string repeat " " 39]
            
            # 18 Zeroes                                                     254 - 264
            puts -nonewline $output_file_id [string repeat "0" 11]
            
            # 19 Blanks                                                     265 - 1464
            puts $output_file_id [string repeat " " 1199]
            flush $output_file_id
            
     }
  }


    ################################################
    # Trailer Record                               
    ################################################
    
    # 01 Record Type                                                        01 (Always "Z")
    puts -nonewline $output_file_id "Z" 
    
    # 02 Logical Record Count                                               02 - 10 
    set line_cnt [string trimleft $line_cnt 0]
    incr line_cnt 1
    set line_cnt [format %09i $line_cnt]
    puts -nonewline $output_file_id $line_cnt
    
    # 03 Assigned Originator ID                                             11 - 20
    puts -nonewline $output_file_id  $originator_id_cr
	
    # 04 File Creation #                                                    21 - 24
    puts -nonewline $output_file_id [format %04i $nextCrFileNbr] 
	
    # 05 Total Value of Debit Transactions                                  25 - 38
    set tot_debit_amt [format %014i $tot_debit_amt] 
    puts -nonewline $output_file_id $tot_debit_amt
    
    # 06 Total Number of Debit Transactions                                 39 - 46
    set tot_debit_cnt [format %08i $tot_debit_cnt]
    puts -nonewline $output_file_id $tot_debit_cnt
    
    # 07 Total Value of Credit Transactions                                 47 - 60
    set tot_credit_amt [format %014i $tot_credit_amt] 
    puts -nonewline $output_file_id $tot_credit_amt
    
    # 08 Total Number of Credit                                             61 - 68
    set tot_credit_cnt [format %08i $tot_credit_cnt] 
    puts -nonewline $output_file_id $tot_credit_cnt
    
    # 09 Filler                                                             69 - 1464
    puts $output_file_id [string repeat " " 1395]
    flush $output_file_id
    
 }
 
 #################################################################
 # Debit Transactions - Detail Line 627
 #################################################################
proc get_bmo_eft_debit {} {
    global env
    #set locpath $env(MAS_OSITE_ROOT)
    #set locpath "$locpath/data/ach"
    #set locpath "/clearing/apps/mas/pdir/ositeroot/data/ach/" 
    set locpath $env(PWD)
    global output_file_id
    global s_curr
    global inst_id
    global drawee_acct
    global tot_debit_amt
    global tot_debit_cnt
    global tot_credit_amt
    global tot_credit_cnt
    global eff_date
    global eff_mon
    global eff_day
    global eff_yr
    global hdr_rec
    global argv
    global nextDrFileNbr
    global nextCrFileNbr
    global lastDrFileNbr
    global lastCrFileNbr
    global inst_id
    global curr_cd
    global originator_id_cr
    global originator_id_dr
    global dest_data_ctr
    global tran_type_cr
    global tran_type_dr
    global orig_shrt_name
    global orig_long_name
    global inst_id_return
    global acct_num_return
    global output_fname_cr
    global output_fname_dr
    global curr_code_ca
    global curr_code_us
    global tran_code_ch
    global tran_code_sv
    global inst_to_run
    
    set tot_debit_amt 0
    set tot_debit_cnt 0
    set tot_credit_amt 0
    set tot_credit_cnt 0
    set hdr_rec "520"
    set julian_file_date [expr [clock format [clock scan seconds] -format "%y%j"]]
    set julian_date_value [expr [clock format [clock scan seconds] -format "%y%j"]] 
    # set up the output file
    set temp_date [clock format [clock seconds] -format "_%Y%m%d%H%M"]
    
    #set output_file_name "/clearing/apps/mas/pdir/ositeroot/data/ach/DEFT-RPTCADDR-A_$temp_date"
    set locpath ""
    set locpath $env(PWD)
    set inst_dir "INST_$inst_to_run"
    set output_file_name "$locpath/$inst_dir/$output_fname_dr"
    append output_file_name "$temp_date"
    
    if {[catch {open $output_file_name {WRONLY CREAT EXCL} } output_file_id ]} {
        puts "Cannot open or create $output_file_name: $output_file_id"
        exit 1 
    }
    #    if {$curr_cd == "127"} {  
    #    set s_curr "CAD"
    #else
    #    set s_curr "USD"    
    #}
    set tran_code_ch "627"
    set tran_code_sv "637" 
    set line_cnt 0 
    set tot_debit_amt 0 
    set tot_debit_cnt 0

    ################################################
    # Header Record                               
    ################################################
    
    # 01 Record Type                                                        01 (Always "A")
    puts -nonewline $output_file_id "A" 
    
    # 02 Logical Record Count                                               02 - 10 (Always "1")    
    incr line_cnt 1
    set line_cnt [format %09i $line_cnt]
    puts -nonewline $output_file_id $line_cnt
    
    # 03 Assigned Originator ID                                             11 - 20
    puts -nonewline $output_file_id  $originator_id_dr
	
    # 04 File Creation #                                                    21 - 24
    puts -nonewline $output_file_id [format %04i $nextDrFileNbr] 
	
    # 05 Julian File Create Date                                            25 - 30
    puts -nonewline $output_file_id "0"
    puts -nonewline $output_file_id $julian_date_value
    
    # 06 Destination Data Centre                                            31 - 35
    puts -nonewline $output_file_id $dest_data_ctr
    
    # 07 Filler                                                             36 - 55
    puts -nonewline $output_file_id [string repeat " " 20]
    
    # 08 Currency Code                                                      56 - 58
    puts -nonewline $output_file_id $curr_cd
    
    # 09 Filler                                                             59 - 1464
    puts $output_file_id [string repeat " " 1405]
    set locpath ""
    #set locpath $env(MAS_OSITE_ROOT)
    #set locpath "$locpath/data/ach" 
    #set filelist [string trim $locpath/[lindex $argv 0]]
    set locpath $env(PWD)
    set fileName [lindex $argv 1]
    set filelist "$locpath/$inst_dir/$fileName"
    puts "Inside get_bmo_eft_debit ACH file name : $fileName filelist: $filelist"
    set fp [open $filelist r]
    set file_data [read $fp]
    close $fp
    set data [split $file_data "\n"]
    foreach line $data {
        
        set var1 [string range $line 0 2]
        if { $var1 == $hdr_rec } { 
          set var2 [string range $line 69 74]  
          set eff_date [clock format [clock scan $var2] -format %y%j]
        }

        if { ($var1  == $tran_code_ch) || ($var1 == $tran_code_sv ) } {
            # 01 Record Type                                                01 (Always "D")
            puts -nonewline $output_file_id "D" 
            
            # 02 Logical Record Count                                       02 - 10 (Always "1")    
            set line_cnt [string trimleft $line_cnt 0]
            incr line_cnt 1
            set line_cnt [format %09i $line_cnt]
            puts -nonewline $output_file_id $line_cnt
            
            # 03 Originator ID + File Creation Number                       11 - 24
            puts -nonewline $output_file_id  $originator_id_dr

            #03a File Creation Number
            puts -nonewline $output_file_id  [format %04i $nextDrFileNbr]
            
            # 04 Transaction Type                                           25 - 27
            puts -nonewline $output_file_id  $tran_type_dr
            
            # 05 Transaction Amount                                         28 -  37
            set tran_amt [string range $line 29 38]
            set tran_amt [string trimleft $tran_amt 0]
            incr tot_debit_amt $tran_amt
            incr tot_debit_cnt 1 
            set tran_amt [format %010i $tran_amt]
            puts -nonewline $output_file_id $tran_amt
            puts -nonewline $output_file_id [string repeat " " [expr 10 - {[string length [string range $tran_amt 0 10]]}]]
            
            # 06 Julian Date Funds are Withdrawn                           38 - 43
            puts -nonewline $output_file_id "0"
            puts -nonewline $output_file_id [string trim $eff_date]
            
            # 07 Drawee Institution ID                                     44 - 52
            set inst_id [string range $line 3 11]
            set inst_id [string trim $inst_id]
            if { [string length $inst_id] == 8 } {
                set inst_id "0$inst_id"
            } elseif { [string length $inst_id] != 9 } {
                # raise error and skip line
                # write to log file and send out email error message
                continue
            }
            puts -nonewline $output_file_id $inst_id
            
            # 08 Drawee Account #                                            053 - 64
            set drawee_acct [string range $line 12 23]
            set drawee_acct [string trimleft $drawee_acct]
            set drawee_acct [format "%-12s" $drawee_acct]
            puts -nonewline $output_file_id $drawee_acct
            
            # 09 Zeroes                                                     065 - 89
            puts -nonewline $output_file_id [string repeat "0" 25]
            
            # 10 Originator Short Name                                      090 - 104
            set sht_name [format "%-15s" $orig_shrt_name] 
            puts -nonewline $output_file_id $sht_name
            
            # 11 Drawee Name                                                105 - 134 
            set dba [string range $line 54 77]
            set dba [format "%-30s" $dba]
            puts -nonewline $output_file_id $dba
            
            # 12 Originator Long Name                                       135 - 164
            set lng_name [format "%-30s" $orig_long_name]
            puts -nonewline $output_file_id $lng_name
            
            # 13 Blanks                                                     165 - 174
            puts -nonewline $output_file_id [string repeat " " 10]
            
            # 14 Cross Reference # 		varchar 16			                175 - 193
            set entity_id [string range $line 39 53]
            puts -nonewline $output_file_id $entity_id
            puts -nonewline $output_file_id [string repeat " " [expr 19 - {[string length [string range $entity_id 0 19]]}]]
            
            # 15 Account # ID for Returns                                   194 - 202
            puts -nonewline $output_file_id $inst_id_return
            
            # 16 Account # for Returns                                      203 - 214
            puts -nonewline $output_file_id $acct_num_return    
            puts -nonewline $output_file_id [string repeat " " 5]
            
            # 17 Zeroes                                                     215 - 229
            puts -nonewline $output_file_id [string repeat "0" 15]
            
            # 18 Zeroes                                                     230 - 238
            puts -nonewline $output_file_id [string repeat "0" 9]
            
            # 19 Zeroes                                                     239 - 247
            puts -nonewline $output_file_id [string repeat "0" 9]
            
            # 20 Blanks                                                     248 - 250
            puts -nonewline $output_file_id [string repeat " " 3]
            
            # 21 Blanks                                                     251 - 253
            puts -nonewline $output_file_id [string repeat " " 3]
            
            # 22 Zeroes                                                     254 - 264
            puts -nonewline $output_file_id [string repeat "0" 11]
            
            # 23 Blanks                                                     265 - 1464
            puts $output_file_id [string repeat " " 1199]
            flush $output_file_id
            
     }
  }


    ################################################
    # Trailer Record                               
    ################################################
    
    # 01 Record Type                                                        01 (Always "Z")
    puts -nonewline $output_file_id "Z" 
    
    # 02 Logical Record Count                                               02 - 10 
    set line_cnt [string trimleft $line_cnt 0]
    incr line_cnt 1
    set line_cnt [format %09i $line_cnt]
    puts -nonewline $output_file_id $line_cnt
    
    # 03 Assigned Originator ID                                             11 - 20
    puts -nonewline $output_file_id  $originator_id_dr
	
    # 04 File Creation #                                                    21 - 24
    puts -nonewline $output_file_id [format %04i $nextDrFileNbr]
	
    # 05 Total Value of Debit Transactions                                  25 - 38
    set tot_debit_amt [format %014i $tot_debit_amt]
    puts -nonewline $output_file_id $tot_debit_amt
    
    # 06 Total Number of Debit Transactions                                 39 - 46
    set tot_debit_cnt [format %08i $tot_debit_cnt]
    puts -nonewline $output_file_id $tot_debit_cnt
 
    #  07 Total Value of Credit Transactions                                 47 - 60
    set tot_credit_amt [format %014i $tot_credit_amt] 
    puts -nonewline $output_file_id $tot_credit_amt
 
    # 08 Total Number of Credit                                             61 - 68
    set tot_credit_cnt [format %08i $tot_credit_cnt] 
    puts -nonewline $output_file_id $tot_credit_cnt
    
    # 09 Filler                                                             69 - 1464
    puts $output_file_id [string repeat " " 1395]
    flush $output_file_id
 }

###########################
#  MAIN
###########################

global inst_id
global curr_cd
global originator_id_cr
global originator_id_dr
global dest_data_ctr
global tran_type_cr
global tran_type_dr
global orig_shrt_name
global orig_long_name
global inst_id_return
global acct_num_return
global output_fname_cr
global output_fname_dr
global curr_code_ca
global curr_code_us
global tran_code_ch
global tran_code_sv
global inst_to_run MODE
global nextDrFileNbr
global nextCrFileNbr
global lastDrFileNbr
global lastCrFileNbr


set cfg_file_name "bmo.cfg" 

set logdate [clock seconds]
set logdate [clock format $logdate -format "%m-%d-%Yd %H:%M"]

if {[catch {open $cfg_file_name r} file_ptr]} {
  puts " *** File Open Err: Cannot open config file $cfg_file_name"
  exit 1
}
set inst_to_run [lindex $argv 0]
set MODE [lindex $argv 2]
puts "Inside create_bmo_eft_file Inst id : $inst_to_run MODE : $MODE"
set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
# ####################################################################
#  (01) inst_id              129,130,132,133,134                     #
#  (03) curr_cd              124                                     #
#  (04) originator_id_cr     B2BCADCR00                              #
#  (05) originator_id_dr     B2BCADCR00                              #
#  (06) dest_data_ctr        00100                                   #
#  (07) tran_type_cr         460                                     #
#  (08) tran_type_dr         470                                     #
#  (09) orig_shrt_name       PTC - B2B Paymt                         #
#  (10) orig_long_name       People's Trust - B2B Payments           #
#  (11) inst_id_return       00100040                                #
#  (12) acct_num_return      1902473                                 #
#  (13) output_fname_cr      DEFT_RPTCADCR-A_timedate                #
#  (14) output_fname_dr      DEFT_RPTCADDR-A_timedate                #
# ####################################################################

while {$cur_line != ""} {
  if {[string toupper [string trim  [lindex $cur_line 0]]] == $inst_to_run } {
     set curr_cd [lindex $cur_line 1]
     set originator_id_cr [lindex $cur_line 2]
     set originator_id_dr [lindex $cur_line 3]
     set dest_data_ctr [lindex $cur_line 4]
     set tran_type_cr [lindex $cur_line 5]
     set tran_type_dr [lindex $cur_line 6]
     set orig_shrt_name [lindex $cur_line 7]
     set orig_long_name [lindex $cur_line 8]
     set inst_id_return [lindex $cur_line 9]
     set acct_num_return [lindex $cur_line 10]
     set output_fname_cr [lindex $cur_line 11]
     set output_fname_dr [lindex $cur_line 12]
  }
  set cur_line  [split [set orig_line [gets $file_ptr] ] ~]
};

if { $MODE == "TEST"} {
    set nextDrFileNbr 0
    set nextCrFileNbr 0
    set lastCrFileNbr 0
    set lastDrFileNbr 0
} else {
    getNextFileNumber
};

get_bmo_eft_credit 
get_bmo_eft_debit
