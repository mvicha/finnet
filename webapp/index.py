from flask import Flask
import urllib.request

app = Flask(__name__)

@app.route('/')
def hello():
  contents = urllib.request.urlopen("http://dev:8181/approve").read()
  return contents
