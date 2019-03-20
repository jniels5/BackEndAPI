var runfile = require('./runfile.js');
var bodyParser = require('body-parser')
var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()
var nodemailer = require('nodemailer')

var whitelist = [
  'localhost:3000/',
  'team11-frontend.mjhmkfjvi5.us-east-2.elasticbeanstalk.com/'
]
//keep out the baddies
var corsOptions = {
  origin: '*', //use whitelist when localhost testing isn't needed
  methods: 'GET,POST,OPTIONS',
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

app.get('/metrics/totalCurr', function(request,response) {
  connection.query('SELECT COUNT(*) "Total" FROM TeamMembers, Teams WHERE TeamMembers.TeamID = Teams.TeamID AND Teams.Semester = "FA18"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/metrics/totalCurr/Grad', function(request,response) {
  connection.query('SELECT COUNT(*) "GradCurr" FROM TeamMembers, Teams, Members WHERE TeamMembers.TeamID = Teams.TeamID AND Members.MemberID = TeamMembers.MemberID AND Teams.Semester = "FA18" AND Members.GradSemester = "Fall" AND Members.GradYear = "2018"', function (error, results, fields) {
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
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/last', function(request,response) {
  connection.query('SELECT MemberID AS "ID", FirstName AS "First Name", LastName AS "Last Name", Gender, GradSemester as "Semester", GradYear as "Year", Email, AssetID AS "Asset ID", LabID AS "Lab" WHERE LastName = '  + request.query.Search, function (error, results, fields) {
        if(error) {
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/grad', function(request,response) {
  connection.query('SELECT MemberID AS "ID", FirstName AS "First Name", LastName AS "Last Name", Gender, GradSemester as "Semester", GradYear as "Year", Email, AssetID AS "Asset ID", LabID AS "Lab" WHERE GradYear = '  + request.query.Search, function (error, results, fields) {
        if(error) {
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

app.get('/stats/search/all', function(request,response) {
  connection.query('SELECT MemberID AS "ID", FirstName AS "First Name", LastName AS "Last Name", Gender, GradSemester as "Semester", GradYear as "Year", Email, AssetID AS "Asset ID", LabID AS "Lab" FROM Members', function (error, results, fields) {
        if(error) {
            response.json({select_status: "failed"});
        }
        else {
            response.json(results);
        }
  });
});

//get emails
app.get('/email/get', function(request,response) {
  connection.query('SELECT EMAIL FROM Members, Role WHERE Members.MemberID = Role.MemberID AND Role.Type = "Intern"', function (error, results, fields) {
    if(error) {
      response.json({navColor_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

// runfile is failing with SQL files, no error output. Table modifications done here
app.get('/jeremy/thisismyswamp', function(request, response) {
  connection.query(`INSERT INTO Members(MemberID, FirstName, LastName, Gender, GradSemester, GradYear, Email, WorkEmail, AssetID, LabID) VALUES
  (5, 'Michael', 'Pacyga', 'Male', 'Spring', 2020, NULL, 'michaelpacyga@discover.com', 20108939, 1),
  (6, 'Mike', 'Brenner', 'Male', NULL, NULL, NULL, 'michaelbrenner@discover.com', NULL, 1),
  (7, 'Brady', 'Goldsworthy', 'Male', 'Spring', 2019, NULL, 'bradygoldsworthy@discover.com', NULL, 1),
  (8, 'Justin', 'Dupre', 'Male', NULL , NULL, NULL, 'justindupre@discover.com', NULL, 1);
  (9, 'Bradley', 'Protano', 'Male', 'Fall', 2018, NULL, 'bradleyprotano@discover.com', NULL, 1),
  (10, 'Katie', 'Berendt', 'Female', 'Fall', 2019, NULL, 'katieberendt@discover.com', NULL, 1),
  (11, 'Jackie', 'Salim', 'Female', 'Spring', 2019, NULL,'jacquelinesalim@discover.com', NULL, 2),
  (12, 'Nahom', 'Gebremichael', 'Male', NULL, NULL, NULL, 'nahomgebremichael@discover.com', NULL, 2),
  (13, 'Thomas', 'Franczak', 'Male', NULL, NULL, NULL, 'thomasfranczak@discover.com', NULL, 2),
  (14, 'Kyle', 'Wilson', 'Male', NULL, NULL, NULL, 'kylewilson@discover.com', NULL, 2),
  (15, 'Ben', 'Lane', 'Male', NULL, NULL, NULL, 'benlane@discover.com', NULL, 3),
  (16, 'Kevin', 'Miyata', 'Male', NULL, NULL, NULL, 'kevimiyata@discover.com', NULL, 3),
  (17, 'James', 'Bonasera', 'Male', NULL, NULL, NULL, 'jamesbonasera@discover.com', NULL, 3),
  (18, 'Kris', 'Schrader', 'Female', NULL, NULL, NULL, 'krisschrader@discover.com', NULL, 3),
  (19, 'Samuel', 'Rutledge', 'Male', NULL, NULL, NULL, 'samuelrutledge@discover.com', NULL, 3),
  (20, 'Nicholas', 'Swanson', 'Male', NULL, NULL, NULL, 'nicholasswanson@discover.com', NULL, 3),
  (21, 'Alex', 'Boyle', 'Male', NULL, NULL, NULL, 'alexboyle@discover.com', NULL, 4),
  (22, 'Amy', 'Jakopin', 'Female', NULL, NULL, NULL, 'amyjakopin@discover.com', NULL, 4),
  (23, 'Andrew', 'Slade', 'Male', NULL, NULL, NULL, 'andrewslade@discover.com', NULL, 4),
  (24, 'Kristen', 'Arms', 'Female', NULL, NULL, NULL, 'kristenarms@discover.com', NULL, 4),
  (25, 'Shiva', 'Singh', 'Male', NULL, NULL, NULL, 'shivasingh@discover.com', NULL, 4),
  (26, 'Dylan', 'Drake', 'Male', NULL, NULL, NULL, 'dylandrake@discover.com', NULL, 5),
  (27, 'Jane', 'Swift', 'Female', NULL, NULL, NULL, 'janeswift@discover.com', NULL, 5),
  (28, 'Kwaku', 'Agyemang', 'Male', NULL, NULL, NULL, 'kwakuagyemang@discover.com', NULL, 5),
  (29, 'Nathanael', 'Isola', 'Male', NULL, NULL, NULL, 'nathanaelisola@discover.com', NULL, 5),
  (30, 'Quinton', 'Lee', 'Male', NULL, NULL, NULL, 'quintonlee@discover.com', NULL, 5),
  (31, 'Adam', 'Remes', 'Male', NULL, NULL, NULL, 'adamremes@discover.com', NULL, 6),
  (32, 'Elly', 'Jdaidany', 'Male', NULL, NULL, NULL, 'ellyjdaidany@discover.com', NULL, 6),
  (33, 'Jessica', 'Guenther', 'Female', NULL, NULL, NULL, 'jessicaguenther@discover.com', NULL, 6),
  (34, 'Spencer', 'Yoder', 'Male', NULL, NULL, NULL, 'spenceryoder@discover.com', NULL, 6),
  (35, 'Vishy', 'Singh', 'Male', NULL, NULL, NULL, 'vishysingh@discover.com', NULL, 6),
  (36, 'Nicholas', 'Glaviano', 'Male', NULL, NULL, NULL, 'nicholasglaviano@discover.com', NULL, 6),
  (37, 'Javier', 'Gomez', 'Male', NULL, NULL, NULL, 'javiergomez@discover.com', NULL, 7),
  (38, 'Cameron', 'Badenoch', 'Male', NULL, NULL, NULL, 'cameronbadenoch@discover.com', NULL, 7),
  (39, 'Krystal', 'McIntyre-Miller', 'Female', NULL, NULL, NULL, 'krystalmcintyremiller@discover.com', NULL, 7),
  (40, 'Nicholas', 'Rosso', 'Male', NULL, NULL, NULL, 'nicholasrosso@discover.com', NULL, 7),
  (41, 'Tyler', 'Havener', 'Male', NULL, NULL, NULL, 'tylerhavener@discover.com', NULL, 7),
  (42, 'Mary', 'Sue', 'Female', 'Fall', 2019, 'abc@xyz.com', 'something@discover.com', 12345678, 1),
  (43, 'Susan', 'Joe', 'Female', 'Spring', 2020, 'susanjoe@xyz.com', NULL, NULL, 1),
  (44, 'Lucy', 'Lola', 'Female', 'Spring', 2020, 'lucy123@xyz.com', NULL, NULL, 1);`, function (error, results, fields) {
    if(error) {
      console.log(error.sql)
    }
  });
});

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
