USE covid;

# Continent
INSERT IGNORE INTO DIM_continent (continent_id, name)
SELECT continent_id, continent AS name
FROM `covid_temp`;

# Country
INSERT IGNORE INTO DIM_country (iso_code, continent_id, name)
SELECT iso_code, continent_id, location AS name
FROM `covid_temp`;

# Date
INSERT IGNORE INTO DIM_date (date, day_of_week, day, month, year)
SELECT date, day_of_week, day, month, year
FROM `covid_temp`;

# Events
INSERT INTO DIM_events (iso_code, date, new_cases, new_deaths, new_tests)
SELECT iso_code, date, new_cases, new_deaths, new_tests
FROM `covid_temp`;

# Statistics
INSERT IGNORE INTO DIM_statistics (iso_code, population, population_density, median_age,
                            aged_65_older, gdp_per_capita, extreme_poverty,
                            cardiovasc_death_rate, diabetes_prevalence, female_smokers,
                            male_smokers, life_expectancy, human_development_index)
SELECT iso_code, population, population_density, median_age, aged_65_older,
       gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence,
       female_smokers, male_smokers, life_expectancy, human_development_index
FROM `covid_temp`;