const debug = require('debug')('meshblu-netscaler-connector:index')
import _ from 'lodash'
import {Schemas} from './schema'
import {Validator} from 'jsonschema'

import {EventEmitter2} from 'eventemitter2'

class NetScalerConnector extends EventEmitter2 {
  constructor (){
    super({wildcard: true})
    this.validator = new Validator()
  }

  authenticate (callback=()=>{}){


  }

  onConfig (deviceConfig){
    let result = this.validator.validate(deviceConfig, Schemas.configureSchema)
    if(!_.isEmpty(result.errors)){
      return this.emit('meshblu.netscaler.config.error', result.errors)
    }
    this.username = deviceConfig.username;
    this.password = deviceConfig.password; 
  }

  onMessage (message){

  }
}

export {NetScalerConnector as Plugin, Schemas}
