Exprestive = require '../../lib/exprestive'

describe 'Exprestive configuration', ->
  context 'initialized with no options', ->
    beforeEach ->
      @exprestive = new Exprestive

    it 'sets the appDir to the dirname of the calling file', ->
      expect(@exprestive.appDir).to.equal __dirname

    it 'sets the routesFilePath to appDir + routes', ->
      expect(@exprestive.routesFilePath).to.equal __dirname + '/routes'

    it 'sets the controllersDirPath to appDir + controllers', ->
      expect(@exprestive.controllersDirPath).to.equal __dirname + '/controllers'


  context 'initialized with a relative appDir', ->
    beforeEach ->
      @exprestive = new Exprestive appDir: './foo/bar'

    it 'sets the appDir relative to the dirname of the calling file', ->
      expect(@exprestive.appDir).to.equal __dirname + '/foo/bar'

    it 'sets the routesFilePath to appDir + routes', ->
      expect(@exprestive.routesFilePath).to.equal __dirname + '/foo/bar/routes'

    it 'sets the controllersDirPath to appDir + controllers', ->
      expect(@exprestive.controllersDirPath).to.equal __dirname + '/foo/bar/controllers'


  context 'initialized with an absolute appDir', ->
    beforeEach ->
      @exprestive = new Exprestive appDir: '/foo/bar'

    it 'sets the appDir', ->
      expect(@exprestive.appDir).to.equal '/foo/bar'

    it 'sets the routesFilePath to appDir + routes', ->
      expect(@exprestive.routesFilePath).to.equal '/foo/bar/routes'

    it 'sets the controllersDirPath to appDir + controllers', ->
      expect(@exprestive.controllersDirPath).to.equal '/foo/bar/controllers'


  context 'initialized with a relative routesFilePath', ->
    beforeEach ->
      @exprestive = new Exprestive
        appDir: '/app/dir'
        routesFilePath: './routes/file/path'

    it 'sets the routesFilePath relative to appDir', ->
      expect(@exprestive.routesFilePath).to.equal '/app/dir/routes/file/path'


  context 'initialized with an absolute routesFilePath', ->
    beforeEach ->
      @exprestive = new Exprestive
        appDir: '/app/dir'
        routesFilePath: '/routes/file/path'

    it 'sets the routesFilePath', ->
      expect(@exprestive.routesFilePath).to.equal '/routes/file/path'


  context 'initialized with a relative controllersDirPath', ->
    beforeEach ->
      @exprestive = new Exprestive
        appDir: '/app/dir'
        controllersDirPath: './controllers/dir/path'

    it 'sets the controllersDirPath relative to appDir', ->
      expect(@exprestive.controllersDirPath).to.equal '/app/dir/controllers/dir/path'


  context 'initialized with an absolute controllersDirPath', ->
    beforeEach ->
      @exprestive = new Exprestive
        appDir: '/app/dir'
        controllersDirPath: '/controllers/dir/path'

    it 'sets the controllersDirPath', ->
      expect(@exprestive.controllersDirPath).to.equal '/controllers/dir/path'
