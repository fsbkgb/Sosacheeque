#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, shutil, requests, re, pyotherside

def save (dst, filename, src):
    copyfile(src, dst + "/" + filename)

def cache (domain, path):
    cachedir = "/home/nemo/.cache/harbour-sosacheeque/harbour-sosacheeque/.media"
    filedir = re.search(r"(\/[0-9,a-z]+){3}", path).group(0)
    filepath = cachedir + path
    if not os.path.isfile(filepath):
        if not os.path.exists(cachedir + filedir):
            os.makedirs(cachedir + filedir)
        response = requests.get("https://2ch." + domain + path, stream=True)
        if response.status_code == 200:
            dl = 0
            total_length = int(response.headers.get('content-length'))
            pyotherside.send(total_length)
            f = open(filepath, 'wb')
            for data in response.iter_content(chunk_size=40960):
                dl += len(data)
                f.write(data)
                done = int(dl / total_length * 100)
                pyotherside.send(done)
            f.close()
    return filepath

def calccache ():
    cachedir = "/home/nemo/.cache/harbour-sosacheeque/harbour-sosacheeque/.media"
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(cachedir):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return sizeof_fmt(total_size)

def sizeof_fmt (num):
    for x in ['bytes','KB','MB','GB','TB']:
        if num < 1024.0:
            return "%3.1f%s" % (num, x)
        num /= 1024.0

def clearcache ():
    cachedir = "/home/nemo/.cache/harbour-sosacheeque/harbour-sosacheeque/.media"
    for the_folder in os.listdir(cachedir):
        folder_path = os.path.join(cachedir, the_folder)
        shutil.rmtree(folder_path)
