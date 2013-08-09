
module.exports = class Unauthorized extends Error
  name: "Unauthorized"
  constructor: (@message, @code = 401) ->