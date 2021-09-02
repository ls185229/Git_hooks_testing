#!/usr/bin/env python
'''
$Id: revert_back_reserve_setup.py 4893 2019-09-24 19:30:24Z skumar $
$Rev: 4893 $
File Name:  revert_back_reserve_setup.py

Description:  This script revert back the reserve setup after the
              reserve is released

Running options:

Shell Arguments:
          -f = File name which holds the Merchant ID
                and amount to release(Optional)
          -m = MODE (Required)
          -c = CYCLE (Optional)
          -t = Test email configuration file name (Optional)
          -v = Verbosity level (Optional)
                        -v = logging.DEBUG
                        -vv = logging.INFO
                        -vvv = logging.WARNING
                        -vvvv = logging.ERROR
                        -vvvvv = logging.CRITICAL

Output:       mail is sent to accounting

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
    Description: A local exception class to post exceptions local to this
                 module. The local exception class is derived from the Python
                 base exception class. It is used to throw other types of
                 exceptions that are not in the standard exception class.
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
    Description: This script revert back the reserve setup
                 after the reserve is released
    Arguments: input file, mode, verbosity level and cycle
    """
    try:
        revert_object = ReserveClass('revert_back_reserve_setup')
        arg_list = revert_object.parse_arguments()
        revert_object.mode = arg_list.mode
        print('MODE:', revert_object.mode)
        if arg_list.cycle != "ALL":
            revert_object.cycle = arg_list.cycle + " "
        else:
            revert_object.cycle = arg_list.cycle
        print('CYCLE:', revert_object.cycle)

        #test mode override the default mail id
        if arg_list.test:
            revert_object.email_config_file = arg_list.test
            print('email config file name: ', arg_list.test)
        #set logger object verbose level by default set to warning level
        if arg_list.verbose:
            log_res = revert_object.set_logger_level(arg_list.verbose)
        else:
            log_res = revert_object.set_logger_level(3)
            
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
            #self.__lineNum = self.__GetLineNo() - 1
            raise LocalException( \
                db_object.GetErrorDescription(db_object.errorCode))

        print('Database credentials', db_object._DbClass__dbCredentials)
        db_object.Connect()

        if db_object.errorCode:
            #self.__lineNum = self.__GetLineNo() - 1
            raise LocalException( \
                db_object.GetErrorDescription(db_object.errorCode))

        print('Database connection: ', db_object.dbConnection)

        #Merchant id and the amount read from the input file
        if arg_list.input_file:
            print('File to process:', arg_list.input_file)
            revert_object.process_revert(db_object, arg_list.input_file)
        else:
            in_file_list = revert_object.get_revert_file_name()
            if in_file_list:
                for in_file_name in in_file_list:
                    print('File to process:', in_file_name)
                    revert_object.process_revert(db_object, in_file_name)
                    mv_cmd = "mv " + in_file_name + " ARCHIVE/"
                    os.system(mv_cmd)
            else:
                print('No files to process in IN directory for today')

        db_object.Disconnect()
    except LocalException as err:
        err_msg = 'Inside RevertReserve function, Exception is {}'.format(err)
        print(err_msg)
        revert_object.send_alert(err_msg)
        db_object.Disconnect()

    except Exception as err:
        err_msg = 'Error: During execution of reserve inside main function {}'\
                       .format(err)
        print(err_msg)
        revert_object.send_alert(err_msg)
        db_object.Disconnect()
