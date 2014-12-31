camelCase = require 'camel-case'
express = require 'express'
fs = require 'fs'
path = require 'path'

class Exprestive
  constructor: (baseDir, @options = {}) ->
    @appDir             = path.resolve baseDir, @options.appDir ? ''
    @routesFilePath     = path.resolve @appDir, @options.routesFilePath ? 'routes'
    @controllersDirPath = path.resolve @appDir, @options.controllersDirPath ? 'controllers'
    @middlewareRouter = express.Router()


  # Registers a route on the middlewareRouter
  addRoute: ({ httpMethod, url, controllerName, controllerAction }) ->
    httpMethod = httpMethod.toLowerCase()
    @middlewareRouter[httpMethod] url, => @controllers[controllerName][controllerAction] arguments...


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
    @initializeControllers()
    @initializeRoutes()
    @middlewareRouter


  initializeControllers: ->
    @controllers = @options.controllers ? {}
    return if @options.controllers?

    for file in fs.readdirSync @controllersDirPath
      Controller = require path.join @controllersDirPath, file
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller


  initializeRoutes: ->
    return if @routesInitialized
    @routesInitialized = yes
    @routesMethod = @options.routes ? require @routesFilePath
    @routesMethod @getRoutesHelperMethods()


module.exports = Exprestive
