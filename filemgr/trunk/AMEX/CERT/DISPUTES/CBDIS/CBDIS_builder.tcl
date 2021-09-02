#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: $

################################################################################
#
#    File Name - CBDIS_builder.tcl
#
#    Description - This scripts checks to see if the neccesary files were
#                  imported into the MAS or not.
#
#    Arguments-  
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    EXAMPLE = CBDIS_builder.tcl -d <YYYYMMDD>
#
#    Return - 0 = Success
#             1 = Fail
#
#    Exit - 1 - Error related to Program parameters/arguments
#           2 - 
#           3 - DB Error
#           4 - Warning Message
#
#    Note -
#
################################################################################

package require Oratcl

## Enviornment Variable ##
set box $env(SYS_BOX)
set prod_db $env(IST_DB)
set prod_auth_db $env(ATH_DB)
set sysinfo "System: $box \nLocation: $env(PWD) \n\n"

## Global Variable ##
set programName "[lindex [split [file tail $argv0] .] 0]"
set cfg_file params.cfg
set seq_file seq_nbr.txt
## Default values
set said "A57450"
set fileType "CBDIS"
set STARS_FILESEQ_NB "1"
set error 0

################################################################################
#
#    set the structure for file header
#   <field#> <field_name> <length> <data type in the file> <start field position> <end field position>
#   <justification>/<padding>
#NOTE - the field name should match the coulumn name in amex_dispute_txn table
###############################################################################
set file_hdr {
1       REC_TYPE              1   Alphanumeric        1   1     -
2       AMEX_APPL_AREA      100   Character_spaces    2   101   -
3       SAID                  6   Alphanumeric      102   107   -
4       DATATYPE              5   Alphanumeric      108   112   -
5       CCYYDDD               7   Alphanumeric      113   119   -
6       0HHMMSS               7   Numeric           120   126   0
7       STARS_FILESEQ_NB      3   Numeric           127   129   0
8       FILE_BATCH_ID         8   Alphanumeric      130   137   -
9       FILLER                9   Character_spaces  138   146   -
10      FILLER                8   Character_spaces  147   154   -
11      CLIENT_AREA         100   Alphanumeric      155   254   -
12      FILLER             1948   Character_spaces  255   2202  -
}

