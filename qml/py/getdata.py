#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
