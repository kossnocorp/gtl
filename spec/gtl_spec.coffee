gtl       = require('../src/gtl.coffee')

chai      = require('chai')
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.should()
chai.use(sinonChai)

describe 'gtl.js', ->

  it 'should be defined', ->
    gtl.should.exists