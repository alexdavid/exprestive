camelCase = require 'camel-case'
FileIdentifier = require './file_identifier'
fs = require 'fs'
path = require 'path'


# Initializes controllers in @controllersDir and supports calling saved controller actions
class ControllerInitializer

  constructor: (@controllersDir, @dependencies) ->
    @controllers = {}
    @initialize()


  # Calls a controller action with args
  applyAction: ({controllerName, actionName, args}) ->
    @controllers[camelCase controllerName][actionName] args...


  # Populates @controllers by instantiating controllers found in @controllersDir
  initialize: ->
    for fileName in fs.readdirSync @controllersDir
      filePath = path.join @controllersDir, fileName
      continue unless new FileIdentifier(filePath).isController()
      Controller = require filePath
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller @dependencies


module.exports = ControllerInitializer
