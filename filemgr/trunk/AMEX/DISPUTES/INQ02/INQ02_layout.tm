#!/usr/local/bin/tclsh

# $Id: INQ02_layout.tm 2853 2015-04-16 20:13:31Z jkruse $

if { [info exists AMEX_INQ02_LAYOUT_LOADED] } {
    return
}

namespace eval INQ02 {
    namespace export header_rec
    namespace export detail_front
    namespace export detail_rec
    namespace export trailer_rec
    namespace export detail_fraud

    ##############################################################################
    #
    # set the structure for file header
    # <field#> <field_name> <length> <data type>
    # <start position> <end position>
    # <default value> <database column> <format>
    ##############################################################################

    #   Field   Field_Name                  Len Typ Pos     End    Dflt             Col                         Fmt

    # 5.1     Inquiry Header Record

    set header_rec {
        1  RECORD_TYPE                      1   a   1       1       {H}             {}                           {}
        2  APPLICATION_SYSTEM_CODE          2   a   2       3       {"01"}          {}                           {}
        3  FILE_TYPE_CODE                   2   a   4       5       {"01"}          {}                           {}
        4  FILE_CREATION_DATE               8   d   6       13      {}              {}                           {YYYYMMDD}
        5  FILLER_1                         6   s   14      19      {}              {}                           {}
        6  FILE_SEQUENCE_NUMBER             2   a   20      21      {}              {}                           {}
        7  FILLER_2                         80  s   22      101     {}              {}                           {}
        8  SAID                             6   a   102     107     {}              {}                           {}
        9  DATATYPE                         5   a   108     112     {INQ02}         {}                           {}
        10 STARS_CREATION_DATE              7   d   113     119     {}              {}                           {YYYYMMDD}
        11 FILE_CREATION_TIME               7   a   120     126     {}              {}                           {"0HH24MISS"}
        12 STARS_FILE_SEQUENCE_NUMBER       3   a   127     129     {}              {}                           {}
        13 FILLER_3                         948 s   130     1077    {}              {}                           {}
    }

    # 5.2 Inquiry Detail Record (Fields 1-41)

    set detail_front {
        1  DTL_REC_TYPE                     1   a   1       1       {D}             {}                           {}
        2  REC_TYPE                         5   a   2       6       {INQ02}         {}                           {}
        3  CM_ACCT_NUMB                     15  a   7       21      {}              {}                           {}
        4  CURRENT_CASE_NUMBER              7   a   22      28      {}              {}                           {}
        5  AIRLINE_TKT_NUM                  13  a   29      41      {}              {}                           {}
        6  FILLER_1                         6   s   42      47      {}              {}                           {}
        7  AMEX_PROCESS_DATE                6   d   48      53      {}              {}                           {YYMMDD}
        8  AMEX_ID                          7   a   54      60      {}              {}                           {}
        9  CASE_TYPE                        5   a   61      65      {}              {}                           {}
        10 SE_REPLY_BY_DATE                 6   d   66      71      {}              {}                           {YYMMDD}
        11 LOC_NUMB                         6   a   72      77      {}              {}                           {}
        12 DATE_OF_CHARGE                   6   d   78      83      {}              {}                           {YYMMDD}
        13 CM_NAME1                         30  a   84      113     {}              {}                           {}
        14 CM_NAME2                         30  a   114     143     {}              {}                           {}
        15 SELLER_ID                        20  a   144     163     {}              {}                           {}
        16 FILLER_2                         10  s   164     173     {}              {}                           {}
        17 FILLER_3                         30  s   174     203     {}              {}                           {}
        18 CM_CITY_STATE                    30  a   204     233     {}              {}                           {}
        19 CM_ZIP                           9   a   234     242     {}              {}                           {}
        20 SE_NUMB                          10  a   243     252     {}              {}                           {}
        21 REASON_CODE                      3   a   253     255     {}              {}                           {}
        22 FOLLOW_UP_REASON_CODE            2   a   256     257     {}              {}                           {}
        23 FOREIGN_AMT                      15  a   258     272     {}              {}                           {}
        24 FILLER_4                         3   s   273     275     {}              {}                           {}
        25 SUPP_TO_FOLLOW                   1   a   276     276     {}              {}                           {}
        26 CURRENT_ACTION_NUMBER            2   a   277     278     {}              {}                           {}
        27 CM_FIRST_NAME_1                  12  a   279     290     {}              {}                           {}
        28 CM_MIDDLE_NAME_1                 12  a   291     302     {}              {}                           {}
        29 CM_LAST_NAME_1                   20  a   303     322     {}              {}                           {}
        30 CM_ORIG_ACCT_NUM                 15  a   323     337     {}              {}                           {}
        31 CM_ORIG_NAME                     30  a   338     367     {}              {}                           {}
        32 NOTE1                            66  a   368     433     {}              {}                           {}
        33 NOTE2                            78  a   434     511     {}              {}                           {}
        34 NOTE3                            60  a   512     571     {}              {}                           {}
        35 CM_ORIG_FIRST_NAME               12  a   572     583     {}              {}                           {}
        36 CM_ORIG_MIDDLE_NAME              12  a   584     595     {}              {}                           {}
        37 CM_ORIG_LAST_NAME                20  a   596     615     {}              {}                           {}
        38 NOTE4                            60  a   616     675     {}              {}                           {}
        39 NOTE5                            60  a   676     735     {}              {}                           {}
        40 NOTE6                            60  a   736     795     {}              {}                           {}
        41 NOTE7                            60  a   796     855     {}              {}                           {}
    }

