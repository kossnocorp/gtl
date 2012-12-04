# ![gtl.js](http://f.cl.ly/items/1s3T1h1q1Z3l2F3E2s45/gtl_logo.png)
## Greater than less

[![Build Status](https://secure.travis-ci.org/kossnocorp/gtl.png?branch=master)](http://travis-ci.org/kossnocorp/gtl)

## Usage

You can use `gtl.filter` function to filter arrays by conditions like greaterThan, lessThanOrEqualTo etc.

Full list of rules is avalible in ["Avaliable rules"](#avaliable-rules).

``` js
gtl.filter([1, 2, 3, 4, 5], { gt: 2, lte: 4 });
```

You can pass iterator function as second argument:

``` js
gtl.filter(
  [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }],
  { only: [1, 2] },
  function (obj) {
    return obj.num;
  }
);
// => [{ num : 1 }, { num : 2 }]
```

... or use iterator rules (`in`, `or` and `and`):

``` js
gtl.filter(
  [{ body: { text: 'but break' } }, { body: { text: 'my heart' } }, { body: { text: 'for I must' } }, { body: { text: 'hold my tongue' } }],
  { grep: 'my', in: 'body.text' }
);
// => [{ body: { text: 'my heart' } }, { body: { text: 'hold my tongue' } }]
```

# API

## gtl.filter()

### Filter array of numbers with gt rule (alias to greaterThan)

``` js
gtl.filter([1, 2, 3, 4, 5], { gt: 3 });
// => [4, 5]
```

### Filter array of strings

``` js
gtl.filter(['a', 'b', 'c', 'd'], { lte: 'c' });
// => ['a', 'b', 'c']
```

### Filter array of objects through iterator

``` js
gtl.filter(
  [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }],
  { gte: 4 },
  function (obj) {
    return obj.num;
  }
);
// => [{ num : 4 }, { num : 5 }]
```

### Combine rules

You can use multiply rules to filter array:

``` js
gtl.filter([1, 2, 3, 4, 5], { gt: 2, lte: 4 });
// => [3, 4]
```

You also can use multiply iterator rules:

``` js
gtl.filter(
  [{ one: 1, two: 5, three: 4 }, { one: 4, two: 4, three: 9 }, { one: 4, two: -2, three: 3 }, { one: 5, two: 7, three: 1 }],
  { gte: 4, or: ['one', 'two'], and: 'three' }
);
// => [{ one: 1, two: 5, three: 4 }, { one: 4, two: 4, three: 9 }]
```

### Avaliable rules

#### greaterThan (alias: gt)

``` js
gtl.filter([1, 2, 3, 4, 5], { gt: 3 });
// => [4, 5]
```

#### greaterThanOrEqualTo (aliases: gte, gteq)

``` js
gtl.filter([1, 2, 3, 4, 5], { gte: 3 });
// => [3, 4, 5]
```

#### lessThan (alias: lt)

``` js
gtl.filter([1, 2, 3, 4, 5], { lt: 3 });
// => [1, 2]
```

#### lessThanOrEqualTo (aliases: lte, lteq)

``` js
gtl.filter([1, 2, 3, 4, 5], { lte: 3 });
// => [1, 2, 3]
```

#### only

``` js
gtl.filter(
  [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }],
  { only: [1, 2] },
  function (obj) {
    return obj.num;
  }
);
// => [{ num : 1 }, { num : 2 }]
```

#### except (alias: not)

``` js
gtl.filter(
  [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }],
  { except: [1, 3] },
  function (obj) {
    return obj.num;
  }
);
// => [{ num : 2 }, { num : 4 }, { num : 5 }]
```

#### grep

Grep array by string:

``` js
gtl.filter(['but break', 'my heart', 'for I must', 'hold my tongue'], { grep: 'my' })
// => ['my heart', 'hold my tongue']
```

You also can use RegExp:

``` js
gtl.filter(['but break', 'my heart', 'for I must', 'hold my tongue'], { grep: /m./ })
// => ['my heart', 'for I must', 'hold my tongue']
```

#### fuzzy

You can find elements using fuzzy search:

``` js
gtl.filter(
  ['but break', 'my heart', 'for I must', 'hold my tongue'],
  fuzzy: 'ut'
);
// => ['but break', 'for I must']
```

### Iterator rules

#### or (alias: in)

You can use `in` rule to set fields to search for:

``` js
gtl.filter(
  [{ body: { text: 'but break' } }, { body: { text: 'my heart' } }, { body: { text: 'for I must' } }, { body: { text: 'hold my tongue' } }],
  { grep: 'my', in: 'body.text' }
);
// => [{ body: { text: 'my heart' } }, { body: { text: 'hold my tongue' } }]
```

You also can specify multiply fields:

``` js
gtl.filter(
  [{ one: 1, two: 5 }, { one: 4, two: 4 }, { one: 4, two: -2 }, { one: 5, two: 7 }],
  { gt: 4, or: ['one', 'two'] }
);
// => [{ one: 1, two: 5 }, { one: 5, two: 7 }]
```

#### and

``` js
gtl.filter(
  [{ one: 1, two: 5 }, { one: 4, two: 4 }, { one: 4, two: -2 }, { one: 5, two: 7 }],
  { gte: 4, and: ['one', 'two'] }
);
// => [{ one: 4, two: 4 }, { one: 5, two: 7 }]
```

## gtl.rules

gtl.rules contain all comparsion rules (lt, gt etc).

You can add your own comparator to gtl.rules:

``` js
gtl.rules.odd = function (num, rule) {
  var isOdd = num % 2 === 1
  if rule {
    return isOdd;
  } else {
    return !isOdd;
  }
};
```

... then:

``` js
gtl.filter([1, 2, 3, 4], odd: true)
// => [1, 3, 5]
gtl.filter([1, 2, 3, 4], odd: false)
// => [2, 4]
```

You can't use `or`, `in` and `and` rule name because it's reserved to build-ins iterator rules.

## gtl.curry

You can make copy of gtl.filter with predefined options:

``` js
var findWilly = gtl.curry({ fuzzy: 'willy' });

findWilly(['storm we are ill, 'is we ill yo', 'trololo will']);
// => ['is we ill yo']
```

# Changelog

This project uses [Semantic Versioning](http://semver.org/) for release numbering.

## v0.1.0, released 13 Aug 2012

First, initial release.

# Contributors

Idea and code by [@kossnocorp](http://koss.nocorp.me/).

Check out full list of [contributors](https://github.com/kossnocorp/gtl/contributors).

# License

The MIT License

Copyright (c) 2012 Sasha Koss

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
