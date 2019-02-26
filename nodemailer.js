"use strict";
const nodemailer = require("nodemailer");

// async..await is not allowed in global scope, must use a wrapper
async function main(){

  // Generate test SMTP service account from ethereal.email
  // Only needed if you don't have a real mail account for testing
  var account = await nodemailer.createTestAccount();

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
    to: "colebraswell@discover.com, @example.com", // list of receivers
    subject: "Hello this is a test", // Subject line
    text: "Hello world this is the text test", // plain text body
    html: "<b>Hello world this is the text test</b>" // html body
  };

  // send mail with defined transport object
  var info = await transporter.sendMail(mailOptions)

  console.log("Message sent: %s", info.messageId);
  // Preview only available when sending through an Ethereal account
  console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));

  // Message sent: <b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>
  // Preview URL: https://ethereal.email/message/WaQKMgKddxQDoou...
}

main().catch(console.error);
