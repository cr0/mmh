
Mmh  = require('mmh')

module.exports = class AuthenticatedPolicy extends Mmh.Policy

  validate: (req, res) ->
    if req.isAuthenticated() then return true
    else
      req.session.returnto = req.originalUrl || req.url
      return new Mmh.Error.Unauthorized 'User needs to be authenticated to perform this action'
