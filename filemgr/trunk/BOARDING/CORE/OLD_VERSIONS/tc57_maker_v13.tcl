#!/usr/bin/env tclsh
#/clearing/filemgr/.profile
#
# Version 0.00 Joe Cloud 4/27/05
# Based on the Visa Base 2 code written by Gene Scogin
#    This program generates a TC 57 based settlement file for
#    submittal to the EFunds Base 2 program T2 purchased for
#    submitting interchange files to Visa/Mastercard/etc.
#
# Version 43 Myke Sanders/Rifat Khan 05/18/2006
# Internal Version 50
#    Removing a section of code that incorrectly places sub batch trailers
#    Changes made to TC57 are added env variables and standard email format
#    added Tax info, purchase idetifier and Arn info.
#    Batch issue fixed
#
# Internal Version 51
# Version modified by Myke Sanders 03/02/2007
# Tested by Rifat/Mary/Myke
#    Production implementation by Rifat 03/02/2007
#    added UCAF, Lodging, recurring txn support. 03/02/2007
#
# Internal Version 53
# Version modified by MGI 05-08-2007
# Tested by MGI
#    request_type 0250 (capture) was removed as a conditional for setting
#    ACI to 'N' in order to correct qualification issues.
#
# Internal Version 58
# Version modified by MGI 11-13-2007
# Tested by MGI
#    Set auth_code spaces whenever cps_tran_id is not provided;
#    this generally occurs with force (0220) transactions.
#
# Internal Version 59
# Version modified by Myke Sanders 02-01-2007
# Tested by Myke Sanders
#    Added support for Discover processing.
#    NOTE:  The 'DS' card_type has been commented out in the card_list
#           until Discover processing has been switched on through
#           Clearing.
#

# Internal Version 60
# Version modified by Myke Sanders 02-21-2007
# Tested by Myke Sanders
#    Added support for Discover processing.
#    NOTE:  The Tc57 will only pick up transactions with a settle_discover of 'JTPY'
#
#
# Internal Version 61
# Version modified by Myke Sanders 02-21-2007
# Tested by Myke Sanders
#    Spring Release
#    NOTE:  Spring Release.  Total Tax is atleast 0.01.  Removed 196 and 470 currency codes.  Changes 288 to 936 and update VE to 937. Discover modifications to Zip to increase the size to 15.  Added discover field Network Reference ID
#

# Internal Version 62
# Version modified by Myke Sanders 02-21-2007
# Tested by Myke Sanders
#    NOTE:  Fixed Discover ARN issue.  Added code to support DFW.
#




puts "BEGIN TC57 File"
package require Oratcl
#package require Mpexpr

##################################################################################################################

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

set mbody_c "ASSIST :: \nContact On-Call Engr. \[15 minutes or Escalate\] - Open Ticket \n\n"
set mbody_u "ASSIST :: \nContact On-Call Engr. \[60 minutes or Escalate\] - Open Ticket \n\n"
set mbody_h "ASSIST :: \nInform On-Call/Available Engr. \[Day Time 7 days of the week\] - Open Ticket \n\n"
set mbody_m "ASSIST :: \nInform Available Engr. \[Day Time 5 working days of week\] - Open Ticket \n\n"
set mbody_l "ASSIST :: \nAssign Ticket to the appropriate Engr. \[24/7 - 365 days\] - Open Ticket \n\n"

#System information variables....

set sysinfo "System: $box\n Location: /clearing/filemgr/TC57/ARCHIVE \n\n"

###############################################################################################################

# **********Global Variables**********
set FLAG X
set DYNAMIC_DESCRIPTORS 0
set OD4 0
set FILES_DIR ""
set PROCESSING_BIN 457003
set SECURITY_CODE "SECURITY"
set TEST_OPTION "TEST"
set OUTGOING_FILE_ID 0
set SUB_BATCH_NUM_TRANS 0
set SUB_BATCH_NUM_MONEY_TRANS 0
set SUB_BATCH_NUM_TCR 0
set SUB_BATCH_NET_AMOUNT 0
set SUB_BATCH_GROSS_AMOUNT 0
set VISA_DEST_BIN ""
set VISA_SOURCE_BIN ""
set MC_DEST_BIN ""
set MC_SOURCE_BIN ""
set LINE_SIZE 168
set FILE_NUM_TRANS 0
set FILE_NUM_MONEY_TRANS 0
set FILE_NUM_TCR 0
set FILE_TOTAL_AMOUNT 0
set BATCH_NUM_TRANS 0
set BATCH_NUM_MONEY_TRANS 0
set BATCH_NUM_TCR 0
set BATCH_TOTAL_AMOUNT 0
set BATCH_NUM 1
set DEST_BIN ""
set SOURCE_BIN ""
set tranhistory_arn ""
set TABLE_NAME ""
set cardtype ""
set ZIP " "
#*************************************


# US
set CURRENCYDIVISOR(840) 100
# canada
set CURRENCYDIVISOR(124) 100
# euro-dollar
set CURRENCYDIVISOR(978) 100
# france
set CURRENCYDIVISOR(250) 100
# mexico
set CURRENCYDIVISOR(484) 100
# netherlands
set CURRENCYDIVISOR(528) 100
#switzerland
set CURRENCYDIVISOR(756) 100
# england
set CURRENCYDIVISOR(826) 100
# finland
set CURRENCYDIVISOR(246) 100
# denmark
set CURRENCYDIVISOR(208) 100
#austria
set CURRENCYDIVISOR(40) 100
# New Zealand
set CURRENCYDIVISOR(554) 100
# australia
set CURRENCYDIVISOR(036) 100
set CURRENCYDIVISOR(004) 100
set CURRENCYDIVISOR(008) 100
set CURRENCYDIVISOR(012) 100
set CURRENCYDIVISOR(024) 100
set CURRENCYDIVISOR(951) 100
set CURRENCYDIVISOR(578) 100
set CURRENCYDIVISOR(032) 100
set CURRENCYDIVISOR(051) 100
set CURRENCYDIVISOR(533) 100
set CURRENCYDIVISOR(031) 100
set CURRENCYDIVISOR(044) 100
set CURRENCYDIVISOR(050) 100
set CURRENCYDIVISOR(052) 100
set CURRENCYDIVISOR(084) 100
set CURRENCYDIVISOR(060) 100
set CURRENCYDIVISOR(356) 100
set CURRENCYDIVISOR(068) 100
set CURRENCYDIVISOR(977) 100
set CURRENCYDIVISOR(072) 100
set CURRENCYDIVISOR(986) 100
set CURRENCYDIVISOR(096) 100
set CURRENCYDIVISOR(100) 100
set CURRENCYDIVISOR(116) 100
set CURRENCYDIVISOR(132) 100
set CURRENCYDIVISOR(136) 100
set CURRENCYDIVISOR(152) 100
set CURRENCYDIVISOR(156) 100
set CURRENCYDIVISOR(170) 100
set CURRENCYDIVISOR(188) 100
set CURRENCYDIVISOR(191) 100
set CURRENCYDIVISOR(192) 100
set CURRENCYDIVISOR(203) 100
set CURRENCYDIVISOR(214) 100
set CURRENCYDIVISOR(218) 100
set CURRENCYDIVISOR(818) 100
set CURRENCYDIVISOR(222) 100
set CURRENCYDIVISOR(232) 100
set CURRENCYDIVISOR(233) 100
set CURRENCYDIVISOR(238) 100
set CURRENCYDIVISOR(242) 100
set CURRENCYDIVISOR(270) 100
set CURRENCYDIVISOR(280) 100
set CURRENCYDIVISOR(936) 100
set CURRENCYDIVISOR(292) 100
set CURRENCYDIVISOR(320) 100
set CURRENCYDIVISOR(624) 100
set CURRENCYDIVISOR(328) 100
set CURRENCYDIVISOR(332) 100
set CURRENCYDIVISOR(340) 100
set CURRENCYDIVISOR(344) 100
set CURRENCYDIVISOR(348) 100
set CURRENCYDIVISOR(352) 100
set CURRENCYDIVISOR(360) 100
set CURRENCYDIVISOR(364) 100
set CURRENCYDIVISOR(365) 100
set CURRENCYDIVISOR(368) 100
set CURRENCYDIVISOR(372) 100
set CURRENCYDIVISOR(376) 100
set CURRENCYDIVISOR(388) 100
set CURRENCYDIVISOR(398) 100
set CURRENCYDIVISOR(404) 100
set CURRENCYDIVISOR(408) 100
set CURRENCYDIVISOR(417) 100
set CURRENCYDIVISOR(418) 100
set CURRENCYDIVISOR(428) 100
set CURRENCYDIVISOR(422) 100
set CURRENCYDIVISOR(710) 100
set CURRENCYDIVISOR(430) 100
set CURRENCYDIVISOR(440) 100
set CURRENCYDIVISOR(446) 100
set CURRENCYDIVISOR(807) 100
set CURRENCYDIVISOR(454) 100
set CURRENCYDIVISOR(458) 100
set CURRENCYDIVISOR(462) 100
set CURRENCYDIVISOR(478) 100
set CURRENCYDIVISOR(480) 100
set CURRENCYDIVISOR(498) 100
set CURRENCYDIVISOR(496) 100
set CURRENCYDIVISOR(891) 100
set CURRENCYDIVISOR(504) 100
set CURRENCYDIVISOR(508) 100
set CURRENCYDIVISOR(104) 100
set CURRENCYDIVISOR(516) 100
set CURRENCYDIVISOR(524) 100
set CURRENCYDIVISOR(532) 100
set CURRENCYDIVISOR(558) 100
set CURRENCYDIVISOR(566) 100
set CURRENCYDIVISOR(586) 100
set CURRENCYDIVISOR(590) 100
set CURRENCYDIVISOR(598) 100
set CURRENCYDIVISOR(604) 100
set CURRENCYDIVISOR(608) 100
set CURRENCYDIVISOR(985) 100
set CURRENCYDIVISOR(634) 100
set CURRENCYDIVISOR(643) 100
set CURRENCYDIVISOR(810) 100
set CURRENCYDIVISOR(882) 100
set CURRENCYDIVISOR(678) 100
set CURRENCYDIVISOR(682) 100
set CURRENCYDIVISOR(690) 100
set CURRENCYDIVISOR(694) 100
set CURRENCYDIVISOR(702) 100
set CURRENCYDIVISOR(703) 100
set CURRENCYDIVISOR(705) 100
set CURRENCYDIVISOR(090) 100
set CURRENCYDIVISOR(706) 100
set CURRENCYDIVISOR(144) 100
set CURRENCYDIVISOR(654) 100
set CURRENCYDIVISOR(736) 100
set CURRENCYDIVISOR(737) 100
set CURRENCYDIVISOR(740) 100
set CURRENCYDIVISOR(748) 100
set CURRENCYDIVISOR(752) 100
set CURRENCYDIVISOR(760) 100
set CURRENCYDIVISOR(901) 100
set CURRENCYDIVISOR(762) 100
set CURRENCYDIVISOR(834) 100
set CURRENCYDIVISOR(764) 100
set CURRENCYDIVISOR(776) 100
set CURRENCYDIVISOR(780) 100
set CURRENCYDIVISOR(792) 100
set CURRENCYDIVISOR(795) 100
set CURRENCYDIVISOR(980) 100
set CURRENCYDIVISOR(784) 100
set CURRENCYDIVISOR(858) 100
set CURRENCYDIVISOR(860) 100
set CURRENCYDIVISOR(937) 100
set CURRENCYDIVISOR(704) 100
set CURRENCYDIVISOR(886) 100
set CURRENCYDIVISOR(180) 100
set CURRENCYDIVISOR(894) 100
set CURRENCYDIVISOR(716) 100
set CURRENCYDIVISOR(724) 1
set CURRENCYDIVISOR(112) 1
set CURRENCYDIVISOR(056) 1
set CURRENCYDIVISOR(952) 1
set CURRENCYDIVISOR(108) 1
set CURRENCYDIVISOR(950) 1
set CURRENCYDIVISOR(174) 1
set CURRENCYDIVISOR(262) 1
set CURRENCYDIVISOR(626) 1
set CURRENCYDIVISOR(953) 1
set CURRENCYDIVISOR(981) 1
set CURRENCYDIVISOR(300) 1
set CURRENCYDIVISOR(324) 1
set CURRENCYDIVISOR(380) 1
set CURRENCYDIVISOR(392) 1
set CURRENCYDIVISOR(410) 1
set CURRENCYDIVISOR(442) 1
set CURRENCYDIVISOR(450) 1
set CURRENCYDIVISOR(600) 1
set CURRENCYDIVISOR(620) 1
set CURRENCYDIVISOR(646) 1
set CURRENCYDIVISOR(800) 1
set CURRENCYDIVISOR(548) 1
set CURRENCYDIVISOR(048) 1000
set CURRENCYDIVISOR(400) 1000
set CURRENCYDIVISOR(414) 1000
set CURRENCYDIVISOR(434) 1000
set CURRENCYDIVISOR(512) 1000
set CURRENCYDIVISOR(788) 1000

