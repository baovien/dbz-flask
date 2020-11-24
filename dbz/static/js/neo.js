// Credentials have to be stored client-side (Read: https://github.com/neo4j-contrib/neovis.js/issues/101)
let credentials = {
    server_url: "bolt://167.99.255.7:7687",
    server_user: "neo4j",
    server_password: "Alpacas1",
}

// Note: Dirty fix for below function
// Todo: Find a better way to perform this
let gridOptionsContinents = null;

nw = Prism.plugins.NormalizeWhitespace;


function onFirstDataRendered_f(params) {
    params.api.sizeColumnsToFit();
}

function draw_graph_countries() {
    let config = {
        container_id: "neo_graph_1",
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



function draw_graph_event_by_country() {
    let config = {
        container_id: "neo_graph_2",
        labels: {
            "Country": {
                "caption": "location",
                // "community": "population",
                "size": "population_density",
            },
            "Event": {
                "caption": "new_cases",
                "size": "new_cases",
                // "community": "new_cases",
            },
            "Date": {
                "caption": "date.day",
                // "community": "date.day",
            },
            "Continent": {
                "caption": "continent",
                "community": "continent",
            },
        },
        relationships: {
            "IN": {
                "caption": false
            },
            "DURING": {
                "caption": false
            },
            "LOCATED_IN": {
                "caption": false,
            },
        },
        initial_cypher: `
        MATCH 
            (c:Country) <-[r]- (e:Event) -[i]-> (d:Date),
            (c:Country) -[x]-> (cc:Continent)
        WHERE 
            d.date.month = 5 
            AND e.new_cases > 2000
        RETURN c, r, e, cc, x
        `

        // AND c.location in ['Norway','Vietnam','Sweden', 'China', 'Japan']

    }

    let viz = new NeoVis.default({...credentials, ...config});
    viz.render();
}



function draw_graph_event_by_date() {
    let config = {
        container_id: "neo_graph_3",
        labels: {
            "Country": {
                "caption": "location",
                // "community": "population_density",
                "size": "population_density",
            },
            "Event": {
                "caption": "new_cases",
                "size": "new_cases",
                // "community": "new_cases",
            },
            "Date": {
                "caption": "date.day",
                // "community": "date.day",
            },
            "Continent": {
                "caption": "continent",
                // "community": "continent",
            },
        },
        relationships: {
            "IN": {
                "caption": false,
                "thickness": 2

            },
            "DURING": {
                "caption": false,
                "thickness": 1
            },
            "LOCATED_IN": {
                "caption": false,
                "thickness": 3
            },
        },
        initial_cypher: `
        MATCH 
            (c:Country) <-[r]- (e:Event) -[i]-> (d:Date),
            (c:Country) -[x]-> (cc:Continent)
        WHERE 
            d.date = Date('2020-06-01')
            AND e.new_cases > 100
        RETURN c, r, e, d, i, cc, x
        `
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
            gridOptionsContinents.api.setRowData(data);
        });
}


// On-Load: setup the grid after the page has finished loading
document.addEventListener('DOMContentLoaded', function () {
    // draw graph
    draw_graph_countries();
    draw_graph_event_by_country();
    draw_graph_event_by_date();

    // render ag-grid table
    render_table();

    render_table_continent_stats();
    update_table_continent_stats('Europe');



});


let continent_snippet = document.querySelector('#continent_code_snippet')

// Continent Dropdown - On-Click
let dropdown_face = document.querySelector('#continent_dropdown')
let dropdown_button = document.querySelectorAll('.dropdown-item')
for (const btn of dropdown_button) {
    btn.addEventListener('click', function() {
        dropdown_face.innerHTML = btn.innerHTML
        dropdown_face.innerText = btn.innerText
        dropdown_face.value = btn.value

        continent_snippet.innerHTML = `
        MATCH
            (e:Event)-[:IN]->(c)-[:LOCATED_IN]->(cc),
            (e)-[:DURING]->(d)
        WHERE cc.continent = '` + dropdown_face.innerHTML + `'
        RETURN
            d.date.month as month,
            SUM(e.new_cases) as total_cases,
            SUM(e.new_deaths) as total_deaths,
            SUM(e.new_tests) as total_tests
        ORDER BY month
        `
        Prism.highlightElement(continent_snippet);

        update_table_continent_stats(dropdown_face.innerHTML)
    });
}
