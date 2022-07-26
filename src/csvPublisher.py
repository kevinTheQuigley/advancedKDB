#!/usr/bin/env python2

import datetime
import numpy
import sys
import time
import subprocess

#rc = subprocess.call("sleep.sh")

from qpython import qconnection
from qpython.qcollection import qlist
from qpython.qtype import QException, QTIME_LIST, QSYMBOL_LIST, QFLOAT_LIST,QSYMBOL
from numpy import genfromtxt



convs = dict.fromkeys([0, 1], bytes.decode)

def exportCSV(filename):
        #data = genfromtxt(filename, delimiter=',', dtype=("U7", float, float,int,int), skip_header=1,converters =convs)
        data = genfromtxt(filename, delimiter=',', dtype=None,skip_header=1,encoding=None)
        return data

global sLine
def check():
    with open('env.sh') as f:
        datafile = f.readlines()
    for line in datafile:
        if "PORT_TP" in line:
            global portLine
            # found = True # Not necessary
            portLine=line
check()
sLine=portLine.split("=", 10)
tpPort=sLine[-1]
tpPort = int(tpPort)


if __name__ == '__main__':
    with qconnection.QConnection(host='localhost', port=tpPort) as q:
        print(q)
        print('IPC version: %s. Is connected: %s' % (q.protocol_version, q.is_connected()))
        data = q.sendSync('{`long$ til x}', 10)
        print('type: %s, numpy.dtype: %s, meta.qtype: %s, data: %s ' % (type(data), data.dtype, data.meta.qtype, data))

        for row in exportCSV('./Quote.csv'):
            print(row[0])
  
            tick = [numpy.string_(row[0]),
                    numpy.float_(row[1]),
                    numpy.float_(row[2]),
                    numpy.int_(row[3]),
                    numpy.int_(row[4])] 
            print('Publishing row of tick data')
            print(tick)
            q.sendSync('.u.upd', numpy.string_('Quote'), tick)
            #q.sendSync('.u.upd', numpy.string_('Quote').decode("UTF-8"), tick)
            time.sleep(1)

with qconnection.QConnection(host='localhost', port=6800) as q:
    print(q)
    print('IPC version: %s. Is connected: %s' % (q.protocol_version, q.is_connected()))
