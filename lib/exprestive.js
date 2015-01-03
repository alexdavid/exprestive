(function() {
  var Exprestive, camelCase, express, fs, path, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('lodash');

  camelCase = require('camel-case');

  express = require('express');

  fs = require('fs');

  path = require('path');

  Exprestive = (function() {
    Exprestive.defaultOptions = {
      appDir: '',
      routesFilePath: 'routes',
      controllersDirPath: 'controllers'
    };

    function Exprestive(baseDir, options) {
      this.options = options != null ? options : {};
      this.resourcesHelperMethod = __bind(this.resourcesHelperMethod, this);
      _.defaults(this.options, Exprestive.defaultOptions);
      this.appDir = path.resolve(baseDir, this.options.appDir);
      this.routesFilePath = path.resolve(this.appDir, this.options.routesFilePath);
      this.controllersDirPath = path.resolve(this.appDir, this.options.controllersDirPath);
      this.middlewareRouter = express.Router();
    }

    Exprestive.prototype.addRoute = function(_arg) {
      var controllerAction, controllerName, httpMethod, url;
      httpMethod = _arg.httpMethod, url = _arg.url, controllerName = _arg.controllerName, controllerAction = _arg.controllerAction;
      return this.middlewareRouter[httpMethod.toLowerCase()](url, (function(_this) {
        return function() {
          var _ref;
          return (_ref = _this.controllers[camelCase(controllerName)])[controllerAction].apply(_ref, arguments);
        };
      })(this));
    };

    Exprestive.prototype.getMiddleware = function() {
      this.initializeControllers();
      this.initializeRoutes();
      return this.middlewareRouter;
    };

    Exprestive.prototype.getRoutesHelperMethods = function() {
      var helperMethods, httpMethod, _i, _len, _ref;
      helperMethods = {
        resources: this.resourcesHelperMethod
      };
      _ref = ['GET', 'POST', 'PUT', 'DELETE'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        httpMethod = _ref[_i];
        helperMethods[httpMethod] = this.getRoutesHttpHelperMethod(httpMethod);
      }
      return helperMethods;
    };

    Exprestive.prototype.getRoutesHttpHelperMethod = function(httpMethod) {
      return (function(_this) {
        return function(url, _arg) {
          var controllerAction, controllerName, to, _ref;
          to = _arg.to;
          _ref = to.split('#'), controllerName = _ref[0], controllerAction = _ref[1];
          return _this.addRoute({
            httpMethod: httpMethod,
            url: url,
            controllerName: controllerName,
            controllerAction: controllerAction
          });
        };
      })(this);
    };

    Exprestive.prototype.initializeControllers = function() {
      var Controller, controllerName, file, _i, _len, _ref, _ref1, _results;
      this.controllers = (_ref = this.options.controllers) != null ? _ref : {};
      if (this.options.controllers != null) {
        return;
      }
      _ref1 = fs.readdirSync(this.controllersDirPath);
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        file = _ref1[_i];
        Controller = require(path.join(this.controllersDirPath, file));
        controllerName = camelCase(Controller.name.replace(/Controller$/, ''));
        _results.push(this.controllers[controllerName] = new Controller);
      }
      return _results;
    };

    Exprestive.prototype.initializeRoutes = function() {
      var _ref;
      if (this.routesInitialized) {
        return;
      }
      this.routesInitialized = true;
      this.routesMethod = (_ref = this.options.routes) != null ? _ref : require(this.routesFilePath);
      return this.routesMethod(this.getRoutesHelperMethods());
    };

    Exprestive.prototype.resourcesHelperMethod = function(controllerName) {
      var controllerAction, httpMethod, resourceRoutes, url, _i, _len, _ref, _results;
      resourceRoutes = [['GET', "/" + controllerName, 'index'], ['GET', "/" + controllerName + "/new", 'new'], ['POST', "/" + controllerName, 'create'], ['GET', "/" + controllerName + "/:id", 'show'], ['GET', "/" + controllerName + "/:id/edit", 'edit'], ['PUT', "/" + controllerName + "/:id", 'update'], ['DELETE', "/" + controllerName + "/:id", 'destroy']];
      _results = [];
      for (_i = 0, _len = resourceRoutes.length; _i < _len; _i++) {
        _ref = resourceRoutes[_i], httpMethod = _ref[0], url = _ref[1], controllerAction = _ref[2];
        _results.push(this.addRoute({
          httpMethod: httpMethod,
          url: url,
          controllerAction: controllerAction,
          controllerName: controllerName
        }));
      }
      return _results;
    };

    return Exprestive;

  })();

  module.exports = Exprestive;

}).call(this);