set COUNTRYCODE(000) XX
set COUNTRYCODE(840) US
set COUNTRYCODE(124) CA
set COUNTRYCODE(036) AU
set COUNTRYCODE(826) GB
set COUNTRYCODE(250) FR
set COUNTRYCODE(276) DE
set COUNTRYCODE(380) IT
set COUNTRYCODE(392) JP
set COUNTRYCODE(040) AT
set COUNTRYCODE(484) MX
set COUNTRYCODE(004) AF
set COUNTRYCODE(008) AL
set COUNTRYCODE(012) DZ
set COUNTRYCODE(016) AS
set COUNTRYCODE(020) AD
set COUNTRYCODE(024) AO
set COUNTRYCODE(660) AI
set COUNTRYCODE(010) AQ
set COUNTRYCODE(028) AG
set COUNTRYCODE(032) AR
set COUNTRYCODE(051) AM
set COUNTRYCODE(533) AW
set COUNTRYCODE(031) AZ
set COUNTRYCODE(044) BS
set COUNTRYCODE(048) BH
set COUNTRYCODE(050) BD
set COUNTRYCODE(052) BB
set COUNTRYCODE(112) BY
set COUNTRYCODE(056) BE
set COUNTRYCODE(084) BZ
set COUNTRYCODE(204) BJ
set COUNTRYCODE(060) BM
set COUNTRYCODE(064) BT
set COUNTRYCODE(068) BO
set COUNTRYCODE(070) BA
set COUNTRYCODE(072) BW
set COUNTRYCODE(074) BV
set COUNTRYCODE(076) BR
set COUNTRYCODE(086) IO
set COUNTRYCODE(096) BN
set COUNTRYCODE(100) BG
set COUNTRYCODE(854) BF
set COUNTRYCODE(108) BI
set COUNTRYCODE(116) KH
set COUNTRYCODE(120) CM
set COUNTRYCODE(132) CV
set COUNTRYCODE(136) KY
set COUNTRYCODE(140) CF
set COUNTRYCODE(148) TD
set COUNTRYCODE(152) CL
set COUNTRYCODE(156) CN
set COUNTRYCODE(162) CX
set COUNTRYCODE(166) CC
set COUNTRYCODE(170) CO
set COUNTRYCODE(174) KM
set COUNTRYCODE(180) CD
set COUNTRYCODE(178) CG
set COUNTRYCODE(184) CK
set COUNTRYCODE(188) CR
set COUNTRYCODE(384) CI
set COUNTRYCODE(191) HR
set COUNTRYCODE(192) CU
set COUNTRYCODE(203) CZ
set COUNTRYCODE(208) DK
set COUNTRYCODE(262) DJ
set COUNTRYCODE(212) DM
set COUNTRYCODE(214) DO
set COUNTRYCODE(626) TL
set COUNTRYCODE(218) EC
set COUNTRYCODE(818) EG
set COUNTRYCODE(222) SV
set COUNTRYCODE(226) GQ
set COUNTRYCODE(232) ER
set COUNTRYCODE(233) EE
set COUNTRYCODE(231) ET
set COUNTRYCODE(238) FK
set COUNTRYCODE(234) FO
set COUNTRYCODE(242) FJ
set COUNTRYCODE(246) FI
set COUNTRYCODE(249) FX
set COUNTRYCODE(254) GF
set COUNTRYCODE(258) PF
set COUNTRYCODE(260) TF
set COUNTRYCODE(266) GA
set COUNTRYCODE(270) GM
set COUNTRYCODE(268) GE
set COUNTRYCODE(936) GH
set COUNTRYCODE(292) GI
set COUNTRYCODE(300) GR
set COUNTRYCODE(304) GL
set COUNTRYCODE(308) GD
set COUNTRYCODE(312) GP
set COUNTRYCODE(316) GU
set COUNTRYCODE(320) GT
set COUNTRYCODE(324) GN
set COUNTRYCODE(624) GW
set COUNTRYCODE(328) GY
set COUNTRYCODE(332) HT
set COUNTRYCODE(334) HM
set COUNTRYCODE(340) HN
set COUNTRYCODE(344) HK
set COUNTRYCODE(348) HU
set COUNTRYCODE(352) IS
set COUNTRYCODE(356) IN
set COUNTRYCODE(360) ID
set COUNTRYCODE(364) IR
set COUNTRYCODE(368) IQ
set COUNTRYCODE(372) IE
set COUNTRYCODE(376) IL
set COUNTRYCODE(388) JM
set COUNTRYCODE(400) JO
set COUNTRYCODE(398) KZ
set COUNTRYCODE(404) KE
set COUNTRYCODE(296) KI
set COUNTRYCODE(408) KP
set COUNTRYCODE(410) KR
set COUNTRYCODE(414) KW
set COUNTRYCODE(417) KG
set COUNTRYCODE(418) LA
set COUNTRYCODE(428) LV
set COUNTRYCODE(422) LB
set COUNTRYCODE(426) LS
set COUNTRYCODE(430) LR
set COUNTRYCODE(434) LY
set COUNTRYCODE(438) LI
set COUNTRYCODE(440) LT
set COUNTRYCODE(442) LU
set COUNTRYCODE(446) MO
set COUNTRYCODE(807) MK
set COUNTRYCODE(450) MG
set COUNTRYCODE(454) MW
set COUNTRYCODE(458) MY
set COUNTRYCODE(462) MV
set COUNTRYCODE(466) ML
set COUNTRYCODE(584) MH
set COUNTRYCODE(474) MQ
set COUNTRYCODE(478) MR
set COUNTRYCODE(480) MU
set COUNTRYCODE(175) YT
set COUNTRYCODE(583) FM
set COUNTRYCODE(498) MD
set COUNTRYCODE(492) MC
set COUNTRYCODE(496) MN
set COUNTRYCODE(500) MS
set COUNTRYCODE(504) MA
set COUNTRYCODE(508) MZ
set COUNTRYCODE(104) MM
set COUNTRYCODE(516) NA
set COUNTRYCODE(520) NR
set COUNTRYCODE(524) NP
set COUNTRYCODE(528) NL
set COUNTRYCODE(530) AN
set COUNTRYCODE(540) NC
set COUNTRYCODE(554) NZ
set COUNTRYCODE(558) NI
set COUNTRYCODE(562) NE
set COUNTRYCODE(566) NG
set COUNTRYCODE(570) NU
set COUNTRYCODE(574) NF
set COUNTRYCODE(580) MP
set COUNTRYCODE(578) NO
set COUNTRYCODE(512) OM
set COUNTRYCODE(586) PK
set COUNTRYCODE(585) PW
set COUNTRYCODE(275) PS
set COUNTRYCODE(591) PA
set COUNTRYCODE(598) PG
set COUNTRYCODE(600) PY
set COUNTRYCODE(604) PE
set COUNTRYCODE(608) PH
set COUNTRYCODE(612) PN
set COUNTRYCODE(616) PL
set COUNTRYCODE(620) PT
set COUNTRYCODE(630) PR
set COUNTRYCODE(634) QA
set COUNTRYCODE(638) RE
set COUNTRYCODE(642) RO
set COUNTRYCODE(643) RU
set COUNTRYCODE(646) RW
set COUNTRYCODE(659) KN
set COUNTRYCODE(662) LC
set COUNTRYCODE(670) VC
set COUNTRYCODE(882) WS
set COUNTRYCODE(674) SM
set COUNTRYCODE(678) ST
set COUNTRYCODE(682) SA
set COUNTRYCODE(686) SN
set COUNTRYCODE(690) SC
set COUNTRYCODE(694) SL
set COUNTRYCODE(702) SG
set COUNTRYCODE(703) SK
set COUNTRYCODE(705) SI
set COUNTRYCODE(090) SB
set COUNTRYCODE(706) SO
set COUNTRYCODE(710) ZA
set COUNTRYCODE(239) GS
set COUNTRYCODE(724) ES
set COUNTRYCODE(144) LK
set COUNTRYCODE(654) SH
set COUNTRYCODE(666) PM
set COUNTRYCODE(736) SD
set COUNTRYCODE(740) SR
set COUNTRYCODE(744) SJ
set COUNTRYCODE(748) SZ
set COUNTRYCODE(752) SE
set COUNTRYCODE(756) CH
set COUNTRYCODE(760) SY
set COUNTRYCODE(158) TW
set COUNTRYCODE(762) TJ
set COUNTRYCODE(834) TZ
set COUNTRYCODE(764) TH
set COUNTRYCODE(768) TG
set COUNTRYCODE(772) TK
set COUNTRYCODE(776) TO
set COUNTRYCODE(780) TT
set COUNTRYCODE(788) TN
set COUNTRYCODE(792) TR
set COUNTRYCODE(795) TM
set COUNTRYCODE(796) TC
set COUNTRYCODE(798) TV
set COUNTRYCODE(800) UG
set COUNTRYCODE(804) UA
set COUNTRYCODE(784) AE
set COUNTRYCODE(581) UM
set COUNTRYCODE(858) UY
set COUNTRYCODE(860) UZ
set COUNTRYCODE(548) VU
set COUNTRYCODE(336) VA
set COUNTRYCODE(937) VE
set COUNTRYCODE(704) VN
set COUNTRYCODE(092) VG
set COUNTRYCODE(850) VI
set COUNTRYCODE(876) WF
set COUNTRYCODE(732) EH
set COUNTRYCODE(887) YE
#set COUNTRYCODE(891) YU
set COUNTRYCODE(688) RS
set COUNTRYCODE(499) ME
set COUNTRYCODE(894) ZM
set COUNTRYCODE(716) ZW



# File Header
set TCR(90) {
    tc n 2 {Transaction Code}
    proc_bin a 6 {Processing BIN}
    proc_date n 5 {Processing Date}
    rsrvd1 a 16 {Reserved}
    test_opt a 4 {Test Option}
    rsrvd2 a 29 {Reserved}
    sec_code a 8 {Security Code}
    rsrvd3 a 6 {Reserved}
    file_id n 3 {Outgoing File ID}
    rsrvd4 a 89 {Reserved}
};# end set TCR(90)



# 1st Batch Header
set TCR(57-0-0-1) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    rsrvd1 a 6 {Reserved}
    tran_amt n 12 {Transaction Amount}
    rsrvd2 a 3 {Reserved}
    draft_flag a 1 {Draft Flag}
    cp_date a 4 {Central Processing Date}
    rec_fmt_code a 2 {Record Format Code}
    rev_flag a 1 {Reversal Flag}
    disc_a_id n 11 {Discover Acquirer ID}
    rsrvd3 a 12 {Reserved}
    dcp_date a 4 {Data Capture Processing Date}
    rsrvd4 a 2 {Reserved}
    agent n 6 {Agent}
    chain n 6 {Chain}
    merc_num n 16 {Merchant Number}
    store_num n 4 {Store Number}
    term_num n 4 {Terminal Number}
    batch_num n 5 {Merchant Batch Number}
    batch_date n 4 {Merchant Batch Date}
    ds_merc_id a 15 {Discover Merchant ID}
    xmit_time n 6 {Batch Transmit Time}
    time_zone a 3 {Time Zone}
    gmt_offset a 3 {GMT Offset}
    merc_sec_code n 5 {Merchant Security Code}
    rsrvd5 n 2 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr n 1 {Reimbursement Attribute}
};# end set TCR(57-0-0-1)



# 2nd Batch Header
set TCR(57-0-1-1) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    rsrvd1 a 12 {Reserved}
    dev_code a 1 {Device Code}
    rsrvd2 a 4 {Reserved}
    its_num a 8 {Internal Terminal Serial Number}
    mcc n 4 {Merchant Category Code}
    merc_name a 25 {Merchant Name}
    merc_city a 13 {Merchant City}
    merc_state a 3 {Merchant State/Province Code}
    merc_country a 3 {Merchant Country Code}
    merc_zip a 5 {Merchant Zip Code}
    rsrvd3 a 4 {Reserved}
    tran_route a 1 {Transmission Route}
    term_loc_num n 5 {Terminal Locator Number}
    postal_code a 11 {Merchant Postal Code}
    rsrvd4 a 50 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    rsrvd5 a 1 {Reserved}
};# end set TCR(57-0-1-1)

# AMEX Batch Header
set TCR(57-0-2-1) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    res1 a 12 {Reserved}
    SEN a 10 {Service Establishment Number}
    format_code a 2 {Format Code}
    invoice_batch n 3 {Invoice Batch}
    invoice_sub n 2 {Invoice Sub Code}
    PCI n 6 {Process Control ID}
    file_seq_num n 6 {File Sequence Number}
    CAP a 10 {Chain Affiliated Property}
    service_city a 18 {Service Established City}
    res2 a 80 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res3 a 1 {Reserved}
};# end set TCR(57-0-2-1)

# Transaction Detail - AMEX
set TCR(57-0-2-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    res1 a 12 {Reserved}
    format_code a 2 {Format Code}
    I3Q a 3 {Item 3 Quantity}
    I3D n 15 {Item 3 Description}
    I3UP a 8 {Item 3 Unit Price}
    I3TP n 8 {Item 3 Total Price}
    I4Q n 3 {Item 4 Quantity}
    I4D a 15 {Item 4 Description}
    I4UP n 8 {Item 4 Unit Price}
    I4TP n 8 {Item 4 Total Price}
    res2 a 67 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res3 a 1 {Reserved}
};# end set TCR(57-0-2-2)


# Transaction Detail
set TCR(57-0-0-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    sc_ind a 2 {Special Condition Indicators}
    tran_cq n 1 {Transaction Code Qualifier}
    recur_pmt_ind a 1 {Recurring Payment Indicator}
    rsrvd1 n 2 {Reserved}
    tran_amt n 12 {Transaction Amount}
    cur_code a 3 {Transaction Currency Code}
    drft_sent_flg a 1 {Draft Sent Flag}
    cp_date n 4 {Central Processing Date}
    fmt_code a 2 {Record Format Code}
    rev_flag a 1 {Reversal Flag}
    cat_ind a 1 {Cat Level Indicator}
    prepaid_crd a 1 {Prepaid Card Indicator}
    chip_code a 1 {Chip Condition Code}
    card_type a 1 {Card Type}
    pan a 19 {Account Number}
    purch_date n 4 {Purchase Date}
    tran_time n 4 {Transaction Time}
    tran_type a 1 {Transaction Type}
    void_ind a 1 {Transaction Void Indicator}
    entry_method a 1 {Card Entry Method}
    ch_id_method a 1 {Cardholder ID Method}
    auth_code a 6 {Authorization Code}
    auth_source a 1 {Authorization Source Code}
    film_loc n 11 {Film Locator}
    tip_cashbk a 12 {Tip/Cashback}
    moto_ec_ind a 1 {MOTO or Electronic Commerce Indicator}
    debit_ind a 1 {Debit Indicator}
    rsrch_code a 1 {Research Code}
    netwrk_id a 1 {Network ID}
    settle_date n 4 {Settlement Date}
    dta_num a 6 {Debit Trace Audit Number}
    posdra a 1 {POS Debit Reimbursement Attribute}
    debit_date n 4 {Debit Trans Date}
    debit_time n 6 {Debit Trans Time}
    ret_ref_num a 12 {Retrieval Reference Number}
    avs a 1 {AVS response code}
    crb_exc_ind a 1 {CRB Exception File Indicator}
    atm_account a 1 {ATM Account Selection}
    aci a 1 {Authorization Characteristics Indicator}
    pos_entry a 2 {POS Entry Mode}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr a 1 {Reimbursement Attribute}
};# end set TCR(57-0-2)



# Transaction Detail - Payment Service Data
set TCR(57-0-3-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    auth_response a 2 {Authorization Response Code}
    auth_amount n 12 {Authorized Amount}
    tran_id n 15 {Transaction Identifier}
    val_code a 4 {Validation Code}
    clr_seq_num n 2 {Multiple Clearing Sequence Number}
    clr_seq_count n 2 {Multiple Clearing Sequence Count}
    mkt_auth_data a 1 {Market-specific Authorization Data Identifier}
    total_amount n 12 {Total Authorized Amount}
    aci a 1 {Submitted Authorization Characteristics Indicator}
    moto_ph_num a 11 {MOTO Customer Service Phone Number}
    moto_ph_flag a 1 {MOTO Customer Service PHone Flag}
    moto_seq_num n 2 {MOTO Installment Sequence Number}
    moto_seq_count n 2 {MOTO Installment Sequence Count}
    egoods_ind a 2 {Electronic Commerce Goods Indicator}
    reward_id a 6 {Rewards Program Identifier}
    crd_lvl_rslt a 2 {Card Level Results Reserved}
    cvv2 a 1 {CVV2 Response Code}
    mvv a 10 {Merchant Verification Value}
    reserved1 a 61 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reserved2 a 1 {Reserved}
};# end set TCR(57-0-3-2)


# Mastercard Compliance Data
set TCR(57-0-5-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    reserved1 a 11 {Reserved}
    banknet_num a 9 {Banknet Settlement Number}
    banknet_date a 4 {Banknet Settlement Date}
    val_code a 4 {Validation Code}
    ucaf_sec a 1 {UCAF - Ecomm Security Protocol}
    ucaf_cha a 1 {UCAF - Ecomm Cardholder Authentication}
    ucaf_us a 1 {UCAF - Ecomm UCAF Status}
    reserved2 a 5 {Reserved}
    auth_amount n 12 {Authorization Amount}
    service_code a 3 {Service Code}
    pos_sd a 12 {POS Service Data}
    reserved3 a 86 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr a 1 {Reimbursement Attribute}
};# end set TCR(57-0-5-2)

# Visa Lodging
set TCR(57-0-4-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    res a 12 {Reserved}
    bfc a 2 {Business Format Code}
    res1 a 8 {Reserved}
    lodging_no_show_ind a 1 {Lodging No Show Indicator}
    lodging_extra n 6 {Lodging Extra Charges}
    res2 a 4 {Reserved}
    check_in n 6 {Loding check in date}
    daily_rate n 12 {Daily room rate}
    total_tax n 12 {Total Tax}
    prepaid_exp n 12 {Prepaid Expenses}
    food_charge n 12 {Food/Beverage charge}
    folio_cash_advance n 12 {Folio Cash Advance}
    room_nights n 2 {Room nights}
    room_tax n 12 {Room Tax}
    res3 a 36 {Reserved}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res4 a 1 {Reserved}
}

# Dynamic Descriptor
set TCR(57-0-1-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    reserved1 a 12 {Reserved}
    format_code a 2 {Format Code}
    dd a 25 {Dynamic Descriptor}
    reserved a 123 {Reserved}
    rec_type a 1 {Record Type}
    rec_ind a 1 {Record Indicator}
};# end set TCR(57-0-1-2)

#Visa Transport
set TCR(57-0-4-2V) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    l3_fbc a 6 {Leg 3 Fare Basis Code}
    l4_fbc a 6 {Leg 4 Fare Basis Code}
    bfc a 2 {Business Format Code}
    crs a 4 {Computerized REservation System}
    res a 4 {Reserved}
    pass_name a 20 {Passenger Name}
    depart_date n 6 {Departure Date}
    orig_city a 3 {Origination City/Airport Code}
    leg1 a 7 {Leg 1}
    leg2 a 7 {Leg 2}
    leg3 a 7 {Leg 3}
    leg4 a 7 {Leg 4}
    tac a 8 {Travel Agency Code}
    tan a 25 {Travel Agency Number}
    rti a 1 {Restricted Ticket Indicator}
    otn a 13 {Original Ticket Number}
    l1_fbc a 6 {Leg 1 Fare Basis Code}
    l1_fn a 5 {Leg 1 Flight Number}
    l2_fbc a 6 {Leg 2 Fare Basis Code}
    l2_fn a 5 {Leg 2 Flight Number}
    res1 a 1 {Reserved}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res4 a 1 {Reserved}
}

# MC Transport
set TCR(57-0-4-2M) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    pass_name a 12 {Passenger Name}
    bfc a 2 {Business Format Code}
    ticket_number n 15 {Ticket Number}
    res1 n 7 {Reserved}
    issuing_carrier a 4 {Issuing Carrier}
    customer_code a 25 {Customer Code}
    tac a 8 {Travel Agency Code}
    tan a 25 {Travel Agency Number}
    total_fare n 12 {Total Fare}
    l1_travel_date n 6 {Leg 1 Travel Date}
    l1_carrier_code a 2 {Leg 1 Carrier Code}
    l1_scc a 1 {Leg 1 Service Class Code}
    l1_orig_city a 3 {Leg 1 Origination City/Airport Code}
    l1_desc_city a 3 {Leg 1 Destination City/Airport Code}
    l1_soc a 1 {leg 1 Stop over Code}
    l1_fbc a 6 {Leg 1 Fare Basis Code}
    l1_flight_number a 5 {Leg 1 Flight Number}
    l1_dep_time n 4 {Leg 1 Depature Time}
    l1_dep_time_seg n 1 {Leg 1 Depature Time Segment}
    res2 a 7 {Reserved}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res3 a 1 {Reserved}
}

