callsite = require 'callsite'
Exprestive = require './exprestive'
path = require 'path'


module.exports = (options) ->
  # Determine the __dirname of the file calling exprestive
  stack = callsite()
  baseDir = path.dirname stack[1].getFileName()

  exprestive = new Exprestive baseDir, options
  return exprestive.getMiddleware()
