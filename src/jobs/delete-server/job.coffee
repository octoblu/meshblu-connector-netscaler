request = require 'request'
http    = require 'http'

class DeleteServer
  constructor: ({@options}) ->

  do: ({data}, callback) =>
    options =
      baseUrl: @options.hostAddress
      headers:
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password
      json: true

    request.delete "/nitro/v1/config/server/#{data.name}", options, (error, response, body) =>
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
      data: data
    }

module.exports = DeleteServer
