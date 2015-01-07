Feature: reverse routing

  Background:
    Given an empty "controllers" directory


  Scenario: routes can define reverse routes with 'as'
    Given a file "routes.coffee" with the contents
      """
      module.exports = ({ GET }) ->
        GET '/some/route', to: 'test#index', as: 'foobar'
      """
    And an exprestive app using defaults
    Then the function res.locals.paths.foobar() should return "/some/route"


  Scenario Outline: restful routes define reverse routes automatically
    Given a file "routes.coffee" with the contents
      """
      module.exports = ({ resources, GET }) ->
        resources 'users'
      """
    And an exprestive app using defaults
    Then the function res.locals.<LOCAL> should return "<VALUE>"

    Examples:
      | LOCAL               | VALUE           |
      | paths.users()       | /users          |
      | paths.user(123)     | /users/123      |
      | paths.newUser()     | /users/new      |
      | paths.editUser(123) | /users/123/edit |
