#!/usr/bin/env python

"""
#
#   $Id: copy_transactions.py 4907 2019-10-15 14:15:38Z bjones $
#   copy_transactions.py
#
#   Building a mas_file using a list of ARN values.
"""

import sys
import getopt

from optparse import OptionParser

sample_filename = "105.DEBITRAN.01.6091.901"
sample_file = """
  tid         entity_id           mas_code                                                                                                                                     ARN

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

def main(argv=None):
    """
    Main process that parses input file, and generates new file
    """

    inputfile = ''
    outputfile = ''
    inst = ''
    file_id = ''
    arn_list = []
    arn_merch_id = {}
    try:
        opts, args = getopt.getopt(argv, "hi:o:f:b:a:m:",
                                  ["ifile=", "ofile=", "fileid=", "bank=",
                                  "arn=", "arn_merch="])
    except getopt.GetoptError:
        print('copy_transactions.py -i <inputfile> -o <outputfile> '
              '-b <bank (institution)> -f <mas file id> -a <arn list file>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('copy_transactions.py -i <inputfile> -o <outputfile> '
                  '-b <bank (institution)> -f <fileid> -a <arn list file> '
                  '-m <arn - entity_id list file')
            sys.exit()
        elif opt in ("-a", "--arn"):
            arnfile = arg
            with open(arnfile) as f:
                arn_list = f.read().splitlines()
        elif opt in ("-m", "--merch_id"):
            arn_merch_file = arg
            with open(arn_merch_file) as f:
                for line in f:
                   (key, val) = line.split()
                   arn_merch_id[key] = val
        elif opt in ("-b", "--bank"):
            inst = arg
        elif opt in ("-f", "--fileid"):
            file_id = arg
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    # if inputfile == "" or  outputfile == "" or file_id == "" or inst == "":
    #     print 'All arguments are required'
    #     print 'copy_transactions.py -i <inputfile> -o <outputfile>
    #            -b <bank (institution)> -f <fileid>'
    #     sys.exit()

    print('Input file is ', inputfile)
    print('Output file is ', outputfile)

    # con = cx_Oracle.connect('masclr/masclr@clear1')

    # inst = "105"
    # file_id = 1734089
    # inputfile  = '31_Mar/orig/105.DEBITRAN.01.6091.001'
    # outputfile = '31_Mar/105.DEBITRAN.01.6091.701'

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

            if arn in arn_list:
                # TODO add find_trans function
                outfile.write(line)
                batch_cnt += cnt
                batch_amt += amt
            elif arn in arn_merch_id:
                # TODO add find_trans function
                #line_new = line[:21] + arm_merch_id[arn] + line[36:]
                #outfile.write(line_new)
                outfile.write(line)
                batch_cnt += cnt
                batch_amt += amt
            else:
                continue
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
            print("line is unknown type\n", line)

    outfile.close()
    # con.close()

if __name__ == "__main__":
    main(sys.argv[1:])
