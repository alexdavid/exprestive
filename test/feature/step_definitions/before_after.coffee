express = require 'express'
portfinder = require 'portfinder'

module.exports = ->
  @Before (done) ->
    @routes = ->
    @controllers = {}
    portfinder.getPort (err, @port) =>
      return done err if err
      @app = express()
      @server = @app.listen @port
      done()


  @After (done) ->
    @server.close ->
      done()
