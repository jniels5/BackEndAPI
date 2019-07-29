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

router.get('/projects', function(request,response) {
    if (request.query.Semester == "unassigned")
    {
      // Fetching all project names in database
      connection.query('SELECT p.Name, p.ProjectID FROM Projects AS p, TeamProjects as tp WHERE ' +
                       'p.ProjectID NOT IN (SELECT ProjectID FROM TeamProjects) ' +
                       'GROUP BY `Name` ORDER BY `Name`', function (error, results, fields) {
            if(error) {
                response.json({Unassigned_select: "failed"});
            }
            else {
                response.json(results);
            }
      });
    }
    else
    {
      // Fetching project names according to semester
      connection.query('SELECT p.Name, p.ProjectID FROM Projects AS p, Teams, TeamProjects as tp WHERE Teams.Semester = "'+ request.query.Semester +
                       '" AND p.ProjectID = tp.ProjectID AND tp.TeamID = Teams.TeamID ' +
                       'ORDER BY `Name`', function (error, results, fields) {
            if(error) {
                response.json({Project_select: "failed"});
            }
            else {
                response.json(results);
            }
      });
    }
  });

  // Lists all teams, groups by semester
router.get('/semesters', function(request,response) {
  connection.query('SELECT Semester FROM Teams GROUP BY Semester ORDER BY TeamID DESC;', function (error, results, fields) {
        if(error) {
            response.json({semester_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

module.exports = router