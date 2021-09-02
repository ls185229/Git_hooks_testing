#!/usr/local/bin/tclsh

# $Id: RESPN_layout_B.tm 2455 2013-10-22 17:16:38Z bjones $

if { [info exists AMEX_RESPN_LAYOUT_LOADED] } {
    return
}

namespace eval RESPN {
    namespace export header_rec
    namespace export detail_rec
    namespace export trailer_rec

    ############################################################################
    #
    # set the structure for file header
    # <field#> <field_name> <length> <data type> <start position> <end position>
    #
    ############################################################################

    #   Field   Field_Name          Len Typ Pos End Dflt    Col                 Fmt

    # Response Header Record

    set header_rec {
        1   RECORD_TYPE             1   a   1   1   {H}     {}                  {}
        2   APPLICATION_SYSTEM_CODE 2   a   2   3   {"01"}  {}                  {}
        3   FILE_TYPE_CODE          2   a   4   5   {"02"}  {}                  {}
        4   FILE_CREATION_DATE      8   a   6   13  {}      {}                  {YYYYMMDD}
        5   FILLER                  6   s   14  19  {}      {}                  {}
        6   FILLER                  2   s   20  21  {}      {}                  {}
        7   FILLER                  80  s   22  101 {}      {}                  {}
        8   SAID                    6   a   102 107 {}      {}                  {}
        9   DATATYPE                5   a   108 112 {RESPN} {}                  {}
        10  FILLER                  89  s   113 201 {}      {}                  {}
        11  CLIENT_AREA             100 a   202 301 {}      {}                  {}
        12  FILLER                  99  s   302 400 {}      {}                  {}
    }

    #     Response Detail Record 1

    set det_rec(1) {
        1   DTL_REC_TYPE            1   a   1   1   {D}     {}                  {}
        2   SEQ_NUMBER              2   a   2   3   {"01"}  {}                  {}
        3   CM_ACCT_NUMB            15  n   4   18  {}      {}                  {}
        4   CURRENT_CASE_NUMBER     7   a   19  25  {}      {}                  {}
        5   SE_NUMB                 10  n   26  35  {}      {}                  {}
        6   CM_ACCT_NUMB            15  n   36  50  {}      {}                  {}
        7   CM_NAME1                30  a   51  80  {}      {}                  {}
        8   CURRENT_CASE_NUMBER     7   a   81  87  {}      {}                  {}
        9   CURRENT_ACTION_NUMBER   2   a   88  89  {}      {}                  {}
        10  AMEX_ID                 7   a   90  96  {}      {}                  {}
        11  RESOLUTION_CODE         2   a   97  98  {}      {}                  {}
        12  DOLLAR_AMOUNT           9   n   99  107 {}      {}                  {}
        13  DATE_ACTION_TAKEN       8   a   108 115 {}      {}                  {YYYYMMDD}
        14  SUPPORT_SENT            1   a   116 116 {}      {}                  {}
        15  SE_TRACKING             40  a   117 156 {}      {}                  {}
        16  RESPONSE_EXPLANATION_1  132 a   157 288 {}      {DISPUTE_TEXT_AREA} {}
        17  REFERENCE_NUMBER        20  a   289 308 {}      {}                  {}
        18  TRIUMPH_AREA            47  a   309 355 {}      {TRIUMPH_SEQ_NO}    {}
        19  FILLER                  44  s   356 399 {}      {}                  {}
        20  INQUIRY_MARK            1   a   400 400 {}      {}                  {}
    }

    #     Response Detail Record 2

    set det_rec(2) {
        1   DTL_REC_TYPE            1   a   1   1   {D}     {}                  {}
        2   SEQ_NUMBER              2   a   2   3   {"02"}  {}                  {}
        3   CM_ACCT_NUMB            15  n   4   18  {}      {}                  {}
        4   CURRENT_CASE_NUMBER     7   a   19  25  {}      {}                  {}
        5   RESPONSE_EXPLANATION_2  253 a   26  278 {}      {DISPUTE_TEXT_AREA} {}
        6   FILLER                  121 s   279 399 {}      {}                  {}
        7   INQUIRY_MARK            1   a   400 400 {}      {}                  {}
    }

    #     Response Detail Record 3

    set det_rec(3) {
        1   DTL_REC_TYPE            1   a   1   1   {D}     {}                  {}
        2   SEQ_NUMBER              2   a   2   3   {"03"}  {}                  {}
        3   CM_ACCT_NUMB            15  n   4   18  {}      {}                  {}
        4   CURRENT_CASE_NUMBER     7   a   19  25  {}      {}                  {}
        5   RESPONSE_EXPLANATION_3  59  a   26  84  {}      {DISPUTE_TEXT_AREA} {}
        6   FILLER                  315 s   85  399 {}      {}                  {}
        7   INQUIRY_MARK            1   a   400 400 {}      {}                  {}
    }

    #     Response Trailer Record

    set trailer_rec {
        1   RECORD_TYPE             1   a   1   1   {T}     {}                  {}
        2   APPLICATION_SYSTEM_CODE 2   a   2   3   {"01"}  {}                  {}
        3   FILE_TYPE_CODE          2   a   4   5   {"02"}  {}                  {}
        4   FILE_CREATION_DATE      8   a   6   13  {}      {}                  {YYYYMMDD}
        5   FILLER                  13  s   14  26  {}      {}                  {}
        6   AMEX_TOTAL_RECORDS      9   n   27  35  {}      {}                  {}
        7   SE_TOTAL_RECORDS        9   n   36  44  {}      {}                  {}
        8   FILLER                  5   s   45  49  {}      {}                  {}
        9   FILLER                  80  s   50  129 {}      {}                  {}
        10  SAID                    6   a   130 135 {}      {}                  {}
        11  DATATYPE                5   a   136 140 {RESPN} {}                  {}
        12  FILLER                  7   s   141 147 {}      {}                  {}
        13  FILLER                  7   s   148 154 {}      {}                  {}
        14  FILLER                  75  s   155 229 {}      {}                  {}
        15  FILLER                  100 s   230 329 {}      {}                  {}
        16  FILLER                  71  s   330 400 {}      {}                  {}
    }

}

set AMEX_RESPN_LAYOUT_LOADED 1
