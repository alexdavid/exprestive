Feature: Middleware support

  Background:
    Given a file "testMiddleware.js" with the content
      """
      module.exports = {
        test: (req, res) => res.end("test"),
        scoped: (req, res, next) => {
          req.scoped = "scoped"
          next()
        },
        indexOne: (req, res, next) => {
          if (req.index) req.index += "indexOne "
          else req.index = "indexOne "
          next()
        },
        indexTwo: (req, res, next) => {
          if (req.index) req.index += "indexTwo "
          else req.index = "indexTwo"
          next()
        }
      }
      """
    And a file "controllers/users_controller.js" with the content
      """
      const middleware = require('../testMiddleware');

      module.exports = class UsersController {
        constructor() {
          this.middleware = { index: middleware.indexTwo};
        }
        test(req, res)  { res.end("test middleware failed"); }
        index(req, res) { res.end(req.index); }
        foo(req, res)   { res.end(req.scoped + " foo"); }
        bar(req, res)   { res.end(req.scoped + " bar"); }
      }
      """

  Scenario: simple middleware support in routes file
    Given a file "routes.js" with the content
      """
      var middleware = require('./testMiddleware')
      module.exports = ({ GET }) => {
        GET('/users', { to: 'users#test' , use: middleware.test});
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "test"

  Scenario: middleware support in scoped routes
    Given a file "routes.js" with the content
      """
      var testMiddleware = require('./testMiddleware')
      module.exports = ({ scope, GET }) => {
        scope('/users', {use: testMiddleware.scoped}, () => {
          GET('/foo', { to: 'users#foo' });
          GET('/bar', { to: 'users#bar' });
        })
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users/foo"
    Then the response body should be "scoped foo"

  Scenario: middleware in the routes file runs before middleware in the controller
    Given a file "routes.js" with the content
      """
      var middleware = require('./testMiddleware')
      module.exports = ({ GET }) => {
        GET('/users', { to: 'users#index' , use: middleware.indexOne});
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "indexOne indexTwo"

  Scenario: middleware in the routes file runs before middleware in the controller with scoping
    Given a file "routes.js" with the content
      """
      var middleware = require('./testMiddleware')
      module.exports = ({ scope, GET }) => {
        scope('/users', {use: middleware.indexOne}, () => {
          GET('/foo', { to: 'users#index' });
        })
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users/foo"
    Then the response body should be "indexOne indexTwo"

  Scenario: middleware can be applied to resources
    Given a file "routes.js" with the content
      """
      var middleware = require('./testMiddleware')
      module.exports = ({ resources }) => {
        resources('users', {use: middleware.test, only: ['index'] })
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "test"

  Scenario: The resources and scopes can take an array of middleware and apply in order
    Given a file "routes.js" with the content
      """
      var m = require('./testMiddleware')
      module.exports = ({ scope, resources }) => {
        scope('outer', { use: [m.indexOne, m.indexTwo] }, () => {
          resources('users', {use: [m.indexTwo, m.indexOne], only: ['index'] })
        })
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/outer/users"
    Then the response body should be "indexOne indexTwo indexTwo indexOne indexTwo"
