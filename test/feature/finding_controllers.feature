Feature: Finding controllers

  Background:
    Given a file "routes.coffee" with the content
      """
      module.exports = ({GET}) ->
        GET '/users', to: 'users#index'
      """

  Scenario: missing controller
    Given an exprestive app using defaults
    When making a GET request to "/users"
    Then the response code should be 500
    And the response body should be "Missing 'users' controller"


  Scenario: missing action
    Given a file "controllers/users_controller.coffee" with the content
      """
      class UsersController
      module.exports = UsersController
      """
    Given an exprestive app using defaults
    When making a GET request to "/users"
    Then the response code should be 500
    And the response body should be "Missing 'index' action in 'users' controller"


  Scenario: default configuration
    Given a file "controllers/users_controller.coffee" with the content
      """
      class UsersController
        index: (req, res) ->
          res.end 'user list'
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario: custom controllers directory
    Given a file "my_controllers/users_controller.coffee" with the content
      """
      class UsersController
        index: (req, res) ->
          res.end 'user list'
      module.exports = UsersController
      """
    And an exprestive app with the option "controllersPattern" set to `"my_controllers/*_controller.coffee"`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario: an application with a non-javascript file in controllers
    Given a file "controllers/readme.md" with the content
      """
      Readme about controllers
      """
    And an exprestive app using defaults
    Then the app doesn't error


  Scenario: an application with a javascript sourcemap in controllers
    Given a file "controllers/user_controller.js.map" with the content
      """
      # sourcemap
      """
    And an exprestive app using defaults
    Then the app doesn't error


  Scenario: an application with a javascript file not ending in _controller
    Given a file "controllers/users.coffee" with the content
      """
      throw 'not a controller'
      """
    And an exprestive app using defaults
    Then the app doesn't error
