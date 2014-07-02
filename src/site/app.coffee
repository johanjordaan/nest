"use strict"

express = require 'express'
bodyParser = require('body-parser')

async = require 'async'

# Configure express
#
app = express()
app.use(bodyParser())
app.use('/bower',express.static('bower_components'))
app.use('/',express.static('static'))
app.use('/shared',express.static('shared'))

setup = (name, port, cb) ->
  app.set('name',name)
  app.set('port',3000)

  auth_module = require('./modules/auth/auth_module')

  async.parallel [
    (cb) ->
      auth_module.init name, app, '/auth', () ->
        cb(null,'')
  ],() ->
    console.log 'All modules loaded ...'
    cb(app)

module.exports = setup




