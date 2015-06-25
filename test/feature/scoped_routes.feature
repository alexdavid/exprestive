Feature: Scoped routes

  Scenario Outline: basic scoped routing
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ scope, GET }) ->
        scope '/api', ->
          GET '/users', to: 'users#index'
        GET '/widgets', to: 'widgets#index'
      """
    And a file "controllers/users_controller.coffee" with the content
      """
      class UsersController
        index:   (req, res) -> res.end 'users index'
      module.exports = UsersController
      """
    And a file "controllers/widgets_controller.coffee" with the content
      """
      class WidgetsController
        index:   (req, res) -> res.end 'widgets index'
      module.exports = WidgetsController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL               | RESPONSE BODY   |
      | GET     | /api/users        | users index     |
      | GET     | /widgets          | widgets index   |

  Scenario Outline: resource scoped routing
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ resources, scope }) ->
        scope '/api', ->
          resources 'users'
      """
    And a file "controllers/users_controller.coffee" with the content
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
      | REQUEST | URL               | RESPONSE BODY |
      | GET     | /api/users        | users index   |
      | GET     | /api/users/new    | users new     |
      | POST    | /api/users        | users create  |
      | GET     | /api/users/1      | users show    |
      | GET     | /api/users/1/edit | users edit    |
      | PUT     | /api/users/1      | users update  |
      | DELETE  | /api/users/1      | users destroy |

  Scenario Outline: nested scoped routing
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ GET, scope }) ->
        scope '/api', ->
          scope '/v1', ->
            GET 'users', to: 'users#index'
      """
    And a file "controllers/users_controller.coffee" with the content
      """
      class UsersController
        index:   (req, res) -> res.end 'users index'
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL                  | RESPONSE BODY |
      | GET     | /api/v1/users        | users index   |
