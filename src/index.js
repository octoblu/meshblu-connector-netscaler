const debug = require('debug')('meshblu-netscaler-connector:index')
import _ from 'lodash'
import {Schemas} from './schema'
import {Validator} from 'jsonschema'

import {EventEmitter2} from 'eventemitter2'

class NetScalerConnector extends EventEmitter2 {

  constructor (){
    super({wildcard: true})
    this.validator = new Validator()
    this.username
    this.password
    this.hostAddress
    return this
  }

  authenticate (callback=()=>{}){

  }

  // validatePath (path){
  //   _.find(Schemas.messageSchemas, function(schema) {
  //      return schema.properties.path.default == path;
  //    });
  // }


  getUsername(){
    return this.username
  }
  getPassword(){
    return this.password
  }

  getHostAddress(){
    return this.hostAddress
  }

  setUsername(value){
    this.username = value

  }
  setPassword(value){
    this.password = value
  }
  setHostAddress(value){
    this.hostAddress = value
  }

  onConfig (deviceConfig){
    let result = this.validator.validate(deviceConfig, Schemas.configureSchema)
    if(!_.isEmpty(result.errors)){
      return this.emit('meshblu.netscaler.config.error', result.errors)
    }
    this.setUsername(deviceConfig.username)
    this.setPassword(deviceConfig.password)
    this.setHostAddress(deviceConfig.hostAddress)
  }

  onMessage (message){

  }
}
export {NetScalerConnector as Plugin, Schemas}