    # 5.3 AIRDS Case Type Detail Record     # AIRDS = Airline Credit Requested

    set detail_rec(AIRDS) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 SOC_INVOICE_NUMBER               6   a   886     891     {}              {}                           {}
        46 SEQUENCE_INDICATOR               2   a   892     893     {}              {}                           {}
        47 PASSENGER_NAME                   20  a   894     913     {}              {}                           {}
        48 PASSENGER_FIRST_NAME             12  a   914     925     {}              {}                           {}
        49 PASSENGER_MIDDLE_NAME            12  a   926     937     {}              {}                           {}
        50 PASSENGER_LAST_NAME              20  a   938     957     {}              {}                           {}
        51 SE_PROCESS_DATE                  3   a   958     960     {}              {}                           {DDD}
        52 FILLER_5                         62  s   961     1022    {}              {}                           {}
        53 IND_FORM_CODE                    2   a   1023    1024    {}              {}                           {}
        54 IND_REF_NUMBER                   30  a   1025    1054    {}              {}                           {}
        55 FILLER_6                         3   s   1055    1057    {}              {}                           {}
        56 LOC_REF_NUMBER                   15  a   1058    1072    {}              {}                           {}
        57 FILLER_7                         2   s   1073    1074    {}              {}                           {}
        58 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        59 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.4 AIRLT Case Type Detail Record     # AIRLT = Airline Lost/Stolen Ticket

    set detail_rec(AIRLT) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 SOC_INVOICE_NUMBER               6   a   886     891     {}              {}                           {}
        46 AL_SEQUENCE_NUMBER               2   a   892     893     {}              {}                           {}
        47 PASSENGER_NAME                   20  a   894     913     {}              {}                           {}
        48 PASSENGER_FIRST_NAME             12  a   914     925     {}              {}                           {}
        49 PASSENGER_MIDDLE_NAME            12  a   926     937     {}              {}                           {}
        50 PASSENGER_LAST_NAME              20  a   938     957     {}              {}                           {}
        51 SE_PROCESS_DATE                  3   a   958     960     {}              {}                           {}
        52 LTA_FILED_DATE                   6   d   961     966     {}              {}                           {YYMMDD}
        53 FILLER_5                         56  s   967     1022    {}              {}                           {}
        54 IND_FORM_CODE                    2   a   1023    1024    {}              {}                           {}
        55 IND_REF_NUMBER                   30  a   1025    1054    {}              {}                           {}
        56 FILLER_6                         3   s   1055    1057    {}              {}                           {}
        57 LOC_REF_NUMBER                   15  a   1058    1072    {}              {}                           {}
        58 FILLER_7                         2   s   1073    1074    {}              {}                           {}
        59 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        60 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.5 AIRRT Case Type Detail Record     # AIRRT = Airline Returned Ticket

