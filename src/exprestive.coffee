_ = require 'lodash'
camelCase = require 'camel-case'
express = require 'express'
fs = require 'fs'
path = require 'path'
{pluralize, singularize} = require 'inflection'
URLFormatter = require './url_formatter'


class Exprestive

  # Default options
  @defaultOptions =
    appDir: ''
    routesFilePath: 'routes'
    controllersDirPath: 'controllers'
    dependencies: {}
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


  # Returns if the passed filePath resembles a controller
  # Controllers are .js or .coffee files that export a constructor and name
  fileIsController: (filePath) ->
    # Non-JS files aren't controllers
    extension = path.extname filePath
    return false unless extension is '.coffee' or extension is '.js'

    # Controllers must export a name
    maybeController = require filePath
    return false unless maybeController.name?

    # Controllers must export a constructor function
    return false unless typeof maybeController is 'function'

    true


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

    for fileName in fs.readdirSync @controllersDirPath
      filePath = path.join @controllersDirPath, fileName
      continue unless @fileIsController filePath
      Controller = require filePath
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller @options.dependencies


  # Sets the @routesMethod from the function exported from @routesFilePath
  initializeRoutes: ->
    return if @routesInitialized
    @routesInitialized = yes
    @routesMethod = @options.routes ? require @routesFilePath
    @routesMethod @getRouteDirectives()


  # Save a function to @reversePaths to get a url back from a route name
  registerReverseRoute: ({routeName, url}) ->
    formatter = new URLFormatter url
    @reversePaths[routeName] = new URLFormatter(url).replaceParams


  # Full list of resource action names. It is important that 'new' precede 'show'
  resourceActions:
    ['index', 'new', 'show', 'edit', 'update', 'create', 'destroy']


  # Returns an object mapping each resource route name to a function which binds the route
  resourceMappings: (controllerName) ->
    {GET, POST, PUT, DELETE} = @getRouteDirectives()
    singularName = singularize controllerName
    pluralName = pluralize controllerName

    index:   -> GET "/#{controllerName}",          to: "#{controllerName}#index",   as: pluralName
    new:     -> GET "/#{controllerName}/new",      to: "#{controllerName}#new",     as: camelCase "new_#{singularName}"
    show:    -> GET "/#{controllerName}/:id",      to: "#{controllerName}#show",    as: singularName
    edit:    -> GET "/#{controllerName}/:id/edit", to: "#{controllerName}#edit",    as: camelCase "edit_#{singularName}"
    update:  -> PUT "/#{controllerName}/:id",      to: "#{controllerName}#update",  as: camelCase "update_#{singularName}"
    create:  -> POST   "/#{controllerName}",       to: "#{controllerName}#create",  as: camelCase "create_#{singularName}"
    destroy: -> DELETE "/#{controllerName}/:id",   to: "#{controllerName}#destroy", as: camelCase "destroy_#{singularName}"


  # A helper method for automatically binding restful controllers in a routes file
  # This is passed as "resources" to the routes file function parameter hash
  # Routes can be filtered with the 'only:' option.
  # E.g. resources 'users', only: ['index', 'show']
  resourcesDirective: (controllerName, opts = {}) =>
    includedActions = if opts.only?
      _.intersection @resourceActions, opts.only
    else
      @resourceActions
    mappings = @resourceMappings controllerName

    mappings[action]() for action in includedActions

  # Middleware to set reverse routes on req.locals
  setReverseRoutesOnReqLocals: (req, res, next) =>
    # Only set res.locals.paths if the paths option was not set
    res.locals.paths = @reversePaths if @options.paths is Exprestive.defaultOptions.paths
    next()


module.exports = Exprestive
