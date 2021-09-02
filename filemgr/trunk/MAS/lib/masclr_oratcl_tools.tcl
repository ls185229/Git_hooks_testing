
# this is a library file, not a standalone tcl script
# include this file in a different script by using 
# source this_file_name 
# $Id$
# need to support auto roll back on error
# need procs to fetch value
# need procs to loop through fetches and work on data with a callback


# prevent loading the file more than once
if { [info exists ORATCL_TOOLS_LOADED] } {
    puts stdout "oratcl_tools already loaded"
    return
}

package require Oratcl

source $env(MASCLR_TCL_LIB)/masclr_standard_lib.tcl



namespace eval MASCLR {
    
    namespace export open_db_connection close_db_connections
    namespace export insert_record insert_record_with_cursor
    namespace export update_record update_record_with_cursor
    namespace export delete_record delete_record_with_cursor
    namespace export clear_database_logon_handles add_database_logon_handle
    namespace export fetch_single_value_from_cursor
    namespace export open_cursor close_cursor
    namespace export live_updates
    namespace export save_updates_to_file

    variable DB_ERROR "DB_ERROR"
    variable AFFECTED_ROWS 0
    variable DATABASE_LOGON_HANDLES
    array set DATABASE_LOGON_HANDLES {}
    variable LIVE_UPDATES 0
    variable OUT_SQL_FILE_NAME ""

##################################################
# set_out_sql_file_name
# can throw an open file error
# tested with ???
##################################################
        proc set_out_sql_file_name { new_name } {
                variable OUT_SQL_FILE_NAME

                MASCLR::log_message "Setting OUT_SQL_FILE_NAME to $new_name"
                set OUT_SQL_FILE_NAME $new_name

		MASCLR::log_message "Opening file handle for $new_name"
		if { [catch {MASCLR::open_file $new_name} failure] } {
                    error "Could not open out SQL file: $failure " "" 
		}
        }

##################################################
# clear_database_logon_handles
# tested with clear_database_logon_handles-1.0
##################################################
        proc clear_database_logon_handles {} {
                variable DATABASE_LOGON_HANDLES
                array unset DATABASE_LOGON_HANDLES
                array set DATABASE_LOGON_HANDLES {}
        }
##################################################
# add_database_logon_handle
# tested with add_database_logon_handle-1.0
##################################################
        proc add_database_logon_handle { handle_name new_logon_handle } {
                variable DATABASE_LOGON_HANDLES
                set DATABASE_LOGON_HANDLES($handle_name) $new_logon_handle
        }

##################################################
# live_updates
# tested with
# tested with
##################################################
        proc live_updates { } {
		variable LIVE_UPDATES
                MASCLR::log_message "Setting LIVE_UPDATES to 1"
                set LIVE_UPDATES 1
        }

##################################################
# save_updates_to_file
# this will cause sql to output to a file instead of 
# 	running live against the database
# tested with
# tested with
##################################################
        proc save_updates_to_file { } {
		variable LIVE_UPDATES
                MASCLR::log_message "Setting LIVE_UPDATES to 0"
                set LIVE_UPDATES 0
        }
    
################################################################################
# proc open_db_connection { handle_name login_data }
# open db connections -- this only opens the logon handle
# parameters:
#    handle_name -- friendly name for the handle
#    login_data -- the user ID/password for the login
#
# individual procs are responsible for their cursors
# database logon handles are passed around in an array
# the array subscripts refer to the logon handle "name".
# dereference the array subscript to get the logon handle, like this:
#
# set masclr_logon_handle "MASCLR_REPORT"
#    set db_login_data "blah/blah@trnclr4"
#    open_db_connection $masclr_logon_handle $db_login_data 
#
# later open a cursor like this:
#    some_proc $MASCLR::DATABASE_LOGON_HANDLES($masclr_logon_handle)
#    inside some_proc
#    oraopen $parameter_name_that_received_the_logon_handle
# tested with open_db_connection-1.0
################################################################################
    proc open_db_connection { handle_name login_data } {
        
        if {[catch {set new_logon_handle [oralogon $login_data]} result]} {
            error "Could not open database connections.  Result: $result" "" $MASCLR::DB_ERROR
        }
        MASCLR::add_database_logon_handle $handle_name $new_logon_handle
    }

################################################################################
# proc open_cursor { handle_name }
# parameters:
#    handle_name -- friendly name for the handle
# returns new cursor 
# not tested yet
################################################################################
    proc open_cursor { handle_name } {
        if { [ catch {set new_cursor [oraopen $handle_name] } result ] } {
	    error "Could not open cursor.  Result: $result" "" $MASCLR::DB_ERROR
	}
	return $new_cursor
        
    }

################################################################################
# proc close_cursor { the_cursor }
# parameters:
#    the_cursor -- cursor to close 
# not tested yet
################################################################################
    proc close_cursor { the_cursor } {
        if { [ catch {oraclose $the_cursor } result ] } {

	    error "Could not close cursor.  Result: $result" "" $MASCLR::DB_ERROR

	}
    }
        
################################################################################
# proc close_db_connections { }
# close db connections -- closes all logon handles in the array passed as the argument
#    calling script should log the results.  Nothing breaks out of this proc so
#           an attempt will be made to close every connection
# parameters:
# return :
#     results - string with all results (both successful and caught errors)
################################################################################
    proc close_db_connections { } {
    
        set flat_logon_handles [array get MASCLR::DATABASE_LOGON_HANDLES]
        set results ""
        foreach {handle_name handle} $flat_logon_handles {
            if { [catch {oralogoff $handle} result] } {
                append results "Could not close handle $handle_name $result"
            } else {
                append results "\tClosing database connection $handle_name"
            }
            
        }
	MASCLR::clear_database_logon_handles
        return $results
    }


################################################################################
# proc insert_record { database_handle insert_sql }
# runs the insert statement against a database handle
# a new cursor is opened and then closed
# all error checking is done 
# parameters:
#    database_handle -- existing database handle
#    insert_sql -- the sql code to run for the insert
################################################################################

