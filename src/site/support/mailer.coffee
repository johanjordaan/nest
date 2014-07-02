_ = require 'underscore'
nodemailer = require 'nodemailer'

smtpTransport = nodemailer.createTransport 'sendmail',

mailer = {}

mailer.send_mail = (to,template,data,cb) ->
  mailOptions = 
    from    : "h2ash <admin@h2ash.com>"
    to      : "djjordaan@gmail.com"
    subject : _.template(template.subject,data)
    text    : _.template(template.text,data)
    html    : _.template(template.html,data)

  smtpTransport.sendMail mailOptions, (err,res) ->
      cb err
      smtpTransport.close()   

module.exports = mailer
  
