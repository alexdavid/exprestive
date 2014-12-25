chai = require 'chai'
sinon = require 'sinon'
{ expect } = chai
chai.use require('sinon-chai')

module.exports = ->
  @Given /^the route ([A-Z]+) "([^"]+)"$/, (method, urlPath, done) ->
    @controllers.test_controller ?= {}
    @controllers.test_controller.test_action = (req, res) -> res.end()
    @routes = (methods) ->
      methods[method] urlPath, to: 'test_controller#test_action'
    done()


  @Given /^the route ([A-Z]+) "([^"]+)" to "([^"]+)"$/, (method, urlPath, controllerAction, done) ->
    @routes = (methods) ->
      methods[method] urlPath, to: controllerAction
    done()


  @Given /^a (\w+) controller with an? (\w+) action$/, (controller, action, done) ->
    @controllers[controller] ?= {}
    @controllers[controller][action] = sinon.spy (req, res) -> res.end()
    done()


  @Then /^the (\w+) action of the (\w+) controller is called$/, (action, controller, done) ->
    expect(@controllers[controller][action]).to.have.been.calledOnce
    done()
