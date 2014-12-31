Feature: Finding routes

  Scenario: an application with a custom routes file
    Given a routes file "my_routes.coffee" with the routes
          | METHOD | ROUTE  | TO          |
          | GET    | /users | users#index |
    And a "Users" controller in "controllers/users_controller.coffee" with the actions
          | ACTION | RESPONSE  |
          | index  | user list |
    And an exprestive app with the option "routesFilePath" set to `"./my_routes.coffee"`
    When making a GET request to /users
    Then the response should be a 200
    And the response body should be "user list"


  Scenario: an application with routes passed into options instead of a routes file
    Given a "Users" controller in "controllers/users_controller.coffee" with the actions
          | ACTION | RESPONSE  |
          | index  | user list |
    And an exprestive app with the option "routes" set to `({ GET }) -> GET '/users', to: 'users#index'`
    When making a GET request to /users
    Then the response should be a 200
    And the response body should be "user list"
