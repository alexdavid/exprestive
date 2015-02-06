class ReverseRoute

  constructor: ({@path, @method}) ->
    @length = @path.length

    # Enable single character access
    @[i] = character for character, i in @path


  # Forward String methods
  indexOf: -> @path.indexOf arguments...

  match: -> @path.match arguments...

  slice: -> @path.slice arguments...

  toString: -> @path

  valueOf: -> @path


module.exports = ReverseRoute
