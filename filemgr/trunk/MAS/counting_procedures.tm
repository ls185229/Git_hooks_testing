
#  counting_procedures.tclinc

# $Id: counting_procedures.tm 2647 2014-06-19 17:28:23Z bjones $


proc get_cfg {inst_id cfg_pth} {
    global arr_cfg
    set cfg_file "$inst_id.inst.cfg"
    set in_cfg [open $cfg_pth/$cfg_file r]
    set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
    while {$cur_line != ""} {
        MASCLR::log_message "cur_line: $cur_line" 3
        if {[string toupper [string trim [lindex $cur_line 0]]] != ""} {            
            set arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) \
                    "'[string trim [lindex $cur_line 1]]'"
            for {set i 2} {$i < [llength $cur_line]} {incr i 1} {
                append arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) \
                    ",'[string trim [lindex $cur_line $i]]'"
            }
        }
        puts "arr_cfg([string toupper [string trim [lindex $cur_line 0]]]) \
            $arr_cfg([string toupper [string trim [lindex $cur_line 0]]])"
        set cur_line  [split [set orig_line [gets $in_cfg] ] ,]
    }
    return arr_cfg
}
