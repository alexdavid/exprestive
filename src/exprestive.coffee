camelCase = require 'camel-case'
express = require 'express'
fs = require 'fs'
path = require 'path'

class Exprestive

  constructor: (baseDir, @options = {}) ->

    # The directory where routes and controllers can be found
    # Used only as a relative directory for @routesFilePath and @controllersDirPath
    @appDir = path.resolve baseDir, @options.appDir ? ''

    # Path to the routes file
    @routesFilePath = path.resolve @appDir, @options.routesFilePath ? 'routes'

    # Path to the directory to look for controllers
    @controllersDirPath = path.resolve @appDir, @options.controllersDirPath ? 'controllers'

    # Router to register routes and pass to express as middleware
    @middlewareRouter = express.Router()


  # Registers a route on @middlewareRouter
  addRoute: ({ httpMethod, url, controllerName, controllerAction }) ->
    @middlewareRouter[httpMethod.toLowerCase()] url, =>
      @controllers[camelCase controllerName][controllerAction] arguments...


  # Returns the hash of methods passed to the routes file function
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


  # Populates @controllers by instantiating controllers found in @controllerDirPath
  initializeControllers: ->
    @controllers = @options.controllers ? {}
    return if @options.controllers?

    for file in fs.readdirSync @controllersDirPath
      Controller = require path.join @controllersDirPath, file
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller


  # Sets the @routesMethod from the function exported from @routesFilePath
  initializeRoutes: ->
    return if @routesInitialized
    @routesInitialized = yes
    @routesMethod = @options.routes ? require @routesFilePath
    @routesMethod @getRoutesHelperMethods()


module.exports = Exprestive
