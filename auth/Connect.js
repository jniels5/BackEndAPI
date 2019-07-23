var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()

var whitelist = [
    'http://localhost:3000/',
    'http://team11-frontend.mjhmkfjvi5.us-east-2.elasticbeanstalk.com/'
  ]

//creating connection object
var connection = mysql.createConnection({
  host     : process.env.RDS_HOSTNAME || "team11-database.cpfq5d1i5xkj.us-east-2.rds.amazonaws.com",
  user     : process.env.RDS_USERNAME || "Team11",
  password : process.env.RDS_PASSWORD || "CCCJMS11",
  port     : process.env.RDS_PORT     || "3306",
  database : process.env.RDS_DB_NAME  || "ebdb",
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