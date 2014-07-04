"use strict"

_ = require 'underscore'
http = require 'http' 

app_setup = require './app'

port = "<%= site_node_port %>"
if(_.isNaN(Number(port)))
  port = 3000 
name = "<%= name %>"
if(name.indexOf("<%=")==0)
  name = 'nest'

app_setup name, port, (app) ->
  http.createServer(app).listen app.get('port'), () ->
    console.log("Express(#{app.get('name')}) server listening on port [#{app.get('port')}]")