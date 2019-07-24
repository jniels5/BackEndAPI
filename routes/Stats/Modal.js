var express = require('express');
var router = express.Router();
var mysql = require('mysql');

var connection = require("../../auth/Connect");
var useCors = require("../../auth/Cors");

useCors();

// Stats Update Record Calls . . .
router.post('/post', function(request,response) {
    // used in connection.query
    var entry = {
      FirstName: request.body.FirstName,
      LastName: request.body.LastName,
      Gender: request.body.Gender,
      GradSemester: request.body.GradSemester,
      GradYear: request.body.GradYear,
      Email: request.body.Email,
      WorkEmail: request.body.WorkEmail,
      MemberID: request.body.MemberID
    };
  
    var roleEntry = {
      Type: request.body.Type,
      Status: request.body.Status,
      Description: request.body.Description,
      Date: request.body.Date
    }
  
    connection.query('SET foreign_key_checks = 0; ' +
    'UPDATE Members SET ? WHERE MemberID = ' + request.body.MemberID + ";" +
    'SET foreign_key_checks = 1;', entry, function (error, results, fields) {
      if(error) {
        response.json({modal_post: "failed: " + error, entry: entry});
      }
      else {
        connection.query('SET foreign_key_checks = 0; ' +
        'UPDATE Role SET ? WHERE MemberID = ' + request.body.MemberID + ";" +
        'SET foreign_key_checks = 1;', roleEntry, function (error, results, fields) {
          if(error) {
            response.json({modal_post: "failed: " + error, entry: entry});
          }
          else {
          }
        });
      }
    });
  });
  
  router.post('/post/teams', function(request,response) {
    // used in connection.query
    var entry = {
      TeamName: request.body.TeamName,
      TeamNumber: request.body.TeamNumber,
      Semester: request.body.TeamSemester,
      PhotoPath: request.body.PhotoPath,
      LabID: request.body.LabID
    };
  
    var ProjectEntry = {
      Name: request.body.ProjectName,
      Description: request.body.ProjectDesc,
      Paragraph: request.body.ProjectPara,
      FrontEnd: request.body.ProjectFend,
      BackEnd: request.body.ProjectBend,
      RDS: request.body.ProjectRDS
    }
  
    connection.query('SET foreign_key_checks = 0; ' +
    'UPDATE Teams SET ? WHERE TeamID = ' + request.body.TeamID + ";" +
    'SET foreign_key_checks = 1;', entry, function (error, results, fields) {
      if(error) {
        response.json({modal_post: "failed: " + error, entry: entry});
      }
      else {
        connection.query('SET foreign_key_checks = 0; ' +
        'UPDATE Projects SET ? WHERE ProjectID = ' + request.body.ProjectID + ";" +
        'SET foreign_key_checks = 1;', ProjectEntry, function (error, results, fields) {
          if(error) {
            response.json({modal_post: "failed: " + error, entry: entry});
          }
          else {
          }
        });
      }
    });
  });

module.exports = router