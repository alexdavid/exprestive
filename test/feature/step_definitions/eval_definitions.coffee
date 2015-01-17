{ expect } = require 'chai'


module.exports = ->

  @Then /^I have a routing helper "([^"]+)" that returns "([^"]+)"$/, (helper, value, done) ->
    @makeRequest 'get', "/eval/return String(#{helper})", (err, _, responseBody) ->
      return done.fail err if err
      expect(responseBody).to.equal value
      done()


  @Then /^the routing helper "([^"]+)" is undefined$/, (helper, done) ->
    @makeRequest 'get', "/eval/return String(#{helper})", (err, _, responseBody) ->
      return done.fail err if err
      expect(responseBody).to.equal 'undefined'
      done()
