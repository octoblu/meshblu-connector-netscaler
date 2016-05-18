cson           = require 'cson'
{EventEmitter} = require 'events'
http           = require 'http'
_              = require 'lodash'
path           = require 'path'
debug = require('debug')('meshblu-connector-netscaler:index')
CreateServer = require './jobs/create-server'
GetCountOfServers = require './jobs/get-count-of-servers'
GetServers = require './jobs/get-servers'

CONFIG_SCHEMA   = cson.requireFile path.join(__dirname, '../schemas/config.cson')
MESSAGE_SCHEMAS = cson.requireFile path.join(__dirname, '../schemas/message.cson')
FORM_SCHEMA     = cson.requireFile path.join(__dirname, '../schemas/form.cson')

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

    job = @_getJob payload.metadata.jobType
    return unless job?

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
      optionsSchema: CONFIG_SCHEMA
      schemas:
        version: '1.0.0'
        message: MESSAGE_SCHEMAS
        form:    FORM_SCHEMA
      octoblu:           octoblu

  _getJob: (jobType) =>
    return new CreateServer {@options}      if jobType == 'CreateServer'
    return new GetCountOfServers {@options} if jobType == 'GetCountOfServers'
    return new GetServers {@options}        if jobType == 'GetServers'

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
