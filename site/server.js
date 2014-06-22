var app, bodyParser, express, fs, server, _;

fs = require('fs');

_ = require('underscore');

express = require('express');

bodyParser = require('body-parser');

app = express();

app.use(bodyParser());

app.use(express["static"]('bower_components'));

server = app.listen(3000);

app.get('/', function(req, res) {
  return res.send('hello world');
});

if (typeof module !== "undefined" && module !== null) {
  module.exports.server = server;
}
