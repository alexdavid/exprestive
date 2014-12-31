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
      expect(@methods.resource).to.be.a 'function'
