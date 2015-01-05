Feature: Finding controllers

  Scenario: an application with defaults
    Given a file "routes.coffee" with the contents
      """
      module.exports = ({GET}) ->
        GET '/users', to: 'users#index'
      """
    And a file "controllers/users_controller.coffee" with the contents
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


  Scenario: an application with a custom controllers directory
    Given a file "routes.coffee" with the contents
      """
      module.exports = ({GET}) ->
        GET '/users', to: 'users#index'
      """
    And a file "my_controllers/controller_file_name.coffee" with the contents
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


  Scenario: an application with controllers passed into options instead of a controllers directory
    Given a file "routes.coffee" with the contents
      """
      module.exports = ({GET}) ->
        GET '/users', to: 'users#index'
      """
    And an exprestive app with the option "controllers" set to `{ users: index: (req, res) -> res.end 'user list' }`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"
