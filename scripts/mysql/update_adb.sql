USE covid_adb;


REPLACE INTO FACT_country_events (iso_code, continent_id, population, median_age, total_cases, total_deaths,
                                  total_tests)
SELECT DISTINCT C.iso_code,
                CC.continent_id,
                S.population,
                S.median_age,
                SUM(E.new_cases) AS cases,
                SUM(E.new_deaths),
                SUM(E.new_tests)
FROM covid.DIM_country C
         INNER JOIN covid.DIM_continent CC ON C.continent_id = CC.continent_id
         NATURAL JOIN covid.DIM_statistics S
         NATURAL JOIN covid.DIM_events E
GROUP BY C.iso_code, CC.continent_id, C.name;


REPLACE INTO FACT_continent_events (continent_id, total_cases, total_deaths, total_tests)
SELECT DISTINCT ce.continent_id, SUM(ce.total_cases), SUM(ce.total_deaths), SUM(ce.total_tests)
FROM covid_adb.FACT_country_events AS ce
GROUP BY ce.continent_id;


REPLACE INTO FACT_per_million_events (iso_code, cases_per_million, deaths_per_million, tests_per_million)
SELECT DISTINCT ce.iso_code,
                ce.total_cases / (ce.population / 1000000),
                ce.total_deaths / (ce.population / 1000000),
                ce.total_tests / (ce.population / 1000000)
FROM covid_adb.FACT_country_events AS ce
GROUP BY ce.iso_code;

# DATE FACT TABLE INSERTS
REPLACE INTO FACT_events_date (date, total_cases, total_deaths, total_tests)
SELECT DISTINCT date,
                SUM(new_cases),
                SUM(new_deaths),
                SUM(new_tests)
FROM covid.DIM_country
         NATURAL JOIN covid.DIM_events
GROUP BY date;


REPLACE INTO FACT_events_year_month (year, month, total_cases, total_deaths, total_tests)
SELECT DISTINCT YEAR(date),
                MONTH(date),
                SUM(total_cases),
                SUM(total_deaths),
                SUM(total_tests)
FROM FACT_events_date
GROUP BY YEAR(date), MONTH(date);
