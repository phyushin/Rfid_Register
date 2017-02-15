#!/usr/bin/env python3
import json

class Member():
    
    def __init__(self, cardUID):
        self._cardUID = cardUID

    def CardUID(self):
        print(hex(self._cardUID))

    def Post(self):
        print("post to URL {0}".format(URL))
