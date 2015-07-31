Feature: Advanced usage

  Scenario: controller instances can be accessed
    Given a file "routes.coffee" with the content
      """
      module.exports = ({GET}) ->
        GET '/status', to: 'status#index'
      """
    And a file "controllers/count_controller.coffee" with the content
      """
      class StatusController
        constructor: ->
          @status = 'unknown'

        setStatus: (x) ->
          @status = x

        index: (req, res) ->
          res.end @status

      module.exports = StatusController
      """
    Given a file "server.coffee" with the content
      """
      express = require 'express'
      {Exprestive} = require 'exprestive'

      exprestive = new Exprestive __dirname, {}
      exprestive.controllers.status.setStatus 'green'

      app = express()
      app.use exprestive.middlewareRouter
      app.use (err, req, res, next) -> res.status(500).end err.toString()
      app.listen process.env.PORT

      process.send('server started')
      """
    And I start my app
    When making a GET request to "/status"
    Then the response code should be 200
    And the response body should be "green"
