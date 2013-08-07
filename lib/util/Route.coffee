
module.exports = class Route

  method: 'all'
  path: '/'
  controller: null
  action: ''

  constructor: ( key, value )->
    # path
    [one, two] = key.split(' ')
    if not two
      @method = 'all'
      @path = one
    else
      @method = one
      @path = two

    if @method not in ['all', 'get', 'put', 'post', 'delete'] then throw Error "Invalid http method in key: #{key}"

    # action
    if typeof value is 'function' then @action = value
    else
      [@controller, @action] = value.split('#')
      @action ?= 'index'