_ = require 'lodash'
camelCase = require 'camel-case'
express = require 'express'
fs = require 'fs'
path = require 'path'

class Exprestive

  # Default options
  @defaultOptions =
    appDir: ''
    routesFilePath: 'routes'
    controllersDirPath: 'controllers'


  constructor: (baseDir, @options = {}) ->

    # Merge given and default options
    _.defaults @options, Exprestive.defaultOptions

    # The directory where routes and controllers can be found
    # Used only as a relative directory for @routesFilePath and @controllersDirPath
    @appDir = path.resolve baseDir, @options.appDir

    # Path to the routes file
    @routesFilePath = path.resolve @appDir, @options.routesFilePath

    # Path to the directory to look for controllers
    @controllersDirPath = path.resolve @appDir, @options.controllersDirPath

    # Router to register routes and pass to express as middleware
    @middlewareRouter = express.Router()


  # Registers a route on @middlewareRouter
  addRoute: ({ httpMethod, url, controllerName, controllerAction }) ->
    @middlewareRouter[httpMethod.toLowerCase()] url, =>
      @controllers[camelCase controllerName][controllerAction] arguments...


  # Returns the connect middleware to be passed to express app.use
  getMiddleware: ->
    @initializeControllers()
    @initializeRoutes()
    @middlewareRouter


  # Returns the hash of methods passed to the routes file function
  getRoutesHelperMethods: ->
    helperMethods = resources: @resourcesHelperMethod
    for httpMethod in ['GET', 'POST', 'PUT', 'DELETE']
      helperMethods[httpMethod] = @getRoutesHttpHelperMethod httpMethod
    helperMethods


  # Returns a helper method for a specific http method to be called in a routes file
  getRoutesHttpHelperMethod: (httpMethod) ->
    (url, { to }) =>
      [ controllerName, controllerAction ] = to.split '#'
      @addRoute { httpMethod, url, controllerName, controllerAction }


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


  # A helper method for automatically binding restful controllers in a routes file
  # This is passed as "resources" to the routes file function parameter hash
  resourcesHelperMethod: (controllerName) =>
    resourceRoutes = [
      [ 'GET',    "/#{controllerName}",          'index'   ]
      [ 'GET',    "/#{controllerName}/new",      'new'     ]
      [ 'POST',   "/#{controllerName}",          'create'  ]
      [ 'GET',    "/#{controllerName}/:id",      'show'    ]
      [ 'GET',    "/#{controllerName}/:id/edit", 'edit'    ]
      [ 'PUT',    "/#{controllerName}/:id",      'update'  ]
      [ 'DELETE', "/#{controllerName}/:id",      'destroy' ]
    ]
    for [httpMethod, url, controllerAction] in resourceRoutes
      @addRoute { httpMethod, url,  controllerAction, controllerName }


module.exports = Exprestive
