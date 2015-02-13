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

  it 'has a toString method', ->
    expect(@route.toString()).to.equal '/some/path'

  it 'has a valueOf method', ->
    expect(@route.valueOf()).to.equal '/some/path'
