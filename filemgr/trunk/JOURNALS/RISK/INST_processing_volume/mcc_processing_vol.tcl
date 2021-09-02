#!/usr/bin/env tclsh

################################################################################
# $Id: mcc_processing_vol.tcl 2522 2014-01-23 19:25:16Z mitra $
# $Rev: $
################################################################################
#
# Monthly MCC Processing Volume Risk Report
#
# USAGE: mcc_processing_vol.tcl -I nnn ?\[-D YYYYMMDD\] ?\[-sort column_name\]
#
################################################################################

##
# REPORT DATA FORMAT
###
#
# entity_dictionary
#        |______________entity_1
#        |                 |_______EntityID
#        |                 |_______DBA Name
#        |                 |_______MCC
#        |                 |_______Auth_Declines
#        |                 |_______SALES_AMT
#        |                 |...
#        |                 |...
#        |                 |_______MC
#        |                 |       |_______Sales_AMT
#        |                 |       |_______Sales_CNT
#        |                 |       |_______Chargeback_AMT
#        |                 |       |_______Chargeback_CNT
#        |                 |       |...
#        |                 |
#        |                 |_______VS
#        |                 |       |_______Sales_AMT
#        |                 |       |_______Sales_CNT
#        |                 |       |_______Chargeback_AMT
#        |                 |       |_______Chargeback_CNT
#        |                 |       |...
#        |                 |
#        |                 |_______DS
#        |                 |       |_______Sales_AMT
#        |                 |       |_______Sales_CNT
#        |                 |       |_______Chargeback_AMT
#        |                 |       |_______Chargeback_CNT
#        |                 |       |...
#        |
#        |______________entity_2
#        |                 |_______EntityID
#        |                 |_______DBA Name
#        |                 |_______Auth_Declines
#        |                 |_______...
#        .
#        .
#        .
###

package require Oratcl

#set Entity_id as the default sort
set sort_columns "INSTITUTION_ID"

# Space below is left intentionally. When we need to add a new column,
# it needs to be added before CARD_SCHEME.
set main_col_lst {
            {INSTITUTION_ID "Institution ID" a}
            {ENTITY_ID "Entity ID" a}
            {ENTITY_DBA_NAME "DBA NAME" a}
            {DEFAULT_MCC "DEFAULT MCC" a}
            {AUTH_DECLINES "AUTH DECLINES" n}
            {PREV_SALES_AMT "PREVIOUS MONTH SALES TOTAL" r}
            {CUR_SALES_AMT "CURRENT SALES TOTAL" r}
            {CUR_SALES_CNT "CURRENT SALES COUNT" n}
            {AVG_TICKET "AVERAGE SALE AMOUNT" r}
            {PERC_CHNGE "SALES VOL PERC CHANGE" r}
            {CHARGBK_CNT "CHARGEBACK COUNT" n}

            {CARD_SCHEME "CARD SCHEME" a}
}

set cardtype_col_lst {
                    {SALES_AMT "SALES AMOUNT" n}
                    {SALES_CNT "SALES COUNT" n}
                    {REFUNDS "REFUNDS" n}
                    {CHARGBK_AMT "CHARGEBACK AMOUNT" n}
                    {CHARGBK_CNT "CHARGEBACK COUNT" n}
                    {REPRESENTMENT_AMT "REPRESENTMENT AMOUNT" n}
                    {REPRESENTMENT_CNT "REPRESENTMENT COUNT" n}
            }


# Environment Variables
# set clrdb trnclr4
# set authdb AUTH2
set authuser $env(ATH_DB_USERNAME)
set authpwd $env(ATH_DB_PASSWORD)
set authdb $env(ATH_DB)
set clruser $env(IST_DB_USERNAME)
set clrpwd $env(IST_DB_PASSWORD)
set clrdb $env(CLR4_DB)

set email_recipient "risk@jetpay.com,Reports-clearing@jetpay.com"
set log_folder      "LOGS"

proc formatted_puts {str} {
    puts "[clock format [clock seconds] -format %Y%m%d%H%M%S] - $str"
}

