(function() {
  var Exprestive, callsite, path;

  Exprestive = require('./exprestive');

  callsite = require('callsite');

  path = require('path');

  module.exports = function(options) {
    var baseDir, exprestive, stack;
    stack = callsite();
    baseDir = path.dirname(stack[1].getFileName());
    exprestive = new Exprestive(baseDir, options);
    return exprestive.getMiddleware();
  };

}).call(this);
