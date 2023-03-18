#!/usr/bin/env python
#-----------------------------------------------------------------------------------
# This python is to:
#   1. create http server for showing front 
# it is copied from internet and modified.
#
# Author: Hao Feng (F1)
#
# Init Date:   Dec. 15, 2022
# Last Date:   Dec. 15, 2022
#
# Copyright (c) 2022-, FATAVAY CO., LTD.

#-----------------------------------------------------------------------------------

try:
    # Python 3
    from http.server import HTTPServer, SimpleHTTPRequestHandler, test as test_orig
    import sys

    def test(*args):
        test_orig(*args, port=int(sys.argv[1]) if len(sys.argv) > 1 else 8000)
except ImportError:
    from BaseHTTPServer import HTTPServer, test
    from SimpleHTTPServer import SimpleHTTPRequestHandler


class CORSRequestHandler (SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        SimpleHTTPRequestHandler.end_headers(self)


if __name__ == '__main__':
    test(CORSRequestHandler, HTTPServer)
