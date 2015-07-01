BaseController = require '../../src/base_controller'

class CustomController extends BaseController
  index: ->
  show: ->

describe 'BaseController', ->
  beforeEach ->
    @controller = new CustomController()


  describe '#getActions', ->
    context 'when called with no options', ->
      beforeEach ->
        @actions = @controller.getActions()

      it 'returns an array of the controller actions', ->
        expect(@actions).to.eql ['index', 'show']


    context 'when called with only option', ->
      beforeEach ->
        @actions = @controller.getActions only: 'index'

      it 'returns an array of only the specified controller actions', ->
        expect(@actions).to.eql ['index']


    context 'when called with except option', ->
      beforeEach ->
        @actions = @controller.getActions except: 'index'

      it 'returns an array of all but the specified controller actions', ->
        expect(@actions).to.eql ['show']


  describe '#useMiddleware', ->
    context 'when called with a middleware and no options', ->
      beforeEach ->
        @middleware = (req, res, next) -> next()
        @controller.useMiddleware @middleware

      it 'adds all controller actions to the controller middleware', ->
        expect(@controller.middleware.index).to.eql [@middleware]
        expect(@controller.middleware.show).to.eql [@middleware]


    context 'when called with a middleware and only option', ->
      beforeEach ->
        @middleware = (req, res, next) -> next()
        @controller.useMiddleware @middleware, only: 'index'

      it 'adds all controller actions to the controller middleware', ->
        expect(@controller.middleware.index).to.eql [@middleware]
        expect(@controller.middleware.show).to.be.undefined


    context 'when called with a middleware and except option', ->
      beforeEach ->
        @middleware = (req, res, next) -> next()
        @controller.useMiddleware @middleware, except: 'index'

      it 'adds all controller actions to the controller middleware', ->
        expect(@controller.middleware.index).to.be.undefined
        expect(@controller.middleware.show).to.eql [@middleware]
