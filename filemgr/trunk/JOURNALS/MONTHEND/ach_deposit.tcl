#!/usr/bin/env tclsh

# $Id: ach_deposit.tcl 2254 2013-03-27 16:06:51Z mitra $

###
# ACH Deposits Monthly Report
# This script needs the date that the ach was done as an argument with format:  -d yyyymmdd
# If more than one date is entered, the report will calculate the total for all dates. 
###

package require Oratcl


set clrdb $env(SEC_DB) 


proc arg_parse {} {
    global argv dt_args

puts "Parsing arguments"
    #scan for Date

        #We can read multiple date arguments <-d 20120824 -d 20120827>
    set numDTs [regexp -all -- {-[dD][ ]+([0-9]{8,8})} $argv]

    if { $numDTs > 0 } {
        set res_lst [regexp -all -inline -- {-[dD][ ]+([0-9]{8,8})} $argv]
        set dt_args ""
        
        foreach {fullmatch dt} $res_lst {
            set dt_args "$dt_args $dt"
        }

        set dt_args [string trim $dt_args]
        puts "dates: $dt_args"
    }
}

proc init_date {dt_lst} {
    global sql_date month_year
    
    
    foreach dt $dt_lst {
        
        #The yearmonth used for the filename will be based on the last date argument
        set month_year $dt
        
        set dt_start [string toupper [clock format [clock scan "$dt" -format %Y%m%d] -format %d-%b-%Y]]
        set dt_end [string toupper [clock format [clock scan "$dt_start +1 day"] -format %d-%b-%Y]]
        
        if {![info exists sql_date]} {
            set sql_date "(aad.payment_proc_dt >= '$dt_start' and aad.payment_proc_dt < '$dt_end')\n"
        } else {
            set sql_date "$sql_date OR (aad.payment_proc_dt >= '$dt_start' and aad.payment_proc_dt < '$dt_end')\n"
        }
        
    }
    
    if {[info exists sql_date]} {
        set sql_date "($sql_date)"
    }
    
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
    puts "$argv0 failed to run\n$result"
    #mailsend "$argv0 failed to run" $mailto_error $mailfromlist "$argv0 failed to run\n$result" 
    exit
}

set cursor_C    [oraopen $handleC]

