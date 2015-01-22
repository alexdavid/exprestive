camelCase = require 'camel-case'
FileIdentifier = require './file_identifier'
fs = require 'fs'
path = require 'path'


class ControllerStore

  constructor: (@controllersDir, @dependencies) ->
    @controllers = {}


  # Calls a controller action with args
  applyAction: ({controller, action, args}) ->
    @controllers[camelCase controller][action] args...


  # Populates @controllers by instantiating controllers found in @controllersDir
  initialize: ->
    for fileName in fs.readdirSync @controllersDir
      filePath = path.join @controllersDir, fileName
      continue unless new FileIdentifier(filePath).isController()
      Controller = require filePath
      controllerName = camelCase Controller.name.replace /Controller$/, ''
      @controllers[controllerName] = new Controller @dependencies


module.exports = ControllerStore
