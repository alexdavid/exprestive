Exprestive = require '../../src/exprestive'


describe 'Exprestive configuration', ->
  context 'initialized with no options', ->

    beforeEach ->
      @exprestive = new Exprestive '/base/dir'

    it 'sets the appDir to the baseDir', ->
      expect(@exprestive.appDir).to.equal '/base/dir'

    it 'sets the routesFilePath to baseDir + routes', ->
      expect(@exprestive.routesFilePath).to.equal '/base/dir/routes'

    it 'sets the controllersDirPath to baseDir + controllers', ->
      expect(@exprestive.controllersDirPath).to.equal '/base/dir/controllers'


  context 'initialized with a relative appDir', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir', appDir: './app/dir'

    it 'sets the appDir relative to the baseDir', ->
      expect(@exprestive.appDir).to.equal '/base/dir/app/dir'

    it 'sets the routesFilePath to baseDir + appDir routes', ->
      expect(@exprestive.routesFilePath).to.equal '/base/dir/app/dir/routes'

    it 'sets the controllersDirPath to baseDir + appDir + controllers', ->
      expect(@exprestive.controllersDirPath).to.equal '/base/dir/app/dir/controllers'


  context 'initialized with an absolute appDir', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir', appDir: '/app/dir'

    it 'sets the appDir', ->
      expect(@exprestive.appDir).to.equal '/app/dir'

    it 'sets the routesFilePath to appDir + routes', ->
      expect(@exprestive.routesFilePath).to.equal '/app/dir/routes'

    it 'sets the controllersDirPath to appDir + controllers', ->
      expect(@exprestive.controllersDirPath).to.equal '/app/dir/controllers'


  context 'initialized with a relative routesFilePath', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
        appDir: '/app/dir'
        routesFilePath: './routes/file/path'

    it 'sets the routesFilePath relative to appDir', ->
      expect(@exprestive.routesFilePath).to.equal '/app/dir/routes/file/path'


  context 'initialized with an absolute routesFilePath', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
        appDir: '/app/dir'
        routesFilePath: '/routes/file/path'

    it 'sets the routesFilePath', ->
      expect(@exprestive.routesFilePath).to.equal '/routes/file/path'


  context 'initialized with a relative controllersDirPath', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
        appDir: '/app/dir'
        controllersDirPath: './controllers/dir/path'

    it 'sets the controllersDirPath relative to appDir', ->
      expect(@exprestive.controllersDirPath).to.equal '/app/dir/controllers/dir/path'


  context 'initialized with an absolute controllersDirPath', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
        appDir: '/app/dir'
        controllersDirPath: '/controllers/dir/path'

    it 'sets the controllersDirPath', ->
      expect(@exprestive.controllersDirPath).to.equal '/controllers/dir/path'
