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

// Used to get database information on team members
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
