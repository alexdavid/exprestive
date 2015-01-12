expRESTive [![Build Status](https://travis-ci.org/alexdavid/exprestive.svg)](https://travis-ci.org/alexdavid/exprestive) [![Dependency Status](https://david-dm.org/alexdavid/exprestive.png)](https://david-dm.org/alexdavid/exprestive)
==========

A RESTful routing middleware for [Express.js](http://expressjs.com).


## Basic usage
Assuming you have already created an [Express](http://expressjs.com/) application
by following the [Express installation instructions](http://expressjs.com/starter/installing.html).
Now:

* add expRESTive to your _package.json_ file: `$ npm install --save express exprestive`
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
  File names don't matter controller names are taken from the class name

  ```coffeescript
  # controllers/hello_world.coffee
  class HelloWorldController
    index: (req, res) ->
      res.end 'hello world'

  module.exports = HelloWorldController
  ```
* visit `/hello` in your browser


## Reverse routing
Exprestive exports url building functions to a `paths` object. By default it is saved to `res.locals.paths` for easy access from views.

### Saving / accessing reverse routes
In your routes file you can pass an `as` parameter to non-restful routes to define a reverse route.
```coffeescript
# routes.coffee
module.exports = ({GET}) ->
  GET '/foo/bar', to: 'foo#bar', as: 'foobar'
```

In a controller you can access this path with `res.locals.paths.foobar()`
```coffeescript
# controllers/foo.coffee
class FooController
  bar: (req, res) ->
    res.locals.paths.foobar() # returns "/foo/bar"
```

In a view you can access this path with `paths.foobar()`
```jade
//- index.jade
a(href=paths.foobar()) Visit foobar
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
    res.locals.paths.userPost(1, 2)             # returns "/users/1/posts/2"
    res.locals.paths.userPost(userId: 1, id: 2) # returns "/users/1/posts/2"
```


### Custom paths
Setting `options.paths` will cause reverse routes to be exported to the passed object instead of `res.locals.paths`
For example you can set `options.paths` to a global variable to access paths the same from everywhere.

```coffeescript
global.paths = {}
app.use exprestive paths: global.paths

# Now paths.foobar() returns "/foo/bar" from anywhere in your application
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
  GET    '/users',          to: 'user#index', as: 'users'
  GET    '/users/new',      to: 'user#new',   as: 'newUser'
  GET    '/users/:id',      to: 'user#show',  as: 'user'
  GET    '/users/:id/edit', to: 'user#edit',  as: 'editUser'
  PUT    '/users/:id',      to: 'user#update'
  POST   '/users',          to: 'user#create'
  DELETE '/users/:id',      to: 'user#destroy'
```


## Options

Options are provided to the _exprestive_ function.
```coffeescript
app = express()
app.use exprestive
  appDir: './www'
```

| Option                 | Description                                                                                                                                                                     | Default Value                         |
|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| **appDir**             | Directory used as a base directory for routes file and controllers directory                                                                                                    | `__dirname`                           |
| **routesFilePath**     | File to be required to define routes. This is passed to `require`, so extension is optional                                                                                     | **appDir**&nbsp;+&nbsp;`/routes`      |
| **controllersDirPath** | Directory in which to look for controllers. All files in this directory will be automatically required                                                                          | **appDir**&nbsp;+&nbsp;`/controllers` |
| **routes**             | Pass in a routes function instead of requiring **routesFilePath**. Setting this will cause **routesFilePath** to be ignored                                                     | *None*                                |
| **controllers**        | Pass in an object of instantiated controllers instead of requiring controller classes from **controllersDirPath**. Setting this will cause **controllersDirPath** to be ignored | *None*                                |
| **paths**              | Pass in an object to export paths to (see [reverse routing](#reverse-routing))                                                                                                  | `res.locals.paths`                    |
| **initializeWith**     | Pass in an object to be passed to controller constructors                                                                                                                       | `{}`                                  |



## Tests

* Run unit tests: `npm run unit-tests`
* Run feature tests: `npm run feature-tests`
