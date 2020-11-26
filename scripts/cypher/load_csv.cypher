/*****************************************************************************
 * COVID-19 CSV LOADER FOR NEO4J
 *****************************************************************************
 * Loads data from .csv file and creates nodes and relationships between them.
 * NOTE: This will reset the existing database!
 * Compatible with Neo4j version 4.1+
 *****************************************************************************/


/* WARNING: Deletes all existing nodes in the connected database! */
MATCH (n) DETACH DELETE n;


/* Drop existing indices */
DROP INDEX CountryIndex IF EXISTS;
DROP INDEX ContinentIndex IF EXISTS;
DROP INDEX DateIndex IF EXISTS;


/* Drop existing constraints */
DROP CONSTRAINT UniqueDateConstraint IF EXISTS;
DROP CONSTRAINT UniqueCountryConstraint IF EXISTS;
DROP CONSTRAINT UniqueLocationConstraint IF EXISTS;
DROP CONSTRAINT UniqueContinentConstraint IF EXISTS;


/* Add uniqueness constraints */
CREATE CONSTRAINT UniqueDateConstraint ON (d:Date) ASSERT d.date IS UNIQUE;
CREATE CONSTRAINT UniqueCountryConstraint ON (c:Country) ASSERT c.iso_code IS UNIQUE;
CREATE CONSTRAINT UniqueLocationConstraint ON (c:Country) ASSERT c.location IS UNIQUE;
CREATE CONSTRAINT UniqueContinentConstraint ON (cc:Continent) ASSERT cc.continent IS UNIQUE;


/* Get Countries from CSV File */
LOAD CSV WITH HEADERS FROM 'file:///owid-covid-2020-11-18.csv' AS line
WITH line WHERE line.iso_code IS NOT NULL AND line.iso_code <> 'OWID_WRL'
MERGE (c:Country {iso_code : line.iso_code, location : line.location})
ON CREATE SET
	c.population = toInteger(line.population),
	c.population_density = toFloat(line.population_density),
	c.median_age = toFloat(line.median_age),
	c.aged_65_older = toFloat(line.aged_65_older),
	c.gdp_per_capita = toFloat(line.gdp_per_capita),
	c.extreme_poverty = toFloat(line.extreme_poverty), 
	c.cardiovasc_death_rate = toFloat(line.cardiovasc_death_rate),
	c.diabetes_prevalence = toFloat(line.diabetes_prevalence),
	c.female_smokers = toFloat(line.female_smokers),
	c.male_smokers = toFloat(line.male_smokers),
	c.life_expectancy = toFloat(line.life_expectancy),
	c.human_development_index = toFloat(line.human_development_index);


/* Get Continents from CSV File */
LOAD CSV WITH HEADERS FROM 'file:///owid-covid-2020-11-18.csv' AS line
WITH line WHERE line.continent IS NOT NULL
MERGE (cc:Continent {continent : line.continent});


/* Connect Countries with Continents using relationships from CSV File */
LOAD CSV WITH HEADERS FROM 'file:///owid-covid-2020-11-18.csv' AS line
MATCH (c:Country {iso_code : line.iso_code})
MATCH (cc:Continent {continent : line.continent})
MERGE (c)-[:LOCATED_IN]->(cc);


/* Create indices for our nodes, making future lookups more efficient */
CREATE INDEX CountryIndex IF NOT EXISTS FOR (c:Country) ON (c.iso_code);
CREATE INDEX ContinentIndex IF NOT EXISTS FOR (cc:Continent) ON (cc.continent);


/* Get Dates from CSV File */
LOAD CSV WITH HEADERS FROM 'file:///owid-covid-2020-11-18.csv' AS line
WITH line WHERE line.date IS NOT NULL
MERGE (d:Date {date : date(line.date)});


/* Create Events from CSV File */
LOAD CSV WITH HEADERS FROM 'file:///owid-covid-2020-11-18.csv' AS line
MATCH (c:Country {iso_code: line.iso_code})
MATCH (d:Date {date : date(line.date)})
CREATE
(e:Event {new_cases  : toInteger(line.new_cases),
  		  new_deaths : toInteger(line.new_deaths),
  		  new_tests  : toInteger(line.new_tests)}
)
MERGE (c)<-[:IN]-(e)-[:DURING]->(d);


/* Create indices for Date, making future lookups more efficient */
CREATE INDEX DateIndex IF NOT EXISTS FOR (d:Date) ON (d.date);
