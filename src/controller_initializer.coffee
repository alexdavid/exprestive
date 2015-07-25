camelCase = require 'camel-case'
fs = require 'fs'
path = require 'path'


# Initializes controllers in @dirPath and supports calling saved controller actions
class ControllerInitializer

  constructor: (@dirPath, {@dependencies, @reverseRoutes, @whitelist}) ->
    @controllers = {}
    @initializeControllers()


  # Calls a controller action with args
  applyAction: ({controllerName, actionName, args: [req, res, next]}) ->
    controller = @controllers[camelCase controllerName]
    unless controller
      return next "Missing '#{controllerName}' controller"

    if typeof controller[actionName] isnt 'function'
      return next "Missing '#{actionName}' action in '#{controllerName}' controller"

    controller[actionName] req, res, next


  # Populates @controllers by instantiating controllers found in @dirPath
  initializeControllers: ->
    for fileName in fs.readdirSync @dirPath
      continue unless fileName.match @whitelist
      filePath = path.join @dirPath, fileName
      Controller = require filePath
      Controller::routes = @reverseRoutes
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller @dependencies


  # Finds any middleware defined for the controller action
  middlewareFor: ({controllerName, actionName}) ->
    controller = @controllers[camelCase controllerName]
    return [] unless controller?
    return [] unless typeof controller[actionName] is 'function'
    return [] unless controller.middleware?[actionName]?
    [].concat controller.middleware[actionName]


module.exports = ControllerInitializer
