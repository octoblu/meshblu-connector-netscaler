import NetScalerConnector from '../src/index'
const netScalerConnector = new NetScalerConnector();

describe('NetScalerConnector', ()=>{
  beforeEach( ()=>{
  });
  it('should exist', ()=>{
    expect(netScalerConnector).to.exist
  });
});
