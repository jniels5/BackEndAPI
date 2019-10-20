var bodyParser = require('body-parser')
var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()

// Connection 
 var connection = require("./auth/Connect");

//keep out the baddies
var corsOptions = {
  origin: '*', //use whitelist when localhost testing isn't needed
  //origin: whitelist,
  methods: 'GET,HEAD,POST,OPTIONS,DELETE',
  "preflightContinue": true
}

app.use(cors(corsOptions)); //use cors with options enables
app.use(bodyParser.json()); //Parses POST Data

app.set('port', (process.env.PORT || 5000))

app.listen(app.get('port'), function () {
  console.log("Node app is running at localhost:" + app.get('port'));
});

//pretty much useless, used it to test db connection
app.get('/', function (request, response) {
  console.log("connections");
    response.json({Welcome: "Don't Mind the Mess"});
});
