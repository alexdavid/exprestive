camelCase = require 'camel-case'
glob = require 'glob'
path = require 'path'


# Initializes controllers in @controllersDir and supports calling saved controller actions
class ControllerInitializer

  constructor: ({@appDir, @controllersPattern, @dependencies}) ->
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


  # Populates @controllers by instantiating controllers found in @controllersDir
  initializeControllers: ->
    for fileName in glob.sync(@controllersPattern, cwd: @appDir)
      filePath = path.join @appDir, fileName
      Controller = require filePath
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
