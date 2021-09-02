#!/usr/local/bin/tclsh

################################################################################
# $Id: iso_billing.tcl 4709 2018-09-19 16:52:10Z lmendis $
# $Rev: 4709 $
################################################################################
#
#    File Name    - iso_billing.tcl
#
#    Description  - This is a custom monthly report for generating ISO Billing
#                   by card type.
#    Arguments   -i institution id
#                -f config file
#                -d Date to run the report, optional  e.g. 20140501
#                   This scripts can run with or without a date.  If no date
#                   provided it will run the report for the previous month.  With
#                   a date argument, the script will run the report for a given
#                   month.
#                -v verbose level
#
#    Note - requires GetOpts package from tclGetOpts1.1 to be in ~/MASCLRLIB
#
################################################################################

lappend auto_path $env(MASCLR_LIB)
package require GetOpts 1.1

source $env(MASCLR_LIB)/masclr_tcl_lib

###
# REPORT DATA FORMAT
###
#
# entity_dictionary
#        |______________entity_1
#        |                 |_______AgentID
#        |                 |_______EntityID
#        |                 |_______DBA Name
#        |                 |_______Name
#        |                 |_______ACH Count
#        |                 |_______...
#        |
#        |______________entity_2
#        |                 |_______AgentID
#        |                 |_______EntityID
#        |                 |_______DBA Name
#        |                 |_______Name
#        |                 |_______ACH Count
#        |                 |_______...
#        |
#        |______________entity_3
#        |                 |_______AgentID
#        |                 |_______EntityID
#        |                 |_______DBA Name
#        |                 |_______Name
#        |                 |_______ACH Count
#        |                 |_______...
#        .
#        .
#        .
###

#source $env(MASCLR_LIB)/masclr_tcl_lib

set mailto_error "clearing@jetpay.com"

global MODE
set MODE "PROD"
set MASCLR::DEBUG_LEVEL 0

## Global Variable ##
global programName

set programName [file tail $argv0]

##
# To add a new Column,
# 1). Add column_name and description to this list
# 2). Add query to set this column for each entity key in the dictionary
#
# The script will automatically init this value for each entity,
# calculate the subtotal for this column (if numeric 'n') and,
# output the data to the csv in the column order listed
###

set report_data_lst {
                    {SQL_INST "Institution" a}
                    {FILEDATE "Period" a}
                    {AGENT_ID "Agent ID" a}
                    {ENTITY_ID "Entity ID" a}
                    {DBA_NAME "DBA Name" a}
                    {NAME "Name" a}

                    {ACH_CNT "ACH Count" n}
                    {NET_SALES_AMT "Net Sales Amount" n}
                    {GROSS_SALES_AMT "Gross Sales Amount" n}
                    {SALES_CNT "Sales Count" n}
                    {SALES_REFUNDS "Sales Refunds" n}
                    {RETURNS_CNT "Returns Count" n}
                    {DISCOUNT "Discount Charged" n}
                    {FANF_FEES "FANF Fee Amount" n}
                    {CP_COUNT "Card Present Count" n}
                    {CP_AMOUNT "Card Present Amount" n}
                    {CNP_COUNT "Card Not Present Count" n}
                    {CNP_AMOUNT "Card Not Present Amount" n}
                    {CP_CNP_TOTAL_COUNT "TEMP COL CPCNP TOTAL" n}
                    {BILLING_TYPE "Billing Type" a}
                    {STMT_INTERCHANGE "Statement Interchange" n}
                    {REPRESENTMENT_AMT "Representments" n}
                    {CHARGEBK_AMT "Chargeback Amount" n}
                    {CHARGEBK_CNT "Chargeback Count" n}
                    {REPR_FOR_REIMBURSE_AMT "Representments for reimbursements" n}
                    {VS_ASSESS_AMT "Visa Assessments" n}
                    {VS_FEE_COLLCT "Visa Fee Collection" n}
                    {VS_ISA "Visa ISA Fee" n}
                    {MC_ASSESS_AMT "Mastercard Assessments" n}
                    {MC_FEE_COLLCT "Mastercard Fee Collection" n}
                    {AX_ASSESS_AMT "American Express Assessments" n}
                    {AX_FEE_COLLCT "American Express Fee Collection" n}
                    {DISC_III_I_SALES "Discover Sales" n}
                    {DISC_DISCOUNT_CHARGE "Discover Discount Charge" n}
                    {DISC_INTERCHANGE_AMT "Discover Interchange" n}
                    {DISC_DISPUTES "Discover Disputes" n}
                    {DISC_ASSESS_AMT "Discover Assessments" n}
                    {ARBITRATION_AMT "Arbitration Amount" n}
                    {RETRIEVAL_REQS "Retrieval Requests" n}
                    {AUTH_COUNTS "Auth Counts" n}
                    {DIALUP_TERM_COUNTS "Dialup Terminal Counts" n}
                    {DIALUP_TRANS_COUNTS "Dialup Transaction Counts" n}
                    {FRAUD_COUNT "Fraud Counts" n}
                    {TSYS_COUNTS "TSYS Counts" n}
                    {GET_REP_USERS "GetReporting User counts" n}
                    {DB_ASSESS_AMT "Debit Assessments" n}
                    {DEFAULT_MCC "MCC" a}
                    {CALC_INTERCHANGE "Calculated Interchange" n}
                    {RESIDUAL_INTERCHANGE "Residual Interchange" n}
                    {CASH_ADVANCE_CNT "Cash Advance Count" n}
                    {PCI_NON_COMP_FEE "PCI Fee" n}
                    {AVS_CHECK_CNT "AVS Check Count" n}
                    {AVS_CHECK_AMT "AVS Check Charge" n}
                    {CVV_CHECK_CNT "CVV Check Count" n}
                    {CVV_CHECK_AMT "CVV Check Charge" n}
                    {PROV_STATE_ABBREV "Location State" a}
                    }
###


proc  {} {
    global programName


    puts "Usage:   $programName \[ options \]... <arg>... "
    puts "     where <arg> is a filename or list of filenames "
    puts "     options: -d date (date must be YYYYMMDD) "
    puts "              -f configfile (the configuration file to use) "
    puts "                 (the default config file is $programName.cfg) "
    puts "              -m mode (set the mode, e.g., DEV, TEST, QA or PROD) "
    puts "              -v (verbosity, i.e., raises the debug level) "
    puts "              -h (help. displays this list) "
    exit 1
}

################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - Get the DB variables
#
#    Arguments -
#
#    Return -
#
###############################################################################

