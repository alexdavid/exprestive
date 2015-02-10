camelCase = require 'camel-case'
fs = require 'fs'
path = require 'path'


# Initializes controllers in @controllersDir and supports calling saved controller actions
class ControllerInitializer

  constructor: (@controllersDir, {@dependencies, @controllersWhitelist}) ->
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
    for fileName in fs.readdirSync @controllersDir
      continue unless fileName.match @controllersWhitelist
      filePath = path.join @controllersDir, fileName
      Controller = require filePath
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller @dependencies


module.exports = ControllerInitializer
