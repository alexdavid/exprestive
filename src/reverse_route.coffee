class ReverseRoute extends String

  constructor: ({@path, @method}) ->
    super @path


  toString: ->
    @path


module.exports = ReverseRoute
