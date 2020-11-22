function draw() {
    var config = {
        container_id: "viz",
        server_url: "bolt://167.99.255.7:7687",
        server_user: "neo4j",
        server_password: "Alpacas1",
        labels: {
            "Country": {
                "caption": "location",
                // "community": "population_density",
                "size": "population",
            },
            "Continent": {
                "caption": "continent",
                "community": "continent",
            },
        },
        relationships: {
            "LOCATED_IN": {
                "caption": false
            },
        },
        initial_cypher: "MATCH (c:Country)-[r]->(cc:Continent) RETURN c, r, cc;"
    }

    var viz = new NeoVis.default(config);
    viz.render();
}