proc readCfgFile {} {
   global clr_db         auth_db        port_db

   global clr_db_logon   auth_db_logon  port_db_logon
   global Shortname_list argv inst sql_inst card_type institution_arg cfg_file_name

   set clr_db ""
   set clr_db_logon ""
   set auth_db ""
   set auth_db_logon ""
   set port_db ""
   set port_db_logon ""
   set inst_line ""

   if {[catch {open $cfg_file_name r} file_ptr]} {
        puts "File Open Err:Cannot open config file $cfg_file_name"
        exit 1
   }

   while { [set line [gets $file_ptr]] != {}} {
       set line_parms [split $line , ]
      switch -exact -- [lindex  $line_parms 0] {
         "CLR_DB_LOGON" {
            set clr_db_logon [lindex $line_parms 1]
         }
         "CLR_DB" {
            set clr_db [lindex $line_parms 1]
         }
         "AUTH_DB_LOGON" {
            set auth_db_logon [lindex $line_parms 1]
         }
         "AUTH_DB" {
            set auth_db [lindex $line_parms 1]
         }
         "PORT_DB_LOGON" {
            set port_db_logon [lindex $line_parms 1]
         }
         "PORT_DB" {
            set port_db [lindex $line_parms 1]
         }
         "SHORTNAME_LIST" {
            set Shortname_list [lindex $line_parms 1]
         }
         "INST_LINE" {
            set inst [lindex $line_parms 1]
            if { $sql_inst == $inst }  {
                 puts " inst: $inst"
                 set card_type [lindex $line_parms 2]
                 puts " card_type: $card_type "
            }
         }
         default {
            puts "Unknown config parameter [lindex $line_parms 0]"
         }
      }
   }

   close $file_ptr

   if {$clr_db_logon == ""} {
       puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }

   if {$auth_db_logon == ""} {
       puts "Unable to find AUTH_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }

   if {$port_db_logon == ""} {
       puts "Unable to find PORT_DB_LOGON params in $cfg_file_name, exiting..."
       exit 2
   }
}

##########################################
# connect_to_db
# handles connections to the database
##########################################

proc connect_to_db {} {
   global auth_db           clr_db           port_db
   global auth_db_logon     clr_db_logon     port_db_logon
   global auth_logon_handle mas_logon_handle port_logon_handle
   global cursor_A          cursor_C         cursor_GtReporting

   if {[catch {set auth_logon_handle [oralogon $auth_db_logon@$auth_db]} result] } {
        puts "Encountered error $result while trying to connect to AUTH_DB"
        exit 1
   } else {
        puts " Connected auth_db"
   }

   if {[catch {set mas_logon_handle [oralogon $clr_db_logon@$clr_db]} result] } {
        puts "Encountered error $result while trying to connect to CLR_DB"
        exit 1
   } else {
        puts " Connected clr_db"
   }

   if {[catch {set port_logon_handle [oralogon $port_db_logon@$port_db]} result] } {
        puts "Encountered error $result while trying to connect to PORT_DB"
        exit 1
   } else {
        puts " Connected port_db"
   }

   set cursor_A            [oraopen $auth_logon_handle]
   set cursor_C            [oraopen $mas_logon_handle]
   ### port must always be trnclr4
   set cursor_GtReporting  [oraopen $port_logon_handle]
}

proc arg_parse {} {
    global argv0 argv argc date_arg MODE debug
    global sql_inst cfg_file_name institution_arg
    global optind

    set sql_inst ""

    set cfg_file_name iso_billing.cfg

    MASCLR::log_message "argv0: $argv0, argv: $argv, argc: $argc" 1

    while { [ set err [ getopt $argv "d:f:hi:m:tv" opt optarg ]] } {
        if { $err < 0 } then {
            MASCLR::log_message "error: $argv0: opt $opt, optarg: $optarg "
            usage
            exit 1
        } else {
            MASCLR::log_message "opt: $opt, optarg: $optarg" 1
            switch -exact $opt {
                d {set date_arg  $optarg}
                f {set cfg_file_name $optarg}
                l {
                   set log_file $optarg
                   MASCLR::set_log_file_name $LOG_FILE
                   MASCLR::log_message "Report date is: $curdate"
                }
                i {set sql_inst $optarg}
                m {set MODE     $optarg}
                t {set MODE "TEST"}
                v {incr MASCLR::DEBUG_LEVEL}
                h {
                    usage
                    exit 1
                }
            }
        }
    }

    set argv [ lrange $argv $optind end ]
    set institution_arg $sql_inst

    MASCLR::log_message "MODE: $MODE, DEBUG_LEVEL $MASCLR::DEBUG_LEVEL"
    MASCLR::log_message "sql_inst: $sql_inst, institution_arg $institution_arg"
}

proc init_dates {val} {
    global date date_my filedate next_mnth_my CUR_JULIAN_DATEX date_strt_frontend next_mnth_frontend

    set date        [string toupper [clock format [clock scan "$val"] -format %d-%b-%Y]]
    set date_my     [string toupper [clock format [clock scan " $date -0 day"] -format %b-%Y]]                 ;# MAR-2012
    set next_mnth_my        [string toupper [clock format [clock scan "01-$date_my +1 month"] -format %b-%Y]]  ;# APR-2012
    set date_strt_frontend  [clock format [clock scan "01-$date_my -0 day"] -format %Y%m%d%H%M%S]    ;# 20120809204501
    set next_mnth_frontend  [clock format [clock scan "01-$date_my +1 month"] -format %Y%m%d%H%M%S]  ;# 20120809204501
    set filedate            [clock format [clock scan " $date -0 day"] -format %Y%m]                 ;# 20080321

    formatted_puts "Running for month: $date_my"
    formatted_puts "Start Date: 01-$date_my"
    formatted_puts "End Date:   01-$next_mnth_my"
}

proc formatted_puts {str} {
    ## puts "[clock format [clock seconds] -format %Y%m%d%H%M%S] - $str"
    MASCLR::log_message "$str"
}

proc do_report {} {
    global cursor_C cursor_A cursor_GtReporting
    global date_my next_mnth_my institution_arg filedate report_data_lst
    global date_strt_frontend next_mnth_frontend
    global inst card_type rpt_type

    set sql_inst $institution_arg

    switch $rpt_type {
        ALL {
              # report will include all crad types
              set v_card_scheme    "'02', '03', '04', '05', '08'"
              set v_card_type      "'DB', 'AX', 'VS', 'MC', 'DS'"
              set card_type_00     "'00', " }
        00  {
              # report will show all fees not related to card types e.g.
              # pci compliance or get-reporting fees
              set v_card_scheme    "'00'"
              set v_card_type      "'xxx'"
              set card_type_00     ""      }
        DB  {
              set v_card_scheme    "'02'"
              set v_card_type      "'DB'"
              set card_type_00     ""      }
        AX  {
              set v_card_scheme    "'03'"
              set v_card_type      "'AX'"
              set card_type_00     ""      }
        VS  {
              set v_card_scheme    "'04'"
              set v_card_type      "'VS'"
              set card_type_00     ""      }
        MC  {
              set v_card_scheme    "'05'"
              set v_card_type      "'MC'"
              set card_type_00     ""      }
        DS  {
              set v_card_scheme    "'08'"
              set v_card_type      "'DS'"
              set card_type_00     ""      }
   default {
              # Correct Comment Placement
              set v_card_scheme    "'02', '03', '04', '05', '08'"
              set v_card_type      "'DB', 'AX', 'VS', 'MC', 'DS'"
              set card_type_00     "'00', " }
}

    set v_request_type_1 "'0100', '0200', '0220', '0270', '0400', '0402', '0440', '0480'"
    set v_request_type_2 "'0100', '0200', '0220', '0250', '0270', '0400', '0402', '0420'"

    # set entity_qry  "
        # select '$sql_inst' sql_inst, '$filedate' filedate, Entity_id, Entity_dba_Name, Entity_Name, institution_id, billing_type, default_mcc
        # from MASCLR.acq_entity
        # where institution_id in ('$sql_inst')
          # and ((entity_status = 'A')  or (entity_status = 'C' and (termination_date-90)  > '01-$date_my'))
        # order by entity_id"

    # set entity_qry  "
        # select '$sql_inst' sql_inst, '$filedate' filedate, ae.Entity_id, ae.Entity_dba_Name, ae.Entity_Name,
        # ae.institution_id, ae.billing_type, ae.default_mcc, NVL(ma.PROV_STATE_ABBREV, NULL) as PROV_STATE_ABBREV
        # from MASCLR.acq_entity ae
        # JOIN ACQ_ENTITY_ADDRESS aea
        # ON aea.INSTITUTION_ID = ae.INSTITUTION_ID AND aea.ENTITY_ID = ae.ENTITY_ID
           # AND aea.ADDRESS_ROLE = 'LOC'
        # JOIN MASTER_ADDRESS ma
        # ON ma.INSTITUTION_ID = aea.INSTITUTION_ID AND ma.ADDRESS_ID = aea.ADDRESS_ID
        # where ae.institution_id in ('$sql_inst')
          # and ((ae.entity_status = 'A')  or (ae.entity_status = 'C' and (ae.termination_date-90)  > '01-$date_my'))
        # order by ae.entity_id"

    set entity_qry  "
        SELECT '$sql_inst' sql_inst, '$filedate' filedate, ae.Entity_id, ae.Entity_dba_Name, ae.Entity_Name,
            ae.institution_id, ae.billing_type, ae.default_mcc, NVL(aea_ma.PROV_STATE_ABBREV, NULL) as PROV_STATE_ABBREV
        FROM MASCLR.acq_entity ae,
            (SELECT DISTINCT aea.institution_id, aea.Entity_id, ma.PROV_STATE_ABBREV
                FROM ACQ_ENTITY_ADDRESS aea
                JOIN MASTER_ADDRESS ma
                    ON ma.INSTITUTION_ID = aea.INSTITUTION_ID AND ma.ADDRESS_ID = aea.ADDRESS_ID
                WHERE aea.institution_id IN ('$sql_inst')
                    AND aea.ADDRESS_ROLE = 'LOC'
                    AND aea.institution_id = ma.INSTITUTION_ID
                    AND aea.address_id = ma.address_id) aea_ma
        WHERE ae.institution_id IN ('$sql_inst')
            AND ((ae.entity_status = 'A')  OR (ae.entity_status = 'C' AND (ae.termination_date-90)  > '01-$date_my'))
            AND ae.institution_id = aea_ma.institution_id
            AND ae.Entity_id = aea_ma.Entity_id
        ORDER BY ae.Entity_id"

    formatted_puts "Fetching active merchant list"
    MASCLR::log_message "entity_qry : $entity_qry" 3

    orasql $cursor_C $entity_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique "$row(INSTITUTION_ID).$row(ENTITY_ID)"

        # INITIALIZE THIS ENTITY's DICTIONARY DATA
        # Basically, we set all numeric (n) data types defined above in report_data_lst to 0

        foreach col $report_data_lst {
            if {[lindex $col 2] == "n"} {
                    dict set entity_dictionary $unique [lindex $col 0] 0
            } else {
                dict set entity_dictionary $unique [lindex $col 0] ""
            }
        }

        dict set entity_dictionary $unique DBA_NAME     [string map {"," "."} $row(ENTITY_DBA_NAME)]
        dict set entity_dictionary $unique NAME         [string map {"," "."} $row(ENTITY_NAME)]
        dict set entity_dictionary $unique DEFAULT_MCC  $row(DEFAULT_MCC)
        dict set entity_dictionary $unique BILLING_TYPE $row(BILLING_TYPE)
        dict set entity_dictionary $unique ENTITY_ID    $row(ENTITY_ID)
        dict set entity_dictionary $unique AGENT_ID     [string range $row(ENTITY_ID) 7 10]
        dict set entity_dictionary $unique SQL_INST     $row(SQL_INST)
        dict set entity_dictionary $unique FILEDATE     $row(FILEDATE)
        dict set entity_dictionary $unique PROV_STATE_ABBREV $row(PROV_STATE_ABBREV)
    }

    #Create a final dictionary for subtotals
    #Initialize all fields of dictionary

    foreach col $report_data_lst {
        if {[lindex $col 2] == "n"} {
            dict set totals_dictionary [lindex $col 0] 0
        } else {
            dict set totals_dictionary [lindex $col 0] ""
        }
    }


    ###
    # Get frontend mids needed later for all auth queries
    # This list is divided into groups of less than 1000
    ###

    set ent_to_auth_qry "
        select institution_id, entity_id, mid
        from entity_to_auth
        where institution_id in ('$sql_inst')"

    set mids(0) ""
    set mid_lst_indx 0
    set cur_indx_in_lst 0

    MASCLR::log_message "ent_to_auth_qry : $ent_to_auth_qry" 3

    orasql $cursor_C $ent_to_auth_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        lappend mids($mid_lst_indx) $row(MID)

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        #This will be used later to link mids to their entity for the report
        set mid_to_entity($row(MID)) $unique

        #We limit the count of mids per var below 1000
        #Oracle complains if the <where foo in ('1', '2'...)
        #contains more than 1000 elements>

        if {$cur_indx_in_lst >= 999} {

            incr mid_lst_indx
            set cur_indx_in_lst 0
        } else {
            incr cur_indx_in_lst
        }
    }

    formatted_puts "Fetching sales data"

    # set IS_SALES "'010003005101', '010003005102', '010003005103', '010003005104',
    #               '010003005201', '010003005202', '010003005203', '010003005204'"

    set sales_qry "
        select mtl.entity_id, mtl.institution_id,
               sum(case when ta.major_cat = 'SALES' then mtl.amt_original *
                            case when mtl.tid_settl_method = 'C' then 1 else -1 end
                        else 0 end)                                                     as sales_amt,
               sum(case when ta.major_cat = 'REFUNDS'
                        then mtl.amt_original *
                            case when mtl.tid_settl_method = 'C' then 1 else -1 end
                        else 0 end)                                                     as returns_amt,
               sum(case when ta.major_cat = 'SALES'   then mtl.nbr_of_items else 0 end) as Sales_Count,
               sum(case when ta.major_cat = 'REFUNDS' then mtl.nbr_of_items else 0 end) as Returns_Count
        FROM masclr.mas_trans_log mtl
        join tid_adn ta
        on ta.tid = mtl.tid
        WHERE ta.major_cat in ('SALES', 'REFUNDS')
          and mtl.gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and mtl.card_scheme in ($v_card_scheme)
          and mtl.settl_flag = 'Y'
          and mtl.institution_id in ('$sql_inst')
        group by mtl.entity_id, mtl.institution_id
        order by mtl.entity_id
        "

    MASCLR::log_message "sales_qry : $sales_qry" 3

    orasql $cursor_C $sales_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        #Ignore any query result that don't belong to our active merchant list
        if {[dict exists $entity_dictionary $unique]} {

            dict set entity_dictionary $unique NET_SALES_AMT    [expr $row(SALES_AMT) + $row(RETURNS_AMT)]
            dict set entity_dictionary $unique GROSS_SALES_AMT  $row(SALES_AMT)
            dict set entity_dictionary $unique SALES_CNT        $row(SALES_COUNT)
            dict set entity_dictionary $unique RETURNS_CNT      $row(RETURNS_COUNT)
            dict set entity_dictionary $unique SALES_REFUNDS    $row(RETURNS_AMT)
        }
    }

    formatted_puts "Fetching card present/card not present"

    # set IS_SALES "'010003005101', '010003005102', '010003005103', '010003005104',
    #               '010003005201', '010003005202', '010003005203', '010003005204'"

    # TODO change inner join on in_draft_main to outer join and
    # TODO make all PID debit card present
    set presentNotpresent_qry "SELECT mtl.institution_id, mtl.entity_id,
               SUM(CASE WHEN ( i.pos_crd_present = 1)
                        Then case when mtl.tid_settl_method = 'C'
                            then 1 else -1 end * mtl.amt_original
                        else 0 end)                                 AS CP_AMOUNT,
               SUM(CASE WHEN (i.pos_crd_present <> 1
                              or i.pos_crd_present is null )
                        Then case when mtl.tid_settl_method = 'C'
                            then 1 else -1 end * mtl.amt_original
                        else 0 end)                                 AS CNP_AMOUNT,
               SUM(CASE WHEN (i.pos_crd_present = 1)
                        Then mtl.nbr_of_items else 0 end )          AS CP_COUNT,
               SUM(CASE WHEN (i.pos_crd_present <> 1
                              or i.pos_crd_present is null )
                        Then mtl.nbr_of_items else 0 end )          AS CNP_COUNT,
               sum(mtl.nbr_of_items) AS CP_CNP_TOTAL_COUNT
        FROM masclr.mas_trans_log mtl
        join tid_adn ta
        on ta.tid = mtl.tid
        join masclr.in_draft_main i
        on trim(mtl.external_trans_nbr) = to_char(i.trans_seq_nbr)
            and mtl.trans_ref_data = i.arn
        WHERE ta.major_cat in ('SALES')
          and mtl.institution_id in ('$sql_inst')
          and mtl.trans_sub_seq = 0
          and mtl.gl_date >= '01-$date_my' and mtl.gl_date < '01-$next_mnth_my'
          and mtl.settl_flag = 'Y'
          and mtl.card_scheme in ('02', '03', '04', '05', '08')
        group by mtl.institution_id, mtl.entity_id"

    #"
    #    SELECT mtl.institution_id, mtl.entity_id,
    #           SUM(CASE WHEN ( i.pos_crd_present = '1')
    #                    Then case when mtl.tid_settl_method = 'C'
    #                        then 1 else -1 end * mtl.amt_original
    #                    else 0 end)                                 AS CP_AMOUNT,
    #           SUM(CASE WHEN (i.pos_crd_present <> '1'
    #                          or i.pos_crd_present is null )
    #                    Then case when mtl.tid_settl_method = 'C'
    #                        then 1 else -1 end * mtl.amt_original
    #                    else 0 end)                                 AS CNP_AMOUNT,
    #           SUM(CASE WHEN (i.pos_crd_present = '1')
    #                    Then mtl.nbr_of_items else 0 end )          AS CP_COUNT,
    #           SUM(CASE WHEN (i.pos_crd_present <> '1'
    #                          or i.pos_crd_present is null )
    #                    Then mtl.nbr_of_items else 0 end )          AS CNP_COUNT,
    #           sum(mtl.nbr_of_items) AS CP_CNP_TOTAL_COUNT
    #    FROM masclr.mas_trans_log mtl
    #    join tid_adn ta
    #    on ta.tid = mtl.tid
    #    join masclr.in_draft_main i
    #    on to_number(mtl.external_trans_nbr) = (i.trans_seq_nbr)
    #    and mtl.trans_ref_data = i.arn
    #    WHERE ta.major_cat in ('SALES')
    #      and mtl.institution_id in ('$sql_inst')
    #      and mtl.trans_sub_seq = '0'
    #      and mtl.gl_date >= '01-$date_my' and mtl.gl_date < '01-$next_mnth_my'
    #      and mtl.settl_flag = 'Y'
    #      and mtl.card_scheme in ($v_card_scheme)
    #    group by mtl.institution_id, mtl.entity_id"


    MASCLR::log_message "presentNotpresent_qry : $presentNotpresent_qry" 3

    orasql $cursor_C $presentNotpresent_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        #Ignore any query result that don't belong to our active merchant list
        if {[dict exists $entity_dictionary $unique]} {

            dict set entity_dictionary $unique CP_AMOUNT    $row(CP_AMOUNT)
            dict set entity_dictionary $unique CNP_AMOUNT   $row(CNP_AMOUNT)
            dict set entity_dictionary $unique CP_COUNT     $row(CP_COUNT)
            dict set entity_dictionary $unique CNP_COUNT    $row(CNP_COUNT)
            dict set entity_dictionary $unique CP_CNP_TOTAL_COUNT $row(CP_CNP_TOTAL_COUNT)
        }
    }

    formatted_puts "Fetching ACH Counts"

    #Probably need to move this inside some other qry that uses acct_accum_detail

    set ach_cnt_qry "
        SELECT ea.institution_id, ea.owner_entity_id ENTITY_ID, COUNT(1) AS ACH_CNT
        FROM masclr.acct_accum_det a, masclr.entity_acct ea
        WHERE (ea.entity_acct_id = a.entity_acct_id and ea.institution_id = a.institution_id)
          and a.payment_status = 'P'
          and a.institution_id in ('$sql_inst')
          and a.payment_proc_dt >= '01-$date_my' and a.payment_proc_dt < '01-$next_mnth_my'
        GROUP BY ea.institution_id, ea.owner_entity_id"

    MASCLR::log_message "ach_cnt_qry : $ach_cnt_qry" 3

    orasql $cursor_C $ach_cnt_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique ACH_CNT $row(ACH_CNT)
        }
    }

    formatted_puts "Fetching Cash Advance Transaction Count"

    # TODO set tid_adn.minor_cat to CASHBACK on these TID values
    set IS_CASHBACK "'010003005103', '010003005105', '010003005121',
                     '010003005203', '010003005205', '010003005221'"

    set cash_adv_cnt_qry "
        SELECT institution_id, entity_id,
               SUM(case when tid in ($IS_CASHBACK) then 1 else 0 end) as CASH_ADVANCE_CNT
        FROM masclr.mas_trans_log
        WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
           and card_scheme in ($v_card_scheme)
           and institution_id in ('$sql_inst')
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "cash_adv_cnt_qry : $cash_adv_cnt_qry" 3

    orasql $cursor_C $cash_adv_cnt_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique CASH_ADVANCE_CNT $row(CASH_ADVANCE_CNT)
        }
    }

    formatted_puts "Fetching Assessments"

    # TODO use tid_adn with minor_cat ASSESSMENT
    set assess_qry "
        SELECT institution_id, entity_id,
               sum(case when (tid_settl_method <> 'C' and card_scheme = '02')
                        then amt_original
                        when (tid_settl_method  = 'C' and card_scheme = '02')
                        then amt_original * -1 else 0 end) as DB_ASSESS_AMT,

               sum(case when (tid_settl_method <> 'C' and card_scheme = '03')
                        then amt_original
                        when (tid_settl_method  = 'C' and card_scheme = '03')
                        then amt_original * -1 else 0 end) as AX_ASSESS_AMT,

               sum(case when (tid_settl_method <> 'C' and card_scheme = '04')
                        then amt_original
                        when (tid_settl_method  = 'C' and card_scheme = '04')
                        then amt_original * -1 else 0 end) as VS_ASSESS_AMT,

               sum(case when (tid_settl_method <> 'C' and card_scheme = '05')
                        then amt_original
                        when (tid_settl_method  = 'C' and card_scheme = '05')
                        then amt_original * -1 else 0 end) as MC_ASSESS_AMT,

               sum(case when (tid_settl_method <> 'C' and card_scheme = '08')
                        then amt_original
                        when (tid_settl_method  = 'C' and card_scheme = '08')
                        then amt_original * -1 else 0 end) as DS_ASSESS_AMT

        FROM masclr.mas_trans_log
        WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
           and tid in ( '010004030000' , '010004030005', '010004030001')
           and card_scheme in ($v_card_scheme)
           and institution_id in ('$sql_inst')
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "assess_qry : $assess_qry" 3

    orasql $cursor_C $assess_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {

            dict set entity_dictionary $unique DISC_ASSESS_AMT  $row(DS_ASSESS_AMT)
            dict set entity_dictionary $unique VS_ASSESS_AMT    $row(VS_ASSESS_AMT)
            dict set entity_dictionary $unique MC_ASSESS_AMT    $row(MC_ASSESS_AMT)
            dict set entity_dictionary $unique AX_ASSESS_AMT    $row(AX_ASSESS_AMT)
            dict set entity_dictionary $unique DB_ASSESS_AMT    $row(DB_ASSESS_AMT)
        }
    }

    formatted_puts "Fetching Disc MAP_Phase I & III"

    # TODO uset tid_adn instead of individual tid values
    # set IS_MERCH_FEE "(substr(m.tid, 1, 8) = '01000507' OR substr(m.tid, 1, 6) in ('010004'))"
    # set IS_DISPUTE "m.tid in ('010003005301', '010003005401', '010003015201', '010003015102', '010003015101')"
    # set IS_INTERCHANGE "
        # '010004020000', '010004020001', '010004020005', '010004720000',
        # '010004720001', '010004720005', '010004720010', '010004720015',
        # '010004720020', '010004720025', '010004720030', '010004720035',
        # '010004720040', '010004720045', '010004720050', '010004720055',
        # '010004720060', '010004720065'"

    # set disc_sales_qry "
        # SELECT m.entity_id, m.institution_id,
              # ( SUM( CASE WHEN m.tid_settl_method = 'C' and ta.major_cat in ('SALES')
                          # then m.AMT_ORIGINAL else 0 end )
              # - SUM( CASE WHEN m.tid_settl_method = 'D' and ta.major_cat in ('SALES')
                          # then m.AMT_ORIGINAL else 0 end)) as DISC_III_I_SALES,
              # ( SUM( CASE WHEN( $IS_MERCH_FEE and m.tid_settl_method = 'D')
                          # then m.AMT_ORIGINAL else 0 end )
              # - SUM( CASE WHEN( $IS_MERCH_FEE and m.tid_settl_method = 'C')
                          # then m.AMT_ORIGINAL else 0 end )) as DISCOUNT_CHARGE,
              # ( SUM( CASE WHEN( m.tid in ($IS_INTERCHANGE) and m.tid_settl_method = 'D' )
                          # then m.AMT_ORIGINAL else 0 end)
              # - SUM( CASE WHEN( m.tid in ($IS_INTERCHANGE) and m.tid_settl_method = 'C' )
                          # then m.AMT_ORIGINAL else 0 end)) as INTERCHANGE_AMT,
                # SUM( CASE WHEN m.tid_settl_method = 'D'
                            # and ta.major_cat in ('DISPUTES')  then m.AMT_ORIGINAL else 0 end) as DISC_DISPUTES
        # FROM mas_trans_log m
        # join acq_entity ae
             # on (m.entity_id = ae.entity_id and m.institution_id = ae.institution_id)
        # join merchant_flag mf
             # on (m.entity_id = mf.entity_id and m.institution_id = mf.institution_id)
        # left outer join tid_adn ta
             # on ta.tid = m.tid
        # WHERE m.institution_id in ('$sql_inst')
          # and m.card_scheme = '08'
          # and (mf.flag_type = 'MAP_PHASE3' or (mf.flag_type = 'MAP_PHASE1' and ae.creation_date < '01-MAY-2010'))
          # and m.gl_date >= '01-$date_my' and m.gl_date < '01-$next_mnth_my'
          # and (ta.major_cat in ('SALES', 'DISPUTES') OR $IS_MERCH_FEE )
          # and substr(m.tid, 0, 8) <> '01000428'
        # GROUP BY m.entity_id, m.institution_id"

    set disc_sales_qry "
        SELECT m.entity_id, m.institution_id,
             SUM(m.calc_amount) calc_amt,
             SUM(m.amount) amt,
             SUM(CASE WHEN m.major_cat IN ('SALES')       THEN m.calc_amount ELSE 0 END) AS DISC_III_I_SALES,
             SUM(CASE WHEN m.major_cat IN ('FEES')        THEN -m.calc_amount ELSE 0 END) AS DISCOUNT_CHARGE,
             SUM(CASE WHEN m.minor_cat IN ('INTERCHANGE') THEN -m.calc_amount ELSE 0 END) AS INTERCHANGE_AMT,
             SUM(CASE WHEN m.major_cat IN ('DISPUTES')    THEN -m.calc_amount ELSE 0 END) AS DISC_DISPUTES
        FROM mas_trans_view m
        JOIN acq_entity ae
             ON (m.entity_id = ae.entity_id AND m.institution_id = ae.institution_id)
        LEFT OUTER JOIN merchant_flag mf
             ON (m.entity_id = mf.entity_id AND m.institution_id = mf.institution_id)
        WHERE
             m.institution_id IN ('$sql_inst')
             AND (mf.flag_type = 'MAP_PHASE3' OR (mf.flag_type = 'MAP_PHASE1' AND ae.creation_date < '01-MAY-2010'))
             AND m.gl_date >= '01-$date_my' AND m.gl_date < '01-$next_mnth_my'
             AND (m.major_cat IN ('SALES', 'DISPUTES', 'FEES' ) )
             AND nvl(m.minor_cat,0) != 'ACH'
             AND m.entity_id = ae.ENTITY_ID
             AND m.card_scheme = '08'
        GROUP BY m.entity_id, m.institution_id"

    MASCLR::log_message "disc_sales_qry : $disc_sales_qry" 3

    orasql $cursor_C $disc_sales_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {

            dict set entity_dictionary $unique DISC_III_I_SALES     $row(DISC_III_I_SALES)
            dict set entity_dictionary $unique DISC_DISCOUNT_CHARGE $row(DISCOUNT_CHARGE)
            dict set entity_dictionary $unique DISC_INTERCHANGE_AMT $row(INTERCHANGE_AMT)
            dict set entity_dictionary $unique DISC_DISPUTES        $row(DISC_DISPUTES)
        }
    }

    formatted_puts "Fetching Arbitration amounts"

    # TODO uset tid_adn instead of individual tid values
    set IS_ARB "tid IN ('010003010101', '010003010102')"

    set arb_qry "
        select institution_id, entity_id,
               sum(CASE WHEN tid_settl_method = 'C' then amt_original
                   else amt_original* -1 end) as ARB_AMT
        FROM mas_trans_log
        WHERE $IS_ARB
          and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and institution_id in ('$sql_inst')
          and card_scheme in ($v_card_scheme)
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "arb_qry : $arb_qry" 3

    orasql $cursor_C $arb_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique ARBITRATION_AMT $row(ARB_AMT)
        }
    }

    formatted_puts "Fetching Visa ISA"

    # TODO uset tid_adn instead of individual tid values
    set vs_isa_qry "
        select institution_id, entity_id, sum(amt_original) as VS_ISA_AMT
        FROM mas_trans_log
        WHERE tid = '010004330000'
          and mas_code = 'VS_ISA_FEE'
          and institution_id in ('$sql_inst')
          and ((gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my') or
               (date_to_settle >= '01-$date_my' and date_to_settle < '01-$next_mnth_my'))
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "vs_isa_qry : $vs_isa_qry" 3

    orasql $cursor_C $vs_isa_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique VS_ISA $row(VS_ISA_AMT)
        }
    }

    formatted_puts "Fetching PCI Non-Compliance Fee"

    set pci_fee_qry "
        select institution_id, entity_id, sum(amt_original) as PCI_FEE
        FROM mas_trans_log
        WHERE  mas_code = '00PCINONCOMP'
          and institution_id in ('$sql_inst')
          and ((gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my') or
               (date_to_settle >= '01-$date_my' and date_to_settle < '01-$next_mnth_my'))
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "pci_fee_qry : $pci_fee_qry" 3

    orasql $cursor_C $pci_fee_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique PCI_NON_COMP_FEE $row(PCI_FEE)
        }
    }

    formatted_puts "Fetching Visa and MC Fee Collection"

    # TODO uset tid_adn instead of individual tid values
    set fee_collct_qry "
        SELECT institution_id, entity_id,
               SUM( CASE WHEN SUBSTR(mas_code, 1, 2) = 'MC' then amt_original else 0 END) AS MC_FEE_COLLCT,
               SUM( CASE WHEN SUBSTR(mas_code, 1, 2) = 'VS' then amt_original else 0 END) AS VS_FEE_COLLCT
        FROM mas_trans_log
        WHERE mas_code IN ('MC_BORDER', 'MC_GLOBAL_ACQ', 'VS_ISA_FEE', 'VS_ISA_HI_RISK_FEE', 'VS_INT_ACQ_FEE')
          and (substr(tid, 1, 8) = '01000507' OR substr(tid, 1, 6) in ('010004', '010040', '010050', '010080', '010014'))
          and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and institution_id in ('$sql_inst')
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "fee_collct_qry : $fee_collct_qry" 3

    orasql $cursor_C $fee_collct_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique VS_FEE_COLLCT $row(VS_FEE_COLLCT)
            dict set entity_dictionary $unique MC_FEE_COLLCT $row(MC_FEE_COLLCT)
        }
    }

    formatted_puts "Fetching Representments"

    # TODO uset tid_adn instead of individual tid values
    set repr_qry "
        SELECT institution_id, entity_id,
               sum(CASE WHEN( tid in ('010003005301', '010003005401') and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL
                        WHEN( tid in ('010003005301', '010003005401') and TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL
                        else 0 end) as REPRESENTMENT_AMT,
               sum(CASE WHEN( tid in ('010003010102', '010003010101') and TID_SETTL_METHOD = 'C') then AMT_ORIGINAL
                        WHEN( tid in ('010003010102', '010003010101') and TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL
                        else 0 end) as REPR_FOR_REIMBURSE_AMT
        FROM mas_trans_log
        WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and settl_flag = 'Y'
          and institution_id in ('$sql_inst')
          and TID in ('010003005301', '010003005401', '010003010102', '010003010101')
          and card_scheme in ($v_card_scheme)
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "repr_qry : $repr_qry" 3

    orasql $cursor_C $repr_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique REPRESENTMENT_AMT        $row(REPRESENTMENT_AMT)
            dict set entity_dictionary $unique REPR_FOR_REIMBURSE_AMT   $row(REPR_FOR_REIMBURSE_AMT)
        }
    }

    formatted_puts "Fetching Chargebacks"

    # TODO uset tid_adn instead of individual tid values
    set IS_CHRGBK "TID in ('010003010101', '010003010102', '010003015101', '010003015102', '010003015201', '010003015210', '010003015301')"

    set chrgbk_qry "
        SELECT institution_id, entity_id,
               sum(CASE WHEN( TID_SETTL_METHOD = 'C') then AMT_ORIGINAL
                        WHEN( TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL else 0 end) as CHARGEBK_AMT,
               SUM(case when amt_original <> 0 then 1 else 0 end) as CHARGEBK_CNT
        FROM masclr.mas_trans_log
        WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and $IS_CHRGBK
          and institution_id in ('$sql_inst')
          and card_scheme in ($v_card_scheme)
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "chrgbk_qry : $chrgbk_qry" 3

    orasql $cursor_C $chrgbk_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique CHARGEBK_AMT $row(CHARGEBK_AMT)
            dict set entity_dictionary $unique CHARGEBK_CNT $row(CHARGEBK_CNT)
        }
    }

    formatted_puts "Fetching Discount"

    # TODO uset tid_adn instead of individual tid values
    set discnt_qry "
        SELECT institution_id, entity_id,
               sum(CASE WHEN m.tid_settl_method = 'D'  then m.AMT_billing
                        WHEN m.tid_settl_method <> 'D' then -1*m.AMT_billing else 0 end) as DISCOUNT
        FROM masclr.mas_trans_log m
        WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and (substr(m.tid, 1, 8) = '01000507' OR substr(m.tid, 1, 6) in ('010004', '010040', '010050', '010080', '010014'))
          and substr(m.tid, 1, 8) <> '01000428'
          and institution_id in ('$sql_inst')
          and m.card_scheme in ($card_type_00$v_card_scheme)
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "discnt_qry : $discnt_qry" 3

    orasql $cursor_C $discnt_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique DISCOUNT $row(DISCOUNT)
        }
    }

    formatted_puts "Fetching FANF"

    set fanf_qry "
        SELECT institution_id, entity_id,
               sum(CASE WHEN (TID_SETTL_METHOD = 'C') then AMT_ORIGINAL
                        WHEN(TID_SETTL_METHOD <> 'C') then -1*AMT_ORIGINAL else 0 end) as FANF_FEES
        FROM masclr.mas_trans_log
        WHERE gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and settl_flag = 'Y'
          and institution_id in ('$sql_inst')
          and substr(mas_code, 1, 4) = 'FANF'
        GROUP BY institution_id, entity_id"

    MASCLR::log_message "fanf_qry : $fanf_qry" 3

    orasql $cursor_C $fanf_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique FANF_FEES $row(FANF_FEES)
        }
    }

    formatted_puts "Fetching Interchange"

    # TODO uset tid_adn instead of individual tid values
    # set interchg_qry "
        # select institution_id, gl_month, entity_id, entity_dba_name, billing_type,
               # sum(CALC_INTERCHANGE) CALC_INTERCHANGE,
               # sum(STMT_INTERCHANGE) STMT_INTERCHANGE,
               # sum(case when STMT_INTERCHANGE = 0
                        # then CALC_INTERCHANGE
                        # else STMT_INTERCHANGE end) RESIDUAL_INTERCHANGE
        # from
             # ( select mtl.institution_id,
                      # trunc(mtl.gl_date, 'MM') gl_month,
                      # mtl.entity_id, ae.entity_dba_name, ae.billing_type, mtl.card_scheme,
                      # sum( case when ( mtl.tid_settl_method ='D') then  1
                                # when ( mtl.tid_settl_method ='C') then -1
                                # else 0 end * mtl.amt_original) as CALC_INTERCHANGE,
                      # sum( case when ( mtl.tid_settl_method ='D') then  1
                                # when ( mtl.tid_settl_method ='C') then -1
                                # else 0 end * mtl.amt_billing) as STMT_INTERCHANGE
               # from masclr.mas_trans_log mtl, MASCLR.acq_entity ae
               # where mtl.posting_entity_id = ae.entity_id
                 # and mtl.institution_id = ae.institution_id
                 # and mtl.gl_date >=  '01-$date_my' and mtl.gl_date < '01-$next_mnth_my'
                 # and mtl.tid in ($IS_INTERCHANGE)
                 # and mtl.card_scheme in ($v_card_scheme)
                 # and mtl.institution_id in ('$sql_inst')
               # group by mtl.institution_id, trunc(mtl.gl_date, 'MM'),
                        # mtl.entity_id, ae.entity_dba_name, ae.billing_type, mtl.card_scheme
             # )
        # group by institution_id, gl_month, entity_id, entity_dba_name, billing_type
        # order by institution_id, entity_id, billing_type"

    # Query without the inner query
    # set interchg_qry "
        # SELECT m.institution_id AS institution_id, trunc(m.gl_date, 'MM') AS gl_month,
             # m.entity_id AS entity_id, ae.entity_dba_name AS entity_dba_name,
             # ae.billing_type AS billing_type,
             # SUM(case when m.tid_settl_method = 'C' then 1 else -1 end * m.calc_amount) AS CALC_INTERCHANGE,
             # SUM(case when m.tid_settl_method = 'C' then 1 else -1 end * m.amount) AS STMT_INTERCHANGE,
                 # (case when (SUM(case when m.tid_settl_method = 'C' then 1 else -1 end * m.amount)) = 0
                           # then (SUM(case when m.tid_settl_method = 'C' then 1 else -1 end * m.calc_amount))
                       # else (SUM(case when m.tid_settl_method = 'C' then 1 else -1 end * m.amount)) end) AS RESIDUAL_INTERCHANGE
        # FROM mas_trans_view m
            # JOIN acq_entity ae
                # ON (m.entity_id = ae.entity_id AND m.institution_id = ae.institution_id)
        # WHERE
            # m.posting_entity_id = ae.ENTITY_ID
            # AND m.institution_id = ae.institution_id
            # AND m.gl_date >= '01-$date_my' AND m.gl_date < '01-$next_mnth_my'
            # AND m.major_cat IN ('FEES')
            # AND m.minor_cat IN ('INTERCHANGE')
            # AND m.card_scheme IN ($v_card_scheme)
            # AND m.institution_id IN ('$sql_inst')
        # GROUP BY m.institution_id, trunc(m.gl_date, 'MM'), m.entity_id, ae.entity_dba_name, ae.billing_type
        # ORDER BY m.institution_id, m.entity_id, ae.billing_type"

    # Query with the inner query
    set interchg_qry "
        SELECT institution_id, gl_month, entity_id, entity_dba_name, billing_type,
            SUM(CALC_INTERCHANGE) CALC_INTERCHANGE,
            SUM(STMT_INTERCHANGE) STMT_INTERCHANGE,
            SUM(case when STMT_INTERCHANGE = 0 then CALC_INTERCHANGE else STMT_INTERCHANGE end) RESIDUAL_INTERCHANGE
        FROM
           (SELECT m.institution_id as institution_id, trunc(m.gl_date, 'MM') as gl_month, m.entity_id as entity_id,
                ae.entity_dba_name as entity_dba_name, ae.billing_type as billing_type,
                SUM(case when m.tid_settl_method = 'C' then 1 else -1 end * m.calc_amount) as CALC_INTERCHANGE,
                SUM(case when m.tid_settl_method = 'C' then 1 else -1 end * m.amount) as STMT_INTERCHANGE
            FROM mas_trans_view m
                    -- JOIN acq_entity ae ON (m.entity_id = ae.entity_id AND m.institution_id = ae.institution_id),
                    JOIN acq_entity ae ON (m.posting_entity_id = ae.entity_id AND m.institution_id = ae.institution_id)
            WHERE
                m.posting_entity_id = ae.ENTITY_ID
                AND m.institution_id = ae.institution_id
                AND m.gl_date >= '01-$date_my' AND m.gl_date < '01-$next_mnth_my'
                AND m.major_cat IN ('FEES')
                AND m.minor_cat IN ('INTERCHANGE')
                AND m.card_scheme IN ($v_card_scheme)
                AND m.institution_id IN ('$sql_inst')
            GROUP BY m.institution_id, trunc(m.gl_date, 'MM'), m.entity_id, ae.entity_dba_name, ae.billing_type
            ORDER BY m.institution_id, m.entity_id, ae.billing_type)
        GROUP BY institution_id, gl_month, entity_id, entity_dba_name, billing_type
        ORDER BY institution_id, entity_id, billing_type"


    MASCLR::log_message "interchg_qry : $interchg_qry" 3

    orasql $cursor_C $interchg_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique STMT_INTERCHANGE     $row(STMT_INTERCHANGE)
            dict set entity_dictionary $unique CALC_INTERCHANGE     $row(CALC_INTERCHANGE)
            dict set entity_dictionary $unique RESIDUAL_INTERCHANGE $row(RESIDUAL_INTERCHANGE)
        }
    }

    formatted_puts "Fetching retrieval requests"

    # TODO uset tid_adn instead of individual tid values
    set retrievalReq_qry "
        select institution_id, entity_id, count(1) RETRIEVAL_REQS
        from masclr.mas_trans_log
        where institution_id in ('$sql_inst')
          and tid = '010103020102'
          and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and card_scheme in ($v_card_scheme)
        group by institution_id, entity_id"

    MASCLR::log_message "retrievalReq_qry : $retrievalReq_qry" 3

    orasql $cursor_C $retrievalReq_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique RETRIEVAL_REQS $row(RETRIEVAL_REQS)
        }
    }

    # TODO add avs counts and charges

    # AVS_CHECK_CNT
    # AVS_CHECK_AMT

    formatted_puts "Fetching AVS Counts"

    set avs_check_qry "
        select institution_id, entity_id,
          sum(nbr_of_items) AVS_CHECK_CNT,
          sum(
            case when tid_settl_method = 'D' then 1
                 when tid_settl_method = 'C' then -1  else 0 end *
            amt_billing) AVS_CHECK_AMT
        from mas_trans_log
        where institution_id in ('$sql_inst')
          and mas_code like '__AVS_AUTH'
          and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and card_scheme in ($v_card_scheme)
        group by institution_id, entity_id
        order by institution_id, entity_id"

    MASCLR::log_message "avs_check_qry : $avs_check_qry" 3

    orasql $cursor_C $avs_check_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique AVS_CHECK_CNT $row(AVS_CHECK_CNT)
            dict set entity_dictionary $unique AVS_CHECK_AMT $row(AVS_CHECK_AMT)
        }
    }


    # CVV_CHECK_CNT
    # CVV_CHECK_AMT

    formatted_puts "Fetching CVV Counts"

    set CVV_check_qry "
        select institution_id, entity_id,
          sum(nbr_of_items) CVV_CHECK_CNT,
          sum(
            case when tid_settl_method = 'D' then 1
                 when tid_settl_method = 'C' then -1  else 0 end *
            amt_billing) CVV_CHECK_AMT
        from mas_trans_log
        where institution_id in ('$sql_inst')
          and mas_code like '__CVV_AUTH'
          and gl_date >= '01-$date_my' and gl_date < '01-$next_mnth_my'
          and card_scheme in ($v_card_scheme)
        group by institution_id, entity_id
        order by institution_id, entity_id"

    MASCLR::log_message "CVV_check_qry : $CVV_check_qry" 3

    orasql $cursor_C $CVV_check_qry

    while {[orafetch $cursor_C -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique CVV_CHECK_CNT $row(CVV_CHECK_CNT)
            dict set entity_dictionary $unique CVV_CHECK_AMT $row(CVV_CHECK_AMT)
        }
    }


    ##
    ##############AUTH #################
    # Run queries for each set of MIDs
    # *less than 1000 mids per set*
    ###

    formatted_puts "Fetching: AUTH_COUNTS"
    formatted_puts "          TSYS COUNTS"
    formatted_puts "          DIALUP_TERM_COUNTS"
    formatted_puts "          DIALUP_TRANS_COUNTS"
    formatted_puts "          FRAUD_COUNT"
    for {set i 0} {$i <= $mid_lst_indx} {incr i} {

        set mid_sql_lst ""
        foreach x $mids($i) {
            set mid_sql_lst "$mid_sql_lst, '$x'"
        }

        set mid_sql_lst [string trim $mid_sql_lst {, }]

        set auth_counts_qry "
            Select m.mid, count(1) AUTH_COUNTS
            from teihost.transaction t, teihost.merchant m
            where t.mid=m.mid
              and m.mid in ($mid_sql_lst)
              and request_type in ($v_request_type_1)
              and authdatetime >= '$date_strt_frontend'
              and authdatetime < '$next_mnth_frontend'
              and t.card_type in ($v_card_type)
            GROUP BY m.mid"

        MASCLR::log_message "auth_counts_qry : $auth_counts_qry" 3

        orasql $cursor_A $auth_counts_qry

        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {

            set unique $mid_to_entity($row(MID))

            if {[dict exists $entity_dictionary $unique]} {

                #These acuumulate as one entity may have multiple MIDs
                set old_val [dict get [dict get $entity_dictionary $unique] AUTH_COUNTS]
                dict set entity_dictionary $unique AUTH_COUNTS [expr $old_val + $row(AUTH_COUNTS)]
            }
        }

        set tsys_count_qry "
            Select th.mid, count(1) as TSYS_COUNTS
            from teihost.tranhistory th
            where th.mid in ($mid_sql_lst)
              and SUBSTR(th.tid, 1, 4) = 'JSYS'
              and (th.settle_date >= '$date_strt_frontend' and th.settle_date < '$next_mnth_frontend')
              and th.card_type in ($v_card_type)
            GROUP BY th.mid"

        MASCLR::log_message "tsys_count_qry : $tsys_count_qry" 3

        orasql $cursor_A $tsys_count_qry

        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {

            set unique $mid_to_entity($row(MID))

            if {[dict exists $entity_dictionary $unique]} {

                #These acuumulate as one entity may have multiple MIDs
                set old_val [dict get [dict get $entity_dictionary $unique] TSYS_COUNTS]
                dict set entity_dictionary $unique TSYS_COUNTS [expr $old_val + $row(TSYS_COUNTS)]
            }
        }


        #TODO: This query needs to be revised
        set terminal_counts_qry "
            SELECT  m.mid,
                    sum(case when regexp_like(t.tid, '^-?\[\[:digit:\],.\]*\$')
                             then 1 else 0 end) as DIALUP_TERM_COUNTS
            FROM teihost.terminal t, teihost.merchant m, teihost.master_merchant mm
            WHERE t.mid=m.mid
              and m.mmid= mm.mmid
              and mm.active = 'A'
              and m.mid in ($mid_sql_lst)
              and m.active = 'A'
              and t.active = 'A'
              and t.mid = m.mid
              and case when regexp_like(t.tid, '^-?\[\[:digit:\],.\]*\$')
                       then t.tid end is not null
            GROUP BY m.mid"

        MASCLR::log_message "terminal_counts_qry : $terminal_counts_qry" 3

        orasql $cursor_A $terminal_counts_qry

        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {

            set unique $mid_to_entity($row(MID))

            if {[dict exists $entity_dictionary $unique]} {

                #These acuumulate as one entity may have multiple MIDs
                set old_val [dict get [dict get $entity_dictionary $unique] DIALUP_TERM_COUNTS]
                dict set entity_dictionary $unique DIALUP_TERM_COUNTS [expr $old_val + $row(DIALUP_TERM_COUNTS)]
            }
        }

        #TODO: This query needs to be revised
        set dialup_trnx_counts_qry "
            select t.mid, count(1) DIALUP_TRANS_COUNTS
            from teihost.transaction t
            where (t.authdatetime >= '$date_strt_frontend'
              and t.authdatetime < '$next_mnth_frontend')
              and t.mid in ($mid_sql_lst)
              and (t.tid BETWEEN ('000000000000') AND ('999999999999'))
              and t.request_type in ($v_request_type_2)
              and t.card_type in ($v_card_type)
            group by t.mid"

        puts "Diapup qry = $dialup_trnx_counts_qry"

        orasql $cursor_A $dialup_trnx_counts_qry

        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {

            set unique $mid_to_entity($row(MID))

            if {[dict exists $entity_dictionary $unique]} {
                #These acuumulate as one entity may have multiple MIDs
                set old_val [dict get [dict get $entity_dictionary $unique] DIALUP_TRANS_COUNTS]
                dict set entity_dictionary $unique DIALUP_TRANS_COUNTS [expr $old_val + $row(DIALUP_TRANS_COUNTS)]
            }
        }

        set fraud_count_qry "
            SELECT unique m.mid, count(f.orig_amount) AS FRAUD_COUNT
            FROM teihost.fraud_history f, teihost.merchant m, teihost.master_merchant mm
            WHERE f.mid = m.mid
              and m.mmid = mm.mmid
              and m.mid in ($mid_sql_lst)
              and f.AUTHDATETIME >= '$date_strt_frontend'
              and f.AUTHDATETIME < '$next_mnth_frontend'
              and f.SHIPDATETIME < '$next_mnth_frontend'
              and f.card_type in ($v_card_type)
            GROUP BY m.mid"
        puts "Fraud Qry = $fraud_count_qry"

        MASCLR::log_message "fraud_count_qry : $fraud_count_qry" 3

        orasql $cursor_A $fraud_count_qry

        while {[orafetch $cursor_A -dataarray row -indexbyname] != 1403} {

            set unique $mid_to_entity($row(MID))

            if {[dict exists $entity_dictionary $unique]} {
                #These acuumulate as one entity may have multiple MIDs
                set old_val [dict get [dict get $entity_dictionary $unique] FRAUD_COUNT]
                dict set entity_dictionary $unique FRAUD_COUNT [expr $old_val + $row(FRAUD_COUNT)]
            }
        }
    }

    formatted_puts "Fetching GetReporting User counts"

    set getRep_user_cnt_qry "
        select eta.institution_id, eta.entity_id, count (unique u.username) as GET_REP_USERS
        from port.user_profiles u, port.master_entity_hierarchy h, entity_to_auth eta
        WHERE u.entity_code = h.entity_code
          AND u.entity_type = h.entity_type
          and h.entity_id = eta.entity_id
          and eta.institution_id in ('$sql_inst')
        group by eta.institution_id, eta.entity_id"

    MASCLR::log_message "getRep_user_cnt_qry : $getRep_user_cnt_qry" 3

    orasql $cursor_GtReporting $getRep_user_cnt_qry

    while {[orafetch $cursor_GtReporting -dataarray row -indexbyname] != 1403} {

        set unique $row(INSTITUTION_ID).$row(ENTITY_ID)

        if {[dict exists $entity_dictionary $unique]} {
            dict set entity_dictionary $unique GET_REP_USERS $row(GET_REP_USERS)
        }
    }

    ##
    # Report Output
    # No need to add anything below here
    ###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###
    ###............................................................................................###
    ###%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###

    set filename "IsoBilling.$filedate.$rpt_type.$institution_arg.csv"
    set cur_file [open "$filename" w]

    #Output column names
    set rep ""
    set repline ""

    foreach col $report_data_lst {
        set repline "${repline}[lindex $col 1],"
    }

    set rep "${rep}[string trim $repline {, }]"

    ##
    # GO THROUGH ALL ENTITIES IN THE DICTIONARY
    # Print all data defined in report_data_lst for that entity
    ###

    foreach unique [dict keys $entity_dictionary] {
        set rep "${rep}\n"
        set repline ""

        foreach col $report_data_lst {
            #Grab the value of that column for that entity
            #Write to report
            set val [dict get [dict get $entity_dictionary $unique] [lindex $col 0]]
            set repline "${repline}$val,"

            #if numeric, Add to subtotal for that column
            if {[lindex $col 2] == "n"} {
                set old_val [dict get $totals_dictionary [lindex $col 0]]
                dict set totals_dictionary [lindex $col 0] [expr $old_val + $val]
            }

        }

        set rep "${rep}[string trim $repline {, }]"
    }


    #Write Subtotals

    set rep "${rep}\n"
    set repline ""
    foreach col $report_data_lst {
        set repline "${repline}[dict get $totals_dictionary [lindex $col 0]],"
    }

    set rep "${rep}[string trimright $repline {, }]"

    puts $cur_file $rep
    close $cur_file
}

