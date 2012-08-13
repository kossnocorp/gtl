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
  Internal: get element by path
###
getByPath = (obj, path) ->
  if path.constructor == String
    getByPath(obj, path.split('.'))
  else
    if path.length == 1
      obj[path]
    else
      getByPath(obj[path[0]], path.slice(1))

###
  Internal: is satisfied to iterator rule
###
isSatisfiedToIteratorRule = (rule, results) ->
  if rule == 'or'
    results.indexOf(true) != -1
  else if rule == 'and'
    results.indexOf(false) == -1

###
  Internal: filter array by rule and return copy
###
filter = (array, comparator, rule, iterator) ->
  result = []

  for elm in array
    satisfied = false

    if iterator.constructor == Function
      satisfied = true if comparator(iterator(elm), rule)
    else
      satisfied = true

      # Each iterator rule (or, and)
      for iteratorRule in iterator
        do ->

          results = []

          compare = (iterator) ->
            results.push \
              comparator(getByPath(elm, iterator), rule)

          if iteratorRule.iterator.constructor == String
            compare(iteratorRule.iterator)
          else if iteratorRule.iterator.constructor == Array
            compare(i) for i in iteratorRule.iterator

          unless isSatisfiedToIteratorRule(iteratorRule.rule, results)
            satisfied = false

    result.push(elm) if satisfied

  result

###
  Public: filter function
###
gtl.filter = (array, rules, iterator) ->
  result = clone(array)

  unless iterator?
    iterator = []

    if rules.or? or rules.in?
      iterator.push(
        rule: 'or'
        iterator: rules.or || rules.in
      )

    iterator.push(rule: 'and', iterator: rules.and) if rules.and?

    if iterator.length == 0
      iterator = (elm) -> elm

  for name, rule of rules
    if ['or', 'in', 'and'].indexOf(name) == -1
      result = filter(result, gtl.rules[name], rule, iterator)

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
