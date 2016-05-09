{EventEmitter2} = require 'eventemitter2'
{Validator}     = require 'jsonschema'
_               = require 'lodash'
{Schemas}       = require './schema'

debug = require('debug')('meshblu-netscaler-connector:index')

class NetScalerConnector extends EventEmitter2
  constructor: ->
    super wildcard: true

  onConfig: ({@username, @password, @hostAddress}) =>

  onMessage: (message) =>
    debug 'onMessage', message

module.exports = NetScalerConnector
