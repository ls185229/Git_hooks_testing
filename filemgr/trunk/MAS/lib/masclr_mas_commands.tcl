# this is a library file, not a standalone tcl script
# include this file in a different script by using
# source this_file_name
# $Id$
# prevent loading the file more than once
if { [info exists MASCLR_MAS_COMMANDS_LIB_LOADED] } {
    puts stdout "boarding standard library already loaded"
    return
}

source $env(MASCLR_TCL_LIB)/masclr_globals.tcl

namespace eval MASCLR {
    
    namespace export close_all_and_exit_with_code exit_with_code
    namespace export open_file close_file close_all_open_files

################################################################################
# proc  mas_server_busy? { query_cursor } 
# parameters:
#    query_cursor -- existing/open cursor 
# Not tested yet
# Not finished yet
################################################################################
    proc mas_server_busy? { query_cursor } {
        global env    
        source $env(MASCLR_TCL_LIB)/masclr_oratcl_tools.tcl
	set query_sql "select * from field_value_ctrl where field_name in ('FR_STATUS','SERVER_STATUS') and field_value1 = 'BUSY'"
   	MASCLR::fetch_row_as_array_from_cursor $query_cursor $query_sql 
    }



}



set MASCLR_MAS_COMMANDS_LIB_LOADED 1
