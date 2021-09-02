#!/usr/bin/env tclsh

package require Oratcl

#$Id: 117_ISO_BILLING.tcl 3666 2016-01-28 21:31:54Z bjones $

# set clrdb trnclr1
set clrdb $env(IST_DB)
set authdb $env(TSP4_DB)

set mailfromlist "ajohn@jetpay.com"
set mailto_error "ajohn@jetpay.com"

proc mailsend { email_subject email_recipient email_sender email_body } {
    set temp_value ""
    regsub -all "\:" $email_body "\072" temp_value

    exec echo "$temp_value" | mailx -r $email_sender -s "$email_subject" $email_recipient
    #exec echo "$temp_value" |  mail -s "$email_subject" $email_recipient -- -r "$email_sender"
}

proc arg_parse {} {
    global argv institutions_arg date_arg

    #scan for Date
    if { [regexp -- {(-[dD])[ ]+([0-9]{8,8})} $argv dummy1 dummy2 arg_date] } {
        puts "Date argument: $arg_date"
        set date_arg $arg_date
    }

}

proc init_dates {val} {
    global date today date_my next_mnth_my prev_mnth_my date_auth_start date_auth_end filedate
    set date            [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]] 
    set filedate        [string toupper [clock format [clock scan " $date -0 day"] -format %Y%m]]
    set date_my         [string toupper [clock format [clock scan " $date -0 day"] -format %b-%Y]]     ;# MAR-2012
    set next_mnth_my    [string toupper [clock format [clock scan "01-$date_my +1 month"] -format %b-%Y]]     ;# APR-2012
    set prev_mnth_my    [string toupper [clock format [clock scan "01-$date_my -1 month"] -format %b-%Y]]     ;# FEB-2012

    set date_auth_start [clock format [clock scan "01-$date_my -0 day"] -format %Y%m%d%H%M%S]     ;# 20120809204501
    set date_auth_end   [clock format [clock scan "01-$date_my +1 month"] -format %Y%m%d%H%M%S]     ;# 20120809204501
    set today           [string toupper [clock format [clock seconds] -format %d-%b-%Y]]
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
  mailsend "iso_billing.tcl failed to run" $mailto_error $mailfromlist "iso_billing.tcl failed to run\n$result" 
  exit
}

#This must always be trnclr4
if {[catch {set handleGetreporting [oralogon masclr/masclr@trnclr4]} result]} {
    exec echo "$argv0 failed to run\n$result" | mutt -s "$argv0 failed to run" -- $mailto_error
    exit
}

if {[catch {set handleA [oralogon teihost/quikdraw@$authdb]} resultauth ]} {
  mailsend "iso_billing.tcl failed to run" $mailto_error $mailfromlist "iso_billing.tcl failed to run\n$result"
  exit
}

set cursor_C [oraopen $handleC]
set cursor_GtReporting  [oraopen $handleGetreporting]
set cursor_A [oraopen $handleA]


