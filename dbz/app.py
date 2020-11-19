# ===================
# Imports
# ===================

import os
from flask import Flask, render_template, url_for
from dotenv import load_dotenv

from flask_sqlalchemy import SQLAlchemy
from flask_pymongo import PyMongo
from neo4j import GraphDatabase

app = Flask(__name__)
load_dotenv()

# ===================
# Configs
# ===================

app.config['TEMPLATES_AUTO_RELOAD'] = True  # Force update on html on change
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("MYSQL_URI")
app.config['MONGO_URI'] = os.getenv("MONGO_URI")

NEO_USERNAME = os.getenv("NEO_USERNAME")
NEO_PASSWORD = os.getenv("NEO_PASSWORD")
NEO_URI = os.getenv("NEO_URI")

debug = True
port = 5000

# ===================
# DB Connections
# ===================

# MySQL
mysql_db = SQLAlchemy(app)

# MongoDB
mongo = PyMongo(app)

# Neo4j
neo_driver = GraphDatabase.driver(NEO_URI, auth=(NEO_USERNAME, NEO_PASSWORD))


# ===================
# Views
# ===================

@app.route('/')
def index():
    return render_template("index.html")


@app.route('/mysql')
def mysql():
    food = mysql_db.engine.execute("""SELECT * FROM country LIMIT 50""")
    return render_template("mysql.html", food=list(food))


@app.route('/mongo')
def mongo():
    print(mongo)
    return render_template("mongo.html")


@app.route('/neo')
def neo():
    print(neo_driver)
    return render_template("neo.html")


@app.route('/login')
def login():
    return render_template("login.html")


# ===================
# Main
# ===================

if __name__ == '__main__':
    app.run(debug=debug, port=port)