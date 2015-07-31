BaseController = require './base_controller'
callsite = require 'callsite'
Exprestive = require './exprestive'
path = require 'path'


middleware = (options) ->
  # Determine the __dirname of the file calling exprestive
  stack = callsite()
  baseDir = path.dirname stack[1].getFileName()

  new Exprestive(baseDir, options).middlewareRouter


middleware.BaseController = BaseController
middleware.Exprestive = Exprestive


module.exports = middleware
