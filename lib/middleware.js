(function() {
  var Exprestive, callsite, path;

  callsite = require('callsite');

  Exprestive = require('./exprestive');

  path = require('path');

  module.exports = function(options) {
    var baseDir, exprestive, stack;
    stack = callsite();
    baseDir = path.dirname(stack[1].getFileName());
    exprestive = new Exprestive(baseDir, options);
    return exprestive.getMiddleware();
  };

}).call(this);
