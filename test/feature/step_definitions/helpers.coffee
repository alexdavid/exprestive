Exprestive = require '../../../exprestive'
request = require 'request'
url = require 'url'

module.exports = ->
  @Before (done) ->
    @helpers =
      makeRequest: (method, urlPath, callback) =>
        exprestive = new Exprestive { @routes, @controllers }
        @app.use exprestive.getMiddleware()
        uri = url.format
          protocol: 'http:'
          hostname: 'localhost'
          port: @port
          pathname: urlPath
        request { method, uri }, callback

    done()
