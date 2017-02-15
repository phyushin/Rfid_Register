#!/usr/bin/env python3

import yaml


class Config():
    settings = {}

    def __init__(self):
        settings = {}
    
    def loadConfig(self):
        with open("config/config.yaml", 'r') as stream:
            try:
                c = yaml.load_all(stream)
                for setting in c:
                    for k, v in setting.items():
                        self.settings[k] = v
            except yaml.YAMLError as exc:
                print(exc)
