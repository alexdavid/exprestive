Feature: reverse routing

  Scenario: routes can define reverse routes with 'as'
    Given the routing definition
      """
      GET '/some/route', to: 'test#index', as: 'fooBar'
      GET '/other/route', to: 'test#other', as: 'foo_bar'
      """
    And an exprestive app using defaults
    Then I have a routing helper "res.locals.routes.fooBar()" that returns "/some/route"
    Then I have a routing helper "res.locals.routes.foo_bar()" that returns "/other/route"


  Scenario: reverse route parameters can be filled in with multilple arguments
    Given the routing definition
      """
      GET '/users/:userId/posts/:id', to: 'posts#show', as: 'userPost'
      """
    And an exprestive app using defaults
    Then I have a routing helper "res.locals.routes.userPost(1, 2)" that returns "/users/1/posts/2"
    And I have a routing helper "res.locals.routes.userPost(1, 2).method" that returns "GET"


  Scenario: reverse route parameters can be filled in with an object
    Given the routing definition
      """
      GET '/users/:userId/posts/:id', to: 'posts#show', as: 'userPost'
      """
    And an exprestive app using defaults
    Then I have a routing helper "res.locals.routes.userPost({userId: 1, id: 2})" that returns "/users/1/posts/2"


  Scenario Outline: restful routes define reverse routes automatically
    Given the routing definition
      """
      resources 'users'
      """
    And an exprestive app using defaults
    Then I have a routing helper "<HELPER>" that returns "<VALUE>" and the HTTP verb "<METHOD>"

    Examples:
      | HELPER                             | VALUE           | METHOD |
      | res.locals.routes.users()          | /users          | GET    |
      | res.locals.routes.user(123)        | /users/123      | GET    |
      | res.locals.routes.newUser()        | /users/new      | GET    |
      | res.locals.routes.editUser(123)    | /users/123/edit | GET    |
      | res.locals.routes.updateUser(123)  | /users/123      | PUT    |
      | res.locals.routes.createUser()     | /users          | POST   |
      | res.locals.routes.destroyUser(123) | /users/123      | DELETE |


  Scenario: configuring the name of the global routes object
    Given the routing definition
      """
      GET '/some/route', to: 'test#index', as: 'foobar'
      """
    And an exprestive app with the option "routes" set to `global.custom_routes_object = {}`
    Then I have a routing helper "custom_routes_object.foobar()" that returns "/some/route"
    And I have a routing helper "res.locals.routes.foobar()" that returns "/some/route"
