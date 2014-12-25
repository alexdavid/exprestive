Exprestive = require '../../exprestive'

describe 'Exprestive routes', ->
  describe '#initializeRoutes', ->
    beforeEach (done) ->
      @routes = sinon.spy (@methods) => done()
      exprestive = new Exprestive { @routes }
      exprestive.initializeRoutes()

    it 'calles the routes method', ->
      expect(@routes).to.have.been.calledOnce

    it 'passes a GET method', ->
      expect(@methods.GET).to.be.a 'function'

    it 'passes a POST method', ->
      expect(@methods.POST).to.be.a 'function'

    it 'passes a PUT method', ->
      expect(@methods.PUT).to.be.a 'function'

    it 'passes a DELETE method', ->
      expect(@methods.DELETE).to.be.a 'function'
