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
      #User.find id, (error, user) ->
      done null, 123

    @provider provider for provider in setup.provider


  provider: ( name, options ) ->
    @["#{name}Strategy"](options)

    params        = {}

    params.scope  = [
      'https://www.googleapis.com/auth/userinfo.profile'
      'https://www.googleapis.com/auth/userinfo.email'
    ] if name == 'google'

    @app.get "/auth/#{name}/", passport.authenticate name, params

    @app.get "/auth/#{name}/callback", (req, res, next) ->
      passport.authenticate(name, (err, profile, credentials) ->
        if err then res.redirect '/auth/failed'

        provider  = profile.provider
        id        = profile.id

        delete profile._json
        delete profile._raw

        req.session.auth =
          provider:     provider
          id:           id
          info:         profile
          credentials:  credentials

        req.logIn profile, (err) ->
          if err then next err
          else next()

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
