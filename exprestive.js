require('coffee-script/register');
Exprestive = require('./lib/exprestive');
callsite = require('callsite');
path = require('path');

module.exports = function(options) {
  // Determine the __dirname of the file calling exprestive
  var stack = callsite();
  var baseDir = path.dirname(stack[1].getFileName());

  var exprestive = new Exprestive(baseDir, options);
  return exprestive.getMiddleware();
}
