from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route('/')
def hello():
  return 'Hello, World!'

@app.route('/approve')
def showenv():
  varEnv = "This is <strong>{}</strong> host in <strong>{}</strong> environment<br><br>Settings are:<br>Tunning: <strong>{}</strong><br>Debug: <strong>{}</strong><br>External URL <strong>{}</strong>:<br>Client: <strong>{}</strong><br>Interaction Mode: <strong>{}</strong><br>Device ID: <strong>{}</strong>".format(socket.gethostname(), os.environ['env'], os.environ['Tunning'], os.environ['debug'], os.environ['exturl'], os.environ['client'], os.environ['intmode'], os.environ['device_id'])
  return varEnv