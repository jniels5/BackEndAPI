var runfile = require('./runfile.js');
var bodyParser = require('body-parser')
var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()

// Connection 
var connection = require("./auth/Connect");

// Pull in route files
var Login = require('./routes/Login.js');
var MAP = require("./routes/MAP.js");
var Metrics = require("./routes/Metrics.js");
var PCFRoutes = require('./routes/PCF.js');
var Stats = require('./routes/Stats.js');

// Specify Paths
app.use('/login/', Login);
app.use('/map/', MAP);
app.use('/metrics/', Metrics);
app.use('/pcf/', PCFRoutes);
app.use('/stats/', Stats);

server = require('http').createServer(app);

io = require('socket.io')(server);

io.on('connection', function(socket)
{
  console.log("a user connected");
});

var conflicts;
//--------------- Email Begin----------------
var nodemailer = require("nodemailer");

var transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'CodeOrangeReservations@gmail.com',
    pass: 'Scrumptious7!'
  }
});

/*
var mailOptions = {
  from: 'CodeOrangeReservations@gmail.com',
  to: 'danielomalley@discover.com',
  subject: 'Reservations Page Email',
  text: 'api email start'
};

transporter.sendMail(mailOptions, function(error, info){
  if(error){
    res.json(null)
  }
  else{
    res.json({email: 'sent'})
  }
})
*/

//-------------- Email End ---------------------

var whitelist = [
  'http://localhost:3000/',
  'http://team11-frontend.mjhmkfjvi5.us-east-2.elasticbeanstalk.com/'
]
//keep out the baddies
var corsOptions = {
  origin: '*', //use whitelist when localhost testing isn't needed
  //origin: whitelist,
  methods: 'GET,HEAD,POST,OPTIONS,DELETE',
  "preflightContinue": true
}
//app.use(cors()); uncomment to enable cors for everything
app.use(cors(corsOptions)); //use cors with options enables
//app.options('*', cors(corsOptions)); //enables preflight options
app.use(bodyParser.json()); //Parses POST Data

app.set('port', (process.env.PORT || 5000))

app.listen(app.get('port'), function() {
  console.log("Node app is running at localhost:" + app.get('port'));
});

//pretty much useless, used it to test db connection
app.get('/', function(request,response) {
  if(!conn_succ) {
    response.json({connect_status: 'Failed'});
  }
  else {
    response.json({connect_status: 'Success'});
  }
});

