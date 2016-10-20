Feature: Middleware support

  Background:
    Given a file "testMiddleware.js" with the content
      """
      module.exports = function(req, res, next) { return res.end("bar") }
      """
    And a file "controllers/users_controller.js" with the content
      """
      module.exports = class UsersController {
        index(req, res) { res.end("foo"); }
      }
      """

  Scenario: simple middleware support
    Given a file "routes.js" with the content
      """
      var testMiddleware = require('./testMiddleware')
      module.exports = ({ GET }) => {
        GET('/users', { to: 'users#index' , use: testMiddleware});
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "bar"
