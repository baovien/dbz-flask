from neo4j import GraphDatabase

# How to create Managed Transactions:
# https://neo4j.com/docs/api/python-driver/current/api.html#managed-transactions-transaction-functions
# Note: You must run .data() INSIDE transaction function, or else the returned data is wiped before reaching APP.


class CustomNeoApp:
    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
        print(" *** NEO4J ::: Neo4J Custom App --- SUCCESSFULLY INITIATED")

    def close(self):
        # Don't forget to close the driver connection when you are finished with it
        self.driver.close()

    def ping(self):
        """ Check current driver status """
        print(" *** NEO4J ::: Neo4J Custom App --- STILL ONLINE")


    def get_common_summary(self):
        return self._exec_cypher(self._return_common_summary)

    def get_continent_stats(self, continent_name):
        with self.driver.session() as session:
            return session.read_transaction(self._find_and_return_continents_stats, continent_name)

    def get_countries_continents(self):
        return self._exec_cypher(self._find_and_return_countries_continents)

    def _exec_cypher(self, _query_func):
        # TODO: Merge into the other functions and then deprecate?
        with self.driver.session() as session:
            return session.read_transaction(_query_func)

    @staticmethod
    def _find_and_return_continents_stats(tx, continent_name):
        """ Returns stats by given continent, ordered by month. """
        # NOTE: This is the proper way to implement neo4j transactions!

        query = f"""
        MATCH (e:Event)-[:IN]->(c)-[:LOCATED_IN]->(cc), (e)-[:DURING]->(d)
        WHERE cc.continent = '{continent_name}'
        RETURN 
            d.date.month as month, 
            SUM(e.new_cases) as total_cases, 
            SUM(e.new_deaths) as total_deaths, 
            SUM(e.new_tests) as total_tests
        ORDER BY month
        """

        result = tx.run(query)

        return result.data()

    @staticmethod
    def _find_and_return_countries_continents(tx):
        query = """
        MATCH (c:Country) -[]-> (cc:Continent)
        RETURN c.location, cc.continent
        """

        result = tx.run(query)
        return list(result)

    @staticmethod
    def _return_common_summary(tx):
        """ Returns the data for Main Table on the homepage. """
        query = """
        MATCH (e:Event)-[]->(c:Country)
        RETURN 
            c.location as Country, 
            SUM(e.new_cases) as Confirmed, 
            SUM(e.new_deaths) as Deaths, 
            SUM(e.new_tests) as Tests
        ORDER BY Country
        """

        result = tx.run(query)
        return list(result)
