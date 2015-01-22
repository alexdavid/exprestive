{ expect } = require 'chai'


module.exports = ->

  @Given /^an exprestive app using defaults$/, (done) ->
    @createExprestiveApp '', (err) =>
      return done.fail err if err
      @startApp (err) =>
        return done.fail err if err
        done()


  @Given /^an exprestive app with the option "([^"]+)" set to `([^`]+)`$/, (optionName, optionValue, done) ->
    optionsStr = "#{optionName}: #{optionValue}"
    @createExprestiveApp optionsStr, (err) =>
      return done.fail err if err
      @startApp (err) =>
        return done.fail err if err
        done()


  @Given /^a file "([^"]+)" with the content$/, (fileName, fileContents, done) ->
    @createFile fileName, fileContents, (err) =>
      return done.fail err if err
      done()


  @Given /^the routing definitions?$/, (routingDefinitons, done) ->
    routesFileContents = """
    module.exports = ({GET, POST, PUT, DELETE, resources}) ->
      #{routingDefinitons.replace("\n", "\n  ")}
    """
    @createFile "routes.coffee", routesFileContents, (err) =>
      return done.fail err if err
      done()


  @Then /^the app doesn't error$/, (done) ->
    done()
