_ = require 'lodash'
ControllerInitializer = require './controller_initializer'
express = require 'express'
path = require 'path'
RoutesInitializer = require './routes_initializer'


class Exprestive

  # Default options
  @defaultOptions =
    appDir: ''
    routesFilePath: 'routes'
    controllersDirPath: 'controllers'
    dependencies: {}
    routes: {}


  constructor: (baseDir, @options = {}) ->

    # Merge given and default options
    _.defaults @options, Exprestive.defaultOptions

    # The directory where routes and controllers can be found
    # Used only as a relative directory for @routesFilePath and @controllersDirPath
    appDir = path.resolve baseDir, @options.appDir

    # Path to the routes file
    routesFilePath = path.resolve appDir, @options.routesFilePath

    # Path to the directory to look for controllers
    controllersDirPath = path.resolve appDir, @options.controllersDirPath

    # Router to register routes and pass to express as middleware
    @middlewareRouter = express.Router()

    # Save reverse routes
    @reverseRoutes = @options.routes

    # Initialize controllers and routes
    @controllers = new ControllerInitializer controllersDirPath, @options.dependencies
    {routes} = new RoutesInitializer routesFilePath, @reverseRoutes
    @addRoute route for route in routes

    # Set res.locals.routes if the routes option was not set
    @middlewareRouter.use @setReverseRoutesOnReqLocals if @optionIsDefault 'routes'


  # Registers a route on @middlewareRouter
  addRoute: ({httpMethod, url, controllerName, actionName}) =>
    @middlewareRouter[httpMethod.toLowerCase()] url, (args...) =>
      @controllers.applyAction {controllerName, actionName, args}


  # Reterns true if the passed option is its default value
  optionIsDefault: (optionName) ->
    @options[optionName] is Exprestive.defaultOptions[optionName]


  # Middleware to set reverse routes on req.locals
  setReverseRoutesOnReqLocals: (req, res, next) =>
    res.locals.routes = @reverseRoutes
    next()


module.exports = Exprestive
