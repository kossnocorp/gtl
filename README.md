# ![gtl.js](http://f.cl.ly/items/1s3T1h1q1Z3l2F3E2s45/gtl_logo.png)
## Greater than less

[![Build Status](https://secure.travis-ci.org/kossnocorp/gtl.png?branch=master)](http://travis-ci.org/kossnocorp/gtl)

## Usage

```
TODO: Few examples: simple and advanced
```

# API

## gtl.filter()

### Filter array of numbers with gt rule (alias to greaterThan)

Full list of rules is avalible in ["Avaliable rules"](#avaliable-rules).
``` js
gtl.filter([1, 2, 3, 4, 5], { gt: 3 });
// => [4, 5]
```

### Filter array of strings

``` js
gtl.filer(['a', 'b', 'c', 'd'], { lte: 'c' });
// => ['a', 'b', 'c']
```

### Filter array of objects through iterator

``` js
gtl.filer(
  [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }],
  { gte: 4 },
  function (obj) {
    return obj.num;
  }
);
// => [{ num : 4 }, { num : 5 }]
```

### Combine rules

```
TODO: Example of combine rules
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
gtl.filer(
  [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }],
  { only: [1, 2] },
  function (obj) {
    return obj.num;
  }
);
// => [{ num : 1 }, { num : 2 }]
```

#### except

``` js
gtl.filer(
  [{ num : 1 }, { num : 2 }, { num : 3 }, { num : 4 }, { num : 5 }],
  { except: [1, 3] },
  function (obj) {
    return obj.num;
  }
);
// => [{ num : 2 }, { num : 4 }, { num : 5 }]
```

## gtl.grep()

``` js
gtl.grep(['but break', 'my heart', 'for I must', 'hold my tongue'], 'my')
// => ['my heart', 'hold my tongue']
```

## gtl.define()

Allow to define you own rule

### Basic example

``` js
gtl.define('no', function () {
  return false;
});
```

# Changelog

This project uses [Semantic Versioning](http://semver.org/) for release numbering.

Currently this project in active development but no any releases yet.

# Contributors

Idea and code by [@kossnocorp](http://koss.nocorp.me/).

Check out full list of [contributors](https://github.com/kossnocorp/gtl/contributors).

# License

The MIT License

Copyright (c) 2012 Sasha Koss

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.