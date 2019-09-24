var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var cors = require('cors');
var bodyParser = require('body-parser')

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
router.use(bodyParser.json());

////////////////////////////////////////////////////
//                                                //
//    Student Portal                              //
//                                                //
////////////////////////////////////////////////////

router.get('/portal/check', function(request, response) {
  var WorkEmail = decodeURIComponent(request.body.WorkEmail)

  let query = "SELECT * FROM Members WHERE WorkEmail = '" + WorkEmail + "';";

  connection.query(query, function(error) {
    if(error) {
      response.json({email_verify: "failed"});
    }
    else{
      response.json({email_verify: "success"});
    }
  })
})

router.get('/portal/info', function(request,response) {
    let query = 'SELECT m.MemberID, m.FirstName, m.LastName, m.GradSemester, m.GradYear, m.Email, m.AssetID, m.Gender, m.Email, m.PhoneNum, m.WorkEmail, m.SuperUser, ' +
                     't.TeamNumber, t.TeamName, t.Semester, t.PhotoPath, t.LabID, ' +
                     'r.Type, r.Status, r.Description, r.Date, ' +
                     'p.ProjectID, p.Name, p.Description, p.Paragraph, p.FrontEnd, p.BackEnd, p.RDS ' +
                     'FROM Members AS m, Role AS r, TeamMembers AS tm, Teams AS t, TeamProjects AS tp, Projects AS p ' +
                     'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = t.TeamID ' +
                     'AND t.TeamID = tp.TeamID AND tp.ProjectID = p.ProjectID AND m.WorkEmail = "' + request.query.WorkEmail + '"';
    connection.query(query, function (error, results, fields) {
          if(error) {
              response.json({student_select: "failed",
                             error: error});
          }
          else {
              response.json(results[results.length - 1]);
          }
    });
  });
  
  router.post('/portal/update', function(request,response) {
    // used in connection.query
    var membUpdate = {
      Gender: request.body.Gender,
      GradSemester: request.body.GradSemester,
      GradYear: request.body.GradYear,
      Email: request.body.Email,
      PhoneNum: request.body.PhoneNum
    };

    var projUpdate = {
      Name: request.body.Name,
      Paragraph: request.body.Paragraph,
      FrontEnd: request.body.FrontEnd,
      BackEnd: request.body.BackEnd,
      RDS: request.body.RDS
    };

    var teamUpdate = {
      TeamName: request.body.TeamName,
      PhotoPath: request.body.PhotoPath
    };
  
    connection.query('SET foreign_key_checks = 0; ' +
    'UPDATE Members SET ? WHERE MemberID = ' + request.body.MemberID + ";", membUpdate, function (error) {
      if(error) {
        response.json({student_update_member: "failed: " + error});
      }
    });

    connection.query('UPDATE Teams SET ? WHERE TeamID = ' + request.body.TeamID + "; ", teamUpdate, function (error) {
        if(error) {
          response.json({student_update_team: "failed: " + error});
        }
      });

      connection.query('UPDATE Projects SET ? WHERE ProjectID = ' + request.body.ProjectID + "; " +
        'SET foreign_key_checks = 1;', projUpdate, function (error) {
          if(error) {
            response.json({student_update_project: "failed: " + error});
          } else {
            response.json({student_update: "success"})
          }
        });
  });

module.exports = router