var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var cors = require('cors');
var bodyParser = require('body-parser')

var connection = require("../auth/Connect");

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
router.use(bodyParser.json());

// Pull in route files
var Email = require("./Stats/Email.js");
var Filter = require("./Stats/Filter.js");
var Lab = require("./Stats/Lab.js");
var Modal = require("./Stats/Modal.js");
var Search = require("./Stats/Search.js");
var Student = require("./Stats/Student.js");

// Specify Paths
router.use('/email/', Email);
router.use('/filter/', Filter);
router.use('/lab/', Lab);
router.use('/modal/', Modal);
router.use('/search/', Search);
router.use('/student/', Student);

// Team Names by Semester
router.get('/teams/names', function(request,response) {
    var sem = "Teams.Semester = " + mysql.escape(request.query.Semester);
    connection.query('SELECT TeamName, TeamNumber FROM Teams WHERE '  + sem, function (error, results, fields) {
          if(error) {
              response.json({teams_select: "failed"});
          }
          else {
              response.json(results);
          }
    });
  });
  
  // Add new members with a role to database
  router.post('/add/member', function(request,response) {
    //used in connection.query
    var entry = {
      FirstName: request.body.FirstName,
      LastName:  request.body.LastName,
      Gender: request.body.Gender,
      GradSemester: request.body.GradSemester,
      GradYear: request.body.GradYear,
      Email: request.body.Email,
      WorkEmail: request.body.WorkEmail,
      PhoneNum: request.body.PhoneNum,
      Major: '',
      AssetID: 10000000,
      LabID: 1
    };
  
    var role = {
      Type: request.body.Type,
      Status: request.body.Status,
      Description: request.body.Description,
      Date: request.body.Date
    }
  
    connection.query('INSERT INTO Members set ?', entry, function (error, results, fields) {
          if(error) {
              response.json({
                add_member: "Insert Failed",
                member_error: error,
              });
          }
          else {
            connection.query('SELECT MemberID FROM Members WHERE FirstName = "' + entry.FirstName + '" AND LastName = "' + entry.LastName + '"', function (error, results, fields) {
            if(error) {
                response.json({
                  membID_get: "Testing Failed",
                  membID_err: error,
                });
            }
            else {
              var holding = results[0].MemberID;
              connection.query("INSERT INTO Role(Type, Status, Description, Date, MemberID) " +
              "VALUES ('" + role.Type + "', '" + role.Status + "', '" +
              role.Description + "', '" + role.Date + "', '" + holding + "')", function (error, results, fields) {
              if(error) {
                response.json({
                  role_status: "FAILED"
                });
              }
              else
              {
                  response.json({
                    role_status: "SUCCESS"
                  });
              }
              });
            };
          });
        };
      });
    });
  
  // Stats Add Projects . . .
  // New project
  router.post('/create/project', function(request,response) {
    var entry = {
      Name: request.body.Name,
      Description: request.body.Description,
      Type: request.body.Type,
      FrontEnd: request.body.FrontEnd,
      BackEnd: request.body.BackEnd,
      RDS: request.body.RDS
    };
  
    connection.query('INSERT INTO Projects set ?', entry, function (error, results, fields) {
          if(error) {
              response.json({
                create_project: "Insert Failed",
                member_error: error,
              });
          }
          else {
              response.json({
                create_project: "Success!"
              })
            };
          });
        });
  
    router.post('/create/team', function(request,response) {
      var entry = {
        TeamName: request.body.TeamName,
        TeamNumber: '0',
        Semester: request.body.Semester,
        PhotoPath: 'temp.jpg',
        LabID: 1
      }
  
      var link = {
        TeamID: 0,
        ProjectID: request.body.ProjectID
      }
  
      connection.query('SELECT COALESCE(COUNT(*),0) AS "Count" FROM Teams Where Semester = "SU19"', function (error, results, fields) {
        if(error) {
          response.json({
            count_teams: "Failed to count!",
            team_error: error
          });
        }
        else {
          response.json({
            count: "cool"
          })
        }
  
      });
    });
  
  // Stats Add Assets . . .
  // FIX
  router.post('/add/asset', function(request,response) {
    var entry = {
      AssetID: request.body.AssetID,
      Type: request.body.Type,
      Description: request.body.Description,
      IsImaged: false,
      LabID: 1
    };
  
    entry.IsImaged = (request.body.IsImaged == "true") ? true : false;
  
    connection.query('INSERT INTO Assets set ?', entry, function (error, results, fields) {
          if(error) {
              response.json({
                add_asset: "Insert Failed",
                asset_error: error,
              });
          } else {
            response.json({
              add_asset: "Insert Failed"
            });
          }
    });
  });

module.exports = router