    set detail_rec(AIRRT) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 SOC_INVOICE_NUMBER               6   a   886     891     {}              {}                           {}
        46 AL_SEQUENCE_NUMBER               2   a   892     893     {}              {}                           {}
        47 PASSENGER_NAME                   20  a   894     913     {}              {}                           {}
        48 PASSENGER_FIRST_NAME             12  a   914     925     {}              {}                           {}
        49 PASSENGER_MIDDLE_NAME            12  a   926     937     {}              {}                           {}
        50 PASSENGER_LAST_NAME              20  a   938     957     {}              {}                           {}
        51 SE_PROCESS_DATE                  3   a   958     960     {}              {}                           {DDD}
        52 RETURN_DATE                      6   d   961     966     {}              {}                           {YYMMDD}
        53 CREDIT_RECEIPT_NUMBER            15  a   967     981     {}              {}                           {}
        54 RETURN_TO_NAME                   24  a   982     1005    {}              {}                           {}
        55 RETURN_TO_STREET                 17  a   1006    1022    {}              {}                           {}
        56 IND_FORM_CODE                    2   a   1023    1024    {}              {}                           {}
        57 IND_REF_NUMBER                   30  a   1025    1054    {}              {}                           {}
        58 FILLER_5                         3   s   1055    1057    {}              {}                           {}
        59 LOC_REF_NUMBER                   15  a   1058    1072    {}              {}                           {}
        60 FILLER_6                         2   s   1073    1074    {}              {}                           {}
        61 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        62 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.6 AIRTB Case Type Detail Record     # AIRTB = Airline Support of Charge

    set detail_rec(AIRTB) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 SOC_INVOICE_NUMBER               6   a   886     891     {}              {}                           {}
        46 AL_SEQUENCE_NUMBER               2   a   892     893     {}              {}                           {}
        47 PASSENGER_NAME                   20  a   894     913     {}              {}                           {}
        48 PASSENGER_FIRST_NAME             12  a   914     925     {}              {}                           {}
        49 PASSENGER_MIDDLE_NAME            12  a   926     937     {}              {}                           {}
        50 PASSENGER_LAST_NAME              20  a   938     957     {}              {}                           {}
        51 FILLER_5                         65  s   958     1022    {}              {}                           {}
        52 IND_FORM_CODE                    2   a   1023    1024    {}              {}                           {}
        53 IND_REF_NUMBER                   30  a   1025    1054    {}              {}                           {}
        54 FILLER_6                         3   s   1055    1057    {}              {}                           {}
        55 LOC_REF_NUMBER                   15  a   1058    1072    {}              {}                           {}
        56 FILLER_7                         2   s   1073    1074    {}              {}                           {}
        57 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        58 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.7 AREXS Case Type Detail Record     # AREXS = Reservation/Cancellation

    set detail_rec(AREXS) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 CARD_DEPOSIT                     1   a   886     886     {}              {}                           {}
        46 CANC_NUM                         20  a   887     906     {}              {}                           {}
        47 ASSURED_RESERVATION              1   a   907     907     {}              {}                           {}
        48 RES_CANCELLED                    1   a   908     908     {}              {}                           {}
        49 RES_CANCELLED_DATE               6   d   909     914     {}              {}                           {YYMMDD}
        50 RES_CANCELLED_TIME               8   asp 915     922     {}              {}                           {"HH24:MI:SS"}
        51 CANCEL_ZONE                      1   a   923     923     {}              {}                           {}
        52 RESERVATION_MADE_FOR             6   d   924     929     {}              {}                           {YYMMDD}
        53 RESERVATION_LOCATION             20  a   930     949     {}              {}                           {}
        54 RESERVATION_MADE_ON              6   d   950     955     {}              {}                           {YYMMDD}
        55 FOLIO_REF                        18  a   956     973     {}              {}                           {}
        56 FILLER_5                         49  s   974     1022    {}              {}                           {}
        57 IND_FORM_CODE                    2   a   1023    1024    {}              {}                           {}
        58 IND_REF_NUMBER                   30  a   1025    1054    {}              {}                           {}
        59 FILLER_6                         3   s   1055    1057    {}              {}                           {}
        60 LOC_REF_NUMBER                   15  a   1058    1072    {}              {}                           {}
        61 FILLER_7                         2   s   1073    1074    {}              {}                           {}
        62 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        63 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.8 CARRD Case Type Detail Record     # CARRD = Car Rental

    set detail_rec(CARRD) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 SOC_INVOICE_NUMBER               6   a   886     891     {}              {}                           {}
        46 RENTAL_AGREEMENT_NEEDED          1   a   892     892     {}              {}                           {}
        47 RENTAL_AGREEMENT_NUMBER          18  a   893     910     {}              {}                           {}
        48 FILLER_5                         164 s   911     1074    {}              {}                           {}
        49 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        50 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # CRCDW = Collision Damage Waiver Liability

    set detail_rec(CRCDW) $detail_rec(CARRD)

    # 5.9 GSDIS Case Type Detail Record     # GSDIS = Goods/Services

