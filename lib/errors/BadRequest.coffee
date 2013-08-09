
module.exports = class BadRequest extends Error
  name: "BadRequest"
  constructor: (@message, @code = 400) ->