http    = require 'http'
_       = require 'lodash'
request = require 'request'

class CreateServiceGroupServiceGroupMemberBinding
  constructor: ({@options}) ->

  do: ({data}, callback) =>
    data = _.pickBy data

    options =
      baseUrl: @options.hostAddress
      headers:
        'Content-Type': 'application/vnd.com.citrix.netscaler.servicegroup_servicegroupmember_binding+json'
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password
      json:
        servicegroup_servicegroupmember_binding:
          servicegroupname: data.serviceGroupName
          ip:               data.ipAddress
          port:             data.port
          servername:       data.serverName

    request.post '/nitro/v1/config/servicegroup_servicegroupmember_binding', options, (error, response, body) =>
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

module.exports = CreateServiceGroupServiceGroupMemberBinding
