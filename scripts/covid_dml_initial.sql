# This script can be executed locally, but make sure to enable "local_infile" variable on the server and client.

USE covid;
DROP TABLE IF EXISTS covid_temp;

# Create a temporary table
create table covid_temp
(
    iso_code                           text  null,
    continent                          text  null,
    location                           text  null,
    date                               date  null,
    total_cases                        float null,
    new_cases                          float null,
    new_cases_smoothed                 float null,
    total_deaths                       float null,
    new_deaths                         float null,
    new_deaths_smoothed                float null,
    total_cases_per_million            float null,
    new_cases_per_million              float null,
    new_cases_smoothed_per_million     float null,
    total_deaths_per_million           float null,
    new_deaths_per_million             float null,
    new_deaths_smoothed_per_million    float null,
    reproduction_rate                  float null,
    icu_patients                       text  null,
    icu_patients_per_million           text  null,
    hosp_patients                      text  null,
    hosp_patients_per_million          text  null,
    weekly_icu_admissions              text  null,
    weekly_icu_admissions_per_million  text  null,
    weekly_hosp_admissions             text  null,
    weekly_hosp_admissions_per_million text  null,
    total_tests                        text  null,
    new_tests                          float null,
    total_tests_per_thousand           text  null,
    new_tests_per_thousand             text  null,
    new_tests_smoothed                 text  null,
    new_tests_smoothed_per_thousand    text  null,
    tests_per_case                     text  null,
    positive_rate                      text  null,
    tests_units                        text  null,
    stringency_index                   float null,
    population                         float null,
    population_density                 float null,
    median_age                         float null,
    aged_65_older                      float null,
    aged_70_older                      float null,
    gdp_per_capita                     float null,
    extreme_poverty                    text  null,
    cardiovasc_death_rate              float null,
    diabetes_prevalence                float null,
    female_smokers                     text  null,
    male_smokers                       text  null,
    handwashing_facilities             float null,
    hospital_beds_per_thousand         float null,
    life_expectancy                    float null,
    human_development_index            float null
);


# Load data into covid_temp
LOAD DATA LOCAL INFILE '/home/bao/dev/dbz-flask/data/owid-covid-2020-11-18.csv'
    INTO TABLE covid_temp
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

# Preprocessing
DELETE
FROM covid_temp
WHERE iso_code = 'OWID_WRL'
   OR iso_code IS NULL
   OR iso_code = '';