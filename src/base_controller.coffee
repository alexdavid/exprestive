
# Offers a base controller to extend
class BaseController

  #helper for use in subclass constructors
  useMiddleware: (middleware, options={}) ->
    {only, except} = options
    actions = [].concat only if only?
    actions ?= @_actions()
    except ?= []
    except = [].concat except
    for action in actions when except.indexOf(action) < 0
      @middleware ?= {}
      @middleware[action] ?= []
      @middleware[action] = [].concat @middleware[action]
      @middleware[action].push middleware


  _actions: ->
    (action for action, _ of @ when action isnt 'useMiddleware' and action.indexOf('_') isnt 0)

module.exports = BaseController
