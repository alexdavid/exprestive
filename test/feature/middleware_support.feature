Feature: Middleware support


  Background:
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ GET }) ->
        GET '/users', to: 'users#index'
      """


  Scenario: simple middleware support
    Given a file "controllers/users_controller.coffee" with the content
      """
      middle = (req, res, next) ->
        req.custom = 'foo'
        next()

      class UsersController
        middleware:
          index: middle

        index: (req, res) -> res.end req.custom
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "foo"


  Scenario: multiple middleware support
    Given a file "controllers/users_controller.coffee" with the content
      """
      middle1 = (req, res, next) ->
        req.custom1 = 'foo'
        next()

      middle2 = (req, res, next) ->
        req.custom2 = 'bar'
        next()

      class UsersController
        middleware:
          index: [middle1, middle2]

        index: (req, res) -> res.end "#{req.custom1} #{req.custom2}"
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response body should be "foo bar"


  Scenario: referencing routes in middleware
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ GET }) ->
        GET '/', to: 'home#index'
        GET '/dashboard', to: 'home#dashboard', as: 'dashboard'
      """
    And a file "controllers/home_controller.coffee" with the content
      """
      redirectToDashboard = (req, res, next) ->
        res.writeHead 301, Location: @routes.dashboard()
        res.end()

      class HomeController
        middleware:
          index: redirectToDashboard

        index: (req, res) ->
          res.end()

        dashboard: (req, res) ->
          res.end()

      module.exports = HomeController
      """
    And an exprestive app using defaults
    When making a GET request to "/"
    Then I am redirected to "/dashboard"
