#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, inspect
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"libs")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import requests

def getdirs (dir):
    dirs = []
    if os.path.abspath(dir) != os.getenv('HOME'):
        dirs.append("..")
    dirs = dirs + next(os.walk(dir))[1]
    return dirs

def save (dir, name, url):
    response = requests.get(url)
    if response.status_code == 200:
        f = open(os.path.abspath(dir) + "/" + name, 'wb')
        f.write(response.content)
        f.close()