# MC Lodging
set TCR(57-0-4-3) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    arrival_date n 6 {Arrival Date}
    depart_date n 6 {Departure Date}
    bfc n 2 {Business Format Code}
    folio a 10 {Folio Number}
    property_phone n 10 {Property Phone Number}
    cust_serv_phone n 10 {Customer Service Phone Number}
    room_rate n 12 {Room Rate}
    room_tax n 12 {Room Tax}
    total_tax n 12 {Total Tax}
    res1 a 47 {Reserved}
    total_room_nights n 4 {Total Room Nights}
    fsai a 1 {Fire Safety Act Indicator}
    customer_code a 17 {Customer Code}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res4 a 1 {Reserved}
}



# Visa Purchasing Card
set TCR(57-0-5-2V) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    local_tax n 9 {Local Tax}
    tax_included n 1 {Tax included}
    PIF a 1 {Purchase Identifier Format}
    PI a 25 {Purchase Identifier}
    national_tax_included n 1 {National Tax Included}
    national_tax n 12 {National Tax}
    CRI a 17 {Customer Reference Identifier}
    BRN a 20 {Business Refernce Number}
    customer_vat a 13 {Customer VAT}
    scc a 4 {Summary Commodity Code}
    other_tax n 12 {Other Tax}
    PC1 a 2 {Product Code}
    PC2 a 2 {Product Code}
    PC3 a 2 {Product Code}
    PC4 a 2 {Product Code}
    PC5 a 2 {Product Code}
    PC6 a 2 {Product Code}
    PC7 a 2 {Product Code}
    PC8 a 2 {Product Code}
    res a 1 {Reserved}
    mi a 15 {Message Identifier}
    version_code a 2 {Version Code}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res1 a 1 {Reserved}
};# end set TCR(57-0-5-2)

# DS Additional data
set TCR(57-0-1-00) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {Reserved}
    pro_code a 6 {Processing Code}
    psi a 1 {Partial Shipment Indicator} 
    tran_date n 6 {Transaction Date}
    tran_time a 6 {Transaction Time}
    pos_entry a 3 {POS Entry Mode}
    tdcc a 2 {Track Data Condition Code} 
    pos_data a 13 {POS Data}
    response_code a 2 {Response Code}
    network_refernce a 15 {Network Reference ID}
    res2 a 107 {Reserved}
    ind a 1 {Indicator .D. - Discover related}
}

#DS Statement
set TCR(57-0-3-01-01) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 01}
    seq_nbr a 2 {Sequence Number 01}
    message a 40 {Statement Message}
    filler a 119 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
}

#DS tip
set TCR(57-0-3-02-01) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 02}
    seq_nbr a 2 {Sequence Number 01}
    tip n 12 {Tip Amount}
    filler a 147 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
}

#DS Cash Over
set TCR(57-0-3-03-01) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 03}
    seq_nbr a 2 {Sequence Number 01}
    cash_over n 12 {Cash Over}
    filler a 147 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
}

#DS address
set TCR(57-0-3-04-01) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 04}
    seq_nbr a 2 {Sequence Number 01}
    zip a 15 {Postal ZIP Code}
    store_number a 5 {Merchant Store Number}
    mall_name a 21 {Mall Name} 
    phone_number a 10 {Phone Number}
    filler a 108 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
}

#DS lodging
set TCR(57-0-3-09-01) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 09}
    seq_nbr a 2 {Sequence Number 01}
    promo_code a 12 {Promotional Code}
    coupon_code a 12 {Coupon Code}
    ccc a 12 {Coporate Client Code}
    room_loc a 10 {Room Location}
    bed_type a 12 {Bed Type}
    room_type a 12 {Room Type}
    smoking a 1 {Smoking Preference}
    nbr_rooms n 2 {Number of Rooms}
    nbr_adults n 2 {Number of Adults}
    tax n 10 {Tax Elements}
    no_show a 1 {No Show Indicator}
    travel_code a 8 {Travel Agency Code}
    extra_charge n 12 {Extra Charges}
    travel_agency_name a 25 {Travel Agency Name}
    filler a 16 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
}

#DS lodging 2
set TCR(57-0-3-09-02) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence}
    sdr a 2 {SDR Type 09}
    seq_nbr a 2 {Sequence Number 02}
    arrival n 8 {Arrival Date CCYYMMDD}
    depart n 8 {Depart Date CCYYMMDD}
    folio a 10 {Folio Number}
    fac_phone a 16 {Facility Phone}
    adjustment_amount n 12 {Adjestment Amount}
    room_rate n 12 {Room Rate}
    room_tax n 12 {Room Tax}
    program a 2 {Program Code}
    phone_charge n 12 {Phone Charge}
    rest_charge n 12 {Restraunt Charge}
    mini_bar_charge n 12 {Mini Bar Charge}
    laun_charge n 12 {Laundry Charge}
    other_charge n 12 {Other Charge}
    other_ind a 2 {Other Indicator}
    gift_charge n 12 {Gift Shop Charge}
    filler a 4 {Filler Spaces}
    ind a 1 {Indicator .D. - Discover related}
}


# MC Purchasing Card
set TCR(57-0-6-2) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    sales_tax n 12 {Sales Tax}
    sales_tax_included a 1 {Sales Tax included}
    customer_code a 25 {Customer Code}
    commodity_code a 15 {Commodity Code}
    merchant_type a 4 {Merchant Type}
    merchant_reference_number a 25 {Merchant Refence Number}
    merchant_tax_identifier a 20 {Merchant Tax Identifier}
    res a 30 {Reserved}
    mi a 15 {Message Identifier}
    version_code a 2 {Version Code}
    imbk a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    res1 a 1 {Reserved}
};# end set TCR(57-0-6-2)



# Sub Batch Trailer
set TCR(57-0-0-3) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    dest_bin n 6 {Destination BIN}
    src_bin n 6 {Source BIN}
    rsrvd1 n 6 {Reserved}
    rsrvd2 n 12 {Reserved}
    rsrvd3 a 3 {Reserved}
    draft_flag a 1 {Draft Flag}
    cp_date n 4 {Central Processing Date}
    rec_fmt a 2 {Record Format Code}
    rev_flag a 1 {Reversal Flag}
    rsrvd4 n 23 {Reserved}
    tran_count n 7 {Batch Transaction Count}
    net_amount n 15 {Batch Net Amount}
    net_sign a 2 {Batch Net Amount Sign}
    tcr_count n 7 {Batch Record (TCR) Count}
    gross_amt n 15 {Batch Gross Amount}
    secondary_amt n 16 {Secondary Amount}
    rsrvd5 a 23 {Reserved}
    batch_key a 13 {Internal Merchant Batch Key}
    rec_type a 1 {Record Type}
    reimburse_attr a 1 {Reimbursement Attribute}
};# end set tct(57-0-0-3)



# Batch Trailer
set TCR(91) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    bin n  6 {BIN}
    proc_jdate n  5 {Processing Date (YYDDD)}
    dest_amount n 15 {Destination Amount}
    num_money_trans n 12 {Number of Monetary Trans}
    batch_num n  6 {Batch Number}
    num_tcr n 12 {Number of TCRs}
    rsrvd1 n  6 {Reserved}
    batch_id a  8 {Center Batch ID}
    num_trans n  9 {Number of Transactions}
    rsrvd2 n 18 {Reserved}
    src_amount n 15 {Source Amount}
    rsrvd3 n 15 {Reserved}
    rsrvd4 n 15 {Reserved}
    rsrvd5 n 15 {Reserved}
    rsrvd6 a  7 {Reserved}
};# end set TCR(92)



# File Trailer
set TCR(92) {
    tc n 2 {Transaction Code}
    tcq n 1 {Transaction Code Qualifier}
    tcn n 1 {Transaction Component Sequence Number}
    bin n  6 {BIN}
    proc_jdate n  5 {Processing Date (YYDDD)}
    dest_amount n 15 {Destination Amount}
    num_money_trans n 12 {Number of Monetary Trans}
    batch_num n  6 {Batch Number}
    num_tcr n 12 {Number of TCRs}
    rsrvd1 n  6 {Reserved}
    batch_id a  8 {Center Batch ID}
    num_trans n  9 {Number of Transactions}
    rsrvd2 n 18 {Reserved}
    src_amount n 15 {Source Amount}
    rsrvd3 n 15 {Reserved}
    rsrvd4 n 15 {Reserved}
    rsrvd5 n 15 {Reserved}
    rsrvd6 a  7 {Reserved}
};# end set TCR(92)

proc check_for_lodging_mcc {aname} {
    upvar $aname a
    if {$a(sic_code) >= 3501 && $a(sic_code) <= 3999} {
      return 1 
    }
    if {$a(sic_code) == 7011} {
      return 1
    }
    return 0 
}; #end check_for_lodging_mcc

proc write_tc {file aname} {
    upvar $aname a
    upvar $file output_file
    global TCR FLAGS
    
    set line {}
    foreach {index type length comment} $TCR($a(tc))  {
        if {[string equal $type "a"]} {
            set value "[format "%-$length.${length}s" $a($index)]"
            append line "[format "%-$length.${length}s" $a($index)]"
        } else {
            if {![string is digit $a($index) ]} {
                set temp 0
            } else {
                set temp $a($index)
            }
            set value "[format "%0$length.${length}s" $temp]"
            append line "[format "%0$length.${length}s" $temp]"
        }
#       puts [format "%-30.30s  >%s<" $comment $value]
    }
    puts -nonewline $output_file $line
    if {$FLAGS(-lf) == 1} {
        puts $output_file {}
    }
    flush $output_file
};# end write_tc

proc write_tc_tcq_tcn_rt {file aname} {
    upvar $aname a
    upvar $file output_file
    global TCR FLAGS
    
    set line {}
    foreach {index type length comment} $TCR($a(tc)-$a(tcq)-$a(tcn)-$a(rec_type))  {
        if {[string equal $type "a"]} {
            #puts "$a($index) $index"
            set value "[format "%-$length.${length}s" $a($index)]"
            append line "[format "%-$length.${length}s" $a($index)]"
        } else {
            if {![string is digit $a($index) ]} {
                set temp 0
            } else {
                set temp $a($index)
            }
            set value "[format "%0$length.${length}s" $temp]"
            append line "[format "%0$length.${length}s" $temp]"
        }

 #       puts [format "%-30.30s  >%s<" $comment $value]
    }
    puts -nonewline $output_file $line
    if {$FLAGS(-lf) == 1} {
        puts $output_file {}
    }
    flush $output_file
};# end write_tc_tcq_tcn_rt

proc write_tc_tcq_tcn_sdr {file aname} {  
    upvar $aname a
    upvar $file output_file
    global TCR FLAGS

    set line {}
    if {$a(sdr) != "00"} {
      foreach {index type length comment} $TCR($a(tc)-$a(tcq)-$a(tcn)-$a(sdr)-$a(seq_nbr))  {
          if {[string equal $type "a"]} {
              #puts "$a($index) $index"
              set value "[format "%-$length.${length}s" $a($index)]"
              append line "[format "%-$length.${length}s" $a($index)]"
          } else {
              if {![string is digit $a($index) ]} {
                  set temp 0
              } else {
                  set temp $a($index)
              }
              set value "[format "%0$length.${length}s" $temp]"
              append line "[format "%0$length.${length}s" $temp]"
          }

   #       puts [format "%-30.30s  >%s<" $comment $value]
      }
    } else {
      foreach {index type length comment} $TCR($a(tc)-$a(tcq)-$a(tcn)-$a(sdr))  {
          if {[string equal $type "a"]} {
              #puts "$a($index) $index"
              set value "[format "%-$length.${length}s" $a($index)]"
              append line "[format "%-$length.${length}s" $a($index)]"
          } else {
              if {![string is digit $a($index) ]} {
                  set temp 0
              } else {
                  set temp $a($index)
              }
              set value "[format "%0$length.${length}s" $temp]"
              append line "[format "%0$length.${length}s" $temp]"
          }

   #       puts [format "%-30.30s  >%s<" $comment $value]
      }
    }
    puts -nonewline $output_file $line
    if {$FLAGS(-lf) == 1} {
        puts $output_file {}
    }
    flush $output_file
};# end write_tc_tcq_tcn_rt

#because of the similarity between the visa purchasing card and the MC compliance section and new tc_tcq is needed
proc write_tc_tcq_tcn_rtM {file aname} {
    upvar $aname a
    upvar $file output_file
    global TCR FLAGS


#    puts "--------------------"
    set line {}
    #foreach {index type length comment} $TCR($a(tc)-$a(tcq)-$a(tcn)-$a(rec_type)M)  {
    #  puts "$index"
    #}
    foreach {index type length comment} $TCR($a(tc)-$a(tcq)-$a(tcn)-$a(rec_type)M)  {
        if {[string equal $type "a"]} {
            #puts "$a($index) $index"
            set value "[format "%-$length.${length}s" $a($index)]"
            append line "[format "%-$length.${length}s" $a($index)]"
        } else {
            if {![string is digit $a($index) ]} {
                set temp 0
            } else {
                set temp $a($index)
            }
            set value "[format "%0$length.${length}s" $temp]"
            append line "[format "%0$length.${length}s" $temp]"
        }

 #       puts [format "%-30.30s  >%s<" $comment $value]
    }
    puts -nonewline $output_file $line
    if {$FLAGS(-lf) == 1} {
        puts $output_file {}
    }
    flush $output_file
};# end write_tc_tcq_tcn_rtM


proc write_tc_tcq_tcn_rtV {file aname} {
    upvar $aname a
    upvar $file output_file
    global TCR FLAGS


#    puts "--------------------"
    set line {}
    #foreach {index type length comment} $TCR($a(tc)-$a(tcq)-$a(tcn)-$a(rec_type)V)  {
    #  puts "$index"
    #}
    foreach {index type length comment} $TCR($a(tc)-$a(tcq)-$a(tcn)-$a(rec_type)V)  {
        if {[string equal $type "a"]} {
            #puts "$a($index) $index"
            set value "[format "%-$length.${length}s" $a($index)]"
            append line "[format "%-$length.${length}s" $a($index)]"
        } else {
            if {![string is digit $a($index) ]} {
                set temp 0
            } else {
                set temp $a($index)
            }
            set value "[format "%0$length.${length}s" $temp]"
            append line "[format "%0$length.${length}s" $temp]"
        }

 #       puts [format "%-30.30s  >%s<" $comment $value]
    }
    puts -nonewline $output_file $line
    if {$FLAGS(-lf) == 1} {
        puts $output_file {}
    }
    flush $output_file
};# end write_tc_tcq_tcn_rtV




proc make_yddd {datetime} {
    set datestring "[string range $datetime 0 7]T[string range $datetime 8 13]"
    set secs [clock scan $datestring]
    return [string range [clock format $secs -format %y%j ] 1 4]
};# end make_yddd



proc make_mmdd {datetime} {
    set datestring "[string range $datetime 0 7]T[string range $datetime 8 13]"
    set secs [expr [clock scan $datestring]]
    return [clock format $secs -format %m%d]
};# end make_mmdd



proc make_acq_ref_num { bin date film card_type tran_type currency} {
    #FIXME need to look at the req type to do this for revs
    if {$card_type == "VS" || $card_type == "DB"} {
      if {$tran_type == "0420" || $currency != "840"} {
        set format_code 7
      } else {
        set format_code 2
      }
    }
    if {$card_type == "MC" || $card_type == "DS"} {
      set format_code 1
    }
    if {$card_type == "DB"} {
      set format_code F
    }

    if {$card_type == "DS"} {
      set format_code 8
      set bin 123456
    }



    set s1 [format "%d%06.6s%04.4s%011.11s" $format_code $bin $date $film]

        set c {0 1 2 3 4 5 6 7 8 9 0 2 4 6 8 1 3 5 7 9}
    # not lunh style
#    set c {0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9}
    #   puts "s1 = >$s1<"

    set phase 0
    set sum 0
    foreach v [split $s1 {}] {

        set vv [lindex $c [expr {$v + 10 * $phase}]]
        set sum [expr {$sum + $vv}]

        set phase [expr {$phase ^ 1}]
    }
    set ch [expr {(10 - $sum %10) %10}]
    #implied return
    set s1 "$s1$ch"
};# end make_acq_ref_num



