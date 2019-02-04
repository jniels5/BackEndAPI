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

app.set('port', (process.env.PORT || 5000))

app.get('/', function(request, response)
{
  response.send('Hello World!')
})

app.get('/test', function(request, response)
{
  response.json({test: 'whatever2'})
})

app.listen(app.get('port'), function()
  {
    console.log("Node app is running at localhost:" + app.get('port'))
  })
