#!/usr/bin/env python3

from lib.member import Member
from lib.config import Config
from lib.hs_session import HsSession

from pirc522 import RFID

import lib.tag
import sys, getopt, signal, time

global run

def end_read(signal,frame):
    print("\nCtrl+C captured, ending read.")
    run = False
    rdr.cleanup()

def main(argv):
    #load configuration file
    config = Config()
    config.loadConfig()
    url = "{0}{1}".format(config.settings["base_url"], config.settings["api_path"])
    if len(argv) > 1:
        for arg in argv:
            print("cardUID:{0} found".format(arg))
            session = HsSession(arg)
            session.post(url)
    else:
        print ("Starting")
        while run:
            (error, data) = rdr.request()
            (error, uid) = rdr.anticoll()
            if not error:
                cardUID = (format(uid[0],"x")+format(uid[1],"x")+format(uid[2],"x")+format(uid[3],"x")).upper()
                session = HsSession(cardUID)
                session.post(url)
                time.sleep(10)
                signal.signal(signal.SIGINT, end_read)

if __name__ == "__main__":
    run = True
    rdr = RFID()
    util = rdr.util()
    util.debug = True
    main(sys.argv[1:])