proc add_cps_detail {aname m} {
    upvar $m merchant
    upvar $aname a

    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT


    set original_amount [expr ($CURRENCYDIVISOR($a(currency_code)) * $a(orig_amount))]
    set original_amount [format "%0f" $original_amount]
    set original_amount [expr int($original_amount)]

    set real_amount [expr ($CURRENCYDIVISOR($a(currency_code)) * $a(amount))]
    set real_amount [format "%0f" $real_amount]
    set real_amount [expr int($real_amount)]

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 3
    set rec(rec_type) 2
    set rec(auth_response) "00"
    set rec(auth_amount) $original_amount
    
    if {$a(request_type) == "0220"} {
      set rec(tran_id) " "
    } else {
      set rec(tran_id) $a(cps_tran_id)
    }

    set rec(val_code) $a(cps_validation_code)
    set rec(clr_seq_num) 0
    if {$a(market_type) == "J"} {
      set rec(clr_seq_num) 1 
      if {$a(transaction_type) == "I"} {
        set rec(clr_seq_num) 2
      }
    }
    set rec(clr_seq_count) 0
    set rec(mkt_auth_data) " "
    if {$a(market_type) == "L"} {
      set rec(mkt_auth_data) "H"
    }

    set rec(total_amount) $real_amount
    if {$a(request_type) == "0420" || $a(request_type) == "0220"} {
        set rec(aci) "N"
    } else {
        set rec(aci) $a(aci)
    }
    if {$a(transaction_type) == "U"} {
       #set rec(aci) "U"
       set rec(mkt_auth_data) "B"
    }

#JNC Fix this for MOTO
    if {$a(transaction_type) == "M"} {
        regsub -all -- "-" $merchant(cust_service) "" cust_srv_number
        set cust_srv_number [string range $cust_srv_number 0 9]
        set rec(moto_ph_num) [string range $cust_srv_number 0 2][string range $cust_srv_number 3 9]
        set rec(moto_ph_flag) "Y"
    } else {
        set rec(moto_ph_num) " "
        set rec(moto_ph_flag) "N"
    }
    set rec(moto_seq_num) 0
    set rec(moto_seq_count) 0
    set rec(egoods_ind) " "
    set rec(reward_id) " "
    set first [string first CL: $a(other_data2)]
    if {$first != -1} {
      set end [string first ";" $a(other_data2) $first]
      set clr [string range $a(other_data2) [expr $first + 3 ] [expr $end - 1]]
    } else {
      set clr " "
    }
    set rec(crd_lvl_rslt) "$clr" 
    set rec(cvv2) $a(cvv)
    set rec(mvv) " "
    set rec(reserved1) " "
    set rec(batch_key) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(reserved2) " "

    write_tc_tcq_tcn_rt TEMP_FILE rec
};# end add_cps_detail

# convert floating amount to pennies to prevent binary roundoff
proc convert_amount {amount_in} {
#    regsub "\\." $amount_in "" temp_value
    set temp_value [expr int(($amount_in * 100) + .05)]
#    puts "Received <$amount_in> returning <$temp_value>"
    return $temp_value
};# end convert_amount

proc Amex_detail {merchant rec} {
upvar $merchant m
upvar $rec r

    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID LINE_SIZE OUTPUT_FILE
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT
    global TEMP_CRSR

    set tc "57"
    set tcq "0"
    set tcn "2"
    set res1 "            "
    set format_code "02"
    #I3Q a 3 {Item 3 Quantity}
    #I3D n 15 {Item 3 Description}
    #I3UP a 8 {Item 3 Unit Price}
    #I3TP n 8 {Item 3 Total Price}
    #I4Q n 3 {Item "4 Quantity}
    #I4D a 15 {Item 4 Description}
    #I4UP n 8 {Item 4 Unit Price}
    #I4TP n 8 {Item 4 Total Price}
    set res2 "                                                                   "
    set batch_key "[format "%013s" [string trim $a(batch_no)]]"
    set rec_type "2"
    set res3 " "

}

proc dynamic_descriptor {merchant rec} {
upvar $merchant m
upvar $rec re

    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID LINE_SIZE OUTPUT_FILE
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT
    global TEMP_CRSR

        if {$SUB_BATCH_NUM_TCR != 0} {
            incr SUB_BATCH_NUM_TCR 3
            incr SUB_BATCH_NUM_TRANS
            incr BATCH_NUM_TCR 3
            incr BATCH_NUM_TRANS 3
            incr FILE_NUM_TCR 3
            incr FILE_NUM_TRANS 3
            write_sub_batch_trailer
        }

        incr BATCH_NUM_TCR
        incr BATCH_NUM_TRANS
        incr FILE_NUM_TCR
        incr FILE_NUM_TRANS
        write_batch_trailer
        init_batch_variables

        close $TEMP_FILE
        #orasql $TEMP_CRSR "select mmid from merchant where mid = '$m(mid)'"
        #orafetch $TEMP_CRSR -dataarray z -indexbyname
        #orasql $TEMP_CRSR "select shortname from master_merchant where mmid = '$z(MMID)'"
        #orafetch $TEMP_CRSR -dataarray z -indexbyname
        set temp_filename "tc57.$CUR_PID.tmp"

        write_DD_batch_headers m re
# attach temp file to end of output file
        set TEMP_FILE [open $temp_filename r]
        while {[set line [read $TEMP_FILE $LINE_SIZE]] != {} } {
            puts -nonewline $OUTPUT_FILE $line
        }
        close $TEMP_FILE
        init_sub_batch_variables
        set TEMP_FILE [open $temp_filename w]
}

#SYANG
proc mc_dynamic_descriptor {merchant aname} {
    upvar $aname a
    upvar $merchant merc

    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID TABLE_NAME OD4
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT tran_c terminal_c

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "1"
    set rec(reserved1) " "
    set rec(format_code) " "

    set rec(dd) " "
    
#SYNAG
    orasql $tran_c "select * from $TABLE_NAME where other_data4 = '$OD4'"
    set tstr [orafetch $tran_c -dataarray tran -indexbyname]
    orasql $terminal_c "select unique * from terminal where tid = '$tran(TID)'"
    set tstr [orafetch $terminal_c -dataarray terminal -indexbyname]
    
        set dd_len [string length [string trim $terminal(LONG_NAME)]]
        if {$dd_len <= 3} {
            set dd_len 3
        } else {
            if {$dd_len <= 7} {
                set dd_len 7
            } else {
                set dd_len 12
            }
        }

        set dummy_str "                         "                       ;# create padding
# get long_name and pad with spaces
        set temp [string trim $terminal(LONG_NAME)]$dummy_str
        set temp [string range $temp 0 [expr $dd_len - 1]]
        #puts "temp is <$temp>"
        set temp $temp*                                                 ;# put th '*' in the next position
        #puts "temp is now <$temp>"
        set dummy_str "                         "                       ;# create padding
        set temp2 [string range $tran(TICKET_NO) 0 24]$dummy_str      ;# get and pad ticket_no
#        puts "temp2 is <$temp2>"

# 25 characters availabe but "*" eats one so 24 characters remaining
# since we start counting at 0 remove one more for the proper index i.e 23
        set remaining_space [expr 23 - $dd_len]

        set temp2 [string range $temp2 0 $remaining_space]
#        puts "temp2 is now <$temp2>"
        set rec(dd) $temp2
#SYANG

    set rec(reserved) " " 
    set rec(rec_type) "2"
    set rec(rec_ind) " "
 
    write_tc_tcq_tcn_rt TEMP_FILE rec
}

###########################

proc add_vs_lodging {aname bname cname} {
    upvar $aname a
    upvar $bname b
    upvar $cname c

    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT tran_c

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "4"
    set rec(res) " "
    set rec(bfc) "LG"
    set rec(res1) " "
    if {$a(NO_SHOW) == "Y"} {
      set rec(lodging_no_show_ind) 1
    } else {
      set rec(lodging_no_show_ind) 0
    }
    if {[string is integer $a(EXTRA_CODES)] != 1} {
      set lodging_extra "000000"
    } else {
      set lodging_extra [string trim $a(EXTRA_CODES)]
      while {[string length $lodging_extra] != 6} {
        set lodging_extra [expr $lodging_extra * 10]
      }
    }
    set rec(lodging_extra) $lodging_extra
    set rec(res2) " "
    set rec(check_in) [string range $a(CHECK_IN_DATE) 2 8]

    set real_tax [expr ($CURRENCYDIVISOR($c(currency_code)) * $a(ROOM_RATE))]
    set real_tax [format "%0f" $real_tax]
    set real_tax [expr int($real_tax)]

    set rec(daily_rate) "$real_tax"

    set real_tax [expr ($CURRENCYDIVISOR($c(currency_code)) * $c(tax_amount))]
    set real_tax [format "%0f" $real_tax]
    set real_tax [expr int($real_tax)]

    set rec(room_tax) "$real_tax"
    set rec(total_tax) "$real_tax"
    set rec(prepaid_exp) " "
    set rec(food_charge) " "
    set rec(folio_cash_advance) " "
    if {[string length [string trim $a(CHECK_OUT_DATE)]] == 0 } {
      set TRN [expr [format "%0d" $c(shipdatetime)] - $a(CHECK_IN_DATE)]
    } else {
      set TRN [expr [format "%0d" $a(CHECK_OUT_DATE)] - $a(CHECK_IN_DATE)]
    }
    if {$TRN < 1} {
      set TRN 1
    }
    set rec(room_nights) $TRN
    set rec(res3) " "
    set rec(imbk) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(rec_type) "2"
    set rec(res4) " "

    write_tc_tcq_tcn_rt TEMP_FILE rec
}

proc add_mc_lodging {aname bname cname} {
    upvar $aname a
    upvar $bname b
    upvar $cname c
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT tran_c

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "4"
    set rec(arrival_date) "[string range $a(CHECK_IN_DATE) 4 8][string range $a(CHECK_IN_DATE) 2 3]"
    set rec(depart_date) "[string range $a(CHECK_OUT_DATE) 4 8][string range $a(CHECK_OUT_DATE) 2 3]"

    if {[string length [string trim $a(CHECK_OUT_DATE)]] == 0 || $a(CHECK_OUT_DATE) < $a(CHECK_IN_DATE)} {
      set rec(depart_date) "[expr [string range $c(shipdatetime) 4 7] + 1 ][string range $c(shipdatetime) 2 3]"

    }
    set rec(bfc) "06"
    set rec(folio) "$a(FOLIO_NUMBER)"
    if {[string length [string trim $a(FOLIO_NUMBER)]] == 0} {
      set rec(folio) "123456789"
    }
    regsub -all -- "-" $b(cust_service) "" cust_srv_number
    regsub -all -- "-" $b(phone_no) "" phone_no
    set cust_srv_number [string range $cust_srv_number 0 9]
    set phone_no [string range $phone_no 0 9]
    set rec(property_phone) "$phone_no"
    set rec(cust_serv_phone) "$cust_srv_number"

    set real_tax [expr ($CURRENCYDIVISOR($c(currency_code)) * $a(ROOM_RATE))]
    set real_tax [format "%0f" $real_tax]
    set real_tax [expr int($real_tax)]

    set rec(room_rate) "$real_tax"

    set real_tax [expr ($CURRENCYDIVISOR($c(currency_code)) * $c(tax_amount))]
    set real_tax [format "%0f" $real_tax]
    set real_tax [expr int($real_tax)]

    set rec(room_tax) "$real_tax"
    set rec(total_tax) "$real_tax"
    if {$real_tax == 0} {
      set rec(total_tax) 1
    }
    set rec(res1) " "

    set TRN [expr [format "%0f" $rec(depart_date)] - $a(CHECK_IN_DATE)]
    if {$TRN < 1} {
      set TRN 1
    }
    set rec(total_room_nights) "$TRN"
    set rec(fsai) "Y"
    set rec(customer_code) " "
    set rec(imbk) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(rec_type) "3"
    set rec(res4) " "

    write_tc_tcq_tcn_rt TEMP_FILE rec
}

proc add_vs_tax {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT tran_c

    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "5"
   if {$a(pc_type) == "S" || $a(pc_type) == "B"} {
    set rec(local_tax) [convert_amount $a(tax_amount)]
    if {$rec(local_tax) == "0"} {
      set rec(local_tax) [convert_amount [expr $a(amount) * 0.06]]
    }
    if {$rec(local_tax) < 0.01} {
      set rec(local_tax) 1
    }
    set rec(tax_included) "1" 
   } else {
    set rec(tax_included) "0"
    set rec(local_tax) 0
   }

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    set rec(PIF) "1"
    #set rec(PI) "$a(ticket_no)"
    if {  [string is digit $a(ticket_no)]  } {
        set rec(PI) $a(ticket_no)
    } else {
        # set to a numeric value that is somewhat unique
        # TODO send an info-only message if this occurs???
        set rec(PI) [clock format [clock seconds] -format "%Y%m%d%H%m%S"]
    }

    if {$a(market_type) == "L"} {
      set rec(PIF) "4"
      orasql $tran_c "select folio_number from extension_lodging where unique_id = '$a(other_data3)'"
      if {[orafetch $tran_c -dataarray tran -indexbyname] != 1403 } {
        set rec(PI) $tran(FOLIO_NUMBER) 
        if {[string length [string trim $tran(FOLIO_NUMBER)]] == 0} {
          set rec(PI) "123456789"
        }
      }
    }

    #if {$rec(PI) == "          "} {
    #  set rec(PI) "0"
    #}
    set rec(national_tax_included) "0"
    set rec(national_tax) "            "
    set rec(CRI) "                 "
    set rec(BRN) "                    "
    set rec(customer_vat) "             "
    set rec(scc) "    "
    set rec(other_tax) "            "
    set rec(PC1) "  "
    set rec(PC2) "  "
    set rec(PC3) "  "
    set rec(PC4) "  "
    set rec(PC5) "  "
    set rec(PC6) "  "
    set rec(PC7) "  "
    set rec(PC8) "  "
    set rec(res) " "
    set rec(mi) "               "
    set rec(version_code) "  "
    set rec(imbk) "[format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]"
    set rec(rec_type) "2"
    set rec(res1) " "
    write_tc_tcq_tcn_rtV TEMP_FILE rec

}

proc add_mc_transport {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT terminal_c tran_c
    orasql $terminal_c "select * from extension_transport where unique_id = '$a(other_data4)'"

    set rec(l1_orig_city) " "
    set rec(l1_carrier_code) " "
    if {[orafetch $terminal_c -dataarray c -indexbyname] != 1403 } {

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    orasql $tran_c "select * from leg_information where unique_id = '$a(other_data4)' and leg_number = 1"
    if {[orafetch $tran_c -dataarray d -indexbyname] != 1403 } {
      set rec(l1_orig_city) "$d(ORIGIN_CITY)"
      set rec(l1_desc_city) "$d(DESTINATION_CITY)"
    }
    set rec(l1_carrier_code) "$c(CARRIER_CODE)"
    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 4
    set rec(bfc) 01 
    set rec(pass_name) "$c(PASSENGER_NAME)"
    set rec(ticket_number) "$c(TICKET_NUMBER)"
    set rec(res1) " "
    set rec(issuing_carrier) "$c(ISSUING_CARRIER)"
    set rec(customer_code) "$c(CUSTOMER_CODE)"
    set rec(tac) "$c(TRAVEL_AGENCY_CODE)"
    set rec(tan) "$c(TRAVEL_AGENCY_NAME)"
    set rec(total_fare) "$a(amount)"
    set rec(l1_travel_date) "$c(FLIGHT_DATE)"
    set rec(l1_scc) "1"
    set rec(l1_soc) " "
    set rec(l1_fbc) " "
    set rec(l1_flight_number) "$c(FLIGHT_NUMBER)"
    set rec(l1_dep_time) " "
    set rec(l1_dep_time_seg) " "

    set rec(res2) " "
    set rec(imbk) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(rec_type) 2
    set rec(res3) " "
    write_tc_tcq_tcn_rtM TEMP_FILE rec
    }


}

