DROP DATABASE IF EXISTS covid_adb;

CREATE DATABASE IF NOT EXISTS covid_adb;

USE covid_adb;

DROP TABLE IF EXISTS FACT_country_events;
CREATE TABLE FACT_country_events
(
    iso_code     VARCHAR(20) NOT NULL,
    continent_id INT         NOT NULL,
    population   INT         NULL,
    median_age   FLOAT       NULL,
    total_cases  INT         NULL,
    total_deaths INT         NULL,
    total_tests  INT         NULL,
    PRIMARY KEY (iso_code),
    FOREIGN KEY (iso_code) REFERENCES covid.DIM_country (iso_code) ON DELETE CASCADE,
    FOREIGN KEY (continent_id) REFERENCES covid.DIM_continent (continent_id) ON DELETE CASCADE
);


DROP TABLE IF EXISTS FACT_continent_events;
CREATE TABLE FACT_continent_events
(
    continent_id INT NOT NULL,
    total_cases  INT NULL,
    total_deaths INT NULL,
    total_tests  INT NULL,
    PRIMARY KEY (continent_id),
    FOREIGN KEY (continent_id) REFERENCES FACT_country_events (continent_id) ON DELETE CASCADE
);


DROP VIEW IF EXISTS FACT_world_events;
CREATE VIEW FACT_world_events AS
SELECT SUM(total_cases) as total_cases,
       SUM(total_deaths) as total_deaths,
       SUM(total_tests) as total_tests
FROM FACT_continent_events;


DROP TABLE IF EXISTS FACT_per_million_events;
CREATE TABLE FACT_per_million_events
(
    iso_code           VARCHAR(20) NOT NULL,
    cases_per_million  INT         NULL,
    deaths_per_million INT         NULL,
    tests_per_million  INT         NULL,
    PRIMARY KEY (iso_code),
    FOREIGN KEY (iso_code) REFERENCES FACT_country_events (iso_code) ON DELETE CASCADE
);


# DATE FACT TABLES

DROP TABLE IF EXISTS FACT_events_date;
CREATE TABLE FACT_events_date
(
    date         DATE NOT NULL,
    total_cases  INT  NULL,
    total_deaths INT  NULL,
    total_tests  INT  NULL,
    PRIMARY KEY (date),
    FOREIGN KEY (date) REFERENCES covid.DIM_date (date) ON DELETE CASCADE
);

DROP TABLE IF EXISTS FACT_events_year_month;
CREATE TABLE FACT_events_year_month
(
    year         INT                                 NOT NULL,
    month        INT CHECK ( month BETWEEN 1 AND 12) NOT NULL,
    total_cases  INT                                 NULL,
    total_deaths INT                                 NULL,
    total_tests  INT                                 NULL,
    PRIMARY KEY (year, month)
);
