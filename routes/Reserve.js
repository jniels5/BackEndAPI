var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var cors = require('cors');
var bodyParser = require('body-parser')

var connection = require("../auth/Connect");

//--------------- Email Begin----------------
var nodemailer = require("nodemailer");

var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.NODEMAILER_EMAIL,
    pass: process.env.NODEMAILER_PASSWORD
  }
});
//--------------------------------------------

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
 
 // Used to get database information on Room Reservations
router.get('/select/:day', function(request,response) {
    let test = String(request.query.test).toLowerCase() == "true";
    let tableName = (!test) ? "Reservations" : "Reservations_TEST";
    connection.query('SELECT ReserveID, Start, End, RoomID, TeamID, Description, Email, Date FROM ' + tableName + ' WHERE Date = "' + request.params.day + 'T00:00:00.000Z"', function (error, results, fields) {
          if(error) {
              response.json( {
                select_reserve_status: "failed",
                select_error: error
              });
          }
          else {
              response.json(results);
          }
    });
  });
  router.get('/remove/:rID', function(request,response) {
    //used in connection.query
    var res;
    let test = String(request.query.test).toLowerCase() == "true";
    let tableName = (!test) ? "Reservations" : "Reservations_TEST";
    
    var emailQuery = "select WorkEmail, Description, Reservations.Date, Start, End, Reservations.RoomID AS RoomID, Teams.TeamNumber AS TeamNumber from Members INNER JOIN TeamMembers ON TeamMembers.MemberID=Members.MemberID INNER JOIN Teams ON TeamMembers.TeamID=Teams.TeamID INNER JOIN Reservations ON Teams.TeamNumber=Reservations.TeamID WHERE Reservations.ReserveID=? AND Teams.TeamID=(SELECT MAX(Teams.TeamID)   FROM Teams INNER JOIN Reservations ON Teams.TeamNumber=Reservations.TeamID WHERE Reservations.ReserveID=? GROUP BY Teams.TeamID ORDER BY Teams.TeamID DESC LIMIT 1);"
    connection.query(emailQuery,[request.params.rID, request.params.rID], function(error, results, fields) {
        if(error){
          res = "failed";
        }
        else{
          var teamEmails = [];
          for(var i in results){
              teamEmails.push(results[i].WorkEmail) + ','
           }
                   // EMAIL TOKEN
             var mailOptions = {
              from: 'CodeOrangeReservations@gmail.com',
              to: teamEmails,
              subject: 'code_orange Reservations',
              text: 'Your reservation has been canceled. \n\n Your reservation for team ' + results[0].TeamNumber + ' scheduled in room ' + results[0].RoomID + 
                    ' at ' + results[0].Start + ' scheduled until ' + results[0].End + ' has been canceled.  Please reschedule if you would like another room. \n\nReservation Description: ' + results[0].Description,
            };
  
            transporter.sendMail(mailOptions, function(error, info){
              if(error){
                res = "failed: email";
              }
              else {
                res = "sent: email";
              }
            });
            //END EMAIL TOKEN
        }
    })
    connection.query('DELETE FROM ' + tableName + ' WHERE ReserveID = ' + request.params.rID, function (error, results, fields) {
          if(error) {
              response.json({
                res = "failed",
                remove_status: res,
                remove_error: error
              });
          }
          else {
              response.json({
                res = "success",
                remove_status: res,
              });
          }
    });
  });
  // Delete all reservations (Deprecated)
  router.get('/delete', function(request,response) {
    //used in connection.query
    connection.query('DELETE FROM Reservations', function (error, results, fields) {
          if(error) {
              response.json({
                remove_status: "failed",
                remove_error: error
              });
          }
          else {
              response.json({
                remove_status: "success",
              });
          }
    });
  });
  // make into a put
  router.post('/update', function(request,response) {
    let test = String(request.body.test).toLowerCase() == "true";
    let tableName = (!test) ? "Reservations" : "Reservations_TEST";
    var query = 'UPDATE ' + tableName + ' SET Start = ' + mysql.escape(request.body.Start) + ', End = ' + mysql.escape(request.body.End) + ', Date = ' + mysql.escape(request.body.Date) + ', RoomID = ' + mysql.escape(request.body.RoomID) + ' WHERE ReserveID = ' + mysql.escape(request.body.ReserveID);
  
              //EMAIL TOKEN
             var emailQuery = "SELECT WorkEmail, Reservations.Description AS Description, Reservations.Date, Start, End, Reservations.RoomID AS RoomID, Teams.TeamNumber AS TeamNumber from Members INNER JOIN TeamMembers ON TeamMembers.MemberID=Members.MemberID "
             + "INNER JOIN Teams ON TeamMembers.TeamID=Teams.TeamID INNER JOIN Reservations ON Teams.TeamNumber=Reservations.TeamID"
             + " WHERE Reservations.ReserveID="+ mysql.escape(request.body.ReserveID) +" AND Teams.TeamID=(SELECT MAX(Teams.TeamID)FROM Teams INNER JOIN Reservations ON "
             + "Teams.TeamNumber=Reservations.TeamID WHERE Reservations.ReserveID="+ mysql.escape(request.body.ReserveID) + " GROUP BY Teams.TeamID ORDER BY Teams.TeamID DESC LIMIT 1);";
            connection.query(emailQuery,function (error, results, fields){
              if(error){
                console.log(error)
              }
              else{
                 var teamEmails = [];
                      for(var i in results){
                        teamEmails.push(results[i].WorkEmail) + ','
                      }
                    var mailOptions = {
                      from: 'CodeOrangeReservations@gmail.com',
                      to: teamEmails,
                      subject: 'code_orange Reservations',
                      text: 'Your Reservation has been updated.\n\nYour reservation for team ' + results[0].TeamNumber + ' has been updated to room '+ results[0].RoomID + ' beginning at ' + request.body.Start +
                      ' and scheduled to end at ' + request.body.End + '.\n\nReservation Description: ' + results[0].Description + '.'
                    };
  
                    transporter.sendMail(mailOptions, function(error, info){
                    });
                    //END EMAIL TOKEN
      }
    })
    connection.query(query, function (error, results, fields) {
          if(error) {
              response.json({
                update_status: "failed",
                update_error: error
              });
          }
          else {
              response.json({
                update_status: "success",
              });
          }
    });
  });
  
  
  router.post('/edit', function(request,response) {
    let startClause = '';
    let endClause = '';
  
    if(request.body.Start !== undefined)
    {
      startClause = ', Start = ' + mysql.escape(request.body.Start);
    }
    if(request.body.End !== undefined)
    {
      endClause = ', End = ' + mysql.escape(request.body.End);
    }
  
    let test = String(request.body.test).toLowerCase() == "true";
    let tableName = (!test) ? "Reservations" : "Reservations_TEST";
  
    //reservation time conflict check
    conflicts = 0;
      var entry = {
        Description: request.body.Description,
        Email: request.body.Email,
        Start: request.body.Start,
        End: request.body.End,
        Date: request.body.Date,
        RoomID: request.body.RoomID,
        TeamID: request.body.TeamID
      };
  
      //console.log(JSON.stringify(entry));
      let query = "SELECT COUNT(*) as c FROM " + tableName + " WHERE Date=" + mysql.escape(entry.Date) + " AND RoomID=" + mysql.escape(entry.RoomID) + " AND ReserveID<>" + mysql.escape(request.body.ReserveID) + " AND ((" + mysql.escape(String(entry.Start).substring(0,7) + "1") + " BETWEEN Start AND End) OR (" + mysql.escape(entry.End) + " BETWEEN Start AND End) OR (Start BETWEEN " + mysql.escape(String(entry.Start).substring(0,7) + "1") + " AND " + mysql.escape(entry.End) + ") OR (End BETWEEN " + mysql.escape(String(entry.Start).substring(0,7) + "1") + " AND " + mysql.escape(entry.End) + "));";
      connection.query(query, function(error, results, fields) {
        if(error)
        {
          response.json({
            checkin_status: "failed",
            checkin_error: error,
          });
        }
  
        //check if a reservation already occupies timeslot
        else
        {
          conflicts = results[0].c;
          if (conflicts > 0)
          {
            response.json({
              checkin_status: "failed",
              checkin_error: "Reservation already occupies timeslot",
              conflict_count: conflicts,
            });
          }
  
          // proceed with updating reservation
          else
          {
            //var query = 'UPDATE ' + tableName + ' SET Description = ' + mysql.escape(request.body.Description) + startClause + endClause + ', Email = ' + mysql.escape(request.body.Email) + ', TeamID = ' + mysql.escape(request.body.TeamID) + ' ' + 'WHERE ReserveID = ' + mysql.escape(request.body.ReserveID);
  
            connection.query('UPDATE ' + tableName + ' SET Description = ' + mysql.escape(request.body.Description) + startClause + endClause + ', Email = ' + mysql.escape(request.body.Email) + ', TeamID = ' + mysql.escape(request.body.TeamID) + ' ' + 'WHERE ReserveID = ' + mysql.escape(request.body.ReserveID), function (error, results, fields) {
              if(error) {
                response.json({
                  edit_status: "failed",
                  sql_query: query,
                  edit_error: error
                });
              }
              else {
                response.json({
                  edit_status: "success",
                  sql_query: query,
                  conflict_count: conflicts,
                });
              }
            });
          }
        }   //end of initial else
      });
    }); // end of '/edit'
  
  
  router.post('/insert', function(request,response) {
    //used in connection.query
    console.log(request);
    let test = String(request.body.test).toLowerCase() == "true";
    let tableName = (!test) ? "Reservations" : "Reservations_TEST";
    conflicts = 0;
      var entry = {
        Description: request.body.Description,
        Email: request.body.Email,
        Start: request.body.Start,
        End: request.body.End,
        Date: request.body.Date,
        RoomID: request.body.RoomID,
        TeamID: request.body.TeamID
      };
    //EMAIL TOKEN
    //Query for emails based on team
    let emailQuery = "SELECT WorkEmail FROM (Teams INNER JOIN TeamMembers ON Teams.TeamID=TeamMembers.TeamID) INNER JOIN Members ON TeamMembers.MemberID=Members.MemberID WHERE Teams.TeamNumber=" +
    mysql.escape(request.body.TeamID) + " AND Teams.TeamID = (SELECT MAX(Teams.TeamID) FROM (Teams INNER JOIN TeamMembers ON Teams.TeamID=TeamMembers.TeamID) INNER JOIN Members ON TeamMembers.MemberID=Members.MemberID WHERE Teams.TeamNumber="+
    mysql.escape(request.body.TeamID) +" GROUP BY Teams.TeamID ORDER BY Teams.TeamID DESC LIMIT 1);"
  
    //console.log(JSON.stringify(entry));
    let query = "SELECT COUNT(*) as c FROM " + tableName + " WHERE Date=" + mysql.escape(entry.Date) + " AND RoomID=" + mysql.escape(entry.RoomID) + 
    " AND ((" + mysql.escape(String(entry.Start).substring(0,7) + "1") + " BETWEEN Start AND End) OR (" + mysql.escape(entry.End) + " BETWEEN Start AND End) OR (Start BETWEEN " 
    + mysql.escape(String(entry.Start).substring(0,7) + "1") + " AND " + mysql.escape(entry.End) + ") OR (End BETWEEN " + mysql.escape(String(entry.Start).substring(0,7) + "1") + 
    " AND " + mysql.escape(entry.End) + "));";
  
    connection.query(query, function(error, results, fields) {
        if(error)
        {
          response.json({
            checkin_status: "failed",
            checkin_error: error,
          });
        }
  
        //check if a reservation already occupies timeslot
        else
        {
          conflicts = results[0].c;
          if (conflicts > 0)
          {
            response.json({
              checkin_status: "failed",
              checkin_error: "Reservation already occupies timeslot",
              conflict_count: conflicts,
            });
          }
  
          // proceed with inserting a reservation
          else
          {
            connection.query('INSERT INTO ' + tableName + ' set ?', entry, function (error, results, fields) {
              if(error) {
                response.json({
                  checkin_status: "failed",
                  checkin_error: error,
                });
              }
            else {
              response.json({
                checkin_status: "success",
                conflict_count: conflicts,
                });
              }
            });
          }
        }
    });
  
    connection.query(emailQuery , function(error, results, fields){
      if(error){
        response.json(null)
      }
      else{
        var teamEmails = [];
        for(var i in results){
          teamEmails.push(results[i].WorkEmail) + ','
        }
         var mailOptions = {
          from: 'CodeOrangeReservations@gmail.com',
          to: teamEmails,
          subject: 'code_orange Reservations',
          text: 'Your Reservation for team ' + request.body.TeamID +
          ' has been made.  \nIt is scheduled for room ' + request.body.RoomID + ' at '
          + request.body.Start + ' scheduled until ' + request.body.End + '.\n\nReservation Description: ' + request.body.Description + '.',
        };
  
            transporter.sendMail(mailOptions, function(error, info){
              if(error){
                response.json(null)
              }
              else {
                response.json({email: "sent"})
              }
            });
            // END EMAIL TOKEN
      }
    })
  });

  module.exports = router