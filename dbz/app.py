# ===================
# Imports
# ===================

import os
import json

from flask import Flask, render_template, url_for, jsonify, request
from dotenv import load_dotenv

from flask_sqlalchemy import SQLAlchemy
from flask_pymongo import PyMongo

# Neo4j Imports
from dbz.neo4j_source.neo4j_app import CustomNeoApp

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
neo_driver = CustomNeoApp(NEO_URI, NEO_USERNAME, NEO_PASSWORD)


# ===================
# Views
# ===================

@app.route('/')
def index():
    return render_template("home.html")


@app.route('/mysql')
def mysql():
    return render_template("mysql.html")


@app.route('/mongo')
def mongo():
    print(mongo)
    return render_template("mongo.html")


@app.route('/neo')
def neo():
    return render_template("neo.html")


@app.route('/login')
def login():
    return render_template("login.html")


# ===================
# API Calls
# ===================

"""
    Fyll inn query som henter:
        
        location, sum(new_cases), sum(new_deaths), sum(tests)
    
    Dataen skal formateres slik:
    
        data = [
            {confirmed: 43123, deaths: 213123, location: afgh, tests: 12312}
        ]
        
"""

@app.route('/api-test', methods=["GET"])
def api_test():
    """
    Eksempel endpoint som blir kalt i home.js (api_call_example)
    :return:
    """
    dict_of_items = {
        "test": 123,
        "helo": "wrld"
    }

    return jsonify(dict_of_items)


@app.route('/mysql-stats', methods=["GET"])
def mysql_stats():
    query = """
    SELECT location, SUM(new_cases) as confirmed, SUM(new_deaths) as deaths, SUM(new_tests) as tests
    FROM country
    GROUP BY location
    """

    resultproxy = mysql_db.engine.execute(query)

    return jsonify([dict(row) for row in resultproxy])


@app.route('/mongo-stats', methods=["GET"])
def mongo_stats():

    return jsonify("false")


@app.route('/neo-stats', methods=["GET"])
def neo_stats():
    data = neo_driver.get_common_summary()
    return jsonify(data)


# ===================
# Site specific api calls
# ===================

@app.route('/neo/country', methods=["GET"])
def neo_country():
    countries_continents = neo_driver.get_countries_continents()
    return jsonify(countries_continents)


@app.route('/neo/continent', methods=["GET"])
def neo_continent():
    continent_name = request.args.get('name')
    continent_name = continent_name.title()  # Properly capitalize
    continent_stats = neo_driver.get_continent_stats(continent_name)
    return jsonify(continent_stats)


# ===================
# Main
# ===================

if __name__ == '__main__':
    app.run(debug=debug, port=port)
