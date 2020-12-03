/**
 * MySQL Javascript File
 * Remember, we adhere to Google's JS Styleguide:
 * - JSDoc: https://google.github.io/styleguide/jsguide.html#jsdoc
 * - Method Name: https://google.github.io/styleguide/jsguide.html#naming-method-names
 */

function onFirstDataRendered_f(params) {
    params.api.sizeColumnsToFit();
}

/**
 * Draw a scatter plot on Median Age and Total Deaths.
 * x-axis is converted to logarithmic.
 * TODO: Switch name if more scatter plots are introduced.
 */
function draw_scatter_plot() {
    fetch('/mongo/scatter')
        .then(response => response.json())
        .then(data => {

                let countries = data.map(a => a.name);
                let points = data.map(function (a) {
                    return {
                        x: a.total_deaths,
                        y: a.median_age
                    }
                });

                let ctx = document.getElementById('scatter_plot_age_deaths').getContext('2d');
                let scatterChart = new Chart(ctx, {
                    type: 'scatter',
                    data: {
                        labels: countries,
                        datasets: [{
                            label: 'Countries',
                            borderColor: "rgb(0,0,0)",
                            backgroundColor: "rgb(0,228,255)",
                            data: points
                        }]
                    },
                    options: {
                        scales: {
                            xAxes: [{
                                type: 'logarithmic',
                                position: 'bottom',

                                scaleLabel: {
                                    labelString: 'Total Deaths',
                                    display: true,
                                },

                                ticks: {
                                    callback: function (value, index, values) {
                                        return Number(value.toString());//pass tick values as a string into Number function
                                    }
                                }
                            }],
                            yAxes: [{
                                scaleLabel: {
                                    labelString: 'Median Age',
                                    display: true,
                                },

                                ticks: {
                                    max: 60,
                                    min: 0
                                }
                            }],
                        },
                        tooltips: {
                            callbacks: {
                                label: function (tooltipItem, data) {
                                    let label = data.labels[tooltipItem.index];
                                    return label + ': Deaths: ' + tooltipItem.xLabel + ', Median Age: ' + tooltipItem.yLabel;
                                }
                            }
                        }
                    }
                });
            }
        )
        .catch(error => callback(error, null))
}


/**
 * Render table with stats on cases, deaths, and tests per million.
 */
function render_table_million() {
    let columnDefs = [
        {
            headerName: "Country",
            field: "name",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Cases per million",
            field: "cases_per_million",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Deaths per million",
            field: "deaths_per_million",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Tests per million",
            field: "tests_per_million",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
    ];

    // let the grid know which columns and what data to use
    let gridOptionsContinents = {
        columnDefs: columnDefs,
        onFirstDataRendered: onFirstDataRendered_f,
        animateRows: true,
        pagination: true,

    };


    let gridDiv = document.querySelector('#table_per_million');
    new agGrid.Grid(gridDiv, gridOptionsContinents);

    // get data from server
    let full_url = "/mongo/million"
    agGrid.simpleHttpRequest({url: full_url})
        .then(function (data) {
            gridOptionsContinents.api.setRowData(data);
        });

}


/**
 * Render table with stats grouped by month and year.
 */
function render_table_month_year() {
    let columnDefs = [
        {
            headerName: "Month",
            field: "month",
            sortable: true,
            filter: "agTextColumnFilter",
            sortingOrder: ['desc', 'asc']
        },
        {
            headerName: "Year",
            field: "year",
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
    let gridOptionsContinents = {
        columnDefs: columnDefs,
        onFirstDataRendered: onFirstDataRendered_f,
        animateRows: true,
        pagination: false,
    };


    let gridDiv = document.querySelector('#table_month_year');
    new agGrid.Grid(gridDiv, gridOptionsContinents);

    // get data from server
    let full_url = "/mongo/month"
    agGrid.simpleHttpRequest({url: full_url})
        .then(function (data) {
            gridOptionsContinents.api.setRowData(data);
        });

}


/**
 * Render Choropleth Map colored by total deaths.
 */
function draw_choropleth_map() {
    fetch('/mongo/map')
        .then(response => response.json())
        .then(result => {

                let countries = result.map(a => a.name);
                let deaths = result.map(b => b.total_deaths);

                let data = [{
                    type: 'choropleth',
                    locationmode: 'country names',
                    locations: countries,
                    z: deaths,
                    autocolorscale: true,
                    colorbar: {
                        autotic: true,
                        title: 'Total Deaths'
                    },
                }];

                let layout = {
                    title: 'Total Covid-19 Cases',
                    geo: {
                        projection: {
                            type: 'robinson'
                        }
                    }
                };

                Plotly.newPlot("myDiv", data, layout, {showLink: false});

            }
        );

}


// On-Load: setup the grid after the page has finished loading
document.addEventListener('DOMContentLoaded', function () {

    draw_choropleth_map()
    draw_scatter_plot();

    render_table_million();
    render_table_month_year();

});