#!/usr/bin/env python
# coding: utf-8

import requests

ret = requests.post("http://localhost:8888/api/test/?", data={'args': 'abc'})
print ret.content

