/*
 UPDATE QUERIES
 - Execute this script to update the existing database.
 - Client must have the target .csv file locally.
 */


# PREREQUISITES
SHOW GLOBAL VARIABLES LIKE 'local_infile';  # Must be 'ON' for this script to work
# Client-side must set the flag 'allowLoadLocalInfile' = TRUE

USE covid;
DROP TABLE IF EXISTS covid_temp;

# Create a temporary table, removed at the end of script or when session terminates
CREATE TEMPORARY TABLE covid_temp
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


# Load data into covid_temp - Insert correct path to .csv file
# LOAD DATA LOCAL INFILE 'C:/Users/Trong/gitter/dbz-flask/data/owid-covid-2020-11-18.csv'
LOAD DATA LOCAL INFILE 'C:/Users/Trong/gitter/dbz-flask/data/owid-covid-2020-12-02.csv'
    INTO TABLE covid_temp
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES;

# Preprocessing
DELETE
FROM covid_temp
WHERE iso_code = 'OWID_WRL'
   OR iso_code IS NULL
   OR iso_code = '';


# UPDATE EXISTING DIMENSION-TABLES BY INSERTION AND IGNORE IF ALREADY EXISTS

# Continent
INSERT IGNORE INTO DIM_continent (continent_id, name)
SELECT DISTINCT 0, continent
FROM covid_temp;

# Country
INSERT IGNORE INTO DIM_country (iso_code, continent_id, name)
SELECT DISTINCT iso_code, DIM_continent.continent_id, location AS name
FROM covid_temp,
     DIM_continent
WHERE covid_temp.continent = DIM_continent.name;

# Date
INSERT IGNORE INTO DIM_date (date, day_of_week, day, month, year)
SELECT DISTINCT date, WEEKDAY(date), DAY(date), MONTH(date), YEAR(date)
FROM covid_temp;

# Events
INSERT IGNORE INTO DIM_events (iso_code, date, new_cases, new_deaths, new_tests)
SELECT DIM_country.iso_code, DIM_date.date, new_cases, new_deaths, new_tests
FROM covid_temp,
     DIM_country,
     DIM_date
WHERE covid_temp.iso_code = DIM_country.iso_code
  AND covid_temp.date = DIM_date.date;

# Statistics
INSERT IGNORE INTO DIM_statistics (iso_code, population, population_density, median_age,
                                   aged_65_older, gdp_per_capita, extreme_poverty,
                                   cardiovasc_death_rate, diabetes_prevalence, female_smokers,
                                   male_smokers, life_expectancy, human_development_index)
SELECT DISTINCT DIM_country.iso_code,
       population,
       population_density,
       median_age,
       aged_65_older,
       gdp_per_capita,
       extreme_poverty,
       cardiovasc_death_rate,
       diabetes_prevalence,
       female_smokers,
       male_smokers,
       life_expectancy,
       human_development_index
FROM covid_temp, DIM_country
WHERE covid_temp.iso_code=DIM_country.iso_code;

# Drop covid_temp
DROP TABLE IF EXISTS covid_temp;
