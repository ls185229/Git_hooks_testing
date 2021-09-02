#!/usr/bin/env python
'''
$Id: release_reserve_fund.py 4893 2019-09-24 19:30:24Z skumar $
$Rev: 4893 $
File Name:  release_reserve_fund.py

Description:  This script release reserve amount from the merchant

Running options:

Shell Arguments:
           -f = File name which holds the Merchant ID
                 and amount to release(Optional)
           -m = MODE (Required)
                PROD - production mode
                PREVIEW - test mode
           -c = CYCLE (Optional)
           -t = Test email configuration file name (Optional)
           -v = Verbosity level
                -v = logging.DEBUG
                -vv = logging.INFO
                -vvv = logging.WARNING
                -vvvv = logging.ERROR
                -vvvvv = logging.CRITICAL

Output:       File which has the institution_id, Merchant ID,
              amount requested to release,
              actual amount planned or released and
              cycle

Return:   0 = Success
          !0 = Exit with errors
'''

# The following are pylint directives to suppress some pylint warnings that you
# do not care about.
# pylint: disable = invalid-name
# pylint: disable = protected-access
# pylint: disable = no-self-use

import os
import sys

sys.path.append('/clearing/filemgr/MASCLRLIB')
from database_class import DbClass
from reserve import ReserveClass

class LocalException(Exception):
    """
    Name : LocalException
    Description:A local exception class to post exceptions local to this module.
                The local exception class is derived from the Python base
                exception class. It is used to throw other types of exceptions
                that are not in the standard exception class.
    """

    # Constructor or Initializer
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.value)

if __name__ == "__main__":
    """
    Name : main
    Description: This script release reserve amount from the merchant
    Arguments: input file, mode, verbosity level and cycle
    """
    try:
        reserve_object = ReserveClass('release_reserve_fund')

        #Parse the command line arguments
        arg_list = reserve_object.parse_arguments()
        reserve_object.mode = arg_list.mode
        print('MODE:', reserve_object.mode)

        #if the MODE is not passed default to ALL ( cycle 1 and 5)
        if arg_list.cycle != "ALL":
            reserve_object.cycle = arg_list.cycle + " "
        else:
            reserve_object.cycle = arg_list.cycle
        print('CYCLE:', reserve_object.cycle)

        #test mode override the default mail id
        if arg_list.test:
            reserve_object.email_config_file = arg_list.test
            print('email config file name: ', arg_list.test)

        #set logger object verbose level by default set to warning level
        if arg_list.verbose:
            log_res = reserve_object.set_logger_level(arg_list.verbose)
        else:
            log_res = reserve_object.set_logger_level(3) 
        print('set_logger_level result - ', log_res)

        if not log_res:
            raise LocalException("Unable to create a logger object")

        #Open database connection
        db_object = DbClass(ENV_HOSTNM='IST_HOST', \
                            ENV_USERID='IST_DB_USERNAME', \
                            PORTNO='1521', \
                            ENV_PASSWD='IST_DB_PASSWORD', \
                            ENV_SERVNM='IST_SERVERNAME')
        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription\
                                            (db_object.errorCode))

        print('Database credentials', db_object._DbClass__dbCredentials)
        db_object.Connect()

        if db_object.errorCode:
            raise LocalException(db_object.GetErrorDescription\
                                            (db_object.errorCode))

        print('Database connection: ', db_object.dbConnection)
        #Merchant id and the amount read from the input file
        #if the file name is not passed in command line
        #check IN directory has file for today date
        if arg_list.input_file:
            print('File to process:', arg_list.input_file)
            reserve_object.process_reserve(db_object, arg_list.input_file)
            mv_cmd = "mv " + arg_list.input_file + " ARCHIVE/"
            os.system(mv_cmd)
        else:
            in_file_list = reserve_object.get_reserve_file_name()
            if in_file_list:
                for in_file_name in in_file_list:
                    print('File to process:', in_file_name)
                    reserve_object.process_reserve(db_object, in_file_name)
                    mv_cmd = "mv " + in_file_name + " ARCHIVE/"
                    os.system(mv_cmd)
            else:
                print('No files to process in IN directory for today')

        db_object.Disconnect()
    except LocalException as err:
        err_msg = 'Error: During database connection or execution of \
                        reserve {}'.format(err)
        print(err_msg)
        reserve_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
    except Exception as err:
        err_msg = 'Error: During execution of reserve inside main function {}'\
                       .format(err)
        print(err_msg)
        reserve_object.send_alert(err_msg)
        db_object.Disconnect()
        sys.exit()
