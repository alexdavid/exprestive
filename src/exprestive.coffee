_ = require 'lodash'
camelCase = require 'camel-case'
express = require 'express'
fs = require 'fs'
path = require 'path'
{pluralize, singularize} = require 'inflection'


class Exprestive

  # Default options
  @defaultOptions =
    appDir: ''
    routesFilePath: 'routes'
    controllersDirPath: 'controllers'
    paths: {}


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
    @reversePaths = @options.paths
    @middlewareRouter.use @setReverseRoutesOnReqLocals


  # Registers a route on @middlewareRouter
  addRoute: ({httpMethod, url, controllerName, controllerAction}) ->
    @middlewareRouter[httpMethod.toLowerCase()] url, =>
      @controllers[camelCase controllerName][controllerAction] arguments...


  # Returns a route directive for a specific http method to be called in a routes file
  getHttpDirective: (httpMethod) ->
    (url, {to, as}) =>
      [controllerName, controllerAction] = to.split '#'
      @addRoute {httpMethod, url, controllerName, controllerAction}
      @registerReverseRoute {routeName: as, url} if as?


  # Returns the connect middleware to be passed to express app.use
  getMiddleware: ->
    @initializeControllers()
    @initializeRoutes()
    @middlewareRouter


  # Returns the object of directives passed to the routes file function
  getRouteDirectives: ->
    directives = resources: @resourcesDirective
    for httpMethod in ['GET', 'POST', 'PUT', 'DELETE']
      directives[httpMethod] = @getHttpDirective httpMethod
    directives


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
    @routesMethod @getRouteDirectives()


  # Save a function to @reversePaths to get a url back from a route name
  registerReverseRoute: ({routeName, url}) ->
    @reversePaths[camelCase routeName] = (args...) ->
      if typeof args[0] is 'object'
        url = url.replace ":#{k}", v for k, v of args[0]
      else
        url = url.replace /\:[^/]+/, arg for arg in args

      url


  # A helper method for automatically binding restful controllers in a routes file
  # This is passed as "resources" to the routes file function parameter hash
  resourcesDirective: (controllerName) =>
    {GET, POST, PUT, DELETE} = @getRouteDirectives()
    singularName = singularize controllerName
    pluralName = pluralize controllerName

    GET "/#{controllerName}",          to: "#{controllerName}#index", as: pluralName
    GET "/#{controllerName}/new",      to: "#{controllerName}#new",   as: "new_#{singularName}"
    GET "/#{controllerName}/:id",      to: "#{controllerName}#show",  as: singularName
    GET "/#{controllerName}/:id/edit", to: "#{controllerName}#edit",  as: "edit_#{singularName}"
    PUT "/#{controllerName}/:id",      to: "#{controllerName}#update"
    POST   "/#{controllerName}",       to: "#{controllerName}#create"
    DELETE "/#{controllerName}/:id",   to: "#{controllerName}#destroy"


  # Middleware to set reverse routes on req.locals
  setReverseRoutesOnReqLocals: (req, res, next) =>
    # Only set res.locals.paths if the paths option was not set
    res.locals.paths = @reversePaths if @options.paths is Exprestive.defaultOptions.paths
    next()


module.exports = Exprestive
