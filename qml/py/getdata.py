#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests

def dyorg (url):
    session = requests.session()
    session.headers['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0'
    try:
        resp = session.get(url, timeout = 25.0)
        if resp.status_code == requests.codes.ok:
            return { 'error':"none", 'response':resp.text }
        else:
            return { 'error':resp.status_code, 'response':resp.text }
    except requests.exceptions.ConnectionError as e:
        return { 'error':"Connection Error", 'response':resp.text }
    except requests.exceptions.ConnectTimeout as e:
        return { 'error':"Connection Error", 'response':resp.text }
    except requests.exceptions.ReadTimeout as e:
        return { 'error':"Connection Error", 'response':resp.text }
