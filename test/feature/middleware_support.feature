Feature: Middleware support


  Background:
    Given a file "routes.js" with the content
      """
      module.exports = ({ GET }) => {
        GET('/users', { to: 'users#index' });
      }
      """


  Scenario: simple middleware support
    Given a file "controllers/users_controller.js" with the content
      """
      function fooInjector(req, res, next) {
        req.custom = 'foo';
        next();
      }

      module.exports = class UsersController {
        constructor() {
          this.middleware = { index: fooInjector };
        }

        index(req, res) { res.end(req.custom); }
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "foo"


  Scenario: multiple middleware support
    Given a file "controllers/users_controller.js" with the content
      """
      function fooInjector(req, res, next) {
        req.custom1 = 'foo';
        next();
      }

      function barInjector(req, res, next) {
        req.custom2 = 'bar';
        next();
      }

      module.exports = class UsersController {
        constructor() {
          this.middleware = { index: [fooInjector, barInjector] };
        }

        index(req, res) { res.end(req.custom1 + ' ' + req.custom2) }
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "foo bar"


  Scenario: referencing routes in middleware
    Given a file "routes.js" with the content
      """
      module.exports = ({ GET }) => {
        GET('/', { to: 'home#index' });
        GET('/dashboard', { to: 'home#dashboard', as: 'dashboard' });
      }
      """
    And a file "controllers/home_controller.js" with the content
      """
      function redirectToDashboard(req, res, next) {
        res.writeHead(301, { Location: this.routes.dashboard() });
        res.end();
      }

      module.exports = class HomeController {
        constructor() {
          this.middleware = { index: redirectToDashboard };
        }

        index(req, res) {}
        dashboard(req, res) { res.end(); }
      }
      """
    And an exprestive app using defaults
    When making a GET request to "/"
    Then I am redirected to "/dashboard"
