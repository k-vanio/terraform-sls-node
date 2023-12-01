'use strict';

const mailer = require('nodemailer');

const transporter = mailer.createTransport({
  host: process.env.SMTP_SERVER,
  port: 465,
  secure: true,
  auth: {
    user: process.env.EMAIL_FROM,
    pass: process.env.EMAIL_FROM_PASSWORD
  }
})


module.exports.send = async (event) => {
  const emailsPromises = []  
  for (const record of event.Records) {
    const message = JSON.parse(record.body).Message
    emailsPromises.push(
      transporter.sendMail({
        from: `Lambda of vanio <${process.env.EMAIL_FROM}>`,
        to: process.env.EMAIL_TO,
        subject: 'Email Notification',
        text: message,
        html: `<b>${message}</b>`
      })
    )
  }


  const info = await Promise.all(emailsPromises)

  console.log('Message all messages sent');

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};
