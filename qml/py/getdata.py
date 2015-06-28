#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, inspect
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"libs")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import json, requests

def dyorg (url):
    resp = requests.get(url)
    return resp.text
