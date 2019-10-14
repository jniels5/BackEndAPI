var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var cors = require('cors');

var connection = require("../../auth/Connect");

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
                     'WHERE Teams.TeamNumber IN ' + request.query.Teams + ' Teams.Semester = ' + request.query.Semester + ' AND ' +
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