const axios = require('axios');

module.exports = {
    getHot: () => {
        return axios.get('https://bgg-json.azurewebsites.net/hot');
    }
}