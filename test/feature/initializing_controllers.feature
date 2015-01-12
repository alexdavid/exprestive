Feature: Initializing controllers

  Scenario: initializeWith object is passed to controller constructors
    Given the routing definition
      """
      GET '/users', to: 'users#index'
      """
    And a file "controllers/users.coffee" with the contents
      """
      class UsersController
        constructor: ({@userList}) ->

        index: (req, res) ->
          res.end @userList.join ', '

      module.exports = UsersController
      """
    And an exprestive app with the option "initializeWith" set to `userList: ['Alice', 'Bob', 'Carol']`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "Alice, Bob, Carol"

