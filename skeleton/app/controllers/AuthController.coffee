

Mmh  = require('mmh')

module.exports = class AuthController extends Mmh.Controller

  required: ( req, res ) ->
    res.status 401
    if req.xhr then res.json
      error:
        code:     401
        message: 'login required'
    else
      res.render 'error',
        error:
          code:     401
          message:  'login required'

  logout:  (req, res) ->
    req.logout()
    res.status 200
    if req.xhr then res.json
        code:     200
        message: 'logout successful'
    else res.redirect '/'


  validate: ( req, res ) ->
    res.status 200
    console.log "we got a user:", req.session.auth
    redirectto = if req.session.returnto? then req.session.returnto else '/user/me'
    if req.xhr then res.redirect redirectto
    else res.render 'success'
    

  failed: ( req, res ) ->
    res.status 400
    if req.xhr then res.json
      error: 400
      message: 'auth failed'
    else res.render 'failed'

