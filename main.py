#!/usr/bin/env python3

from lib.member import Member
from lib.config import Config
from lib.hs_session import HsSession
 
config = Config()
config.loadConfig()
url = "{0}{1}".format(config.settings["base_url"], config.settings["api_path"])
print(url)
session = HsSession("D2B84BB5")
session.post(url)
