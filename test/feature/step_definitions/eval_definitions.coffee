{ expect } = require 'chai'


module.exports = ->

  @Then /^I have a routing helper "([^"]+)" that returns "([^"]+)"$/, (helper, value) ->
    response = yield @makeRequest 'get', "/eval/return String(#{helper})"
    expect(response.body).to.equal value


  @Then /^I have a routing helper "([^"]+)" that returns "([^"]+)" and the HTTP verb "([^"]+)"$/, (helper, value, method) ->
    response = yield @makeRequest 'get', "/eval/return String(#{helper})"
    expect(response.body).to.equal value
    response = yield @makeRequest 'get', "/eval/return String(#{helper}.method)"
    expect(response.body).to.equal method


  @Then /^the routing helper "([^"]+)" is undefined$/, (helper) ->
    response = yield @makeRequest 'get', "/eval/return String(#{helper})"
    expect(response.body).to.equal 'undefined'
