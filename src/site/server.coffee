fs = require('fs')
_ = require('underscore')

express = require('express')
bodyParser = require('body-parser')

app = express()

app.use bodyParser()
app.use(express.static('bower_components'))

server = app.listen(3000)

app.get '/', (req, res) ->
  res.send 'hello world'

if module?
  module.exports.server = server