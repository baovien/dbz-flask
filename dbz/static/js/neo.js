function onFirstDataRendered_f(params) {
    params.api.sizeColumnsToFit();
}

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


function render_table(){
    let columnDefs = [
        {
            headerName: "Country",
            field: "location",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Continent",
            field: "continent",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        }
    ];

    // let the grid know which columns and what data to use
    let gridOptions = {
        columnDefs: columnDefs,
        onFirstDataRendered: onFirstDataRendered_f,
        animateRows: true,
        pagination: true,

    };

    let gridDiv = document.querySelector('#neoGrid'); //TODO: Change id if you want to trong
    new agGrid.Grid(gridDiv, gridOptions);


    // get data from server
    agGrid.simpleHttpRequest({url: '/neo/country'})
        .then(function (data) {
            console.log(data)
            gridOptions.api.setRowData(data);
        });

}

// setup the grid after the page has finished loading
document.addEventListener('DOMContentLoaded', function () {
    // draw graph
    draw();
    // render ag-grid table
    render_table();

});