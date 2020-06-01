"""
This script fetches data updated in the google sheets and downloads it as a csv to 'sample/data' and then copies the
data to the database.
Before connecting to google sheets you need to set up a project through the google developers console and then create a
service account then ask for credentials for google sheets and google drive as a .json file which you then store in
'sample/config' as 'client_secret.json'.
"""


from sqlalchemy import create_engine
from exitstatus import ExitStatus
from datetime import datetime
import pygsheets as pyg
import pandas as pd
import logging
import yaml
import sys
import os

roots = os.path.realpath(os.path.dirname(os.getcwd()))
path = r'/config'
root_path = roots + path

if not os.path.exists(root_path):
    logging.info('Creating path')
    os.makedirs(root_path)
else:
    if os.path.exists(root_path + r'/database.yaml'):
        logging.info('File exists')
    else:
        logging.info('Creating file. Please fill in details')
        open(root_path + r'/database.yaml', 'w')

with open(root_path + r'/database.yaml') as file:
    # The FullLoader parameter handles the conversion from YAML
    # scalar values to Python the dictionary format
    db_list = yaml.load(file, Loader=yaml.FullLoader)


def get_sample_data():
    # connection to google sheets
    gs_connection = pyg.authorize(service_file=root_path + r'/client_secret.json')
    # connect to the specific google sheet: in this case sampledata
    main_sheet = gs_connection.open('sampledata')
    # select the worksheet you want from the sheet sampledata
    work_sheet = main_sheet[0]
    # create a pandas df and export as CSV
    sample_data = pd.DataFrame(work_sheet.get_all_records())
    sample_data.to_csv(roots + r'/data/sampledata_{0}.csv'.format(datetime.now().strftime('%y-%m-%d')))
    logging.info('Created CSV')
    return sample_data


def main(arg):
    try:
        sample_data = get_sample_data()
        engine = create_engine('postgresql://{0}:{1}@{2}:{3}/{4}'.format(db_list['user'],
                                                                         db_list['password'],
                                                                         db_list['host'],
                                                                         db_list['port'],
                                                                         db_list['database']))
        sample_data.to_sql(name='sampledata', con=engine, if_exists='replace', index=False)
    except Exception as err:
        logging.error(err)
        logging.error('Error while updating database')
        return sys.exit(ExitStatus.failure)
    else:
        logging.info('Ran successfully')
        return sys.exit(ExitStatus.success)


if __name__ == '__main__':
    args = sys.argv
    main(args)
