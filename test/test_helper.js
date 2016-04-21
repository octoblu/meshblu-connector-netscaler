import 'babel-polyfill'
import chai from 'chai'
import chaiAsPromised from 'chai-as-promised'
import sinon from 'sinon'
import sinonChai from 'sinon-chai'
chai.use(sinonChai)
global.expect = chai.expect
global.sinon  = sinon
