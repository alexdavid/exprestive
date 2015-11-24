# Changelog

### 1.0.0 (2015-11-23)

* Add support for any connect-based web framework

---
### 0.10.1 (2015-09-10)

* update documentation

---
### 0.10.0 (2015-09-08)

* update `BaseController::useMiddleware` to support array of middleware functions
* expose reverse routing object as `this.routes` in controllers
* remove option to export reverse routing object
* always set `res.locals.routes`
* change `controllersWhitelist` regex to `controllersPattern` glob pattern

---
### 0.9.1 (2015-07-20)

* make default `controllersWhitelist` more specific

---
### 0.9.0 (2015-07-09)

* add support for controller/action specific middleware

---
### 0.8.0 (2015-06-25)

* add support for scoped routes

---
### 0.7.0 (2015-03-24)

* add informative errors when a controller or action is missing
* bug fix: `res.locals.routes` can now be used in views

---
### 0.6.1 (2015-02-06)

* add resource filtering with `except:`
* bug fix: set `res.locals.routes` before controller action is called

---
### 0.6.0 (2015-01-27)

* add option `controllersWhitelist` to determine what files are controllers

---
### 0.5.0 (2015-01-22)

* rename `res.locals.paths` to `res.locals.routes`
* rename option `paths` to `routes`
* routes include a `method` propery
* ignore files in the controller directory that do not export a function with a name property

---
### 0.4.0 (2015-01-19)

* add controller dependencies
* add resource filtering with `only:`
* add support for reverse routing to handle any paramaters
* allow reverse routing in any case
* fix reverse routes caching issue

---
### 0.3.0 (2015-01-09)

* add support for reverse routing

---
### 0.2.0 (2014-12-31)

* rename `resource` to `resources`

---
### 0.1.1 (2014-12-31)

* update documentation

---
### 0.1.0 (2014-12-31)

* initial implementation
