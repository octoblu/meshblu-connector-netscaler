request = require 'request'

class GetCountOfNetscalerResources
  constructor: ({@options}) ->

  do: ({}, callback) =>
    options =
      baseUrl: @options.hostAddress
      headers:
        'X-NITRO-USER': @options.username
        'X-NITRO-PASS': @options.password
        # 'Accept': 'application/vnd.com.citrix.netscaler.lbvserver+json'
      qs:
        count: 'yes'

    request.get '/nitro/v1/config/lbvserver', options, (error, response, body) =>
      return callback error if error?
      callback null, data: body


module.exports = GetCountOfNetscalerResources
