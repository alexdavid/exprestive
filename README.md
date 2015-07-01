expRESTive [![Build Status](https://img.shields.io/circleci/project/alexdavid/exprestive/master.svg)](https://circleci.com/gh/alexdavid/exprestive) [![Dependency Status](https://img.shields.io/david/alexdavid/exprestive.svg)](https://david-dm.org/alexdavid/exprestive)
==========

A RESTful routing middleware for [Express.js](http://expressjs.com).


## Basic usage
Assuming you have already created an [Express](http://expressjs.com/) application
by following the [Express installation instructions](http://expressjs.com/starter/installing.html).
Now:

* add expRESTive to your _package.json_ file: `$ npm install --save exprestive`
* add the expRESTive middleware to your application

    ```coffeescript
    express = require 'express'
    exprestive = require 'exprestive'

    app = express()
    app.use exprestive()

    app.listen 3000
    ```

* create a `routes.coffee` file in the same directory as your server

  ```coffeescript
  module.exports = ({ GET, POST, PUT, DELETE }) ->
    GET '/hello',   to: 'helloWorld#index'
  ```

* create a `controllers/` directory in the same directory as your server and populate it with controllers.
  Controller file names must end in `_controller.coffee` or `_controller.js`. This restriction can be changed with the **controllersWhitelist** option. See [options](#options).

  ```coffeescript
  # controllers/hello_world_controller.coffee
  class HelloWorldController
    index: (req, res) ->
      res.end 'hello world'

  module.exports = HelloWorldController
  ```
* visit `/hello` in your browser


## Reverse routing
Exprestive exports url building functions to a `routes` object. By default it is saved to `res.locals.routes` for easy access from views.

### Saving / accessing reverse routes
In your routes file you can pass an `as` parameter to non-restful routes to define a reverse route.
```coffeescript
# routes.coffee
module.exports = ({GET}) ->
  GET '/foo/bar', to: 'foo#bar', as: 'foobar'
```

In a controller you can access this path with `res.locals.routes.foobar()`
```coffeescript
# controllers/foo.coffee
class FooController
  bar: (req, res) ->
    res.locals.routes.foobar() # returns "/foo/bar"
```

In a view you can access this path with `routes.foobar()`
```jade
//- index.jade
a(href=routes.foobar()) Visit foobar
```


### Parameters

If a route has parameters, the reverse route can take the parameters in order as arguments or as an object

````coffeescript
# routes.coffee
module.exports = ({GET}) ->
  GET '/users/:userId/posts/:id', to: 'posts#show', as: 'userPost'

# controllers/posts.coffee
class PostsController
  show: (req, res) ->
    res.locals.routes.userPost(1, 2)             # returns "/users/1/posts/2"
    res.locals.routes.userPost(userId: 1, id: 2) # returns "/users/1/posts/2"
```


### Custom routes
Setting `options.routes` will cause reverse routes to be exported to the passed object instead of `res.locals.routes`
For example you can set `options.routes` to a global variable to access routes the same from everywhere.

```coffeescript
global.routes = {}
app.use exprestive routes: global.routes

# Now routes.foobar() returns "/foo/bar" from anywhere in your application
```


## Restful routing
The `resources` helper can be used to build all the standard RESTFUL routes
```coffeescript
# routes.coffee
module.exports = ({resources}) ->
  resources 'users'
```

is equivalent to
```coffeescript
# routes.coffee
module.exports = ({DELETE, GET, POST, PUT}) ->
  GET    '/users',          to: 'user#index',   as: 'users'
  GET    '/users/new',      to: 'user#new',     as: 'newUser'
  GET    '/users/:id',      to: 'user#show',    as: 'user'
  GET    '/users/:id/edit', to: 'user#edit',    as: 'editUser'
  PUT    '/users/:id',      to: 'user#update',  as: 'updateUser'
  POST   '/users',          to: 'user#create',  as: 'createUser'
  DELETE '/users/:id',      to: 'user#destroy', as: 'destroyUser'
```

You can limit the restful routing with the options `except:` or `only:`
```coffeescript
# routes.coffee
module.exports = ({resources}) ->
  resources 'users', only: ['index', 'new', 'create', 'destroy']
  resources 'posts', except: ['index']
```

## Scoped routing
The `scope` helper can be used to create a prefixed set of routes:
```coffeescript
# routes.coffee
module.exports = ({GET, scope}) ->
  scope '/api', ->
    GET '/users', to: 'users#index'
    GET '/widgets', to: 'widgets#index'
```

This is equivalent to:
```coffeescript
# routes.coffee
module.exports = ({GET}) ->
  GET '/api/users', to: 'users#index'
  GET '/api/widgets', to: 'widgets#index'
```

Scopes can also be nested:
```coffeescript
# routes.coffee
module.exports = ({GET, resources, scope}) ->
  scope '/api', ->
    scope '/v1', ->
      resources 'users'
      GET '/widgets', to: 'widgets#index'
```

## Middleware Support

Adding per-route middleware can be done in the controller
by using the `middleware` property.

```coffeescript
# controllers/hello_world_controller.coffee
someMiddleware = require 'some-middleware'

class HelloWorldController
  middleware:
    index: someMiddleware

  index: (req, res) ->
    res.end 'hello world'

module.exports = HelloWorldController
```

The specified middleware will be inserted in the chain before the controller
action. An array of middleware can also be specified and they will be
inserted in the chain in the specified order.

## BaseController

A base controller has been exposed that application controllers can optionally extend.
The base controller exposes several helper methods.

The `useMiddleware` helper adds middleware declartions for all controller actions.
Often this would be used in the constructor of a controller.
The function also accepts options of `only` or `except` which modify the list of actions.

```coffeescript
# controllers/hello_world_controller.coffee
someMiddleware = require 'some-middleware'
someOtherMiddleware = require 'some-other-middleware'

class HelloWorldController
  constructor: ->
    @useMiddleware someMiddleware
    @useMiddleware someOtherMiddleware, only: 'index'

  index: (req, res) ->
    res.end 'hello world index'

  show: (req, res) ->
    res.end 'hello world show'

module.exports = HelloWorldController
```

The `getActions` helper returns an array of all the actions on the controller.
It also takes options of `only` or `except` to modify the list.

## Options

Options are provided to the _exprestive_ function.
```coffeescript
app = express()
app.use exprestive
  appDir: './www'
```

| Option                   | Description                                                                                            | Default Value                         |
|--------------------------|--------------------------------------------------------------------------------------------------------|---------------------------------------|
| **appDir**               | Directory used as a base directory for routes file and controllers directory                           | `__dirname`                           |
| **routesFilePath**       | File to be required to define routes. This is passed to `require`, so extension is optional            | **appDir**&nbsp;+&nbsp;`/routes`      |
| **controllersDirPath**   | Directory in which to look for controllers. All files in this directory will be automatically required | **appDir**&nbsp;+&nbsp;`/controllers` |
| **routes**               | Pass in an object to export routes to (see [reverse routing](#reverse-routing))                        | `res.locals.routes`                   |
| **dependencies**         | Pass in an object of dependencies to be passed to controller constructors                              | `{}`                                  |
| **controllersWhitelist** | Regex to match filenames in controllers directory                                                      | `/.+_controller\.(?:coffee|js)/`      |



## Development

See the [developer documentation](CONTRIBUTING.md)
