fs          = require 'fs'

Route       = require '../util/Route'
Server      = require './Server'
Database    = require './Database'
Event       = require '../util/Event'

config      = require "#{process.cwd()}/config/setup"

module.exports = class Application

  @instance: null

  server: null
  database: null

  constructor: ->
    if Application.instance? then throw Error 'Application already running!';
    else Application.instance ?= @

    # initialize db
    @database ?= new Database()

    # initialize server
    port = config.server.port || 2000
    @server ?= new Server(port)

    @addExtensions()
    @addRoutes()

  addExtensions: ->
    console.log 
    for file in fs.readdirSync __dirname + "/../extensions"
      try
        clazz = require __dirname + "/../extensions/#{file}"
        new clazz( @server.express )
      catch err
        console.error err
        Event.emit '!error', new Error "Unable to enable extension: #{err}"


  addRoutes: ->
    routes = require "#{process.cwd()}/config/routes"
    @server.addRoute new Route key, value for key, value of routes
    @server.addGenericRoute()

  
  start: ->
    # launch when connected to database
    Event.on 'database:connected', =>
      console.log "Connected to mongodb at #{@database.host}:#{@database.port}/#{@database.database}"
      try
        @server.listen()
        console.log "Server is listening on #{@server.port}" if @server.listening
      catch err
        console.error 'Unable to start listening', err
        console.error 'Bye...'
        process.exit()

    Event.on 'database:error', (err) =>
      console.error 'Unable to connect to database', err
      process.exit()

    @database.connect()

