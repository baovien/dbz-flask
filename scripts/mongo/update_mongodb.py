"""
Update collections with new data
"""

import json
from datetime import datetime

import numpy as np
import pandas as pd
from pymongo import MongoClient

client = MongoClient("mongodb://167.99.255.7:27017/")
db = client["corona"]
collection = db["data"]
filepath = "../../data/owid-covid-2020-11-18.csv"


def csv_to_json(f_name, usecols=None, header=None):
    df = pd.read_csv(f_name, usecols=usecols, header=header)

    # remove iso_code = OWID_WRl, NaN
    df = df[(df["iso_code"] != "OWID_WRL") & (df["iso_code"].notna())]
    df["date"] = df["date"].apply(pd.to_datetime)

    return df.to_dict('records')


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

# Insert all data
collection.insert_many(csv_to_json(filepath, usecols=cols, header=0))

# remove unwanted data
# collection.delete_many({'iso_code': 'OWID_WRL'})
# collection.delete_many({'iso_code': np.nan})
