var runfile = require('./runfile.js');
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
//app.use(bodyParser.json()); //Parses POST Data

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
  connection.query('SELECT * FROM ' + request.params.table, function (error, results, fields) {
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
  connection.query('UPDATE Preferences SET NavColor = "' + request.params.NavColor + '" WHERE AcctID = 1', function (error, results, fields) {
    if(error) {
      response.json({navColor_post: "failed"});
    }
    else {
      response.json(results);
    }
  });
});


// STATS TABLE QUERIES
app.get('/stats/search/', function(request,response) {
  //used in connection.query
  var entryRes = {
    Filter: request.body.Filter,
    Search: request.body.Search,
    Location: request.body.Location
  };

  if(entryRes.Location == "All")
  {
    if(entryRes.Filter == "FirstName")
    {
      connection.query('SELECT * FROM Members WHERE FirstName = ' + entryRes.Search)
        if(error) {
          response.json({table_names: "failed"});
        }
        else {
          response.json(results);
        }
    }
    else if(entryRes.Filter == "LastName")
    {
      connection.query('SELECT * FROM Members WHERE LastName = ' + entryRes.Search)
        if(error) {
          response.json({table_names: "failed"});
        }
        else {
          response.json(results);
        }
    }
    else if(entryRes.Filter == "GradYear")
    {
      connection.query('SELECT * FROM Members WHERE GradYear = ' + entryRes.Search)
        if(error) {
          response.json({table_names: "failed"});
        }
        else {
          response.json(results);
        }
    }
  }
  else // IF location is specified
  {
    if(entryRes.Filter == "FirstName")
    {
      connection.query('SELECT m.FirstName, m.LastName, m.Gender, m.GradYear, m.Email FROM Members m, Labs l WHERE m.FirstName = ' + entryRes.Search + ' AND m.LabID = l.LabID and l.School = ' + entryRes.Location)
        if(error) {
          response.json({table_names: "failed"});
        }
        else {
          response.json(results);
        }
    }
    else if(entryRes.Filter == "LastName")
    {
      connection.query('SELECT m.FirstName, m.LastName, m.Gender, m.GradYear, m.Email FROM Members m, Labs l WHERE m.LastName = ' + entryRes.Search + ' AND m.LabID = l.LabID and l.School = ' + entryRes.Location)
        if(error) {
          response.json({table_names: "failed"});
        }
        else {
          response.json(results);
        }
    }
    else if(entryRes.Filter == "GradYear")
    {
      connection.query('SELECT m.FirstName, m.LastName, m.Gender, m.GradYear, m.Email FROM Members m, Labs l WHERE m.GradYear = ' + entryRes.Search + ' AND m.LabID = l.LabID and l.School = ' + entryRes.Location)
        if(error) {
          response.json({table_names: "failed"});
        }
        else {
          response.json(results);
        }
    }
  }
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
