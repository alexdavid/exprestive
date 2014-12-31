expRESTive [![Build Status](https://travis-ci.org/alexdavid/exprestive.svg)](https://travis-ci.org/alexdavid/exprestive) [![Dependency Status](https://david-dm.org/alexdavid/exprestive.png)](https://david-dm.org/alexdavid/exprestive)
==========

Expressive RESTful express router

## Basic usage
* Create an express application with exprestive middleware
```coffeescript
# server.coffee
express = require 'express'
exprestive = require 'exprestive'

app = express()
app.use exprestive()

app.listen 3000
```

* Create a `routes.coffee` file in the same directory as your server
```coffeescript
# routes.coffee
module.exports = ({ GET, POST, PUT, DELETE }) ->
  GET '/hello',   to: 'helloWorld#index'
```

* Create a `controllers/` directory in the same directory as your server
* Populate with controllers. File names don't matter controller names are taken from the class name
```coffeescript
# controllers/hello_world.coffee
class HelloWorldController
  index: (req, res) ->
    res.end 'hello world'
    
module.exports = WelcomeController
```
* Visit `/hello` in your browser


## Options
Options can be passed in to the exprestive function
```coffeescript
app = express()
app.use exprestive
  appDir: __dirname
```

| Option                 | Description                                                                                                       | Default Value                         |
|------------------------|-------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| **appDir**             | Directory used as a base directory for routes file and controllers directory                                      | `__dirname`                           |
| **routesFilePath**     | File to be required to define routes. This is passed to `require`, so extension is optional                       | **appDir**&nbsp;+&nbsp;`/routes`      |
| **controllersDirPath** | Directory in which to look for controllers. All files in this directory will be automatically required            | **appDir**&nbsp;+&nbsp;`/controllers` |
| **controllers**        | Pass in an object of instantiated controllers instead of requiring controller classes from **controllersDirPath** | `undefined`                           |
| **routes**             | Pass in a routes function instead of requiring **routesFilePath**                                                 | `undefined`                           |

## Tests
* Run unit tests with `npm run unit-tests`
* Run feature tests with `npm run feature-tests`