proc do_report {} {
    global cursor_C
    global sql_date
    global month_year
    
    set qry "SELECT m.entity_id, acq.entity_dba_name, acq.entity_name,
                 SUM(CASE WHEN (m.tid ='010070010010') Then NBR_OF_ITEMS else 0 end ) AS ACH_COUNT,
                 SUM(CASE WHEN (m.tid ='010070010010') Then m.amt_original else 0 end ) AS ACH_AMOUNT,
                 SUM(CASE WHEN (m.tid in ('010004280000', '010004280008')) Then m.amt_original else 0 end ) ACH_FEE,
                 SUM(CASE WHEN (m.tid = '010070010011') Then NBR_OF_ITEMS else 0 end ) AS ACH_RETURN_COUNT,
                 SUM(CASE WHEN (m.tid = '010070010011') Then amt_original else 0 end ) AS ACH_RETURN_AMOUNT,
                 SUM(CASE WHEN (m.tid = '010004280001') Then m.amt_original else 0 end ) ACH_RETURN_FEE,
                 SUM(CASE WHEN (m.tid = '010004280004' and mas_code = '00ACHMONMIN') Then m.amt_original else 0 end ) \
                     AS ACH_MONTHLY_MINIMUM_FEE,
                 SUM(CASE WHEN (m.tid = '010004280004' and mas_code = '00ACHANNFEE') Then m.amt_original else 0 end ) \
                     AS ACH_ANNUAL_FEE,
                 SUM(CASE WHEN (m.tid = '010004280006') Then m.amt_original else 0 end ) \
                     AS ACH_MONTHLY_MAINTAIN_FEE,
                 SUM(CASE WHEN (m.tid in ('010004280015','010004280005','010004350005','010004240000','010004280009',\
                                          '010004350000','010004190000')) 
                          THEN decode(m.tid_settl_method,'D',1,-1) * m.amt_original else 0 end ) ADJUSTMENT_ON_FEE
            FROM masclr.mas_trans_log m 
            join masclr.ACCT_ACCUM_DET aad on (m.payment_seq_nbr = aad.payment_seq_nbr 
                 and m.institution_id = aad.institution_id)
            join acq_entity acq on (m.institution_id = acq.institution_id and m.entity_id = acq.entity_id)
            WHERE $sql_date
                   and (SUBSTR(m.tid,1,11) = '01007001001' or SUBSTR(m.tid,1,6) = '010004')
                   and aad.payment_status = 'P'
                   and aad.payment_cycle = '2'
            group by m.entity_id, acq.entity_dba_name, acq.entity_name
            order by m.entity_id"

    orasql $cursor_C $qry

    
    set rpt "MERCHANT ID,MERCHANT DBA NAME,MERCHANT NAME,ACH COUNT,ACH AMOUNT,ACH FEE,ACH RETURN COUNT,"
    set rpt "${rpt}ACH RETURN AMOUNT,ACH RETURN FEE,ACH MONTHLY MINIMUM FEE,ACH ANNUAL FEE,"
    set rpt "${rpt}ACH MONTHLY MAINTAIN FEE,ADJUSTMENT ON FEE,TOTAL FEE\n"

    set totals(ACH_COUNT) 0
    set totals(ACH_AMOUNT) 0
    set totals(ACH_FEE) 0
    set totals(ACH_RETURN_COUNT) 0
    set totals(ACH_RETURN_AMOUNT) 0
    set totals(ACH_RETURN_FEE) 0
    set totals(ACH_MONTHLY_MINIMUM_FEE) 0
    set totals(ACH_ANNUAL_FEE) 0 
    set totals(ACH_MONTHLY_MAINTAIN_FEE) 0
    set totals(ADJUSTMENT_ON_FEE) 0
    set totals(TOTAL_FEE) 0
    
    
    while { [orafetch $cursor_C -dataarray row -indexbyname] != 1403 } {
    
        ##
        # Add current line to report output
        ###
        set E_DBA_NAME [string map {, " "} $row(ENTITY_DBA_NAME)]
        set E_NAME [string map {, " "} $row(ENTITY_NAME)]
       

        set TOTAL_FEE [expr $row(ACH_FEE) \
                        + $row(ACH_RETURN_FEE) \
                        + $row(ACH_MONTHLY_MINIMUM_FEE) \
                        + $row(ACH_ANNUAL_FEE) \
                        + $row(ACH_MONTHLY_MAINTAIN_FEE) \
                        + $row(ADJUSTMENT_ON_FEE)]
 
        set rpt "$rpt$row(ENTITY_ID),$E_DBA_NAME,$E_NAME,$row(ACH_COUNT),$row(ACH_AMOUNT),"
        set rpt "$rpt$row(ACH_FEE),$row(ACH_RETURN_COUNT),$row(ACH_RETURN_AMOUNT),$row(ACH_RETURN_FEE),"
        set rpt "$rpt$row(ACH_MONTHLY_MINIMUM_FEE),$row(ACH_ANNUAL_FEE),$row(ACH_MONTHLY_MAINTAIN_FEE),$row(ADJUSTMENT_ON_FEE),$TOTAL_FEE\n"
        ###
        
        set totals(ACH_COUNT) [expr $totals(ACH_COUNT) + $row(ACH_COUNT)]
        set totals(ACH_AMOUNT) [expr $totals(ACH_AMOUNT) + $row(ACH_AMOUNT)]
        set totals(ACH_FEE) [expr $totals(ACH_FEE) + $row(ACH_FEE)]
        set totals(ACH_RETURN_COUNT) [expr $totals(ACH_RETURN_COUNT) + $row(ACH_RETURN_COUNT)]
        set totals(ACH_RETURN_AMOUNT) [expr $totals(ACH_RETURN_AMOUNT) + $row(ACH_RETURN_AMOUNT)]
        set totals(ACH_RETURN_FEE) [expr $totals(ACH_RETURN_FEE) + $row(ACH_RETURN_FEE)]
        set totals(ACH_MONTHLY_MINIMUM_FEE) [expr $totals(ACH_MONTHLY_MINIMUM_FEE) + $row(ACH_MONTHLY_MINIMUM_FEE)]
        set totals(ACH_ANNUAL_FEE) [expr $totals(ACH_ANNUAL_FEE) + $row(ACH_ANNUAL_FEE)]
        set totals(ACH_MONTHLY_MAINTAIN_FEE) [expr $totals(ACH_MONTHLY_MAINTAIN_FEE) + $row(ACH_MONTHLY_MAINTAIN_FEE)]
        set totals(ADJUSTMENT_ON_FEE) [expr $totals(ADJUSTMENT_ON_FEE) + $row(ADJUSTMENT_ON_FEE)]
        set totals(TOTAL_FEE) [expr $totals(TOTAL_FEE) + $TOTAL_FEE]
    

    }
    set rpt "${rpt}TOTALS:,,,$totals(ACH_COUNT),$totals(ACH_AMOUNT),$totals(ACH_FEE),$totals(ACH_RETURN_COUNT),$totals(ACH_RETURN_AMOUNT),"
    set rpt "$rpt$totals(ACH_RETURN_FEE),$totals(ACH_MONTHLY_MINIMUM_FEE),$totals(ACH_ANNUAL_FEE),$totals(ACH_MONTHLY_MAINTAIN_FEE),$totals(ADJUSTMENT_ON_FEE),$totals(TOTAL_FEE)\n"
    
    set file_name "ach_deposit.$month_year.csv"
    set fl [open $file_name w]
    
    puts $fl $rpt
    
    close $fl
    
    exec echo "Please see attached." | mutt -a "$file_name" -s "$file_name" -- "accounting@jetpay.com,reports-clearing@jetpay.com" 
    exec mv $file_name ./ARCHIVE
}

##
# MAIN
###

arg_parse

if {[info exists dt_args]} {
    init_date $dt_args
} else {
    puts "USAGE $argv0 -d yyyymmdd ?\[-d yyyymmdd\]..."
    exit 1
}

do_report

oraclose $cursor_C
oralogoff $handleC
