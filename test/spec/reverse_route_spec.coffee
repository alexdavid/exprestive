ReverseRoute = require '../../src/reverse_route'


describe 'ReverseRoute', ->

  beforeEach ->
    @route = new ReverseRoute
      path: '/some/path'
      method: 'GET'

  it 'exposes the URL path for this route through "path"', ->
    expect(@route.path).to.equal '/some/path'

  it 'exposes the URL method for this route through "method"', ->
    expect(@route.method).to.equal 'GET'

  it 'exposes the URL path for this route through "toString"', ->
    expect(@route.toString()).to.equal '/some/path'

  it 'exposes the URL path for this route through "valueOf"', ->
    expect(@route.valueOf()).to.equal '/some/path'
