Feature: Finding controllers

  Scenario: an application with defaults
    Given a routes file "routes.coffee" with the routes
          | METHOD | ROUTE  | TO          |
          | GET    | /users | users#index |
    And a "Users" controller in "controllers/users_controller.coffee" with the actions
          | ACTION | RESPONSE  |
          | index  | user list |
    And an exprestive app using defaults
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario: an application with a custom controllers directory
    Given a routes file "routes.coffee" with the routes
          | METHOD | ROUTE  | TO          |
          | GET    | /users | users#index |
    And a "Users" controller in "my_controllers/controller_name.coffee" with the actions
          | ACTION | RESPONSE  |
          | index  | user list |
    And an exprestive app with the option "controllersDirPath" set to `"./my_controllers"`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"


  Scenario: an application with controllers passed into options instead of a controllers directory
    Given a routes file "routes.coffee" with the routes
          | METHOD | ROUTE  | TO          |
          | GET    | /users | users#index |
    And an exprestive app with the option "controllers" set to `{ users: index: (req, res) -> res.end 'user list' }`
    When making a GET request to "/users"
    Then the response code should be 200
    And the response body should be "user list"
