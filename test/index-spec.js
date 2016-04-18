import NetScalerConnector from '../src/index'


describe('NetScalerConnector', ()=>{
  let sut;

  beforeEach( ()=>{
    sut = new NetScalerConnector()
  })
  it('should exist', ()=>{
    expect(sut).to.exist
  })
  xdescribe('->onConfig', ()=>{
    context('When given invalid device settings',()=>{

    })
    context('when given valid device config settings',()=>{

    })
  })
  xdescribe('->onMessage', ()=>{
    context('when given an invalid netscaler message', ()=>{

    })

    context('when given a valid netscaler message', ()=>{

    })
  })
});
