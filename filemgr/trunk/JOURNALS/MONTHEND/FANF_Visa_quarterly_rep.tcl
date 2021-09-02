#!/usr/bin/env tclsh

package require Oratcl

#$Id: FANF_Visa_quarterly_rep.tcl 2157 2013-02-06 16:36:06Z millig $

#set clrdb $env(SEC_DB)
# set clrdb trnclr1
set clrdb $env(IST_DB)

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
    global date today date_my next_mnth_my prev_mnth_my
    set date            [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]]
    set date_my            [string toupper [clock format [clock scan " $date -0 day"] -format %b-%Y]]     ;# MAR-2012
    set next_mnth_my    [string toupper [clock format [clock scan "01-$date_my +1 month"] -format %b-%Y]]     ;# APR-2012
    set prev_mnth_my    [string toupper [clock format [clock scan "01-$date_my -1 month"] -format %b-%Y]]     ;# FEB-2012

    set today            [string toupper [clock format [clock seconds] -format %d-%b-%Y]]
}

proc mailsend { email_subject email_recipient email_sender email_body } {
    set temp_value ""
    regsub -all "\:" $email_body "\072" temp_value

    exec echo "$temp_value" | mailx -r $email_sender -s "$email_subject" $email_recipient
    #exec echo "$temp_value" |  mail -s "$email_subject" $email_recipient -- -r "$email_sender"
}

if {[catch {set handleC [oralogon masclr/masclr@$clrdb]} result]} {
  mailsend "iso_billing.tcl failed to run" $mailto_error $mailfromlist "iso_billing.tcl failed to run\n$result"
  exit
}

set cursor_C [oraopen $handleC]

proc do_report {inst} {
    global cursor_C date today date_my next_mnth_my

    set TOT_CUST_NOT_PRESENT    0
    set TOT_CUST_PRESENT        0
    set details {}

#    set qry "SELECT Idm.MERCH_ID, ae.TAX_ID, Idm.MCC,
#                Sum( Case    WHEN Idm.Pos_Crd_Present <> '0' THEN mtl.Amt_Original Else 0 END) CUST_NOT_PRESENT,
#                Sum( CASE     WHEN Idm.Pos_Crd_Present = '0' THEN mtl.Amt_Original ELSE 0 END) CUST_PRESENT
#                From In_Draft_Main Idm, mas_trans_Log mtl, acq_entity ae
#                WHERE idm.in_file_nbr IN
#                                        (SELECT in_file_nbr
#                                        From In_File_Log
#                                        Where End_Dt >= '01-$date_my' and End_Dt < '01-$next_mnth_my'
#                                        AND institution_id = '$inst'
#                                        And File_Type = '01'
#                                        )
#                AND Idm.Card_Scheme = '04'
#                AND idm.msg_type = '500'
#                And mtl.Trans_Ref_Data = Idm.Arn
#                and mtl.external_trans_nbr = idm.trans_seq_nbr
#                AND mtl.Entity_Id = Idm.Merch_Id
#                AND mtl.Trans_Sub_Seq = '0'
#                And mtl.Settl_Flag = 'Y'
#                And mtl.Gl_Date >= '01-$date_my' and mtl.Gl_Date < '01-$next_mnth_my'
#                and ae.entity_id = idm.merch_id
#                Group By Idm.Merch_Id, Ae.Tax_Id, Idm.Mcc
#                Order By Idm.Merch_Id"

#    set qry "SELECT Idm.MERCH_ID, ae.TAX_ID, Idm.MCC,
#                Sum( Case    WHEN Idm.Pos_Crd_Present <> '0' THEN Idm.amt_trans/100 Else 0 END) CUST_NOT_PRESENT,
#                Sum( CASE     WHEN Idm.Pos_Crd_Present = '0' THEN Idm.amt_trans/100 ELSE 0 END) CUST_PRESENT
#                From In_Draft_Main Idm, acq_entity ae
#                WHERE idm.in_file_nbr IN
#                                        (SELECT in_file_nbr
#                                        From In_File_Log
#                                        Where End_Dt >= '01-$date_my' and End_Dt < '01-$next_mnth_my'
#                                        AND institution_id = '$inst'
#                                        And File_Type = '01'
#                                        )
#                AND Idm.Card_Scheme = '04'
#                AND idm.msg_type = '500'
#                AND idm.trans_clr_status IS NULL
#                and ae.entity_id = idm.merch_id
#                Group By Idm.Merch_Id, Ae.Tax_Id, Idm.Mcc
#                Order By Idm.Merch_Id"

    set qry "select
                idm.MERCH_ID, ae.TAX_ID, idm.MCC,
                sum(case when va.moto_e_com_ind not in ('1','2','3','4','5','6','7','8','9') or
                              va.moto_e_com_ind is NULL
                        then mtl.amt_billing else 0 end) CUST_PRESENT,
                sum(case when va.moto_e_com_ind     in ('1','2','3','4','5','6','7','8','9')
                        then mtl.amt_billing else 0 end) CUST_NOT_PRESENT
            from acq_entity ae, mas_trans_log mtl, in_draft_main idm, visa_adn va
            where
                ae.institution_id = mtl.institution_id and
                ae.entity_id = mtl.entity_id and
                mtl.trans_sub_seq = '0' and
                mtl.tid like '0100030051%' and
                mtl.tid != '010003005102' and
                mtl.card_scheme = '04' and
                mtl.settl_flag = 'Y' and
                mtl.gl_date >= '01-$date_my' and mtl.gl_date < '01-$next_mnth_my' and
                mtl.external_trans_nbr = idm.trans_seq_nbr and
                va.trans_seq_nbr = mtl.external_trans_nbr
                and mtl.institution_id = '$inst'
            group by idm.MERCH_ID, ae.TAX_ID, idm.MCC
            order by idm.MERCH_ID, idm.MCC"

    orasql $cursor_C $qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {
        lappend details "$row(MERCH_ID),$row(TAX_ID),$row(MCC),$row(CUST_NOT_PRESENT),$row(CUST_PRESENT)"
        set TOT_CUST_NOT_PRESENT     [expr $TOT_CUST_NOT_PRESENT + $row(CUST_NOT_PRESENT)]
        set TOT_CUST_PRESENT         [expr $TOT_CUST_PRESENT + $row(CUST_PRESENT)]
    }

    set rep "FANF VISA QUARTERLY REPORTING\n\n"
    set rep "${rep}$date_my\n\n"
    set rep "${rep}Institution $inst\n\n\n"
    set rep "${rep}\nMerchant ID,Tax ID,MCC,Customer Not Present, Customer Present\n"

    foreach det $details {
        set rep "${rep}$det\n"
    }
    set rep "${rep},,,$TOT_CUST_NOT_PRESENT,$TOT_CUST_PRESENT\n"

    set filename "FANF.VISA.QUARTERLY.REPORTING.$date_my.$inst.csv"
    set cur_file [open "$filename" w]
    puts $cur_file $rep
    close $cur_file

    exec echo "Please see attached." | mutt -a $filename -s "$filename" -- "accounting@jetpay.com,reports-clearing@jetpay.com"
}

arg_parse

if {![info exists date_arg]} {
    #Runs previous month if no date arg is given
    init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]
} else {
    init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

if {$institutions_arg != ""} {
    puts "Running $argv0 for $institutions_arg $date_my"
    do_report $institutions_arg
} else {
    puts "Institution required.\nUsage: $argv0 -I nnn \[-D yyyymmdd\]"
}

oraclose $cursor_C
oralogoff $handleC
