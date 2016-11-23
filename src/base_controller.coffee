
# Offers a base controller to extend
class BaseController

  # helper for use in subclass constructors
  useMiddleware: (middleware, options = {}) ->
    for action in @getActions options
      @middleware ?= {}
      @middleware[action] ?= []
      @middleware[action] = [].concat @middleware[action], middleware


  # helper to get a list of all actions on the controller
  getActions: ({only, except} = {}) ->
    only = [].concat only ? []
    except = [].concat except ? []
    for action in Object.getOwnPropertyNames @constructor.prototype
      continue if typeof @constructor::[action] isnt 'function'
      continue if action is 'constructor'
      continue if action.indexOf('_') is 0
      continue if only.length > 0 and action not in only
      continue if action in except
      action


module.exports = BaseController