    set detail_rec(GSDIS) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 FILLER_5                         18  s   886     903     {}              {}                           {}
        46 IND_FORM_CODE                    2   a   904     905     {}              {}                           {}
        47 IND_REF_NUMBER                   30  a   906     935     {}              {}                           {}
        48 FILLER_6                         3   s   936     938     {}              {}                           {}
        49 LOC_REF_NUMBER                   15  a   939     953     {}              {}                           {}
        50 FILLER_7                         121 s   954     1074    {}              {}                           {}
        51 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        52 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.10 NAXMG Case Type Detail Record    # NAXMG = Merchandise Not Received

    set detail_rec(NAXMG) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 MERCHANDISE_TYPE                 20  a   886     905     {}              {}                           {}
        46 MERCH_ORDER_NUM                  10  a   906     915     {}              {}                           {}
        47 FILLER_5                         107 s   916     1022    {}              {}                           {}
        48 IND_FORM_CODE                    2   a   1023    1024    {}              {}                           {}
        49 IND_REF_NUMBER                   30  a   1025    1054    {}              {}                           {}
        50 FILLER_6                         3   s   1055    1057    {}              {}                           {}
        51 LOC_REF_NUMBER                   15  a   1058    1072    {}              {}                           {}
        52 FILLER_7                         2   s   1073    1074    {}              {}                           {}
        53 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        54 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.11 NAXMR Case Type Detail Record    # NAXMR = Merchandise Returned

    set detail_rec(NAXMR) {
        42 CHARGE_AMOUNT                    9   n   856     864     {}              {}                           {}
        43 DISPUTE_AMOUNT                   9   n   865     873     {}              {}                           {}
        44 REFERENCE_NUMBER                 12  a   874     885     {}              {}                           {}
        45 MERCHANDISE_TYPE                 20  a   886     905     {}              {}                           {}
        46 MERCHANDISE_RETURNED             1   a   906     906     {}              {}                           {}
        47 CREDIT_REQUESTED                 1   a   907     907     {}              {}                           {}
        48 REPLACEMENT_REQUESTED            1   a   908     908     {}              {}                           {}
        49 RETURNED_NAME                    24  a   909     932     {}              {}                           {}
        50 RETURNED_DATE                    6   d   933     938     {}              {}                           {YYMMDD}
        51 RETURNED_HOW                     8   a   939     946     {}              {}                           {}
        52 RETURNED_REASON                  50  a   947     996     {}              {}                           {}
        53 STORE_CREDIT_RECEIVED            1   a   997     997     {}              {}                           {}
        54 CREDIT_RECEIPT_NUMBER            15  a   998     1012    {}              {}                           {}
        55 MERCH_ORDER_NUM                  10  a   1013    1022    {}              {}                           {}
        56 IND_FORM_CODE                    2   a   1023    1024    {}              {}                           {}
        57 IND_REF_NUMBER                   30  a   1025    1054    {}              {}                           {}
        58 FILLER_5                         3   s   1055    1057    {}              {}                           {}
        59 LOC_REF_NUMBER                   15  a   1058    1072    {}              {}                           {}
        60 FILLER_6                         2   s   1073    1074    {}              {}                           {}
        61 TRIUMPH_SEQ_NO                   2   a   1075    1076    {}              {}                           {}
        62 INQUIRY_MARK                     1   a   1077    1077    {}              {}                           {}
    }

    # 5.12 SEDIS Case Type Detail Record    # SEDIS = General Dispute

    set detail_rec(SEDIS) {
        42  CHARGE_AMOUNT                   9   n   856     864     {}              {}                           {}
        43  DISPUTE_AMOUNT                  9   n   865     873     {}              {}                           {}
        44  REFERENCE_NUMBER                12  a   874     885     {}              {}                           {}
        45  FOLIO_REF                       18  a   886     903     {}              {}                           {}
        46  IND_FORM_CODE                   2   a   904     905     {}              {}                           {}
        47  IND_REF_NUMBER                  30  a   906     935     {}              {}                           {}
        48  FILLER_1A                       3   s   936     938     {}              {}                           {}
        49  LOC_REF_NUMBER                  15  a   939     953     {}              {}                           {}
        50  FILLER_1B                       69  s   954     1022    {}              {}                           {}
        51  IND_FORM_CODE_2                 2   a   1023    1024    {}              {}                           {}
        52  IND_REF_NUMBER_2                30  a   1025    1054    {}              {}                           {}
        53  FILLER_2A                       3   s   1055    1057    {}              {}                           {}
        54  LOC_REF_NUMBER_2                15  a   1058    1072    {}              {}                           {}
        55  FILLER_2B                       2   s   1073    1074    {}              {}                           {}
        56  TRIUMPH_SEQ_NO                  2   a   1075    1076    {}              {}                           {}
        57  INQUIRY_MARK                    1   a   1077    1077    {}              {}                           {}
    }

