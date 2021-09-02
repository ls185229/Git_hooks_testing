-- NPP-9360 The Account Updater Monthly Fee is a new Non Activity fee to support Account Updater.  Although, introduced with the AU AMEX and Discover project, the ONB and C&S Tech Leads  
-- agreed that this is a Non Activity Fee and it is standard practice to build this so that it can be used to support all card brands as are the other AU Fee
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('00AU_MONTHLY','00','Account Updater Monthly',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('03AU_UPDATE','03','AXP Account Updater / Success',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('03AU_CHK','03','AXP Account Updater / Txn',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('04AU_UPDATE','04','VS Account Updater / Success',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('04AU_CHK','04','VS Account Updater / Txn',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('05AU_UPDATE','05','MC Account Updater / Success',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('05AU_CHK','05','MC Account Updater / Txn',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('08AU_UPDATE','08','DS Account Updater / Success',null);
Insert into MASCLR.MAS_CODE (MAS_CODE,CARD_SCHEME,MAS_DESC,IRF_PROG_IND_DESC) values ('08AU_CHK','08','DS Account Updater / Txn',null);
commit;