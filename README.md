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


## Tests
* Run unit tests with `npm run unit-tests`
* Run feature tests with `npm run feature-tests`
