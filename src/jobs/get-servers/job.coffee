request = require 'request'
http    = require 'http'

class GetServers
  constructor: ({@options}) ->

  do: ({}, callback) =>
    options =
      baseUrl: @options.hostAddress
      json: true
      headers:
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password

    request.get '/nitro/v1/config/server', options, (error, response, body) =>
      return callback error if error?
      code = response.statusCode
      callback null, {
        metadata:
          code: code
          status: http.STATUS_CODES[code]
        data: body
      }


module.exports = GetServers
