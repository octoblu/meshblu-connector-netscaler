cson           = require 'cson'
{EventEmitter} = require 'events'
http           = require 'http'
_              = require 'lodash'
path           = require 'path'
debug = require('debug')('meshblu-connector-netscaler:index')
GetCountOfLoadBalancingVirtualServers = require './jobs/get-count-of-load-balancing-virtual-servers'

CONFIG_SCHEMA       = cson.requireFile path.join(__dirname, '../schemas/config.cson')
MESSAGE_SCHEMA      = cson.requireFile path.join(__dirname, '../schemas/message.cson')
MESSAGE_FORM_SCHEMA = cson.requireFile path.join(__dirname, '../schemas/message-form.cson')

class NetscalerConnector extends EventEmitter
  constructor: ->
    super wildcard: true

  close: (callback) =>
    debug 'on close'
    callback()

  isOnline: (callback) =>
    callback null, running: true

  onConfig: ({options}) =>
    @options = _.pick options, 'username', 'password', 'hostAddress'

  onMessage: (message) =>
    {devices, fromUuid, payload} = message
    return if '*' in devices
    return if fromUuid == @uuid
    return unless payload?.metadata?
    return unless message?.metadata?.flow?
    {fromNodeId} = message.metadata.flow

    job = new GetCountOfLoadBalancingVirtualServers({@options})
    job.do payload, (error, response) =>
      return @_replyWithError {fromUuid, fromNodeId, error} if error?

      {metadata,data} = response
      @_replyWithResponse {fromUuid, fromNodeId, metadata, data}

  start: (device) =>
    {@uuid,octoblu} = device
    debug 'started', @uuid
    octoblu ?= {}
    octoblu.flow ?= {}
    octoblu.flow.forwardMetadata = true

    @emit 'update',
      optionsSchema:     CONFIG_SCHEMA
      messageSchema:     MESSAGE_SCHEMA
      messageFormSchema: MESSAGE_FORM_SCHEMA
      octoblu:           octoblu

  _replyWithError: ({fromUuid, fromNodeId, error}) =>
    code = error.code ? 500

    @emit 'message', {
      devices: [fromUuid]
      payload:
        from: fromNodeId
        metadata:
          code: code
          status: http.STATUS_CODES[code]
          error:
            message: error.message ? 'Unknown Error'
    }

  _replyWithResponse: ({fromUuid, fromNodeId, metadata, data}) =>
    @emit 'message', {
      devices: [fromUuid]
      payload:
        from: fromNodeId
        metadata: metadata
        data: data
    }

module.exports = NetscalerConnector
