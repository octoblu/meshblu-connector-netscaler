request = require 'request'

class DeleteServer
  constructor: ({@options}) ->

  do: ({data}, callback) =>
    options =
      baseUrl: @options.hostAddress
      headers:
        # 'Content-Type': 'application/vnd.com.citrix.netscaler.server+json'
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password
      json: true

    request.delete "/nitro/v1/config/server/#{data.name}", options, (error, response, body) =>
      return callback error if error?
      callback null, data: body

module.exports = DeleteServer
