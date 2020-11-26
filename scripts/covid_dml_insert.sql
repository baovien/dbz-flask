USE covid;

# Remove  iso_code = OWID_WRL and NaN
# Replicate continent_id
# (Convert date to DATE format)

# Continent
INSERT INTO DIM_continent (continent_id, name)
SELECT DISTINCT 0, continent
FROM covid_temp;

# Country
INSERT INTO DIM_country (iso_code, continent_id, name)
SELECT DISTINCT iso_code, DIM_continent.continent_id, location AS name
FROM covid_temp,
     DIM_continent
WHERE covid_temp.continent = DIM_continent.name;

# Date
INSERT INTO DIM_date (date, day_of_week, day, month, year)
SELECT DISTINCT date, WEEKDAY(date), DAY(date), MONTH(date), YEAR(date)
FROM covid_temp;

# Events
INSERT INTO DIM_events (iso_code, date, new_cases, new_deaths, new_tests)
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


