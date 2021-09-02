'''
Created on Oct 16, 2015

@author: jxiao
'''
# File Name:  mas_debit_settlement_file.py
#
# Description:  This program creates a MAS file for PIN DEBIT transactions.
#               Settlement Reporting Entity (SRE).
#
# Script Arguments:  shortname (e.g. JETPAYIS).  Required.
#                    institution_id (e.g. 107).  Required.
#                    date (YYMMDD, e.g. 20150913) Optional, defaults to today
#
# example mas_debit_settlement_file.py JETPAYIS 107 20151104
# Output:  MAS file under ~/MAS/MAS_FILES/inst_id.DEBITRAN.01.Jdate.Seq
#                                   e.g.: 101.DEBITRAN.01.3267.978
#
# Return:   0 = Success
#          !0 = Exit with errors
#
# Notes:  DO NOT RUN THIS CODE TWICE, as it will create duplicate file contents.
#
#######################################################################################
import sys
import os
import glob
from datetime import datetime
import cx_Oracle


class MasClass(object):
    '''
    classdocs
    '''
    def __init__(self):
        self.programName=""
        self.s_name=''
        self.inst=""
        self.sdate=""
        self.error = 0
        self.fileno = 0
        self.conn=None
        self.conn1=None
        
    def printUsage(self):
         print ("Usage: ", self.programName, "  <short name> <institution><sort date>")
         print  ("EXAMPLE = mas_debit_settlement_file.py  JETPAYIS 107 20130910")
         exit(1)
         
    def checkOpts(self):
        if self.sdate=="":
            now = datetime.now()
            self.sdate=now.strftime("%Y%m%d%H%M%S")
        if self.inst=="":
            print ("Insufficient Arguments")
            self.printUsage()
        if self.s_name=="":
            print ("Insufficient Arguments")
            self.printUsage()
            
        print ("inst=", self.inst," sdate=", self.sdate," s_name=", self.s_name)   
              
    def parseOpts(self):
        self.programName=sys.argv[0]
        args=sys.argv[1:]
        print("in parseOpts args=", args)
        for index, item in enumerate(args):
            if index==0:
                self.s_name=item
            if index==1:
                self.setInstId(item)
            if index==2:
                self.sdate=item
        
        self.checkOpts()
        
    def getEndtime(self):
        endt= '000000'
        endtime =""

        if(len(self.getSdate())==8):
            endtime= self.getSdate()+endt
        else:
            endtime =self.getSdate()
        return endtime

    def setFileno(self, fileno):
        self.fileno = fileno
        
    def setMasCode(self, network_id, sic_code):
            
        if network_id== "00" or network_id == "02" :
            mas_code="0102VISASMS"
        elif network_id == "08" or network_id == "10" or network_id == "11" or network_id == "12" or network_id == "15" :
            mas_code = "0102STARSMS"
        elif network_id == "09" or network_id == "19" or network_id == "17" :
            mas_code = "0102PULSESMS"
        elif network_id == "27" or network_id == "18" :
            mas_code = "0102NYCESMS"
        elif network_id == "03" :
            mas_code = "0102INTRLKSMS"
        elif network_id == "16" :
            mas_code = "0102MSTROSMS"
        elif network_id == "04" :
            mas_code = "0102PULSESMS"
        elif network_id == "13" :
            mas_code = "0102AFFNSMS"
        elif network_id == "20" :
            if sic_code == "4511" :
                mas_code = "0102ACCLSMS"
            elif sic_code < "3000" or sic_code > "3300" :
                mas_code = "0102ACCLSMS"
            else:
                mas_code = "0102ACCLSMS_AL"
        elif network_id == "23" :   
            mas_code ="0102NETSSMS"
        elif network_id == "24" :   
            mas_code= "0102CU24SMS"
        elif network_id == "25" :   
            mas_code ="0102ALSKOPSMS"
        elif network_id == "28" :   
            mas_code ="0102SHAZAMSMS"
        elif network_id == "29" :   
            mas_code ="0102EBTSMS"
        else:    #in case it is not set use default
            mas_code ="0102VISASMS"
      
        return mas_code
        
    def makeAcqRefNum(self, bin, disc_acq_id, film, card_type, tran_type, currency):
        format_code = 0
        date =datetime.now().strftime("%y%j")
        datex=date[1:]
         
        if card_type == "VS":
            if(tran_type== "0420" or currency != "840"):
                format_code = 7
            else:
                format_code = 2
        elif card_type == "MC":
             format_code = 1
        elif card_type == "DS":
             format_code = 8
             if disc_acq_id[:1] != "":
                bin=disc_acq_id[5:10]
             else:
                bin ="123456"
        elif card_type == "DB":
            format_code = 0
        
        s1 = '{:<1}{:<06}{:<04}{:<011}'.format(format_code, bin, datex, film)
        phase= 0
        sum = 0

        if card_type == "DB":
            s1 =s1[1:24]
       
        phase= 0
        sum= 0
        c = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
        
        for v in s1:
            intv=int(v)
            vv = c[intv + 10 * phase]
            sum =sum + vv
            phase= phase ^ 1
            
        ch = (10 - sum %10) %10

        if card_type == "DB":
            s1 = "F"+s1
        s1 = s1+str(ch)
        
        return s1
          
        
    def checkDup(self):
        dupFlag = 1
        f_seq = 0
        one = "01"
        fname = "DEBITRAN"
        pth = "/clearing/filemgr/DEBIT/"
        #jdate is year last digit plus the days of the year 5314 mean 2015 314 days to the year
        jdate =datetime.now().strftime("%y%j")
        jdate=jdate[1:]
        while dupFlag == 1:
            f_seq += 1
            fileno = '{:<03}'.format(f_seq)
            filename=""
            filename=self.getInstId()+"."+fname+"."+one+"."+jdate+"."+fileno
            mfl=self.checkDupSql(filename)
            if(mfl != 0):
                dupFlag = 1
            else:
                dupFlag=0

            ### Check the ARCHIVE folder
            if dupFlag == 0:
                tempFileName = "/clearing/filemgr/MAS/ARCHIVE/"+filename+"*"
                if  glob.glob(tempFileName) :
                    dupFlag = 1         
                else:
                    dupFlag = 0
                
             ### Check for MAS FILES folder
            if dupFlag == 0: 
                if os.path.exists("/clearing/filemgr/MAS/MAS_FILES/"+filename) == True: 
                    dupFlag = 1
                else:
                    dupFlag= 0
            
            
        outfile =pth+filename
        return outfile    
        
        
    def getBatchNum(self):
        #batch_num_file open for read only
        batch_num_file = open ("c:/jean_doc/mas_batch_num.txt", "r+")
        bchnum = batch_num_file.read()
        batch_num_file.seek(0,0)
        if int(bchnum) >= 999999999:
           batch_num_file.write("%d" %1)
        else:  
            batch_num_file.write("%d" % (int(bchnum)+1))
        
        batch_num_file.close() 
        return bchnum
    # all db query
    def checkDupSql(self, filename):
        conn = self.getDbMasConn()
        cs = conn.cursor() 
        queryStr="select count(1) from mas_file_log where institution_id = '" + self.getInstId() + "' and file_name in ('"+filename+"')"
        cs.execute(queryStr)
        rr=cs.fetchone()
        return rr[0]
    
    def pullMerFromMerSql(self):
        conn = self.getDbAuthConn()
        tblnm_mm = self.getDbAuthHost()+".master_merchant"
        tblnm_mr = self.getDbAuthHost()+".merchant"
        cs = conn.cursor()
        
        queryStr="select MMID, MID, VISA_ID, DEBIT_ID from "+tblnm_mr+" where mmid in (select mmid from "+ tblnm_mm+" where shortname = '"+self.s_name+"') and debit_id not like ' %'" 
        cs.execute(queryStr)
        rr=cs.fetchall()
        return rr
    
    def getMerUseMidSql(self, mid):
        conn = self.getDbAuthConn()
        tblnm_mr = self.getDbAuthHost()+".merchant"
        cs = conn.cursor() 
        queryStr="select * from "+tblnm_mr+" where mid = '"+mid + "'" 
        cs.execute(queryStr)
        rr=cs.fetchone()
        return rr
      
    def selectChkSumSql(self, mid):
        conn = self.getDbAuthConn()
        tblnm_set = self.getDbAuthHost()+".SETTLEMENT"
        cs = conn.cursor()
        list=[]
        list.append("select count(amount) ckct, sum(amount) cksm from ")
        list.append(tblnm_set)
        list.append(" where mid = '")
        list.append(mid)
        list.append("' and (request_type like '026%' or request_type like '046%') and status is not null and card_type = 'DB' and settle_date like '"+ self.getSdate()+"%'")
        #below line is for testing only, otherwise dont get entry
        #queryStr="count(amount) ckct, sum(amount) cksm from $tblnm_set where mid = '"+mid+"' and (request_type like '026%' or request_type like '046%') and status is not null and card_type = 'DB' and settle_date like '"+ self.getSdate()+"%'"
        
        queryStr="".join(''.join(elems) for elems in list)
        
        cs.execute(queryStr)
        rr=cs.fetchone()
        return rr[0]
    
    def selectEntityToAuthSql (self,  mid, type): 
        tblnm_e2a =self.getDbMasHost()+".ENTITY_TO_AUTH"
        conn = self.getDbMasConn()
        temp_crsr1= conn.cursor()
        
        list=[]
        list.append("select MID, VISA_BIN, MC_BIN, ENTITY_ID, DISCOVER_ACQ_ID from ")
        list.append(tblnm_e2a)
        list.append(" where status = 'A' and INSTITUTION_ID = '")
        list.append(self.getInstId())
        list.append("' and MID = '")
        list.append(mid[1]) #mid[1] is MID field
        list.append("'")
        queryStr="".join(''.join(elems) for elems in list)
       
        temp_crsr1.execute(queryStr)
        bins=temp_crsr1.fetchone()
       
        if(bins):
            #VISA_BIN=1,MAC_BIN=2,ENTITY_ID=3,DISCOVER_AC1_ID=4
            VISA_DEST_BIN =bins[1]
            VISA_SOURCE_BIN= bins[1]
            MC_DEST_BIN =bins[2]
            MC_SOURCE_BIN = bins[2]
            ENTITY_ID= bins[3]
            DISC_ACQ_ID =bins[4]
            # type only db, so no need switch as before only set db soource and dest bin
            self.setSourceBin(VISA_SOURCE_BIN)
            self.setDestBin(VISA_DEST_BIN)
            self.setDiscAcqID(DISC_ACQ_ID)
        else:   # in case don't get return from query
            self.setSourceBin("000000")
            self.setDestBin("000000")
            self.setDiscAcqID("000000")
            
          
    def batchCountSql ( self, mid, r_typ, type ):
        #Sql string command for transaction count
        # FC use Settlement instead of TranHistory
        conn = self.getDbAuthConn()
        tblnm_set = self.getDbAuthHost()+".SETTLEMENT"
        cs = conn.cursor()
        list=[]
        list.append("select * from ")
        list.append(tblnm_set)
        list.append(" where mid = '")
        list.append(mid[0])
        list.append("' and action_code = '000' and request_type = '")
        list.append(r_typ)
        list.append("' and card_type = 'DB' and settle_date like '")
        list.append(self.getSdate())
        list.append("%'")
        queryStr="".join(''.join(elems) for elems in list)
        # use following str for testing only
        #queryStr="select * from teihost.SETTLEMENT where mid = 'TESTMERCHANT0001'"
        cs.execute(queryStr)
        rr=cs.fetchall()
       
        return rr
      
    def updateSettlementWithARNSql (self, settlement_arn,  mid, r_typ, card_type, otherData4 ):
        
        conn = self.getDbAuthConn()
        tblnm_set = self.getDbAuthHost()+".SETTLEMENT"
        cs = conn.cursor()
        list=["UPDATE "]
        list.append(tblnm_set)
        list.append(" SET ARN = '")
        list.append(settlement_arn)
        list.append("' STATUS = '")
        list.append(self.getInstId()) 
        list.append("' WHERE MID = '")
        list.append(mid)
        list.append("' AND ACTION_CODE = '000' AND REQUEST_TYPE = '")
        list.append(r_typ)
        list.append("' AND CARD_TYPE = '")
        list.append(card_type)
        list.append("' AND OTHER_DATA4 = '")
        list.append(otherData4)
        list.append("'")
        queryStr="".join(''.join(elems) for elems in list)
        cs.execute(queryStr)
        
    ## this is called by both DbOnlyProcess and FileAndDbProcess
    def updateSettlementTbSql(self):
        conn = self.getDbAuthConn()
        tblnm_set = self.getDbAuthHost()+".SETTLEMENT"
        cs = conn.cursor()
        list=["UPDATE "]
        list.append(tblnm_set)
        list.append(" SET SETTLE_DATE = '") 
        list.append(self.getSdate())
        list.append("' WHERE CARD_TYPE = 'DB'  AND (REQUEST_TYPE like '026%' OR REQUEST_TYPE like '046%' AND STATUS IS NOT NULL)")
        queryStr="".join(''.join(elems) for elems in list)
       
        ### comment out, not run update for testing
        #cs.execute(queryStr)

    def countRecProcessedFromSettlementSql(self):
        conn = self.getDbAuthConn()
        tblnm_set = self.getDbAuthHost()+".SETTLEMENT"
        cs = conn.cursor()
        list=[]
        list.append("select count(amount) CNT from ")
        list.append(tblnm_set)
        list.append(" WHERE (STATUS='")
        list.append(self.getInstId())
        list.append("') and CARD_TYPE = 'DB' and SETTLE_DATE like '")
        list.append(self.getSdate())
        list.append("%'")
        queryStr="".join(''.join(elems) for elems in list)
        
        cs.execute(queryStr)
        rr=cs.fetchone()
    
        return rr[0]
     
    def countRecInsertToTranhistorySql (self):
        conn = self.getDbAuthConn()
        tblnm_tn =self.getDbAuthHost()+".TRANHISTORY"
        cs = conn.cursor()
        list=[]
        list.append("select count(amount) CNT from ")
        list.append(tblnm_tn)
        list.append(" WHERE (STATUS='")
        list.append(self.getInstId())
        list.append("') and CARD_TYPE = 'DB' and SETTLE_DATE like '")
        list.append(self.getSdate())
        list.append("%'")
        queryStr="".join(''.join(elems) for elems in list)
       
        cs.execute(queryStr)
        rr=cs.fetchone()
       
        return rr[0]    
    
    def insertToTranhistoryFromSettlementSql(self):
        conn = self.getDbAuthConn()
        tblnm_set = self.getDbAuthHost()+".SETTLEMENT"
        tblnm_tn =self.getDbAuthHost()+".TRANHISTORY"
        cs = conn.cursor()
        list=["INSERT INTO "]
        list.append(tblnm_tn)
        list.append(" (MID,TID,TRANSACTION_ID,REQUEST_TYPE,TRANSACTION_TYPE,CARDNUM,EXP_DATE,AMOUNT,ORIG_AMOUNT,INCR_AMOUNT,FEE_AMOUNT,TAX_AMOUNT,")
        list.append("PROCESS_CODE,STATUS,AUTHDATETIME,AUTH_TIMER,AUTH_CODE,AUTH_SOURCE,ACTION_CODE,SHIPDATETIME,TICKET_NO,NETWORK_ID,ADDENDUM_BITMAP,")
        list.append("CAPTURE,POS_ENTRY,CARD_ID_METHOD,RETRIEVAL_NO,AVS_RESPONSE,ACI,CPS_AUTH_ID,CPS_TRAN_ID,CPS_VALIDATION_CODE,CURRENCY_CODE,CLERK_ID,")
        list.append("SHIFT,HUB_FLAG,BILLING_TYPE,BATCH_NO,ITEM_NO,OTHER_DATA,SETTLE_DATE,CARD_TYPE,CVV,PC_TYPE,CURRENCY_RATE,OTHER_DATA2,OTHER_DATA3,OTHER_DATA4,")
        list.append("ARN,MARKET_TYPE,VV_RESULT,CARD_PRESENT,AUTHORIZATION_AUTHORITY)")      
        list.append(" SELECT MID,TID,TRANSACTION_ID,REQUEST_TYPE,TRANSACTION_TYPE,CARDNUM,  EXP_DATE,AMOUNT,ORIG_AMOUNT,INCR_AMOUNT,FEE_AMOUNT,TAX_AMOUNT,")
        list.append("PROCESS_CODE,STATUS,AUTHDATETIME,AUTH_TIMER,AUTH_CODE,AUTH_SOURCE,ACTION_CODE,SHIPDATETIME,TICKET_NO,NETWORK_ID,ADDENDUM_BITMAP,")
        list.append("CAPTURE,POS_ENTRY,CARD_ID_METHOD,RETRIEVAL_NO,AVS_RESPONSE,ACI,CPS_AUTH_ID,CPS_TRAN_ID,CPS_VALIDATION_CODE,CURRENCY_CODE,CLERK_ID,")
        list.append("SHIFT,HUB_FLAG,BILLING_TYPE,BATCH_NO,ITEM_NO,OTHER_DATA,SETTLE_DATE,CARD_TYPE,CVV,PC_TYPE,CURRENCY_RATE,OTHER_DATA2,OTHER_DATA3,OTHER_DATA4,")
        list.append("ARN,MARKET_TYPE,VV_RESULT,CARD_PRESENT,AUTHORIZATION_AUTHORITY FROM ")    
        list.append(tblnm_set)
        list.append(" WHERE (STATUS='")
        list.append(self.getInstId())
        list.append("') and card_type = 'DB' and SETTLE_DATE = '")
        list.append(self.getSdate())
        list.append("'")       
        queryStr="".join(''.join(elems) for elems in list)
        #print("insert queryStr=", queryStr)
        ### comment out, not run update for testing
        cs.execute(queryStr)
    
    def deleteFromSettlementSql(self):
        conn = self.getDbAuthConn()
        tblnm_set = self.getDbAuthHost()+".SETTLEMENT"
        cs = conn.cursor()
        list=["DELETE FROM "]
        list.append(tblnm_set)
        list.append(" WHERE STATUS='")
        list.append(self.getInstId())
        list.append("' and card_type = 'DB' and SETTLE_DATE = '")
        list.append(self.getSdate())
        list.append("'")
        queryStr="".join(''.join(elems) for elems in list)
        #print("delete queryStr=", queryStr)
        ### comment out, not run update for testing
        cs.execute(queryStr)
        
    def checkDBRecToCommitMoveFile(self,  setl_cnt, tn_ins, outfile):
        conn = self.getDbAuthConn()
        if(setl_cnt == tn_ins):
            conn.commit()
            os.rename(outfile, "/clearing/filemgr/MAS/MAS_FILES/"+os.path.basename(outfile))
        else:
            conn.rollback()
            os.rename(outfile, "./ARCHIVE/"+os.path.basename(outfile)+".killed")
           
        conn.close()
        
    def setDbMasConn(self, conn):
        self.masConn = conn
        
    def getDbMasConn(self):
        return self.masConn
    
    def setDbAuthConn(self, conn):
        self.authConn= conn
        
    def getDbAuthConn(self):
        return self.authConn
    
    def setDbAuthHost(self, host):
        self.authHost=host
    def getDbAuthHost(self):
        return self.authHost
    def setDbMasHost(self, host):
        self.masHost=host
    def getDbMasHost(self):
        return self.masHost
    def setSourceBin(self, sb):
        self.SOURCE_BIN =sb
    def getSourceBin(self):
        return self.SOURCE_BIN
    def setDestBin(self, db):
        self.DEST_BIN=db
    def getDestBin(self):
        return self.DEST_BIN
    def setDiscAcqID(self, db):
        self.DISC_ACQ_ID=db
    def getDiscAcqID(self):
        return self.DISC_ACQ_ID
    def setInstId(self, inst):
        self.inst=inst
    def getInstId(self):
        return self.inst
    def setSdate(self, sdate):
        self.sdate=sdate
    def getSdate(self):
        return self.sdate
    
    def initDB(self):
        
        connstr = "masclr/masclr@authqa.jetpay.com:1521/authqa.jetpay.com"
        # connstr = os.environ["IST_DB_USERNAME"]+'/'+os.environ["IST_DB_PASSWORD"] +'@' +os.environ["IST_DB_HOST"]+':1521/'+os.environ["IST_DB"]
        conn = cx_Oracle.connect(connstr)
        
        connstr1 = "teihost/quikdraw@hqz-prd-db-06:1521/auth4"
        # connstr1 = os.environ["ATH_DB_USERNAME"]+'/'+os.environ["ATH_DB_PASSWORD"] +'@' +os.environ["ATH_DB_HOST"]+':1521/'+os.environ["ATH_DB"] 
        conn1= cx_Oracle.connect(connstr1)
        self.setDbMasConn(conn)
        self.setDbAuthConn(conn1)
       
        
    # create a file Header
    def makeFileHeader(self, outfile):
        #File header variables declared-----------------------------------
        now = datetime.now()
        fhtrans_type =  "FH"
        file_type = "01"
        rightnow = now.strftime("%Y%m%d%H%M%S")
    
        file_date_time = '{:0<16}'.format(rightnow)
        activity_source = '{:<16}'.format('TTLCSYSTEM')
        activity_job_name = '{:<8}'.format('DEBITRN')
        suspend_level = '{:<1}'.format('B')
    
        #Creating the File Header string length 45 -----
        list =[]
        list.append(fhtrans_type)
        list.append(file_type)
        list.append(file_date_time)
        list.append(activity_source)
        list.append(activity_job_name)
        list.append(suspend_level)
        fh = ''.join(list)
        
        if len(fh) != 45:
            print("FILE HEADER LENGTH DID NO MATCH ", fh)
            exit(1)
        else:    
            try:
                fileid = open(outfile, 'a+')
                fileid.writelines(fh + '\n')
            except IOError:
                print("Cannot open /duplog :", fileid)
                exit(2)
    # create a file Header
    def makeFileTrailer(self, totfileamt, totfilecnt, outfile):
        #File trailer variables declared-----------------------------------
  
        fttrans_type  =  "FT"
        file_amt  = '{:>012}'.format(totfileamt)
        file_cnt  = '{:>010}'.format(totfilecnt)
        file_add_amt1  = '{:0<12}'.format(0)
        file_add_cnt1  = '{:0<10}'.format(0)
        file_add_amt2  = '{:0<12}'.format(0)
        file_add_cnt2  = '{:0<10}'.format(0)
    
        #Creating the File trailer string length 68 -----
        list =[]
        list.append(fttrans_type)
        list.append(file_amt)
        list.append(file_cnt)
        list.append(file_add_amt1)
        list.append(file_add_cnt1)
        list.append(file_add_amt2)
        list.append(file_add_cnt2)
        ft = ''.join(list)
        
        if len(ft) != 68:
            print("FILE TRAILER LENGTH DID NO MATCH ", ft)
            exit(1)
        else:    
            try:
                fileid = open(outfile, 'a+')
                fileid.writelines(ft + '\n')
            except IOError:
                print("Cannot open /duplog :", fileid)
                exit(2)     
    
    
    
    # create a file Header
    def makeBatchHeader(self, mid, outfile):
        # get and bump the file number
        bchnum = self.getBatchNum()
        #BATCH variables declared-----------------------
        spcs25  = '{:>25}'.format("")
        spcs23  = '{:>23}'.format("")
        bhtrans_type  = 'BH'
        batch_curr ="840"
        activity_date_time_bh = '{:>016}'.format(self.getEndtime())
        if mid[2] != "":
            merchantid = '{:<30}'.format(mid[2])
        else:
            merchantid = '{:<30}'.format(mid[3])
        
        inbatchnbr= '{:<09}'.format(bchnum)
        infilenbr= '{:<09}'.format(self.fileno)
        billind = "N"
        orig_batch_id ='{:<9}'.format("")
        orig_file_id='{:<9}'.format("")
        ext_batch_id =spcs25
        ext_file_id= spcs25
        sender_id ='{:<25}'.format(mid[1])
        microfilm_nbr ='{:<30}'.format("")
        institution_id= '{:<10}'.format("")
        batch_capture_dt= '{:0<16}'.format(self.getEndtime())
        list=[]
   
        list.append(bhtrans_type)
        list.append(batch_curr)
        list.append(activity_date_time_bh)
        list.append(merchantid)
        list.append(inbatchnbr)
        list.append(infilenbr)
        list.append(billind)
        list.append(orig_batch_id)
        list.append(orig_file_id)
        list.append(ext_batch_id)
        list.append(ext_file_id)
        list.append(sender_id)
        list.append(microfilm_nbr)
        list.append(institution_id)
        list.append(batch_capture_dt)
        bh = ''.join(list)
        
        if len(bh) != 219:
            print("BATCH HEADER LENGTH DID NO MATCH ", bh)
            exit(1)
        else:    
            try:
                fileid = open(outfile, 'a+')
                fileid.writelines(bh + '\n')
            except IOError:
                print("Cannot open /duplog :", fileid)
                exit(2)   
       
    def makeBatchBody(self,  mid, c_sch, mas_code, efcs, settlement_arn, outfile, tid):   
       
        spcs25  = '{:>25}'.format("")
        spcs23  = '{:>23}'.format("")
        mgtrans_type  = '01'
        trans_id = '{:0>12}'.format(tid)
        if(mid[2].strip() != ""):
            entity_id = '{:<18}'.format(mid[2])
        else:
            entity_id = '{:<18}'.format(mid[3])
        card_scheme = c_sch
        mas_code = '{:<25}'.format(mas_code)
        mas_code_downgrade=spcs25
        nbr_of_items = '{:0>10}'.format(1)
        amt_original  = round(int(efcs[7]) *100) 
        amt_original ='{:0>12}'.format(amt_original)
        add_cnt1 ="0000000000"
        add_amt1 ="000000000000"
        add_cnt2 ="0000000000"
        add_amt2 ="000000000000"
        trans_ref_data =settlement_arn[0:23]
        suspend_reason ='{:>2}'.format("")
        external_trans_id =spcs25
        b=mgtrans_type+trans_id+entity_id+card_scheme+mas_code+mas_code_downgrade+nbr_of_items+amt_original+add_cnt1+\
        add_amt1+add_cnt2+add_amt2+external_trans_id+trans_ref_data+suspend_reason
        if len(b) != 200:
            print("BATCH BODY LENGTH DID NO MATCH ", b)
            exit(1)
        else:    
            try:
                fileid = open(outfile, 'a+')
                fileid.writelines(b + '\n')
            except IOError:
                print("Cannot open /duplog :", fileid)
                exit(2)   
                
    def makeBatchTrailer(self, totbchamt, bchcnt, outfile):
        totbchamt  = round(int(totbchamt) *100) 
        bttrans_type = "BT"
        batch_amt ='{:0>12}'.format(totbchamt)
        batch_cnt ='{:>010}'.format(bchcnt)
        batch_add_amt1 = '{:0<12}'.format(0)
        batch_add_cnt1= '{:0<10}'.format(0)
        batch_add_amt2 ='{:0<12}'.format(0)
        batch_add_cnt2='{:0<10}'.format(0)
        #Creating Batch trailer string length 68
        bt= bttrans_type+batch_amt+batch_cnt+batch_add_amt1+batch_add_cnt1+batch_add_amt2+batch_add_cnt2

        if len(bt) != 68:
            print("BATCH TRAILER LENGTH DID NO MATCH ", bt)
            exit(1)
        else:    
            try:
                fileid = open(outfile, 'a+')
                fileid.writelines(bt + '\n')
            except IOError:
                print("Cannot open /duplog :", fileid)
                exit(2)   
    
    def fileAndDbProcess(self):
        
        outfile = self.checkDup()
        #for test 
        #outfile="c:/jean_doc/new1"
        card_type = "DB"
        r_type = ["0260", "0262", "0460", "462"]
        act_code = ['A', 'D']
        seq_type = ["batch_id" "file_id"]
        tot = 0
        totbchamt =0
        totitm =0 
        bchcnt= 0
        y = 0
        totfileamt = 0
        totfilecnt = 0
        
        self.updateSettlementTbSql()                        
        self.makeFileHeader(outfile)
        pull_mer_from_mer=self.pullMerFromMerSql()
        #print("total merchants = ", len(pull_mer_from_mer))
        FILE_NUM_MONEY_TRANS=0
        # this is the outer loop 
        for mid in pull_mer_from_mer:
            chk_sum = self.selectChkSumSql(mid[1]) 
            #for testing
            #chk_sum=1
            if( chk_sum != 0):  
                if mid[0] != "":
                    self.makeBatchHeader(mid, outfile)
                           
                for r_typ in r_type:
                    for act_typ in act_code:
                        if act_typ == "A":                            
                            self.selectEntityToAuthSql (mid, type)     
                            batch_count_sql = self.batchCountSql(mid, r_typ, type)
                            
                            for efcs in batch_count_sql:
                                c_sch = '02'
                                mcd=self.getMerUseMidSql(mid[1])
                              
                                request_type = efcs[3]
                                tid = "010003005101"  #default value
                                if request_type[:2] == "02":
                                    tid ="010003005101"
                                elif request_type[:2] == "04":
                                    tid ="010003005102"
                                
                                network_id = efcs[21]
                                mas_code = self.setMasCode(network_id, mcd[16])  #mcd[16]is SIC_CODE
                                CUR_PID  = os.getpid()
                                FILE_NUM_MONEY_TRANS += 1  
                                temp = '{:05d}{:06d}'.format(CUR_PID, FILE_NUM_MONEY_TRANS)
                                settlement_arn=self.makeAcqRefNum(self.getSourceBin(), self.getDiscAcqID(), temp, card_type, r_typ, efcs[32])
                                self.updateSettlementWithARNSql (settlement_arn,  mid[0], r_typ, card_type, efcs[47] )
                                self.makeBatchBody(mid, c_sch, mas_code, efcs, settlement_arn, outfile, tid)
                                
                                #Calculation totals from sum amount and transaction counts-----------------------
                                tot = tot + int(efcs[7])
                                totbchamt = tot
                                totitm = totitm + 1
                                bchcnt =totitm
                        
                self.makeBatchTrailer(totbchamt, bchcnt, outfile)
                #calculating total for file trailer---------------------------------------
                totfileamt =totfileamt + tot
                totfilecnt =totfilecnt + totitm
                tot= 0
                totitm =0
                totbchamt= 0
                bchcnt= 0
                y += y
                
        totfileamt=round(totfileamt * 100)      
        self.makeFileTrailer(totfileamt, totfilecnt, outfile)
        # count number of records processed from Settlement
        setl_cnt = self.countRecProcessedFromSettlementSql()
        # FC Insert records into TranHistory from Settlement
        self.insertToTranhistoryFromSettlementSql()
        self.deleteFromSettlementSql()
        # count number of records inserted into TranHistory
        tn_ins=self.countRecInsertToTranhistorySql()
        print("Settlement Count =  ", setl_cnt, " and TranHistory Count = ", tn_ins)
        # check to see if record count in Settlement matches record count in TranHistory to commit or roll back transactions
        self.checkDBRecToCommitMoveFile(setl_cnt, tn_ins, outfile)        
        
    def dbOnlyProcess(self):
        print(" in dbOnlyProcess")
        self.updateSettlementTbSql()
        self.insertToTranhistoryFromSettlementSql()
        self.deleteFromSettlementSql()
        
        
    def process(self):
        #test set host will get from env
        self.setDbMasHost("masclr")
        self.setDbAuthHost("teihost")
        self.initDB()
        
        if(self.getInstId()=="117"):
            self.dbOnlyProcess()
        else:
            self.fileAndDbProcess()    
def main():
    mas = MasClass()
    mas.parseOpts()
    mas.process()

if __name__ == "__main__":
    main()   