#!/usr/bin/env tclsh

#$Id: entity_reserve_summary.tcl 2031 2013-01-23 22:48:13Z ajohn $

#Usage: $argv0 -E <15 digit eid> \[-E <15 digit eid>\]... \[-start yyyymmdd -end yyyymmdd\]

package require Oratcl

# set clrdb trnclr4
set clrdb $env(CLR4_DB)
set mailfromlist "ajohn@jetpay.com"
set mailto_error "ajohn@jetpay.com"

proc arg_parse {} {
    global argv entity_arg start_date_arg end_date_arg

    #scan for Date
    if { [regexp -- {(-start)[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Start date argument: $arg_date"
        set start_date_arg $arg_date
    }

    if { [regexp -- {(-end)[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "End date argument: $arg_date"
        set end_date_arg $arg_date
    }

    #scan for entity ID
    set entity_arg ""
    set numEnt 0
    
    #We can read multiple entity arguments <-e xxxxx1 -e xxxxx2>
    set numEnt [regexp -all -- {-[eE][ ]+([0-9]{15})} $argv]

    if { $numEnt > 0 } {
        set res_lst [regexp -all -inline -- {-[eE][ ]+([0-9]{15})} $argv]
        
        foreach {fullmatch eid} $res_lst {
            set entity_arg "$entity_arg $eid"
        }

        set entity_arg [string trim $entity_arg]
        puts "Entities: $entity_arg"
    }
}


proc init_dates {start_date_arg end_date_arg} {
    global sdate edate filedate today complete_history
    set sdate   [string toupper [clock format [clock scan "$start_date_arg"] -format %d-%b-%Y]] 
    set edate   [string toupper [clock format [clock scan "$end_date_arg"] -format %d-%b-%Y]] 

    if {$complete_history == 1} {
        set filedate "cmplt"
    } else {
        set filedate "[clock format [clock scan "$sdate -0 day"] -format %Y%m%d]-[clock format [clock scan "$edate -0 day"] -format %Y%m%d]"
    }
    
    set today     [string toupper [clock format [clock seconds] -format %d-%b-%Y]]
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
    puts "$argv0 failed to run\n$result" 
    exit
}

set cursor_C  [oraopen $handleC]

proc do_report { entity_arg} {
    global cursor_C
    global date_my filedate today sdate edate

    ##
    # Prepare the comma separated enity list for sql
    ###
    set sql_entity_arg ""
    foreach ent $entity_arg {
        set sql_entity_arg "$sql_entity_arg '$ent',"
    }
    set sql_entity_arg [string trim $sql_entity_arg {, }]

    ##
    # Get entity info and save for later use
    ###
    set entity_qry	"select Entity_id, Entity_dba_Name
                    from MASCLR.acq_entity
                    where entity_id in ($sql_entity_arg)"

    orasql $cursor_C $entity_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        set entity_info($row(ENTITY_ID).DBA) $row(ENTITY_DBA_NAME)
    }

    ##
    # Get reserve details
    ###
    set qry "select entity_id, payment_proc_dt, action, AMT from
            (
                select mtl.entity_id, aad.payment_proc_dt, 'ADD' action, sum(mtl.AMT_ORIGINAL) AMT
                from mas_trans_log mtl, (select institution_id, payment_seq_nbr, payment_status, payment_proc_dt
                                        from acct_accum_det 
                                        where payment_status = 'P'
                                        and payment_proc_dt >= '$sdate' and payment_proc_dt < '$edate') aad
                where (mtl.institution_id = aad.institution_id and mtl.payment_seq_nbr = aad.payment_seq_nbr)
                and mtl.tid in ('010005050000')
                and mtl.entity_id in ($sql_entity_arg)
                group by mtl.entity_id, aad.payment_proc_dt
            )
            union all
            (
                select mtl.entity_id, aad.payment_proc_dt, 'RELEASE' action, sum(-1*mtl.AMT_ORIGINAL) AMT
                from mas_trans_log mtl, (select institution_id, payment_seq_nbr, payment_status, payment_proc_dt
                                        from acct_accum_det 
                                        where (institution_id, entity_acct_id) in (select institution_id, entity_acct_id
                                                                                    from entity_acct
                                                                                    where OWNER_ENTITY_ID in ($sql_entity_arg)
                                                                                    and acct_posting_type = 'R')
                                        and payment_status = 'P'
                                        and payment_proc_dt >= '$sdate' and payment_proc_dt < '$edate') aad
                where (mtl.institution_id = aad.institution_id and mtl.payment_seq_nbr = aad.payment_seq_nbr)
                and mtl.tid in ('010007050000', '010007050100')
                and mtl.entity_id in ($sql_entity_arg)
                group by mtl.entity_id, aad.payment_proc_dt
            )
            order by entity_id, payment_proc_dt"

    #puts "\n\n\n$qry\n\n"
    orasql $cursor_C $qry

    set TOTAL_ADDED		0
    set TOTAL_RELEASED	0
    set data_dict [dict create]

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        set ent $row(ENTITY_ID)
        
        ##
        # if a dictionary entry for this entity has not yet been created
        # create and initialize its variables in the dictionary
        ###
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
            set NET [expr $NET + $row(AMT)]
            
            if {$row(ACTION) == "ADD"} {
                set ADD     [expr $ADD + $row(AMT)]
            } else {
                set REL     [expr $REL + $row(AMT)]
            }
        }
    }
    
    if {[llength $entity_arg] ==1} {
        set filename "entity.reserve.summary.$filedate.$entity_arg.csv"
    } else {
        set filename "entity.reserve.summary.$filedate.multi.csv"
    }
    
    set cur_file [open "$filename" w]
    puts $cur_file "Generated:, [clock format [clock seconds] -format %d-%b-%Y]"
    
    ##
    # For each entity, write details to the file
    ###
    dict for {ent data} $data_dict {
        puts "writing $ent"
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
}


##
# Main
###

arg_parse
set complete_history 0

if {[info exists start_date_arg] && [info exists end_date_arg]} {
    set start_arg	[string toupper [clock format [clock scan $start_date_arg -format %Y%m%d ] -format %d-%b-%Y]]
    set end_arg		[string toupper [clock format [clock scan $end_date_arg -format %Y%m%d ] -format %d-%b-%Y]]
    init_dates $start_arg $end_arg
} else {
    set start_arg	[string toupper [clock format [clock scan "20090101" -format %Y%m%d ] -format %d-%b-%Y]]
    set end_arg		[string toupper [clock format [clock scan "+1 year" ] -format %d-%b-%Y]]
    set complete_history 1
    init_dates $start_arg $end_arg
    puts "All reserve history -> start: $start_arg -- end: $end_arg"
}

if {$entity_arg != ""} {
    do_report $entity_arg 
} else {
    puts "Entity_ID required.\nUsage: $argv0 -E <15 digit eid> \[-E <15 digit eid>\]... \[-start yyyymmdd -end yyyymmdd\]"
}


oraclose $cursor_C
oralogoff $handleC


