{ expect } = require 'chai'


module.exports = ->

  @Then /^I have a routing helper "([^"]+)" that returns "([^"]+)"$/, (helper, value, done) ->
    @makeRequest 'get', "/eval/return String(#{helper})", (err, _, responseBody) ->
      return done err if err
      expect(responseBody).to.equal value
      done()


  @Then /^I have a routing helper "([^"]+)" that returns "([^"]+)" and the HTTP verb "([^"]+)"$/, (helper, value, method, done) ->
    @makeRequest 'get', "/eval/return String(#{helper})", (err, _, responseBody) =>
      return done err if err
      expect(responseBody).to.equal value
      @makeRequest 'get', "/eval/return String(#{helper}.method)", (err, _, responseBody) ->
        return done err if err
        expect(responseBody).to.equal method
        done()

  @Then /^the routing helper "([^"]+)" is undefined$/, (helper, done) ->
    @makeRequest 'get', "/eval/return String(#{helper})", (err, _, responseBody) ->
      return done err if err
      expect(responseBody).to.equal 'undefined'
      done()
