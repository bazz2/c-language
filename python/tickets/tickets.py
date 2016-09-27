#! /usr/bin/env python3

""" Train tickets query via command-line.

Usage:
    tickets [-gdtkz] <from> <to> <date>

Options:
    -h, --help  show this information and exit
    -g          Gao Tie
    -d          Dong che
    -t          Te Kuai
    -k          Kuai Su
    -z          Zhi Da

Example:
    tickets beijing shanghai 2016-08-25

"""

import requests
import json
from docopt import docopt
from stations import stations
from prettytable import PrettyTable

class TrainCollection(object):
    header = 'train station time duration first second softsleep hardsleep hardsit'.split()
    def __init__(self, rows):
        self.rows = rows

    def _get_duration(self, row):
        duration = row.get('lishi').replace(':', 'h') + 'm'
        if duration.startswitch('00'):
            return duration[4:]
        if duration.startswitch('0'):
            return duration[1:]
        return duration

    def colored(color, text):
        table = {
            'red': '\033[91m',
            'green': '\033[92m',
            'nc': '\033[0m', # no color
        }
        cv = table.get(color)
        nc = table.get('nc')
        return ''.join([cv, text, nc])

    @property
    def trains(self):
        print(1)
        for row1 in self.rows:
            row = row1['queryLeftNewDTO']
            print(2)
            print(row['station_train_code'], row['from_station_name'], row['to_station_name'], row['start_time'], row['arrive_time'])
            """
            train = [
                row['station_train_code'],
                '\n'.join([colored('green', row['from_station_name']), colored('red', row['to_station_name']) ]),
                '\n'.join([colored('green', row['start_time']), colored('red', row['arrive_time']) ]),
                self._get_duration(row),
                row['zy_num'],
                row['ze_num'],
                row['rw_num'],
                row['yw_num'],
                row['yz_num']
            ]
            yield train
            """

    def pretty_print(self):
        pt = PrettyTable()
        pt._set_field_names(self.header)
        """
        for train in self.trains:
            print("========", type(train))
            pt.add_row(train)
        print(pt)
        """


def cli():
    """ command-line interface """
    arguments = docopt(__doc__)
    from_station = stations.get(arguments['<from>']).split('|')
    to_station = stations.get(arguments['<to>']).split('|')
    date = arguments['<date>']

    url = 'https://kyfw.12306.cn/otn/leftTicket/queryT?leftTicketDTO.train_date={}&leftTicketDTO.from_station={}&leftTicketDTO.to_station={}&purpose_codes=ADULT'.format(
        date, from_station[0], to_station[0]
    )

    r = requests.get(url, verify=False)
    rows = r.json()['data']
    trains = TrainCollection(rows)
    trains.pretty_print()

    
if __name__ == '__main__':
    cli()
