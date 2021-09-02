#!/usr/bin/env tclsh
#/clearing/filemgr/.profile

# $Id: $

################################################################################
#
#    File Name - CBNSP_parser.tcl
#
#    Description - This scripts checks to see if the neccesary files were
#                  imported into the MAS or not.
#
#    Arguments-  -f = file to parse
#                -d = run date YYYYMMDD optional, defaults to sysdate
#
#    EXAMPLE = CBNSP_parser.tcl -f <filename> -d <YYYYMMDD>
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
set error 0
################################################################################
#
#    Procedure Name - usage
#
#    Description - Print the script usage
#
###############################################################################

proc usage {} {
   global programName

   puts "Usage:   $programName <-f file to parse> <-d run date>"
   puts "     where -d = Run date YYYYMMDD,optional. Defaults to sysdate"
   puts "           -f = file to parse"
   puts "EXAMPLE = CBNSP_parser.tcl -f file -d 20130910"
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
   global inputFile

   set runDate ""
   set inst ""
   set group ""

    foreach {opt} [split $argv -] {
      switch -exact -- [lindex $opt 0] {
         "d" {
            set runDate [lrange $opt 1 end]
         }
         "f" {
            set inputFile [lrange $opt 1 end]
         }
        }
    }


    if {$runDate == ""} {
      set runDate [clock format [clock second] -format "%Y%m%d"]
    }

    if {$inputFile == ""} {
      puts "Insufficient Arguments:Need file name to parse"
      usage
      exit 1
    }


    ### Read the config file to get DB params
    readCfgFile $cfg_file

    ### Intitalize database variables
    initDB

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
#    set the structure for file header
#   <field#> <field_name> <length> <data type in the file> <start field position> <end field position> <data type in DB>
###############################################################################
set file_hdr {
1 REC_TYPE         1 Alphanumeric       0 0     skip 
2 AMEX_APPL_AREA 100 Alphanumeric       1 100   skip 
3 SAID             6 Alphanumeric     101 106   skip 
4 DATATYPE         5 Alphanumeric     107 111   varchar 
5 CCYYDDD          7 Alphanumeric     112 118   skip 
6 0HHMMSS          7 Numeric          119 125   skip 
7 FILLER        2076 Character_spaces 126 2201  skip
}
set maxHdrFld 7

set detail_record {
1   REC_TYPE                       1 Alphanumeric             0   0     skip
2   FIN_IND                        1 Alphanumeric             1   1     varchar
3   FILLER                         4 Character_spaces         2   5     skip
4   SE_NUMB                       10 Alphanumeric             6   15    varchar
5   FILLER                        10 Character_spaces        16   25    skip
6   CM_ACCT_NUMB                  15 Alphanumeric            26   40    varchar
7   FILLER                         5 Character_spaces        41   45    skip
8   CURRENT_CASE_NUMBER           11 Alphanumeric            46   56    varchar
9   CURRENT_ACTION_NUMBER          2 Alphanumeric            57   58    varchar
10  PREVIOUS_CASE_NUMBER          11 Alphanumeric            59   69    varchar
11  PREVIOUS_ACTION_NUMBER         2 Alphanumeric            70   71    varchar
12  RESOLUTION                     1 Alphanumeric            72   72    varchar
13  FROM_SYSTEM                    1 Alphanumeric            73   73    varchar
14  REJECTS_TO_SYSTEM              1 Alphanumeric            74   74    varchar
15  DISPUTES_TO_SYSTEM             1 Alphanumeric            75   75    varchar
16  DATE_OF_ADJUSTMENT             8 Alphanumeric            76   83    date   
17  DATE_OF_CHARGE                 8 Alphanumeric            84   91    date   
18  AMEX_ID                        7 Alphanumeric            92   98    varchar
19  FILLER                         5 Character_spaces        99   103   skip
20  CASE_TYPE                      6 Alphanumeric           104   109   varchar
21  LOC_NUMB                      15 Alphanumeric           110   124   varchar
22  REASON_CODE                   3 Alphanumeric           125   127   varchar
23  CB_AMOUNT                     17 Numeric_signed         128   144   number
24  CB_ADJUSTMENT_NUMBER           6 Alphanumeric           145   150   varchar
25  CB_RESOLUTION_ADJ_NUMBER       6 Alphanumeric           151   156   varchar
26  CB_REFERENCE_CODE             12 Alphanumeric           157   168   varchar
27  FILLER                        13 Character_spaces       169   181   skip
28  BILLED_AMOUNT                 17 Numeric_signed         182   198   number
29  SOC_AMOUNT                    17 Numeric_signed         199   215   number
30  SOC_INVOICE_NUMBER             6 Alphanumeric           216   221   varchar
31  ROC_INVOICE_NUMBER             6 Alphanumeric           222   227   varchar
32  FOREIGN_AMT                   15 Alphanumeric           228   242   varchar
33  CURRENCY                       3 Alphanumeric           243   245   varchar
34  SUPP_TO_FOLLOW                 1 Alphanumeric           246   246   varchar
35  CM_NAME1                      30 Alphanumeric           247   276   varchar
36  CM_NAME2                      30 Alphanumeric           277   306   varchar
37  CM_ADDR1                      30 Alphanumeric           307   336   varchar
38  CM_ADDR2                      30 Alphanumeric           337   366   varchar
39  CM_CITY_STATE                 30 Alphanumeric           367   396   varchar
40  CM_ZIP                         9 Alphanumeric           397   405   varchar
41  CM_FIRST_NAME_1               12 Alphanumeric           406   417   varchar
42  CM_MIDDLE_NAME_1              12 Alphanumeric           418   429   varchar
43  CM_LAST_NAME_1                20 Alphanumeric           430   449   varchar
44  CM_ORIG_ACCT_NUM              15 Alphanumeric           450   464   varchar
45  CM_ORIG_NAME                  30 Alphanumeric           465   494   varchar
46  CM_ORIG_FIRST_NAME            12 Alphanumeric           495   506   varchar
47  CM_ORIG_MIDDLE_NAME           12 Alphanumeric           507   518   varchar
48  CM_ORIG_LAST_NAME             20 Alphanumeric           519   538   varchar
49  NOTE1                         66 Alphanumeric           539   604   varchar
50  NOTE2                         78 Alphanumeric           605   682   varchar
51  NOTE3                         60 Alphanumeric           683   742   varchar
52  NOTE4                         60 Alphanumeric           743   802   varchar
53  NOTE5                         60 Alphanumeric           803   862   varchar
54  NOTE6                         60 Alphanumeric           863   922   varchar
55  NOTE7                         60 Alphanumeric           923   982   varchar
56  TRIUMPH_SEQ_NO                 2 Alphanumeric           983   984   varchar
57  FILLER                        20 Character_spaces       985   1004  skip
58  SELLER_ID                     15 Character_spaces      1005   1019  varchar
59  FILLER                        10 Character_spaces      1020   1029  skip
60  AIRLINE_TKT_NUM               14 Alphanumeric          1030   1043  varchar
61  AL_SEQUENCE_NUMBER             2 Alphanumeric          1044   1045  varchar
62  FOLIO_REF                     18 Alphanumeric          1046   1063  varchar
63  MERCH_ORDER_NUM               10 Alphanumeric          1064   1073  varchar
64  MERCH_ORDER_DATE               8 Alphanumeric          1074   1081  date   
65  CANC_NUM                      20 Alphanumeric          1082   1101  varchar
66  CANC_DATE                      8 Alphanumeric          1102   1109  date   
67  FINCAP_TRACKING_ID            11 Alphanumeric          1110   1120  varchar
68  FINCAP_FILE_SEQ_NUM            6 Alphanumeric          1121   1126  varchar
69  FINCAP_BATCH_NUMBER            4 Alphanumeric          1127   1130  varchar
70  FINCAP_BATCH_INVOICE_DT        8 Alphanumeric          1131   1138  varchar
71  LABEL1                        25 Alphanumeric          1139   1163  varchar
72  DATA1                         25 Alphanumeric          1164   1188  varchar
73  LABEL2                        25 Alphanumeric          1189   1213  varchar
74  DATA2                         25 Alphanumeric          1214   1238  varchar
75  LABEL3                        25 Alphanumeric          1239   1263  varchar
76  DATA3                         25 Alphanumeric          1264   1288  varchar
77  LABEL4                        25 Alphanumeric          1289   1313  varchar
78  DATA4                         25 Alphanumeric          1314   1338  varchar
79  LABEL5                        25 Alphanumeric          1339   1363  varchar
80  DATA5                         25 Alphanumeric          1364   1388  varchar
81  LABEL6                        25 Alphanumeric          1389   1413  varchar
82  DATA6                         25 Alphanumeric          1414   1438  varchar
83  LABEL7                        25 Alphanumeric          1439   1463  varchar
84  DATA7                         25 Alphanumeric          1464   1488  varchar
85  LABEL8                        25 Alphanumeric          1489   1513  varchar
86  DATA8                         25 Alphanumeric          1514   1538  varchar
87  LABEL9                        25 Alphanumeric          1539   1563  varchar
88  DATA9                         25 Alphanumeric          1564   1588  varchar
89  LABEL10                       25 Alphanumeric          1589   1613  varchar
90  DATA10                        25 Alphanumeric          1614   1638  varchar
91  LABEL11                       25 Alphanumeric          1639   1663  varchar
92  DATA11                        25 Alphanumeric          1664   1688  varchar
93  LABEL12                       25 Alphanumeric          1689   1713  varchar
94  DATA12                        25 Alphanumeric          1714   1738  varchar
95  FILLER                        26 Character_spaces      1739   1764  skip
96  IND_FORM_CODE                  2 Alphanumeric          1765   1766  varchar
97  IND_REF_NUMBER                30 Alphanumeric          1767   1796  varchar
98  FILLER                         3 Character_spaces      1797   1799  skip
99  LOC_REF_NUMBER                15 Alphanumeric          1800   1814  varchar
100 PASSENGER_NAME                20 Alphanumeric          1815   1834  varchar
101 PASSENGER_FIRST_NAME          12 Alphanumeric          1835   1846  varchar
102 PASSENGER_MIDDLE_NAME         12 Alphanumeric          1847   1858  varchar
103 PASSENGER_LAST_NAME           20 Alphanumeric          1859   1878  varchar
104 SE_PROCESS_DATE                3 Alphanumeric          1879   1881  varchar
105 RETURN_DATE                    6 Alphanumeric          1882   1887  date   
106 CREDIT_RECEIPT_NUMBER         15 Alphanumeric          1888   1902  varchar
107 RETURN_TO_NAME                24 Alphanumeric          1903   1926  varchar
108 RETURN_TO_STREET              17 Alphanumeric          1927   1943  varchar
109 CARD_DEPOSIT                   1 Alphanumeric          1944   1944  varchar
110 ASSURED_RESERVATION            1 Alphanumeric          1945   1945  varchar
111 RES_CANCELLED                  1 Alphanumeric          1946   1946  varchar
112 RES_CANCELLED_DATE             6 Alphanumeric          1947   1952  date   
113 CANCEL_ZONE                    1 Alphanumeric          1953   1953  varchar
114 RESERVATION_MADE_FOR           6 Alphanumeric          1954   1959  varchar
115 RESERVATION_LOCATION          20 Alphanumeric          1960   1979  varchar
116 RESERVATION_MADE_ON            6 Alphanumeric          1980   1985  varchar
117 RENTAL_AGREEMENT_NUMBER       18 Alphanumeric          1986   2003  varchar
118 MERCHANDISE_TYPE              20 Alphanumeric          2004   2023  varchar
119 MERCHANDISE_RETURNED           1 Alphanumeric          2024   2024  varchar
120 RETURNED_NAME                 24 Alphanumeric          2025   2048  varchar
121 RETURNED_DATE                  6 Alphanumeric          2049   2054  date   
122 RETURNED_HOW                   8 Alphanumeric          2055   2062  varchar
123 RETURNED_REASON               50 Alphanumeric          2063   2112  varchar
124 STORE_CREDIT_RECEIVED          1 Alphanumeric          2113   2113  varchar
125 FILLER                        15 Character_spaces      2114   2128  skip
126 FILLER                       387 Character_spaces       2129  2201  skip
}

set maxDetailFld 126

set trailer_record {
1   REC_TYPE               1 Alphanumeric         0    0   skip
2   AMEX_APPL_AREA       100 Alphanumeric	  1  100   skip
3   SAID	           6 Alphanumeric	101  106   skip
4   DATATYPE	           5 Alphanumeric	107  111   skip
5   CCYYDDD	           7 Alphanumeric	112  118   skip
6   0HHMMSS	           7 Numeric	        119  125   skip
7   STARS_FILESEQ_NB       3 Numeric	        126  128   skip
8   FILLER	        2073 Character_spaces   129  2201  skip
}
set maxTrailerFld 8

################################################################################
#
#    Procedure Name - process
#
#    Description - Gets the expected file count, actual file count and compares the values
#
#    Return - 
###############################################################################
proc process {} {
global programName
global inputFile
global maxHdrFld
global maxDetailFld
global maxTrailerFld
global file_hdr
global detail_record
global trailer_record
global ami_tb
global adt_tb

set institution_id ""
set entity_id ""
set insertValue ""
set insertColumn ""

set logDate [clock format [clock second] -format "%Y%m%d%H%M%S"]

    ## Reset the header buffer
    foreach {num name length type start end db_type} $file_hdr {
       set HdrValue($name) ""
    }

    ## Reset the detail record buffer
    foreach {num name length type start end db_type} $detail_record {
       #puts "T-1 $num $name $length $type $start $end"
       set DetailValue($name) ""
    }

    ## Reset trailer buffer
    foreach {num name length type start end db_type} $trailer_record {
       #puts "T-1 $num $name $length $type $start $end"
       set TrailerValue($name) ""
    }

    if {[catch {open $inputFile r} filePtr]} {
        puts "File Open Err:Cannot open file $inputFile"
        exit 1
    }

    while { [gets $filePtr line] >= 0 } {
        switch -exact -- [ string range $line 0 0 ] {
            "H" {
                puts "Parsing Header Record"
                foreach {num name length type start end db_type} $file_hdr {
                   #puts "T-1 $num $name $length $type $start $end"
                   set HdrValue($name) [string trim [string range $line $start $end]]
                   #puts "T-1 HdrValue($name) = $HdrValue($name)"
                }; #end of for loop
            }
            "D" {
                puts "Parsing Detail Record"
                foreach {num name length type start end db_type} $detail_record {
                    set DetailValue($name) [string trim [string range $line $start $end]]
                   # puts "T-1 DetailValue($name) = $DetailValue($name)"
                    #puts "T-1 Amount = $DetailValue(CB_AMOUNT) and TRIMAMOUNT=[string trimleft $DetailValue(CB_AMOUNT) 0]"
                }; #end of for loop
            }
            "T" {
                puts "Parsing Trailer Record"
                foreach {num name length type start end db_type} $trailer_record {
                    set TrailerValue($name) [string trim [string range $line $start $end]]
                    #puts "T-1 TrailerValue($name) = $TrailerValue($name)"
                }; #end of for loop
            }
        }; #endof switch case
 
        ### Data Edits on detail record
        if { [ string range $line 0 0 ] == "D" } {
           #if {[string range $DetailValue(CB_AMOUNT) 0 0] == "-"} {
           #   set DetailValue(CB_AMOUNT) "[string range $DetailValue(CB_AMOUNT) 0 0][string trimleft [string range $DetailValue(CB_AMOUNT) 1 end] 0]"
              #puts "T-1 after edits $DetailValue(CB_AMOUNT)"
           #} elseif {[string range $DetailValue(CB_AMOUNT) 0 0] == " "} {
           #   set DetailValue(CB_AMOUNT) "[string trimleft [string range $DetailValue(CB_AMOUNT) 1 end] 0]"
              #puts "T-1 after edits $DetailValue(CB_AMOUNT)"
           #}
  
           #if {[string range $DetailValue(BILLED_AMOUNT) 0 0] == "-"} {
           #   set DetailValue(BILLED_AMOUNT) "[string range $DetailValue(BILLED_AMOUNT) 0 0][string trimleft [string range $DetailValue(BILLED_AMOUNT) 1 end] 0]"
              #puts "T-1 after edits $DetailValue(BILLED_AMOUNT)"
           #} elseif {[string range $DetailValue(BILLED_AMOUNT) 0 0] == " "} {
           #   set DetailValue(BILLED_AMOUNT) "[string trimleft [string range $DetailValue(BILLED_AMOUNT) 1 end] 0]"
              #puts "T-1 after edits $DetailValue(BILLED_AMOUNT)"
           #}

           #if {[string range $DetailValue(SOC_AMOUNT) 0 0] == "-"} {
           #   set DetailValue(SOC_AMOUNT) "[string range $DetailValue(SOC_AMOUNT) 0 0][string trimleft [string range $DetailValue(SOC_AMOUNT) 1 end] 0]"
              #puts "T-1 after edits $DetailValue(SOC_AMOUNT)"
           #} elseif {[string range $DetailValue(SOC_AMOUNT) 0 0] == " "} {
           #   set DetailValue(SOC_AMOUNT) "[string trimleft [string range $DetailValue(SOC_AMOUNT) 1 end] 0]"
              #puts "T-1 after edits $DetailValue(SOC_AMOUNT)"
           #}

           ### Get the institution and visa_id
           set institution_id ""
           set entity_id ""

           set query "select institution_id,entity_id
                      from alt_merchant_id
                      where card_scheme = '03'
                      and cs_merchant_id = '$DetailValue(SELLER_ID)'" 
 
           orasql $ami_tb $query

           while {[orafetch $ami_tb -dataarray ami -indexbyname] != 1403} {
              set institution_id "$ami(INSTITUTION_ID)"
              set entity_id "$ami(ENTITY_ID)"
           }; #endof while for ami_tb
           
           if {$institution_id == "" || $entity_id == "" } {
              puts "ERROR: Could not find the institution and visa id for seller id = $DetailValue(SELLER_ID) in alt_merchant_id table"
           }

           ### Build the insert statement
           ### NOTE the insertColumn and insertValue go in pair. The sequence is absolutely cruicial to maintain data integrity

           set insertValue ""
           set insertColumn "" 

           append insertColumn "INSTITUTION_ID,"
           append insertValue "\'$institution_id\',"

           append insertColumn "VISA_ID,\n"
           append insertValue "\'$entity_id\',"
 
           append insertColumn "FILE_NAME,"
           append insertValue "\'$inputFile\',"
 
           append insertColumn "FILE_TYPE,"
           append insertValue "\'$HdrValue(DATATYPE)\',"
 
           append insertColumn "SAID,"
           append insertValue "\'$HdrValue(SAID)\',"

           append insertColumn "LOG_DATE,"
           append insertValue "to_date\(\'$logDate\',\'YYYYMMDDHH24MISS\'\),"

           foreach {num name length type start end db_type} $detail_record {
               if { $name == "FILLER" || $name == "REC_TYPE"} {
                  continue
               }
               if {$db_type == "date"} {
                  if {$name == "RES_CANCELLED_DATE" || $name == "RETURN_DATE" || $name == "RETURNED_DATE"} {
                     ### incoming date format YYMMDD
                     append insertColumn "$name,"
                     append insertValue "to_date\(\'$DetailValue($name)\',\'YYMMDDHH24MISS\'\),"
                  } else {
                     ### incoming date format YYYYMMDD
                     append insertColumn "$name,"
                     append insertValue "to_date\(\'$DetailValue($name)\',\'YYYYMMDDHH24MISS\'\),"
                  }
               } else {
                  append insertColumn "$name,"
                  append insertValue "\'$DetailValue($name)\',"
               }
           }; #endof foreach


           set insertColumn [string trimright [string trimright $insertColumn] ,]
           set insertValue [string trimright [string trimright $insertValue] ,]

           set query "insert into AMEX_DISPUTE_TXN 
                       \($insertColumn\) 
                       values \($insertValue\)"
           #puts "T-1 $query"

           if {[catch {orasql $adt_tb $query} result]} {
              puts "ERROR: Encoutered error while inserting row into AMEX_DISPUTE_TXN table"
              puts "ERROR REASON: $result"
              puts "ERROR RESOLUTION: Fix the query and rerun the query only on SQL Developer"
              puts "ERROR QUERY - $query"
           }



        }; #end of if detail record
    } ; #Endof while fileptr

}


##########
## MAIN ##
##########

init $argv
process
