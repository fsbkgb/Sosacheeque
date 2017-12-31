#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests, pyotherside

def sendpost (domain, board, thread, comment, captcha, captcha_value, email, name, subject, icon, image1, image2, image3, image4):
    url = 'https://2ch.' + domain + '/makaba/posting.fcgi?json=1'
    #url ='http://posttestserver.com/post.php'
    post = [('task', "post"), ('board', board), ('thread', thread), ('comment', comment), ('captcha_type', "recaptcha"), ('2chaptcha_value', captcha_value), ('g-recaptcha-response', captcha), ('email', email), ('name', name), ('subject', subject), ('icon', icon)]
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
