require('coffee-script/register');
Exprestive = require('./lib/exprestive');

module.exports = function(options) {
  var exprestive = new Exprestive(options);
  return exprestive.getMiddleware();
}
