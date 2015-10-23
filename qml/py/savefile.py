#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, requests

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