proc add_vs_transport {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT terminal_c tran_c

    orasql $terminal_c "select * from extension_transport where unique_id = '$a(other_data4)'"
    set rec(orig_city) " "
    set rec(leg1) " "
    set rec(leg2) " "
    set rec(leg3) " "
    set rec(leg4) " "
    if {[orafetch $terminal_c -dataarray c -indexbyname] != 1403 } {

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


      orasql $tran_c "select * from leg_information where unique_id = '$a(other_data4)' and leg_number = 1"
      if {[orafetch $tran_c -dataarray d -indexbyname] != 1403 } {
        set rec(orig_city) $d(ORIGIN_CITY)
        if {$c(CARRIER_CODE) == " " } {
          set rec(leg1) "U5$d(SERVICE_CLASS)$d(STOPOVER_CODE)$d(DESTINATION_CITY)"
        } else {
          set rec(leg1) "$c(CARRIER_CODE)$d(SERVICE_CLASS)$d(STOPOVER_CODE)$d(DESTINATION_CITY)"
        }
      }
      orasql $tran_c "select * from leg_information where unique_id = '$a(other_data4)' and leg_number = 2"
      if {[orafetch $tran_c -dataarray d -indexbyname] != 1403 } {
        set rec(leg2) "$c(CARRIER_CODE)$d(SERVICE_CLASS)$d(STOPOVER_CODE)$d(DESTINATION_CITY)"
      }
      orasql $tran_c "select * from leg_information where unique_id = '$a(other_data4)' and leg_number = 3"
      if {[orafetch $tran_c -dataarray d -indexbyname] != 1403 } {
        set rec(leg3) "$c(CARRIER_CODE)$d(SERVICE_CLASS)$d(STOPOVER_CODE)$d(DESTINATION_CITY)"
      }
      orasql $tran_c "select * from leg_information where unique_id = '$a(other_data4)' and leg_number = 4"
      if {[orafetch $tran_c -dataarray d -indexbyname] != 1403 } {
        set rec(leg4) "$c(CARRIER_CODE)$d(SERVICE_CLASS)$d(STOPOVER_CODE)$d(DESTINATION_CITY)"
      }
    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "4"
    set rec(l3_fbc) " "
    set rec(l4_fbc) " "
    set rec(bfc) "AI"
    set rec(crs) $c(COMP_RSERV_SYSTEM)
    set rec(res) " "
    set rec(pass_name) $c(PASSENGER_NAME)
    #puts "$c(FLIGHT_DATE)"
    #puts "[string range $c(FLIGHT_DATE) 4 7][string range $c(FLIGHT_DATE) 2 3]"
    set rec(depart_date) [string range $c(FLIGHT_DATE) 4 7][string range $c(FLIGHT_DATE) 2 3]
    set rec(tac) $c(TRAVEL_AGENCY_CODE)
    set rec(tan) $c(TRAVEL_AGENCY_NAME)
    set rec(rti) $c(RESTRICTED_TICKET_INDICATOR)
    if {$rec(rti) != "0" && $rec(rti) != "1"} {
      set rec(rti) 0
    }
    set rec(otn) $c(TICKET_NUMBER)
    set rec(l1_fbc) " "
    set rec(l1_fn) "$c(FLIGHT_NUMBER)"
    set rec(l2_fbc) " "
    set rec(l2_fn) " "
    set rec(res1) " "
    set rec(imbk) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(rec_type) "2"
    set rec(res4) " "
    write_tc_tcq_tcn_rtV TEMP_FILE rec
    }

}


proc add_ds_statement {aname m} {
    upvar $aname a
    upvar $m merchant
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID TABLE_NAME OD4 temp_crsr2
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT tran_c terminal_c INSTITUTION_ID

    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "3"
    set rec(sdr) "01" 
    set rec(seq_nbr) "01"

#Myke
    orasql $temp_crsr2 "select DYNAMIC_DESC_FLAG from entity_to_auth where mid = '$merchant(mid)' and institution_id = '$INSTITUTION_ID' and status = 'A'"
    orafetch $temp_crsr2 -dataarray z -indexbyname
    if {$z(DYNAMIC_DESC_FLAG) == "Y"} {

    orasql $tran_c "select * from $TABLE_NAME where other_data4 = '$OD4'"
    set tstr [orafetch $tran_c -dataarray tran -indexbyname]
    orasql $terminal_c "select unique * from terminal where tid = '$tran(TID)'"
    set tstr [orafetch $terminal_c -dataarray terminal -indexbyname]

        set dd_len [string length [string trim $terminal(LONG_NAME)]]
        if {$dd_len <= 4} {
            set dd_len 4 
        } else {
            if {$dd_len <= 8} {
                set dd_len 8 
            } else {
                set dd_len 13
            }
        }

        set dummy_str "                         "                       ;# create padding
# get long_name and pad with spaces
        set temp [string trim $terminal(LONG_NAME)]$dummy_str
        set temp [string range $temp 0 [expr $dd_len - 1]]
        #puts "temp is <$temp>"
        #puts "temp is now <$temp>"
        set dummy_str "                         "                       ;# create padding
        set temp2 [string range $tran(TICKET_NO) 0 24]$dummy_str      ;# get and pad ticket_no
#        puts "temp2 is <$temp2>"

# 25 characters availabe but "*" eats one so 24 characters remaining
# since we start counting at 0 remove one more for the proper index i.e 23
        set remaining_space [expr 23 - $dd_len]

        set temp2 [string range $temp2 0 $remaining_space]
#        puts "temp2 is now <$temp2>"
#myke

    set rec(message) "$temp$temp2"
    } else {
      set rec(message) " "
    }
    set rec(filler) " "
    set rec(ind) "D" 
    write_tc_tcq_tcn_sdr TEMP_FILE rec
}

proc add_ds_cash_over {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT

    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "3"
    set rec(sdr) "03"
    set rec(seq_nbr) "01"
    set rec(cash_over) 0
    set rec(filler) " "
    set rec(ind) "D"
    write_tc_tcq_tcn_sdr TEMP_FILE rec
}

proc add_ds_lodging1 {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT ZIP

    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "3"
    set rec(sdr) "09"
    set rec(seq_nbr) "01"
    set rec(promo_code) " "
    set rec(coupon_code) " "
    set rec(ccc) " "
    set rec(room_loc) " "
    set rec(bed_type) " "
    set rec(room_type) " "
    set rec(smoking) " "
    set rec(nbr_rooms) "0"
    set rec(nbr_adults) 0
    set rec(tax) " "
    set rec(no_show) $a(NO_SHOW)
    set rec(travel_code) " "
    set rec(extra_charge) " "
    set rec(travel_agency_name) " "
    set rec(filler) " "
    set rec(ind) "D"
    write_tc_tcq_tcn_sdr TEMP_FILE rec
}

proc add_ds_lodging2 {aname bname cname} {
    upvar $aname a
    upvar $bname b
    upvar $cname c
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT ZIP

    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "3"
    set rec(sdr) "09"
    set rec(seq_nbr) "02"

    set rec(arrival) "$a(CHECK_IN_DATE)"
    set rec(depart) "$a(CHECK_OUT_DATE)"

    if {[string length [string trim $a(CHECK_OUT_DATE)]] == 0} {
      set rec(depart) "$c(shipdatetime)"
    }
    set rec(folio) "$a(FOLIO_NUMBER)"
    if {[string length [string trim $a(FOLIO_NUMBER)]] == 0} {
      set rec(folio) "123456789"
    }

    regsub -all -- "-" $b(phone_no) "" phone_no
    set phone_no [string range $phone_no 0 9]

    set rec(fac_phone) $phone_no
    set rec(adjustment_amount) 0

    set real_tax [expr ($CURRENCYDIVISOR($c(currency_code)) * $a(ROOM_RATE))]
    set real_tax [format "%0f" $real_tax]
    set real_tax [expr int($real_tax)]

    set rec(room_rate) "$real_tax"

    set real_tax [expr ($CURRENCYDIVISOR($c(currency_code)) * $c(tax_amount))]
    set real_tax [format "%0f" $real_tax]
    set real_tax [expr int($real_tax)]

    set rec(room_tax) "$real_tax"
    set rec(program) " "
    set rec(phone_charge) 0
    set rec(rest_charge) 0
    set rec(mini_bar_charge) 0
    set rec(laun_charge) 0
    set rec(other_charge) 0
    set rec(other_ind) " "
    set rec(gift_charge) 0
    set rec(filler) " "
    set rec(ind) "D"
    write_tc_tcq_tcn_sdr TEMP_FILE rec
}

proc add_ds_address {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT ZIP

    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "3"
    set rec(sdr) "04"
    set rec(seq_nbr) "01" 
    set rec(zip) $ZIP 
    set rec(store_number) " "
    set rec(mall_name) " "
    set rec(phone_number) " "
    set rec(filler) " "
    set rec(ind) "D"
    write_tc_tcq_tcn_sdr TEMP_FILE rec
}


proc add_ds_tip  {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT

    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "3"
    set rec(sdr) "02"
    set rec(seq_nbr) "01"
    set rec(tip) 0 
    set rec(filler) " " 
    set rec(ind) "D" 
    write_tc_tcq_tcn_sdr TEMP_FILE rec
}



proc add_ds_additional {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT

    #incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

    #incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

    #incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR


    set rec(tc) "57" 
    set rec(tcq) "0"
    set rec(tcn) "1" 
    set rec(sdr) "00"
    set rec(pro_code) "00"
    if {$a(transaction_type) == "U"} {
      set rec(pro_code) "14"
    }
    if {$a(request_type) == "0420"} {
      set rec(pro_code) "20"
    }
    set rec(psi) "N"
    #puts "[string range $a(shipdatetime) 8 14]"
    set rec(tran_date) [string range $a(shipdatetime) 2 8]
    set rec(tran_time) [string range $a(shipdatetime) 8 14]

    set rec(pos_entry) 01 
    if  {$a(pos_entry) == "1" || $a(pos_entry) == "2" }  {
      set rec(pos_entry) 02 
    }
    if  {$a(transaction_type) == "I" || $a(transaction_type) == "U"} {
      set rec(pos_entry) 07 
    }

    if  {$a(pos_entry) == "1"} {
      if {$a(cvv) == " "} {
        set rec(tdcc) "10"
      } else {
        set rec(tdcc) "20"
      }
    } else {
      if {$a(cvv) == " "} {
        set rec(tdcc) "01"
      } else {
        set rec(tdcc) "02"
      }
    }

    if {$a(transaction_type) == "R" || $a(transaction_type) == "1" || $a(transaction_type) == "5" || $a(transaction_type) == "6" || $a(transaction_type) == "8" || $a(transaction_type) == "T"} {
      set rec(pos_data) 909009092
    }
    if {$a(transaction_type) == "M"} {
      set rec(pos_data) 909219096
    }
    #if {$a(transaction_type) == "U"} {
      #set rec(pos_data) 90941909S
    #}
    if {$a(transaction_type) == "I" || $a(transaction_type) == "U"} {
      set rec(pos_data) 90951909S
    }
    set rec(response_code) [string range $a(action_code) 1 2]
    set rec(network_refernce) " "

    set rec(res2) " "
    set rec(ind) "D"
    write_tc_tcq_tcn_sdr TEMP_FILE rec
}

proc add_mc_tax {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT

    set rec(tc) "57"
    set rec(tcq) "0"
    set rec(tcn) "6"
    set rec(sales_tax) [convert_amount $a(tax_amount)]
    if {$rec(sales_tax) == "0"} {
      set rec(sales_tax) [convert_amount [expr $a(amount) * 0.06]]
    }
    if {$rec(sales_tax) < 0.01} {
      set rec(sales_tax) 1
    }

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    set rec(sales_tax_included) "Y"
    set rec(customer_code) $a(ticket_no)
    set rec(commodity_code) "               " 
    set rec(merchant_type) "    "
    set rec(merchant_reference_number) "                         " 
    set rec(merchant_tax_identifier) "                    " 
    set rec(res) "                              " 
    set rec(mi) "               " 
    set rec(version_code) "  "
    set rec(imbk) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(rec_type) "2"
    set rec(res1) " "
    write_tc_tcq_tcn_rt TEMP_FILE rec

}

proc add_mc_compliance {aname} {
    upvar $aname a
    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID TEMP_CRSR
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT FLAG terminal_c

    set original_amount [expr ($CURRENCYDIVISOR($a(currency_code)) * $a(orig_amount))]
    set original_amount [format "%0f" $original_amount]
    set original_amount [expr int($original_amount)]

#    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR

#    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR

#    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 5
    set rec(rec_type) 2
    set rec(reserved1) " "
    set rec(banknet_num) [string range $a(cps_tran_id) 4 12]
    set rec(banknet_date) [string range $a(cps_tran_id) 0 3]

# JNC Fix these 4
    orasql $terminal_c "select * from ecomm_addendum_auth where unique_id = '$a(other_data3)'"
    if {[orafetch $terminal_c -dataarray ecomm -indexbyname] != 1403} {
      set cavv $ecomm(CAVV)
    } else {
      set cavv " "
    }
    if {$a(transaction_type) == "I" || $a(transaction_type) == "U"} {
      set rec(val_code) " "
      set rec(ucaf_sec) "2"
      set rec(ucaf_cha) "1"
      set rec(ucaf_us) "0"
      if { $FLAG == "X"} {
        orasql $terminal_c "select * from merchant_addenda_rt where mid = '$a(mid)'"
        #puts "select * from merchant_addenda_rt where mid = '$a(mid)'"
        set tstr [orafetch $terminal_c -dataarray mar -indexbyname]
        if {[string match S $mar(FLAGS)] == 1} {
        #if {$mar(FLAGS) == "S"} 
          set FLAG S
        } else {
          set FLAG N
        }
      }
      #puts "$FLAG"
      if {$cavv != " " && $FLAG == "N"} {
        set rec(ucaf_us) "1"
      } else {
        if {$FLAG == "S"} {
          set rec(ucaf_us) "2"
        }
      }
    } else {
      set rec(val_code) " "
      set rec(ucaf_sec) " "
      set rec(ucaf_cha) " "
      set rec(ucaf_us) " "

    }
    set rec(service_code) "099"
    set rec(pos_sd) "199990059001"
    if {$a(transaction_type) == "R" || $a(transaction_type) == "1" || $a(transaction_type) == "5" || $a(transaction_type) == "6" || $a(transaction_type) == "8"} {
      if {$a(pos_entry) == 0} {
        set rec(pos_sd) "B99901659001"
      } elseif {$a(pos_entry) == 1} {
        set rec(pos_sd) "B99901B59001"
      } elseif {$a(pos_entry) == 2} {
        set rec(pos_sd) "B99901B59001"
      } elseif {$a(pos_entry) == 9} {
        set rec(pos_sd) "A99901A99001"
      } else {
        set rec(pos_sd) "B99001059001"
      }
    }
    if {$a(transaction_type) == "M"} {
      set rec(pos_sd) "199030099001"
    }
    #if {$a(transaction_type) == "U"} {
    #  set rec(pos_sd) "199040099001"
    #}
    if {$a(transaction_type) == "I" || $a(transaction_type) == "U"} {
      orasql $terminal_c "select * from ecomm_addendum_auth where unique_id = '$a(other_data3)'"
      if {[orafetch $terminal_c -dataarray ecomm -indexbyname] != 1403 } {
        set rec(pos_sd) "D99959S99001"
      } else {
        set rec(pos_sd) "D99959S99001"
      }
    }



    set rec(reserved2) " "
    set rec(auth_amount) $original_amount
    set rec(reserved3) " "
    set rec(batch_key) [format "%013s" [string trim $a(batch_no)]]

#JNC Fix this?
    set rec(reimburse_attr) "0"

    write_tc_tcq_tcn_rt TEMP_FILE rec
};# end add_mc_compliance



# Try to determine the ECI from the ecomm_addenda_auth table
proc determine_eci {other_data3} {
    global TEMP_CRSR
set x ""
    #puts "other_data3: <$other_data3>"
    set eci "7"             ;# set default value
    if {$other_data3 != " "} {
        orasql $TEMP_CRSR "select * from ecomm_addendum_auth where unique_id = \'$other_data3\'"
        set ecomm_collist [oracols $TEMP_CRSR]
#        puts $ecomm_collist

       # set x [orafetch $TEMP_CRSR ]
        orafetch $TEMP_CRSR -datavariable x

        if {[oramsg $TEMP_CRSR rc] != 1403} {
            load_array ecomm_addendum $x $ecomm_collist
            if {$ecomm_addendum(eci) != " "} {
              #puts "[string range $ecomm_addendum(eci) 1 1]"
                switch [string range $ecomm_addendum(eci) 1 1] {
                    "5" -
                    "6" {set eci [string range $ecomm_addendum(eci) 1 1]}
                }
            }
        }
    }
    #puts "ECI:$eci"
    return $eci
};# end determine_eci



