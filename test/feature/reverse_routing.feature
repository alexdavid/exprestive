Feature: reverse routing

  Scenario: routes can define reverse routes with 'as'
    Given the routing definition
      """
      GET '/some/route', to: 'test#index', as: 'fooBar'
      GET '/other/route', to: 'test#other', as: 'foo_bar'
      """
    And an exprestive app using defaults
    Then I have a routing helper "this.routes.fooBar()" that returns "/some/route"
    And I have a routing helper "this.routes.foo_bar()" that returns "/other/route"


  Scenario: routes can be accessed from res.locals.routes when using express
    Given the routing definition
      """
      GET '/some/route', to: 'test#index', as: 'fooBar'
      GET '/other/route', to: 'test#other', as: 'foo_bar'
      """
    And an exprestive app powered by express
    Then I have a routing helper "res.locals.routes.fooBar()" that returns "/some/route"
    And I have a routing helper "res.locals.routes.foo_bar()" that returns "/other/route"


  Scenario: reverse route parameters can be filled in with multilple arguments
    Given the routing definition
      """
      GET '/users/:userId/posts/:id', to: 'posts#show', as: 'userPost'
      """
    And an exprestive app using defaults
    Then I have a routing helper "this.routes.userPost(1, 2)" that returns "/users/1/posts/2"
    And I have a routing helper "this.routes.userPost(1, 2).method" that returns "GET"


  Scenario: reverse route parameters can be filled in with an object
    Given the routing definition
      """
      GET '/users/:userId/posts/:id', to: 'posts#show', as: 'userPost'
      """
    And an exprestive app using defaults
    Then I have a routing helper "this.routes.userPost({userId: 1, id: 2})" that returns "/users/1/posts/2"


  Scenario Outline: restful routes define reverse routes automatically
    Given the routing definition
      """
      resources 'users'
      """
    And an exprestive app using defaults
    Then I have a routing helper "<HELPER>" that returns "<VALUE>" and the HTTP verb "<METHOD>"

    Examples:
      | HELPER                       | VALUE           | METHOD |
      | this.routes.users()          | /users          | GET    |
      | this.routes.user(123)        | /users/123      | GET    |
      | this.routes.newUser()        | /users/new      | GET    |
      | this.routes.editUser(123)    | /users/123/edit | GET    |
      | this.routes.updateUser(123)  | /users/123      | PUT    |
      | this.routes.createUser()     | /users          | POST   |
      | this.routes.destroyUser(123) | /users/123      | DELETE |
