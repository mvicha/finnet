from flask import Flask
import urllib.request
import os

app = Flask(__name__)

@app.route('/')
def hello():
  url = "http://{}:8181/approve".format(os.environ['env'])
  contents = urllib.request.urlopen(url).read()
  return contents

