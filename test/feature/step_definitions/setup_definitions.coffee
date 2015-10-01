async = require 'async'
{ expect } = require 'chai'


module.exports = ->

  @Given /^an exprestive app using defaults$/, (done) ->
    @createExprestiveApp '', (err) =>
      return done err if err
      @startApp done


  @Given /^an exprestive app with the option "([^"]+)" set to `([^`]+)`$/, (optionName, optionValue, done) ->
    optionsStr = "#{optionName}: #{optionValue}"
    @createExprestiveApp optionsStr, (err) =>
      return done.fail err if err
      @startApp done


  @Given /^a file "([^"]+)" with the content$/, (fileName, fileContents, done) ->
    @createFile fileName, fileContents, done


  @Given /^the routing definitions?$/, (routingDefinitons, done) ->
    routesFileContents = """
    module.exports = ({GET, POST, PUT, DELETE, resources}) ->
      #{routingDefinitons.replace("\n", "\n  ")}
      GET '/eval/:strToEval', to: 'eval#index'
    """
    @createFile 'routes.coffee', routesFileContents, done


  @Then /^the app doesn't error$/, ->
