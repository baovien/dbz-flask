"""
MongoDB creates databases and collections automatically for you if they don't exist already.
"""

import json
from datetime import datetime

import numpy as np
import pandas as pd
from pymongo import MongoClient

client = MongoClient("mongodb://167.99.255.7:27017/")
db = client["corona"]

if "data" in db.list_collection_names():
    db.drop_collection("data")

collection = db["data"]

cols = [
    'iso_code',
    'continent',
    'location',
    'date',
    'new_cases',
    'new_deaths',
    'new_tests',
    'population',
    'population_density',
    'median_age',
    'aged_65_older',
    'gdp_per_capita',
    'extreme_poverty',
    'cardiovasc_death_rate',
    'diabetes_prevalence',
    'female_smokers',
    'male_smokers',
    'life_expectancy',
    'human_development_index'
]

f_name = "../../data/owid-covid-2020-11-18.csv"

# read to pandas
df = pd.read_csv(f_name, usecols=cols, header=0)

# remove iso_code = OWID_WRl, NaN
df = df[(df["iso_code"] != "OWID_WRL") & (df["iso_code"].notna())]
# df["date"] = df["date"].apply(pd.to_datetime)

json_df = df.to_json(orient='records')
json_df = json.loads(json_df)
# json_df = df.to_dict('records')
collection.insert_many(json_df)

# Insert all data


# remove unwanted data
# collection.delete_many({'iso_code': 'OWID_WRL'})
# collection.delete_many({'iso_code': "null"})
