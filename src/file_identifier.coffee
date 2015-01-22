path = require 'path'


class FileIdentifier

  constructor: (@filePath) ->


  exportsConstructor: ->
    typeof require(@filePath) is 'function'


  exportsName: ->
    {name} = require @filePath
    typeof name is 'string'


  # Returns whether the file is an Exprestive controller
  isController: ->
    @isJsFile() and @exportsName() and @exportsConstructor()


  isJsFile: ->
    extension = path.extname @filePath
    extension is '.coffee' or extension is '.js'


module.exports = FileIdentifier
