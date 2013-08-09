passport = require 'passport'

App      = require '../app'
Route    = require '../util/Route'
Event    = require '../util/Event'

config   = require "#{process.cwd()}/config/setup"
setup    = require("#{process.cwd()}/config/extensions").passport


module.exports = class Passport

  constructor: ( @app ) ->

    if not setup.enabled then return

    try
      User = require "#{process.cwd()}/app/models/#{setup.model}"
    catch err
      throw new Error "Unable to load #{setup.model} for passport serialization"

    @app.use passport.initialize()
    @app.use passport.session()

    passport.serializeUser (user, done) ->
      done null, user.id

    passport.deserializeUser (id, done) ->
      User.findById id, (error, user) ->
        done null, user

    @provider provider for provider in setup.provider


  provider: ( name, options ) ->
    @["#{name}Strategy"](options)

    @app.get "/auth/#{name}/", passport.authenticate name, setup[name]

    @app.get "/auth/#{name}/callback", (req, res, next) ->
      passport.authenticate(name, (err, profile, credentials) ->
        if err then res.redirect '/auth/failed'

        provider  = profile.provider
        id        = profile.id

        if profile._json?.birthday then profile.birthday = profile._json?.birthday
        if profile._json?.picture then profile.picture = profile._json?.picture
        
        delete profile._json
        delete profile._raw
        delete profile.provider
        delete profile.id

        req.session.auth =
          provider:     
            name:       provider
            id:         id
          info:         profile
          credentials:  credentials

        next()
        
      )(req, res, next)

    Event.emit "passport:#{name}", yes

  oauth2Strategy: ( name, options = {} ) ->

    try
      if name == 'google'
        Strategy    = require("passport-#{name}-oauth").OAuth2Strategy
      else
        Strategy    = require("passport-#{name}").Strategy
      credentials = config.auth[name]

      if credentials
        options.id ||= credentials.id
        options.secret ||= credentials.secret

      passport.use new Strategy
        clientID:     options.id
        clientSecret: options.secret
        callbackURL:  "http://#{config.server.host}:#{config.server.port}/#{config.server.path}auth/#{name}/callback"
        (accessToken, refreshToken, profile, callback) ->
          info =
            accessToken:  accessToken
            refreshToken: refreshToken

          callback(null, profile, info)

    catch e
      console.error 'unable to create oauth strategy'
      throw e


  amazonStrategy: ( options ) ->
    @oauth2Strategy('amazon', options)

  facebookStrategy: ( options ) ->
    @oauth2Strategy('facebook', options)

  googleStrategy: ( options ) ->
    @oauth2Strategy('google', options)
