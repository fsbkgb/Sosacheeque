#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests

def sendpost (domain, board, thread, comment, captcha, captcha_value, email, name, subject, icon, image1, image2, image3, image4):
    url = 'https://2ch.' + domain + '/makaba/posting.fcgi?json=1'
    post = [('task', "post"), ('board', board), ('thread', thread), ('comment', comment), ('captcha_type', "2chaptcha"), ('2chaptcha_value', captcha_value), ('2chaptcha_id', captcha), ('email', email), ('name', name), ('subject', subject), ('icon', icon)]
    if image1 != '':
        file1 = open(image1, 'rb')
    else:
        file1 = ''
    if image2 != '':
        file2 = open(image2, 'rb')
    else:
        file2 = ''
    if image3 != '':
        file3 = open(image3, 'rb')
    else:
        file3 = ''
    if image4 != '':
        file4 = open(image4, 'rb')
    else:
        file4 = ''
    multiple_files = {'image1': file1, 'image2': file2, 'image3': file3,'image4': file4}
    r = requests.post(url, data=post, files=multiple_files)
    return r.text
