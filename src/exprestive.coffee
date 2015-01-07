_ = require 'lodash'
camelCase = require 'camel-case'
express = require 'express'
fs = require 'fs'
path = require 'path'
{pluralize, singularize } = require 'inflection'


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

    # Save reverse paths
    @reversePaths = {}
    @middlewareRouter.use @setReverseRoutesOnReqLocals


  # Registers a route on @middlewareRouter
  addRoute: ({httpMethod, url, controllerName, controllerAction}) ->
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
    (url, {to, as}) =>
      [controllerName, controllerAction] = to.split '#'
      @addRoute {httpMethod, url, controllerName, controllerAction}
      @registerReverseRoute {routeName: as, url}


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


  # Save a function to @reversePaths to get a url back from a route name
  registerReverseRoute: ({routeName, url}) ->
    return unless routeName?
    @reversePaths[camelCase routeName] = (id) ->
      url.replace ':id', id


  # A helper method for automatically binding restful controllers in a routes file
  # This is passed as "resources" to the routes file function parameter hash
  resourcesHelperMethod: (controllerName) =>
    singular = singularize controllerName
    plural = pluralize controllerName
    for [ httpMethod ,  url                   , controllerAction , routeName          ] in [
        [ 'GET'      ,  "/#{plural}"          , 'index'          , plural             ]
        [ 'GET'      ,  "/#{plural}/new"      , 'new'            , "new_#{singular}"  ]
        [ 'POST'     ,  "/#{plural}"          , 'create'         , null               ]
        [ 'GET'      ,  "/#{plural}/:id"      , 'show'           , singular           ]
        [ 'GET'      ,  "/#{plural}/:id/edit" , 'edit'           , "edit_#{singular}" ]
        [ 'PUT'      ,  "/#{plural}/:id"      , 'update'         , null               ]
        [ 'DELETE'   ,  "/#{plural}/:id"      , 'destroy'        , null               ]
    ]
      @addRoute {httpMethod, url,  controllerAction, controllerName}
      @registerReverseRoute {routeName, url}


  # Middleware to set reverse routes on req.locals
  setReverseRoutesOnReqLocals: (req, res, next) =>
    res.locals.paths = @reversePaths
    next()


module.exports = Exprestive
