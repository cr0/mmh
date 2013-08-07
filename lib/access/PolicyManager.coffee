
Policy = require './Policy'

module.exports = class PolicyManager

  @policyPrefix: 'Policy'

  policies: {}

  constructor: ->
    rawpolicies = require "#{process.cwd()}/config/policies"
    @create rawpolicies


  create: ( object, controller = null ) ->
    for key, value of object
      if typeof value is 'object' and value not instanceof Array then @create value, key
      else 
        if not controller? then @policies["#{key}"] = value
        else @policies["#{controller}##{key}"] = value


  validate: ( controller, method, req, res ) ->
    evaluate = true

    if "#{controller}##{method}" of @policies then evaluate = @policies["#{controller}\##{method}"]
    else if "#{controller}#*" of @policies then evaluate = @policies["#{controller}\#*"]
    else if "#{method}" of @policies then evaluate = @policies["#{method}"]
    else if "*" of @policies then evaluate = @policies["*"]

    if typeof evaluate is 'boolean' then return evaluate
    else if typeof evaluate is 'string' then return @callPolicy( evaluate, req, res )
    else if typeof evaluate is 'object' and evaluate instanceof Array
      for evaluateItem in evaluate
        if not @callPolicy( evaluateItem, req, res ) then return false
      return true


  callPolicy: ( policyName, req, res ) ->

    policyName = "#{process.cwd()}/app/policies/" + policyName.charAt(0).toUpperCase() + policyName.slice(1).toLowerCase()
    policyName += PolicyManager.policyPrefix
    
    try
      clazz = require policyName
      clazz = new clazz()
      if clazz not instanceof Policy then throw new Error 'Provided file is not a Policy'
    catch e
      console.error "Invalid policy provided", e
      return false

    clazz.validate(req, res)

