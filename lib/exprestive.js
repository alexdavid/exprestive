(function() {
  var Exprestive, camelCase, express, fs, path;

  camelCase = require('camel-case');

  express = require('express');

  fs = require('fs');

  path = require('path');

  Exprestive = (function() {
    function Exprestive(baseDir, options) {
      var _ref, _ref1, _ref2, _ref3;
      this.options = options != null ? options : {};
      this.appDir = path.resolve(baseDir, (_ref = this.options.appDir) != null ? _ref : '');
      this.routesFilePath = path.resolve(this.appDir, (_ref1 = this.options.routesFilePath) != null ? _ref1 : 'routes');
      this.controllersDirPath = path.resolve(this.appDir, (_ref2 = this.options.controllersDirPath) != null ? _ref2 : 'controllers');
      this.controllers = (_ref3 = this.options.controllers) != null ? _ref3 : {};
      this.middlewareRouter = express.Router();
    }

    Exprestive.prototype.addRoute = function(_arg) {
      var controllerAction, controllerName, httpMethod, url;
      httpMethod = _arg.httpMethod, url = _arg.url, controllerName = _arg.controllerName, controllerAction = _arg.controllerAction;
      httpMethod = httpMethod.toLowerCase();
      return this.middlewareRouter[httpMethod](url, (function(_this) {
        return function() {
          var _ref;
          return (_ref = _this.controllers[controllerName])[controllerAction].apply(_ref, arguments);
        };
      })(this));
    };

    Exprestive.prototype.getRoutesHelperMethods = function() {
      var helperMethods, httpMethod, _i, _len, _ref;
      helperMethods = {};
      _ref = ['GET', 'POST', 'PUT', 'DELETE'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        httpMethod = _ref[_i];
        helperMethods[httpMethod] = (function(_this) {
          return function(httpMethod) {
            return function(url, _arg) {
              var controllerAction, controllerName, to, _ref1;
              to = _arg.to;
              _ref1 = to.split('#'), controllerName = _ref1[0], controllerAction = _ref1[1];
              return _this.addRoute({
                httpMethod: httpMethod,
                url: url,
                controllerName: controllerName,
                controllerAction: controllerAction
              });
            };
          };
        })(this)(httpMethod);
      }
      return helperMethods;
    };

    Exprestive.prototype.getMiddleware = function() {
      this.initializeControllers();
      this.initializeRoutes();
      return this.middlewareRouter;
    };

    Exprestive.prototype.initializeControllers = function() {
      var Controller, controller, controllerName, controllers, _i, _len, _results;
      controllers = fs.readdirSync(this.controllersDirPath);
      _results = [];
      for (_i = 0, _len = controllers.length; _i < _len; _i++) {
        controller = controllers[_i];
        Controller = require(path.join(this.controllersDirPath, controller));
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

    return Exprestive;

  })();

  module.exports = Exprestive;

}).call(this);
