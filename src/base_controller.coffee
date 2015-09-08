
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
    for action of this
      continue if BaseController::[action]?
      continue if action.indexOf('_') is 0
      continue unless action in only or only.length is 0
      continue if action in except
      action


module.exports = BaseController
