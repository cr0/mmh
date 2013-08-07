Mmh  = require 'mmh'

module.exports = class App extends Mmh.Application

  constructor: () ->
    super

    mmm.Event.on '!error', (err, req, res) ->
      console.error 'Error occured', err
      res.send 500, err

    mmm.Event.on '!error:404', (err, req, res) ->
      res.send 404, err

