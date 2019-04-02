var runfile = require('./runfile.js');
var bodyParser = require('body-parser')
var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()
var nodemailer = require('nodemailer')
var fs = require('fs');
const json2csv = require('json2csv').parse;

var whitelist = [
  'localhost:3000/',
  'team11-frontend.mjhmkfjvi5.us-east-2.elasticbeanstalk.com/'
]
//keep out the baddies
var corsOptions = {
  origin: '*', //use whitelist when localhost testing isn't needed
  methods: 'GET,POST,OPTIONS,DELETE',
  "preflightContinue": true
}
//app.use(cors()); uncomment to enable cors for everything
app.use(cors(corsOptions)); //use cors with options enables
app.options('*', cors(corsOptions)); //enables preflight options
app.use(bodyParser.json()); //Parses POST Data

app.set('port', (process.env.PORT || 5000))

//creating connection object
var connection = mysql.createConnection({
  host     : process.env.RDS_HOSTNAME,
  user     : process.env.RDS_USERNAME,
  password : process.env.RDS_PASSWORD,
  port     : process.env.RDS_PORT,
  database : process.env.RDS_DB_NAME,
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

//nodemailer stuff
// create reusable transporter object using the default SMTP transport
var transporter = nodemailer.createTransport({
  host: "smtp.ethereal.email",
  port: 587,
  secure: false, // true for 465, false for other ports
  auth: {
    user: 'trycia96@ethereal.email', // generated ethereal user
    pass: 'H2qNsXxpkeUew42BFS' // generated ethereal password
  }
});

// setup email data with unicode symbols
var mailOptions = {
  from: '"Trycia Nikolaus" <trycia96@ethereal.email>', // sender address
  to: "colebraswell@discover.com, trycia96@ethereal.email", // list of receivers
  subject: "Hello this is a test", // Subject line
  text: "Hello world this is the text test", // plain text body
  html: "<b>Hello world this is the text test</b>" // html body, I beleive this is optional. Can choose between either text and html, or have both!
};

// hopefully sends the eMail?
app.get('/email', function(request,response) {
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
        response.json({email: "failed"});
    }
    else {
      respose.json({email: "sent"});
    }
  })
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
  connection.query('SELECT * FROM '  + request.params.table, function (error, results, fields) {
        if(error) {
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Describe table structure
app.get('/describe/:table', function(request,response) {
  connection.query('DESCRIBE '  + request.params.table, function (error, results, fields) {
        if(error) {
            response.json({describe_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Describe table structure
app.get('/show/tables', function(request,response) {
  connection.query('SHOW Tables', function (error, results, fields) {
        if(error) {
            response.json({describe_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Login Page Stuff
app.get('/login/check/', function(request,response) {
  connection.query('SELECT AcctID FROM Accounts', function (error, results, fields) {
    if(error) {
      response.json({login_check: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// Preferences Stuff
// Navbar Color
app.get('/navbar/color/get', function(request,response) {
  connection.query('SELECT NavColor FROM Preferences', function (error, results, fields) {
    if(error) {
      response.json({navColor_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// updating Navigation Bar Color
app.post('/navbar/color/post', function(request,response) {
  connection.query('UPDATE Preferences SET NavColor = "' + request.body.Color + '" WHERE AcctID = 1', function (error, results, fields) {
    if(error) {
      response.json({navColor_post: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// Metrics
app.get('/metrics/options/get', function(request,response) {
  connection.query('SELECT * FROM Metrics', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// Count em up
app.get('/metrics/total/interns', function(request,response) {
  connection.query('SELECT COUNT(*) "Count" FROM Members, Role WHERE Members.MemberID = Role.MemberID AND Role.Type = "Intern" AND Role.Status != "Not Active"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

//"total and grad year" counters; hardcoded to previous 2 semesters
app.get('/metrics/totalCurr', function(request,response) {
  connection.query('SELECT COUNT(*) "Total" FROM TeamMembers, Teams WHERE TeamMembers.TeamID = Teams.TeamID AND Teams.Semester = "SP19"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/metrics/totalCurr/Grad', function(request,response) {
  connection.query('SELECT COUNT(*) "GradCurr" FROM TeamMembers, Teams, Members WHERE TeamMembers.TeamID = Teams.TeamID AND Members.MemberID = TeamMembers.MemberID AND Teams.Semester = "SP19" AND Members.GradSemester = "Spring" AND Members.GradYear = "2019"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/metrics/totalCurr1', function(request,response) {
  connection.query('SELECT COUNT(*) "Total1" FROM TeamMembers, Teams WHERE TeamMembers.TeamID = Teams.TeamID AND Teams.Semester = "FA18"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/metrics/totalCurr1/Grad', function(request,response) {
  connection.query('SELECT COUNT(*) "GradCurr1" FROM TeamMembers, Teams, Members WHERE TeamMembers.TeamID = Teams.TeamID AND Members.MemberID = TeamMembers.MemberID AND Teams.Semester = "FA18" AND Members.GradSemester = "Fall" AND Members.GradYear = "2018"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});


//Count Open House
app.get('/metrics/total/OH', function(request,response) {
  connection.query('SELECT COUNT(*) "OpenHouse" FROM Members, Role WHERE Members.MemberID = Role.MemberID AND Role.Type = "Open House"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// updating Metrics
// needs to be looked at, how to change multiple metrics with just one statement if possible
app.post('/metrics/options/post', function(request,response) {
  connection.query('UPDATE Metrics m, Preferences p SET IsActive = "' + request.params.WeatherMet + '" WHERE m.PrefID = p.PrefID AND p.AcctID = 1', function (error, results, fields) {
    if(error) {
      response.json({Metrics_post: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// Notifications
app.get('/notifications/options/get', function(request,response) {
  connection.query('SELECT * FROM Notifications', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// updating Notification Preferences
// same thing as "Updating Metrics"; needs to be looked at some more
app.post('/notifications/options/post', function(request,response) {
  connection.query('UPDATE Metrics m, Preferences p SET IsActive = "' + request.params.WeatherMet + '" WHERE m.PrefID = p.PrefID AND p.AcctID = 1', function (error, results, fields) {
    if(error) {
      response.json({Metrics_post: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/notifications/options/NotRead', function(request,response) {
  connection.query('SELECT COUNT(*) FROM Notifications WHERE Notifications.IsRead = 0', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// STATS TABLE QUERIES
app.get('/stats/search/first', function(request,response) {
  connection.query('SELECT MemberID AS "ID", FirstName AS "First Name", LastName AS "Last Name", Gender, GradSemester as "Semester", GradYear as "Year", Email, AssetID AS "Asset ID", LabID AS "Lab" FROM Members WHERE FirstName = '  + request.query.Search, function (error, results, fields) {
        if(error) {
            response.json({first_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/last', function(request,response) {
  connection.query('SELECT MemberID AS "ID", FirstName AS "First Name", LastName AS "Last Name", Gender, GradSemester as "Semester", GradYear as "Year", Email, AssetID AS "Asset ID", LabID AS "Lab" FROM Members WHERE LastName = '  + request.query.Search, function (error, results, fields) {
        if(error) {
            response.json({last_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/grad', function(request,response) {
  connection.query('SELECT MemberID AS "ID", FirstName AS "First Name", LastName AS "Last Name", Gender, GradSemester as "Semester", GradYear as "Year", Email, AssetID AS "Asset ID", LabID AS "Lab" FROM Members WHERE GradYear = '  + request.query.Search, function (error, results, fields) {
        if(error) {
            response.json({grad_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/all', function(request,response) {
  connection.query('SELECT MemberID AS "ID", FirstName AS "First Name", LastName AS "Last Name", Gender, GradSemester as "Semester", GradYear as "Year", Email, AssetID AS "Asset ID", LabID AS "Lab" FROM Members', function (error, results, fields) {
        if(error) {
            response.json({all_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Teams Info for Stats page
app.get('/stats/teams/semester', function(request,response) {
  connection.query('SELECT TeamdID, TeamName, TeamNumber, Semester, LabID FROM Teams WHERE Semester = '  + request.query.Search, function (error, results, fields) {
        if(error) {
            response.json({teams_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

//get emails
app.get('/email/get', function(request,response) {
  connection.query('SELECT Members.Email FROM Members, Role WHERE Members.MemberID = Role.MemberID AND Role.Type = "Intern" AND Members.Email is not NULL', function (error, results, fields) {
    if(error) {
      response.json({email_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

//Local test
app.get("/csv/table.csv", function (req, res) {
  var resFields = [];
  var resData = [];

  connection.query('SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_NAME` = "Members"', function (error, rows, results, fields) {
        if(error) {
            res.json({csv1_select: "failed"});
        }
        else {
            for (var i = 0; i < rows.length; i++) {
              resFields.push(rows[i]);
            }
            console.log(resFields);
        }
  });

  connection.query('SELECT MemberID, FirstName, LastName, Gender, GradSemester, GradYear, Email, AssetID, LabID FROM Members', function (error, rows, results, fields) {
        if(error) {
            res.json({csv2_select: "failed"});
        }
        else {
          for (var i = 0; i < rows.length; i++) {
            resData.push(rows[i]);
          }
          console.log(resData);
          res.json({we_made_it: "this_far"});
        }
  });

  json2csv({ data: resData, fields: resFields }, function(err, csv) {
    res.setHeader('Content-disposition', 'attachment; filename=table.csv');
    res.set('Content-Type', 'text/csv');
    res.status(200).send(csv);
  });
});

//--------------------------------------------------------|
//  Atlas - Backend API Calls for code_orange website     |
//--------------------------------------------------------|

// Checkin page for guests
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
                    'Projects.RDS FROM Teams JOIN Projects ON Projects.TeamID = Teams.TeamID ' +
                    ' AND Teams.Semester = "' + request.params.semester + '"', function (error, results, fields) {
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
  connection.query('SELECT Members.FirstName, Members.LastName FROM Members ' +
                    'JOIN TeamMembers ON TeamMembers.MemberID = Members.MemberID ' +
                    'JOIN Teams ON Teams.TeamID = TeamMembers.TeamID JOIN Projects ON Projects.TeamID = Teams.TeamID ' +
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

  connection.query('SELECT ReserveID, Start, End, RoomID, TeamID, Description, Email, Date FROM Reservations WHERE Date = "' + request.params.day + 'T00:00:00.000Z"', function (error, results, fields) {
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

  connection.query('DELETE FROM Reservations WHERE ReserveID = ' + request.params.rID, function (error, results, fields) {
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

app.post('/insert/reserve/', function(request,response) {
  //used in connection.query
  var entry = {
    Description: request.body.Description,
    Email: request.body.Email,
    Start: request.body.Start,
    End: request.body.End,
    Date: request.body.Date,
    RoomID: request.body.RoomID,
    TeamID: request.body.TeamID
  };

  connection.query('INSERT INTO Reservations set ?', entry, function (error, results, fields) {
    if(error) {
        response.json({
          checkin_status: "failed",
          checkin_error: error,
          RoomID: request.body.RoomID,
          TeamID: request.body.TeamID,
          Email: request.body.Email,
          Start:  request.body.Start,
          End: request.body.End,
          Date: request.body.Date,
          Description: request.body.Description
        });
    }
    else {
        response.json({
          checkin_status: "success",
          RoomID: request.body.RoomID,
          TeamID: request.body.TeamID,
          Email: request.body.Email,
          Start:  request.body.Start,
          End: request.body.End,
          Date: request.body.Date,
          Description: request.body.Description
        });
      }
    });
  });

//
// RUNFILE Section . . .
//

/*runs a specified sql file (**Needs error handling**)
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
*/

app.listen(app.get('port'), function() {
    console.log("Node app is running at localhost:" + app.get('port'))
  });
