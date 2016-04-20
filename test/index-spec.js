import {Plugin} from '../src/index'
import {EventEmitter2} from 'eventemitter2'



describe('NetScalerConnector', ()=>{
  let sut;
  let eventEmmiter;

  beforeEach( ()=>{
    sut = new Plugin()
    eventEmmiter = new EventEmitter2({wildcard: true})
  })
  it('should exist', ()=>{
    expect(sut).to.exist
  })
  describe('->onConfig', ()=>{
    context('When an invalid config that does not match the configureSchema',( )=>{
      let deviceConfig = {};
      let configErrors;

      beforeEach((done)=>{
        sut.on('meshblu.netscaler.config.error', (validationErrors)=>{
          console.log("Event was fired")
          configErrors = validationErrors
          done()
        });
        sut.onConfig(deviceConfig);
      })
      it('Should emit an error if the config does not match schema',(done)=>{
        expect(configErrors).to.not.be.null;
        expect(configErrors.length).to.equal(3);
        done()
      });

    })
    context('when given valid device config settings',()=>{
      let deviceConfig = {
        "username": "hello",
        "password": "world",
        "hostAddress": "10.1.0.1"
      }
      beforeEach((done)=>{
        sut.onConfig(deviceConfig)
        done()
      })
      it('should set the username, password and server for the plugin', (done)=>{

        expect(sut.getUsername()).to.equal("hello")
        expect(sut.getPassword()).to.equal("world")
        expect(sut.getHostAddress()).to.equal("10.1.0.1")
        done()
      })
    })
  })
  describe('->onMessage', ()=>{
    context('when given a valid message endpoint', ()=>{

    })

    context('when given an invalid message endpoint that isn\'t defined', ()=>{

    })
  })
});
