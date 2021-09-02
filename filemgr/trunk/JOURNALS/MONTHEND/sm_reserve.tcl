#!/usr/bin/env tclsh

package require Oratcl

#$Id: sm_reserve.tcl 1887 2012-11-08 19:19:40Z ajohn $

#set clrdb $env(SEC_DB) 
# set clrdb trnclr1
set clrdb $env(IST_DB) 
set mailto_error "clearing@jetpay.com"


proc arg_parse {} {
    global argv institutions_arg date_arg

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }

    #scan for Institution
    # ONLY ONE INSTITUTION IS EXPECTED HERE..
    set institutions_arg ""
    set numInst 0
    set numInst [regexp -- {-[iI][ ]+([0-9]{3})} $argv]
    
    if { $numInst > 0 } {
    
         set res_lst [regexp -inline -- {-[iI][ ]+([0-9]{3})} $argv]
         
         for {set x 0} {$x<$numInst} {incr x} {
             set institutions_arg "$institutions_arg [lrange $res_lst [expr ($x * 2) + 1] [expr ($x * 2) + 1]]"
         }
        
        set institutions_arg [string trim $institutions_arg]
        puts "Institutions: $institutions_arg"
    }
}


proc init_dates {val} {
    global date date_my filedate today next_mnth_my
    set date    [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]] 
    set date_my     [string toupper [clock format [clock scan " $date -0 day"] -format %b-%Y]]     ;# MAR-2012
    set next_mnth_my     [string toupper [clock format [clock scan "01-$date_my +1 month"] -format %b-%Y]]     ;# APR-2012
    set filedate  [clock format   [clock scan " $date -0 day"] -format %Y%m]                     ;# 20080321
    set today     [string toupper [clock format [clock scan " $date +0 day"] -format %d-%b-%Y]]
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
    exec echo "iso_billing.tcl failed to run\n$result" | mutt -s "$argv0 failed to run" -- $mailto_error 
    exit
}

set cursor_C  [oraopen $handleC]

proc do_report { institutions_arg } {
    global cursor_C
    global date_my filedate today next_mnth_my
    
    set sql_inst ""
    
    foreach inst $institutions_arg {
        set sql_inst "$sql_inst '$inst',"
    }
    
    set sql_inst [string trim $sql_inst {, }]
    
    set entity_qry    "select Entity_id, Entity_dba_Name
                        from MASCLR.acq_entity
                        where institution_id in ($sql_inst)
                        order by entity_id"
    
    orasql $cursor_C $entity_qry
    
    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        set entity_info($row(ENTITY_ID).DBA) $row(ENTITY_DBA_NAME)
    }
    
    set qry "select entity_id, payment_proc_dt, action, AMT from
            (
                select mtl.entity_id, aad.payment_proc_dt, 'ADD' action, sum(mtl.AMT_ORIGINAL) AMT
                from mas_trans_log mtl, (select institution_id, payment_seq_nbr, payment_status, payment_proc_dt
                                        from acct_accum_det 
                                        where payment_status = 'P'
                                        and payment_proc_dt >= '01-$date_my' and payment_proc_dt < '01-$next_mnth_my') aad
                where (mtl.institution_id = aad.institution_id and mtl.payment_seq_nbr = aad.payment_seq_nbr)
                and mtl.tid in ('010005050000')
                and mtl.institution_id in ($sql_inst)
                group by mtl.entity_id, aad.payment_proc_dt
            )
            union all
            (
                select mtl.entity_id, aad.payment_proc_dt, 'RELEASE' action, sum(-1*mtl.AMT_ORIGINAL) AMT
                from mas_trans_log mtl, (select institution_id, payment_seq_nbr, payment_status, payment_proc_dt
                                        from acct_accum_det 
                                        where (institution_id, entity_acct_id) in (select institution_id, entity_acct_id
                                                                                    from entity_acct
                                                                                    where institution_id in ($sql_inst)
                                                                                    and acct_posting_type = 'R')
                                        and payment_status = 'P'
                                        and payment_proc_dt >= '01-$date_my' and payment_proc_dt < '01-$next_mnth_my') aad
                where (mtl.institution_id = aad.institution_id and mtl.payment_seq_nbr = aad.payment_seq_nbr)
                and mtl.tid in ('010007050000', '010007050100')
                and mtl.institution_id in ($sql_inst)
                group by mtl.entity_id, aad.payment_proc_dt
            )
            order by entity_id, payment_proc_dt"
    
    orasql $cursor_C $qry
    
    set TOTAL_ADDED        0
    set TOTAL_RELEASED    0
    set data_dict [dict create]
    
    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        
        set ent $row(ENTITY_ID)
        
        if {![dict exists $data_dict $ent]} {
            dict set data_dict $ent DETAIL ""
            dict set data_dict $ent NET 0
            dict set data_dict $ent ADD 0
            dict set data_dict $ent REL 0
        }


        if {$row(ACTION) == "ADD"} {
            set TOTAL_ADDED [expr $TOTAL_ADDED + $row(AMT)]
        } else {
            set TOTAL_RELEASED [expr $TOTAL_RELEASED + $row(AMT)]
        }

        
        dict with data_dict $ent {
            set DETAIL "${DETAIL}\n$row(PAYMENT_PROC_DT),$row(ACTION),$row(AMT)"
            set NET        [expr $NET + $row(AMT)]
        
            if {$row(ACTION) == "ADD"} {
                set ADD            [expr $ADD + $row(AMT)]
            } else {
                set REL     [expr $REL + $row(AMT)]
            }
        }
    }
    
    set filename "monthly.reserve.activity.$date_my.$institutions_arg.csv"
    set cur_file [open "$filename" w]
    
    dict for {ent data} $data_dict {
        if {[info exists entity_info($ent.DBA)] } {
            puts $cur_file "\n$ent,$entity_info($ent.DBA)\n"
        } else {
            #This should never be the case but hey...
            puts $cur_file "\n$ent,\n"
        }
        
        puts $cur_file "Date,Activity,Amount"
        puts $cur_file "---------,---------,---------"
        dict with data {
            puts $cur_file "$DETAIL"
            puts $cur_file "---------,---------,---------"
            puts $cur_file "Added,$ADD"
            puts $cur_file "Released,$REL"
            puts $cur_file "Net,$NET\n\n"
        }
    }
    
    puts $cur_file "\n\n---------,---------"
    puts $cur_file "SUB TOTALS"
    puts $cur_file "---------,---------"
    puts $cur_file "Added,$TOTAL_ADDED"
    puts $cur_file "Released,$TOTAL_RELEASED"
    puts $cur_file "Net,[expr $TOTAL_ADDED + $TOTAL_RELEASED]"
    puts $cur_file "---------,---------"
    
    close $cur_file
    
    exec echo "Please see attached." | mutt -a $filename -s "$filename" -- "accounting@jetpay.com,reports-clearing@jetpay.com"

}


##
# Main
###

arg_parse

if {![info exists date_arg]} {
    init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]
} else {
    init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

if {$institutions_arg != ""} {
    do_report $institutions_arg
} else {
    puts "Institution required.\nUsage: $argv0 -I nnn \[-D yyyymmdd\]"
}


oraclose $cursor_C
oralogoff $handleC


