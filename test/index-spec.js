import {Plugin} from '../src/index'
import {EventEmitter2} from 'eventemitter2'
import shmock from 'shmock'



describe('NetScalerConnector', ()=>{
  let sut;
  let eventEmmiter;
  let netScalerShmock;

  beforeEach( ()=>{
    sut = new Plugin()
    eventEmmiter = new EventEmitter2({wildcard: true})
    netScalerShmock = new shmock(0xDEAD)
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

  xdescribe('->onMessage', ()=>{
    context('When given a message that matches a Netscaler endpoint', ()=>{
      let message = {
        metadata: {
          jobType: "/CreateResource"
        },
        data: {
          "lbvserver": {
            "name": "hello",
            "serviceType": "world"
          }
        }
      };
      let deviceConfig = {
        "username": "hello",
        "password": "world",
        "hostAddress": `localhost:${0xDEAD}`
      };
      let nsConfigResourceHandler;

      beforeEach(()=>{
    //     @cwcStagingServerMock
    //  .post "/#{bodyOptions.customerId}/sessionotp"
    //  .set "Authorization", "CWSAuth service=#{cwcAuthServiceKey}"
    //  .send {oneTimePassword: "#{bodyOptions.otp}"}
    //  .reply 200, {sessionId: @sessionId, bearerToken: @bearerToken}
        nsConfigResourceHandler = netScalerShmock
        .post("/nitro/v1/config/lbvserver")
        .set("X-NITRO-USER", "hello")
        .set("X-NITRO-PASS", "world")
        .set("Content-Type", `application/vnd.com.citrix.netscaler.lbvserver+json`)
        .send({"lbvserver":{"name": "servername", "serviceType": "world"}})
        .reply(200)

        sut.onConfig(deviceConfig);
        sut.onMessage(message);
      });
      it('should validate the message against the message schema and make a request to Netscaler'()=>{
        expect(nsConfigResourceHandler.isDone).to.be.true
      })

    })

    context('When given a message that doesn\'t match a Netscaler api endpoint', ()=>{

    })
  })
});
