var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var cors = require('cors');

var connection = require("../auth/Connect");

var whitelist = [
  'http://localhost:3000/',
  'http://team11-frontend.mjhmkfjvi5.us-east-2.elasticbeanstalk.com/'
]

//keep out the baddies
var corsOptions = {
  origin: '*',
  //origin: whitelist,
  methods: 'GET,HEAD,POST,OPTIONS,DELETE',
  "preflightContinue": true
}

router.use(cors(corsOptions)); 

router.get('/attempts/get', function(request, response){

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

router.post('/attempts/post', function(request, response){
  
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

router.post('/attempts/insert', function(request, response){

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


router.post('/attempts/update', function(request, response){

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

module.exports = router