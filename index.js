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
var Reserve = require('./routes/Reserve.js');
var Stats = require('./routes/Stats.js');

// Specify Paths
app.use('/login/', Login);
app.use('/map/', MAP);
app.use('/metrics/', Metrics);
app.use('/pcf/', PCFRoutes);
app.use('/reserve/', Reserve);
app.use('/stats/', Stats);

server = require('http').createServer(app);

io = require('socket.io')(server);

io.on('connection', function(socket)
{
  console.log("a user connected");
});



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
    response.json({Welcome: 'Please use the SwaggerDocs to learn more about specific API calls'});
});

// Used to get All info from each table
app.get('/select/table/:table', function(request,response) {
  if(request.params.table.toLowerCase() == "applications")
  {
    response.sendStatus(403);
  }
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
