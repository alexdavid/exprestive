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
    controllersPattern: 'controllers/*controller.+([^.])'
    dependencies: {}


  constructor: (baseDir, @options = {}) ->

    # Merge given and default options
    _.defaults @options, Exprestive.defaultOptions

    # The directory where routes and controllers can be found
    # Used only as a relative directory for routesFilePath and controllersPattern
    @options.appDir = path.resolve baseDir, @options.appDir

    # Path to the routes file
    @options.routesFilePath = path.resolve @options.appDir, @options.routesFilePath

    # Router to register routes and pass to express as middleware
    @middlewareRouter = express.Router()

    # Save reverse routes
    @reverseRoutes = {}

    # Set res.locals.routes
    @middlewareRouter.use @setReverseRoutesOnReqLocals

    # Initialize controllers and routes
    routes = new RoutesInitializer @options.routesFilePath, @reverseRoutes
    @controllers = new ControllerInitializer _.extend {}, @options, {@reverseRoutes}
    @addRoute route for route in routes.toArray()


  # Registers a route on @middlewareRouter
  addRoute: ({httpMethod, url, controllerName, actionName}) =>
    middleware = @controllers.middlewareFor {controllerName, actionName}
    @middlewareRouter[httpMethod.toLowerCase()] url, middleware..., (args...) =>
      @controllers.applyAction {controllerName, actionName, args}


  # Middleware to set reverse routes on req.locals
  setReverseRoutesOnReqLocals: (req, res, next) =>
    res.locals.routes = @reverseRoutes if res.locals?
    next()


module.exports = Exprestive
