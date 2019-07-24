var express = require('express');
var router = express.Router();
var mysql = require('mysql');

var connection = require("../../auth/Connect");
var useCors = require("../../auth/Cors");

useCors();

////////////////////////////////////////////////////
//                                                //
//    Email API Calls                             //
//                                                //
////////////////////////////////////////////////////

router.get('/Intern/PO', function(request,response) {
    connection.query('SELECT ' + request.query.ContactType + ' FROM Members ' +
                     'JOIN TeamMembers ON TeamMembers.MemberID = Members.MemberID ' +
                     'JOIN Teams ON Teams.TeamID = TeamMembers.TeamID '+
                     'JOIN Role ON Role.MemberID = Members.MemberID ' +
                     'WHERE ' + request.query.Teams + 'Teams.Semester = ' + mysql.escape(request.query.Semester) + ' AND ' +
                     request.query.Role, function (error, results, fields) {
      if(error) {
        response.json({email_get: "failed"});
      }
      else {
        response.json(results);
      }
    });
  });
  
  router.get('/Applicants/OH', function(request,response) {
    connection.query('SELECT ' + request.query.ContactType + ' FROM Members ' +
                     'JOIN Role ON Role.MemberID = Members.MemberID ' +
                     'WHERE ' + request.query.Role, function (error, results, fields) {
      if(error) {
        response.json({email_get: "failed"});
      }
      else {
        response.json(results);
      }
    });
  });

module.exports = router