set detail_record {
1   REC_TYPE                      1   Alphanumeric          1  1        -
2   FILLER                        5   Character_spaces      2  6        -
3   SE_NUMB                      10   Alphanumeric          7  16       -
4   XREF_SE_NUMB                 10   Alphanumeric         17  26       -
5   CM_ACCT_NUMB                 15   Alphanumeric         27  41       -
6   FILLER                        5   Character_spaces     42  46       -
7   CURRENT_CASE_NUMBER          11   Alphanumeric         47  57       -
8   CURRENT_ACTION_NUMBER         2   Alphanumeric         58  59       -
9   PREVIOUS_CASE_NUMBER         11   Alphanumeric         60  70       -
10  PREVIOUS_ACTION_NUMBER        2   Alphanumeric         71  72       -
11  RESOLUTION                    1   Alphanumeric         73  73       -
12  FROM_SYSTEM                   1   Alphanumeric         74  74       -
13  REJECTS_TO_SYSTEM             1   Alphanumeric         75  75       -
14  DISPUTES_TO_SYSTEM            1   Alphanumeric         76  76       -
15  DATE_OF_ADJUSTMENT            8   Alphanumeric         77  84       -
16  DATE_OF_CHARGE                8   Alphanumeric         85  92       -
17  AMEX_ID                       7   Alphanumeric         93  99       -
18  FILLER                        5   Character_spaces    100  104      -
19  CASE_TYPE                     6   Alphanumeric        105  110      -
20  LOC_NUMB                     15   Alphanumeric        111  125      -
21  REASON_CODE                   3   Alphanumeric        126  128      -
22  CB_AMOUNT                    17   Alphanumeric        129  145      0
23  CB_ADJUSTMENT_NUMBER          6   Alphanumeric        146  151      -
24  CB_RESOLUTION_ADJ_NUMBER      6   Alphanumeric        152  157      -
25  CB_REFERENCE_CODE            12   Alphanumeric        158  169      -
26  FILLER                       13   Alphanumeric        170  182      -
27  BILLED_AMOUNT                17   Alphanumeric        183  199      0
28  SOC_AMOUNT                   17   Alphanumeric        200  216      0
29  SOC_INVOICE_NUMBER            6   Alphanumeric        217  222      -
30  ROC_INVOICE_NUMBER            6   Alphanumeric        223  228      -
31  FOREIGN_AMT                  15   Alphanumeric        229  243      -
32  CURRENCY                      3   Alphanumeric        244  246      -
33  SUPP_TO_FOLLOW                1   Alphanumeric        247  247      -
34  CM_NAME1                     30   Alphanumeric        248  277      -
35  CM_NAME2                     30   Alphanumeric        278  307      -
36  CM_ADDR1                     30   Alphanumeric        308  337      -
37  CM_ADDR2                     30   Alphanumeric        338  367      -
38  CM_CITY_STATE                30   Alphanumeric        368  397      -
39  CM_ZIP                        9   Alphanumeric        398  406      -
40  CM_FIRST_NAME_1              12   Alphanumeric        407  418      -
41  CM_MIDDLE_NAME_1             12   Alphanumeric        419  430      -
42  CM_LAST_NAME_1               20   Alphanumeric        431  450      -
43  CM_ORIG_ACCT_NUM             15   Alphanumeric        451  465      -
44  CM_ORIG_NAME                 30   Alphanumeric        466  495      -
45  CM_ORIG_FIRST_NAME           12   Alphanumeric        496  507      -
46  CM_ORIG_MIDDLE_NAME          12   Alphanumeric        508  519      -
47  CM_ORIG_LAST_NAME            20   Alphanumeric        520  539      -
48  NOTE1                        66   Alphanumeric        540  605      -
49  NOTE2                        78   Alphanumeric        606  683      -
50  NOTE3                        60   Alphanumeric        684  743      -
51  NOTE4                        60   Alphanumeric        744  803      -
52  NOTE5                        60   Alphanumeric        804  863      -
53  NOTE6                        60   Alphanumeric        864  923      -
54  NOTE7                        60   Alphanumeric        924  983      -
55  TRIUMPH_SEQ_NO                2   Alphanumeric        984  985      -
56  FILLER                       20   Character_spaces    986  1005     -
57  SELLER_ID                    15   Character_spaces   1006  1020     -
58  FILLER                       10   Character_spaces   1021  1030     -
59  AIRLINE_TKT_NUM              14   Alphanumeric       1031  1044     -
60  AL_SEQUENCE_NUMBER            2   Alphanumeric       1045  1046     -
61  FOLIO_REF                    18   Alphanumeric       1047  1064     -
62  MERCH_ORDER_NUM              10   Alphanumeric       1065  1074     -
63  MERCH_ORDER_DATE              8   Alphanumeric       1075  1082     -
64  CANC_NUM                     20   Alphanumeric       1083  1102     -
65  CANC_DATE                     8   Alphanumeric       1103  1110     -
66  FINCAP_TRACKING_ID           11   Alphanumeric       1111  1121     -
67  FINCAP_FILE_SEQ_NUM           6   Alphanumeric       1122  1127     -
68  FINCAP_BATCH_NUMBER           4   Alphanumeric       1128  1131     -
69  FINCAP_BATCH_INVOICE_DT       8   Alphanumeric       1132  1139     -
70  LABEL1                       25   Alphanumeric       1140  1164     -
71  DATA1                        25   Alphanumeric       1165  1189     -
72  LABEL2                       25   Alphanumeric       1190  1214     -
73  DATA2                        25   Alphanumeric       1215  1239     -
74  LABEL3                       25   Alphanumeric       1240  1264     -
75  DATA3                        25   Alphanumeric       1265  1289     -
76  LABEL4                       25   Alphanumeric       1290  1314     -
77  DATA4                        25   Alphanumeric       1315  1339     -
78  LABEL5                       25   Alphanumeric       1340  1364     -
79  DATA5                        25   Alphanumeric       1365  1389     -
80  LABEL6                       25   Alphanumeric       1390  1414     -
81  DATA6                        25   Alphanumeric       1415  1439     -
82  LABEL7                       25   Alphanumeric       1440  1464     -
83  DATA7                        25   Alphanumeric       1465  1489     -
84  LABEL8                       25   Alphanumeric       1490  1514     -
85  DATA8                        25   Alphanumeric       1515  1539     -
86  LABEL9                       25   Alphanumeric       1540  1564     -
87  DATA9                        25   Alphanumeric       1565  1589     -
88  LABEL10                      25   Alphanumeric       1590  1614     -
89  DATA10                       25   Alphanumeric       1615  1639     -
90  LABEL11                      25   Alphanumeric       1640  1664     -
91  DATA11                       25   Alphanumeric       1665  1689     -
92  LABEL12                      25   Alphanumeric       1690  1714     -
93  DATA12                       25   Alphanumeric       1715  1739     -
94  DISPUTE_CODE                  2   Alphanumeric       1740  1741     -
95  DISPUTE_AMOUNT               17   Alphanumeric       1742  1758     0
96  ADJ_NUMBER_AREA               6   Alphanumeric       1759  1764     -
97  TEXT_FILLER_AREA              1   Character_space    1765  1765     -
98  DISPUTE_TEXT_AREA           437   Alphanumeric       1766  2202     -
}

