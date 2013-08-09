
express    = require 'express'


Dispatcher = require './Dispatcher'
Event      = require '../util/Event'
NotFound   = require '../errors/NotFound'

config     = require "#{process.cwd()}/config/setup"


module.exports = class Server

  express: express()
  dispatcher: new Dispatcher()

  compress: false
  listening: false

  constructor: ( @port ) ->
    Event.on 'middleware:add', (middleware) => 
      console.log "adding middleware #{middleware}"
      @addMiddleware middleware

    @express.set 'view engine', config.view.engine

    #@express.use express.compress()
    @express.use (express.static(process.cwd() + '/public'))
    
    @express.use express.methodOverride()
    @express.use express.bodyParser()
    @express.use express.favicon()
    @express.use express.logger('dev')

    @express.use express.cookieParser()
    if config.session.enabled and config.session.secret
      @express.use express.session
        secret: config.session.secret

  listen: ->
    @express.listen( @port )
    @listening = true

  addRoute: ( route ) ->
    addAction = (req, res, next) ->
      req.params.controller = route.controller
      req.params.method = route.action
      next()

    switch route.method
      when 'get' then @express.get route.path, addAction, @dispatcher.all
      when 'post' then @express.post route.path, addAction, @dispatcher.all
      when 'put' then @express.put route.path, addAction, @dispatcher.all
      when 'delete' then @express.del route.path, addAction, @dispatcher.all
      else @express.all route.path, addAction, @dispatcher.all

  # generic route: /:controller/:id?
  addGenericRoute: ->
    @express.get '/api/:controller/:id?', @dispatcher.get, @dispatcher.all
    @express.post '/api/:controller', @dispatcher.post, @dispatcher.all
    @express.put '/api/:controller/:id', @dispatcher.put, @dispatcher.all
    @express.del '/api/:controller/:id', @dispatcher.del, @dispatcher.all

  addErrorHandler: ->
    @express.use @express.router

    @express.use (req, res, next) ->
      next new NotFound "Cannot find a route for #{req.url}"

    @express.use (err, req, res, next) ->
      errcode = if err.code then err.code else 500
      res.status errcode

      console.error err.stack if errcode is 500

      message = if err.message instanceof Error then err.message.message else err.message 

      if req.xhr
        res.json 
          error: 
            code: errcode
            name: err.name
            message: message
            details: stack: err.stack, file: err.fileName, line: err.lineNumber
      else
        res.render 'error', error: err, code: errcode, stack: err.stack, name: err.name, message: message, file: err.fileName, line: err.lineNumber
    