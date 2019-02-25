var runfile = require('./runfile.js');
var bodyParser = require('body-parser')
var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()

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

//"per gender" counters
app.get('/metrics/total/male', function(request,response) {
  connection.query('SELECT COUNT(*) "Males" FROM Members WHERE Members.Gender = "Male"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/metrics/total/female', function(request,response) {
  connection.query('SELECT COUNT(*) "Females" FROM Members WHERE Members.Gender = "Female"', function (error, results, fields) {
    if(error) {
      response.json({Metrics_get: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/metrics/total/other', function(request,response) {
  connection.query('SELECT COUNT(*) "Nonbinary" FROM Members WHERE Members.Gender = "Nonbinary"', function (error, results, fields) {
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

app.get('/notifications/options/gets', function(request,response) {
  connection.query('SELECT Name, Description, CONVERT(VARCHAR(12), date, 107) AS [Mon, DD, YYYY] FROM Notifications', function (error, results, fields) {
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

  connection.query('SELECT * FROM Members WHERE FirstName = ' + entryRes.Search), function(request,response) {
    if(error) {
      response.json({table_names: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/stats/search/last', function(request,response) {

  connection.query('SELECT * FROM Members WHERE LastName = ' + entryRes.Search), function(request,response) {
    if(error) {
      response.json({table_names: "failed"});
    }
    else {
      response.json(results);
    }
  });
});

app.get('/stats/search/grad', function(request,response) {

  connection.query('SELECT * FROM Members WHERE Graduation = ' + entryRes.Search), function(request,response) {
    if(error) {
      response.json({table_names: "failed"});
    }
    else {
      response.json(results);
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

app.listen(app.get('port'), function()
  {
    console.log("Node app is running at localhost:" + app.get('port'))
  })
