#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, inspect
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"libs")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import requests

def sendpost (domain, board, thread, comment, captcha, captcha_value):
    #url = 'https://posttestserver.com/post.php'
    url = 'https://2ch.' + domain + '/makaba/posting.fcgi?json=1'
    post = [('task', "post"), ('board', board), ('thread', thread), ('comment', comment), ('captcha', captcha), ('captcha_value', captcha_value)]
    multiple_files = {'image1': ('', '',''), 'image2': ('', '', ''), 'image3': ('', '', ''),'image4': ('', '', '')}
    r = requests.post(url, data=post, files=multiple_files)
    return r.text
