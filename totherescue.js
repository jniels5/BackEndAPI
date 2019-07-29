var mysql = require('mysql');

var connection = mysql.createConnection({
  host     : process.env.RDS_HOSTNAME || "team11-database.cpfq5d1i5xkj.us-east-2.rds.amazonaws.com",
  user     : process.env.RDS_USERNAME || "Team11",
  password : process.env.RDS_PASSWORD || "CCCJMS11",
  port     : process.env.RDS_PORT     || "3306",
  database : process.env.RDS_DB_NAME  || "ebdb",
  multipleStatements: true //used for running an sql file
});

connection.connect();

var query = "SELECT FirstName, LastName, WorkEmail FROM Members";

connection.query(query, function(error, results, fields)
{
   if(error){
       console.log("error!");
   } 
   else
   {
       console.log(results);
   }
});