proc make_b2lines {aname m} {
    upvar $m merchant

    global FILE_NUM_TRANS FILE_NUM_TCR FILE_TOTAL_AMOUNT FILE_NUM_MONEY_TRANS SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_TCR
    global SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT SUB_BATCH_NUM_MONEY_TRANS CURRENCYDIVISOR COUNTRYCODE
    global DEST_BIN SOURCE_BIN CUR_SET_TIME FILE_NUM TEMP_FILE CUR_JULIAN_DATEX CUR_PID TABLE_NAME
    global PROCESSING_BIN BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_TOTAL_AMOUNT
    global tranhistory_arn tran_c temp_crsr2 INSTITUTION_ID

    upvar $aname a

#    set real_amount [expr int($CURRENCYDIVISOR($a(currency_code)) * $a(amount))]
    set real_amount [expr ($CURRENCYDIVISOR($a(currency_code)) * $a(amount))]
    set real_amount [format "%0f" $real_amount]
    set real_amount [expr int($real_amount)]

#    set real_amount [expr int($a(amount)*100)]


    incr FILE_NUM_TRANS
    incr FILE_NUM_MONEY_TRANS
    incr FILE_NUM_TCR
    set  FILE_TOTAL_AMOUNT [expr $FILE_TOTAL_AMOUNT +  $real_amount]

    incr BATCH_NUM_TRANS
    incr BATCH_NUM_MONEY_TRANS
    incr BATCH_NUM_TCR
    set  BATCH_TOTAL_AMOUNT [expr $BATCH_TOTAL_AMOUNT +  $real_amount]

    incr SUB_BATCH_NUM_TRANS
    incr SUB_BATCH_NUM_MONEY_TRANS
    incr SUB_BATCH_NUM_TCR

    switch $a(request_type) {
        "0420" -
        "0440" {set SUB_BATCH_NET_AMOUNT [expr $SUB_BATCH_NET_AMOUNT - $real_amount]}
        default {set SUB_BATCH_NET_AMOUNT [expr $SUB_BATCH_NET_AMOUNT +  $real_amount]}
    }

    set SUB_BATCH_GROSS_AMOUNT [expr $SUB_BATCH_GROSS_AMOUNT + $real_amount]

    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 0
    set rec(dest_bin) $DEST_BIN
    set rec(src_bin) $SOURCE_BIN
    set rec(sc_ind) " "
    set rec(tran_cq) 0

    if {$a(transaction_type) == "U"} {
        set rec(recur_pmt_ind) "4"
    } else {
        set rec(recur_pmt_ind) " "
    }

    set rec(rsrvd1) 0
    set rec(tran_amt) $real_amount
    set rec(cur_code) $a(currency_code)
    set rec(drft_sent_flg) "N"
    set rec(cp_date) $CUR_JULIAN_DATEX
    set rec(fmt_code) "DC"
    set rec(rev_flag) " "

    if {$a(transaction_type) == "I" || $a(transaction_type) == "U"} {
        set rec(cat_ind) "6"
    } else {
        set rec(cat_ind) " "
    }

    set rec(prepaid_crd) " "
    set rec(chip_code) " "

    switch $a(card_type) {
        "DB" {set rec(card_type) "D"}
        "VS" {set rec(card_type) "V"}
        "MC" {set rec(card_type) "M"}
        "AX" {set rec(card_type) "S"}
        "DS" {set rec(card_type) "R"}
        "DC" {set rec(card_type) "N"}
        "JC" {set rec(card_type) "J"}
        default {set rec(card_type) "L"}
    }
    set rec(pan) $a(cardnum)
    set rec(purch_date) [string range $a(shipdatetime) 4 7]
    set rec(tran_time) [string range $a(shipdatetime) 8 11]

    switch $a(request_type) {
        "0260" {set rec(tran_type) "3"}
        "0262" {set rec(tran_type) "3"}
        "0460" {set rec(tran_type) "4"}
        "0462" {set rec(tran_type) "4"}
        "0100" {set rec(tran_type) "1"}
        "0220" {
                 if {$TABLE_NAME == "SETTLEMENT"} {
                   set rec(tran_type) "5"
                 } else {
                   set rec(tran_type) "9"
                 }
               }
        "0200" {set rec(tran_type) "5"}
        "0250" {
                 if {$TABLE_NAME == "SETTLEMENT"} {
                   set rec(tran_type) "5"
                 } else {
                   set rec(tran_type) "2"
                 }
               }
        "0420" {set rec(tran_type) "6"}
        default {set rec(tran_type) "5"}
    }
    if {$a(market_type) == "L"} {
      orasql $tran_c "select * from extension_lodging where unique_id = '$a(other_data3)'"
      if {[orafetch $tran_c -dataarray tran -indexbyname] != 1403 } {
        if {$tran(NO_SHOW) == "Y" && $a(card_type) == "VS"} {
          set rec(tran_type) "8"
        }
        if {[check_for_lodging_mcc merchant]} {
          set lodging_rec_ind Y
        } else {
          set lodging_rec_ind N
        }
      } else {
        set lodging_rec_ind N
      }
    }
    if {$a(request_type) == "0400"} {
      set rec(void_ind) "V"
    } else {
      set rec(void_ind) " "
    }

    set rec(void_ind) " "

# JNC - fix me - This will eventually need updating
# We need to determine if things are keyed but terminal has
# read capability etc.
    switch $a(pos_entry) {
         "0" {
                if { $rec(cat_ind) == "6" && $a(card_type) == "MC"} {
                     set rec(entry_method) "S"
                } else {
                     set rec(entry_method) "@"
                }
         }
        "1" {set rec(entry_method) "H"}
        "2" {set rec(entry_method) "D"}
        "9" {set rec(entry_method) "G"}
        default {set rec(entry_method) " "}
    }

    switch $a(transaction_type) {
        "T" -
        "M" {set rec(ch_id_method) "4"}
        "1" -
        "5" -
        "6" -
        "8" -
        "R" {set rec(ch_id_method) "1"}
        "I" {set rec(ch_id_method) "4"}
        #"U" {set rec(ch_id_method) "1"}
        "U" {set rec(ch_id_method) "4"}
        default {set rec(ch_id_method) " "}
    }
    if {$a(request_type) == "0260" && $a(card_type) == "VS" && $a(avs_response) != " "} {
      set rec(ch_id_method) "2"
    } 
    
    if {$a(cps_tran_id) != " "} {
        set rec(auth_code) $a(auth_code)
    } else {
        set rec(auth_code) " "
    }

     set rec(auth_source) $a(auth_source)
#    set rec(aci) $a(aci)

# JNC - fix me - Need to come up with a better solution
    set rec(film_loc) [format "%05s%06s" $CUR_PID $FILE_NUM_MONEY_TRANS]
    set temp [format "%05s%06s" $CUR_PID $FILE_NUM_MONEY_TRANS]
    set tranhistory_arn [make_acq_ref_num $SOURCE_BIN $CUR_JULIAN_DATEX $temp $a(card_type) $a(request_type) $a(currency_code)]
#    set rec(film_loc) 9

    set rec(tip_cashbk) " "

    switch $a(transaction_type) {
        "T" -
        "M" {set rec(moto_ec_ind) "1"}
        "I" {set rec(moto_ec_ind) [determine_eci $a(other_data3)] }
        "U" {set rec(moto_ec_ind) "2"}
        default {set rec(moto_ec_ind) " "}
    }
     if {$a(aci) == "W" && $a(transaction_type) == "U"} {
       set rec(moto_ec_ind) "7"
     }

     if {$a(aci) == "W" && $a(transaction_type) == "I"} {
       set rec(moto_ec_ind) "7"
     }

     if {$a(aci) == "S" && $a(transaction_type) == "I"} {
       set rec(moto_ec_ind) "6"
     }
 
     if {$a(aci) == "U" && $a(transaction_type) == "I"} {
       set rec(moto_ec_ind) "5"
     }
     #puts "aci: $a(aci) : transaction_type : $a(transaction_type): cardnum :$a(cardnum) : eci:$rec(moto_ec_ind)"

    if {[string range $a(request_type) 2 2] == "6"} {   #MYKEDEBIT
      set first [string first TN: $a(other_data2)]
      if {$first != -1} {
        set end [string first ";" $a(other_data2) $first]
        set clr [string range $a(other_data2) [expr $first + 3 ] [expr $end - 1]]
      } else {
        set clr " "
      }
      set rec(debit_ind) "D"
      set rec(dta_num) $clr
      set rec(posdra) " "
      set rec(debit_date) [string range $a(shipdatetime) 4 4]
      set rec(debit_time) [string range $a(shipdatetime) 8 6]
    } else {
      set rec(debit_ind) " "
      set rec(dta_num) " "
      set rec(posdra) " "
      set rec(debit_date) 0
      set rec(debit_time) 0
    }
    set rec(rsrch_code) " "
    set rec(netwrk_id) " "
    set rec(settle_date) [clock format $CUR_SET_TIME -format "%m%d"]
    set rec(ret_ref_num) $a(retrieval_no)
    set rec(avs) $a(avs_response)
    set rec(crb_exc_ind) " "
    set rec(atm_account) " "
#
#   request_type 0250 removed as a conditional from the following statement
#   by MGI 05-08-2007
#

    if {$a(request_type) == "0420" || $a(request_type) == "0220"} {
        set rec(aci) "N"
    } else {
        set rec(aci) $a(aci)
    }
    if {$a(transaction_type) == "U"} {
       #set rec(aci) "U"
       set rec(mkt_auth_data) "B"
    }


    switch $a(pos_entry) {
        "0" {set rec(pos_entry) "01"}
        "1" -
        "2" {set rec(pos_entry) "90"}
        "9" {set rec(pos_entry) "91"}
        default {set rec(pos_entry) "  "}
    }

    set rec(batch_key) [format "%013s" [string trim $a(batch_no)]]
    set rec(rec_type) "2"
    if {$a(transaction_type) == "U" || $a(market_type) == "L"} {
      set rec(reimburse_attr) "A"
    } else {
      set rec(reimburse_attr) "0"
    }

    write_tc_tcq_tcn_rt TEMP_FILE rec

    switch $a(card_type) {
        "VS" {add_cps_detail a merchant}
        "MC" {add_mc_compliance a}
        "DS" {
              add_ds_additional a
              if {$a(request_type) != "0420"} {
              add_ds_statement a merchant
              add_ds_tip a
              add_ds_cash_over a
              add_ds_address a
              }

             }  
        default { }
    }
    if {$a(market_type) == "L" && $lodging_rec_ind == "Y"} {
      if {$a(card_type) == "MC"} {
        add_mc_lodging tran merchant a
      }
      if {$a(card_type) == "VS"} {
        add_vs_lodging tran merchant a
      }
      if {$a(card_type) == "DS"} {
        add_ds_lodging1 tran
        add_ds_lodging2 tran merchant a
      }
    }
    if {$a(market_type) == "J"} {
      if {$a(card_type) == "MC"} {
        add_mc_transport a
      }
      if {$a(card_type) == "VS"} {
        add_vs_transport a
      }
    }
#    puts "$a(card_type), $a(cardnum)"
    if {$a(card_type) == "MC"} {
      switch [string range $a(cps_tran_id) 4 6] {
        "MCB" {add_mc_tax a }
        "MWB" {add_mc_tax a }
        "MAB" {add_mc_tax a }
        "MWO" {add_mc_tax a }
        "MAC" {add_mc_tax a }
        "MCP" { }
        "MCF" { }
        "MCO" {add_mc_tax a}
        default { }
      }
    }
    if {$a(card_type) == "VS"} {
#      puts "$a(pc_type)"
      switch $a(transaction_type) {
        "I" {add_vs_tax a}
        "M" {add_vs_tax a}
        "U" {add_vs_tax a}
        "T" {add_vs_tax a}
        "1" -
        "5" -
        "6" -
        "8" -
        "R" {add_vs_tax a}
        default { }
      }
    }
    orasql $temp_crsr2 "select DYNAMIC_DESC_FLAG from entity_to_auth where mid = '$merchant(mid)' and institution_id = '$INSTITUTION_ID' and status = 'A'"
    orafetch $temp_crsr2 -dataarray z -indexbyname
     if {$z(DYNAMIC_DESC_FLAG) == "Y" && ($a(card_type) == "VS" || $a(card_type) == "MC")} {
       mc_dynamic_descriptor merchant rec
    }
    
    
};# end make_b2lines



# this is a quick list of the columns for the transaction table.  the
# second item is a v if it is a varchar and n if it is a number.  we
# need the list for two things, we need it for the select from catpure
# so that i can get all the columns AND rowid, and we use it to build
# the insert command to put the 166 in transaction
if {$TABLE_NAME == "SETTLEMENT"} {
set flist {
    {mid  v}
    {tid  v}
    {transaction_id  v}
    {request_type  v}
    {transaction_type  v}
    {cardnum  v}
    {exp_date  v}
    {amount  v}
    {orig_amount  n}
    {incr_amount  n}
    {fee_amount  n}
    {tax_amount  n}
    {process_code  v}
    {status  v}
    {authdatetime  v}
    {auth_timer  n}
    {auth_code  v}
    {auth_source  v}
    {action_code  v}
    {shipdatetime  v}
    {ticket_no  v}
    {network_id  v}
    {addendum_bitmap  v}
    {capture  v}
    {pos_entry  v}
    {card_id_method  v}
    {retrieval_no  v}
    {avs_response  v}
    {aci  v}
    {cps_auth_id  v}
    {cps_tran_id  v}
    {cps_validation_code  v}
    {currency_code  v}
    {clerk_id  v}
    {shift  v}
    {hub_flag  v}
    {billing_type  v}
    {batch_no  v}
    {item_no  v}
    {other_data  v}
    {settle_date  v}
    {card_type  v}
    {cvv v}
    {pc_type v}
    {currency_rate n}
    {other_data2 v}
    {other_data3 v}
    {other_data4 v}
    {arn v}
    {market_type v}
}
} else {
set flist {
    {mid  v}
    {tid  v}
    {transaction_id  v}
    {request_type  v}
    {transaction_type  v}
    {cardnum  v}
    {exp_date  v}
    {amount  v}
    {orig_amount  n}
    {incr_amount  n}
    {fee_amount  n}
    {tax_amount  n}
    {process_code  v}
    {status  v}
    {authdatetime  v}
    {auth_timer  n}
    {auth_code  v}
    {auth_source  v}
    {action_code  v}
    {shipdatetime  v}
    {ticket_no  v}
    {network_id  v}
    {addendum_bitmap  v}
    {capture  v}
    {pos_entry  v}
    {card_id_method  v}
    {retrieval_no  v}
    {avs_response  v}
    {aci  v}
    {cps_auth_id  v}
    {cps_tran_id  v}
    {cps_validation_code  v}
    {currency_code  v}
    {clerk_id  v}
    {shift  v}
    {hub_flag  v}
    {billing_type  v}
    {batch_no  v}
    {item_no  v}
    {other_data  v}
    {settle_date  v}
    {card_type  v}
    {cvv v}
    {pc_type v}
    {currency_rate n}
    {other_data2 v}
    {other_data3 v}
    {other_data4 v}
    {market_type v}
}
}




proc write_file_header {} {
    global PROCESSING_BIN SECURITY_CODE TEST_OPTION OUTGOING_FILE_ID CUR_JULIAN_DATE OUTPUT_FILE COUNTRY_CODE

    set rec(tc) 90
    set rec(proc_bin) $PROCESSING_BIN
    set rec(proc_date) $CUR_JULIAN_DATE
    set rec(rsrvd1) " "
    set rec(test_opt) $TEST_OPTION
    set rec(rsrvd2) " "
    set rec(sec_code) $SECURITY_CODE
    set rec(rsrvd3) " "
    set rec(file_id) $OUTGOING_FILE_ID
    set rec(rsrvd4) " "

    write_tc OUTPUT_FILE rec

};# end write_file_header