proc arg_parse {} {
    global argv date_arg mccs_arg sort_columns

    #scan for Date
    if { [regexp -- {-[Dd][ ]+([0-9]{8,8})} $argv dummy parsed_date] } {
        formatted_puts "Start date argument: $parsed_date"
        set date_arg $parsed_date
    }

    #scan for sort argument
    set numsort 0
    set numsort [regexp -all -- {-SORT[ ]+([A-Z_]{1,15})} [string toupper $argv]]

    if { $numsort > 0 } {
        set sort_columns {}
        set res_lst [regexp -inline -all -- {-SORT[ ]+([A-Z_]{1,15})} [string toupper $argv]]

        foreach {fullmatch sort_var} $res_lst {
            lappend sort_columns $sort_var
        }
    }

    #scan for MCC

    set numMcc 0
    set numMcc [regexp -all -- {-MCC[ ]+([0-9]{4})} [string toupper $argv]]

    if { $numMcc > 0 } {

        set res_lst [regexp -inline -all -- {-MCC[ ]+([0-9]{4})} [string toupper $argv]]

        foreach {fullmatch mcc} $res_lst {
            lappend mccs_arg $mcc
        }
    }
}

proc init_dates {dt} {
    global sdate edate sdate_auth edate_auth prev_mnth_sdate prev_mnth_edate
    set sdate   [string toupper [clock format [clock scan "$dt" -format %Y%m%d ] -format 01-%b-%Y]]
    set edate   [string toupper [clock format [clock scan "$dt + 1 month"] -format 01-%b-%Y]]

    set sdate_auth [string toupper [clock format [clock scan "$sdate"] -format %Y%m%d000000]]
    set edate_auth [string toupper [clock format [clock scan "$edate"] -format %Y%m%d000000]]

    set prev_mnth_sdate [string toupper [clock format [clock scan "$dt - 1 month"] -format 01-%b-%Y]]
    set prev_mnth_edate $sdate
}

proc init_log {} {
    global log_fd log_folder argv0

    set nme $argv0
    set log_fd [open "./LOG/${nme}_[clock format [clock seconds] -format %Y%m%d].log" a+]
    puts $log_fd "Script started... $nme\n"
}

proc cleanup_log {} {
    global log_fd

    if { [info exists log_fd] } {
        close $log_fd
    } else {
        puts "LOG NOT OPENED"
    }
}

proc log_msg {msg} {
    global log_fd

    if {[info level ] == 1} {
        set caller MAIN
    } else {
        set caller [lrange [info level -1] 0 0]
    }

    if {[info exists log_fd]} {
        puts $log_fd "[clock format [clock seconds] -format %Y%m%d%H%M%S] $caller - $msg"
        flush $log_fd
    }

    #Also send to std out
    puts "[clock format [clock seconds] -format %Y%m%d%H%M%S] $caller - $msg"

}

proc print_usage {} {
    global main_col_lst argv0
    puts "USAGE: $argv0 -mcc nnnn ?\[-D YYYYMMDD\] ?\[-sort column_name\]"
    puts "\tSort arguments include:"
    foreach col $main_col_lst {
        puts "\t\t[lindex $col 0]"
    }
}


