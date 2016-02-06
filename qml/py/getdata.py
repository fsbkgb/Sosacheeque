#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests, time, pyotherside

def dyorg (listener, type, url):
    session = requests.session()
    session.headers['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0'
    try:
        resp = session.get(url, timeout = 25.0)
        if resp.status_code == requests.codes.ok:
            pyotherside.send(listener, type, "none", resp.text)
        else:
            pyotherside.send(listener, type, resp.status_code, "")
    except requests.exceptions.ConnectionError as e:
        pyotherside.send(listener, type, "connection error", "")
    except requests.exceptions.ConnectTimeout as e:
        pyotherside.send(listener, type, "connection error", "")
    except requests.exceptions.ReadTimeout as e:
        pyotherside.send(listener, type, "connection error", "")

def timeout (delay):
    time.sleep(delay)
