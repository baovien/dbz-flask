function draw() {
    var config = {
        container_id: "viz",
        server_url: "bolt://167.99.255.7:7687",
        server_user: "neo4j",
        server_password: "Alpacas1",
        labels: {
            "Country": {
                "caption": "location",
            },

        },
        relationships: {},
        initial_cypher: "MATCH (c:Country) RETURN c;"
    }

    var viz = new NeoVis.default(config);
    viz.render();
}