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
  switch rule
    when 'or'
      results.indexOf(true) != -1
    when 'and'
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

          switch iteratorRule.iterator.constructor 
            when String
              compare(iteratorRule.iterator)
            when Array
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

  unless iterator
    iterator = []

    if rules.or or rules.in
      iterator.push(rule: 'or', iterator: rules.or || rules.in)

    if rules.and
      iterator.push(rule: 'and', iterator: rules.and)

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
gtl.rules.gt = gtl.rules.greaterThan = (a, b) -> a > b

###
  Public: greater than or equal to comparator
###
gtl.rules.gte = gtl.rules.gteq = gtl.rules.greaterThanOrEqualTo =
  (a, b) -> a >= b

###
  Public: less than comparator
###
gtl.rules.lt = gtl.rules.lessThan = (a, b) -> a < b

###
  Public: less than or equal to comparator
###
gtl.rules.lte = gtl.rules.lteq = gtl.rules.lessThanOrEqualTo =
  (a, b) -> a <= b

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
gtl.rules.not = gtl.rules.except = (a, bs) ->
  not gtl.rules.only(a, bs)

###
  Public: grep comparator
###
gtl.rules.grep = (str, substr) ->
  str.search(substr) != -1

###
  Public: fuzzy comparator
###
gtl.rules.fuzzy = (str, searchStr) ->
  subStr = str
  for char in searchStr
    if -1 != i = subStr.search(char)
      subStr = subStr.slice(i + 1)
    else
      return false
  true

###
  Public: curry function
###
gtl.curry = (curriedRules, curriedIterator) ->
  (array, userRules, userIterator = curriedIterator) ->
    if userRules and userRules.constructor == Function
      rules = curriedRules
      iterator = userRules
    else
      rules = merge(curriedRules, userRules)
      iterator = userIterator

    gtl.filter(array, rules, iterator)

###
  Public: clone gtl object
###
gtl.clone = ->

# Export gtl to global scope
if window?
  window.gtl = gtl
else
  module.exports = gtl
