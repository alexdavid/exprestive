ReverseRoute = require '../../src/reverse_route'


describe 'ReverseRoute', ->

  beforeEach ->
    @route = new ReverseRoute
      path: '/some/path'
      method: 'GET'

  it 'exposes path', ->
    expect(@route.path).to.equal '/some/path'

  it 'exposes method', ->
    expect(@route.method).to.equal 'GET'


  describe 'behaves like a string', ->

    it 'has a toString method', ->
      expect(@route.toString()).to.equal '/some/path'

    it 'has a valueOf method', ->
      expect(@route.valueOf()).to.equal '/some/path'

    it 'has an indexOf method', ->
      expect(@route.indexOf 'p').to.equal 6

    it 'has a match method', ->
      expect(@route.match(/.+/)[0]).to.equal '/some/path'

    it 'has a length parameter', ->
      expect(@route.length).to.equal 10

    it 'allows accessing single characters', ->
      expect(@route[1]).to.equal 's'

    it 'allows slicing', ->
      expect(@route[5..9]).to.equal '/path'
