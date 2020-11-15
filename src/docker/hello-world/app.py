from flask import Flask, render_template
import os
import random

app = Flask(__name__)


@app.route("/")
def index():
    return "Hello, World!" , 200