    # FRAUD = Fraud Dispute

    set detail_rec(FRAUD) $detail_rec(SEDIS)

    # 5.13 Inquiry Trailer Record

    set trailer_rec {
        1   RECORD_TYPE                     1   a   1       1       {T}             {}                           {}
        2   APPLICATION_SYSTEM_CODE         2   a   2       3       {"01"}          {}                           {}
        3   FILE_TYPE_CODE                  2   a   4       5       {"01"}          {}                           {}
        4   FILE_CREATION_DATE              8   d   6       13      {}              {}                           {YYYYMMDD}
        5   FILLER_1                        13  s   14      26      {}              {}                           {}
        6   AMEX_TOTAL_RECORDS              9   n   27      35      {}              {}                           {}
        7   SE_TOTAL_RECORDS                9   n   36      44      {}              {}                           {}
        8   FILLER_2                        57  s   45      101     {}              {}                           {}
        9   SAID                            6   a   102     107     {}              {}                           {}
        10  DATATYPE                        5   a   108     112     {"INQ02"}       {}                           {}
        11  START_CREATION_DATE             7   d   113     119     {}              {}                           {YYYYMMDD}
        12  FILE_CREATION_TIME              7   a   120     126     {}              {}                           {"0HH24MISS"}
        13  START_FILE_SEQUENCE_NUMBER      3   a   127     129     {}              {}                           {}
        14  FILLER_3                        948 s   130     1077    {}              {}                           {}
    }

    #
    # For CASE_TYPE = “FRAUD”,
    # NOTE_1-7 may
    # be redefined.
    #
    #  Subfield Name                        Len         Pos     End

    #  NOTE_3

    set detail_fraud(NOTE_3) {
        1   CHARGE_AMOUNT                   10  a   512     521     {}              {}                           {}
        2   FILLER                          2   s   522     523     {}              {}                           {}
        3   DATE_OF_CHARGE                  6   a   524     529     {}              {}                           {}
        4   FILLER                          2   s   530     531     {}              {}                           {}
        5   REFERENCE_NUMBER                25  a   532     556     {}              {}                           {}
        6   FILLER                          15  s   557     571     {}              {}                           {}
    }

    #  NOTE_4

    set detail_fraud(NOTE_4) {
        1   CHARGE_AMOUNT                   10  a   616     625     {}              {}                           {}
        2   FILLER                          2   s   626     627     {}              {}                           {}
        3   DATE_OF_CHARGE                  6   a   628     633     {}              {}                           {}
        4   FILLER                          2   s   634     635     {}              {}                           {}
        5   REFERENCE_NUMBER                25  a   636     660     {}              {}                           {}
        6   FILLER                          15  s   661     675     {}              {}                           {}
    }

    #  NOTE_5

    set detail_fraud(NOTE_5) {
        1   CHARGE_AMOUNT                   10  a   676     685     {}              {}                           {}
        2   FILLER                          2   s   686     687     {}              {}                           {}
        3   DATE_OF_CHARGE                  6   a   688     693     {}              {}                           {}
        4   FILLER                          2   s   694     695     {}              {}                           {}
        5   REFERENCE_NUMBER                25  a   696     720     {}              {}                           {}
        6   FILLER                          15  s   721     735     {}              {}                           {}
    }

    #  NOTE_6

    set detail_fraud(NOTE_6) {
        1   CHARGE_AMOUNT                   10  a   736     745     {}              {}                           {}
        2   FILLER                          2   s   746     747     {}              {}                           {}
        3   DATE_OF_CHARGE                  6   a   748     753     {}              {}                           {}
        4   FILLER                          2   s   754     755     {}              {}                           {}
        5   REFERENCE_NUMBER                25  a   756     780     {}              {}                           {}
        6   FILLER                          15  s   781     795     {}              {}                           {}
    }

    #  NOTE_7

    set detail_fraud(NOTE_7) {
        1   CHARGE_AMOUNT                   10  a   796     805     {}              {}                           {}
        2   FILLER                          2   s   806     807     {}              {}                           {}
        3   DATE_OF_CHARGE                  6   a   808     813     {}              {}                           {}
        4   FILLER                          2   s   814     815     {}              {}                           {}
        5   REFERENCE_NUMBER                25  a   816     840     {}              {}                           {}
        6   FILLER                          15  s   841     855     {}              {}                           {}
    }

}

set AMEX_INQ02_LAYOUT_LOADED 1
