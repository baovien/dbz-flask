
let columnDefs = [
    {
        headerName: "Location",
        field: "location",
        sortable: true,
        filter: "agTextColumnFilter",
        sortingOrder: ['desc', 'asc']
    },
    {
        headerName: "Confirmed",
        field: "confirmed",
        sortable: true,
        filter: "agNumberColumnFilter",
        sortingOrder: ['desc', 'asc']
    },
    {
        headerName: "Deaths",
        field: "deaths",
        sortable: true,
        filter: "agNumberColumnFilter",
        sortingOrder: ['desc', 'asc']
    },
    {
        headerName: "Tests",
        field: "tests",
        sortable: true,
        filter: "agNumberColumnFilter",
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
function onFirstDataRendered_f(params) {
    params.api.sizeColumnsToFit();
}


// setup the grid after the page has finished loading
document.addEventListener('DOMContentLoaded', function () {
    let gridDiv = document.querySelector('#myGrid');
    new agGrid.Grid(gridDiv, gridOptions);

    agGrid.simpleHttpRequest({url: '/mysql-stats'})
        .then(function (data) {
            console.log(data)
            gridOptions.api.setRowData(data);
        });

    $('#mysql-stats-btn').on("click", function () {
        gridOptions.api.showLoadingOverlay()

        agGrid
            .simpleHttpRequest({url: '/mysql-stats'})
            .then(function (data) {
                console.log(data)
                gridOptions.api.setRowData(data);
            });
    });

    $('#mongo-stats-btn').on("click", function () {
        gridOptions.api.showLoadingOverlay()

        agGrid
            .simpleHttpRequest({url: '/mongo-stats'})
            .then(function (data) {
                console.log(data)
                gridOptions.api.setRowData(data);
            });
    });

    $('#neo-stats-btn').on("click", function () {
        gridOptions.api.showLoadingOverlay()

        agGrid
            .simpleHttpRequest({url: '/neo-stats'})
            .then(function (data) {
                console.log(data)
                gridOptions.api.setRowData(data);
            });
    });

});