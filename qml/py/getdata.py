#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests, time, pyotherside, re

def dyorg (listener, type, url, usercode):
    session = requests.session()
    session.headers['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0'
    result = re.search(r'#(\d+)', url)
    if result:
        anchor = result.group(1)
    else:
        anchor = 0
    try:
        cookies = {'ageallow': '1', 'usercode_auth': usercode}
        resp = session.get(url, timeout = 40.0, cookies=cookies)
        if resp.status_code == requests.codes.ok:
            pyotherside.send(listener, type, "none", resp.text, anchor)
        else:
            pyotherside.send(listener, type, resp.status_code, "", anchor)
    except requests.exceptions.ConnectionError as e:
        pyotherside.send(listener, type, "connection error", "", anchor)
    except requests.exceptions.ConnectTimeout as e:
        pyotherside.send(listener, type, "connection error", "", anchor)
    except requests.exceptions.ReadTimeout as e:
        pyotherside.send(listener, type, "connection error", "", anchor)

def timeout (delay):
    time.sleep(delay)