proc do_report { inst } {
    global cursor_C cursor_A cursor_GtReporting date_auth_start date_auth_end
    global date_my today prev_mnth_my next_mnth_my filedate

    foreach i $inst {
        lappend sql_inst "'$i',"
    }

    set sql_inst [string trim $sql_inst {,}]
    
    
    set repVarList  {
                    {DBA_NAME           "DBA Name"                  a}
                    {NAME               "Name"                      a}
                    {ENTITY_ID          "Entity ID"                 a}
                    {BILLING_TYPE       "Billing Type"              a}
                    {DBT_CNT             "Debit Count"              n}
                    {DBT_AMT             "Debit Amount"             n}
                    {CHGBK_C_CNT        "Chargeback Credit Count"   n}
                    {CHGBK_C_AMT        "Chargeback Credit Amount"  n}
                    {CHGBK_D_CNT        "Chargeback Debit Count"    n}
                    {CHGBK_D_AMT        "Chargeback Debit Amount"   n}
                    
                    {AUTH_CNT           "Auth Counts"               n}
                    {CAPT_CNT           "Capture Counts"            n}
                    {CVV2_CNT           "CVV2 Counts"               n}
                    {AVS_CNT            "AVS Counts"                n}
                    {RET_REQ_CNT        "Retrieval Requests"        n}
    }
    
        
        
    set entity_qry	"select Entity_id, Entity_dba_Name, Entity_Name, institution_id, billing_type
                    from MASCLR.acq_entity
                    where institution_id in ($sql_inst)
                    and ((entity_status = 'A')  or (entity_status = 'C' and (termination_date-90)  > '01-$date_my'))
                    order by entity_id"

	puts "Fetching active merchant list"
	orasql $cursor_C $entity_qry
	
	while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {		

        ##
        #  eid_list is the list of entities included in this report
        # 	It's elements are in the form: 'institution_ID'.'Entity_ID'
        ###

        set unique "$row(INSTITUTION_ID).$row(ENTITY_ID)"

        dict set report_dictionary "$unique" DBA_NAME       [string map {"," "."} $row(ENTITY_DBA_NAME)]
        dict set report_dictionary "$unique" NAME           [string map {"," "."} $row(ENTITY_NAME)]
        dict set report_dictionary "$unique" BILLING_TYPE   $row(BILLING_TYPE)
        dict set report_dictionary "$unique" ENTITY_ID      $row(ENTITY_ID)

        
        foreach varDesc $repVarList {
            if {[lindex $varDesc 2] == "n"} {
                dict set report_dictionary "$unique" [lindex $varDesc 0] 0
            }
        }
    }
    
    ##
    # INITIALIZATION OF DICTIONARY
    ###
    
    #Add an entry for the totals in the dictionary
    dict set report_dictionary "TOTAL" DBA_NAME "TOTALS"
    
    #Initialize all numeric fields for each entity to 0
    foreach ent [dict keys $report_dictionary] {
        foreach varDesc $repVarList {
            if {[lindex $varDesc 2] == "n"} {
                dict set report_dictionary "$ent" [lindex $varDesc 0] 0
            }
        }
    }

    set ACTIVE_MERCH_CNT	0
    set CAPTURE_CNT			0
    set AUTH_CNT			0
    set GETREPORTING_USERS	0

    set active_merch_qry "Select count(1) as ACTIVE_MERCH_CNT
                            from masclr.acq_entity
                            where institution_id in ($sql_inst) 
                            and (entity_level = '70' and termination_date > '01-$prev_mnth_my')"

    orasql $cursor_C $active_merch_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        set ACTIVE_MERCH_CNT $row(ACTIVE_MERCH_CNT)
    }

    #Will run ONLY on tranclr4
    set getreporting_users_qry "select count (unique u.username)as GR_USERS
                                from port.user_profiles u, port.master_entity_hierarchy h
                                WHERE u.entity_code = h.entity_code
                                AND u.entity_type = h.entity_type
                                and SUBSTR(h.entity_id,1,6) = '461084'"

    orasql $cursor_GtReporting $getreporting_users_qry

    while {[orafetch $cursor_GtReporting -dataarray row -indexbyname] != 1403} {
        set GETREPORTING_USERS $row(GR_USERS)
    }

    ##
    # Get frontend mids needed later for all auth queries
    ###
    set ent_to_auth_qry "select institution_id, entity_id, mid
                        from entity_to_auth 
                        where institution_id in ($sql_inst)"

    set mids(0) ""

    set mid_lst_indx 0
    set cur_indx_in_lst 0

    orasql $cursor_C $ent_to_auth_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        #Array for converting mids back to entity_id
        set mid_to_entity($row(MID)) "$row(INSTITUTION_ID).$row(ENTITY_ID)"
        
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


    ##
    ##############AUTH #################
    # Run queries for each set of MIDs 
    # *less than 1000 mids per set*
    ###
    puts "Fetching CVV2 and AVS counts"
    puts "Fetching CAPTURE counts"
    puts "Fetching Debit amounts"
    puts "Fetching Auth counts"
    for {set i 0} {$i <= $mid_lst_indx} {incr i} {

        set mid_sql_lst ""
        foreach x $mids($i) {
            set mid_sql_lst "$mid_sql_lst, '$x'"
        }

        set mid_sql_lst [string trim $mid_sql_lst {,}]
        
        ##################################################################################################################
        #                                               CVV2 AND AVS
        ##################################################################################################################
        set cvv2_avs_qry "SELECT mid, 
                            /*Count non numeric cvv responses*/
                            SUM( CASE WHEN (translate(cvv,CHR(1)||'1234567890 ',CHR(1)) IS NULL) then 0  else 1 end) CVV2_CNT,
                            /*Count non blank avs responses*/
                            SUM( CASE WHEN (translate(avs_response,CHR(1)||' ',CHR(1)) IS NULL) then 0 else 1 end) AVS_CNT
                      FROM teihost.tranhistory
                      WHERE settle_date >= '$date_auth_start'
                        and settle_date < '$date_auth_end'
                        and mid in ($mid_sql_lst)
                      GROUP by mid"
        
        orasql $cursor_A $cvv2_avs_qry
        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
            
            #Accumulate for entities based on the mids
            set unique $mid_to_entity($row(MID))
            dict set report_dictionary "$unique" CVV2_CNT [expr [dict get $report_dictionary "$unique" CVV2_CNT] + $row(CVV2_CNT)]
            dict set report_dictionary "$unique" AVS_CNT [expr [dict get $report_dictionary "$unique" AVS_CNT] + $row(AVS_CNT)]
        }
        
        ##################################################################################################################
        #                                               CAPTURE COUNTS
        ##################################################################################################################
        set capt_cnt_qry "Select m.mid, count(1) as CAPTURED_CNT 
                            from teihost.tranhistory th, teihost.terminal tt, teihost.merchant m
                            where th.tid = tt.tid 
                            and th.mid=m.mid
                            and m.mid in ($mid_sql_lst)
                            and settle_date >= '$date_auth_start'
                            and settle_date  < '$date_auth_end'
                            group by m.mid"

        orasql $cursor_A $capt_cnt_qry
        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {

            lappend DETAILED_CAP_COUNTS "$row(MID), $row(CAPTURED_CNT)"
            set CAPTURE_CNT [expr $CAPTURE_CNT + $row(CAPTURED_CNT)]
            
            #Accumulate for entities based on the mids
            set unique $mid_to_entity($row(MID))
            dict set report_dictionary "$unique" CAPT_CNT [ expr [dict get $report_dictionary "$unique" CAPT_CNT] + $row(CAPTURED_CNT)]
        }
        
        ##################################################################################################################
        #                                               DEBIT
        ##################################################################################################################
        set debit_qry "Select m.mid, count(1) as DBT_CNT, sum(th.amount) DBT_AMT
                            from teihost.tranhistory th, teihost.terminal tt, teihost.merchant m
                            where th.tid = tt.tid 
                            and th.mid=m.mid
                            and m.mid in ($mid_sql_lst)
                            and SUBSTR(tt.tid,1,4) <> 'JSYS'
                            and request_type = '0260'
                            and settle_date >= '$date_auth_start'
                            and settle_date  < '$date_auth_end'
                            group by m.mid"

        orasql $cursor_A $debit_qry
        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
            
            #Accumulate for entities based on the mids
            set unique $mid_to_entity($row(MID))
            dict set report_dictionary "$unique" DBT_CNT [ expr [dict get $report_dictionary "$unique" DBT_CNT] + $row(DBT_CNT)]
            dict set report_dictionary "$unique" DBT_AMT [ expr [dict get $report_dictionary "$unique" DBT_AMT] + $row(DBT_AMT)]
        }
        
        ##################################################################################################################
        #                                               AUTH COUNTS
        ##################################################################################################################
        set auth_counts_qry "Select m.mid, count(1) AUTH_COUNTS
                            from teihost.transaction t, teihost.merchant m
                            where t.mid=m.mid 
                            and m.mid in ($mid_sql_lst)
                            and request_type in ('0100','0200','0220','0400','0402','0440','0480')
                            and authdatetime >= '$date_auth_start'
                            and authdatetime < '$date_auth_end'
                            GROUP BY m.mid"

        orasql $cursor_A $auth_counts_qry
        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {
            lappend DETAILED_AUTH_COUNTS "$row(MID), $row(AUTH_COUNTS)"
            set AUTH_CNT [expr $AUTH_CNT + $row(AUTH_COUNTS)]
            
            
            #Accumulate for entities based on the mids
            set unique $mid_to_entity($row(MID))
            dict set report_dictionary "$unique" AUTH_CNT [ expr [dict get $report_dictionary "$unique" AUTH_CNT] + $row(AUTH_COUNTS)]
        }
    }
    
    ##
    # Chargebacks
    ###
    set chgtid "'010103015101','010103015102','010103015201','010103015202','010103015203','010103015103','010103015301','010103015302', '010103015303'"
    set chg_qry "select acq.institution_id, acq.entity_id,
                    sum(case when (t.tid in ($chgtid) and t.tid_settl_method = 'C') then 1 else 0 end) as CHGBK_C_CNT,
                    sum(case when (t.tid in ($chgtid) and t.tid_settl_method = 'C') then ind.amt_recon/-100 else 0 end) as CHGBK_C_AMT,
                    sum(case when (t.tid in ($chgtid) and t.tid_settl_method = 'D') then 1 else 0 end) as CHGBK_D_CNT,
                    sum(case when (t.tid in ($chgtid) and t.tid_settl_method = 'D') then  ind.amt_recon/100 else 0 end) as CHGBK_D_AMT
                from in_draft_main ind, in_file_log ifl, tid t, acq_entity acq
                where ind.in_file_nbr = ifl.in_file_nbr
                and (ind.merch_id = acq.entity_id and ind.pri_dest_inst_id = acq.institution_id)
                and ind.tid = t.tid
                and ifl.end_dt >= '01-$date_my' and ifl.end_dt < '01-$next_mnth_my'
                and ind.pri_dest_inst_id in ($sql_inst)
                and ind.tid in ($chgtid)
                and ind.card_scheme in ('04','05','08')
                group by acq.institution_id, acq.entity_id"
                
    orasql $cursor_C $chg_qry
    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        set unique "$row(INSTITUTION_ID).$row(ENTITY_ID)"

        #Only concerned with entities added earlier by the active entity query
        if {[dict exists $report_dictionary $unique]} {
            dict set report_dictionary "$unique" CHGBK_C_CNT $row(CHGBK_C_CNT)
            dict set report_dictionary "$unique" CHGBK_C_AMT $row(CHGBK_C_AMT)
            dict set report_dictionary "$unique" CHGBK_D_CNT $row(CHGBK_D_CNT)
            dict set report_dictionary "$unique" CHGBK_D_AMT $row(CHGBK_D_AMT)
        }
    }
    
    set retrievals_qry "Select Idm.pri_dest_inst_id as INSTITUTION_ID, Idm.merch_id as ENTITY_ID, count(1) RET_REQ_CNT
                        From In_Draft_Main Idm, Tid Tid
                        Where Idm.Tid = Tid.Tid
                        and idm.tid = '010103020102'
                        and pri_dest_inst_id in ($sql_inst)
                        and in_file_nbr in 
                        (SELECT in_file_nbr
                            FROM in_file_log
                            WHERE end_dt >= '01-$date_my' and end_dt < '01-$next_mnth_my'
                            and institution_id in ('04','05','08')
                        )
                        GROUP BY Idm.pri_dest_inst_id, Idm.merch_id"
    
    orasql $cursor_C $retrievals_qry
    
    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        set unique "$row(INSTITUTION_ID).$row(ENTITY_ID)"

        #Only concerned with entities added earlier by the active entity query
        if {[dict exists $report_dictionary $unique]} {
            dict set report_dictionary "$unique" RET_REQ_CNT $row(RET_REQ_CNT)
        }
    }
    
    
    ##
    # Build Report Output
    ###
    set rep "${inst} ISO_BILLING $date_my\n\n"
    set rep "${rep}Active Merchant Count:, $ACTIVE_MERCH_CNT\n"
    set rep "${rep}Get Reporting User Count:, $GETREPORTING_USERS\n\n"

    #Print detail section header
    foreach varDesc $repVarList {
        set rep "${rep}[lindex $varDesc 1],"
    }
    
    set rep "${rep}\n"

    #Print Details
    foreach ent [dict keys $report_dictionary] {
    
        #For each report variable
        foreach varDesc $repVarList {
            if {[dict exists $report_dictionary $ent [lindex $varDesc 0]]} {
                set rep "${rep}[dict get [dict get $report_dictionary $ent] [lindex $varDesc 0]],"
                
                if {[lindex $varDesc 2] == "n"} {
                    set old_tot [dict get [dict get $report_dictionary TOTAL] [lindex $varDesc 0]]
                    set adder   [dict get [dict get $report_dictionary $ent] [lindex $varDesc 0]]
                    
                    dict set report_dictionary TOTAL [lindex $varDesc 0] [expr $old_tot + $adder]
                }
                
            } else {
                set rep "${rep},"
            }
        }
        
        set rep "${rep}\n"
    }

    
    set filename "${inst}.ISO_BILLING.${filedate}.csv"
    set cur_file [open "$filename" w]
    puts $cur_file $rep
    close $cur_file
    
    exec echo "View attached." | mutt -a $filename -s "$filename" -- "accounting@jetpay.com,reports-clearing@jetpay.com"

    exec mv $filename ./ARCHIVE
}

arg_parse

if {![info exists date_arg]} {
	#Runs previous month if no date arg is given
	init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]
} else {
	init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

puts "Running $argv0 for $date_my"
do_report 117

oraclose $cursor_C
oraclose $cursor_GtReporting
oraclose $cursor_A
oralogoff $handleC
oralogoff $handleGetreporting
oralogoff $handleA
