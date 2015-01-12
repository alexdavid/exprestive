Feature: reverse routing

  Scenario: standard redirection
    Given the routing definition
      """
      GET '/some/route', to: redirect('/redirected/route')
      """
    And an exprestive app using defaults
    When making a GET request to "/some/route"
    Then exprestive redirects my request to "/redirected/route"


  Scenario: dynamic segment redirection
    Given the routing definition
      """
      GET '/users/:userId/edit', to: redirect('/edit_user/%{userId}')
      """
    And an exprestive app using defaults
    When making a GET request to "/users/1/edit"
    Then exprestive redirects my request to "/edit_user/1"
    When making a GET request to "/users/2/edit"
    Then exprestive redirects my request to "/edit_user/2"
