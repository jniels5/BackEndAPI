var express = require('express');
var router = express.Router();
var mysql = require('mysql');

var connection = require("../auth/Connect");

//********************************************
//  MAP API                                  *
//********************************************

// Delegations

router.post('/insert/delegations/', function(request,response) {
    //used in connection.query
    var entry = {
      Delegator: request.body.Delegator,
      Email: request.body.Email,
      Delegatee: request.body.Delegatee,
      StartDate: request.body.StartDate,
      EndDate: request.body.EndDate,
      Description: request.body.Description,
      State: request.body.State,
      Status: request.body.Status
    };
  
    connection.query('INSERT INTO Delegations set ?', entry, function (error, results, fields) {
      if(error) {
          response.json({
            insert_delegation: "failed",
            delegation_error: error,
          });
      }
      else {
          response.json({
            delegation_status: "success",
          });
        }
      });
    });
  
  router.post('/update/delegations', function(request,response) {
      // used in connection.query
      var entry = {
        Delegator: request.body.Delegator,
        Email: request.body.Email,
        Delegatee: request.body.Delegatee,
        StartDate: request.body.StartDate,
        EndDate: request.body.EndDate,
        Description: request.body.Description,
        State: request.body.State,
        Status: request.body.Status
      };
  
      connection.query('SET foreign_key_checks = 0; ' +
      'UPDATE Delegations SET ? WHERE DelegationID = ' + request.body.DelegationID + ";" +
      'SET foreign_key_checks = 1;', entry, function (error, results, fields) {
        if(error) {
          response.json({update_delegations: "failed"});
        }
        else {
          response.json({update_delegations: "success"})
        }
      });
    });
  
  // Removes all entries (Deprecated)
  router.get('/delete/delegations', function(request,response) {
      connection.query('DELETE FROM Delegations;', function (error, results, fields) {
        if(error) {
          response.json({delete_delegations: "failed"});
        }
        else {
          response.json({delete_delegations: "success"})
        }
      });
    });
  
  // Removes specific entry
  router.get('/remove/delegation/:dID', function(request,response) {
      connection.query('DELETE FROM Delegations WHERE DelegationID = ' + request.params.dID + ';', function (error, results, fields) {
        if(error) {
          response.json({remove_delegation: "failed"});
        }
        else {
          response.json({remove_delegation: "success"})
        }
      });
    });
  
    // Approvals
  
  router.post('/insert/approvals/', function(request,response) {
      //used in connection.query
      var entry = {
        Email: request.body.Email,
        FullName: request.body.FullName,
        Service: request.body.Service,
        Description: request.body.Description,
        RequestedBy: request.body.RequestedBy,
        RequestedDate: request.body.RequestedDate,
        CloseDate: request.body.CloseDate,
        Status: request.body.Status
      };
  
      connection.query('INSERT INTO ApprovalsHistory set ?', entry, function (error, results, fields) {
        if(error) {
            response.json({
              approval_status: "failed",
              approval_error: error,
            });
        }
        else {
            response.json({
              approval_status: "success",
            });
          }
        });
      });

      module.exports = router