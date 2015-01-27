camelCase = require 'camel-case'
fs = require 'fs'
path = require 'path'


# Initializes controllers in @controllersDir and supports calling saved controller actions
class ControllerInitializer

  constructor: (@controllersDir, {@dependencies, @controllersMatch}) ->
    @controllers = {}
    @initializeControllers()


  # Calls a controller action with args
  applyAction: ({controllerName, actionName, args}) ->
    @controllers[camelCase controllerName][actionName] args...


  # Populates @controllers by instantiating controllers found in @controllersDir
  initializeControllers: ->
    for fileName in fs.readdirSync @controllersDir
      filePath = path.join @controllersDir, fileName
      continue unless filePath.match @controllersMatch
      Controller = require filePath
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller @dependencies


module.exports = ControllerInitializer