proc do_report {mcc_lst} {
    global sdate edate sdate_auth edate_auth prev_mnth_sdate prev_mnth_edate
    global cursor_C cursor_A email_recipient main_col_lst cardtype_col_lst
    global sort_columns sort_column_type institutions_arg

    set rpt_list ""

    set mcc_sql_string ""
    foreach mcc $mcc_lst {
        set mcc_sql_string "${mcc_sql_string}'$mcc',"
    }
    set mcc_sql_string [string trim $mcc_sql_string {,}]



    ##
    # GET ENTITIES THAT WILL BE INCLUDED IN THIS REPORT
    ###
    set entity_qry "SELECT replace(entity_dba_name, ',', '') as ENTITY_DBA_NAME, DEFAULT_MCC, institution_id, entity_id
                        FROM acq_entity
                        WHERE DEFAULT_MCC in ($mcc_sql_string)"

    log_msg "Fetching entity list to initialize dictionary"
    orasql $cursor_C $entity_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] == 0} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        #initialize entity in the dictionary

        dict set entity_dictionary $unique INSTITUTION_ID $row(INSTITUTION_ID)
        dict set entity_dictionary $unique ENTITY_ID $row(ENTITY_ID)
        dict set entity_dictionary $unique ENTITY_DBA_NAME [string map {"," "."} $row(ENTITY_DBA_NAME)]
        dict set entity_dictionary $unique DEFAULT_MCC $row(DEFAULT_MCC)
        dict set entity_dictionary $unique CARD_SCHEME ""
        dict set entity_dictionary $unique HAS_VOLUME 0

        #init all numeric major columns to 0
        foreach col $main_col_lst {
            if {[lindex $col 2] !="a"} {
                dict set entity_dictionary $unique [lindex $col 0] 0
            }
        }

        #init all subcolumns in TOTALS to 0
        foreach column $cardtype_col_lst {
            dict set entity_dictionary $unique TOTALS [lindex $column 0] 0
        }

    }

    ##
    # Get frontend mids needed later for all auth queries
    # This list is divided into groups of less than 1000
    ###
    set ent_to_auth_qry "SELECT eta.institution_id, eta.entity_id, eta.mid
                        FROM entity_to_auth eta, acq_entity acq
                        WHERE (eta.entity_id = acq.entity_id and eta.institution_id = acq.institution_id)
                        and eta.status = 'A'
                        and acq.DEFAULT_MCC in ($mcc_sql_string)"

    set mids(0) ""

    set mid_lst_indx 0
    set cur_indx_in_lst 0

    log_msg "Fetching entity_to_auth MIDs for the auth side queries"
    orasql $cursor_C $ent_to_auth_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] == 0} {

        lappend mids($mid_lst_indx) $row(MID)

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        #This will be used later to link mids to their entity for the report
        set mid_to_entity($row(MID)) $unique

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

    ##
    # AUTH QUERIES
    # Run for each group of MIDS for this institution
    ###
    log_msg "Running Auth queries"
    for {set i 0} {$i <= $mid_lst_indx} {incr i} {

        set mid_sql_lst ""
        foreach x $mids($i) {
            set mid_sql_lst "$mid_sql_lst,'$x'"
        }

        set mid_sql_lst [string trim $mid_sql_lst {,}]

        set auth_declines_qry "SELECT MID, count(1) CNT
                                FROM teihost.transaction
                                WHERE action_code <> '000'
                                and mid in ($mid_sql_lst)
                                and request_type in ('0100','0200','0220','0250','0260','0270','0420')
                                and authdatetime >= '$sdate_auth' and authdatetime < '$edate_auth'
                                group by MID"

        orasql $cursor_A $auth_declines_qry

        while {[orafetch $cursor_A -dataarray row -indexbyname] == 0} {
            set unique $mid_to_entity($row(MID))
            set prev_declns [dict get [dict get $entity_dictionary $unique] AUTH_DECLINES]

            dict set entity_dictionary $unique AUTH_DECLINES [expr $prev_declns + $row(CNT)]
        }
    }

    set IS_SALES "mtl.tid in ('010003005101','010123005101','010123005102','010003005201', \
                              '010003005202','010003005104','010003005204','010003005103', \
                              '010003005203')"
    set IS_CHGBK "mtl.tid in ('010003015101','010003015102','010003015201','010003015210','010003015301')"
    set IS_REPR  "mtl.tid in ('010003005301','010003005401','010003010102','010003010101')"

    set qry "SELECT mtl.institution_id, mtl.entity_id,mtl.CARD_SCHEME,
        sum(case    when(mtl.tid_settl_method = 'C' AND $IS_SALES) then mtl.amt_original
                    when(mtl.tid_settl_method <> 'C' AND $IS_SALES) then -1*mtl.amt_original else 0 end) as SALES_AMT,
        sum(case when($IS_SALES) then 1 else 0 end) as SALES_CNT,
        sum(case when(mtl.tid_settl_method <> 'C' AND mtl.tid in ('010003005102')) then mtl.amt_original else 0 end) as REFUNDS,
        sum(case    when(mtl.tid_settl_method <> 'C' AND $IS_CHGBK) then mtl.amt_original
                    when(mtl.tid_settl_method = 'C' AND $IS_CHGBK) then -1*mtl.amt_original else 0 end) as CHARGBK_AMT,
        sum(case when($IS_CHGBK) then 1 else 0 end) as CHARGBK_CNT,
        sum(case    when(mtl.tid_settl_method = 'C' AND $IS_REPR) then mtl.amt_original
                    when(mtl.tid_settl_method <> 'C' AND $IS_REPR) then -1*mtl.amt_original else 0 end) as REPRESENTMENT_AMT,
        sum(case when($IS_REPR) then 1 else 0 end) as REPRESENTMENT_CNT
     from mas_trans_log mtl, acq_entity acq, (select PAYMENT_SEQ_NBR, institution_id
                                 from ACCT_ACCUM_DET
                                 where PAYMENT_PROC_DT >= '$sdate' and PAYMENT_PROC_DT < '$edate'
                                  and payment_cycle = '1'
                                  and payment_status = 'P') aad
     where (mtl.entity_id = acq.entity_id and mtl.institution_id = acq.institution_id)
         and (mtl.PAYMENT_SEQ_NBR = aad.PAYMENT_SEQ_NBR and mtl.institution_id = aad.institution_id)
         and acq.default_mcc in ($mcc_sql_string)
         and ($IS_SALES OR $IS_CHGBK OR $IS_REPR)
         and mtl.SETTL_FLAG = 'Y'
         and mtl.CARD_SCHEME in ('04','05','03','08')
     group by mtl.institution_id, mtl.entity_id, acq.entity_dba_name, mtl.CARD_SCHEME"

    #puts $qry
    log_msg "Running sales query for current month"

    orasql $cursor_C $qry
    set cur_cardscheme "00"

    while { [orafetch $cursor_C -dataarray row -indexbyname] == 0 } {
        set unique "$row(INSTITUTION_ID).$row(ENTITY_ID)"

        dict set entity_dictionary $unique HAS_VOLUME 1


        switch -- $row(CARD_SCHEME) {
            "04" { set cur_cardscheme "VS"}
            "05" { set cur_cardscheme "MC"}
            "03" { set cur_cardscheme "AX"}
            "08" { set cur_cardscheme "DS"}
            default {set cur_cardscheme "OTHER"}
        }

        foreach column $cardtype_col_lst {
            if {[dict exists $entity_dictionary $unique TOTALS [lindex $column 0]]} {
                set tot [dict get [dict get [dict get $entity_dictionary $unique] TOTALS] [lindex $column 0]]
            } else {
                set tot 0
            }

            dict set entity_dictionary $unique $cur_cardscheme [lindex $column 0] $row([lindex $column 0])
            dict set entity_dictionary $unique TOTALS [lindex $column 0] [expr $tot + $row([lindex $column 0])]
        }
    }


    set prev_month_sales_qry "SELECT mtl.institution_id, mtl.entity_id,
        sum(case    when(mtl.tid_settl_method = 'C' AND $IS_SALES) then mtl.amt_original
                    when(mtl.tid_settl_method <> 'C' AND $IS_SALES) then -1*mtl.amt_original else 0 end) as PREV_SALES_AMT
     from mas_trans_log mtl, acq_entity acq, (select PAYMENT_SEQ_NBR, institution_id
                                 from ACCT_ACCUM_DET
                                 where PAYMENT_PROC_DT >= '$prev_mnth_sdate' and PAYMENT_PROC_DT < '$prev_mnth_edate'
                                  and payment_cycle = '1'
                                  and payment_status = 'P') aad
     where (mtl.entity_id = acq.entity_id and mtl.institution_id = acq.institution_id)
         and (mtl.PAYMENT_SEQ_NBR = aad.PAYMENT_SEQ_NBR and mtl.institution_id = aad.institution_id)
         and acq.default_mcc in ($mcc_sql_string)
         and ($IS_SALES)
         and mtl.SETTL_FLAG = 'Y'
         and mtl.CARD_SCHEME in ('04','05','03','08')
     group by mtl.institution_id, mtl.entity_id"

    log_msg "Running sales query for previous month"
    orasql $cursor_C $prev_month_sales_qry

    while { [orafetch $cursor_C -dataarray row -indexbyname] == 0 } {
        set unique "$row(INSTITUTION_ID).$row(ENTITY_ID)"

        if {[dict exists $entity_dictionary $unique]} {

            dict set entity_dictionary $unique PREV_SALES_AMT $row(PREV_SALES_AMT)
            set cur_sales_amt [dict get [dict get [dict get $entity_dictionary $unique] TOTALS] SALES_AMT]
            set difference [expr $cur_sales_amt - $row(PREV_SALES_AMT)]

            if {$row(PREV_SALES_AMT)==0} {
                set PERC_CHNGE "0"
            } else {
                set PERC_CHNGE [expr (double($difference)/$row(PREV_SALES_AMT))*100]
                set PERC_CHNGE [format %.3f $PERC_CHNGE]
            }
            dict set entity_dictionary $unique PERC_CHNGE $PERC_CHNGE
        } else {
            log_msg "Enity: $unique is not in the dictionary.. skipping"
        }
    }

    log_msg "Generating report from dictionary"
    ##
    # Setup report header
    ###

    set rep "\nPROCESSING VOLUME RISK REPORT FOR SELECTED MCCs\n"
    set rep "${rep}MCC(s):,'$mcc_lst'\n"
    set rep "${rep}Month:,[string toupper [clock format [clock scan $sdate -format %d-%b-%Y] -format "%b %Y"]]\n"
    set rep "${rep}Generated:,[string toupper [clock format [clock seconds] -format %d-%b-%Y]]\n"
    set rep "${rep}\n\n"

    set rep "${rep}Below is the total subreport and after that is the detail report:\n\n"

    set total_sub_report ""

    foreach col $main_col_lst {
        set rep "${rep}[lindex $col 1],"
    }
    #set rep "Entity ID,DBA NAME,AUTH DECLINES,CARD SCHEME"
    foreach column $cardtype_col_lst {
        set rep "${rep}[lindex $column 1],"
    }

    ##
    # Generate report details
    ###
    foreach unique [dict keys $entity_dictionary] {

        ##
        # For each entity, we first output the main heading (includes entity_id, dba, declines..)
        # then we output volume data for the various card schemes
        # WE DONT show entities with no declines or sale activity
        ###

        #get the total sales count/cnt from the TOTALS node and set the CUR_SALES_AMT/CUR_SALES_CNT in the main node
        set cur_sales_amt [dict get [dict get [dict get $entity_dictionary $unique] TOTALS] SALES_AMT]
        set cur_sales_cnt [dict get [dict get [dict get $entity_dictionary $unique] TOTALS] SALES_CNT]
        set chrgbk_cnt [dict get [dict get [dict get $entity_dictionary $unique] TOTALS] CHARGBK_CNT]

        dict set entity_dictionary $unique CUR_SALES_AMT $cur_sales_amt
        dict set entity_dictionary $unique CUR_SALES_CNT $cur_sales_cnt
        dict set entity_dictionary $unique CHARGBK_CNT $chrgbk_cnt

        if {$cur_sales_cnt != 0} {
            dict set entity_dictionary $unique AVG_TICKET [format %.2f [expr $cur_sales_amt/$cur_sales_cnt]]
        }
        #########################


        set num_declines [dict get [dict get $entity_dictionary $unique] AUTH_DECLINES]
        set has_volume_for_month [dict get [dict get $entity_dictionary $unique] HAS_VOLUME]

        if { $num_declines>0 || $has_volume_for_month>0} {

            #Generate the main line data for this entity (Entity_id, DBA, MCC, Declines...)
            set main_line "`"
            set submainline "`"
            foreach maincolumn $main_col_lst {
                set main_line "${main_line}[dict get [dict get $entity_dictionary $unique] [lindex $maincolumn 0]],"
                append submainline "[dict get [dict get $entity_dictionary $unique] [lindex $maincolumn 0]],"
            }
            set submainline [string range $submainline 0 end-1]
            set entity_detail "$main_line"

            #Generate the card type breakdown section for this entity (MC, sales, sales_cnt, chrgbks...
            #                                                          VS, sales, sales_cnt, chrgbks...
            #                                                          AX, sales, sales_cnt, chrgbks...
            #                                                          DS, sales, sales_cnt, chrgbks...)
            foreach crd {VS MC AX DS TOTALS} {

                if {[dict exists $entity_dictionary $unique $crd]} {

                    set line ""
                    #insert a comma infront the line for every main line column that preceeds this section
                    for {set i 0} {$i< [expr [llength $main_col_lst]-1]} {incr i} {
                        set line ",$line"
                    }

                    set line "${line}$crd"
                    set subrepline $crd

                    foreach column $cardtype_col_lst {
                        set line "$line,[dict get [dict get [dict get $entity_dictionary $unique] $crd] [lindex $column 0]]"
                        append subrepline ",[dict get [dict get [dict get $entity_dictionary $unique] $crd] [lindex $column 0]]"
                    }

                    set entity_detail "${entity_detail}\n$line"

                    if {$crd == "TOTALS"} {
                      append total_sub_report "$submainline$subrepline\n"
                    }
                 }
            }

            ##
            # Accumulate the report details in the unsorted listing
            # { {SORT COLUMN VALUE} {Entity detail} }
            #
            #   Perc change   Entity detail
            # { {100.00}    {454045496000000,STUDIO ONE,8699,35,5564.2,-9.901,,,,,,,,
            #                                                                VS,4003.81,109,0,0,0,0,0
            #                                                                MC,1009.5,32,0,0,0,0,0
            #                                                                TOTALS,5013.31,141,0,0,0,0,0} }
            ###

            #insert each sort column value in entry
            set list_of_sort_values {}
            foreach sort_argument $sort_columns {
                lappend list_of_sort_values [dict get [dict get $entity_dictionary $unique] $sort_argument]
            }

            #finally add the actual detail
            lappend list_of_sort_values $entity_detail
            set total_sub_report [string map {\{ "" \} ""} $total_sub_report]
            lappend unsorted_report_listing "$list_of_sort_values"

        }
    }

    log_msg "Putting together the output for the following sort order(s): $sort_columns"

    set indx 0
    foreach sort_argument $sort_columns {

        switch -- $sort_column_type($sort_argument) {
            "n" { set sorted_listing [lsort -integer -decreasing -index $indx $unsorted_report_listing]   }
            "r" { set sorted_listing [lsort -real -decreasing -index $indx $unsorted_report_listing]      }
            default { set sorted_listing [lsort -ascii -index $indx $unsorted_report_listing] }
        }

        incr indx

        set sorted_report ""
        foreach {sub_lst} $sorted_listing {
            #puts $sub_lst
            set sorted_report "${sorted_report}\n\n[lindex $sub_lst [llength $sort_columns]]"
        }

        set sorted_report "${rep}\n$total_sub_report\n$sorted_report"

        set filename "mcc.processing.volume.[clock format [clock scan $sdate -format %d-%b-%Y] -format %Y%m].[string tolower $sort_argument].csv"
        log_msg "Writing file: $filename"
        set fl [open $filename w]
        puts $fl $sorted_report
        close $fl

        exec echo "Please see attached." | mutt -a $filename -s "MCC Processing Volume Monthly Risk Report" -- $email_recipient
    }
}

