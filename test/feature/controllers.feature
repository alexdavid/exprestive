Feature: Controllers

  Scenario: calling controller methods via GET requests
    Given a users controller with an index action
    And the route GET "/users" to "users#index"
    When a GET request to "/users" is made
    Then the index action of the users controller is called

  Scenario: calling controller methods via POST requests
    Given a users controller with an index action
    And the route POST "/users" to "users#index"
    When a POST request to "/users" is made
    Then the index action of the users controller is called

  Scenario: calling controller methods via PUT requests
    Given a users controller with an index action
    And the route PUT "/users" to "users#index"
    When a PUT request to "/users" is made
    Then the index action of the users controller is called

  Scenario: calling controller methods via DELETE requests
    Given a users controller with an index action
    And the route DELETE "/users" to "users#index"
    When a DELETE request to "/users" is made
    Then the index action of the users controller is called
