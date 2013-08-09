
module.exports = class NotFound extends Error
  name: "NotFound"
  constructor: (@message, @code = 404) ->