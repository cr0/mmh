
module.exports = class Forbidden extends Error
  name: "Forbidden"
  constructor: (@message, @code = 403) ->