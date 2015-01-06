Feature: Finding routes

  Scenario: an application with a custom routes file
    Given a file "custom_routes.coffee" with the contents
      """
      module.exports = ({GET}) ->
        GET '/users', to: 'users#index'
      """
    And a file "controllers/users_controller.coffee" with the contents
      """
      class UsersController
        index: (req, res) ->
          res.end "user list"
      module.exports = UsersController
      """
    And an exprestive app with the option "routesFilePath" set to `"./custom_routes.coffee"`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario: an application with routes passed into options instead of a routes file
    Given a file "controllers/users_controller.coffee" with the contents
      """
      class UsersController
        index: (req, res) ->
          res.end "user list"
      module.exports = UsersController
      """
    And an exprestive app with the option "routes" set to `({ GET }) -> GET '/users', to: 'users#index'`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario Outline: routes can be referred to with any case
    Given a file "routes.coffee" with the contents
      """
      module.exports = ({GET}) ->
        GET '/camel',  to: 'changeCase#index'
        GET '/snake',  to: 'change_case#index'
        GET '/pascal', to: 'ChangeCase#index'
        GET '/param',  to: 'change-case#index'
      """
    And a file "controllers/change_case.coffee" with the contents
      """
      class ChangeCaseController
        index: (req, res) ->
          res.end()
      module.exports = ChangeCaseController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response code should be 200

    Examples:
      | REQUEST | URL     |
      | GET     | /camel  |
      | GET     | /snake  |
      | GET     | /pascal |
      | GET     | /param  |


  Scenario Outline: restful routing
    Given a file "routes.coffee" with the contents
      """
      module.exports = ({ resources }) ->
        resources 'users'
      """
    And a file "controllers/users.coffee" with the contents
      """
      class UsersController
        index:   (req, res) -> res.end 'users index'
        new:     (req, res) -> res.end 'users new'
        create:  (req, res) -> res.end 'users create'
        show:    (req, res) -> res.end 'users show'
        edit:    (req, res) -> res.end 'users edit'
        update:  (req, res) -> res.end 'users update'
        destroy: (req, res) -> res.end 'users destroy'
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL           | RESPONSE BODY |
      | GET     | /users        | users index   |
      | GET     | /users/new    | users new     |
      | POST    | /users        | users create  |
      | GET     | /users/1      | users show    |
      | GET     | /users/1/edit | users edit    |
      | PUT     | /users/1      | users update  |
      | DELETE  | /users/1      | users destroy |
