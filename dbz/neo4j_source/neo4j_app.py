from neo4j import GraphDatabase


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



    # TODO: Delete when you can!
    # def create_friendship(self, person1_name, person2_name):
    #     with self.driver.session() as session:
    #         # Write transactions allow the driver to handle retries and transient errors
    #         result = session.write_transaction(
    #             self._create_and_return_friendship, person1_name, person2_name)
    #         for row in result:
    #             print("Created friendship between: {p1}, {p2}".format(p1=row['p1'], p2=row['p2']))

    # def find_total_deaths_country(self, country_name):
    #     with self.driver.session() as session:
    #         result = session.read_transaction(self._find_and_return_countries_continents)
    #         for row in result:
    #             print(f"Found country: {row[0]} with continent {row[1]}")
    #         return result

    def get_countries_continents(self):
        return self._exec_cypher(self._find_and_return_countries_continents)

    def _exec_cypher(self, _query_func):
        with self.driver.session() as session:
            return session.read_transaction(_query_func)

    @staticmethod
    def _find_and_return_countries_continents(tx):
        # query = (
        #     "MATCH (c:Country) -[]-> (cc:Continent) "
        #     "RETURN c.location, cc.continent"
        # )

        query = """
        MATCH (c:Country) -[]-> (cc:Continent)
        RETURN c.location, cc.continent
        """

        result = tx.run(query)
        return list(result)

