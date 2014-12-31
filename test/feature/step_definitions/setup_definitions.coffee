{ expect } = require 'chai'


module.exports = ->

  @Given /^an express app using exprestive$/, (done) ->
    @createExprestiveApp {}, (err) =>
      return done.fail err if err
      @startApp (err) =>
        return done.fail err if err
        done()


  @Given /^an exprestive app with the option "([^"]+)" set to "([^"]+)"$/, (optionName, optionValue, done) ->
    options = {}
    options[optionName] = optionValue
    @createExprestiveApp options, (err) =>
      return done.fail err if err
      @startApp (err) =>
        return done.fail err if err
        done()


  @Given /^a routes file "([^"]+)" with the routes$/, (fileName, routes, done) ->
    @createRoutesFile fileName, routes.hashes(), (err) =>
      return done.fail err if err
      done()


  @Given /^a "([^"]+)" controller in "([^"]+)" with the actions$/, (controllerName, fileName, actions, done) ->
    @createController controllerName, fileName, actions.hashes(), (err) =>
      return done.fail err if err
      done()
