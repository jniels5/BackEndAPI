var express = require('express');
var router = express.Router();
var cors = require('cors');

  //app.use(cors()); uncomment to enable cors for everything
  module.exports = function () {
    var whitelist = [
        'http://localhost:3000/',
        'http://team11-frontend.mjhmkfjvi5.us-east-2.elasticbeanstalk.com/'
    ]

    //keep out the baddies
    var corsOptions = {
        origin: '*',
        //origin: whitelist,
        methods: 'GET,HEAD,POST,OPTIONS,DELETE',
        "preflightContinue": true
    }

    router.use(cors(corsOptions)); 
  }
  //app.options('*', cors(corsOptions)); //enables preflight options