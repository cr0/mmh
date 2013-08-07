
Mmh  = require('mmh')

module.exports = class AuthenticatedPolicy extends Mmh.Policy

  validate: (req, res) ->
    if req.isAuthenticated() then return true
    else
      req.session.returnto = req.originalUrl || req.url
      res.status(401).redirect('/auth/req')
      false
