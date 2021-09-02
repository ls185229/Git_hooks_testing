#!/usr/bin/tclsh
#/clearing/filemgr/.profile

################################################################################
# $Id: PCINonComp.tcl 4157 2017-04-20 16:39:52Z fcaron $
# $Rev: 4157 $
################################################################################
#
# File Name:  PCINonComp.tcl
#
# Description:  This program creates a list of mercharnts that were assessed
#               a PCI Non-Compliance fee for the preveious month.  It also
#               creates a report of merchants recently added as PCI Non-Compliant
#               but are not listed in the first report.
#
# Script Arguments:  None.  Defaults to prior month.
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  None.
#
################################################################################

#Environment veriables
set box $env(SYS_BOX)
set clrpath $env(CLR_OSITE_ROOT)
set maspath $env(MAS_OSITE_ROOT)
set mailtolist $env(MAIL_TO)
#set mailfromlist $env(MAIL_FROM)
set clrdb $env(CLR4_DB)
set authdb $env(TSP4_DB)

#Email Subjects variables Priority wise
set msubj_c "$box :: Priority : Critical - Clearing and Settlement"
set msubj_u "$box :: Priority : Urgent - Clearing and Settlement"
set msubj_h "$box :: Priority : High - Clearing and Settlement"
set msubj_m "$box :: Priority : Medium - Clearing and Settlement"
set msubj_l "$box :: Priority : Low - Clearing and Settlement"

#Email Body Headers variables for assist
set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables
set sysinfo "System: $box\n Location: $env(PWD) \n\n"

#===============================================================================
package require Oratcl
if {[catch {set handler [oralogon masclr/masclr@$clrdb]} result]} {
     exec echo "PCINonComp.tcl failed to run" | mutt -s "PCINonComp.tcl failed to run due to database connection " $mailtolist
     exit
}

set pci_cursor1  [oraopen $handler]
set pci_cursor2  [oraopen $handler]

global report_date
global title_date
global pcistart_qry
global today_date
set mode "PROD"

set title_date [clock format [clock seconds] -format "%m-%d-%Y"]
set today_date [clock format [clock seconds] -format "%Y%m%d"]
if {![info exists given_date]} {
      set report_date [clock format [clock seconds] -format "%Y%m"]
      set file_date $report_date
      append report_date "01"
      set end_date $report_date
      set start_date  [clock format [clock add [clock scan $end_date -format "%Y%m%d"] -1 months] -format "%Y%m%d"]
} else {
  puts "given date $given_date"
  set start_date [clock format [clock scan $given_date -format "%Y%m%d"] -format "%Y%m01"]
  set report_date [clock format [clock scan $given_date -format "%Y%m%d"] -format "%Y%m"]
  set file_date $report_date
  set end_date [clock format [clock scan "$start_date +1 month"] -format "%Y%m01"]
}

set lastdayprevmonth [clock format [clock add [clock scan $file_date] -1 day] -format "%Y%m%d"]

if {$mode == "TEST"} {
     set cur_file_name "./PCI_NonComp_$report_date.TEST.csv"
     set file_name "PCI_NonComp_$report_date.TEST.csv"
} elseif {$mode == "PROD"} {
     set cur_file_name "/clearing/filemgr/JOURNALS/MONTHEND/ARCHIVE/PCI_NonComp_$report_date.csv"
     set file_name "PCI_NonComp_$report_date.csv"
}

 set cur_file [open "$cur_file_name" w]

 puts $cur_file "PCI NonCompliance Activity"
 puts $cur_file "DATE: $title_date" 
 set headline1 "Merchant,GL Date,Amount,Settle Method,MAS Code,Status,Termination Date"
 set headline2 "Inst,Merchant,Name,PCI Start,PCI End"

set pci_qry "SELECT DISTINCT
    mtl.ENTITY_ID,
    mtl.GL_DATE,
    mtl.AMT_ORIGINAL,
    mtl.TID_SETTL_METHOD,
    mtl.MAS_CODE,
    ae.ENTITY_STATUS,
    ae.termination_date
