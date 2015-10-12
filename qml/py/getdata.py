#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, inspect
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"libs")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import json, requests, pyotherside

def dyorg (url):
    try:
        resp = requests.get(url, timeout = 25.0)
        return resp.text
    except requests.exceptions.ConnectionError as e:
        pyotherside.send("These aren't the domains we're looking for.")
    except requests.exceptions.ConnectTimeout as e:
        pyotherside.send("Too slow Mojo!")
    except requests.exceptions.ReadTimeout as e:
        pyotherside.send("Waited too long between bytes.")
    except requests.exceptions.HTTPError as e:
        pyotherside.send("And you get an HTTPError:", e.message)
