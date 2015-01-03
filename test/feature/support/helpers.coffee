fs = require 'fs'
mkdirp = require 'mkdirp'
path = require 'path'
request = require 'request'
url = require 'url'
{ fork } = require 'child_process'


class Helpers

  # Creates a controller in @appDir with the passed actions
  createController: (controllerName, fileName, actions, done) ->
    fileContents = [
      "class #{controllerName}Controller"
      ("  #{ACTION}: (_, res) -> res.end('#{RESPONSE}')" for {ACTION, RESPONSE} in actions)...
      "module.exports = #{controllerName}Controller"
    ].join '\n'
    @createFile fileName, fileContents, done


  # Creates a new exprestive app in @appPath
  createExprestiveApp: (optionsStr, done) ->
    exprestivePath = require.resolve "#{__dirname}/../../.."
    fileContents = """
      # Initialize exprestive application
      express = require '#{require.resolve 'express'}'
      exprestive = require '#{exprestivePath}'
      app = express()
      app.use exprestive(#{optionsStr})
      app.listen #{@port}

      # Send a message to parent to let it know the server started successfully
      process.send('server started')
    """
    @createFile 'server.coffee', fileContents, done


  # Writes a file in @appDir creating any missing directories along the way
  createFile: (fileName, fileContents, done) ->
    filePath = path.join @appPath, fileName
    dirName = path.dirname filePath
    mkdirp dirName, (err) ->
      done err if err
      fs.writeFile filePath, fileContents, done


  # Creates a routes file in @appDir with the passed routes
  createRoutesFile: (fileName, routes, done) ->
    fileContents = [
      "module.exports = ({ GET, POST, PUT, DELETE }) ->"
      ("  #{METHOD} '#{ROUTE}', to: '#{TO}'" for {METHOD, ROUTE, TO} in routes)...
    ].join '\n'
    @createFile fileName, fileContents, done


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

    # After test are done kill the child
    @cleanUpActions.push -> child.kill()


module.exports = ->
  # Export the helper methods to the World
  @World = (done) ->
    done new Helpers
