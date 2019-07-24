var runfile = require('./runfile.js');
var bodyParser = require('body-parser')
var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()
var fs = require('fs');

server = require('http').createServer(app);

io = require('socket.io')(server);

io.on('connection', function(socket)
{
  console.log("a user connected");
});



var mes, res;
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

//creating connection object
var connection = mysql.createConnection({
  host     : process.env.RDS_HOSTNAME || "team11-database.cpfq5d1i5xkj.us-east-2.rds.amazonaws.com",
  user     : process.env.RDS_USERNAME || "Team11",
  password : process.env.RDS_PASSWORD || "CCCJMS11",
  port     : process.env.RDS_PORT     || "3306",
  database : process.env.RDS_DB_NAME  || "ebdb",
  multipleStatements: true //used for running an sql file
});
var conn_succ = false; //checks connection status, will probably get rid of this soon

//connect to db
connection.connect(function(err) {
  if (err) {
    conn_succ = false;
    //Worthless right not, haven't been able to access aws logs
    console.log('Not Connected to database.'); //but maybe some day
    return;
  }
  //yussssssssss
  conn_succ = true;
  console.log('Connected to database.');
});

// Pull in route files
var MAP = require("./routes/MAP.js");
var Metrics = require("./routes/Metrics.js");
var PCFRoutes = require('./routes/PCF.js');
var Stats = require('./routes/Stats.js');

// Specify Paths
app.use('/map/', MAP);
app.use('/metrics/', Metrics);
app.use('/pcf/', PCFRoutes);
app.use('/stats/', Stats);

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

////////////////////////////////////////////////////
//                                                //
//    Statistics API Calls                        //
//                                                //
////////////////////////////////////////////////////

// Stats Page Info Calls . . .
// Team Names by Semester
app.get('/stats/teams/names', function(request,response) {
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

// Lists all teams, groups by semester
app.get('/stats/lab/semesters', function(request,response) {
  connection.query('SELECT Semester FROM Teams GROUP BY Semester ORDER BY TeamID DESC;', function (error, results, fields) {
        if(error) {
            response.json({semester_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Add new members with a role to database
app.post('/stats/add/member', function(request,response) {
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
app.post('/stats/create/project', function(request,response) {
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

  app.post('/stats/create/team', function(request,response) {
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
app.post('/stats/add/asset', function(request,response) {
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

////////////////////////////////////////////////////
//                                                //
//    Student Portal                              //
//                                                //
////////////////////////////////////////////////////

app.get('/student/portal/info', function(request,response) {
  let query = 'SELECT m.MemberID, m.FirstName, m.LastName, m.GradSemester, m.GradYear, m.Email, m.AssetID, m.Gender, m.Email, m.WorkEmail, m.SuperUser, ' +
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

app.post('/student/portal/update', function(request,response) {
  // used in connection.query
  var entry = {
    FirstName: request.body.FirstName,
    LastName: request.body.LastName,
    Gender: request.body.Gender,
    GradSemester: request.body.GradSemester,
    GradYear: request.body.GradYear,
    Email: request.body.Email,
    PhoneNum: request.body.PhoneNum,
    MemberID: request.body.MemberID
  };

  connection.query('SET foreign_key_checks = 0; ' +
  'UPDATE Members SET ? WHERE MemberID = ' + request.body.MemberID + ";" +
  'SET foreign_key_checks = 1;', entry, function (error, results, fields) {
    if(error) {
      response.json({student_update: "failed: " + error, entry: entry});
    } else {
      respose.json({student_update: "success"})
    }
  });
});
////////////////////////////////////////////////////
//                                                //
//    Email API Calls                             //
//                                                //
////////////////////////////////////////////////////

app.get('/email/Intern/PO', function(request,response) {
  connection.query('SELECT ' + request.query.ContactType + ' FROM Members ' +
                   'JOIN TeamMembers ON TeamMembers.MemberID = Members.MemberID ' +
                   'JOIN Teams ON Teams.TeamID = TeamMembers.TeamID '+
                   'JOIN Role ON Role.MemberID = Members.MemberID ' +
                   'WHERE ' + request.query.Teams + 'Teams.Semester = ' + mysql.escape(request.query.Semester) + ' AND ' +
                   request.query.Role, function (error, results, fields) {
    if(error) {
      response.json({email_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/email/Applicants/OH', function(request,response) {
  connection.query('SELECT ' + request.query.ContactType + ' FROM Members ' +
                   'JOIN Role ON Role.MemberID = Members.MemberID ' +
                   'WHERE ' + request.query.Role, function (error, results, fields) {
    if(error) {
      response.json({email_get: "failed"});
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


app.post('/insert/reserve/', function(request,response) {
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
