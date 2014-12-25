Feature: Standard Routing

  Scenario: GET routes
    Given the route GET "/foo"
    Then a GET request to "/foo" returns a 200
    And a POST request to "/foo" returns a 404
    And a PUT request to "/foo" returns a 404
    And a DELETE request to "/foo" returns a 404

  Scenario: POST routes
    Given the route POST "/foo"
    Then a POST request to "/foo" returns a 200
    And a GET request to "/foo" returns a 404
    And a PUT request to "/foo" returns a 404
    And a DELETE request to "/foo" returns a 404

  Scenario: PUT routes
    Given the route PUT "/foo"
    Then a PUT request to "/foo" returns a 200
    And a GET request to "/foo" returns a 404
    And a POST request to "/foo" returns a 404
    And a DELETE request to "/foo" returns a 404

  Scenario: DELETE routes
    Given the route DELETE "/foo"
    Then a DELETE request to "/foo" returns a 200
    And a GET request to "/foo" returns a 404
    And a POST request to "/foo" returns a 404
    And a PUT request to "/foo" returns a 404
