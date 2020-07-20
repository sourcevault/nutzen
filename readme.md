
![](./logo.jpg)

```js
npm install hoplon
// github        much install     |
npm install sourcevault/hoplon#dist
```

[![Build Status](https://travis-ci.org/sourcevault/hoplon.svg?branch=dev)](https://travis-ci.org/sourcevault/hoplon)

`hoplon` provides a simple API to create Haskell / Elixir / Erlang style gaurds for graceful error handling :

1. [Introduction](#introduction)
1. [API](#introduction)

.. **quick examples** ..

🟡 Handling argument errror for adder function :
```js
var hoplon = require("hoplon")

var add = (x,y)=> x + y

var adder = hoplon
.args(2,add)
.args_not(2,() => console.log("only accepts 2 arugument"))
```
If you notice we do not check if x, y are numbers, we can rewrite :

```js
var bothNum = (x,y)=> (((typeof x) is "number") && ((typeof y) is "number"))

var argE = () => console.log("only accepts 2 arugument")

var typeE = () => console.log("only accepts 2 arugument")

var add = (x,y)=> x + y

var adder = hoplon
.args_not(2,argE)
.when_not(bothNum,typeE)
.args(2,add)
```
This now allows us to cover both `typeError` and `argumentError` for the adder function.

#### Introduction

Gaurds are function wrappers that are commonly found in functional programming language, they help in making sure error handling code does not clutter core logic.

#### API

The API surface is kept small, we shall see with examples how to use each one of them:

- `when` : `(function,function)` - first function should return a bloolean, which determines if second function is run or not.

- `when_not`: `(function,function)` - same as above but if the first function return `true` then the second function is **not** run.

- `args` : `(number,function)` - function is run if argument number matches number provided to `hoplon.args`.

- `args_not` : `(number,function)` - function is run if arguments provided by user **doesn't match** what is described in `hoplon.args_not`.

- `args_when` : `(number,function,function)` - a combination of `args` and `when` operators, `number` is number of argument we are ready to accept, first function is a validator just like what we would use with `.when` and last function is what would run if the first two conditions are met.

- `args_when_not` : `(number,function,function)` - just like `args_when` but if either conditions are not met ( argument or function ).

- `rest` : `(function)` - in case `hoplon` is unable to match anything, it would resort to returning `undefined` unless a function is provided using `.rest`, in which case the return value of the function is used.


## LICENCE

- Code released under MIT Licence, see [LICENSE](https://github.com/sourcevault/hoplon/blob/dist/LICENCE) for details.

- Documentation and image released under CC-BY-4.0 see [LICENSE](https://github.com/sourcevault/hoplon/blob/dev/LICENCE1) for details.



