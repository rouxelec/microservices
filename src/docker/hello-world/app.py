from flask import Flask, render_template
import os
import random

app = Flask(__name__)


@app.route("/")
def index():
    url = random.choice(images)
    return "Hello, World!"