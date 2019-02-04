var express = require('express')
var mysql = require('mysql')
var cors = require('cors')
var app = express()

app.set('port', (process.env.PORT || 5000))

app.get('/', function(request, response)
{
  response.send('Hello World!')
})

app.get('/test', function(request, response)
{
  response.send('whatever')
})

app.listen(app.get('port'), function()
  {
    console.log("Node app is running at localhost:" + app.get('port'))
  })
