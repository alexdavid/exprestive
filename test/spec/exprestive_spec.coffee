rewire = require 'rewire'
ControllerInitializerMock = require '../mocks/controller_initializer_mock'
Exprestive = rewire '../../src/exprestive'
RoutesInitializerMock = require '../mocks/routes_initializer_mock'


describe 'Exprestive configuration', ->

  beforeEach ->
    @ControllerInitializerMock = sinon.spy ControllerInitializerMock
    @RoutesInitializerMock = sinon.spy RoutesInitializerMock
    Exprestive.__set__ 'ControllerInitializer', @ControllerInitializerMock
    Exprestive.__set__ 'RoutesInitializer', @RoutesInitializerMock


  context 'initialized with no options', ->

    beforeEach ->
      @exprestive = new Exprestive '/base/dir'

    it 'uses the default routes directory', ->
      expect(@RoutesInitializerMock).to.have.been.calledWith '/base/dir/routes'

    it 'uses the default controller directory', ->
      expect(@ControllerInitializerMock).to.have.been.calledWith sinon.match
        appDir: '/base/dir'
        controllersPattern: 'controllers/*_controller.{coffee,js}'
        dependencies: {}


  context 'custom relative application directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir', appDir: './app/dir'

    it 'uses the routes directory inside the given application directory', ->
      expect(@RoutesInitializerMock).to.have.been.calledWith '/base/dir/app/dir/routes'

    it 'uses the controllers directory inside the given application directory', ->
      expect(@ControllerInitializerMock).to.have.been.calledWith = sinon.match
        appDir: '/base/dir/app/dir'
        controllersPattern: 'controllers/*_controller.{coffee,js}'
        dependencies: {}


  context 'custom absolute application directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir', appDir: '/app/dir'

    it 'uses the routes directory inside the given application directory', ->
      expect(@RoutesInitializerMock).to.have.been.calledWith '/app/dir/routes'

    it 'uses the controllers directory inside the given application directory', ->
      expect(@ControllerInitializerMock).to.have.been.calledWith sinon.match
        appDir: '/app/dir'
        controllersPattern: 'controllers/*_controller.{coffee,js}'
        dependencies: {}


  context 'custom relative routes path', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
                                   appDir: '/app/dir'
                                   routesFilePath: './routes/file/path'

    it 'uses the routes directory relative to the application directory', ->
      expect(@RoutesInitializerMock).to.have.been.calledWith '/app/dir/routes/file/path'


  context 'custom absolute routes directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
                                   appDir: '/app/dir'
                                   routesFilePath: '/routes/file/path'

    it 'uses the given routes directory directly', ->
      expect(@RoutesInitializerMock).to.have.been.calledWith '/routes/file/path'


  context 'custom controllers pattern', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir', controllersPattern: 'my_controllers/*_controller.coffee'

    it 'uses the controllers directory relative to the application directory', ->
      expect(@ControllerInitializerMock).to.have.been.calledWith sinon.match
        appDir: '/base/dir'
        controllersPattern: 'my_controllers/*_controller.coffee'
        dependencies: {}
