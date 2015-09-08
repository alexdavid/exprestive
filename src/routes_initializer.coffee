_ = require 'lodash'
camelCase = require 'camel-case'
{pluralize, singularize} = require 'inflection'
URLFormatter = require './url_formatter'


# Constants:

# Http methods to be passed to the route file function
HTTP_METHODS = ['GET', 'POST', 'PUT', 'DELETE']

# Full list of resource action names. It is important that 'new' precede 'show'
RESOURCE_ACTIONS = ['index', 'new', 'show', 'edit', 'update', 'create', 'destroy']


class RoutesInitializer

  constructor: (@routesFile, @reverseRoutes) ->
    @_routes = []
    @_scope = []
    require(@routesFile) @getRouteDirectives()


  # Returns a route directive for a specific http method to be called in a routes file
  getHttpDirective: (httpMethod) ->
    (url, {to, as}) =>
      url = @_normalizeUrl "#{@_scope.join '/'}/#{url}"
      [controllerName, actionName] = to.split '#'
      @_routes.push {httpMethod, url, controllerName, actionName}
      @registerReverseRoute {routeName: as, httpMethod, url} if as?


  # Returns the object of directives passed to the routes file function
  getRouteDirectives: ->
    directives =
      resources: @resourcesDirective
      scope:     @scopeDirective
    for httpMethod in HTTP_METHODS
      directives[httpMethod] = @getHttpDirective httpMethod
    directives


  # Save a function to @reverseRoutes to get a url back from a route name
  registerReverseRoute: ({routeName, httpMethod, url}) ->
    formatter = new URLFormatter url
    @reverseRoutes[routeName] = ->
      formatter.getRoute httpMethod, arguments


  # Returns an object mapping each resource route name to a function which binds the route
  resourceMappings: (controllerName) ->
    {GET, POST, PUT, DELETE} = @getRouteDirectives()
    singularName = singularize controllerName
    pluralName = pluralize controllerName

    index:   -> GET "/#{controllerName}",          to: "#{controllerName}#index",   as: pluralName
    new:     -> GET "/#{controllerName}/new",      to: "#{controllerName}#new",     as: camelCase "new_#{singularName}"
    show:    -> GET "/#{controllerName}/:id",      to: "#{controllerName}#show",    as: singularName
    edit:    -> GET "/#{controllerName}/:id/edit", to: "#{controllerName}#edit",    as: camelCase "edit_#{singularName}"
    update:  -> PUT "/#{controllerName}/:id",      to: "#{controllerName}#update",  as: camelCase "update_#{singularName}"
    create:  -> POST   "/#{controllerName}",       to: "#{controllerName}#create",  as: camelCase "create_#{singularName}"
    destroy: -> DELETE "/#{controllerName}/:id",   to: "#{controllerName}#destroy", as: camelCase "destroy_#{singularName}"


  # A helper method for automatically binding restful controllers in a routes file
  # This is passed as "resources" to the routes file function parameter hash
  # Routes can be filtered with the 'except:' or 'only:' option.
  # E.g. resources 'users', only: ['index', 'show']
  resourcesDirective: (controllerName, {except, only} = {}) =>
    includedActions = if except?
      _.difference RESOURCE_ACTIONS, except
    else if only?
      _.intersection RESOURCE_ACTIONS, only
    else
      RESOURCE_ACTIONS

    mappings = @resourceMappings controllerName
    mappings[action]() for action in includedActions


  # Adjust the current scope for scoped routes
  scopeDirective: (scopeName, scopedRoutes) =>
    @_scope.push scopeName
    scopedRoutes()
    @_scope.pop scopeName


  toArray: -> @_routes

  _normalizeUrl: (path) ->
    "/#{_.compact(path.split('/')).join('/')}"


module.exports = RoutesInitializer
