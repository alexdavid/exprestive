portfinder = require 'portfinder'
tmp = require 'tmp'

module.exports = ->

  @Before (done) ->

    # An array of functions added by steps to be executed in the after block
    @cleanUpActions = []

    # Create a temp directory to run the feature tests in
    # unsafeCleanup tells tmp to delete the directory on process.exit even when its non-empty
    tmp.dir {unsafeCleanup: yes}, (err, @appPath) =>
      return done err if err
      portfinder.getPort (err, @port) =>
        return done err if err
        @createDirectory 'controllers', (err) =>
          return done err if err
          @linkModules done


  @After (done) ->
    action() for action in @cleanUpActions
    done()
