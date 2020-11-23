// Credentials have to be stored client-side (Read: https://github.com/neo4j-contrib/neovis.js/issues/101)
let credentials = {
    server_url: "bolt://167.99.255.7:7687",
    server_user: "neo4j",
    server_password: "Alpacas1",
}

// Note: Dirty fix for below function
// Todo: Find a better way to perform this
let gridOptionsContinents = null;

function onFirstDataRendered_f(params) {
    params.api.sizeColumnsToFit();
}

function draw() {
    let config = {
        container_id: "viz",
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

    let viz = new NeoVis.default({...credentials, ...config});
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


function render_table_continent_stats(){
    let columnDefs = [
        {
            headerName: "Month",
            field: "month",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Total Cases",
            field: "total_cases",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Total Deaths",
            field: "total_deaths",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Total Tests",
            field: "total_tests",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
    ];

    // let the grid know which columns and what data to use
    gridOptionsContinents = {
        columnDefs: columnDefs,
        onFirstDataRendered: onFirstDataRendered_f,
        animateRows: true,
        pagination: false,

    };

    let gridDiv = document.querySelector('#continent_stats_table');
    new agGrid.Grid(gridDiv, gridOptionsContinents);

}

function update_table_continent_stats(continent_name){
    // get data from server
    let full_url = "/neo/continent?name=" + continent_name
    agGrid.simpleHttpRequest({url: full_url})
        .then(function (data) {
            console.log(data)
            console.log('HELLO BIS')
            gridOptionsContinents.api.setRowData(data);
        });
}


// On-Load: setup the grid after the page has finished loading
document.addEventListener('DOMContentLoaded', function () {
    // draw graph
    draw();
    // render ag-grid table
    render_table();
    render_table_continent_stats()
    update_table_continent_stats('Europe')

});

// On-Click
let button = document.querySelector('#get_countries_btn');
button.addEventListener('click', function() {
    draw();
});

// Continent Dropdown - On-Click
let dropdown_face = document.querySelector('#continent_dropdown')
let dropdown_button = document.querySelectorAll('.dropdown-item')
for (const btn of dropdown_button) {
    btn.addEventListener('click', function() {
        dropdown_face.innerHTML = btn.innerHTML
        dropdown_face.innerText = btn.innerText
        dropdown_face.value = btn.value

        // console.log(dropdown_face.innerHTML)
        update_table_continent_stats(dropdown_face.innerHTML)
    });
}
