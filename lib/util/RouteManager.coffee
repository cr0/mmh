
Path = require './Path'

module.exports = class RouteManager

  _lookup = {}

  constructor: ( paths... ) ->
    @add path for path in paths

  add: ( path ) ->
    throw new Error( 'No a path' ) if path not instanceof Path

    # if path.name exists replace it
    @_lookup[ path.name ] = path.folder

  remove: ( path ) ->
    path = if path instanceof Path then path.name else path
    delete @_lookup[ path ]

  find: ( path ) ->
    path = if path instanceof Path then path.name else path
    throw new Error( 'Unknown path' ) if path of @_lookup

    return @_lookup[ path ]

