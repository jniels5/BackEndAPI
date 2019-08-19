var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()

var whitelist = [
    'http://localhost:3000/',
    'http://team11-frontend.mjhmkfjvi5.us-east-2.elasticbeanstalk.com/'
  ];

var vcap_services = JSON.parse(process.env.VCAP_SERVICES)

//creating connection object
var connection = mysql.createConnection({
  host     : vcap_services["p.mysql"][0].credentials.hostname,
  user     : vcap_services["p.mysql"][0].credentials.username,
  password : vcap_services["p.mysql"][0].credentials.password,
  port     : vcap_services["p.mysql"][0].credentials.port,
  database : vcap_services["p.mysql"][0].credentials.name,
  multipleStatements: true //used for running an sql file
});
var conn_succ = false; //checks connection status, will probably get rid of this soon

//connect to db
connection.connect(function(err) {
  if (err) {
    conn_succ = false;
    //Worthless right not, haven't been able to access aws logs
    console.log('Not Connected to database.'); //but maybe some day
    return;
  }
  //yussssssssss
  conn_succ = true;
  console.log('Connected to database.');
});

module.exports = connection;