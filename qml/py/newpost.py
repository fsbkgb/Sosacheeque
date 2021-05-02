#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests, pyotherside
from hashlib import sha256

def sendpost (domain, cap_type, board, thread, comment, captcha, string7, email, name, subject, icon, image1, image2, image3, image4):
    url = 'https://2ch.' + domain + '/makaba/posting.fcgi?json=1'
    #url ='http://ptsv2.com/'
    r = str(bytes([95, 114, 101, 115, 112, 111, 110, 115, 101]), 'utf-8')
    if cap_type == "2ch" and thread != "0":
        c_type = "app"
        c_id = c_type + r + "_id"
        c_hash = hash(captcha, string7)
    else:
        c_type = "recaptcha"
        c_id = "g-recaptcha-response"
        c_hash = ""

    post = [('task', "post"), ('board', board), ('thread', thread), ('comment', comment), ('captcha_type', c_type), (c_id, captcha), (c_type + r, c_hash), ('email', email), ('name', name), ('subject', subject), ('icon', icon)]
    multiple_files = {}
    if image1 != '':
        file1 = open(image1, 'rb')
        multiple_files['image1'] = file1
    else:
        multiple_files[''] = ''

    if image2 != '':
        file2 = open(image2, 'rb')
        multiple_files['image2'] = file2

    if image3 != '':
        file3 = open(image3, 'rb')
        multiple_files['image3'] = file3

    if image4 != '':
        file4 = open(image4, 'rb')
        multiple_files['image4'] = file4

    session = requests.session()
    session.headers['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0'
    r = session.post(url, data=post, files=multiple_files)
    pyotherside.send(r.status_code)
    return r.text

def hash (spasiba, abu):
    return sha256((spasiba + '|' + abu).encode('utf-8')).hexdigest()
