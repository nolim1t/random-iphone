#!/usr/bin/python

# Note writer v0.1a (bt@perceptionz.net)
# Requires Python 2.5 (Must have the sqlite3 library)


import logging
import sqlite3
import sys
import os
import time

notes_location = '/var/mobile/Library/Notes/notes.db'
#phone_time_executable = "/usr/local/bin/phonetime -n | cut -d: -f1"
logfile = 'scribble.log'
iphone_epoch = 978307238
current_epoch = int(time.time())
current_iphone_epoch = current_epoch - iphone_epoch

arg_array = sys.argv
args = len(arg_array) - 1 # get number of args

if args == 2:
    logging.basicConfig(level=logging.DEBUG, format='[%(asctime)s] %(levelname)s %(message)s', filename=logfile, filemod='w')
    logging.info('Creating Notes writer script')
    title = arg_array[1]
    body = arg_array[2]
    #cmd_result_obj = os.popen(phone_time_executable)
    #rr = cmd_result_obj.readline()
    #cmd_result = rr.rstrip()
    logging.debug('NEW ENTRY => Title:' + title + '; Body=' + body + '; Time=' + str(current_iphone_epoch))
    logging.debug('Opening connection to: ' + notes_location)
    sqlconn = sqlite3.connect(notes_location)
    cursor = sqlconn.cursor()
    logging.debug('Creating database cursor: cursor = sqlconn.cursor')
    stmt = "insert into note (creation_date, title, summary) values (" + str(current_iphone_epoch) + ",'" + title + "', '" + body + "')"
    logging.debug('SQL Query 1 => ' + stmt)
    cursor.execute(stmt)
    sqlconn.commit()
    logging.debug('Commit query')
    html_body = "<div style=\"font-family: Arial; font-size: 24pt;\"><b><u>" + title + "</u></b></div><div><br class=\"webkit-block-placeholder\"></div><div style=\"font-family:Trebuchet MS; font-size:12pt\">" + body + "</div>"
    logging.debug('HTML Body => ' + html_body)
    stmt = "insert into note_bodies (note_id, data) select MAX(note_id) + 1, '" + html_body + "' FROM note_bodies"
    logging.debug('SQL Query 2 => ' + stmt)
    cursor.execute(stmt)
    sqlconn.commit()
    logging.debug('Commit query')    
    cursor.close()
    logging.debug('Closing cursor')    
else:
    print 'Notes writer v0.1a (bt@perceptionz.net)'
    print 'Usage: ' + arg_array[0] + ' <title> <body>'
    print '(You if there are spaces you must put them in ""'
    print


