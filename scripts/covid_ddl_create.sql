DROP DATABASE IF EXISTS covid;

CREATE DATABASE IF NOT EXISTS covid;
USE covid;

# DROP tables
# SET FOREIGN_KEY_CHECKS = 0;
#
# DROP TABLE IF EXISTS DIM_country;
# DROP TABLE IF EXISTS DIM_continent;
# DROP TABLE IF EXISTS DIM_date;
# DROP TABLE IF EXISTS DIM_events;
# DROP TABLE IF EXISTS DIM_statistics;
#
# SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE DIM_continent
(
    continent_id INT AUTO_INCREMENT  NOT NULL,
    name         VARCHAR(255) UNIQUE NULL,
    PRIMARY KEY (continent_id)
);

CREATE TABLE DIM_country
(
    iso_code     VARCHAR(20)  NOT NULL,
    continent_id INT          NULL,
    name         VARCHAR(255) NULL,
    PRIMARY KEY (iso_code),
    FOREIGN KEY (continent_id) REFERENCES DIM_continent (continent_id)
);

CREATE TABLE DIM_date
(
    date        DATE                                     NOT NULL,
    day_of_week INT CHECK ( day_of_week BETWEEN 0 AND 6) NULL,
    day         INT CHECK ( day BETWEEN 1 AND 31)        NULL,
    month       INT CHECK ( month BETWEEN 1 AND 12)      NULL,
    year        INT,
    PRIMARY KEY (date)
);

CREATE TABLE DIM_events
(
    iso_code   VARCHAR(20) NOT NULL,
    date       DATE        NOT NULL,
    new_cases  INT         NULL,
    new_deaths INT         NULL,
    new_tests  INT         NULL,
    PRIMARY KEY (iso_code, date),
    FOREIGN KEY (iso_code) REFERENCES DIM_country (iso_code),
    FOREIGN KEY (date) REFERENCES DIM_date (date)
);

CREATE TABLE DIM_statistics
(
    iso_code                VARCHAR(20) NOT NULL,
    population              INT         NULL,
    population_density      FLOAT       NULL,
    median_age              FLOAT       NULL,
    aged_65_older           FLOAT       NULL,
    gdp_per_capita          FLOAT       NULL,
    extreme_poverty         FLOAT       NULL,
    cardiovasc_death_rate   FLOAT       NULL,
    diabetes_prevalence     FLOAT       NULL,
    female_smokers          FLOAT       NULL,
    male_smokers            FLOAT       NULL,
    life_expectancy         FLOAT       NULL,
    human_development_index FLOAT       NULL,
    PRIMARY KEY (iso_code),
    FOREIGN KEY (iso_code) REFERENCES DIM_country (iso_code)
);

                                                                                                                                                    
