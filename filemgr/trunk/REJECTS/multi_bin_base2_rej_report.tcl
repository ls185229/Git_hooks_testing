#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: multi_bin_base2_rej_report.tcl 3597 2015-12-01 21:27:00Z bjones $

package require Oratcl

#######################################################################################################################

#Environment veriables.......

set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
set mailfromlist $env(MAIL_FROM)
set clrdb $env(IST_DB)
set authdb $env(ATH_DB)

#Email Subjects variables Priority wise

set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"


#Email Body Headers variables for assist

set mbody_c "ASSIST :: \n Contact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \n Contact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \n Inform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \n Inform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \n Assign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: /clearing/filemgr/TC57/ARCHIVE \n\n"

#######################################################################################################################

set logdate [clock format [clock seconds] -format "%Y%m%d"]
set err ""

exec echo "Log Date: $logdate" >> ./LOG/base2.epd.rej.log

proc chk_err {errorv errmsg} {

    global box clrpath maspath mailtolist mailfromlist clrdb authdb msubj_c msubj_u msubj_h msubj_m msubj_l mbody_c mbody_u mbody_h mbody_m mbody_l sysinfo err

    if {$errorv == ""} {
    #exec echo "\n Done -- $errmsg \n " >> ./LOG/base2.epd.rej.log
    } else {
        puts "Err: \n $errmsg \n $errorv"
        set mbody "Err: \n $errmsg \n $errorv \n"
        exec echo "$mbody_u $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_u" $mailtolist
        exit 1	
    }

}

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

set trknbr_list {}


if {$argc > 2 || $argc == 0} {
puts "Wrong # for arguments"
exit 0
}



