#!/usr/bin/env tclsh
#/home/msanders/.profile

package require Oratcl

set inbin [string trim [lindex $argv 0]]

proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string touppe [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array

proc state_name {st_cd} {

        switch $st_cd {
                "AL"    {set state  "Alabama"}
                "AK"    {set state  "Alaska"}
                "AZ"    {set state  "Arizon"}
                "AR"    {set state  "Arkansas"}
                "CA"    {set state  "California"}
                "CO"    {set state  "Colorado"}
                "CT"    {set state  "Connecticut"}
                "DE"    {set state  "Delaware"}
                "DC"    {set state  "District of Columbia"}
                "FL"    {set state  "Florida"}
                "GA"    {set state  "Georgia"}
                "HI"    {set state  "Hawaii"}
                "ID"    {set state  "Idaho"}
                "IL"    {set state  "Illinois"}
                "IN"    {set state  "Indiana"}
                "IA"    {set state  "Iowa"}
                "KS"    {set state  "Kansas"}
                "KY"    {set state  "Kentucky"}
                "LA"    {set state  "Louisiana"}
                "ME"    {set state  "Maine"}
                "MD"    {set state  "Maryland"}
                "MA"    {set state  "Massachusetts"}
                "MI"    {set state  "Michigan"}
                "MN"    {set state  "Minnesota"}
                "MS"    {set state  "Mississippi"}
                "MO"    {set state  "Missouri"}
                "MT"    {set state  "Montana"}
                "NE"    {set state  "Nebraska"}
                "NV"    {set state  "Nevada"}
                "NH"    {set state  "New Hampshire"}
                "NJ"    {set state  "New Jersy "}
                "NM"    {set state  "New Mexico"}
                "NY"    {set state  "New York"}
                "NC"    {set state  "North Carolina"}
                "ND"    {set state  "North Dakota"}
                "OH"    {set state  "Ohio"}
                "OK"    {set state  "Oklahoma"}
                "OR"    {set state  "Oregon"}
                "PA"    {set state  "Pennsylvania"}
                "RI"    {set state  "Rhode Island"}
                "SC"    {set state  "South Carolina"}
                "SD"    {set state  "South Dakota"}
                "TN"    {set state  "Tennessee"}
                "TX"    {set state  "Texas"}
                "UT"    {set state  "Utah"}
                "VT"    {set state  "Vermont"}
                "VA"    {set state  "Virginia"}
                "WA"    {set state  "Washington"}
                "WV"    {set state  "West Virginia"}
                "WI"    {set state  "Wisconsin"}
                "WY"    {set state  "Wyoming"}
                "XX"    {set state  "U.S. military base embassies traveling merchants"}
                "AB"    {set state  "Alberta"}
                "BC"    {set state  "British Columbia"}
                "MB"    {set state  "Manitoba"}
                "NB"    {set state  "New Brunswick"}
                "NF"    {set state  "Newfoundland"}
                "NT"    {set state  "Northwest Terriotories"}
                "NS"    {set state  "Nova Scotia"}
                "NV"    {set state  "Nunavut"}
                "ON"    {set state  "Ontario"}
                "PE"    {set state  "Prince Edward Island"}
                "PQ"    {set state  "Quebec"}
                "QP"    {set state  "Quebec"}
                "SK"    {set state  "Saskatchewan"}
                "YT"    {set state  "Yukon Terrotory"}
                "NL"    {set state  "Newfoundland and Labrador"}
                "QC"    {set state  "Quebec"}
                        default {set state "OTHER"}
        }
set state [string range [string trim [string toupper $state]] 0 49]
set state [string trim $state]
return $state
}

set currdate [clock seconds]
set currdate [clock format $currdate -format "%d/%b/%y"]
puts $currdate

set zt "01"
set xt [clock format [clock scan "next month"] -format "%Y%m"]
set dt $xt$zt
set yt [clock scan $dt]
set yt [clock format $yt -format "%d/%b/%y"]


if {[catch {set handler [oralogon masclr/masclr@$env(IST_DB)]} result]} {
  exec echo "merchant_boarder.tcl failed to run" | mailx -r teiprod@jetpay.com -s "Merchant boarder" rkhan@jetpay.com
  exit
}


if {[catch {set qahandler [oralogon teihost/quikdraw@$env(ATH_DB)]} result]} {
  exec echo "merchant_boarder.tcl failed to run" | mailx -r teiprod@jetpay.com -s "Merchant boarder" rkhan@jetpay.com
  exit
}
set inst_id ""
set info_get [oraopen $qahandler]

set input [open jtpy.txt r]
set cursor [oraopen $handler]
set failed 0
set get [oraopen $handler]
set test_cursor [oraopen $handler]
set test_cursor1 [oraopen $handler]
set settle_cursor [oraopen $handler]
set update_cursor [oraopen $handler]
set cur_line  [split [set orig_line [gets $input] ] ,]
#clean out boarding area
    set delete_string "delete settl_plan_tbl"
#    orasql $update_cursor $delete_string
#    oracommit $handler
    set delete_string "delete master_address_tbl" 
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete master_contact_tbl"
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete acq_entity_tbl"
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete acq_entity_address_tbl"
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete acq_entity_contact_tbl"
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete entity_fee_pkg_tbl"
#    orasql $update_cursor $delete_string
#    oracommit $handler
    set delete_string "delete entity_acct_tbl"
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete alt_merchant_id_tbl"
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete entity_to_auth_tbl"
    orasql $update_cursor $delete_string
    oracommit $handler
    set delete_string "delete ENTITY_HIERARCHY_TBL"
    orasql $update_cursor $delete_string
    oracommit $handler


set sq_list { address_id contact_id entity_acct_id }

set addy_id ""
set cont_id ""
set e_acct_id ""
set ck 1


proc random_gen {digit} {

switch $digit {
        "8" {set multplr 100000000}
        "7" {set multplr 10000000}
        "5" {set multplr 100000}
}
set fint "d"
append dig $digit $fint
set y 0
set seed [clock click]
set trand [expr srand($seed)]
set randnum [expr int([expr $trand * $multplr])]
set randnum [format %0$dig $randnum]
#puts "randnum: $randnum"
set dig ""
return $randnum
}


proc card_id_8 {binnum tercnt} {

set series "3"


set random [random_gen 8]
set bin $binnum
append card_acc_id $bin $series $random
set card_acc_id [format %-015s $card_acc_id]
puts "card_acc_id: $card_acc_id"
set temp [string range $card_acc_id 6 end]
puts $temp
return $card_acc_id
set card_acc_id ""
}



proc card_id_7 {binnum tercnt} {

set series "5"
set zero "0"

set series "5"
set zero "0"

set random [random_gen 7]
set bin $binnum
append card_acc_id $bin $series $random $zero
set card_acc_id [format %-015s $card_acc_id]
#puts "card_acc_id: $card_acc_id"
return $card_acc_id
set card_acc_id ""
}



proc card_id_5 {binnum tercnt} {

set series "55"
set zero "0"

set random [random_gen 5]
set bin $binnum
append card_acc_id $bin $series $random $zero $zero
set card_acc_id [format %-015s $card_acc_id]
#puts "card_acc_id: $card_acc_id"
return $card_acc_id
set card_acc_id ""
}


set addy2 ""
set sp_id 150 
set sdate $yt
set country "USA"
set ph1_ext ""
set ph2 ""
set cell ""
set prnt_id ""
set c_date $currdate
set ex_date $currdate
set acct_date $currdate
set effdate $currdate
set act_date $currdate
set mcg_id ""
set state ""
set process_type "CNP"

switch $inbin {
      "415714" {set inst_id "103"
                set prnt_id "415714000000000"
                set status "A"
                set vbin "415714"
                set mbin ""
                set ica ""
                set s_name "MAX_BANK"
                set dd_flg ""
                set mas_flg "N"}
      "446509" {set inst_id "104"
                set prnt_id "446509000000000"
                set status "A"
                set vbin "446509"
                set mbin ""
                set ica ""
                set s_name "MAX_BNK_PS"
                set dd_flg ""
                set mas_flg "N"}
      "446577" {set inst_id "105"
		set prnt_id "446577000000000"
                set status "A"
                set vbin "426577"
                set mbin "525902"
                set ica "008896"
                set s_name "BNKD_CNP"
                set dd_flg ""
                set mas_flg "N"}
      "447474" {set inst_id "101"
		set prnt_id "447474000000000"
		set status "A"
		set vbin "447474"
		set mbin "526309"
		set ica "004013"
		set s_name "JETPAY"
		set dd_flg ""
		set mas_flg "Y"}
      "454045" {set inst_id "106"
                set prnt_id "454045000000000"
                set status "A"
                set vbin "454045"
                set mbin ""
                set ica ""
#                set mbin "544985"
#                set ica "010279"
                set s_name "ENTERPRIZ"
                set dd_flg ""
                set mas_flg "Y"}
        default {puts "Matching Bin not found"; exit 1}
}

while {$cur_line != ""} {

foreach sq_name $sq_list {
set get1 "select LAST_SEQ_NBR from seq_ctrl where institution_id = '$inst_id' and SEQ_NAME = '$sq_name'"
orasql $get $get1
set a_cols [oracols $get]
orafetch $get -datavariable x
puts $x
load_array seq_ctl $x $a_cols

switch $sq_name {
        "address_id" {set addy_id [expr $seq_ctl(LAST_SEQ_NBR) + 1]}
        "contact_id" {set cont_id [expr $seq_ctl(LAST_SEQ_NBR) + 1]}
        "entity_acct_id" {set e_acct_id [expr $seq_ctl(LAST_SEQ_NBR) + 1]}
}
if {$sq_name == "address_id"} {
set updt_sq "update seq_ctrl set LAST_SEQ_NBR = '$addy_id' where institution_id = '$inst_id' and seq_name = 'address_id'"
orasql $get $updt_sq
}
if {$sq_name == "contact_id"} {
set updt_sq "update seq_ctrl set LAST_SEQ_NBR = '$cont_id' where institution_id = '$inst_id' and seq_name = 'contact_id'"
orasql $get $updt_sq
}
if {$sq_name == "entity_acct_id"} {
set updt_sq "update seq_ctrl set LAST_SEQ_NBR = '$e_acct_id' where institution_id = '$inst_id' and seq_name = 'entity_acct_id'"
orasql $get $updt_sq
}

}




  set dba [string toupper [lindex $cur_line 0]]
  set ent_id [string trim [string toupper [lindex $cur_line 1]]]
  set zero 0
  set $dba "[string toupper [string map {- \  + \  & \  _ \  ' \  # \  @ \  / \  ? \  ! \  % \  $ \  * \  ( \  ) \  , \ } $dba]]"
  set dba1 $dba 
  set counter 0
  set dba_nm "[string toupper [string map {- \  + \  & \  _ \  ' \  # \  @ \  / \  ? \  ! \  % \  $ \  * \  ( \  ) \  , \ } $dba1]]"


set pln_desc $dba_nm
set ent_nm $dba_nm
  set mcc [lindex $cur_line 2]
		set mcc "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $mcc]"
  set bin [lindex $cur_line 3]
		set bin "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $bin]"
  set tax_id [lindex $cur_line 4]
		set tax_id "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $tax_id]"
  set address [string toupper [lindex $cur_line 5]]
		set address "[string toupper [string map {- \  + \  & \  _ \  ' \  # \  @ \  / \  ? \  ! \  % \  $ \  * \  ( \  ) \  , \  . \ } $address]]"
  set addy1 $address

  set address1 [string toupper [lindex $cur_line 6]]
                set address "[string toupper [string map {- \  + \  & \  _ \  ' \  # \  @ \  / \  ? \  ! \  % \  $ \  * \  ( \  ) \  , \ } $address]]"
  set counter 0
  while {$counter != [string length $address1]} {
    if {[string range $address1 $counter $counter] == "."} {
      set address1 "[string range $address1 0 [expr $counter - 1]][string range $address1 [expr $counter + 1] end]"
    }
    set counter [expr $counter + 1]
  }
  set addy2 $address1
  if {$addy2 == 0} {
    set addy2 ""
  }

  set city [lindex $cur_line 7]
		set city "[string toupper [string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $city]]"
puts $city
  set st_cd [string toupper [lindex $cur_line 8]]
		set st_cd "[string toupper [string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $st_cd]]"
  set zip [lindex $cur_line 9]
		set zip [string range "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $zip]" 0 4]
		set zip [format %05s $zip]
  set ph1 [lindex $cur_line 10]
		set ph1 "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $ph1]"
puts $ph1
  if {$ph1 == 0} {
    set ph1 "" 
  }
  set discover [lindex $cur_line 11]
  if {$discover == 0} {
    set discover ""
  }
  set amex [lindex $cur_line 12]
  if {$amex == "" || $amex == 0} {
    set amex ""
  }
  set jcb [lindex $cur_line 13]
  if {$jcb == "" || $jcb == 0} {
   set jcb ""
  }
  set diners [lindex $cur_line 14]
  if {$diners == "" || $diners == 0} {
    set diners ""
  } 
  set ktrn [lindex $cur_line 15]
  if {$ktrn == 0} {
   set ktrn ""
  }
  set kacno [lindex $cur_line 16]
  if {$kacno == "" || $kacno == 0} {
    set kacno ""
  }
  set f_nm [lindex $cur_line 17]
		set f_nm "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $f_nm]]"
  if {$f_nm == 0} {
   set f_nm ""
  }
  set m_nm [lindex $cur_line 18]
                set m_nm "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $m_nm]]"
  if {$m_nm == 0} {
   set m_nm ""
  }
  set l_nm [lindex $cur_line 19]
                set l_nm "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $l_nm]]"
  if {$l_nm == 0} {
   set l_nm ""
  }
  set pf_nm [lindex $cur_line 20]
                set pf_nm "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $pf_nm]]"
  if {$pf_nm == 0} {
   set pf_nm ""
  }
  set pm_nm [lindex $cur_line 21]
                set pm_nm "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $pm_nm]]"
  if {$pm_nm == 0} {
   set pm_nm ""
  }
  set pl_nm [lindex $cur_line 22]
                set pl_nm "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $pl_nm]]"
  if {$pl_nm == 0} {
   set pl_nm ""
  }

  set pro_ttl [string range [lindex $cur_line 23] 0 19]
		set pro_ttl "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $pro_ttl]]"
  if {$pro_ttl == 0} {
   set pro_ttl ""
  }

  set email [lindex $cur_line 24]
		set email "[string toupper $email]"
  if {$email == 0} {
   set email "NULL" 
  }
  set url [lindex $cur_line 25]
		set url "[string toupper $url]"
  if {$url == 0} {
    set url ""
  }
  set ph2 [lindex $cur_line 26]
		set ph2 "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $ph2]"
	        if {[string range $ph2 0 0] == 1} {
                	set ph2 "[string range $ph2 1 10]"
		} else {
			set ph2 "[string range $ph2 0 9]"
		}
  if {$ph2 == 0} {
   set ph2 "NULL" 
  }
  set fax [lindex $cur_line 27]
		set fax "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $fax]"
  if {$fax == 0} {
    set fax "" 
  }

  set bnk_nm [lindex $cur_line 28]
		set bnk_nm "[string toupper [string map {- \  + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , ""} $bnk_nm]]"
  if {$bnk_nm == 0} {
    set bnk_nm ""
  }
  set acno [lindex $cur_line 29]
		set acno "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $acno]"
  if {$acno == 0} {
    set acno ""
  }

  set trn [lindex $cur_line 30]
		set trn "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $trn]"
  if {$trn == 0} {
    set trn ""
  }
  set prdt_type [lindex $cur_line 31]
  if {$trn == 0} {
   puts $cur_line
   puts "Product is not spacified"
   exit 1
  } 
  set prdt_type [string toupper [string trim $prdt_type]]
  switch $prdt_type {
	"VT" {set prdt_type "CP"}
	"API" {set prdt_type "CNP"}
        "INT" {set prdt_type "CNP"}
  }
  set curncy_cd [string trim [lindex $cur_line 32]]
		set curncy_cd "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $curncy_cd]"
  if {$curncy_cd == 0} {
      puts $cur_line
      puts "Currency code not specified"
      exit 1
  }

  set cntry_cd [string trim [lindex $cur_line 33]]
                set cntry_cd "[string map {- "" + "" & "" _ "" ' "" # "" @ "" / "" ? "" ! "" % "" $ "" * "" ( "" ) "" , "" \  ""} $cntry_cd]"
  if {$cntry_cd == 0} {
      puts $cur_line
      puts "Country code not specified"
      exit 1
  }

  set process_type [string trim [lindex $cur_line 34]]
  

#set state [state_name $st_cd]
puts $state
set strn "124384602"
set sacno "5001"

set tph2 ""
if {$ph1 == $ph2} {
set tph2 ""
}

set get_mid "select * from merchant where visa_id = '$ent_id'"
orasql $info_get $get_mid
set mid_col [oracols $info_get]
orafetch $info_get -datavariable tmpmid
if {[oramsg $info_get rc] == 1403 } {
set get_mid "select * from merchant where mastercard_id = '$ent_id'"
orasql $info_get $get_mid
set mid_col [oracols $info_get]
set tmpmid ""
orafetch $info_get -datavariable tmpmid
  if {[oramsg $info_get rc] == 1403 } {
    puts "merchant not found in authside"
    oraroll $handler 
     exit 1
  } else {
load_array gmid $tmpmid $mid_col
#chnge it back to \$gmid(MID)
set mid "$gmid(MID)"
}


} else {
load_array gmid $tmpmid $mid_col 
#chnge it back to \$gmid(MID)
set mid "$gmid(MID)" 
}
puts $mid
set mid ""

set sql12 "insert into ENTITY_TO_AUTH_TBL (INSTITUTION_ID, ENTITY_ID, MID, STATUS, VISA_BIN, MC_BIN, MC_ICA, FILE_GROUP_ID, DYNAMIC_DESC_FLAG, MAS_FILE_FLAG) VALUES ('$inst_id', '$ent_id','$gmid(MID)','$status','$vbin','$mbin','$ica','$s_name','$dd_flg','$mas_flg')"
puts $sql12
orasql $cursor $sql12
oracommit $handler

set sql3 "insert into MASTER_ADDRESS_TBL (INSTITUTION_ID, ADDRESS_ID, ADDRESS1, ADDRESS2, CITY, PROV_STATE_ABBREV, PROV_STATE_NUM_CD, PROVINCE_STATE, COUNTY_CD, COUNTY, POSTAL_CD_ZIP, GEOCODE, CNTRY_CODE, COUNTRY, PHONE1, PHONE2, FAX, EMAIL_ADDRESS, URL, ADDRESS3, ADDRESS4) VALUES ('$inst_id', '$addy_id', '$addy1', '$addy2', '$city', '$st_cd', NULL, NULL, NULL, NULL, '$zip', NULL, '$cntry_cd', '$country', '$ph1', '$tph2', '$fax', '$email', '$url', NULL, NULL)"
puts $sql3
orasql $cursor $sql3
oracommit $handler

set sql4 "insert into MASTER_CONTACT_TBL (INSTITUTION_ID, CONTACT_ID, SALUTATION, FIRST_NAME, MIDDLE_NAME, LAST_NAME, PROFESSIONAL_TITLE, PHONE1, PHONE_EXT, PHONE2, CELLULAR, FAX, EMAIL_ADDRESS, URL, ADDRESS1, ADDRESS2, CITY, COUNTY, PROV_STATE_ABBREV, PROVINCE_STATE, POSTAL_CD_ZIP, GEOCODE, CNTRY_CODE, COUNTRY, ADDRESS3, ADDRESS4) VALUES ('$inst_id', '$cont_id', NULL, '$f_nm', '$m_nm', '$l_nm', '$pro_ttl', '$ph1', '$ph1_ext', '$ph2', '$cell', '$fax', '$email', '$url', '$addy1', '$addy2', '$city', NULL, '$st_cd', '$state', '$zip', NULL, '$cntry_cd','$country', NULL, NULL)"
puts $sql4

orasql $cursor $sql4
oracommit $handler

set sql5 "insert into acq_entity_tbl (INSTITUTION_ID, ENTITY_ID, ENTITY_LEVEL, ENTITY_NAME, ENTITY_DBA_NAME, SETTL_PLAN_ID, ENTITY_STATUS, PARENT_ENTITY_ID, ALLW_ID, EXTERNAL_ENTITY_ID,  CAL_ACTIVITY_ID, CREATION_DATE, EXP_START_DATE, ACTUAL_START_DATE, ALW_NON_QUAL_UPGRD, NON_QUAL_IND, ALW_RECLASS_UPGRD, RSRV_FUND_STATUS, COMPANY_TYPE, PROCESSING_TYPE, BILLING_TYPE, TAX_ID, RECLASS_IND, DEFAULT_MCC, LANGUAGE_CODE, COMPANY_ID, ACCT_PPLAN_ID) VALUES ('$inst_id', '$ent_id', '70', '$ent_nm', '$dba_nm', '$sp_id', 'A', '$prnt_id', '1', '$mid', 'CLEARING-DAYS', '$c_date', '$ex_date', '$act_date', 'Y', 'Y', 'Y', 'F', '1', '$process_type', 'PT', '$tax_id', 'S', '$mcc', 'EN', '', '1')"

orasql $cursor $sql5
oracommit $handler

set sql6 "insert into ACQ_ENTITY_ADDRESS_TBL (INSTITUTION_ID, ENTITY_ID, ADDRESS_ROLE, EFFECTIVE_DATE, ADDRESS_ID) VALUES ('$inst_id', '$ent_id', 'LOC', '$effdate', '$addy_id')"

orasql $cursor $sql6
oracommit $handler

set sql7 "insert into ACQ_ENTITY_CONTACT_TBL (INSTITUTION_ID, ENTITY_ID, CONTACT_ROLE, CONTACT_ID) VALUES ('$inst_id', '$ent_id', 'DEF', '$cont_id')"
puts $sql7
orasql $cursor $sql7
oracommit $handler


set sql9 "update TEMP_ALT_MERCHANT_ID_TBL set ENTITY_ID = '$ent_id', CS_MERCHANT_ID = '$ent_id', institution_id = '$inst_id'"

#orasql $update_cursor $sql9
oracommit $handler

set sql11 "insert into ALT_MERCHANT_ID_TBL select * from TEMP_ALT_MERCHANT_ID_TBL"

#orasql $update_cursor $sql11


set sql10 "insert into ENTITY_ACCT_TBL (INSTITUTION_ID, ENTITY_ACCT_ID, OWNER_ENTITY_ID, ENTITY_ACCT_CURR, TRANS_ROUTING_NBR, ACCT_NBR, ACCT_TYPE, CUSTOMER_NAME, SETTL_ROUTING_NBR, SETTL_ACCT_NBR, OPEN_INV_AMT, INV_CREDIT_AMT, REL_PAY_AMT, REL_FEE_AMT, POST_PAY_AMT, POST_FEE_AMT, ENTITY_ACCT_DESC, GL_GROUP_TYPE, ACCT_POSTING_TYPE, EFFECTIVE_DATE) VALUES ('$inst_id', '$e_acct_id', '$ent_id', '$curncy_cd', '$trn', '$acno', 'C', '$dba_nm', '$strn', '$sacno', '0', '0', '0', '0', '0', '0', '$dba_nm', 'G', 'A', '$c_date')"

orasql $cursor $sql10
oracommit $handler

set sql12 "insert into ENTITY_HIERARCHY_TBL (INSTITUTION_ID, PARENT_ENTITY_ID, ENTITY_ID) VALUES ('$inst_id', '$prnt_id','$ent_id')"
orasql $cursor $sql12
oracommit $handler

oracommit $handler

set cur_line  [split [set orig_line [gets $input] ] ,]
}

