#!/usr/bin/env tclsh

package require Oratcl

#$Id: eom_vol_ecomm_105.tcl 1880 2012-11-06 17:30:41Z ajohn $

set clrdb $env(SEC_DB) 
set authdb $env(TSP4_DB)

proc arg_parse {} {
    global argv institutions_arg date_arg

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }

    #scan for Institution
    # ONLY ONE INSTITUTION IS EXPECTED HERE..
    #set institutions_arg ""
    #set numInst 0
    #set numInst [regexp -- {-[iI][ ]+([0-9]{3})} $argv]
    
    #if { $numInst > 0 } {
    #
    #     set res_lst [regexp -inline -- {-[iI][ ]+([0-9]{3})} $argv]
    #     
    #     for {set x 0} {$x<$numInst} {incr x} {
    #         set institutions_arg "$institutions_arg [lrange $res_lst [expr ($x * 2) + 1] [expr ($x * 2) + 1]]"
    #     }
    #    
    #    set institutions_arg [string trim $institutions_arg]
    #    puts "Institutions: $institutions_arg"
    #}
}

proc init_dates {val} {
    global date today date_my next_mnth_my prev_mnth_my filedate date_auth_start date_auth_end
    set date            [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]] 
    set date_my            [string toupper [clock format [clock scan " $date -0 day"] -format %b-%Y]]     ;# MAR-2012
    set next_mnth_my    [string toupper [clock format [clock scan "01-$date_my +1 month"] -format %b-%Y]]     ;# APR-2012
    set prev_mnth_my    [string toupper [clock format [clock scan "01-$date_my -1 month"] -format %b-%Y]]     ;# FEB-2012
    
    set date_auth_start    [clock format [clock scan "01-$date_my -0 day"] -format %Y%m%d%H%M%S]     ;# 20120809204501
    set date_auth_end    [clock format [clock scan "01-$date_my +1 month"] -format %Y%m%d%H%M%S]     ;# 20120809204501
    
    set filedate         [clock format   [clock scan " $date -0 day"] -format %Y%m]
    set today            [string toupper [clock format [clock seconds] -format %d-%b-%Y]]
}

proc mailsend { email_subject email_recipient email_sender email_body } {
    set temp_value ""
    regsub -all "\:" $email_body "\072" temp_value
    
    exec echo "$temp_value" | mailx -r $email_sender -s "$email_subject" $email_recipient
    #exec echo "$temp_value" |  mail -s "$email_subject" $email_recipient -- -r "$email_sender"
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
  mailsend "$argv0 failed to run" $mailto_error $mailfromlist "$argv0 failed to run\n$result" 
  exit
}

if {[catch {set handleA [oralogon teihost/quikdraw@$authdb]} resultauth ]} {
  mailsend "$argv0 failed to run" $mailto_error $mailfromlist "$argv0 failed to run\n$result"
  exit
}

set cursor_C [oraopen $handleC]
set cursor_A [oraopen $handleA]

proc do_report {inst} {
    global cursor_C cursor_A date_my next_mnth_my filedate today date_auth_start date_auth_end

    ##
    # Get frontend mids needed later for all auth queries
    ###
    set ent_to_auth_qry "select institution_id, entity_id, mid
                    from entity_to_auth 
                    where institution_id in ('$inst')
                    order by entity_id"

    set mids(0) ""

    set mid_lst_indx 0
    set cur_indx_in_lst 0

    orasql $cursor_C $ent_to_auth_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        lappend mids($mid_lst_indx) $row(MID)
    
        #We limit the count of mids per var below 1000
        #Oracle complains if the <where foo in ('1','2'...)
        #contains more than 1000 elements>
        if {$cur_indx_in_lst >= 999} {
    
            incr mid_lst_indx
            set cur_indx_in_lst 0
        } else {
            incr cur_indx_in_lst
        }
    }
    
    
    set TOT_AMT        0
    set TOT_CNT        0
    
    ##
    ##############AUTH #################
    # Run queries for each set of MIDs 
    # *less than 1000 mids per set*
    ###
    for {set i 0} {$i <= $mid_lst_indx} {incr i} {

        set mid_sql_lst ""
        foreach x $mids($i) {
            set mid_sql_lst "$mid_sql_lst, '$x'"
        }

        set mid_sql_lst [string trim $mid_sql_lst {,}]
        
        set ecomm_qry "select mer.long_name as NAME, mer.visa_id as MID, 
                    sum(case when(tei.request_type in ('0200','0220','0250') ) then tei.amount 
                            when(tei.request_type in ('0420')) then -1*tei.amount else 0 end ) as AMOUNT, count(1) CNT
                    from teihost.tranhistory tei, teihost.merchant mer 
                    where tei.shipdatetime >= '$date_auth_start' and tei.shipdatetime < '$date_auth_end' 
                    and tei.mid = mer.mid 
                    and tei.mid in ($mid_sql_lst) 
                    and tei.card_type = 'VS' 
                    and tei.transaction_type = 'I' 
                    and tei.request_type in ('0200','0220','0250', '0420') 
                    group by mer.long_name, mer.visa_id
                    order by mer.visa_id"
                    
        
        orasql $cursor_A $ecomm_qry
        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
        
            lappend DETAILED_RECS "$row(NAME),$row(MID),$row(AMOUNT),$row(CNT)"
            set TOT_AMT        [expr $TOT_AMT + $row(AMOUNT)]
            set TOT_CNT        [expr $TOT_CNT + $row(CNT)]
        }
        
    }
    
    set filename "EOM.Volume.ecomm.$filedate.$inst.csv"
    set cur_file [open "$filename" w]

    
    puts $cur_file "END OF MONTH E-Commerce Sales\n\n\n"
    puts $cur_file "Generated: $today\n\n"
    puts $cur_file "Merchant Name,MID,Amount,Count\n"
    
    
    foreach recrow $DETAILED_RECS {
        puts $cur_file $recrow
    }
    
    puts $cur_file "Total,,$TOT_AMT,$TOT_CNT\n"
    close $cur_file
    
    exec echo "See attached file." | mutt -a $filename -s "$filename" -- "accounting@jetpay.com, reports-clearing@jetpay.com"

}




arg_parse

if {![info exists date_arg]} {
    #Runs previous month if no date arg is given
    init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]
} else {
    init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

set institutions_arg 105

if {$institutions_arg != ""} {
    puts "Running $argv0 for $institutions_arg $date_my"
    do_report $institutions_arg
} else {
    puts "Institution required.\nUsage: $argv0 -I nnn \[-D yyyymmdd\]"
}

oraclose $cursor_C
oraclose $cursor_A
oralogoff $handleC
oralogoff $handleA



