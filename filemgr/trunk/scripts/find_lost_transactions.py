#!/usr/bin/env python

#
#   find_lost_transactions.py
#
#   Using a partially imported mas_file,

sample_filename = "105.DEBITRAN.01.6091.901"
sample_file = """
FH012016033104100100TTLCSYSTEM      DEBITRN B
BH8402016033104100100402529411000244               000000001000000468N                                                                    CHESTERBOOTSH001                                                 2016033104100100
01010003005101402529411000244   020102MAESOTHREGFA                                  00000000010000000286090000000000000000000000000000000000000000000067317                    F4025296091035614000570
01010003005101402529411000244   020102MAESOTHREGFA                                  00000000010000000228850000000000000000000000000000000000000000000067319                    F4025296091035614000572
01010003005101402529411000244   020102NYCEOTH_3                                     00000000010000000263360000000000000000000000000000000000000000000067320                    F4025296091035614000573
BT000000077830000000000300000000000000000000000000000000000000000000
BH8402016033104100100402529465500015               000000002000000468N                                                                    PEACHTREECITY001                                                 2016033104100100
01010003005101402529465500015   020102STAROTH_3                                     00000000010000000073500000000000000000000000000000000000000000000067491                    F4025296091035636000744
BT000000000735000000000100000000000000000000000000000000000000000000
FT000000008518000000000900000000000000000000000000000000000000000000
"""



import sys, getopt
import cx_Oracle

from optparse import OptionParser

def find_trans(con, inst_id, file_id, entity_id, tid, mas_code, card_scheme, amt_original, trans_ref_data):
    """
        find_trans looks in masclr.mas_trans_log for a specific transaction
        and returns true if it finds one
    """
    print con, inst_id, file_id, entity_id, tid, mas_code, card_scheme, amt_original, trans_ref_data
    query_str = """

        select
            institution_id, entity_id, file_id, tid, mas_code, card_scheme,
            amt_original, trans_ref_data
        from mas_trans_log
        where
            file_id = '"""
    query_str += file_id
    query_str += """'
        and institution_id = '"""
    query_str += inst_id
    query_str += """'
        and entity_id = '"""
    query_str += entity_id
    query_str += """'
        and tid = '"""
    query_str += tid
    query_str += """'
        and mas_code = '"""
    query_str += mas_code
    query_str += """'
        and card_scheme = '"""
    query_str += card_scheme
    query_str += """'
        and amt_original = """
    query_str += str(int(amt_original) / 100.00)
    query_str += ""
    if trans_ref_data != "":
        query_str += """
            and trans_ref_data = '"""
        query_str += trans_ref_data
        query_str += "'"


    cur = con.cursor()
    cur.execute(query_str)

    query_str += ";\n"
    print query_str

    found_one = False
    for result in cur:
        found_one = True
        break
    return found_one

def main(argv):

    inputfile = ''
    outputfile = ''
    inst = ''
    file_id = ''
    try:
      opts, args = getopt.getopt(argv,"hi:o:f:b:",["ifile=","ofile=","fileid=","bank="])
    except getopt.GetoptError:
      print 'find_lost_transactions.py -i <inputfile> -o <outputfile> -b <bank (institution)> -f <mas file id>'
      sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'find_lost_transactions.py -i <inputfile> -o <outputfile> -b <bank (institution)> -f <fileid>'
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
        elif opt in ("-f", "--fileid"):
            file_id = arg
        elif opt in ("-b", "--bank"):
            inst = arg

    if inputfile == "" or  outputfile == "" or file_id == "" or inst == "":
        print 'All arguments are required'
        print 'find_lost_transactions.py -i <inputfile> -o <outputfile> -b <bank (institution)> -f <fileid>'
        sys.exit()

    print 'Input file is ', inputfile
    print 'Output file is ', outputfile





    con = cx_Oracle.connect('masclr/masclr@clear1')

    #inst = "105"
    #file_id = 1734089
    #inputfile  = '31_Mar/orig/105.DEBITRAN.01.6091.001'
    #outputfile = '31_Mar/105.DEBITRAN.01.6091.701'

    infile  = open(inputfile)
    outfile = open(outputfile, "w")

    batch_cnt = 0
    batch_amt = 0
    file_cnt = 0
    file_amt = 0

    for line in infile:
        if line[:2] == "FH":
            outfile.write(line)
        elif line[:2] == "BH":
            ent_id = line[21:36]
            outfile.write(line)
        elif line[:2] == "01":
            ent = line[14:29]
            tid = line[2:14]
            mas_code = line[34:80].strip()
            card_scheme = line[32:34]
            cnt = int(line[84:94])
            #batch_cnt += cnt_n
            amt = int(line[94:106])
            #batch_amt += amt_n
            arn = line[175:198].strip()
            #print ent, tid, mas_code, arn, cnt, amt

            if find_trans(con, inst, file_id, ent, tid, mas_code, card_scheme, amt, arn):
                continue
            else:
                # TODO add find_trans function
                outfile.write(line)
                batch_cnt += cnt
                batch_amt += amt
        elif line[:2] == "BT":
            line2 = line
            cnt = int(line[15:24])
            amt = int(line[2:15])
            line_cnt = str(batch_cnt)
            #line[15:24] = batch_cnt.zfill(9)
            line_amt = str(batch_amt)
            #line[2:15]  = batch_amt.zfill(13)
            file_cnt += batch_cnt
            file_amt += batch_amt
            batch_cnt = 0
            batch_amt = 0
            line_out = line[:2]
            line_out += line_amt.zfill(12)
            line_out += line_cnt.zfill(10)
            line_out += line[24:]

            outfile.write(line_out)
            #print line
            #print line2
        elif line[:2] == "FT":
            line_cnt = str(file_cnt)
            line_amt = str(file_amt)

            line_out = line[:2]
            line_out += line_amt.zfill(12)
            line_out += line_cnt.zfill(10)
            line_out += line[24:]

            outfile.write(line_out)

            file_cnt = 0
            file_amt = 0

        else:
            print "line is unknown type\n", line

    outfile.close()
    con.close()


if __name__ == "__main__":
    main(sys.argv[1:])
