#!/usr/bin/env python3

import urllib3
import json

class HsSession():
    uid = ""
    data = {}

    def __init__(self, UID):
        self.uid = UID

    def post(self, url):
        http = urllib3.PoolManager()
        data = {"uid" : self.uid}
        encoded_data = json.dumps(data).encode("utf-8")
        r = http.request('POST',
                         url,
                         body = encoded_data,
                         headers = {'Content-Type' : 'application/json'})
        if not (r.status = 200):
		print("Error - uid {0} not found").format(self.uid)