set trailer_record {
1   REC_TYPE                      1   Alphanumeric          1  1        -
2   AMEX_APPL_AREA              100   Character_spaces      2  101      -
3   SAID                          6   Alphanumeric        102  107      -
4   DATATYPE                      5   Alphanumeric        108  112      -
5   CCYYDDD                       7   Alphanumeric        113  119      0
6   0HHMMSS                       7   Numeric             120  126      0
7   STARS_FILESEQ_NB              3   Numeric             127  129      0
8   FILLER                       72   Character_spaces    130  201      -
9   CLIENT_AREA                 100   Alphanumeric        202  301      -
10  FILLER                     1901   Character_spaces    302  2202     -
}


################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################

proc usage {} {
   global programName

   puts "Usage:   $programName <-d run date>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "EXAMPLE = CBDIS_builder.tcl -d 20130910"
}

################################################################################
#
#    Procedure Name - init
#
#    Description - Initialize program arguments
#
###############################################################################
proc init {argv} {
   global programName
   global cfg_file
   global inst
   global runDate
   global fileName
   global outFilePtr
   global CCYYDDD
   global HHMMSS

   set runDate ""
   set inst ""
   set group ""

    foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
       }
    }


    if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
    }

     #### T-1 Need to redifine this in cfg file
    set fileName "JETPAYEAPTST.CBDIS.$runDate"
    if {[catch {open $fileName w} outFilePtr]} {
       puts "File Open Err:Cannot open outputfile $fileName"
       exit 1
    }


    ### Read the config file to get DB params
    readCfgFile $cfg_file

    ### Intitalize database variables
    initDB
  
    set CCYYDDD [clock format [clock seconds] -format "%Y%j"]
    set HHMMSS [clock format [clock seconds] -format "0%H%M%S"]

    puts "============================START=========================="
    puts "$programName.tcl started at [clock format [clock seconds] -format "%Y%m%d%H%M%S"]\n"
}
################################################################################
#
#    Procedure Name - initDB
#
#    Description - Setup the DB, tables and handles
#
#    Return - exit 3 if any error
#
###############################################################################
proc initDB {} {
   global programName
   global prod_db
   global clr_db_logon
   global ami_tb
   global adt_tb
   global verify_tb


    ## MASCLR and TIEHOST connection ##
    if {[catch { set clr_db_logon_handle [oralogon $clr_db_logon@$prod_db] } result] } {
       puts "Encountered error $result while trying to connect to the $prod_db database "
       exit 3
    }

    if {[catch {
           set ami_tb               [oraopen $clr_db_logon_handle]
           set adt_tb                [oraopen $clr_db_logon_handle]
           set verify_tb             [oraopen $clr_db_logon_handle]
        } result ]} {
        puts "Encountered error $result while creating db handles"
        exit 3
    }

}
################################################################################
#
#    Procedure Name - readCfgFile
#
#    Description - Gets the DB parameters
#
#    Return - 3 if any error
#
###############################################################################
proc readCfgFile {cfg_file_name} {
   global programName
   global clr_db_logon
   global auth_db_logon
   global said
   global fileType
   

   set clr_db_logon ""

    if {[catch {open $cfg_file_name r} file_ptr]} {
        puts "File Open Err:Cannot open config file $cfg_file_name"
        exit 1
    }


    while { [set line [gets $file_ptr]] != {}} {
        set line_parms [split $line ,]
        switch -exact -- [lindex  $line_parms 0] {
           "CLR_DB_LOGON" {
              set clr_db_logon [lindex $line_parms 1]
            }
            "AUTH_DB_LOGON" {
               set auth_db_logon [lindex $line_parms 1]
            }
            "SAID" {
                set said [lindex $line_parms 1]
            }
            "DATATYPE" {
                set fileType [lindex $line_parms 1]
            }
            default {
               puts "Unknown config parameter [lindex $line_parms 0]"
           }
        }
    }

    close $file_ptr

    if {$clr_db_logon == ""} {
        puts "Unable to find CLR_DB_LOGON params in $cfg_file_name, exiting..."
        exit 1
    }

}

