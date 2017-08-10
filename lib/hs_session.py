#!/usr/bin/env python3

import urllib3
import json
import time
import RPi.GPIO as GPIO

def beep(length):
    beeper = 18
    GPIO.setup(beeper, GPIO.OUT)
    GPIO.output(beeper,GPIO.HIGH)
    time.sleep(length)
    GPIO.output(beeper,GPIO.LOW)    

class HsSession():
    uid = ""
    data = {}

    def __init__(self, UID):
        self.uid = UID

    def post(self, url):
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
        http = urllib3.PoolManager()
        data = {"uid" : self.uid}
        encoded_data = json.dumps(data).encode("utf-8")
        r = http.request('POST',
                         url,body = encoded_data,
                         headers = {"Content-Type" : "application/json"})
        beep(1)
        return r.status
