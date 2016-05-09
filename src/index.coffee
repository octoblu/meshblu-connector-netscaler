{EventEmitter} = require 'events'

debug = require('debug')('meshblu-connector-netscaler:index')

class NetscalerConnector extends EventEmitter
  constructor: ->
    super wildcard: true

  close: (callback) =>
    debug 'on close'
    callback()

  isOnline: (callback) =>
    callback null, running: true

  onConfig: (config) =>
    return unless config?
    {@username, @password, @hostAddress} = config

  onMessage: (message) =>
    return unless message?
    { topic, devices, fromUuid } = message
    return if '*' in devices
    return if fromUuid == @uuid
    debug 'onMessage', { topic }

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid

module.exports = NetscalerConnector
