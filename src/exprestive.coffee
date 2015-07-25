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
    controllersWhitelist: /^.+_controller\.(?:coffee|js)$/
    dependencies: {}


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
    @reverseRoutes = {}

    # Set res.locals.routes
    @middlewareRouter.use @setReverseRoutesOnReqLocals

    # Initialize controllers and routes
    routes = new RoutesInitializer routesFilePath, @reverseRoutes
    @controllers = new ControllerInitializer controllersDirPath, {
      dependencies: @options.dependencies
      @reverseRoutes
      whitelist: @options.controllersWhitelist
    }
    @addRoute route for route in routes.toArray()


  # Registers a route on @middlewareRouter
  addRoute: ({httpMethod, url, controllerName, actionName}) =>
    middleware = @controllers.middlewareFor {controllerName, actionName}
    @middlewareRouter[httpMethod.toLowerCase()] url, middleware..., (args...) =>
      @controllers.applyAction {controllerName, actionName, args}


  # Middleware to set reverse routes on req.locals
  setReverseRoutesOnReqLocals: (req, res, next) =>
    res.locals.routes = @reverseRoutes
    next()


module.exports = Exprestive
