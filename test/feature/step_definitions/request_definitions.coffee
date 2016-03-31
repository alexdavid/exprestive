{ expect } = require 'chai'


module.exports = ->

  @When /^making a (GET|POST|PUT|DELETE) request to "(.+)"$/, (httpMethod, urlPath, done) ->
    @makeRequest httpMethod, urlPath, (err, response, @responseBody) =>
      return done err if err
      @requestPath = response.request.path
      @statusCode = response.statusCode
      done()


  @Then /^the response code should be (\d+)$/, (statusCode) ->
    expect(@statusCode).to.equal parseInt statusCode


  @Then /^the response body should be "([^"]+)"$/, (responseBody) ->
    expect(@responseBody.trim()).to.equal responseBody


  @Then /^I am redirected to "([^"]+)"$/, (expectedPath) ->
    expect(@requestPath).to.equal expectedPath
