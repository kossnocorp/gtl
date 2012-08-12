gtl       = require('../src/gtl.coffee')

chai      = require('chai')
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.should()
chai.use(sinonChai)

describe 'Greater than less', ->

  describe 'gtl.filter function', ->

    describe 'greater/less rules', ->

      it 'should filter array with greaterThan rule', ->
        gtl.filter([1, 2, 3, 4, 5], greaterThan: 3).should.eql [4, 5]
        gtl.filter([1, 2, 3, 4, 5], gt: 3).should.eql [4, 5]

      it 'should filter array of strings with greaterThan rule', ->
        gtl.filter(['a', 'b', 'c', 'd', 'e'], greaterThan: 'c').should.eql ['d', 'e']

      it 'should filter array with greaterThanOrEqualTo rule', ->
        gtl.filter([1, 2, 3, 4, 5], greaterThanOrEqualTo: 3).should.eql [3, 4, 5]
        gtl.filter([1, 2, 3, 4, 5], gte: 3).should.eql [3, 4, 5]
        gtl.filter([1, 2, 3, 4, 5], gteq: 3).should.eql [3, 4, 5]

      it 'should filter array of strings with greaterThanOrEqualTo rule', ->
        gtl.filter(['a', 'b', 'c', 'd', 'e'], greaterThanOrEqualTo: 'c').should.eql ['c', 'd', 'e']

      it 'should filter array with lessThan rule', ->
        gtl.filter([1, 2, 3, 4, 5], lessThan: 3).should.eql [1, 2]
        gtl.filter([1, 2, 3, 4, 5], lt: 3).should.eql [1, 2]

      it 'should filter array of strings with lessThan rule', ->
        gtl.filter(['a', 'b', 'c', 'd', 'e'], lessThan: 'c').should.eql ['a', 'b']

      it 'should filter array with lessThanOrEqualTo rule', ->
        gtl.filter([1, 2, 3, 4, 5], lessThanOrEqualTo: 3).should.eql [1, 2, 3]
        gtl.filter([1, 2, 3, 4, 5], lte: 3).should.eql [1, 2, 3]
        gtl.filter([1, 2, 3, 4, 5], lteq: 3).should.eql [1, 2, 3]

      it 'should filter array of strings with lessThanOrEqualTo rule', ->
        gtl.filter(['a', 'b', 'c', 'd', 'e'], lessThanOrEqualTo: 'c').should.eql ['a', 'b', 'c']

      it 'should filter array with only rule', ->
        gtl.filter([1, 2, 3, 4, 5], only: 2).should.eql [2]
        gtl.filter([1, 2, 3, 4, 5], only: [1, 2]).should.eql [1, 2]

      it 'should filter array of strings with only rule', ->
        gtl.filter(['a', 'b', 'c', 'd', 'e'], only: 'c').should.eql ['c']

    describe 'inclusion and exclusion rules', ->

      it 'should filter array with except rule', ->
        gtl.filter([1, 2, 3, 4, 5], except: 3).should.eql [1, 2, 4, 5]
        gtl.filter([1, 2, 3, 4, 5], not: 3).should.eql [1, 2, 4, 5]
        gtl.filter([1, 2, 3, 4, 5], except: [1, 2]).should.eql [3, 4, 5]

      it 'should filter array of strings with except rule', ->
        gtl.filter(['a', 'b', 'c', 'd', 'e'], except: ['a', 'c']).should.eql ['b', 'd', 'e']

    describe 'grep rule', ->

      it 'should filter array by grepping strings', ->
        gtl.filter(
          ['but break', 'my heart', 'for I must', 'hold my tongue']
          grep: 'my'
        ).should.eql ['my heart', 'hold my tongue']

    describe 'filter arrays of objects through iterator', ->

      it 'should use iterator passed as third argument', ->
        gtl.filter(
          [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }]
          gte: 4
          (obj) -> obj.num
        ).should.eql [{ num : 4 }, { num : 5 }]

    describe 'add custom comparator', ->
      gtl.rules.odd = (a) -> a % 2 == 1
      gtl.filter([1, 2, 3, 4, 5], odd: true).should.eql [1, 3, 5]
      gtl.rules.even = (a) -> a % 2 != 1
      gtl.filter([1, 2, 3, 4, 5], even: true).should.eql [2, 4]