################################################################################
#
#    Procedure Name - 
#
#    Description -
#
#    Return -
###############################################################################
proc getSeqNbr {} {
global programName
global runDate
global seq_file
global STARS_FILESEQ_NB

set seq 1

   if {[catch {open $seq_file r+} file_ptr]} {
        puts "File Open Err:Cannot open seq_file $seq_file"
        exit 1
    }

    gets $file_ptr line
    set line_parms [split $line ,]
    puts "T-1 runDate=$runDate, file=[lindex  $line_parms 0]"
    if {[lindex  $line_parms 0] == "$runDate"} {
       set seq [lindex  $line_parms 1]
       incr seq
       seek $file_ptr 0
       puts -nonewline $file_ptr ""
       seek $file_ptr 0
       puts $file_ptr "$runDate,$seq"

    } else {
       seek $file_ptr 0
       puts -nonewline $file_ptr ""
       seek $file_ptr 0
       puts $file_ptr "$runDate,$seq"
    }

    close $file_ptr

    set STARS_FILESEQ_NB $seq


}

################################################################################
#
#    Procedure Name - process
#
#    Description -
#
#    Return -
###############################################################################
proc process {} {
global programName
global runDate
global fileName
global outFilePtr
global adt_tb
global detail_record

   buildFileHeader
   set columns ""
   foreach {num name len type start end justify} $detail_record {
      if {$name == "FILLER" || $name == "XREF_SE_NUMB" || $name == "TEXT_FILLER_AREA"|| $name == "DISPUTE_CODE" || $name == "REC_TYPE"} {
         continue
      }
      if {$name == "DATE_OF_ADJUSTMENT" || $name == "DATE_OF_CHARGE" || $name == "MERCH_ORDER_DATE" || $name == "CANC_DATE"} {
         append columns "to_char ($name,'YYYYMMDD') as $name, "
      } else {
         append columns "$name, "
      }
   }

   set columns [string trimright [string trimright $columns] ,]
   puts "T-1 columns = $columns"

   set query "select $columns
               from amex_dispute_txn
               where file_type = 'CBDIS'
               and to_char(log_date,'YYYYMMDD') = '$runDate'
               and fin_ind = 'Y'"

   puts "T-1 QUERY= $query"
   orasql $adt_tb $query

   while {[orafetch $adt_tb -dataarray adt -indexbyname] != 1403} {
       buildDetailRecord adt
   }; #end of while orafetch

   buildFileTrailer
}

