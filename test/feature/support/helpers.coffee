async = require 'async'
fs = require 'fs'
mkdirp = require 'mkdirp'
path = require 'path'
request = require 'request'
url = require 'url'
{ fork } = require 'child_process'


class Helpers

  constructor: ->
    @exprestivePath = require.resolve "#{__dirname}/../../.."


  # Creates a new exprestive app in @appPath
  createExprestiveApp: (optionsStr, done) ->
    routesContent = '''
      module.exports = ({GET}) ->
        GET '/eval/:strToEval', to: 'root#eval'
      '''

    controllerContent = '''
      module.exports = class RootController
        eval: (req, res) ->
          res.end Function('req', 'res', req.params.strToEval).apply(@, req, res)
      '''

    serverContents = """
      # Initialize exprestive application
      express = require 'express'
      exprestive = require 'exprestive'
      app = express()
      app.use exprestive(#{optionsStr})
      app.listen #{@port}

      # Error handler
      app.use (err, req, res, next) ->
        res.status(500).end err.toString()

      # Send a message to parent to let it know the server started successfully
      process.send('server started')
    """

    async.parallel [
      (next) => @createFile 'routes.coffee', routesContent, next
      (next) => @createFile 'controllers/root_controller.coffee', controllerContent, next
      (next) => @createFile 'server.coffee', serverContents, next
    ], done


  createDirectory: (directoryName, done) ->
    mkdirp path.join(@appPath, directoryName), done


  # Writes a file in @appDir creating any missing directories along the way
  createFile: (fileName, fileContents, done) ->
    filePath = path.join @appPath, fileName
    dirName = path.dirname filePath
    mkdirp dirName, (err) ->
      done err if err
      fs.writeFile filePath, fileContents, done


  # Symlinks express and exprestive as node modules in @appPath
  symlinkModules: (done) ->
    @createDirectory 'node_modules', (err) =>
      return done err if err
      items = [
        {name: 'express', srcPath: require.resolve 'express'}
        {name: 'exprestive', srcPath: @exprestivePath}
      ]
      iterator = ({name, srcPath}, next) =>
        destPath = path.join @appPath, 'node_modules', name
        fs.symlink srcPath, destPath, next
      async.each items, iterator, done


  # Make an HTTP request to the running server
  makeRequest: (method, urlPath, done) ->
    uri = url.format
      protocol: 'http:'
      hostname: 'localhost'
      port: @port
      pathname: urlPath

    request {method, uri}, done


  # Starts up server.coffee in @appPath
  startApp: (done) ->
    child = fork "#{@appPath}/server.coffee"

    # Message emitted by process.send() in server.coffee after the server starts
    child.on 'message', (message) ->
      done() if message is 'server started'

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
  @World = (done) ->
    done new Helpers
