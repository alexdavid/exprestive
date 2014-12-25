exprestive = require '../../..'
request = require 'request'
url = require 'url'

module.exports = ->
  @Before (done) ->
    @helpers =
      makeRequest: (method, urlPath, callback) =>
        @app.use exprestive { @routes, @controllers }
        uri = url.format
          protocol: 'http:'
          hostname: 'localhost'
          port: @port
          pathname: urlPath
        request { method, uri }, callback

    done()
