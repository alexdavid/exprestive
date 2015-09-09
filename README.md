# expRESTive

[![NPM Version](https://img.shields.io/npm/v/exprestive.svg)](https://www.npmjs.com/package/exprestive)
[![Build Status](https://img.shields.io/circleci/project/alexdavid/exprestive/master.svg)](https://circleci.com/gh/alexdavid/exprestive)
[![Dependency Status](https://david-dm.org/alexdavid/exprestive.svg)](https://david-dm.org/alexdavid/exprestive)

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
Exprestive exports url building functions to `this.routes` in controllers and `res.locals.routes` for each request.

### Saving / accessing reverse routes
In your routes file you can pass an `as` parameter to non-restful routes to define a reverse route.
```coffeescript
# routes.coffee
module.exports = ({GET}) ->
  GET '/foo/bar', to: 'foo#bar', as: 'foobar'
```

In a controller you can access this path with `@routes.foobar()`
```coffeescript
# controllers/foo.coffee
class FooController
  bar: (req, res) ->
    @routes.foobar() # returns "/foo/bar"
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
    @routes.userPost(1, 2)             # returns "/users/1/posts/2"
    @routes.userPost(userId: 1, id: 2) # returns "/users/1/posts/2"
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
An array of middleware can also be specified and they will be inserted in the chain in the specified order.
Often this would be used in the constructor of a controller.
The function also accepts options of `only` or `except` which modify the list of actions.

```coffeescript
# controllers/hello_world_controller.coffee
{BaseController} = require 'exprestive'
someMiddleware = require 'some-middleware'
someOtherMiddleware = require 'some-other-middleware'

class HelloWorldController extends BaseController
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

* `appDir`
  * Directory used as a base directory for routes file and controllers directory     
  * default: `__dirname`
* `controllersPattern`
  * [Glob](https://github.com/isaacs/node-glob) pattern used to find controllers. Resolved relative to `appDir`
  * default: `'controllers/*_controller.{coffee,js}'`
* `dependencies`
  * Object passed to controller constructors
  * default: `{}`
* `routesFilePath`
  * Path to routes file. Resolved relative to `appDir`. This is passed to `require`, so extension is optional
  * default: `'routes'`



## Development

See the [developer documentation](CONTRIBUTING.md)
