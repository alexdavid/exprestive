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


  @Given /^a file "([^"]+)" with the contents$/, (fileName, fileContents, done) ->
    @createFile fileName, fileContents, (err) =>
      return done.fail err if err
      done()
