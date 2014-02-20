#!/usr/bin/python

import sys
import os
import csv
import SocketServer
import SimpleHTTPServer
import base64
import urllib
import httplib
import socket
from xml.dom.minidom import Document, parseString

TEST_STRING = "<AllResults><RecognitionResults><Result><symbol>X</symbol></Result></RecognitionResults></AllResults>"

class RecognitionServer(SimpleHTTPServer.SimpleHTTPRequestHandler):
    instance_id = 0

    def do_GET(self):
        """
        This will process a request which comes into the server.
        """
        self.send_response(httplib.OK, 'OK')
        self.send_header("Content-length", len(TEST_STRING))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(TEST_STRING)


if __name__ == "__main__":
    usage = "python ImageRecognitionServer <port number>"
    if(len(sys.argv) < 2):
        print usage
        sys.exit()

    HOST, PORT = "localhost", int(sys.argv[1])

    try:
        server = SocketServer.TCPServer(("", PORT), RecognitionServer)
    except socket.error, e:
        print e
        exit(1)
        
    print "Serving"
    server.serve_forever()
