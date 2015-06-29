ReverseRoute = require './reverse_route'


class URLFormatter

  constructor: (@template) ->


  replaceParams: (params...) ->
    url = @template
    if typeof params[0] is 'object'
      url = url.replace ":#{name}", value for name, value of params[0]
    else
      url = (url.replace /// :[^/]+ ///, param) for param in params
    url


  getRoute: (httpMethod, params) =>
    new ReverseRoute
      path: @replaceParams(params...)
      method: httpMethod


module.exports = URLFormatter
