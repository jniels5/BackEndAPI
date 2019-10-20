var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()

var whitelist = [
    'http://localhost:3000/',
  ];

//var vcap_services = JSON.parse(process.env.VCAP_SERVICES)

//creating connection object
var connection = mysql.createConnection({
  
  host     : 'firstdatabasepractice.clmedzuqz8zr.us-east-2.rds.amazonaws.com',
  user     :'admin',
  password : 'feirick1996',
  port     : '3306',
  database : 'firstdatabasepractice',
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