Feature: Finding routes

  Scenario: an application with a custom routes file
    Given a routes file "my_routes.coffee" with the routes
          | METHOD | ROUTE  | TO          |
          | GET    | /users | users#index |
    And a "Users" controller in "controllers/users_controller.coffee" with the actions
          | ACTION | RESPONSE  |
          | index  | user list |
    And an exprestive app with the option "routesFilePath" set to `"./my_routes.coffee"`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario: an application with routes passed into options instead of a routes file
    Given a "Users" controller in "controllers/users_controller.coffee" with the actions
          | ACTION | RESPONSE  |
          | index  | user list |
    And an exprestive app with the option "routes" set to `({ GET }) -> GET '/users', to: 'users#index'`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario Outline: routes can be referred to with any case
    Given a routes file "routes.coffee" with the routes
          | METHOD | ROUTE   | TO                |
          | GET    | /camel  | changeCase#index  |
          | GET    | /snake  | change_case#index |
          | GET    | /pascal | ChangeCase#index  |
          | GET    | /param  | change-case#index |
    And a "ChangeCase" controller in "controllers/change_case.coffee" with the actions
          | ACTION | RESPONSE  |
          | index  | works     |
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response code should be <RESPONSE CODE>

    Examples:
      | REQUEST | URL     | RESPONSE CODE |
      | GET     | /camel  | 200           |
      | GET     | /snake  | 200           |
      | GET     | /pascal | 200           |
      | GET     | /param  | 200           |


  Scenario Outline: resource routing
    Given a file "routes.coffee" with the contents
          """
            module.exports = ({ resources }) ->
              resources 'users'
          """
    And a "Users" controller in "controllers/users.coffee" with the actions
          | ACTION  | RESPONSE      |
          | index   | users index   |
          | new     | users new     |
          | create  | users create  |
          | show    | users show    |
          | edit    | users edit    |
          | update  | users update  |
          | destroy | users destroy |
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
