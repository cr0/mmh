
mongoose   = require 'mongoose'

Event      = require '../util/Event'

config     = require "#{process.cwd()}/config/setup"


module.exports = class Database

  connected: false

  constructor: ->
    @host = config.mongo.host || '127.0.0.1'
    @port = config.mongo.port || 27017
    @database = config.mongo.database || 'default'

  connect: ->
    mongoose.connect "mongodb://#{@host}:#{@port}/#{@database}"
    mongoose.connection.on 'connected', -> 
      connected = true
      Event.emit 'database:connected'

    mongoose.connection.on 'error', (err) -> 
      connected = false
      Event.emit 'database:error', err
      Event.emit '!error', err
    

