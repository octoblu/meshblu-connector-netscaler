request = require 'request'

class CreateServer
  constructor: ({@options}) ->

  do: ({data}, callback) =>
    options =
      baseUrl: @options.hostAddress
      headers:
        'Content-Type': 'application/vnd.com.citrix.netscaler.server+json'
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password
      json:
        server:
          name:      data.name
          ipaddress: data.ipAddress
          domain:    data.domain

    request.post '/nitro/v1/config/server', options, (error, response, body) =>
      return callback error if error?
      callback null, data: body

module.exports = CreateServer