##
# Main
###

MASCLR::log_message "Command: $argv0 $argv"

arg_parse

readCfgFile

connect_to_db

if {![info exists date_arg]} {
    init_dates [clock format [clock scan "-1 month"] -format %d-%b-%Y]
} else {
    init_dates [clock format [clock scan $date_arg -format %Y%m%d ] -format %d-%b-%Y]
}

if {$institution_arg != ""} {
    foreach rpt_type $card_type {
       puts $rpt_type
       do_report
    }
} else {
    formatted_puts "Institution required.\nUsage: $argv0 -I nnn \[-D yyyymmdd\]"
}


####################################################
##  Setting up the email portion of this script
####################################################

global filedate

set inst $institution_arg
# TODO set up different email when run as TEST

# COMMENTED FOR TESTING
# set email_lst "Reports-clearing@jetpay.com, accounting@jetpay.com"
set email_lst "Leonard.Mendis@jetpay.com"
set email_body " \nPlease see attached."
set email_subject " $inst Iso Billing Reports $filedate"

set filelist ""
set attachement_lst ""

        # Search for only files belonging to the given month/inst
  set filelist [glob -nocomplain -types f "IsoBilling.$filedate.*.$inst.csv"]

        # Creat a list of attachements adding "-a" to each file
  foreach fl $filelist {
    append attachement_lst " -a [file tail $fl]"
  }

        # Email out all the reports
  # COMMENTED FOR TESTING      
  # set mailpipe [open "| mutt -s \"$email_subject\" $attachement_lst -- $email_lst" w ]

  # COMMENTED FOR TESTING
  # if { [info exists mailpipe] } {
      # if { [ catch {
          # puts $mailpipe $email_body
          # close $mailpipe
      # } result ] } {
          # exec echo $result
      # }
  # }

        # Clean up all the reports from this directory
   foreach fl $filelist {
     file copy -force $fl ./ARCHIVE/$fl
     file delete $fl
   }


oraclose $cursor_C
oraclose $cursor_A
oraclose $cursor_GtReporting

oralogoff $mas_logon_handle
oralogoff $auth_logon_handle
oralogoff $port_logon_handle

##### THE END #####
