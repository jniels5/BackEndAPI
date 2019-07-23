var express = require('express');
var router = express.Router();
var mysql = require('mysql')

var connection = require("../auth/Connect.js").connection;

////////////////////////////////////////////////////
//                                                //
//    Metrics API Calls                           //
//                                                //
////////////////////////////////////////////////////
  
  // Manager Dashboard graph data
  router.get('/recent/semesters', function(request,response) {
    var totals = {
      Total1: 0, Total2: 0, Total3: 0, Grad1: 0, Grad2: 0, Grad3: 0
    }
  
    connection.query('SELECT SUM(CASE WHEN T.Semester = "FA18" THEN 1 ELSE 0 END) Total3, ' +
                     'SUM(CASE WHEN T.Semester = "SP19" THEN 1 ELSE 0 END) Total2, ' +
                     'SUM(CASE WHEN T.Semester = "SU19" THEN 1 ELSE 0 END) Total1, ' +
                     'SUM(CASE WHEN T.Semester = "FA18" AND M.GradSemester = "Fall" AND M.GradYear = "2018" THEN 1 ELSE 0 END) Grad3, ' +
                     'SUM(CASE WHEN T.Semester = "SP19" AND M.GradSemester = "Spring" AND M.GradYear = "2019" THEN 1 ELSE 0 END) Grad2, ' +
                     'SUM(CASE WHEN T.Semester = "SU19" AND M.GradSemester = "Summer" AND M.GradYear = "2019" THEN 1 ELSE 0 END) Grad1 ' + 
                     'FROM Members M, Teams T, TeamMembers TM ' +
                     'WHERE TM.TeamID = T.TeamID AND M.MemberID = TM.MemberID', function (error, results, fields) {
      if(error) {
        response.json({sem_totals: "failed"});
      }
      else {
        console.log({results})
        
        totals.Total1 = results[0].Total1;
        totals.Total2 = results[0].Total2;
        totals.Total3 = results[0].Total3;
        totals.Grad1 = results[0].Grad1;
        totals.Grad2 = results[0].Grad2;
        totals.Grad3 = results[0].Grad3;
  
        response.json({totals})
      }
    });
  });

  // Total Interns / Open House
  router.get('/total/interns', function(request,response) {
    connection.query('SELECT COUNT(*) "Count" FROM Members, Role WHERE Members.MemberID = Role.MemberID AND Role.Type = "Intern" AND Role.Status != "Not Active"', function (error, results, fields) {
      if(error) {
        response.json({Metrics_get: "failed"});
      }
      else {
        response.json(results);
      }
    });
  });
  
  router.get('/total/OH', function(request,response) {
    connection.query('SELECT COUNT(*) "OpenHouse" FROM Members, Role WHERE Members.MemberID = Role.MemberID AND Role.Type = "Open House"', function (error, results, fields) {
      if(error) {
        response.json({Metrics_get: "failed"});
      }
      else {
        response.json(results);
      }
    });
  });

module.exports = router