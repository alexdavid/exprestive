{ expect } = require 'chai'

module.exports = ->
  @When /^a (.+) request to "(.+)" is made$/, (method, urlPath, done) ->
    @helpers.makeRequest method, urlPath, (err, response, body) =>
      done()


  @Then /^a (.+) request to "(.+)" returns a (\d+)$/, (method, urlPath, statusCode, done) ->
    @helpers.makeRequest method, urlPath, (err, response, body) =>
      expect(response.statusCode).to.equal parseInt(statusCode)
      done()