proc write_DD_batch_headers {merchant aname} {
    upvar $merchant merc
    upvar $aname a
    global CUR_SET_TIME CUR_JULIAN_DATE OUTPUT_FILE BATCH_NUM FILE_NUM SUB_BATCH_NUM_TCR OUTPUT_FILE COUNTRYCODE
    global DEST_BIN SOURCE_BIN TEMP_CRSR DYNAMIC_DESCRIPTORS terminal_c OD4 tran_c TABLE_NAME cardtype ZIP ENTITY_ID

#First Batch Header TC 57-0-0-1
    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 0
    set rec(dest_bin) $DEST_BIN
    set rec(src_bin) $SOURCE_BIN
    set rec(rsrvd1) " "
    set rec(tran_amt) 0
    set rec(rsrvd2) " "
    set rec(draft_flag) " "
    set rec(cp_date) [string range $CUR_JULIAN_DATE 1 4]
    set rec(rec_fmt_code) "DC"
    set rec(rev_flag) " "
    set rec(disc_a_id) 0
    set rec(rsrvd3) " "
    set rec(dcp_date) [string range $CUR_JULIAN_DATE 1 4]
    set rec(rsrvd4) " "
    set rec(agent) 0
    set rec(chain) 0
    set rec(merc_num) $merc(visa_id)
    if {$merc(visa_id) == " " && $cardtype == "DS"} {
      set rec(merc_num) $ENTITY_ID
    }
    if {$merc(visa_id) == " " && $cardtype == "DB"} {
      set rec(merc_num) $ENTITY_ID
    }
    set rec(store_num) 0
    set rec(term_num) 1
    set rec(batch_num) [expr $BATCH_NUM - 1]
    set rec(batch_date) [clock format $CUR_SET_TIME -format "%m%d"]
    if {$cardtype == "DS"} {
      set rec(ds_merc_id) $merc(discover_id)
    } else {
      set rec(ds_merc_id) " "
    }
    set rec(xmit_time) [clock format $CUR_SET_TIME -format "%H%M%S"]
    set rec(time_zone) [clock format $CUR_SET_TIME -format "%Z"]
    set rec(gmt_offset) " "
    set rec(merc_sec_code) 0
    set rec(rsrvd5) 0
    set rec(batch_key) [format "%08d" $FILE_NUM][format "%05d" $SUB_BATCH_NUM_TCR]
    set rec(rec_type) "1"
    set rec(reimburse_attr) 0

    write_tc_tcq_tcn_rt OUTPUT_FILE rec

#Second Batch Header TC 57-0-1-1
    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 1
    set rec(rsrvd1) " "
    set rec(dev_code) " "
    set rec(rsrvd2) " "
    set rec(its_num) " "
    set rec(mcc) $merc(sic_code)

#SYNAG
    orasql $tran_c "select * from $TABLE_NAME where other_data4 = '$OD4'"
    set tstr [orafetch $tran_c -dataarray tran -indexbyname]
    orasql $terminal_c "select unique * from terminal where tid = '$tran(TID)'"
    set tstr [orafetch $terminal_c -dataarray terminal -indexbyname]

        if {[string range $tran(OTHER_DATA) 0 0] == "#"} {
            set rec(merc_city) [string range $tran(OTHER_DATA) 1 12]
        } else {
            set rec(merc_city) [string range $terminal(CITY) 0 12]
        }
        #puts "$rec(merc_city):CITY"
        set merc_name_len [string length [string trim $terminal(LONG_NAME)]]
        if {$merc_name_len <= 3} {
            set merc_name_len 3
        } else {
            if {$merc_name_len <= 7} {
                set merc_name_len 7
            } else {
                set merc_name_len 12
            }
        }

        set dummy_str "                         "                       ;# create padding
# get long_name and pad with spaces
        set temp [string trim $terminal(LONG_NAME)]$dummy_str
        set temp [string range $temp 0 [expr $merc_name_len - 1]]
        #puts "temp is <$temp>"
        set temp $temp*                                                 ;# put th '*' in the next position
        #puts "temp is now <$temp>"
        set dummy_str "                         "                       ;# create padding
        set temp2 [string range $tran(TICKET_NO) 0 24]$dummy_str      ;# get and pad ticket_no
#        puts "temp2 is <$temp2>"

# 25 characters availabe but "*" eats one so 24 characters remaining
# since we start counting at 0 remove one more for the proper index i.e 23
        set remaining_space [expr 23 - $merc_name_len]

        set temp2 [string range $temp2 0 $remaining_space]
#        puts "temp2 is now <$temp2>"
        set rec(merc_name) $temp$temp2
#SYANG
#        puts "rec(merc_name) is <$rec(merc_name)>"
        set rec(merc_state) $terminal(STATE)
    #set rec(merc_name) [string range $merc(long_name) 0 24]
    #set rec(merc_city) [string range $merc(city) 0 12]
    #set rec(merc_state) [string range $merc(state) 0 1]
    set rec(merc_country) $COUNTRYCODE($merc(country))
    set rec(merc_zip) [string range $merc(zip) 0 4]
    set ZIP $merc(zip)
    set rec(rsrvd3) " "
    set rec(tran_route) " "
    set rec(term_loc_num) 0
    set rec(postal_code) " "
    set rec(rsrvd4) " "
    set rec(batch_key) [format "%08d" $FILE_NUM][format "%05d" $SUB_BATCH_NUM_TCR]
    set rec(rec_type) "1"
    set rec(rsrvd5) " "

    write_tc_tcq_tcn_rt OUTPUT_FILE rec
    if {$cardtype == "AX"} {
      amex_header merc rec
    }

};# end write_DD_batch_headers


proc write_batch_headers {merchant aname} {
    upvar $merchant merc
    upvar $aname a
    global CUR_SET_TIME CUR_JULIAN_DATE OUTPUT_FILE BATCH_NUM FILE_NUM SUB_BATCH_NUM_TCR OUTPUT_FILE COUNTRYCODE
    global DEST_BIN SOURCE_BIN TEMP_CRSR DYNAMIC_DESCRIPTORS terminal_c cardtype ZIP ENTITY_ID

#First Batch Header TC 57-0-0-1
    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 0
    set rec(dest_bin) $DEST_BIN
    set rec(src_bin) $SOURCE_BIN
    set rec(rsrvd1) " "
    set rec(tran_amt) 0
    set rec(rsrvd2) " "
    set rec(draft_flag) " "
    set rec(cp_date) [string range $CUR_JULIAN_DATE 1 4]
    set rec(rec_fmt_code) "DC"
    set rec(rev_flag) " "
    set rec(disc_a_id) 0
    set rec(rsrvd3) " "
    set rec(dcp_date) [string range $CUR_JULIAN_DATE 1 4]
    set rec(rsrvd4) " "
    set rec(agent) 0
    set rec(chain) 0
    set rec(merc_num) $merc(visa_id)
    if {$cardtype == "DS"} {
      set rec(merc_num) $ENTITY_ID
    }
    if {$cardtype == "DB"} {
      set rec(merc_num) $ENTITY_ID
    }
    set rec(store_num) 0
    set rec(term_num) 1
    set rec(batch_num) [expr $BATCH_NUM - 1]
    set rec(batch_date) [clock format $CUR_SET_TIME -format "%m%d"]
    if {$cardtype == "DS"} {
      set rec(ds_merc_id) $merc(discover_id)
    } else {
      set rec(ds_merc_id) " "
    }
    set rec(xmit_time) [clock format $CUR_SET_TIME -format "%H%M%S"]
    set rec(time_zone) [clock format $CUR_SET_TIME -format "%Z"]
    set rec(gmt_offset) " "
    set rec(merc_sec_code) 0
    set rec(rsrvd5) 0
    set rec(batch_key) [format "%08d" $FILE_NUM][format "%05d" $SUB_BATCH_NUM_TCR]
    set rec(rec_type) "1"
    set rec(reimburse_attr) 0

    write_tc_tcq_tcn_rt OUTPUT_FILE rec

#Second Batch Header TC 57-0-1-1
    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 1
    set rec(rsrvd1) " "
    set rec(dev_code) " "
    set rec(rsrvd2) " "
    set rec(its_num) " "
    set rec(mcc) $merc(sic_code)
    set rec(merc_name) [string range $merc(long_name) 0 24]
    set rec(merc_state) [string range $merc(state) 0 1]
    set rec(merc_city) [string range $merc(city) 0 12]
    set rec(merc_country) $COUNTRYCODE($merc(country))
    set rec(merc_zip) [string range $merc(zip) 0 4]
    set ZIP $merc(zip)
    set rec(rsrvd3) " "
    set rec(tran_route) " "
    set rec(term_loc_num) 0
    set rec(postal_code) " "
    set rec(rsrvd4) " "
    set rec(batch_key) [format "%08d" $FILE_NUM][format "%05d" $SUB_BATCH_NUM_TCR]
    set rec(rec_type) "1"
    set rec(rsrvd5) " "

    write_tc_tcq_tcn_rt OUTPUT_FILE rec
    if {$cardtype == "AX"} {
      amex_header merc rec
    }

};# end write_batch_headers

proc amex_header {merchant aname} {
    upvar $merchant merc
    upvar $aname a
    global CUR_SET_TIME CUR_JULIAN_DATE OUTPUT_FILE BATCH_NUM FILE_NUM SUB_BATCH_NUM_TCR OUTPUT_FILE COUNTRYCODE
    global DEST_BIN SOURCE_BIN TEMP_CRSR DYNAMIC_DESCRIPTORS terminal_c FILE_NUM FILE_NUM_TCR

    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 2

    set rec(res1) "            "
    set rec(SEN) $merc(amex_se_no)
    set rec(format_code) "02"
    set rec(invoice_batch) "501"
    set rec(invoice_sub) "00"
    set rec(PCI) "011198"

    set batch_num_file [open "amexseq.dat" "r+"]
    gets $batch_num_file FILE_SEQ_NUM
    seek $batch_num_file 0 start
    puts $batch_num_file [expr $FILE_SEQ_NUM + 1]
    close $batch_num_file
    set rec(file_seq_num) $FILE_SEQ_NUM

    set rec(CAP) "          "
    set rec(service_city) $merc(city)
    set rec(res2) "                                                                                "
    set rec(batch_key) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(rec_type) "1"
    set rec(res3) " "

    write_tc_tcq_tcn_rt OUTPUT_FILE rec
};


proc write_sub_batch_trailer {} {
    global CUR_JULIAN_DATE SUB_BATCH_NUM_MONEY_TRANS BATCH_NUM SUB_BATCH_NUM_TCR SUB_BATCH_NUM_TRANS SUB_BATCH_NET_AMOUNT
    global SUB_BATCH_GROSS_AMOUNT FILE_NUM_TCR FILE_NUM_TRANS TEMP_FILE FILE_NUM DEST_BIN SOURCE_BIN

    set rec(tc) 57
    set rec(tcq) 0
    set rec(tcn) 0
    set rec(dest_bin) $DEST_BIN
    set rec(src_bin) $SOURCE_BIN
    set rec(rsrvd1) 0
    set rec(rsrvd2) 0
    set rec(rsrvd3) " "
    set rec(draft_flag) "N"
    set rec(cp_date) [string range $CUR_JULIAN_DATE 1 4]
    set rec(rec_fmt) "DC"
    set rec(rev_flag) " "
    set rec(rsrvd4) 0
    set rec(tran_count) [expr $SUB_BATCH_NUM_TRANS - 1]
    set rec(net_amount) [expr abs($SUB_BATCH_NET_AMOUNT)]

    if {$SUB_BATCH_NET_AMOUNT < 0} {
        set rec(net_sign) "CR"
    } else {
        set rec(net_sign) "  "
    }
    set rec(tcr_count) $SUB_BATCH_NUM_TCR
    set rec(gross_amt) $SUB_BATCH_GROSS_AMOUNT
    set rec(secondary_amt) 0
    set rec(rsrvd5) " "
    set rec(batch_key) [format "%08d" $FILE_NUM][format "%05d" $FILE_NUM_TCR]
    set rec(rec_type) 3
    set rec(reimburse_attr) "0"

    write_tc_tcq_tcn_rt TEMP_FILE rec

#    incr FILE_NUM_TCR
#    incr FILE_NUM_TRANS
    incr BATCH_NUM

};# end write_sub_batch_trailer



proc init_sub_batch_variables {}  {
    global SUB_BATCH_NUM_TRANS SUB_BATCH_NUM_MONEY_TRANS SUB_BATCH_NUM_TCR SUB_BATCH_NET_AMOUNT SUB_BATCH_GROSS_AMOUNT FLAG

    set SUB_BATCH_NUM_TRANS 0
    set SUB_BATCH_NUM_MONEY_TRANS 0
    set SUB_BATCH_NUM_TCR 0
    set SUB_BATCH_NET_AMOUNT 0
    set SUB_BATCH_GROSS_AMOUNT 0
    set FLAG X

};# end init_sub_batch_variables



proc init_batch_variables {}  {
    global BATCH_NUM_TRANS BATCH_NUM_MONEY_TRANS BATCH_NUM_TCR BATCH_NET_AMOUNT

    set BATCH_NUM_TRANS 0
    set BATCH_NUM_MONEY_TRANS 0
    set BATCH_NUM_TCR 0
    set BATCH_TOTAL_AMOUNT 0
};# end init_batch_variables



proc write_batch_trailer {} {
    global CUR_JULIAN_DATE BATCH_NUM_MONEY_TRANS BATCH_NUM BATCH_NUM_TCR BATCH_NUM_TRANS BATCH_TOTAL_AMOUNT TEMP_FILE PROCESSING_BIN

    set rec(tc) 91
    set rec(tcq) 0
    set rec(tcn) 0
    set rec(bin) $PROCESSING_BIN
    set rec(proc_jdate) $CUR_JULIAN_DATE
    set rec(dest_amount) 0
#    set rec(num_money_trans) $BATCH_NUM_MONEY_TRANS
    set rec(num_money_trans) 0
    set rec(batch_num) [expr $BATCH_NUM - 1]
    set rec(num_tcr) $BATCH_NUM_TCR
    set rec(batch_id) " "
    set rec(num_trans) $BATCH_NUM_TRANS
    set rec(src_amount) $BATCH_TOTAL_AMOUNT
    set rec(rsrvd1) 0
    set rec(rsrvd2) 0
    set rec(rsrvd3) 0
    set rec(rsrvd4) 0
    set rec(rsrvd5) 0
    set rec(rsrvd6) " "

    write_tc TEMP_FILE rec
};# end write_batch_trailer




proc write_file_trailer {} {
    global CUR_JULIAN_DATE FILE_NUM_MONEY_TRANS BATCH_NUM FILE_NUM_TCR FILE_NUM_TRANS FILE_TOTAL_AMOUNT OUTPUT_FILE PROCESSING_BIN

    set rec(tc) 92
    set rec(tcq) 0
    set rec(tcn) 0
    set rec(bin) $PROCESSING_BIN
    set rec(proc_jdate) $CUR_JULIAN_DATE
    set rec(dest_amount) 0
#    set rec(num_money_trans) $FILE_NUM_MONEY_TRANS
    set rec(num_money_trans) 0
    set rec(batch_num) [expr $BATCH_NUM - 1]
    set rec(num_tcr) $FILE_NUM_TCR
    set rec(batch_id) " "
    set rec(num_trans) $FILE_NUM_TRANS
    set rec(src_amount) $FILE_TOTAL_AMOUNT
    set rec(rsrvd1) 0
    set rec(rsrvd2) 0
    set rec(rsrvd3) 0
    set rec(rsrvd4) 0
    set rec(rsrvd5) 0
    set rec(rsrvd6) " "

    write_tc OUTPUT_FILE rec
};# end write_file_trailer




