_       = require 'lodash'
request = require 'request'
http    = require 'http'

class GetCountOfServers
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

    request.get '/nitro/v1/config/server', options, (error, response, body) =>
      return callback error if error?
      code = response.statusCode
      callback null, {
        metadata:
          code: code
          status: http.STATUS_CODES[code]
        data:
          count: _.first(body.server).__count
      }

module.exports = GetCountOfServers
