request = require 'request'
http    = require 'http'

class CreateServiceGroup
  constructor: ({connector}) ->
    {@options} = connector

  do: ({data}, callback) =>
    options =
      baseUrl: @options.hostAddress
      headers:
        'Content-Type': 'application/vnd.com.citrix.netscaler.servicegroup+json'
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password
      json:
        servicegroup:
          servicegroupname: data.name
          servicetype:      data.serviceType

    request.post '/nitro/v1/config/servicegroup', options, (error, response, body) =>
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

module.exports = CreateServiceGroup
