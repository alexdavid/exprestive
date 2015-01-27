Feature: Dependency Injection into controllers

  As a developer using Exprestive to instantiate my controllers for me
  I want to be able to define dependencies to be provided to my controllers
  So that I can use my non-Exprestive application objects in my controllers without having to resort to global variables.

  Scenario: initializeWith object is passed to controller constructors
    Given the routing definition
      """
      GET '/users', to: 'users#index'
      """
    And a file "controllers/users_controller.coffee" with the content
      """
      class UsersController
        constructor: ({@users}) ->

        index: (req, res) ->
          res.end @users.join ', '

      module.exports = UsersController
      """
    And an exprestive app with the option "dependencies" set to `users: ['Alice', 'Bob', 'Carol']`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "Alice, Bob, Carol"
