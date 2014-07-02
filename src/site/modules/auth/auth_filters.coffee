errors = require './auth_errors'

# This is my auth filter. It checks the current token and validates
# it. It further creates a new token for the next request. If the token 
# invalid it returns the default json action requireing the client to logon 
# again.
# If a user has been found it is added to the res object to be used later
#

db = {}
do_auth = (req,res,next,admin) ->
  console.log "Running auth... [admin=#{admin}] #{req.body.auth_email}"
  if !req.body.auth_token? or req.body.auth_token == ""
    console.log 'Here'
    res.json errors.NOT_AUTHED
    return

  if !req.body.auth_email? or req.body.auth_email == ""
    console.log 'Here 2'
    res.json errors.NOT_AUTHED
    return

  db.User.findOne
    email : req.body.auth_email
    token : req.body.auth_token 
  .exec (err,user) ->
    if(!err) and (user?)
      console.log 'Found ...'

      if admin and !user.admin
        console.log 'Admin right required'
        res.json errors.NOT_AUTHED
        return

      user.generate_token () ->
        user.save (err,saved) ->
          req.auth_user = saved
          next()
    else
      console.log 'Not Found ...'    
      res.json errors.NOT_AUTHED

no_auth = (req, res, next) ->
  next()

auth = (req, res, next) ->
  do_auth req,res,next,false

admin_auth = (req, res, next) ->
  do_auth req,res,next,true

if module?
  module.exports = (auth_db) ->
    db = auth_db
    return x =  
      auth : auth
      admin_auth : admin_auth
      no_auth : no_auth

