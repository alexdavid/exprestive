Feature: Finding controllers

  Background:
    Given a file "routes.coffee" with the content
      """
      module.exports = ({GET}) ->
        GET '/users', to: 'users#index'
      """


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
    Given a file "my_controllers/controller_file_name.coffee" with the content
      """
      class UsersController
        index: (req, res) ->
          res.end 'user list'
      module.exports = UsersController
      """
    And an exprestive app with the option "controllersDirPath" set to `"./my_controllers"`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario: an application with a javascript file in controllers not exporting a controller
    Given a file "controllers/my_controller_spec.coffee" with the content
      """
      # This file doesn't export a controller
      """
    And an exprestive app using defaults
    Then the app doesn't error


  Scenario: an application with a non-javascript file in controllers
    Given a file "controllers/readme.md" with the content
      """
      Readme about controllers
      =======================
      """
    And an exprestive app using defaults
    Then the app doesn't error


  Scenario: an application with controllers passed into options instead of a controllers directory
    Given an exprestive app with the option "controllers" set to `{ users: index: (req, res) -> res.end 'user list' }`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"
