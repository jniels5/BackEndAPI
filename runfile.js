/*
call execFile to run an sql file
*/

var fs = require('fs');
var _ = require('underscore');
var	mysql = require('mysql');

//takes a sql connection and sql query as a string
//runs a specific sql query
function exec(connection, sql, response, callback) {
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

//takes a mysql connection and sql file
function execFile(connection, filename, response, callback) {
	fs.readFile(filename, 'utf8', function (error, data) {
		if (error) {
			throw error;
  	};
	//execute specific sql query
  exec(connection, data, response, callback);
	});
	return this;
}

//export functions
exports.exec = exec;
exports.execFile = execFile;
