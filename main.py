#!/usr/bin/env python3
from lib.member import member
from pirc522 import RFID

run = True
rdr = RFID()
util = rdr.util()
util.debug = True

def end_read(signal,frame):
    global run
    print("\nCtril+C captured, ending read.")
    run = False
    rdr.cleanup()

signal.signal(signal.SIGINT, end_read)

while run:
    (error, uid) = rdr.anticoll()
    m = Member(uid)
    if not error:
        print("Card read UID:{0}".format(m.cardUID))
