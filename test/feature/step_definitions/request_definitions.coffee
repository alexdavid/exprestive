{ expect } = require 'chai'
Promise = require 'bluebird'

module.exports = ->

  @When /^making a (GET|POST|PUT|DELETE) request to "(.+)"$/, (httpMethod, urlPath) -> do Promise.coroutine =>
    console.log 'before request'
    response = yield @makeRequest httpMethod, urlPath
    console.log 'request', responseas
    @responseBody = response.body
    @requestPath = response.request.path
    @statusCode = response.statusCode


  @Then /^the response code should be (\d+)$/, (statusCode) ->
    expect(@statusCode).to.equal parseInt statusCode


  @Then /^the response body should be "([^"]+)"$/, (responseBody) ->
    console.log 'response', @responseBody
    expect(@responseBody.trim()).to.equal responseBody


  @Then /^I am redirected to "([^"]+)"$/, (expectedPath) ->
    expect(@requestPath).to.equal expectedPath
