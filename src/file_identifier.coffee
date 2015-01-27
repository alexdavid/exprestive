path = require 'path'


# A collection of methods to help identify what kind of file the passed file path is
class FileIdentifier

  constructor: (@filePath) ->


  exportsConstructor: ->
    typeof require(@filePath) is 'function'


  exportsName: ->
    typeof require(@filePath).name is 'string'


  # Returns whether the file is an Exprestive controller
  isController: ->
    @isJsFile() and @exportsName() and @exportsConstructor()


  isJsFile: ->
    extension = path.extname @filePath
    extension is '.coffee' or extension is '.js'


module.exports = FileIdentifier
