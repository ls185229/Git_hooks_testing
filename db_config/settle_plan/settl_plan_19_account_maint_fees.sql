

INSERT INTO "MASCLR"."TID" (TID, TRANS_DOMAIN, TRANS_SCOPE, TRANS_CLASS, TRANS_CODE, TRANS_SUBTYPE, TID_SETTL_METHOD, MAS_FEE_FLAG, ALTERNATE_TID, DESCRIPTION) VALUES ('010004240002', '01', '00', '04', '240', '002', 'D', 'Y', '010004240002', 'Acct Maint for Conv Chrg Merch');
                                                                                                                                                                                                                                             --  '12345678 1 2345678 2 2345678 3'

REM INSERTING into SETTL_PLAN_TID
SET DEFINE OFF;
                                                                                                                                                                                                                                                                                                                                                                                        -- values                                                                ,
Insert into SETTL_PLAN_TID (INSTITUTION_ID, SETTL_PLAN_ID, TID, CURR_CODE, CARD_SCHEME, SETTL_FLAG, POSTING_ENTITY_ID, GL_ACCT_DEBIT, GL_ACCT_CREDIT, DELAY_FACTOR0, DELAY_FACTOR1, DELAY_FACTOR2, DELAY_FACTOR3, DELAY_FACTOR4, DELAY_FACTOR5, DELAY_FACTOR6, SETTL_FREQ, SETTL_DATE_LIST_ID, NEXT_SETTL_DATE, PAYMENT_TERM, PARENT_ISO_TID, TID_RESERVE, DAY_OF_MONTH, HOL_DELAY_FACTOR) values ('107', 19, '010004240002', '840', '00', 'Y', null             , 'FEE-ACCUM-IN', 'NA-ISO-FEE-OUT', 0, 0, 0, 0, 0, 0, 0, 'D', 0, null, 0, null, null, null, 0);
