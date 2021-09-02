REM Add flmgr_ichg_template for interchange fee packages

REM $Id: 0_5_make_table_flmgr_ichg_temp.sql 17 2016-10-25 15:22:05Z bjones $

CREATE
  TABLE "MASCLR"."FLMGR_ICHG_RATES_TEMPLATE"
  (
    "MAS_CODE"            VARCHAR2(25 BYTE) NOT NULL ENABLE,
    "MAS_DESC"            VARCHAR2(50 BYTE),
    "TIER"                VARCHAR2(2 BYTE),
    "RATE_PERCENT"        NUMBER(26,8),
    "RATE_PER_ITEM"       NUMBER(26,8),
    "PER_TRANS_MAX"       NUMBER(26,8),
    "FPI_IRD"             VARCHAR2(20 BYTE),
    "PROGRAM"             VARCHAR2(70 BYTE),
    "PROGRAM_DESC"        VARCHAR2(70 BYTE),
    "ASSOCIATION_UPDATED" DATE,
    "RETIRE"              VARCHAR2(20 BYTE),
    "DATABASE_UPDATED"    DATE,
    "CARD_SCHEME"         VARCHAR2(3 BYTE),
    "TEMPLATE_MAS_CODE"   VARCHAR2(25 BYTE),
    "NOTES"               VARCHAR2(1000 BYTE),
    "PER_TRANS_MIN"       NUMBER(26,8),
    "USAGE"               VARCHAR2(20 BYTE) NOT NULL ENABLE,
    "CURR_CODE"           CHAR(3 BYTE),
    "REGION"              VARCHAR2(10 BYTE),
    "CNTRY_CODE"          CHAR(3 BYTE),

            CONSTRAINT
                "FLMGR_ICHG_RATES_TEMPLATE_PK"
                    PRIMARY KEY ("MAS_CODE", "USAGE") ENABLE
        )
;
