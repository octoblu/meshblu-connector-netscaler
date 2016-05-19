{EventEmitter} = require 'events'
fs             = require 'fs'
http           = require 'http'
_              = require 'lodash'
path           = require 'path'
debug = require('debug')('meshblu-connector-netscaler:index')

CONFIG_SCHEMA     = require '../schemas/config.cson'
GetCountOfServers = require './jobs/get-count-of-servers'

class NetscalerConnector extends EventEmitter
  constructor: ->
    super wildcard: true

  close: (callback) =>
    debug 'on close'
    callback()

  getJobs: =>
    dirnames = fs.readdirSync path.join(__dirname, './jobs')
    jobs = {}
    _.each dirnames, (dirname) =>
      key = _.upperFirst _.camelCase dirname
      dir = path.join 'jobs', dirname
      jobs[key] = require "./#{dir}"
    return jobs

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

    job = @jobs[payload.metadata.jobType]
    return unless job?

    job.action {@options}, payload, (error, response) =>
      return @_replyWithError {fromUuid, fromNodeId, error} if error?

      {metadata,data} = response
      @_replyWithResponse {fromUuid, fromNodeId, metadata, data}

  start: (device) =>
    {@uuid,octoblu} = device
    debug 'started', @uuid
    @jobs = @getJobs()
    octoblu ?= {}
    octoblu.flow ?= {}
    octoblu.flow.forwardMetadata = true

    @emit 'update',
      optionsSchema: CONFIG_SCHEMA
      type: 'device:netscaler'
      schemas:
        version: '1.0.0'
        message: @_messageSchemaFromJobs @jobs
        form:    @_formSchemaFromJobs @jobs
      octoblu: octoblu

  _formSchemaFromJobs: (jobs) =>
    return {
      message: _.mapValues jobs, 'form'
    }

  _generateMetadata: (jobType) =>
    return {
      type: 'object'
      required: ['jobType']
      properties:
        jobType:
          type: 'string'
          enum: [jobType]
          default: jobType
    }

  _getJob: (jobType) =>
    return new GetCountOfServers {@options} if jobType == 'GetCountOfServers'
    # return new CreateServer {@options}      if jobType == 'CreateServer'
    # return new GetServers {@options}        if jobType == 'GetServers'

  _messageSchemaFromJob: (job, key) =>
    message = _.cloneDeep job.message
    _.set message, 'x-form-schema.angular', "message.#{key}.angular"
    _.set message, 'properties.metadata', @_generateMetadata(key)
    return message

  _messageSchemaFromJobs: (jobs) =>
    _.mapValues jobs, @_messageSchemaFromJob

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
