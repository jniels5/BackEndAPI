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

////////////////////////////////////////////////////
//                                                //
//    Navbar API Calls                            //
//                                                //
////////////////////////////////////////////////////

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

////////////////////////////////////////////////////
//                                                //
//    Metrics API Calls                           //
//                                                //
////////////////////////////////////////////////////

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

////////////////////////////////////////////////////
//                                                //
//    Notifications API Calls                     //
//                                                //
////////////////////////////////////////////////////

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

////////////////////////////////////////////////////
//                                                //
//    Statistics API Calls                        //
//                                                //
////////////////////////////////////////////////////

// Stats Search Calls . . .
app.get('/stats/search/first', function(request,response) {
  connection.query('SELECT m.MemberID, m.FirstName, m.LastName, t.TeamNumber, m.GradSemester, ' +
                   'm.GradYear, m.Email, m.AssetID, r.Type, r.Status, r.Description, r.Date, tm.TeamID, t.TeamName, t.Semester, m.Gender FROM Members AS m, Role AS r, TeamMembers AS tm, Teams AS t ' +
                   'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = t.TeamID AND t.Semester = ' + request.query.Semester + ' AND m.FirstName = ' + request.query.Search + ' ORDER BY m.MemberID', function (error, results, fields) {
        if(error) {
            response.json({first_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/last', function(request,response) {
  connection.query('SELECT m.MemberID, m.FirstName, m.LastName, t.TeamNumber, m.GradSemester, ' +
                   'm.GradYear, m.Email, m.AssetID, r.Type, r.Status, r.Description, r.Date, tm.TeamID, t.TeamName, t.Semester, m.Gender FROM Members AS m, Role AS r, TeamMembers AS tm, Teams AS t ' +
                   'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = t.TeamID AND t.Semester = ' + request.query.Semester + ' AND m.LastName = ' + request.query.Search + ' ORDER BY m.MemberID', function (error, results, fields) {
        if(error) {
            response.json({last_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/grad', function(request,response) {
  connection.query('SELECT m.MemberID, m.FirstName, m.LastName, t.TeamNumber, m.GradSemester, ' +
                   'm.GradYear, m.Email, m.AssetID, r.Type, r.Status, r.Description, r.Date, tm.TeamID, t.TeamName, t.Semester, m.Gender FROM Members AS m, Role AS r, TeamMembers AS tm, Teams AS t ' +
                   'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = t.TeamID AND t.Semester = ' + request.query.Semester + ' AND m.GradYear = ' + request.query.Search + ' ORDER BY m.MemberID', function (error, results, fields) {
        if(error) {
            response.json({grad_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/all', function(request,response) {
  connection.query('SELECT m.MemberID, m.FirstName, m.LastName, t.TeamNumber, m.GradSemester, ' +
                   'm.GradYear, m.Email, m.AssetID, r.Type, r.Status, r.Description, r.Date, tm.TeamID, t.TeamName, t.Semester, m.Gender FROM Members AS m, Role AS r, TeamMembers AS tm, Teams AS t ' +
                   'WHERE r.MemberID = m.MemberID AND m.MemberID = tm.MemberID AND tm.TeamID = t.TeamID AND t.Semester = ' + request.query.Semester + ' ORDER BY m.MemberID', function (error, results, fields) {
        if(error) {
            response.json({all_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Stats Filter Calls . . .
app.get('/stats/filter/status', function(request,response) {
  var OpenHouse = '';
  var Applicant = '';
  var Intern = '';
  var FullTime = '';

  if (request.query.OpenHouse == "true")
  {
    OpenHouse = '"Open House", '
  }
  else if (request.query.Applicants == "true")
  {
    Applicant = '"Applicant", '
  }
  else if (request.query.Interns == "true")
  {
    Intern = '"Intern", '
  }
  else if (request.query.FullTimeHire == "true")
  {
    FullTime = '"Former Intern", '
  }

  connection.query('SELECT m.MemberID, m.FirstName, m.LastName, m.Gender, m.GradSemester, ' +
                   'm.GradYear, m.Email, m.AssetID, r.Type, r.Status, r.Description, r.Date FROM Members AS m, Role AS r ' +
                   'WHERE r.Type IN (' + OpenHouse + Applicant + Intern + FullTime +
                   '"N/a" ) AND r.MemberID = m.MemberID', function (error, results, fields) {
        if(error) {
            response.json({Status_Select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/filter/teams', function(request,response) {

  connection.query('SELECT Teams.TeamName, Teams.TeamNumber, Projects.Name, Projects.Type, Projects.Description FROM Teams, Projects ' +
                   'WHERE ' + request.query.Teams + ' Projects.TeamID = Teams.TeamID AND ' +
                   request.query.Semester + ';', function (error, results, fields) {
        if(error) {
            response.json({Status_Select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Stats Equipment stuff
app.get('/stats/filter/equipment', function(request,response) {
  var Laptops = '';
  var Televisons = '';
  var MobileDevices = '';

  if (request.query.Laptops == "true")
  {
    Laptops = '"Laptop", '
  }
  else if (request.query.Televisions == "true")
  {
    Televisons = '"Television", '
  }
  else if (request.query.MobileDevices == "true")
  {
    MobileDevices = '"Mobile Device", '
  }

  connection.query('SELECT a.AssetID, a.Description, a.Type, m.FirstName, m.LastName ' +
                   'FROM Members AS m, Assets AS a ' +
                   'WHERE a.Type IN (' + Laptops + Televisons + MobileDevices +
                   '"N/a" ) AND a.AssetID = m.AssetID AND a.AssetID != 10000000 AND a.IsImaged >= 0 GROUP BY a.AssetID', function (error, results, fields) {
        if(error) {
            response.json({Status_Select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Stats Page Info Calls . . .
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

app.get('/stats/teams/names', function(request,response) {
  connection.query('SELECT TeamName, TeamNumber FROM Teams WHERE '  + request.query.Semester, function (error, results, fields) {
        if(error) {
            response.json({teams_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/lab/semesters', function(request,response) {
  connection.query('SELECT Semester FROM Teams GROUP BY Semester', function (error, results, fields) {
        if(error) {
            response.json({semester_select: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

// Stats Update Record Calls . . .
app.post('/stats/modal/post', function(request,response) {
  // used in connection.query
  var entry = {
    FirstName: request.body.FirstName,
    LastName: request.body.LastName,
    Gender: request.body.Gender,
    GradSemester: request.body.GradSemester,
    GradYear: request.body.GradYear,
    Email: request.body.Email,
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

////////////////////////////////////////////////////
//                                                //
//    Email API Calls                             //
//                                                //
////////////////////////////////////////////////////

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

app.get('/email/Intern/PO', function(request,response) {
  connection.query('SELECT ' + request.query.ContactType + ' FROM Members ' +
                   'JOIN TeamMembers ON TeamMembers.MemberID = Members.MemberID ' +
                   'JOIN Teams ON Teams.TeamID = TeamMembers.TeamID '+
                   'JOIN Role ON Role.MemberID = Members.MemberID ' +
                   'WHERE ' + request.query.Teams + request.query.Semester + ' AND ' +
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

////////////////////////////////////////////////////
//                                                //
//    Student Portal API Calls                    //
//                                                //
////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////
//                                                       //
//  Atlas - Backend API Calls                            //
//                                                       //
///////////////////////////////////////////////////////////

//********************************************
//  MAP API                                  *
//********************************************

app.post('/map/insert/delegations/', function(request,response) {
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
          Delegator: request.body.Delegator,
          State: request.body.State,
          Email: request.body.Email,
          Delegatee:  request.body.Delegatee,
          StartDate: request.body.StartDate,
          EndDate: request.body.EndDate,
          Description: request.body.Description,
          Status: request.body.Status
        });
    }
    else {
        response.json({
          delegation_status: "success",
          Delegator: request.body.Delegator,
          State: request.body.State,
          Email: request.body.Email,
          Delegatee:  request.body.Delegatee,
          StartDate: request.body.StartDate,
          EndDate: request.body.EndDate,
          Description: request.body.Description,
          Status: request.body.Status
        });
      }
    });
  });

  app.post('/map/insert/approvals/', function(request,response) {
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
            FullName: request.body.FullName,
            CloseDate: request.body.CloseDate,
            Email: request.body.Email,
            Service:  request.body.Service,
            RequestedBy: request.body.RequestedBy,
            RequestedDate: request.body.RequestedDate,
            Description: request.body.Description,
            Status: request.body.Status
          });
      }
      else {
          response.json({
            approval_status: "success",
            FullName: request.body.FullName,
            CloseDate: request.body.CloseDate,
            Email: request.body.Email,
            Service:  request.body.Service,
            RequestedBy: request.body.RequestedBy,
            RequestedDate: request.body.RequestedDate,
            Description: request.body.Description,
            Status: request.body.Status
          });
        }
      });
    });

//********************************************
//  code_orange Website API                  *
//********************************************

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

app.listen(app.get('port'), function() {
    console.log("Node app is running at localhost:" + app.get('port'))
  });
