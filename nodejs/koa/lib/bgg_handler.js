const request = require('request');

module.exports = {
    getHot: () => {
        return new Promise((resolve,reject) => {
            request
            .get("https://bgg-json.azurewebsites.net/hot")
            .on('response', (response) => {
                resolve(response);
            })
            .on('error', function(err) {
                reject(err)
            });
        });
    }
}