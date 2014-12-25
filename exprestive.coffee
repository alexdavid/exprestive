callsite = require 'callsite'
express = require 'express'
path = require 'path'

class Exprestive
  constructor: (@options = {}) ->
    @appDir             = path.resolve @getCallerDirname(), @options.appDir ? ''
    @routesFilePath     = path.resolve @appDir, @options.routesFilePath ? 'routes'
    @controllersDirPath = path.resolve @appDir, @options.controllersDirPath ? 'controllers'
    @controllers = @options.controllers
    @middlewareRouter = express.Router()


  # Registers a route on the middlewareRouter
  addRoute: ({ httpMethod, url, controllerName, controllerAction }) ->
    httpMethod = httpMethod.toLowerCase()
    @middlewareRouter[httpMethod] url, => @controllers[controllerName][controllerAction] arguments...


  # Returns the __dirname of the file that called this method
  getCallerDirname: ->
    stack = callsite()
    for item in stack
      fileName = item.getFileName()
      continue if fileName is __filename
      return path.dirname fileName


  # Returns a hash of methods (GET, POST, PUT, DELETE) to be called in the routes file
  getRoutesHelperMethods: ->
    helperMethods = {}
    for httpMethod in ['GET', 'POST', 'PUT', 'DELETE']
      helperMethods[httpMethod] = do (httpMethod) => (url, { to }) =>
        [ controllerName, controllerAction ] = to.split '#'
        @addRoute { httpMethod, url, controllerName, controllerAction }
    helperMethods


  # Returns the connect middleware to be passed to express app.use
  getMiddleware: ->
    @initializeRoutes()
    @middlewareRouter


  initializeRoutes: ->
    return if @routesInitialized
    @routesInitialized = yes
    @routesMethod = @options.routes ? require @routesFilePath
    @routesMethod @getRoutesHelperMethods()


module.exports = Exprestive
