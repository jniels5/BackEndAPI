var express = require('express');
var router = express.Router();
var mysql = require('mysql');

var connection = require("../../auth/Connect");

// Stats Filter Calls . . .
router.get('/status', function(request,response) {
    //Returns members for the specified semester and filter by type "Intern" or "Former Intern"
    var Intern = '';
    var FullTime = '';
  
    if (String(request.query.Interns).toLowerCase() == "true")
    {
      Intern = '"Intern", '
    }
    if (String(request.query.FullTimeHire).toLowerCase() == "true")
    {
      FullTime = '"Former Intern", '
    }
  
    let query = 'SELECT m.MemberID, m.FirstName, m.LastName, Teams.TeamNumber, r.Type, ' +
                     'm.GradYear, m.Email, m.AssetID, m.GradSemester, r.Status, r.Description, r.Date, tm.TeamID, ' +
                     'Teams.TeamName, Teams.Semester, m.Gender, m.WorkEmail FROM Members m ' +
                     'LEFT JOIN Role r ON r.MemberID = m.MemberID ' +
                     'LEFT JOIN TeamMembers tm ON tm.MemberID = m.MemberID ' +
                     'LEFT JOIN Teams ON Teams.TeamID = tm.TeamID ' +
                     'WHERE r.Type IN (' + Intern + FullTime +
                     '"N/a" ) AND Teams.Semester = ' + mysql.escape(request.query.Semester) + ' ORDER BY m.MemberID';
  
    connection.query(query, function (error, results, fields) {
          if(error) {
              response.json({Status_Select: "failed"});
          }
          else {
              response.json(results);
          }
    });
  });
  
  router.get('/teams', function(request,response) {
  //get team details from semester and team number
    let query = 'SELECT Teams.TeamName, Teams.TeamNumber, Projects.Name, Projects.Type, ' +
                     'Projects.Description, Projects.Paragraph, Projects.FrontEnd, ' +
                     'Projects.Backend, Projects.RDS, Teams.Semester, Teams.PhotoPath, ' +
                     'Teams.LabID, Teams.TeamID, Projects.ProjectID FROM Teams ' +
                     'JOIN TeamProjects ON Teams.TeamID = TeamProjects.TeamID ' +
                     'JOIN Projects ON Projects.ProjectID = TeamProjects.ProjectID ' +
                     'WHERE Teams.TeamNumber = ' + mysql.escape(request.query.TeamNumber)  +
                     ' AND Teams.Semester = ' + mysql.escape(request.query.Semester) + ';';
    connection.query(query, function (error, results, fields) {
          if(error) {
              response.json({Status_Select: "failed"});
          }
          else {
              response.json(results);
          }
    });
  });
  
  router.get('/equipment', function(request,response) {
    var Laptops = '';
    var Televisons = '';
    var MobileDevices = '';
  
    if (String(request.query.Laptops).toLowerCase() == "true")
    {
      Laptops = '"Laptop", '
    }
    if (String(request.query.Televisions).toLowerCase() == "true")
    {
      Televisons = '"Television", '
    }
    if (String(request.query.MobileDevices).toLowerCase() == "true")
    {
      MobileDevices = '"Mobile Device", '
    }
  
    let query = 'SELECT a.AssetID, a.Description, a.Type, m.FirstName, m.LastName ' +
                     'FROM Assets a LEFT JOIN Members m ON m.AssetID = a.AssetID ' +
                     'WHERE a.Type IN (' + Laptops + Televisons + MobileDevices +
                     '"N/a" ) AND a.AssetID != 10000000 AND a.IsImaged >= 0 GROUP BY a.AssetID';
  
  
    connection.query(query, function (error, results, fields) {
          if(error) {
              response.json({Status_Select: "failed"});
          }
          else {
              response.json(results);
          }
    });
  });
  
  router.get('/newbs', function(request,response) {
    let query = 'SELECT m.MemberID, m.FirstName, m.LastName, r.Type, ' +
                     'm.GradYear, m.Email, m.AssetID, m.GradSemester, r.Status, r.Description, r.Date, ' +
                     'm.Gender FROM Members m LEFT JOIN Role r ON r.MemberID = m.MemberID ' +
                     'WHERE r.Type IN ( "Open House", "Applicant" ) ORDER BY m.MemberID';
  
    connection.query(query, function (error, results, fields) {
          if(error) {
              response.json({newb_Select: "failed"});
          }
          else {
              response.json(results);
          }
    });
  });

  module.exports = router