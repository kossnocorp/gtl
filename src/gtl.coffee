###
   ______     ______   __
  /\  ___\   /\__  _\ /\ \
  \ \ \__ \  \/_/\ \/ \ \ \____
   \ \_____\    \ \_\  \ \_____\
    \/_____/     \/_/   \/_____/

  gtl.js ~ v0.0.0 ~ https://github.com/kossnocorp/gtl

  Greater than less

  The MIT License

  Copyright (c) 2012 Sasha Koss
###

# Define main object
gtl = {}

###
  Internal: clone array
###
clone = (array) ->
  result = []
  result.push(elm) for elm in array
  result

###
  Internal: filter array by rule and return copy
###
filter = (array, comparator, rule, iterator) ->
  result = []

  for elm in array
    result.push(elm) if comparator(iterator(elm), rule)

  result

###
  Public: filter function
###
gtl.filter = (array, rules, iterator = (elm) -> elm) ->
  result = clone(array)

  for name, rule of rules
    result = filter(array, gtl.rules[name], rule, iterator)

  result

# Define rules object
gtl.rules = {}

###
  Public: greater than comparator
###
gtl.rules.greaterThan = (a, b) -> a > b
gtl.rules.gt = gtl.rules.greaterThan

###
  Public: greater than or equal to comparator
###
gtl.rules.greaterThanOrEqualTo = (a, b) -> a >= b
gtl.rules.gte = gtl.rules.greaterThanOrEqualTo
gtl.rules.gteq = gtl.rules.greaterThanOrEqualTo

###
  Public: less than comparator
###
gtl.rules.lessThan = (a, b) -> a < b
gtl.rules.lt = gtl.rules.lessThan

###
  Public: less than or equal to comparator
###
gtl.rules.lessThanOrEqualTo = (a, b) -> a <= b
gtl.rules.lte = gtl.rules.lessThanOrEqualTo
gtl.rules.lteq = gtl.rules.lessThanOrEqualTo

###
  Public: only comparator
###
gtl.rules.only = (a, bs) ->
  if bs.constructor == Array
    bs.indexOf(a) != -1
  else
    a == bs

###
  Public: except comparator
###
gtl.rules.except = (a, bs) ->
  not gtl.rules.only(a, bs)
gtl.rules.not = gtl.rules.except

###
  Public: grep comparator
###
gtl.rules.grep = (str, substr) ->
  str.search(substr) != -1

# Export gtl to global scope
if window?
  window.gtl = gtl
else
  module.exports = gtl