########################################
# connect_to_db
#   connect to the oracle databse
########################################
proc connect_to_db {} {
    global DB_LOGON_HANDLE DB_CONNECT_HANDLE mbody mbody_c sysinfo mailfromlist msubj_c mailtolist authdb
    if {[catch {set DB_LOGON_HANDLE [oralogon teihost/quikdraw@$authdb]} result] } {
        puts "Encountered error $result while trying to connect to DB auth"
        set mbody "Encountered error $result while trying to connect to DB auth"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db

proc connect_to_db1 {} {
    global DB_LOGON_HANDLE1 DB_CONNECT_HANDLE1 mbody mbody_c sysinfo mailfromlist msubj_c mailtolist clrdb
    if {[catch {set DB_LOGON_HANDLE1 [oralogon masclr/masclr@$clrdb]} result] } {
        puts "Encountered error $result while trying to connect to DB masclr"
        set mbody "Encountered error $result while trying to connect to DB maasclr"
        exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
        exit 1
    }
};# end connect_to_db1



########################################
# close_db
#   close our connection to the database
########################################
proc close_db {} {
    global DB_LOGON_HANDLE DB_CONNECT_HANDLE
    if {[catch {oralogoff $DB_LOGON_HANDLE} result]} {
    }
};# end close_db

proc close_db1 {} {
    global DB_LOGON_HANDLE1 DB_CONNECT_HANDLE1
    if {[catch {oralogoff $DB_LOGON_HANDLE1} result]} {
    }
};# end close_db1

########################################
# load_array
#   takes the row returned from an orafetch and loads it into an array
#   based opon the column names in the result
########################################
proc load_array {aname str lst} {
    upvar $aname a

    for {set i 0} {$i < [llength $str]} { incr i} {
        set a([string tolower [lindex $lst $i]]) [lindex $str $i]
    }
};# end load_array



########################################
# get_from_capture
#   get a rows from capture until we need to send in an auth and send it
#   in
########################################
proc get_from_capture {m} {
    upvar $m merchant
    set x {}
    global CAPTURE_COLLIST CAPTURE_C HOST_ID TRANSACTIONS STATS
    global SWITCHES UPDATE_C SETTLE_DATE FLAGS tranhistory_arn OD4 TABLE_NAME
    # keep going until we either run out of rows or until we find one that
    # needs to be reauthed

#    set x [orafetch $CAPTURE_C]
        orafetch $CAPTURE_C -datavariable x

    if {[string equal $x {}]} {
        return 0
    }

    load_array capture $x $CAPTURE_COLLIST
    set OD4 $capture(other_data4)
#    puts "  Found one"
    make_b2lines capture merchant
    if {$FLAGS(-test) == 0  && $TABLE_NAME == "SETTLEMENT"} {
        #puts "$FLAGS(-test) == 0  || $TABLE_NAME == SETTLEMENT :: $tranhistory_arn"
        orasql $UPDATE_C "update $TABLE_NAME set status = \'SET\', SETTLE_DATE =\'$SETTLE_DATE\', ARN = \'$tranhistory_arn\' where rowid = \'$capture(rowid)\'"
    }
    return 1

};# end get_from_capture



########
# MAIN #
########
if {$argc != 4} {
        puts "Usage: tc57_maker.tcl FILENAME_PREFIX MMSN_LIST VISA_BIN MC_BIN"
        puts "FILENAME_PREFIX is formatted as INSTITUTION_NUM.TC57.  Sequence number will be appended."
        puts "MMSN_LIST is a list of Master_Merchant ShortNames to be processed for this file."
        puts "VISA BIN is the number to be used as the Source/Destination Bin for Visa transactions for this file."
        puts "MC_BIN is the number to be used as the Source/Destination Bin for Mastercard transactions for this file.\n\n"
        exit 1
}

set tcl_precision 17

# get and bump the batch number
set file_num_file [open "file_num.dat" "r+"]
gets $file_num_file FILE_NUM
seek $file_num_file 0 start
if {$FILE_NUM >= 999} {
    puts $file_num_file 1
} else {
    puts $file_num_file [expr $FILE_NUM + 1]

}
close $file_num_file
puts "Using file seq num: $FILE_NUM"
#set shortname [lindex $argv 1]

set TABLE_NAME [lindex $argv 2]
set run_type "SEEK"

if {$TABLE_NAME == "" || $TABLE_NAME == "NORMAL"} {
  set TABLE_NAME "SETTLEMENT"
  set run_type "NORMAL"
}
if {$TABLE_NAME == "FRAUD" } {
  set TABLE_NAME "FRAUD"
  set run_type "FRAUD"
}
if {$TABLE_NAME == "AUTH" } {
  set TABLE_NAME "TRANSACTION"
  set run_type "AUTH"
}
if {$TABLE_NAME == "SETTLEMENT"} {
  set filename "[lindex $argv 0].[format %03d $FILE_NUM]"
}
if {$TABLE_NAME == "FRAUD"} {
  set filename "[lindex $argv 0].[format %03d $FILE_NUM].fraud"
}
if {$TABLE_NAME == "TRANSACTION"} {
  set filename "[lindex $argv 0].[format %03d $FILE_NUM]"
}

set INSTITUTION_ID [lindex $argv 3]
puts $INSTITUTION_ID



set FLAGS(-test) 0
#set FLAGS(-test) 1
#set FLAGS(-lf) 0
set FLAGS(-lf) 1

set shortname {}

foreach arg [lindex $argv 1] {
    lappend shortname $arg
}

puts $shortname


#set filename b2[clock seconds].out
set OUTPUT_FILE [open $filename w]


connect_to_db
connect_to_db1


if { [ catch {
    set merchant_c [oraopen $DB_LOGON_HANDLE]
    set CAPTURE_C [oraopen $DB_LOGON_HANDLE]
    set terminal_c [oraopen $DB_LOGON_HANDLE]
    set tran_c [oraopen $DB_LOGON_HANDLE]
    set UPDATE_C [oraopen $DB_LOGON_HANDLE]
    set EXT_CRSR [oraopen $DB_LOGON_HANDLE]
    set TEMP_CRSR [oraopen $DB_LOGON_HANDLE]
    set temp_crsr1 [oraopen $DB_LOGON_HANDLE1]
    set temp_crsr2 [oraopen $DB_LOGON_HANDLE1]
} result ] } {
    puts "Error $result while creating db handles"
    exit 1
}
if {[llength $shortname] == 0} {
    puts "no shortname given"
    exit
} else  {
    set shortname2 {}
    set mid_query "select mid from ENTITY_TO_AUTH where FILE_GROUP_ID = '$shortname' and status = 'A'"
    orasql $temp_crsr1 $mid_query
    set first 1
    while {[orafetch $temp_crsr1 -dataarray q -indexbyname] != 1403 } {
        if {$first} {
            set shortname2 "\'$q(MID)\'"
            set first 0
        } else {
            append shortname2 ", \'$q(MID)\'"
        }
    }

}



set TZ_OFFSET [expr 3600 * 9]

set cur_local_time [clock seconds ]
#set CUR_SET_TIME [expr $cur_local_time + $TZ_OFFSET]
set CUR_SET_TIME $cur_local_time

#set CUR_JULIAN_DATE [clock format $CUR_SET_TIME -format "%y%j" -gmt true]
set CUR_JULIAN_DATE [clock format $CUR_SET_TIME -format "%y%j"]
#set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j" -gmt true] 1 4]
set CUR_JULIAN_DATEX [string range [clock format $CUR_SET_TIME -format "%y%j"] 1 4]

set CUR_PID [pid]
set temp_filename "tc57.$CUR_PID.tmp"

write_file_header

#if {$FLAGS(-lf) == 1} {
#    puts $OUTPUT_FILE {}
#}

set SETTLE_DATE [clock format $cur_local_time -format "%Y%m%d%H%M%S"]

set sql1 "select
            m.mid,
            m.long_name,
            m.address_1,
            m.city,
            m.state,
            m.zip,
            n.country,
            m.cust_service,
            m.phone_no,
            m.sic_code,
            q.bin_number,
            m.visa_id,
            m.mastercard_id,
            m.discover_id,
            m.amex_se_no,
	    m.settle_visa,
            m.settle_master_card,
            m.settle_discover,
            m.settle_amex
         from merchant m,
              merchant_addenda_rt n,
              master_merchant q
         where  m.mid = n.mid and m.mmid = q.mmid and m.mid in ($shortname2)  order by m.mid"


#puts $sql1
#puts $FLAGS(-test)
#puts "\$sql1 is <$sql1>"
  if {$TABLE_NAME == "SETTLEMENT" } {
    set card_list {MC VS DS DB}
  } else {
    set card_list {MC VS DS AX}
  }
foreach cardtype $card_list {
puts $card_list
orasql $merchant_c $sql1

set merchant_collist {}
foreach i [oracols $merchant_c] {
    lappend merchant_collist [string tolower $i]
}

set x ""
while {[set err [orafetch $merchant_c -datavariable x]] != 1403 } {
    load_array merchant $x $merchant_collist
    init_sub_batch_variables
    set merc_tran_count 0
    set batch_header 0
    set adate "[clock format [ clock scan "-1 day" ] -format %Y%m%d]000000"
    set sdate "[clock format [ clock scan "-0 day" ] -format %Y%m%d]000000"
    if {$TABLE_NAME == "TRANSACTION"} {
      set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and authdatetime >= '$adate' and  authdatetime < '$sdate'"
    } else {
      #puts $cardtype
      if {$cardtype == "DS"} {
        set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and mid in (select mid from merchant where settle_discover = 'JTPY')"
      }
      if {$cardtype == "VS"} {
        set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and mid in (select mid from merchant where settle_visa = 'JTPY')"
      }
      if {$cardtype == "MC"} {
        set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and mid in (select mid from merchant where settle_master_card = 'JTPY')"
      }
      if {$cardtype == "DB"} {
        set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype'"
      }
      #puts $criteria
    }
    while {$merc_tran_count == 0} {
#        puts "select count(1) \"COUNT\" $criteria"
        orasql $EXT_CRSR "select count(1) \"COUNT\" $criteria"
#        set merc_tran_count [orafetch $EXT_CRSR]
        orafetch $EXT_CRSR -datavariable  merc_tran_count
#        puts "merc_tran_count for $merchant(mid): $merc_tran_count"

    set query_string "select visa_bin,mc_bin,entity_id from ENTITY_TO_AUTH where mid  = '$merchant(mid)' and status = 'A' and institution_id = '$INSTITUTION_ID'"
    #set query_string "select visa_bin,mc_bin from ENTITY_TO_AUTH where entity_id = '$merchant(visa_id)' and status = 'A'"
    orasql $temp_crsr1 $query_string
    orafetch $temp_crsr1 -dataarray q -indexbyname
#    puts "$merchant(mid) : VS $q(VISA_BIN) : MC $q(MC_BIN)"
    set VISA_DEST_BIN $q(VISA_BIN)
    set VISA_SOURCE_BIN $q(VISA_BIN)
    set MC_DEST_BIN $q(MC_BIN)
    set MC_SOURCE_BIN $q(MC_BIN)
    set ENTITY_ID $q(ENTITY_ID)

        if {$merc_tran_count == 0} {
            if {[set err [orafetch $merchant_c -datavariable x]] != 1403 } {
                load_array merchant $x $merchant_collist
                if {$TABLE_NAME == "TRANSACTION"} {
                  set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and authdatetime >= '$adate' and  authdatetime < '$sdate'"
                } else {
                  if {$cardtype == "DS"} {
                    set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and mid in (select mid from merchant where settle_discover = 'JTPY')"
                  }
                  if {$cardtype == "VS"} {
                    set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and mid in (select mid from merchant where settle_visa = 'JTPY')"
                  }
                  if {$cardtype == "MC"} {
                    set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype' and mid in (select mid from merchant where settle_master_card = 'JTPY')"
                  }
                  if {$cardtype == "DB"} {
                    set criteria "from $TABLE_NAME where mid = '$merchant(mid)' and card_type = '$cardtype'"
                  }

                }
                #puts $criteria
            } else {
                set merc_tran_count -1
            }
        }
    }

    if {$merc_tran_count > 0} {
#            puts $merchant(mid)
#            puts $merchant(long_name)
#            puts $merchant(address_1)
#            puts $merchant(city)
#            puts $merchant(state)
#            puts $merchant(zip)
#            puts $merchant(country)
#            puts $merchant(cust_service)
#            puts $merchant(sic_code)
#            puts $merchant(bin_number)
#            puts $merchant(visa_id)

        set TEMP_FILE [open $temp_filename w]
        set sql "select unique rowid"
        foreach i $flist {
            set sql "$sql, [lindex $i 0]"
        }

#    puts "Searching for transactions for merchant $merchant(mid)"
        set sql "$sql $criteria"


        orasql $CAPTURE_C $sql
        set CAPTURE_COLLIST {}
        foreach i [oracols $CAPTURE_C] {
            lappend CAPTURE_COLLIST [string tolower $i]
        }

        set still_going 1


        switch $cardtype {
            "MC" {set DEST_BIN $MC_DEST_BIN
                  set SOURCE_BIN $MC_SOURCE_BIN}
            "VS" {set DEST_BIN $VISA_DEST_BIN
                  set SOURCE_BIN $VISA_SOURCE_BIN}
            "DS" {set DEST_BIN $VISA_DEST_BIN
                  set SOURCE_BIN $VISA_SOURCE_BIN}
            "DB" {set DEST_BIN 220202
                  set SOURCE_BIN 220202}
            default
                 {set DEST_BIN "000000"
                  set SOURCE_BIN "000000"
                 }
}

        set dynam 0
        while {$still_going } {

           set still_going [get_from_capture merchant]
            if {$still_going} {
              orasql $temp_crsr2 "select DYNAMIC_DESC_FLAG from entity_to_auth where mid = '$merchant(mid)' and status = 'A' and institution_id = '$INSTITUTION_ID'"
              orafetch $temp_crsr2 -dataarray z -indexbyname
              if {$z(DYNAMIC_DESC_FLAG) == "Y"} {
 #               set dynam 1
 #               dynamic_descriptor merchant rec
              }
           }
    }

# we only put a batch trailer if there were TRANSACTIONS
#      if {$dynam == 0} {
        if {$SUB_BATCH_NUM_TCR != 0} {
            incr SUB_BATCH_NUM_TCR 3
            incr SUB_BATCH_NUM_TRANS
            incr BATCH_NUM_TCR 3
            incr BATCH_NUM_TRANS 3
            incr FILE_NUM_TCR 3
            incr FILE_NUM_TRANS 3
            write_sub_batch_trailer
        }

        incr BATCH_NUM_TCR
        incr BATCH_NUM_TRANS
        incr FILE_NUM_TCR
        incr FILE_NUM_TRANS
        write_batch_trailer
        init_batch_variables

        close $TEMP_FILE
        write_batch_headers merchant rec
# attach temp file to end of output file
        set TEMP_FILE [open $temp_filename r]
        while {[set line [read $TEMP_FILE $LINE_SIZE]] != {} } {
            puts -nonewline $OUTPUT_FILE $line
        }
        close $TEMP_FILE
        init_sub_batch_variables
#      }
# 
    }

}
}

incr FILE_NUM_TCR
incr FILE_NUM_TRANS
write_file_trailer
close $OUTPUT_FILE
file delete $temp_filename

#catch {exec dd if=$filename conv=ebcdic of=$filename.ebc} foo
# catch {exec ./encrypt_file.tcl $filename.ebc $filename.ebc.gpg NEXTGATE} foo



#catch {exec expect sendb2.exp $filename.ebc} foo
#puts $foo
if {$FLAGS(-test) == 0 && $TABLE_NAME == "SETTLEMENT"} {
    puts "$TABLE_NAME : $FLAGS(-test)"

    orasql $UPDATE_C "INSERT INTO TRANHISTORY
                      (MID,TID,TRANSACTION_ID,REQUEST_TYPE,TRANSACTION_TYPE,CARDNUM,
                       EXP_DATE,AMOUNT,ORIG_AMOUNT,INCR_AMOUNT,FEE_AMOUNT,TAX_AMOUNT,
                       PROCESS_CODE,STATUS,AUTHDATETIME,AUTH_TIMER,AUTH_CODE,AUTH_SOURCE,
                       ACTION_CODE,SHIPDATETIME,TICKET_NO,NETWORK_ID,ADDENDUM_BITMAP,
                       CAPTURE,POS_ENTRY,CARD_ID_METHOD,RETRIEVAL_NO,AVS_RESPONSE,ACI,
                       CPS_AUTH_ID,CPS_TRAN_ID,CPS_VALIDATION_CODE,CURRENCY_CODE,CLERK_ID,
                       SHIFT,HUB_FLAG,BILLING_TYPE,BATCH_NO,ITEM_NO,OTHER_DATA,SETTLE_DATE,
                       CARD_TYPE,CVV,PC_TYPE,CURRENCY_RATE,OTHER_DATA2,OTHER_DATA3,OTHER_DATA4,
                       ARN,MARKET_TYPE)
                      SELECT
                       MID,TID,TRANSACTION_ID,REQUEST_TYPE,TRANSACTION_TYPE,CARDNUM,
                       EXP_DATE,AMOUNT,ORIG_AMOUNT,INCR_AMOUNT,FEE_AMOUNT,TAX_AMOUNT,
                       PROCESS_CODE,STATUS,AUTHDATETIME,AUTH_TIMER,AUTH_CODE,AUTH_SOURCE,
                       ACTION_CODE,SHIPDATETIME,TICKET_NO,NETWORK_ID,ADDENDUM_BITMAP,
                       CAPTURE,POS_ENTRY,CARD_ID_METHOD,RETRIEVAL_NO,AVS_RESPONSE,ACI,
                       CPS_AUTH_ID,CPS_TRAN_ID,CPS_VALIDATION_CODE,CURRENCY_CODE,CLERK_ID,
                       SHIFT,HUB_FLAG,BILLING_TYPE,BATCH_NO,ITEM_NO,OTHER_DATA,SETTLE_DATE,
                       CARD_TYPE,CVV,PC_TYPE,CURRENCY_RATE,OTHER_DATA2,OTHER_DATA3,OTHER_DATA4,
                       ARN,MARKET_TYPE
  FROM SETTLEMENT
      WHERE (STATUS='SET') "

    orasql $UPDATE_C "DELETE FROM SETTLEMENT WHERE STATUS='SET'"

}


oracommit $DB_LOGON_HANDLE

oraclose $merchant_c;
oraclose $CAPTURE_C
oraclose $TEMP_CRSR

puts "-----$run_type"

puts "tc57_xfer.tcl $filename $VISA_SOURCE_BIN"

if {$run_type == "" || $run_type == "NORMAL"} {

        catch {exec tc57_xfer.tcl $filename $VISA_SOURCE_BIN >> LOG/tc57_xfer.log} result

        if {$result != ""} {
                set mbody "Script tc57_xfer.tcl exited abnormally please review log"
                exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
                catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
        }
}


if {$run_type == "AUTH"} {

        catch {exec auth_xfer.tcl $filename $VISA_SOURCE_BIN >> LOG/auth_xfer.log} result

        if {$result != ""} {
                set mbody "Script auth_xfer.tcl exited abnormally please review log \n $result"
                exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
                catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
        }
}

if {$run_type == "FRAUD"} {

        catch {exec fraud_xfer.tcl $filename $VISA_SOURCE_BIN >> LOG/fraud_xfer.log} result

        if {$result != ""} {
                set mbody "Script fraud_xfer.tcl exited abnormally please review log"
                exec echo "$mbody_c $sysinfo $mbody" | mailx -r $mailfromlist -s "$msubj_c" $mailtolist
                catch {open /clearing/filemgr/process.stop {WRONLY CREAT}} fileid
        }
}



oralogoff $DB_LOGON_HANDLE
puts "END TC57 File"
