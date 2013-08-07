

Mmh  = require('mmh')

module.exports = class HomeController extends Mmh.Controller

  index: ( req, res ) ->
    res.render 'index'

