Promise = require 'bluebird'
async = Promise.coroutine
fsExtra = Promise.promisifyAll require 'fs-extra'
path = require 'path'
request = require 'request-promise'
url = require 'url'
{ fork } = require 'child_process'


class Helpers

  constructor: ->
    @exprestivePath = require.resolve "#{__dirname}/../../.."


  # Creates a new exprestive app in @appPath
  createExprestiveApp: async ({library, exprestiveOptions}) ->
    serverContents = """
      # Initialize exprestive application
      #{library} = require '#{library}'
      exprestive = require 'exprestive'
      app = #{library}()
      app.use exprestive(#{JSON.stringify exprestiveOptions})
      app.listen #{@port}

      # Error handler
      app.use (err, req, res, next) ->
        res.statusCode = 500
        res.end err.toString()

      # Send a message to parent to let it know the server started successfully
      process.send('server started')
      """
    yield @createFile 'server.coffee', serverContents


  # Writes a file in @appDir creating any missing directories along the way
  createFile: async (fileName, fileContents) ->
    filePath = path.join @appPath, fileName
    yield fsExtra.outputFileAsync filePath, fileContents


  initializeFiles: async ->
    routesContent = '''
      module.exports = ({GET}) ->
        GET '/eval/:strToEval', to: 'eval#index'
      '''

    controllerContent = '''
      module.exports = class EvalController
        index: (req, res) ->
          res.end Function('res', req.params.strToEval).call(@, res)
      '''

    yield Promise.all [
      @createFile 'routes.coffee', routesContent
      @createFile 'controllers/eval_controller.coffee', controllerContent
    ]


  # Symlinks connect and exprestive as node modules in @appPath
  symlinkModules: async ->
    items = [
      {name: 'connect', srcPath: require.resolve 'connect'}
      {name: 'express', srcPath: require.resolve 'express'}
      {name: 'exprestive', srcPath: @exprestivePath}
    ]
    yield Promise.map items, async ({name, srcPath}) =>
      destPath = path.join @appPath, 'node_modules', name
      yield fsExtra.ensureSymlinkAsync srcPath, destPath


  # Make an HTTP request to the running server
  makeRequest: async (method, urlPath) ->
    uri = url.format
      protocol: 'http:'
      hostname: 'localhost'
      port: @port
      pathname: urlPath

    yield request {method, uri, resolveWithFullResponse: yes, simple: false}


  # Starts up server.coffee in @appPath
  startApp: -> new Promise (resolve) =>
    child = fork "#{@appPath}/server.coffee"

    # Message emitted by process.send() in server.coffee after the server starts
    child.on 'message', (message) ->
      resolve() if message is 'server started'

    unexpectedExit = yes
    # After test are done kill the child
    @cleanUpActions.push ->
      unexpectedExit = no
      child.kill()

    # Throw an error if we didn't exit from the cleanUpAction
    child.on 'close', (err, signal) ->
      throw new Error('Child exited unsuccessfully') if unexpectedExit


module.exports = ->
  # Export the helper methods to the World
  @World = Helpers
