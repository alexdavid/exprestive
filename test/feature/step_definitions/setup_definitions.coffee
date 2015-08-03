async = require 'async'
{ expect } = require 'chai'


module.exports = ->

  @Given /^an exprestive app using defaults$/, (done) ->
    async.series [
      (next) => @createExprestiveApp '', next
      (next) => @startApp next
    ], done


  @Given /^an exprestive app with the option "([^"]+)" set to `([^`]+)`$/, (optionName, optionValue, done) ->
    optionsStr = "#{optionName}: #{optionValue}"
    async.series [
      (next) => @createExprestiveApp optionsStr, next
      (next) => @startApp next
    ], done


  @Given /^a file "([^"]+)" with the content$/, (fileName, fileContents, done) ->
    fileContents = fileContents.replace '{{EXPRESTIVE_PATH}}', @exprestivePath
    @createFile fileName, fileContents, done


  @Given /^the routing definitions?$/, (routingDefinitons, done) ->
    routesFileContents = """
    module.exports = ({GET, POST, PUT, DELETE, resources}) ->
      #{routingDefinitons.replace("\n", "\n  ")}
    """
    @createFile 'routes.coffee', routesFileContents, done


  @Then /^the app doesn't error$/, ->
