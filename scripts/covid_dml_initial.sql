# This script must be executed locally on the server, and not remotely.
# The MySQL server is running with this variable enabled to limit the effect of data import and export operations.

USE covid;

# Create a temporary table
CREATE TABLE covid_temp
(
    iso_code                TEXT  NULL,
    continent               TEXT  NULL,
    location                TEXT  NULL,
    date                    TEXT  NULL,
    new_cases               INT   NULL,
    new_deaths              INT   NULL,
    new_tests               INT   NULL,
    population              INT   NULL,
    population_density      FLOAT NULL,
    median_age              FLOAT NULL,
    aged_65_older           FLOAT NULL,
    gdp_per_capita          FLOAT NULL,
    extreme_poverty         FLOAT NULL,
    cardiovasc_death_rate   FLOAT NULL,
    diabetes_prevalence     FLOAT NULL,
    female_smokers          FLOAT NULL,
    male_smokers            FLOAT NULL,
    life_expectancy         FLOAT NULL,
    human_development_index FLOAT NULL,
    continent_id            INT   NULL,
    day_of_week             INT   NULL,
    day                     INT   NULL,
    month                   INT   NULL,
    year                    INT   NULL
);

# Load data into covid_temp
LOAD DATA LOCAL INFILE 'covid_preprocessed.csv'
    INTO TABLE covid_temp
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
