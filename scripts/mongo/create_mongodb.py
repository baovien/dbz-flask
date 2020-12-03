"""
MongoDB creates databases and collections automatically for you if they don't exist already.
"""

import json
import os

import pandas as pd
from dotenv import load_dotenv
from pymongo import MongoClient

load_dotenv(dotenv_path="../../dbz/.env")

MONGO_URI = os.getenv("MONGO_URI")

client = MongoClient(MONGO_URI)
print("Connected.")
db = client["corona"]

# clear collections
if "data" in db.list_collection_names():
    db.drop_collection("data")

# create new collection
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

# read as pandas dataframe
df = pd.read_csv(f_name, usecols=cols, header=0)

# remove iso_code = OWID_WRl, NaN
df = df[(df["iso_code"] != "OWID_WRL") & (df["iso_code"].notna())]

# create date columns
df["date"] = df["date"].apply(pd.to_datetime)
df["day_of_week"] = df["date"].dt.dayofweek
df["day_of_week"] = df["day_of_week"].apply(lambda x: x+1)
df["day"] = df["date"].dt.day
df["month"] = df["date"].dt.month
df["year"] = df["date"].dt.year

json_df = df.to_json(orient='records')
json_data = json.loads(json_df)

# insert into mongodb
collection.insert_many(json_data)
