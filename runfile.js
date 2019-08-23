
//call execFile to run an sql file


var fs = require('fs');
var _ = require('underscore');
var	mysql = require('mysql');
// Connection 
var connection = require("./auth/Connect");

//takes a sql connection and sql query as a string
//runs a specific sql query
function exec(sql, response, callback) {
	connection.query(sql, function (error, results) {
    if(error) {
			throw error;
    };
		//don't know what this does but it works
    if (typeof callback === 'function') {
      callback(error, results);
    }
	});
	return this;
}

function execNodeMailer(filename, response, callback) {
	fs.readFile(filename, 'utf8', function(error, data) {
		if (error) {
			throw error;
		};
		// execute nodemailer

	})
}

//takes a mysql connection and sql file
function execFile( filename, response, callback) {
	fs.readFile(filename, 'utf8', function (error, data) {
		if (error) {
			throw error;
  	};
	//execute specific sql query
  exec( data, response, callback);
	});
	return this;
}

//export functions
exports.exec = exec;
exports.execFile = execFile;
exports.execNodeMailer = execNodeMailer;
