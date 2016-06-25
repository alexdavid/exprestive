{ expect } = require 'chai'
coffee = require 'coffee-script'


module.exports = ->

  @Given /^an exprestive app using defaults$/, ->
    yield @createExprestiveApp library: 'connect'
    yield @startApp()


  @Given /^an exprestive app powered by express$/, ->
    yield @createExprestiveApp library: 'express'
    yield @startApp()


  @Given /^an exprestive app with the option "([^"]+)" set to `([^`]+)`$/, (optionName, optionValue) ->
    yield @createExprestiveApp {
      library: 'connect'
      exprestiveOptions: "#{optionName}": coffee.eval optionValue
    }
    yield @startApp()


  @Given /^a file "([^"]+)" with the content$/, (fileName, fileContents) ->
    yield @createFile fileName, fileContents


  @Given /^the routing definitions?$/, (routingDefinitons) ->
    routesFileContents = """
    module.exports = ({GET, POST, PUT, DELETE, resources}) => {
      GET('/eval/:strToEval', {to: 'eval#index'});
      #{routingDefinitons}
    }
    """
    yield @createFile 'routes.js', routesFileContents


  @Then /^the app doesn't error$/, ->