FROM
    MAS_TRANS_LOG mtl
    JOIN ACQ_ENTITY ae ON ae.ENTITY_ID = mtl.ENTITY_ID
WHERE 
    mtl.MAS_CODE = '00PCINONCOMP'
    AND mtl.TID_SETTL_METHOD = 'D'
    AND ae.ENTITY_STATUS     = 'A'
    AND TRUNC(mtl.GL_DATE) BETWEEN TO_DATE('$start_date','YYMMDD') AND TO_DATE('$end_date','YYMMDD')
ORDER BY
    GL_DATE,
    ENTITY_ID"
puts $pci_qry

if {$mode == "TEST"} {
    puts "pci query: $pci_qry"
}

orasql $pci_cursor1 $pci_qry
puts $cur_file ""
puts $cur_file "$headline1"

while {[orafetch $pci_cursor1 -dataarray pci -indexbyname] != 1403} {
 set output_line "'$pci(ENTITY_ID),$pci(GL_DATE),$pci(AMT_ORIGINAL),$pci(TID_SETTL_METHOD),"
 append output_line "$pci(MAS_CODE),$pci(ENTITY_STATUS),$pci(TERMINATION_DATE)"
puts $cur_file "$output_line\r"
}

puts $cur_file ""

set pcistart_qry "SELECT * FROM
    (SELECT DISTINCT
        enf.INSTITUTION_ID,
        enf.ENTITY_ID,
        REPLACE(ae.ENTITY_DBA_NAME,',',' ') ENTITY_DBA_NAME,
        enf.start_date PCI_NonComp_Start,
        enf.end_date PCI_NonComp_END
    FROM
        MASCLR.ENT_NONACT_FEE_PKG ENF
        JOIN masclr.acq_entity ae
        ON ae.entity_id = enf.entity_id AND ae.institution_id=enf.institution_id
    WHERE
        ENF.NON_ACT_FEE_PKG_ID IN (SELECT nfp.non_act_fee_pkg_id FROM masclr.non_act_fee_pkg nfp
            WHERE nfp.nonact_feepkg_name LIKE '%PCINONCOMP%')
            AND enf.entity_id NOT IN (SELECT DISTINCT mtl.ENTITY_ID FROM MAS_TRANS_LOG mtl
            WHERE MTL.MAS_CODE = '00PCINONCOMP'
            AND TRUNC(MTL.GL_DATE) >= TO_DATE('$start_date','YYYYMMDD') AND TRUNC(MTL.GL_DATE) < TO_DATE('$end_date','YYYYMMDD')) 
            AND enf.end_date IS NULL AND ae.termination_date IS NULL
    ORDER BY
        enf.institution_id,
        enf.start_date,
        enf.entity_id) sub1 ORDER BY 1 ASC"

puts $pcistart_qry

orasql $pci_cursor2 $pcistart_qry

puts $cur_file ""
puts $cur_file "$headline2"

while {[orafetch $pci_cursor2 -dataarray pcistart -indexbyname] != 1403} {
     set output_line "$pcistart(INSTITUTION_ID),'$pcistart(ENTITY_ID),$pcistart(ENTITY_DBA_NAME),"
     append output_line "$pcistart(PCI_NONCOMP_START),$pcistart(PCI_NONCOMP_END)"
     puts $cur_file "$output_line\r"
}

puts $cur_file ""
puts $cur_file ""

close $cur_file

set ck_email ""

if {$mode == "PROD"} {
    set ck_email "boarding@jetpay.com;pci-compliance@jetpay.com;clearing@jetpay.com"
} elseif {$mode == "TEST"} {
    set ck_email "clearing@jetpay.com"
}

exec echo "Please see attached." | mutt -a "$cur_file_name" -s "$file_name" -- $ck_email

oraclose $pci_cursor1
oraclose $pci_cursor2
