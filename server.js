var express = require('express');
var app = express();
var http = require('http');
var join = require('path').join;
var bodyParser = require('body-parser');

module.exports = function(PORT, log) {
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({
    extended: true
  }));
  app.use("/", express.static(__dirname + "/public"));
  app.get("*", function(req, res, next) {
    var indexPage;
    indexPage = __dirname + "/public/index.html";
    return (res.status(200)).sendFile(indexPage);
  });
  var server = http.createServer(app);
  return server.listen(PORT, function() {
    return log("Running at localhost:" + PORT);
  });
};