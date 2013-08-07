
PolicyManager = require '../access/PolicyManager'
Event         = require '../util/Event'

module.exports = class Dispatcher

  @controllerPrefix: 'Controller'

  policyManager: new PolicyManager

  @getControllerPath: ( controller ) ->
    # upper first char
    controller = controller.charAt(0).toUpperCase() + controller.slice(1).toLowerCase()
    controller += Dispatcher.controllerPrefix

  get: ( req, res, next ) =>
    req.params.method = 'get'
    next()

  post: ( req, res, next ) =>
    req.params.method = 'post'
    next()

  put: ( req, res, next ) =>
    req.params.method = 'put'
    next()

  del: ( req, res, next ) =>
    req.params.method = 'delete'
    next()

  all: ( req, res, next ) =>
    method     = req.params.method
    if req.params.controller is null and typeof method is 'function'
      console.log "route with method", method, req.route
      return method( res, res, next )

    controller = Dispatcher.getControllerPath( req.params.controller )
    method     ?= 'index'

    # check if a policy forbiddes exection
    if not @policyManager.validate(controller, method, req, res)
      console.error "Policy denys access to #{controller}##{method}"
      return

    # try to find the controller
    try
      clazz = require "#{process.cwd()}/app/controllers/#{controller}"
    catch err
      return next new Error "Controller #{controller} not found"

    try
      clazz = new clazz()
      clazz[method]( req, res )
    catch err
      return next new Error "Unable to execute method, because #{err}"


