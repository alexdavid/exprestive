{ expect } = require 'chai'


module.exports = ->

  @When /^making a (GET|POST|PUT|DELETE) request to "(.+)"$/, (httpMethod, urlPath, done) ->
    @makeRequest httpMethod, urlPath, (err, response, @responseBody) =>
      return done.fail err if err
      @statusCode = response.statusCode
      done()


  @Then /^the response code should be (\d+)$/, (statusCode, done) ->
    expect(@statusCode).to.equal parseInt statusCode
    done()


  @Then /^the response body should be "([^"]+)"$/, (responseBody, done) ->
    expect(@responseBody.trim()).to.equal responseBody
    done()
