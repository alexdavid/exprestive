Exprestive = require '../../src/exprestive'

describe 'Exprestive routes', ->
  describe '#initializeRoutes', ->
    beforeEach (done) ->
      @routes = sinon.spy (@methods) => done()
      exprestive = new Exprestive '/base/dir', { @routes }
      exprestive.initializeRoutes()

    it 'calls the routes method', ->
      expect(@routes).to.have.been.calledOnce

    it 'passes a GET method', ->
      expect(@methods.GET).to.be.a 'function'

    it 'passes a POST method', ->
      expect(@methods.POST).to.be.a 'function'

    it 'passes a PUT method', ->
      expect(@methods.PUT).to.be.a 'function'

    it 'passes a DELETE method', ->
      expect(@methods.DELETE).to.be.a 'function'

    it 'passes a resource method', ->
      expect(@methods.resources).to.be.a 'function'


  describe '#registerReverseRoute', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir'
      @exprestive.registerReverseRoute
        routeName: 'userPost'
        url: '/users/:userId/posts/:id'

    context 'calling reversePaths.userPost with positional arguments', ->
      beforeEach ->
        @result1 = @exprestive.reversePaths.userPost 1, 2
        @result2 = @exprestive.reversePaths.userPost 3, 4

      it 'replaces parameters in the url with each argument', ->
        expect(@result1).to.equal '/users/1/posts/2'

      it 'does not override the url on subsequent calls', ->
        expect(@result2).to.equal '/users/3/posts/4'

    context 'calling reversePaths.userPost with an object', ->
      beforeEach ->
        @result1 = @exprestive.reversePaths.userPost userId: 2, id: 3
        @result2 = @exprestive.reversePaths.userPost userId: 4, id: 5

      it 'replaces parameters in the url with each argument', ->
        expect(@result1).to.equal '/users/2/posts/3'

      it 'does not override the url on subsequent calls', ->
        expect(@result2).to.equal '/users/4/posts/5'
