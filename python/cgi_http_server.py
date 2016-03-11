import BaseHTTPServer
import CGIHTTPServer

HOST = ''
PORT = 8001

server = BaseHTTPServer.HTTPServer((HOST, PORT), CGIHTTPServer.CGIHTTPRequestHandler)
server.serve_forever()