    proc insert_record { database_handle insert_sql }  {
        variable AFFECTED_ROWS    
	variable LIVE_UPDATES
	if { $LIVE_UPDATES == 0 } {
	    MASCLR::print_to_file $MASCLR::OUT_SQL_FILE_NAME "$insert_sql;\n\n"  
	    return
        }
        set insert_cursor [oraopen $database_handle]
        if {[catch {orasql $insert_cursor $insert_sql} result_code]} {
	    oraroll $database_handle
            error "[oramsg $insert_cursor rc] [oramsg $insert_cursor error]" "" $MASCLR::DB_ERROR
            
        }
        set AFFECTED_ROWS [oramsg $insert_cursor rows]
        oraclose $insert_cursor
    }

################################################################################
# proc insert_record_with_cursor { insert_cursor insert_sql }
# runs the insert statement against an existing cursor 
# all error checking is done
# parameters:
#    insert_cursor -- existing database cursor
#    insert_sql -- the sql code to run for the insert
################################################################################
    proc insert_record_with_cursor { insert_cursor insert_sql }  {
        variable AFFECTED_ROWS 
	variable LIVE_UPDATES
        if { $LIVE_UPDATES == 0 } {
            MASCLR::print_to_file $MASCLR::OUT_SQL_FILE_NAME "$insert_sql;\n\n"
            return
        }
        if {[catch {orasql $insert_cursor $insert_sql} result_code]} {
            error "[oramsg $insert_cursor rc] [oramsg $insert_cursor error]" "" $MASCLR::DB_ERROR
        }
        
        set AFFECTED_ROWS [oramsg $insert_cursor rows]
    }


################################################################################
# proc update_record { database_handle update_sql } 
# runs an update statement against a database handle
# a new cursor is opened and then closed
# all error checking is done in this proc
# parameters:
#    database_handle -- existing database handle
#    update_sql -- the sql code to run for the update
################################################################################

    proc update_record { database_handle update_sql }  {
        variable AFFECTED_ROWS 
	variable LIVE_UPDATES
        if { $LIVE_UPDATES == 0 } {
            MASCLR::print_to_file $MASCLR::OUT_SQL_FILE_NAME "$update_sql;\n\n"
            return
        }
        set update_cursor [oraopen $database_handle]
        if {[catch {orasql $update_cursor $update_sql} result_code]} {
            error "[oramsg $update_cursor rc] [oramsg $update_cursor error]" "" $MASCLR::DB_ERROR
        }
        set AFFECTED_ROWS [oramsg $update_cursor rows]
        oraclose $update_cursor
    }

################################################################################
# proc update_record_with_cursor { update_cursor update_sql } 
# runs an update statement against an existing cursor  
# all error checking is done in this proc
# parameters:
#    update_cursor -- existing database cursor
#    update_sql -- the sql code to run for the update
################################################################################

    proc update_record_with_cursor { update_cursor update_sql }  {
        variable AFFECTED_ROWS 
	variable LIVE_UPDATES
        if { $LIVE_UPDATES == 0 } {
            MASCLR::print_to_file $MASCLR::OUT_SQL_FILE_NAME "$update_sql;\n\n"
            return
        }
        if {[catch {orasql $update_cursor $update_sql} result_code]} {
            error "[oramsg $update_cursor rc] [oramsg $update_cursor error]" "" $MASCLR::DB_ERROR
        }
        set AFFECTED_ROWS [oramsg $update_cursor rows]
    }

################################################################################
# proc delete_record { database_handle delete_sql } 
# runs a delete statement against a database handle
# a new cursor is opened and then closed
# all error checking is done
# parameters:
#    database_handle -- existing database handle
#    delete_sql -- the sql code to run for the delete
################################################################################

