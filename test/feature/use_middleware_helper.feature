Feature: BaseController useMiddleware helper


  Background:
    Given a file "routes.js" with the content
      """
      module.exports = ({ GET }) => {
        GET('/users', { to: 'users#index' });
        GET('/users/:id', { to: 'users#show' });
      }
      """
    And a file "middleware.js" with the content
      """
        exports.fooInjector = function(req, res, next) {
          if(!req.custom) req.custom = [];
          req.custom.push('foo');
          next();
        }

        exports.barInjector = function(req, res, next) {
          if(!req.custom) req.custom = [];
          req.custom.push('bar');
          next();
        }
      """


  Scenario Outline: basic usage
    Given a file "controllers/users_controller.js" with the content
      """
      BaseController = require('exprestive').BaseController;
      middleware = require('../middleware');

      module.exports = class UsersController extends BaseController {
        constructor() {
          super();
          this.useMiddleware(middleware.fooInjector);
        }

        index (req, res) { res.end(req.custom.join()); }
        show  (req, res) { res.end(req.custom.join()); }
      }
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | foo           |
      | GET     | /users/1 | foo           |


  Scenario Outline: with multiple middleware functions
    Given a file "controllers/users_controller.js" with the content
      """
      BaseController = require('exprestive').BaseController;
      middleware = require('../middleware');

      module.exports = class UsersController extends BaseController {
        constructor() {
          super();
          this.useMiddleware([middleware.fooInjector, middleware.barInjector]);
        }

        index (req, res) { res.end(req.custom.join()); }
        show (req, res) { res.end(req.custom.join()); }
      }
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | foo,bar       |
      | GET     | /users/1 | foo,bar       |


  Scenario Outline: with only option specified
    Given a file "controllers/users_controller.js" with the content
      """
      BaseController = require('exprestive').BaseController;
      middleware = require('../middleware');

      module.exports = class UsersController extends BaseController {
        constructor() {
          super();
          this.useMiddleware(middleware.fooInjector, { only: 'index' });
        }

        index (req, res) { res.end(typeof req.custom); }
        show  (req, res) { res.end(typeof req.custom); }
      }
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | object        |
      | GET     | /users/1 | undefined     |


  Scenario Outline: with except option specified
    Given a file "controllers/users_controller.js" with the content
      """
      BaseController = require('exprestive').BaseController;
      middleware = require('../middleware');

      module.exports = class UsersController extends BaseController {
        constructor() {
          super();
          this.useMiddleware(middleware.fooInjector, { except: 'show' });
        }

        index (req, res) { res.end(typeof req.custom); }
        show  (req, res) { res.end(typeof req.custom); }
      }
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | object        |
      | GET     | /users/1 | undefined     |
