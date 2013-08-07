
Controller = require './Controller'

module.exports = class RestController extends Controller

  get: ( req, res ) -> throw new Error 'Method `get` is not overriden'
  post: ( req, res ) -> throw new Error 'Method `post` is not overriden'
  put: ( req, res ) -> throw new Error 'Method `put` is not overriden'
  delete: ( req, res ) -> throw new Error 'Method `delete` is not overriden'