##MAIN##

init_log

if {[catch {set handleC [oralogon $clruser/$clrpwd@$clrdb]} result]} {
     #exec echo $fail_msg | mutt -s $fail_msg -- $mailtolist
     log_msg "MASCLR Connection Error: $result"
     exit
} else {
    puts "COnnected"
}

set cursor_C [oraopen $handleC]

if {[catch {set handleA [oralogon $authuser/$authpwd@$authdb]} resultauth ]} {
     #exec echo "$argv0 failed to run\n$resultauth" | mutt -s "$argv0 failed to run" -- $mailto_error
     log_msg "TEIHOST Connection Error: $resultauth"
     exit
} else {
    puts "COnnected"
}

set cursor_A [oraopen $handleA]

arg_parse

if {![info exists mccs_arg]} {

    puts "No mcc provided. At least one is needed."
    print_usage
    cleanup_log
    exit
}

if { [info exists date_arg]} {
    init_dates $date_arg
} else {
    #if no date argument was provided use the current month
    init_dates [clock format [clock seconds] -format %Y%m%d]
}

foreach sort_argument $sort_columns {
    #Go through the column list to find the type of column it is
    #Set array 'sort_column_type($column_name)' to the type
    foreach col $main_col_lst {
        if {[lindex $col 0] == $sort_argument} {
            set sort_column_type($sort_argument) [lindex $col 2]
        }
    }
}


if {![info exists sort_column_type]} {
    puts "The provided sort argument is invalid..\n"
    print_usage
    exit
}


log_msg "Starting $argv0 report run"
log_msg "MCCs: $mccs_arg"
log_msg "Report month: [clock format [clock scan $sdate -format %d-%b-%Y] -format %Y%m]"
log_msg "Sort columns: $sort_columns"


do_report $mccs_arg

log_msg "Report Done"

oraclose $cursor_C
oralogoff $handleC
oraclose $cursor_A
oralogoff $handleA

cleanup_log
