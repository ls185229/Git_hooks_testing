#!/usr/bin/env tclsh

# $Id: auth_count_summary.tcl 3201 2015-07-17 21:10:31Z bjones $

# get standard commands from a lib file
source $env(MASCLR_LIB)/mas_process_lib.tcl

### The MASCLR::monitor_clearing_export_status proc requires these two procs
### to be defined in the THIS namespace
namespace eval THIS {

}

proc setup {} {
    global argv

    MASCLR::open_log_file ""

    MASCLR::add_argument date d [list ARG_HAS_VAL ARG_DEFAULT { "set MASCLR::YESTERDAY"} ARG_FORMAT {"MASCLR::get_date_with_format $arg_value %Y%m%d"}]

    MASCLR::set_up_dates
    MASCLR::parse_arguments $argv

    MASCLR::set_script_alert_level "LOW"
    MASCLR::set_debug_level 0
    MASCLR::live_updates

    global env
    namespace eval THIS {

    }


    ###
}   ;# setup

###

proc main {} {
    set success $MASCLR::SCRIPT_SUCCESS
    set script_failures ""
    if { [catch {setup} failure] } {
        MASCLR::log_message "ERROR: Setup failed: $failure"
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }
    global env
    set get_summary_login_data "teihost/quikdraw@$env(TSP4_DB)"
    if { [catch {set get_summary_handle [MASCLR::open_db_connection "get_summary" $get_summary_login_data]} failure] } {
        MASCLR::log_message "ERROR: $failure"
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }

    set insert_summary_login_data "masclr/masclr@$env(IST_DB)"
    if { [catch {set insert_summary_handle [MASCLR::open_db_connection "insert_summary" $insert_summary_login_data]} failure] } {
        MASCLR::log_message "ERROR: $failure"
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION
    }

    if { [catch {set select_cursor [MASCLR::open_cursor $get_summary_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }

    if { [catch {set insert_cursor [MASCLR::open_cursor $insert_summary_handle]} failure] } {
        set message "Could not open cursor: $failure"
        error $message
    }
    if { [catch {
                set get_summary_sql "select /*+INDEX(TRANSACTION_AUTHDATETIME) */
                    mm.shortname,
                    m.mmid,
                    t.mid,
                    t.tid,
                    m.visa_id clearing_id,
                    nvl(card_type,' ') card_type,
                    REQUEST_TYPE,
                    nvl(TRANSACTION_TYPE,' ') TRANSACTION_TYPE,
                    t.STATUS,
                    ACTION_CODE,
                    substr(AUTHDATETIME,0,8) auth_day,
                    substr(SHIPDATETIME,0,8) ship_day,
                    nvl(MARKET_TYPE,' ') MARKET_TYPE,
                    count(*) cnt,
                    sum(amount) sum_amount
                    from transaction  t
                    join merchant  m on m.mid = t.mid
                    join master_merchant  mm on mm.mmid = m.mmid
                    where mm.shortname like 'JETPAY%'
                    and t.authdatetime like :date_var
                    group by m.mmid,
                    mm.shortname,
                    t.mid,
                    t.tid,
                    m.visa_id,
                    nvl(card_type,' '),
                    REQUEST_TYPE,
                    nvl(TRANSACTION_TYPE,' '),
                    t.STATUS,
                    ACTION_CODE,
                    substr(AUTHDATETIME,0,8),
                    substr(SHIPDATETIME,0,8),
                    nvl(MARKET_TYPE,' ')
                    union
                    select /*+INDEX(TRANSACTION_AUTHDATETIME) */
                    mm.shortname,
                    m.mmid,
                    t.mid,
                    t.tid,
                    ach.MASCLR_ACH_ID ,
                    nvl(card_type,' ') card_type,
                    REQUEST_TYPE,
                    nvl(TRANSACTION_TYPE,' ') TRANSACTION_TYPE,
                    t.STATUS,
                    ACTION_CODE,
                    substr(AUTHDATETIME,0,8) auth_day,
                    substr(SHIPDATETIME,0,8) ship_day,
                    nvl(MARKET_TYPE,' ') MARKET_TYPE,
                    count(*) cnt,
                    sum(amount) sum_amount
                    from transaction  t
                    join merchant  m on m.mid = t.mid
                    join master_merchant  mm on mm.mmid = m.mmid
                    join ACHLOOKUPV4  ach on ach.mid = m.mid
                    where mm.shortname not like 'JETPAY%'
                    and t.authdatetime like :date_var
                    and t.request_type like '06%'
                    group by m.mmid,
                    mm.shortname,
                    t.mid,
                    t.tid,
                    ach.MASCLR_ACH_ID ,
                    nvl(card_type,' '),
                    REQUEST_TYPE,
                    nvl(TRANSACTION_TYPE,' '),
                    t.STATUS,
                    ACTION_CODE,
                    substr(AUTHDATETIME,0,8),
                    substr(SHIPDATETIME,0,8),
                    nvl(MARKET_TYPE,' ')"
                MASCLR::log_message $get_summary_sql"

                set bind_vars [dict create :date_var "$MASCLR::SCRIPT_ARGUMENTS(DATE)%"]
                MASCLR::log_message "bind variables $bind_vars"
                if { [catch {MASCLR::start_bind_fetch $select_cursor $get_summary_sql $bind_vars} failure] } {
                    set message "Could not start fetch with orasql: $failure"
                    error $message
                }

                set insert_sql "INSERT
                        INTO
                          AUTH_COUNT_SUMMARY
                          (
                            SHORTNAME ,
                            MMID,
                            MID,
                            TID ,
                            CLEARING_ID,
                            CARD_TYPE,
                            REQUEST_TYPE,
                            TRANSACTION_TYPE,
                            STATUS,
                            ACTION_CODE,
                            AUTH_DAY,
                            SHIP_DAY,
                            MARKET_TYPE,
                            CNT,
                            SUM_AMOUNT
                          )
                          VALUES
                          (
                            :shortname_var,
                            :mmid_var,
                            :mid_var,
                            :tid_var,
                            :clearing_id_var,
                            :card_type_var,
                            :request_type_var,
                            :transaction_type_var,
                            :status_var,
                            :action_code_var,
                            :auth_day_var,
                            :ship_day_var,
                            :market_type_var,
                            :cnt_var,
                            :sum_amount_var
                          )"

                while { [MASCLR::get_cursor_status $select_cursor] == $MASCLR::HAS_MORE_RECORDS } {
                    array set summary_record [MASCLR::fetch_record $select_cursor]

                    if { [MASCLR::get_cursor_status $select_cursor] == $MASCLR::HAS_MORE_RECORDS } {
                        set insert_bind_vars [dict create :shortname_var $summary_record(SHORTNAME) \
                         :mmid_var $summary_record(MMID) :mid_var $summary_record(MID) :tid_var $summary_record(TID) \
                         :clearing_id_var $summary_record(CLEARING_ID) :card_type_var $summary_record(CARD_TYPE) \
                         :request_type_var $summary_record(REQUEST_TYPE) :transaction_type_var $summary_record(TRANSACTION_TYPE) \
                         :status_var $summary_record(STATUS) :action_code_var $summary_record(ACTION_CODE) \
                         :auth_day_var $summary_record(AUTH_DAY) :ship_day_var $summary_record(SHIP_DAY) \
                         :market_type_var $summary_record(MARKET_TYPE) :cnt_var $summary_record(CNT) \
                         :sum_amount_var $summary_record(SUM_AMOUNT)]
                        if { [catch {MASCLR::insert_bind_record $insert_cursor $insert_sql $insert_bind_vars} failure] } {
                            MASCLR::log_message "$failure"
                            catch {MASCLR::perform_rollback $insert_summary_handle} failure
                            catch {MASCLR::close_cursor $insert_cursor} failure
                            return $errorCode
                        }

                    }

                }

                catch {MASCLR::perform_commit $insert_summary_handle} failure

            } failure] } {
        MASCLR::log_message "$failure"
        catch {MASCLR::perform_rollback $insert_summary_handle} failure
        catch {MASCLR::perform_rollback $get_summary_handle} failure
        MASCLR::close_all_and_exit_with_code $MASCLR::FAILURE_CONDITION

    }
    catch {MASCLR::close_cursor $select_cursor} failure
    catch {MASCLR::close_cursor $insert_cursor} failure

    MASCLR::close_all_and_exit_with_code $MASCLR::SCRIPT_SUCCESS

    ###
}   ;# main

###

main
