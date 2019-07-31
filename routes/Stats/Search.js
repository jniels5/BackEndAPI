var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var cors = require('cors');
const AppAccess = require('../../auth/AppAccess');

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

var access = new AppAccess.AppAccess();

router.use(cors(corsOptions)); 

// Stats Search Calls . . .
router.get('/first', function (request, response) {
  access.check(1, request, response).then(result => {
    if (result) {
      var sem = "";
      if (request.query.Semester) {
        sem = "Teams.Semester = " + mysql.escape(request.query.Semester) + " AND ";
      }
      var query = 'SELECT m.MemberID, m.FirstName, m.LastName, Teams.TeamNumber, r.Type, m.GradYear, ' +
        'm.Email, m.AssetID, m.GradSemester, r.Status, r.Description, r.Date, tm.TeamID, Teams.TeamName, m.WorkEmail, ' +
        'Teams.Semester, m.Gender FROM Members AS m, Role AS r, TeamMembers AS tm, Teams ' +
        'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = Teams.TeamID AND ' +
        sem + 'm.FirstName = ' + mysql.escape(request.query.Search) + ' ORDER BY m.MemberID';
      connection.query(query, function (error, results, fields) {
        if (error) {
          response.json({ first_select: "failed" });
        }
        else {
          response.json(results);
        }
      });
    }
  });
});
  
router.get('/last', function (request, response) {
  access.check(1, request, response).then(result => {
    if (result) {
      var sem = "";
      if (request.query.Semester) {
        sem = "Teams.Semester = " + mysql.escape(request.query.Semester) + " AND ";
      }
      var query = 'SELECT m.MemberID, m.FirstName, m.LastName, Teams.TeamNumber, r.Type, m.GradYear, ' +
        'm.Email, m.AssetID, m.GradSemester, r.Status, r.Description, r.Date, tm.TeamID, Teams.TeamName, m.WorkEmail, ' +
        'Teams.Semester, m.Gender FROM Members AS m, Role AS r, TeamMembers AS tm, Teams ' +
        'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = Teams.TeamID AND ' +
        sem + 'm.LastName = ' + mysql.escape(request.query.Search) + ' ORDER BY m.MemberID';
      connection.query(query, function (error, results, fields) {
        if (error) {
          response.json({ last_select: "failed" });
        }
        else {
          response.json(results);
        }
      });
    }
  });
});
  
router.get('/grad', function (request, response) {
  access.check(1, request, response).then(result => {
    if (result) {
      connection.query('SELECT m.MemberID, m.FirstName, m.LastName, Teams.TeamNumber, r.Type, ' +
        'm.GradYear, m.Email, m.AssetID, m.GradSemester, r.Status, r.Description, r.Date, ' +
        'tm.TeamID, Teams.TeamName, Teams.Semester, m.Gender, m.WorkEmail ' +
        'FROM Members AS m, Role AS r, TeamMembers AS tm, Teams ' +
        'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = Teams.TeamID AND Teams.Semester = ' + mysql.escape(request.query.Semester) + ' AND m.GradYear = ' + request.query.Search + ' ORDER BY m.MemberID', function (error, results, fields) {
          if (error) {
            response.json({ grad_select: "failed" });
          }
          else {
            response.json(results);
          }
        });
    }
  });
});
  
  router.get('/graduatedIn/:sem', function(request,response)
  {
    let semCode = decodeSemester(request.params.sem);
    let semester = semCode.split(" ")[0];
    let year = semCode.split(" ")[1];
    let query = "SELECT * FROM Members WHERE GradSemester=" + mysql.escape(semester) + " AND GradYear=" + mysql.escape(year) + ";";
    connection.query(query, function (error, results, fields) {
          if(error) {
              response.json({graduadtedIn: "failed"});
          }
          else {
              response.json(results);
          }
    });
  });
  
  router.get('/all', function(request,response) {
    connection.query('SELECT m.MemberID, m.FirstName, m.LastName, Teams.TeamNumber, r.Type, ' +
                     'm.GradYear, m.Email, m.AssetID, m.GradSemester, r.Status, r.Description, r.Date, tm.TeamID, Teams.TeamName, Teams.Semester, m.Gender, m.WorkEmail FROM Members AS m, Role AS r, TeamMembers AS tm, Teams ' +
                     'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = Teams.TeamID AND Teams.Semester = ' + mysql.escape(request.query.Semester) + ' ORDER BY m.MemberID', function (error, results, fields) {
          if(error) {
              response.json({all_select: "failed"});
          }
          else {
              response.json(results);
          }
    });
  });

  module.exports = router