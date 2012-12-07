###
   ______     ______   __
  /\  ___\   /\__  _\ /\ \
  \ \ \__ \  \/_/\ \/ \ \ \____
   \ \_____\    \ \_\  \ \_____\
    \/_____/     \/_/   \/_____/

  gtl.js ~ v0.1.0 ~ https://github.com/kossnocorp/gtl

  Greater than less

  The MIT License

  Copyright (c) 2012 Sasha Koss
###

###
  Internal: clone array
###
clone = (array) -> array.slice()

###
  Internal: merge objects
###
merge = (a = {}, b = {}) ->
  result = {}

  copyPropsToResult = (obj) ->
    for own key, value of obj
      result[key] = value

  copyPropsToResult(a)
  copyPropsToResult(b)

  result

Gtl = {}

# Comparator class
class Gtl.Comparator
  filter: (array, options...) ->
    result = []
    for el in array
      result.push(el) if @isElSatisfied(el, options...)
    result

  isElSatisfied: (el, rule, iterator) ->
    if iterator.constructor == Function
      if @compare(iterator(el), rule)
        true
      else
        false
    else
      # Each iterator rule (or, and)
      for iteratorRule in iterator

        results = []

        compare = (iterator) =>
          results.push \
            @compare(@getByPath(el, iterator), rule)

        switch iteratorRule.iterator.constructor 
          when String
            compare(iteratorRule.iterator)
          when Array
            compare(i) for i in iteratorRule.iterator

        unless @isSatisfiedToIteratorRule(iteratorRule.rule, results)
          return false

      true

  getByPath: (obj, path) ->
    if path.constructor == String
      @getByPath(obj, path.split('.'))
    else
      if path.length == 1
        obj[path]
      else
        @getByPath(obj[path[0]], path.slice(1))

  isSatisfiedToIteratorRule: (rule, results) ->
    switch rule
      when 'or'
        results.indexOf(true) != -1
      when 'and'
        results.indexOf(false) == -1
  

# Greater than comparator
class Gtl.GreaterThanComparator extends Gtl.Comparator
  names: ['gt', 'greaterThan']
  compare: (a, b) -> a > b

# Greater than or equal to comparator
class Gtl.GreaterThanOrEqualToComparator extends Gtl.Comparator
  names: ['gte', 'gteq', 'greaterThanOrEqualTo']
  compare: (a, b) -> a >= b

# Less than comparator
class Gtl.LessThanComparator extends Gtl.Comparator
  names: ['lt', 'lessThan']
  compare: (a, b) -> a < b

# Less than or equal to comparator
class Gtl.LessThanOrEqualToComparator extends Gtl.Comparator
  names: ['lte', 'lteq', 'lessThanOrEqualTo'] 
  compare: (a, b) -> a <= b

# Only comparator
class Gtl.OnlyComparator extends Gtl.Comparator
  names: ['only']
  compare: (a, bs) ->
    if bs.constructor == Array
      bs.indexOf(a) != -1
    else
      a == bs

# Except comparator
class Gtl.ExceptComparator extends Gtl.Comparator
  names: ['not', 'except']

  constructor: ->
    @onlyComparator = new Gtl.OnlyComparator()

  compare: (a, bs) ->
    not @onlyComparator.compare(a, bs)
 

# Grep comparator
class Gtl.GrepComparator extends Gtl.Comparator
  names: ['grep']
  compare: (str, substr) ->
    str.search(substr) != -1

# Fuzzy comparator
class Gtl.FuzzyComparator extends Gtl.Comparator
  names: ['fuzzy']
  compare: (str, searchStr) ->
    subStr = str
    for char in searchStr
      if -1 != i = subStr.search(char)
        subStr = subStr.slice(i + 1)
      else
        return false
    true

# Function comparator
class Gtl.FunctionComparator extends Gtl.Comparator
  constructor: (names, @compare) ->
    super
    @names = if names.constructor == Array
      names
    else
      names.split(/,/)

# Comparators collection
class Gtl.ComparatorSet

  constructor: ->
    @comparators = []
  
  add: (possibleName, possibleKlass) ->
    if possibleName.constructor == String
      comparator = new Gtl.FunctionComparator(possibleName, possibleKlass)
    else
      comparator = new possibleName()

    @comparators.push(comparator)

  rehash: ->
    for comparator in @comparators
      for name in comparator.names
        @[name] = comparator

# Standart comparator set
class Gtl.StandartComparatorSet extends Gtl.ComparatorSet

  set: [
    Gtl.GreaterThanComparator
    Gtl.GreaterThanOrEqualToComparator
    Gtl.LessThanComparator
    Gtl.LessThanOrEqualToComparator
    Gtl.OnlyComparator
    Gtl.ExceptComparator
    Gtl.GrepComparator
    Gtl.FuzzyComparator
  ]

  constructor: ->
    super
    @add(klass) for klass in @set
    @rehash()

# Main GTL object: set of rules, filter function
class Gtl.Filter

  constructor: ->
    @comparators = new Gtl.StandartComparatorSet()

  filter: (array, rules, iterator = []) ->
    result = clone(array)

    if rules.or or rules.in
      iterator.push(rule: 'or', iterator: rules.or || rules.in)

    if rules.and
      iterator.push(rule: 'and', iterator: rules.and)

    if iterator.length == 0
      iterator = (elm) -> elm

    for name, rule of rules
      if ['or', 'in', 'and'].indexOf(name) == -1
        result = @comparators[name].filter(result, rule, iterator)

    result

  curry: (curriedRules, curriedIterator) ->
    (array, userRules, userIterator = curriedIterator) =>
      if userRules and userRules.constructor == Function
        rules = curriedRules
        iterator = userRules
      else
        rules = merge(curriedRules, userRules)
        iterator = userIterator

      @filter(array, rules, iterator)

# Define main object
gtl = new Gtl.Filter()

###
  Internal: filter array by rule and return copy
###

# Export gtl to global scope
if window?
  window.gtl = gtl
else
  module.exports = gtl
