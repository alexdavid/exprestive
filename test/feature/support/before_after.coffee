async = require 'async'
portfinder = require 'portfinder'
tmp = require 'tmp'

module.exports = ->

  @Before (done) ->

    # An array of functions added by steps to be executed in the after block
    @cleanUpActions = []

    async.auto {
      # unsafeCleanup tells tmp to delete the directory on process.exit even when its non-empty
      appPath: (next) =>
        tmp.dir {unsafeCleanup: yes}, (err, @appPath) => next err

      port: (next) =>
        portfinder.getPort (err, @port) => next err

      controllersDirectory: ['appPath', (next) =>
        @createDirectory 'controllers', next
      ]
    }, done


  @After (done) ->
    action() for action in @cleanUpActions
    done()
