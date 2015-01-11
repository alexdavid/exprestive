Feature: reverse routing

  Scenario: routes can define reverse routes with 'as'
    Given the routing definition
      """
      GET '/some/route', to: 'test#index', as: 'foobar'
      """
    And an exprestive app using defaults
    Then I have a routing helper "res.locals.paths.foobar()" that returns "/some/route"


  Scenario: reverse route parameters can be filled in with multilple arguments
    Given the routing definition
      """
      GET '/users/:userId/posts/:id', to: 'posts#show', as: 'userPost'
      """
    And an exprestive app using defaults
    Then I have a routing helper "res.locals.paths.userPost(1, 2)" that returns "/users/1/posts/2"


  Scenario: reverse route parameters can be filled in with an object
    Given the routing definition
      """
      GET '/users/:userId/posts/:id', to: 'posts#show', as: 'userPost'
      """
    And an exprestive app using defaults
    Then I have a routing helper "res.locals.paths.userPost({userId: 1, id: 2})" that returns "/users/1/posts/2"


  Scenario Outline: restful routes define reverse routes automatically
    Given the routing definition
      """
      resources 'users'
      """
    And an exprestive app using defaults
    Then I have a routing helper "<HELPER>" that returns "<VALUE>"

    Examples:
      | HELPER                         | VALUE           |
      | res.locals.paths.users()       | /users          |
      | res.locals.paths.user(123)     | /users/123      |
      | res.locals.paths.newUser()     | /users/new      |
      | res.locals.paths.editUser(123) | /users/123/edit |


  Scenario: paths object can be passed in to options
    Given the routing definition
      """
      GET '/some/route', to: 'test#index', as: 'foobar'
      """
    And an exprestive app with the option "paths" set to `global.custom_paths_object = {}`
    Then I have a routing helper "custom_paths_object.foobar()" that returns "/some/route"
    And the routing helper "res.locals.paths" is undefined