proc get_cfg {cfg_pth} {
    global arr_cfg trknbr_list
    set cfg_file "base2.rej.epd.cfg"
    set in_cfg [open $cfg_pth/$cfg_file r]
    set cur_line  [split [set orig_line [gets $in_cfg] ] ~]
    while {$cur_line != {} } {
        if {[string toupper [string trim [lindex $cur_line 0]]] != "" && [string toupper [string range [lindex $cur_line 0] 0 0]] != "#"} {
            lappend trknbr_list [lindex $cur_line 0]
            set arr_cfg(inst_id.[lindex $cur_line 0]) [lindex $cur_line 1]
            set arr_cfg(bin.[lindex $cur_line 0]) [lindex $cur_line 2]
            set arr_cfg(en.[lindex $cur_line 1]) [lindex $cur_line 3]
            set arr_cfg(up.[lindex $cur_line 1]) [lindex $cur_line 4]
            #			puts "$trknbr_list $arr_cfg(inst_id.[lindex $cur_line 0]) $arr_cfg(network.[lindex $cur_line 0])"
            }
     set cur_line  [split [set orig_line [gets $in_cfg] ] ~]
    }
        return arr_cfg
    }

    get_cfg ./CFG

    set infile [lindex $argv 0]
    if {$argc == 2} {
    set dt [lindex $argv 1]
    set logdate $dt
    } else {
    set dt ""
    }

    set fname "[string range $infile 0 4]\*"

    foreach f [glob -nocomplain $fname] {
        exec mv $f ./ARCHIVE/mvd.$f.$logdate
    }

    foreach f [glob -nocomplain REJ.*] {
        exec rm -r $f
    }

    catch {exec ./recv_vs_ep_file.exp $fname $dt >> ./LOG/base2.epd.rej.log} err
    chk_err $err "./recv_vs_ep_file.exp $fname $dt >> ./LOG/base2.epd.rej.log"


    foreach f [glob -nocomplain EP200*] {
        exec rm $f
    }

    set nlist ""
    set i 1

    catch {set x [exec find /clearing/filemgr/REJECTS/ -mtime 0 -name $fname]} err

    puts $x
    foreach infile $x {

        set infile [string range $infile 26 end] 
        #puts $infile

        foreach trknbr $trknbr_list {

            set outfile "[string range $infile 0 5].BIN$trknbr.EPD"
            set input [open $infile r]

            exec echo "\n $outfile \n" >> ./LOG/base2.epd.rej.log

            set cur_linea [set orig_line [gets $input]]

            while {! [eof $input]} {
                set cur_line0 [set orig_line [gets $input]]
                set line1 [string range [string trim $cur_line0] 1 9]

                if {$line1 == "REPORT EP"} {
                    set cur_line1 [set orig_line [gets $input]]
                    set cur_line2 [set orig_line [gets $input]]
                    set line2 [string range [string trim $cur_line2] 67 72]
                    if {$line2 == "$trknbr"} {
                        if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                            puts stderr "Cannot open /duplog : $fileid"
                        } else {
                            if {[string range $cur_line0 0 1] == "^L"} {
                                puts $fileid "$cur_line0"
                            } else { 
                                puts $fileid "$cur_line0"
                            }
                            close $fileid
                        }
                        if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                            puts stderr "Cannot open /duplog : $fileid"
                        } else {
                            puts $fileid $cur_line2
                            close $fileid
                        }

                        set x 1
                        while {$x == 1} {
                            set cur_line2  [set orig_line [gets $input]]
                            if {[string range $cur_line2 0 10] == "ACCT NUMBER"} {
                                set cur_line2 "[string range $cur_line2 0 31]XXXXXX[string range $cur_line2 38 end]"
                            }
                            if [catch {open $outfile {WRONLY CREAT APPEND}} fileid] {
                                puts stderr "Cannot open /duplog : $fileid"
                            } else {
                                puts $fileid $cur_line2
                                close $fileid
                            }
                            if {[string range $infile 5 5] == "A" } {
                                set endchk [string range [string trim $cur_line2] 0 19]
                                if {$endchk == "TOTAL RETURNED ITEMS"} {
                                    set x 5
                                }
                            } else {
                                set endchk [string range [string trim $cur_line2] 0 26]
                                if {$endchk == "TOTAL RETURNED ITEMS AMOUNT"} {
                                    set x 5
                                }
                            }
                        }
                    }
                }
            }

            close $input
            set fdir "REJ.$arr_cfg(inst_id.$trknbr).$logdate"
            if {![file exists $fdir]} {
                exec mkdir $fdir
            }
            if {[file exists $outfile]} {
                exec mv $outfile ./$fdir/
            }

        };#end of foreach
    };#end of foreach infile

    catch {set y [exec find /clearing/filemgr/REJECTS/ -mtime 0 -name REJ.*]} result

    foreach ydir $y {
        set ydir [string range $ydir 26 end]
	set ii [string range $ydir 4 6]
        exec zip -r $ydir.zip $ydir
        if {[file size $ydir.zip] > 166 } {
            exec mutt -a $ydir.zip -s "[string range $ydir 4 6] VSDaily Reject Reports for $logdate" clearing@jetpay.com < body.txt
        }
        if {$arr_cfg(en.$ii) != "N"} {
            catch {exec gpg --output $ydir.zip.gpg --encrypt --recipient clearing@jetpay.com --recipient $arr_cfg(en.$ii) $ydir.zip} gpgresult
		puts $gpgresult
            after 15000
        }
	exec mv $ydir.zip ./ARCHIVE/dn-$ydir.zip
        exec rm -r $ydir
    }

    catch {set z [exec find /clearing/filemgr/REJECTS/ -mtime 0 -name REJ.*.gpg]} result


    foreach fgpg $z {
        set fgpg [string range $fgpg 26 end]
        if {$arr_cfg(up.[string range $fgpg 4 6]) == "Y"} {
            catch {exec /clearing/filemgr/BASE2/INST_[string range $fgpg 4 6]/UPLOAD/uploadepd.exp $fgpg >> ./LOG/base2.epd.rej.log} err
            chk_err $err "/clearing/filemgr/BASE2/INST_[string range $fgpg 4 6]/UPLOAD/uploadepd.exp $fgpg >> ./LOG/base2.epd.rej.log"
            if {$err == ""} {
                set renm "PD-$fgpg"
                catch {exec mv $fgpg ./ARCHIVE/$renm >> ./LOG/base2.epd.rej.log} err
                chk_err $err "mv $fgpg ./ARCHIVE/$renm >> ./LOG/base2.epd.rej.log"
            }

        } else {
            catch {exec mv $fgpg ./ARCHIVE/PD-$fgpg >> ./LOG/base2.epd.rej.log} err
            chk_err $err "mv $fgpg ./ARCHIVE/PD-$fgpg >> ./LOG/base2.epd.rej.log"

        }

    }

    foreach f [glob -nocomplain EP20*] {
        exec rm $f
    } 
