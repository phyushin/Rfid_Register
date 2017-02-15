#!/usr/bin/env python3

from lib.member import Member
from lib.config import Config
from lib.hs_session import HsSession
import sys, getopt

def main(argv):
    #load configuration file
    config = Config()
    config.loadConfig()
    url = "{0}{1}".format(config.settings["base_url"], config.settings["api_path"])
    for arg in argv:
        print("cardUID:{0} found".format(arg))
        session = HsSession(arg)
        session.post(url)

if __name__ == "__main__":
    main(sys.argv[1:])
