{ expect } = require 'chai'


module.exports = ->

  @Then /^the function res\.locals\.(.+) should return "([^"]+)"$/, (local, value, done) ->
    @makeRequest 'get', "/eval/return res.locals.#{local}", (err, _, responseBody) ->
      return done.fail err if err
      expect(responseBody).to.equal value
      done()