################################################################################
#
#    Procedure Name - buildFileHeader
#
#    Description -
#
#    Return -
###############################################################################
proc buildFileHeader {} {
global programName
global fileName
global outFilePtr
global said
global fileType
global file_hdr
global CCYYDDD
global HHMMSS
global STARS_FILESEQ_NB

   getSeqNbr

   set header ""
   set hdrBuff(REC_TYPE) "H"
   set hdrBuff(SAID)     "$said" 
   set hdrBuff(DATATYPE) "$fileType"
   set hdrBuff(STARS_FILESEQ_NB) $STARS_FILESEQ_NB
   set hdrBuff(CCYYDDD) $CCYYDDD
   set hdrBuff(0HHMMSS) "$HHMMSS"

   foreach {num name len type start end justify} $file_hdr {
       #puts "T-1 $num $name $length $type $start $end"
    
       if {[info exists hdrBuff($name) ] == 1} {
          #puts "T-1 found var hdrBuff($name)=$hdrBuff($name)"
          append header [format "%$justify*s" $len $hdrBuff($name)]
          #puts "T-1 header=$header"
       } else {
          set value " "
          append header [format  "%$justify*s" $len $value]
       }

   }
   puts $outFilePtr $header
}

################################################################################
#
#    Procedure Name - buildDetailRecord
#
#    Description -
#
#    Return -
###############################################################################
proc buildDetailRecord {buff} {
global programName
global fileName
global outFilePtr
global detail_record

upvar $buff detBuff

   set detail ""
   set local(REC_TYPE) "D"
   set local(DISPUTE_CODE) "01"

   ###AMOUNT

   foreach {num name len type start end justify} $detail_record {

       if {[info exists detBuff($name) ] == 1} {
          if { $name == "CB_AMOUNT" || $name == "BILLED_AMOUNT" || $name == "SOC_AMOUNT" || $name == "DISPUTE_AMOUNT"} {
             if {[string range $detBuff($name) 0 0 ] == "-"} {
                 set amount ""
                 append amount "-"
                 append amount [format %016.2f [string range $detBuff($name) 1 end] ]
             } else {
                 set amount ""
                 append amount " "
                 append amount [format %016.2f [string range $detBuff($name) 0 end] ]
             }
             puts "T-1 $name =$amount"
             append detail $amount
          } else {
              append detail [format "%$justify*s" $len $detBuff($name)]
          }
       } elseif {[info exists local($name) ] == 1} {
          append detail [format "%$justify*s" $len $local($name)]
       } else {
          set value " "
          append detail [format  "%$justify*s" $len $value]
       }
   }; #endof foreach

   puts $outFilePtr $detail

}

################################################################################
#
#    Procedure Name - buildFileTrailer
#
#    Description -
#
#    Return -
###############################################################################
proc buildFileTrailer {} {
global programName
global fileName
global outFilePtr
global said
global fileType
global trailer_record
global CCYYDDD
global HHMMSS
global STARS_FILESEQ_NB

   set trailer ""
   set trlBuff(REC_TYPE) "T"
   set trlBuff(SAID)     "$said"
   set trlBuff(DATATYPE) "$fileType"
   set trlBuff(STARS_FILESEQ_NB) $STARS_FILESEQ_NB
   set trlBuff(CCYYDDD) $CCYYDDD
   set trlBuff(0HHMMSS) "$HHMMSS"

   foreach {num name len type start end justify} $trailer_record {
       #puts "T-1 $num $name $length $type $start $end"

       if {[info exists trlBuff($name) ] == 1} {
          #puts "T-1 found var hdrBuff($name)=$hdrBuff($name)"
          append trailer [format "%$justify*s" $len $trlBuff($name)]
          #puts "T-1 header=$header"
       } else {
          set value " "
          append trailer [format  "%$justify*s" $len $value]
       }

   }
   puts $outFilePtr $trailer
}




##########
## MAIN ##
##########

init $argv
process