// Used to get All info from each table
app.get('/select/table/:table', function(request,response) {
  let tag = (String(request.query.test).toLowerCase() == "true") ? "_TEST" : "";
  let query = 'SELECT * FROM '  +  mysql.escapeId(request.params.table + tag);
  connection.query(query, function (error, results, fields) {
        if(error) {
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

///////////////////////////////////////////////////////////
//                                                       //
//  Atlas - Backend API Calls                            //
//                                                       //
///////////////////////////////////////////////////////////

//********************************************
//  code_orange Website API                  *
//********************************************

// Checkin page for guests (OH and events)
app.post('/checkin', function(request,response) {
  //used in connection.query
  var entry = {
    FirstName: request.body.firstName,
    LastName:  request.body.lastName,
    Gender: '',
    GradSemester: '',
    GradYear: request.body.gradYear,
    Email: request.body.email,
    WorkEmail: '',
    Major: request.body.major,
    AssetID: 10000000,
    LabID: 1
  };

  connection.query('INSERT INTO Members set ?', entry, function (error, results, fields) {
        if(error) {
            response.json({
              checkin_status: "Insert Failed",
              checkin_error: error,
            });
        }
        else {
          connection.query('SELECT MemberID FROM Members WHERE FirstName = "' + entry.FirstName + '" AND LastName = "' + entry.LastName + '"', function (error, results, fields) {
          if(error) {
              response.json({
                checkin_status: "Testing Failed",
                checkin_error: error,
              });
          }
          else {
            var holding = results[0].MemberID;
            connection.query("INSERT INTO Role(Type, Status, Description, Date, MemberID) VALUES ('Open House', 'Attendee', 'Spring code_orange open house', '2019-3-28', '" + holding + "')", function (error, results, fields) {
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

// Select Info for Teams page
app.get('/select/teamPageData/:semester', function(request,response) {
  connection.query('SELECT Teams.TeamName, Teams.Semester, Teams.TeamNumber, Teams.PhotoPath,' +
                    'Projects.Name, Projects.Description, Projects.Paragraph, Projects.FrontEnd, Projects.Backend, ' +
                    'Projects.RDS FROM Teams ' +
                    'JOIN TeamProjects ON Teams.TeamID = TeamProjects.TeamID ' +
                    'JOIN Projects ON Projects.ProjectID = TeamProjects.ProjectID ' +
                    'AND Teams.Semester = "' + request.params.semester + '" ORDER BY Teams.TeamNumber', function (error, results, fields) {
        if(error) {
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Team Member Query
app.get('/select/table/Members/team/:team/:semester', function(request,response) {
  connection.query('SELECT Members.FirstName, Members.LastName, Members.WorkEmail, Members.PhotoPath FROM Members ' +
                    'JOIN TeamMembers ON TeamMembers.MemberID = Members.MemberID ' +
                    'JOIN Teams ON Teams.TeamID = TeamMembers.TeamID ' +
                    'JOIN TeamProjects ON Teams.TeamID = TeamProjects.TeamID ' +
                    'JOIN Projects ON Projects.ProjectID = TeamProjects.ProjectID ' +
                    'WHERE Teams.TeamNumber = ' + request.params.team + ' ' +
                    'AND Teams.Semester = "' + request.params.semester + '" ORDER BY FirstName', function (error, results, fields) {
        if(error) {
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Used to get database information on Room Reservations
app.get('/select/Reservation/:day', function(request,response) {
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
app.get('/remove/reservation/:rID', function(request,response) {
  //used in connection.query
  let test = String(request.query.test).toLowerCase() == "true";
  let tableName = (!test) ? "Reservations" : "Reservations_TEST";
  
    var emailQuery = "select WorkEmail, Description, Reservations.Date, Start, End, Reservations.RoomID AS RoomID, Teams.TeamNumber AS TeamNumber from Members INNER JOIN TeamMembers ON TeamMembers.MemberID=Members.MemberID INNER JOIN Teams ON TeamMembers.TeamID=Teams.TeamID INNER JOIN Reservations ON Teams.TeamNumber=Reservations.TeamID WHERE Reservations.ReserveID=? AND Teams.TeamID=(SELECT MAX(Teams.TeamID)   FROM Teams INNER JOIN Reservations ON Teams.TeamNumber=Reservations.TeamID WHERE Reservations.ReserveID=? GROUP BY Teams.TeamID ORDER BY Teams.TeamID DESC LIMIT 1);"
  connection.query(emailQuery,[request.params.rID, request.params.rID], function(error, results, fields) {
      if(error){
           response.json({
              remove_status: "failed",
              remove_error: error
            });
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
              response.json(null)
            }
            else {
              response.json({email: "sent"})
            }
          });
          //END EMAIL TOKEN
      }
  })
  connection.query('DELETE FROM ' + tableName + ' WHERE ReserveID = ' + request.params.rID, function (error, results, fields) {
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
// Delete all reservations (Deprecated)
app.get('/delete/reservations', function(request,response) {
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
app.post('/update/reserve', function(request,response) {
  let test = String(request.body.test).toLowerCase() == "true";
  let tableName = (!test) ? "Reservations" : "Reservations_TEST";
  var query = 'UPDATE ' + tableName + ' SET Start = ' + mysql.escape(request.body.Start) + ', End = ' + mysql.escape(request.body.End) + ', Date = ' + mysql.escape(request.body.Date) + ', RoomID = ' + mysql.escape(request.body.RoomID) + ' WHERE ReserveID = ' + mysql.escape(request.body.ReserveID);
  //console.log("update/reserve", query);

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


app.post('/edit/reserve', function(request,response) {
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
  //taken from /insert/reserve
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
    //console.log("edit/reserve query", query);
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
  }); // end of '/edit/reserve'


app.post('/insert/reserve', function(request,response) {
  //used in connection.query
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

  //console.log("insert/reserve query", query);
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

app.get('/login/attempts/get', function(request, response){

  var query = 'SELECT LoginAttempts.Attempts, Members.MemberID, Members.WorkEmail FROM LoginAttempts INNER JOIN Members ON LoginAttempts.MemberID = Members.MemberID WHERE WorkEmail = ' + mysql.escape(request.query.WorkEmail) + ';';

  connection.query(query, function (error, results, fields) {
        if(error) {
            response.json({
              edit_status: "failed",
              sql_query: query,
              edit_error: error
            });
        }
        else {
            response.json(results);
                if(results[0].Attempts >= 5){
                 var mailOptions = {
                  from: 'codeorange@discover.com',
                  to: results[0].WorkEmail,
                  subject: 'code_orange Reservations',
                  text: 'The account of ' + results[0].WorkEmail +
                  ' has been locked out. Please contact an administrator for more infomation'
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
        }
  });

});

app.post('/login/attempts/post', function(request, response){
  
  let query = 'UPDATE LoginAttempts SET Attempts = ' + mysql.escape(request.body.Number) + ' WHERE MemberID = (SELECT MemberID FROM Members WHERE WorkEmail = ' + mysql.escape(request.body.WorkEmail) + ');';

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
})
});

app.post('/login/attempts/insert', function(request, response){

  let query = 'INSERT IGNORE INTO LoginAttempts VALUES((SELECT MemberID FROM Members WHERE WorkEmail= ' + mysql.escape(request.body.WorkEmail) + ' ) , 0);';

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
})
});


app.post('/login/attempts/update', function(request, response){

  let query = 'UPDATE LoginAttempts SET Attempts = 0 WHERE MemberID = (SELECT MemberID FROM Members WHERE WorkEmail = ' + mysql.escape(request.body.WorkEmail) + ');';

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
})
});

////////////////////////////////////////////////////
//                                                //
//    Misc API Calls                              //
//                                                //
////////////////////////////////////////////////////

//runs a specified sql file (**Needs error handling**)
app.get('/runfile/:file', function(request,response) {
  try{
      runfile.execFile(connection, './' + request.params.file, response);
  }
  catch(error) {
    response.json( {
      runfile_status: "Failed",
      runfile_error: error
    });
    return;
  }
  response.json({runfile_status: "Success"});
});

//funciton is used to send an email to the userpool
app.get('/getmail', function(request,response){
  //EMAIL TOKEN
  transporter.sendMail(mailOptions, function(error, info){
    if(error){
      response.json(null)
    }
    else{
      response.json({email: "sent"})
    }
  })
});
  //END EMAIL TOKEN

decodeSemester = function(val)
    {
        let semester;
        if(val.length === 4)
        {
            switch (val.toUpperCase().substr(0,2))
            {
                case "FA":
                    semester = "FALL ";
                    break;
                case "SU":
                    semester = "SUMMER ";
                    break;
                case "SP":
                    semester = "SPRING ";
                    break;
                default:
                    semester = val;
                    break;
            }
            let year = Number(val.substr(2,2));
            if(!isNaN(year))
            {
                semester += "20" + String(year);
            }
            return semester;
        }
        return val;
    }
