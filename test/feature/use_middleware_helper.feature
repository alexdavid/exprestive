Feature: BaseController useMiddleware helper


  Background:
    Given a file "routes.coffee" with the content
      """
      module.exports = ({ GET }) ->
        GET '/users', to: 'users#index'
        GET '/users/:id', to: 'users#show'
      """


  Scenario Outline: basic usage
    Given a file "controllers/users_controller.coffee" with the content
      """
      {BaseController} = require 'exprestive'

      middle = (req, res, next) ->
        req.custom = 'foo'
        next()

      class UsersController extends BaseController
        constructor: ->
          @useMiddleware middle

        index: (req, res) -> res.end req.custom

        show: (req, res) -> res.end req.custom
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | foo           |
      | GET     | /users/1 | foo           |


  Scenario Outline: specify multiple middleware
    Given a file "controllers/users_controller.coffee" with the content
      """
      {BaseController} = require 'exprestive'

      middle1 = (req, res, next) ->
        req.custom1 = 'foo'
        next()

      middle2 = (req, res, next) ->
        req.custom2 = 'bar'
        next()

      class UsersController extends BaseController
        constructor: ->
          @useMiddleware [middle1, middle2]

        index: (req, res) -> res.end "#{req.custom1} #{req.custom2}"

        show: (req, res) -> res.end "#{req.custom1} #{req.custom2}"
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | foo bar       |
      | GET     | /users/1 | foo bar       |


  Scenario Outline: with only option specified
    Given a file "controllers/users_controller.coffee" with the content
      """
      {BaseController} = require 'exprestive'

      middle = (req, res, next) ->
        req.custom = 'foo'
        next()

      class UsersController extends BaseController
        constructor: ->
          @useMiddleware middle, only: 'index'

        index:   (req, res) -> res.end req.custom

        show:    (req, res) -> res.end "#{'No Custom' unless req.custom?}"
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | foo           |
      | GET     | /users/1 | No Custom     |


  Scenario Outline: with except option specified
    Given a file "controllers/users_controller.coffee" with the content
      """
      {BaseController} = require 'exprestive'

      middle = (req, res, next) ->
        req.custom = 'foo'
        next()

      class UsersController extends BaseController
        constructor: ->
          @useMiddleware middle, except: 'show'

        index:   (req, res) -> res.end req.custom

        show:    (req, res) -> res.end "#{'No Custom' unless req.custom?}"
      module.exports = UsersController
      """
    And an exprestive app using defaults
    When making a <REQUEST> request to "<URL>"
    Then the response body should be "<RESPONSE BODY>"

    Examples:
      | REQUEST | URL      | RESPONSE BODY |
      | GET     | /users   | foo           |
      | GET     | /users/1 | No Custom     |
