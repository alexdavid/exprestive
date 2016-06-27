Promise = require 'bluebird'
portfinder = Promise.promisifyAll require 'portfinder'
tmp = Promise.promisifyAll require 'tmp'


module.exports = ->

  @Before (scenario) ->

    # An array of functions added by steps to be executed in the after block
    @cleanUpActions = []

    # Create a temp directory to run the feature tests in
    # unsafeCleanup tells tmp to delete the directory on process.exit even when its non-empty
    @appPath = yield tmp.dirAsync unsafeCleanup: yes
    @port = yield portfinder.getPortAsync()
    yield @initializeFiles()
    yield @symlinkModules()


  @After ->
    action() for action in @cleanUpActions
