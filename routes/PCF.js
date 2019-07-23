var express = require('express');
var router = express.Router();

const axios = require('axios');
const cheerio = require('cheerio');

const url = "https://github.discoverfinancial.com/pages/cloud-build-org/cas-pcf-documentation/showback-report/summary";

router.get('/', function(req, res) {
    axios({
        method: 'get',
        url: url,
        proxy: {
            host: "proxy-sim.discoverfinancial.com",
            port: 8081,
            auth: {
                username: "",
                password: ""
            }
        }
    })
        .then(response => {
            console.log(response.data);
            res.json({EHH: "ohye"});
        })
        .catch(error => {
            console.log(error);
            res.json(error);
        })
});

module.exports = router