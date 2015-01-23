Exprestive = require '../../src/exprestive'


xdescribe 'Exprestive configuration', ->
  context 'initialized with no options', ->

    beforeEach ->
      @exprestive = new Exprestive '/base/dir'

    it 'uses the default application directory', ->
      expect(@exprestive.appDir).to.equal '/base/dir'

    it 'uses the default routes directory', ->
      expect(@exprestive.routesFilePath).to.equal '/base/dir/routes'

    it 'uses the default controller directory', ->
      expect(@exprestive.controllersDirPath).to.equal '/base/dir/controllers'


  context 'custom relative application directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir', appDir: './app/dir'

    it 'uses the given application directory relative to the base directory', ->
      expect(@exprestive.appDir).to.equal '/base/dir/app/dir'

    it 'uses the routes directory inside the given application directory', ->
      expect(@exprestive.routesFilePath).to.equal '/base/dir/app/dir/routes'

    it 'uses the controllers directory inside the given application directory', ->
      expect(@exprestive.controllersDirPath).to.equal '/base/dir/app/dir/controllers'


  context 'custom absolute application directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir', appDir: '/app/dir'

    it 'uses the given application directory directly', ->
      expect(@exprestive.appDir).to.equal '/app/dir'

    it 'uses the routes directory inside the given application directory', ->
      expect(@exprestive.routesFilePath).to.equal '/app/dir/routes'

    it 'uses the controllers directory inside the given application directory', ->
      expect(@exprestive.controllersDirPath).to.equal '/app/dir/controllers'


  context 'custom relative routes path', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
                                   appDir: '/app/dir'
                                   routesFilePath: './routes/file/path'

    it 'uses the routes directory relative to the application directory', ->
      expect(@exprestive.routesFilePath).to.equal '/app/dir/routes/file/path'


  context 'custom absolute routes directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
                                   appDir: '/app/dir'
                                   routesFilePath: '/routes/file/path'

    it 'uses the given routes directory directly', ->
      expect(@exprestive.routesFilePath).to.equal '/routes/file/path'


  context 'custom relative controllers directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
                                   appDir: '/app/dir'
                                   controllersDirPath: './controllers/dir/path'

    it 'uses the controllers directory relative to the application directory', ->
      expect(@exprestive.controllersDirPath).to.equal '/app/dir/controllers/dir/path'


  context 'absolute controllers directory', ->
    beforeEach ->
      @exprestive = new Exprestive '/base/dir',
                                   appDir: '/app/dir'
                                   controllersDirPath: '/controllers/dir/path'

    it 'uses the given controllers directory directly', ->
      expect(@exprestive.controllersDirPath).to.equal '/controllers/dir/path'
