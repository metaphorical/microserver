const request = require('request');

module.exports = {
    getHot: (callback) => {
        console.log("Running hot")
        request
        .get("https://bgg-json.azurewebsites.net/hot")
        .on('response', (response) => {
            callback(response, null) 
        })
        .on('error', function(err) {
            callback(null, err);
        });
    }
}