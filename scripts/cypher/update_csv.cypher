/*****************************************************************************
 * COVID-19 CSV UPDATER FOR NEO4J
 *****************************************************************************
 * Updates the existing database with current data straight from URL. 
 * Compatible with Neo4j version 4.1+
 *****************************************************************************/

/* Drop existing indices */
DROP INDEX DateIndex IF EXISTS;


/* Get New Dates from URL Source */
LOAD CSV WITH HEADERS FROM 'https://covid.ourworldindata.org/data/owid-covid-data.csv' AS line
WITH line WHERE line.date IS NOT NULL
MERGE (d:Date {date : date(line.date)});


/* Create Events from CSV Source */
LOAD CSV WITH HEADERS FROM 'https://covid.ourworldindata.org/data/owid-covid-data.csv' AS line
WITH line WHERE line.iso_code IS NOT NULL AND line.iso_code <> 'OWID_WRL'
MERGE (c:Country {iso_code: line.iso_code})
MERGE (d:Date {date : date(line.date)})
MERGE (c)<-[:IN]-(e:Event)-[:DURING]->(d)
ON CREATE SET
	e.new_cases = toInteger(line.new_cases),
	e.new_deaths = toInteger(line.new_deaths),
	e.new_tests = toInteger(line.new_tests);


/* Create indices for Date, making future lookups more efficient */
CREATE INDEX DateIndex IF NOT EXISTS FOR (d:Date) ON (d.date);