    proc delete_record { database_handle delete_sql }  {
        variable AFFECTED_ROWS     
	variable LIVE_UPDATES
        if { $LIVE_UPDATES == 0 } {
            MASCLR::print_to_file $MASCLR::OUT_SQL_FILE_NAME "$delete_sql;\n\n"
            return
        }
        set delete_cursor [oraopen $database_handle]
        if {[catch {orasql $delete_cursor $delete_sql} result_code]} {
            error "[oramsg $delete_cursor rc] [oramsg $delete_cursor error]" "" $MASCLR::DB_ERROR
        }
        set AFFECTED_ROWS [oramsg $delete_cursor rows]
        oraclose $delete_cursor
    }

################################################################################
# proc delete_record_with_cursor { delete_cursor delete_sql }
# runs a delete statement against an existing cursor 
# all error checking is done
# parameters:
#    delete_cursor -- existing database cursor
#    delete_sql -- the sql code to run for the delete
# tested by delete_record_with_cursor-1.0
################################################################################

    proc delete_record_with_cursor { delete_cursor delete_sql }  {
        variable AFFECTED_ROWS 
	variable LIVE_UPDATES
        if { $LIVE_UPDATES == 0 } {
            MASCLR::print_to_file $MASCLR::OUT_SQL_FILE_NAME "$delete_sql;\n\n"
            return
        }

        if {[catch {orasql $delete_cursor $delete_sql} result_code]} {
            error "[oramsg $delete_cursor rc] [oramsg $delete_cursor error]" "" $MASCLR::DB_ERROR
        }
        set AFFECTED_ROWS [oramsg $delete_cursor rows]
    }


################################################################################
# proc fetch_single_value_from_cursor { query_cursor query_sql }
# runs a select statement against an existing cursor
# all error checking is done
# parameters:
#    query_cursor -- existing database cursor
#    query_sql -- the sql code to run for the select
# return: 
#    result -- the single value returned from the query
# tested by 
################################################################################

    proc fetch_single_value_from_cursor { query_cursor query_sql }  {
        variable AFFECTED_ROWS
        if {[catch {orasql $query_cursor $query_sql} result_code]} {
            error "[oramsg $query_cursor rc] [oramsg $query_cursor error]" "" $MASCLR::DB_ERROR
        }
        if { [catch {orafetch $query_cursor -datavariable result} failure] } {
            error "[oramsg $query_cursor rc] [oramsg $query_cursor error]" "" $MASCLR::DB_ERROR
        }

        set AFFECTED_ROWS [oramsg $query_cursor rows]
        return $result
    }

################################################################################
# proc fetch_row_as_array_from_cursor { query_cursor query_sql }
# runs a select statement against an existing cursor
# all error checking is done
# parameters:
#    query_cursor -- existing database cursor
#    query_sql -- the sql code to run for the select
#    fetch_array -- array to fetch the returned row into
# tested by 
################################################################################

    proc fetch_row_as_array_from_cursor { query_cursor query_sql fetch_array}  {
        variable AFFECTED_ROWS
	upvar $fetch_array _fetch_array
        if {[catch {orasql $query_cursor $query_sql} result_code]} {
            error "[oramsg $query_cursor rc] [oramsg $query_cursor error]" "" $MASCLR::DB_ERROR
        }
        if { [catch {orafetch $query_cursor -dataarray _fetch_array -indexbyname} failure] } {
            error "[oramsg $query_cursor rc] [oramsg $query_cursor error]" "" $MASCLR::DB_ERROR
        }

        set AFFECTED_ROWS [oramsg $query_cursor rows]
    }

################################################################################
# proc foreach_row_as_array_from_cursor { query_cursor query_sql lambda }
# runs a select statement against an existing cursor
# all error checking is done
# parameters:
#    query_cursor -- existing database cursor
#    query_sql -- the sql code to run for the select
#    lambda -- tcl code to run on each
# tested by 
################################################################################

    proc foreach_row_as_array_from_cursor { query_cursor query_sql lambda }  {
        variable AFFECTED_ROWS

        if {[catch {orasql $query_cursor $query_sql} result_code]} {
            error "[oramsg $query_cursor rc] [oramsg $query_cursor error]" "" $MASCLR::DB_ERROR
        }
	while {1} {
	    if {[catch {orafetch $query_cursor -dataarray fetch_array } failure]} {
                MASCLR::log_message "Error with $query_sql $failure"
                error "foreach_row_as_array_from_cursor: $failure [oramsg $query_cursor rc] [oramsg $query_cursor error]"
            }
            if {[oramsg $query_cursor rc] != 0} { break; }
            if { [catch {eval $lambda fetch_array} failure] } {
	        MASCLR::log_message "Error processing $lambda fetch_array"
		error "Error processing callback: $failure"
	    } 

        }
	

        set AFFECTED_ROWS [oramsg $query_cursor rows]
    }

}





set ORATCL_TOOLS_LOADED 1

