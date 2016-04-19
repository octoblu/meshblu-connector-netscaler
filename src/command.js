// _             = require 'lodash'
// Connector     = require './connector'
// MeshbluConfig = require 'meshblu-config'
// meshbluConfig = new MeshbluConfig {}
//
// connector = new Connector meshbluConfig.toJSON()
//
// connector.on 'error', (error) ->
//   return console.error 'an unknown error occured' unless error?
//   return console.error error if _.isPlainObject error
//   console.error error.toString()
//   console.error error.stack if error?.stack?
//
// connector.run()
// class Command
//   constructor: ->
//     @serverOptions =
//       cwcOptions:     @_buildCwcOptions()
//       port:           process.env.PORT || 80
//       disableLogging: process.env.DISABLE_LOGGING == "true"
//
//   panic: (error) =>
//     console.error error.stack
//     process.exit 1
//
//   run: =>
//
//     server = new Server @serverOptions
//     server.run (error) =>
//       return @panic error if error?
//
//       {address,port} = server.address()
//
//     process.on 'SIGTERM', =>
//       console.log 'SIGTERM caught, exiting'
//       server.stop =>
//         process.exit 0
//
//   _buildCwcOptions: =>
//     return {
//       staging: @_getCwcEnvironment 'staging'
//       production: @_getCwcEnvironment 'production'
//     }
//
//   _getCwcEnvironment: (environmentName) =>
//     environmentName = environmentName.toUpperCase()
//     environment =
//       authenticatorUrl: process.env["#{environmentName}_AUTHENTICATOR_URL"]
//       hostname: process.env["#{environmentName}_HOSTNAME"]
//       privateKey: process.env["#{environmentName}_PRIVATE_KEY"]
//       serviceName: process.env["#{environmentName}_SERVICE_NAME"]
//       url: process.env["#{environmentName}_URL"]
//
//     _.each environment, (value, key) =>
//       return @panic new Error("#{key} for cwc #{environmentName} is not defined") if _.isEmpty value
//
// command = new Command()
// command.run()
