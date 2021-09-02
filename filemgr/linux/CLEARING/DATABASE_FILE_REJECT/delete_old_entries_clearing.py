#!/usr/bin/env python
#pylint: disable = invalid-name
#pylint: disable = protected-access
#pylint: disable = no-self-use
#pylint: disable = line-too-long
'''

File Name:  delete_old_entries.py
Description:  This Script generates the sql delete script  for a given number of year.
Arguments:   -year -> Number of year
             -month -> Number of Month
Output:       Sql Delete Script
Return:   0 = Success
          !0 = Exit with errors
'''
#!/usr/bin/env python
import sys
import argparse
from datetime import date , datetime
from dateutil.relativedelta import relativedelta


class LocalException(Exception):
    """
    Name : LocalException
    Description: A local exception class to post exceptions local to this module.
                 The local exception class is derived from the Python base exception
                 class. It is used to throw other types of exceptions that are not
                 in the standard exception class.
    """

    # Constructor or Initializer
    def __init__(self, errorValue):
        super(LocalException, self).__init__(errorValue)
        self.value = errorValue

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.value)





class DeleteOldEntries():
    """
    Name : DeleteOldEntries
    Description : DeleteOldEntries class is used to generate sql script
    Argument: None
    Returns : Number of Years
    """
    #private variable
    arguments = []

    def parse_arguments(self):
        """
        Name : parse_arguments
        Arguments: none
        Description : Parses the command line arguments
        Returns: arg_parser args
        """
        try:
            all_args = argparse.ArgumentParser()

            all_args.add_argument("year", help="Number of years")
            all_args.add_argument("month" , help = "Number of Months" )
            args = all_args.parse_args()
            self.arguments.append(args.year)
            self.arguments.append(args.month)

        except:
            print('You failed to provide number of year as input ' \
            'on the command line!')
            sys.exit(1)



    def get_date(self) :
        """
        Name : get_date
        Arguments: Number of year and Months
        Description : It will Returns the Date
        Returns: String
        """
        year = int(self.arguments[0])
        month = int(self.arguments[1])
        dt_temp = date.today()
        new_date = dt_temp + relativedelta(years=-year , months=-month)
        dt_new = new_date.strftime("%d-%b-%Y")
        dt_new = dt_new.upper()
        return dt_new


    def generate_script(self):
        """
        Name : generate_script
        Arguments: None
        Description : It will Generate the Sql Script with delete commands
        Returns: Sql File
        """
        print(self.arguments)

        new_date = self.get_date()
        print(new_date)

        file_name = 'delete_old_entries_clearing_{}.sql'.format(datetime.now().strftime('%Y%m%d%H%M%S'))
        print(file_name)

        with open('delete_old_entries_template.sql', mode='r') as sqlfile:
            sqline = sqlfile.readlines()
            sqline[0] = sqline[0].replace('01-JAN-1000', new_date)
            with open(file_name, mode='w') as creatsql:
                creatsql.writelines(sqline)

        return file_name


if __name__ == "__main__":
    """
    Name : main
    Description : This script create sql queries script to delete old entries
    Arguments : Number of years to delete
    Output: Sql Delete Script
    """

    try:
        delete_entries_object = DeleteOldEntries()

        delete_entries_object.parse_arguments()

        OUT_FILE_NAME = delete_entries_object.generate_script()

        print(OUT_FILE_NAME)



    except Exception as err:
        ERR_MSG = 'Error: During execution of delete_old_entries inside main function {}'.format(err)
        print(ERR_MSG)
        sys.exit()
