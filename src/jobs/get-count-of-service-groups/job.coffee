_       = require 'lodash'
request = require 'request'
http    = require 'http'

class GetCountOfServiceGroups
  constructor: ({@options}) ->

  do: ({}, callback) =>
    options =
      baseUrl: @options.hostAddress
      json: true
      headers:
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password
      qs:
        count: 'yes'

    request.get '/nitro/v1/config/servicegroup', options, (error, response, body) =>
      return callback error if error?
      code = response.statusCode
      data = body

      return @yieldError {code, data}, callback if code > 299
      return @yieldResult {code, data}, callback

  yieldError: ({data, code}, callback) =>
    callback null, {
      metadata:
        code: code
        status: http.STATUS_CODES[code]
      data: data
    }

  yieldResult: ({data, code}, callback) =>
    callback null, {
      metadata:
        code: code
        status: http.STATUS_CODES[code]
      data:
        count: _.first(data.servicegroup).__count
    }

module.exports = GetCountOfServiceGroups
