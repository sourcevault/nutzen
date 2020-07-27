
![](./logo.jpg)

```js
npm install hoplon
// github            much install |
npm install sourcevault/hoplon#dist
```

[![Build Status](https://travis-ci.org/sourcevault/hoplon.svg?branch=dev)](https://travis-ci.org/sourcevault/hoplon)

`hoplon` is a module to provide extensive support for the creation of functional gaurds, like that exists in Haskell / Elixir / Erlang for graceful error handling.

1. [Methods](#methods)
1. [Shorthand](#shorthand)

.. **quick examples** ..

🟡 Handling argument errror for adder function :
```js
var hoplon = require("hoplon")

var add = (x,y)=> x + y

var adder = hoplon
.args(2,add)
.args_not(2,() => console.log("only accepts 2 arugument"))
```

If you notice we do not check if x, y are numbers, we can fix this by using `.when_not` in our error handling :

```js
var bothNum = (x,y)=> (((typeof x) is "number") && ((typeof y) is "number"))

var argE = () => console.log("only accepts 2 arugument")

var typeE = () => console.log("argument type has to be number")

var add = (x,y)=> x + y

var adder = hoplon
.args_not(2,argE)
.when_not(bothNum,typeE)
.args(2,add)
```
This now allows us to cover both `typeError` and `argumentError` for the adder function.

##### *Why ?*

Gaurds are function wrappers that are commonly found in functional programming language, they help in making sure error handling code does not clutter core logic. They are especially useful in languages such as javascipt that have virtually no type checks.

They also provide a powerful way to use pattern matching to structure our code and external API.

### Methods

The API surface is fairly extentive to provide all types of niche functions to provide as much help to simplify creation of error handling in large codebases.

◾️ `when` : `(function,function)` - first function should return a bloolean, which determines if second function is run or not.

◾️ `when_not`: `(function,function)` - same as above but if the first function return `true` then the second function is **not** run.

◾️ `args` : `(number,function)` - function is run if argument number matches number provided to `hoplon.args`.

◾️ `args_not` : `(number,function)` - function is run if `arguments.length` provided by user **doesn't match** what is described in hoplon object.

◾️ `args_when` : `(number,function,function)` - a combination of `args` and `when` operators, first argument is number of argument we are ready to accept, first function is a validator just like what we would use with `.when` and last function is what would run if the first two conditions are met.

◾️ `args_when_not` : `(number,function,function)` - just like `args_when` but only runs if the validator function return false.

◾️ `args_not_when_not` : `(number,function,function)` - just like `args_when_not` but runs if either conditions fails ( argument or function ), ( since the method name is quite a mouthful, its better to use the shorthand `.arnwhn`).

◾️ `default` : `(function)` - in case `hoplon` is unable to match anything, it would resort to returning `undefined` unless a function is added using `.default`, in which case the return value of that function is used.

### shorthand

Each of the methods in the API have their own shorthands to reduce the need for wordy method names, wordy method names are only provided for reference purposes, in fact we encourage the use of shorthands for committed code.

| short  | long              |
|--------|-------------------|
| ar     | args              |
| wh     | when              |
| whn    | when_not          |
| arn    | args_not          |
| arwh   | args_when         |
| arwhn  | args_when_not     |
| arnwhn | args_not_when_not |
| def    | default           |

## LICENCE

- Code released under MIT Licence, see [LICENSE](https://github.com/sourcevault/hoplon/blob/dist/LICENCE) for details.

- Documentation and image released under CC-BY-4.0 see [LICENSE](https://github.com/sourcevault/hoplon/blob/dev/LICENCE1) for details.





