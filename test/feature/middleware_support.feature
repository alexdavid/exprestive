Feature: Middleware support

  Scenario Outline: simple middleware support
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ GET }) ->
        GET '/users', to: 'users#index'
      """
    And a file "controllers/users_controller.coffee" with the content
      """
      middle = (req, res, next) ->
        req.custom = 'foo'
        next()

      class UsersController
        middleware:
          index: middle

        index: (req, res) -> res.end req.custom
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL     | RESPONSE BODY |
      | GET     | /users  | foo           |


  Scenario Outline: multiple middleware support
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ GET }) ->
        GET '/users', to: 'users#index'
      """
    And a file "controllers/users_controller.coffee" with the content
      """
      middle1 = (req, res, next) ->
        req.custom1 = 'foo'
        next()

      middle2 = (req, res, next) ->
        req.custom2 = 'bar'
        next()

      class UsersController
        middleware:
          index: [middle1, middle2]

        index: (req, res) -> res.end "#{req.custom1} #{req.custom2}"
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL     | RESPONSE BODY |
      | GET     | /users  | foo bar       |
