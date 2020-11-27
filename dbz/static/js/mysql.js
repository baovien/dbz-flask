fetch('/mysql/scatter')
    .then(response => response.json())
    .then(data => {


            let countries = data.map(a => a.name);
            let points = data.map(function (a) {
                return {
                    x: a.total_deaths,
                    y: a.median_age
                }
            });

            console.log(countries);
            console.log(points);


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
                            type: 'linear',
                            position: 'bottom',

                            scaleLabel:{
                                labelString: 'Total Deaths',
                                display: true,
                            },

                            ticks: {
                                max: 4000, // Increase this number to increase X-axis
                                min: 0
                            }
                        }],
                        yAxes: [{
                            scaleLabel:{
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


// let ctx = document.getElementById('myChart').getContext('2d');
// let scatterChart = new Chart(ctx, {
//     type: 'scatter',
//     data: {
//         labels: ["Label 1", "Label 2", "Label 3"],
//         datasets: [{
//             label: 'Scatter Dataset',
//             data: [{
//                 x: -10,
//                 y: 0
//             }, {
//                 x: 0,
//                 y: 10
//             }, {
//                 x: 10,
//                 y: 5
//             }]
//         }]
//     },
//     options: {
//         scales: {
//             xAxes: [{
//                 type: 'linear',
//                 position: 'bottom'
//             }]
//         },
//         tooltips: {
//             callbacks: {
//                 label: function (tooltipItem, data) {
//                     let label = data.labels[tooltipItem.index];
//                     return label + ': (' + tooltipItem.xLabel + ', ' + tooltipItem.yLabel + ')';
//                 }
//             }
//         }
//     }
// });