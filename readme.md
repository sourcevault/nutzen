<!-- ![](./logo.jpg) -->
![](https://raw.githubusercontent.com/sourcevault/hoplon/dev/logo.jpg)

```js
npm install hoplon
// github            much install |
npm install sourcevault/hoplon#dist
```

[![Build Status](https://travis-ci.org/sourcevault/hoplon.svg?branch=dev)](https://travis-ci.org/sourcevault/hoplon)

`hoplon` is a small utility function to provide extensive support for creation of functional guards, like that exists in Haskell / Elixir / Erlang for graceful error handling.

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

Guards are function wrappers that are commonly found in functional programming language, they help in making sure error handling code does not clutter core logic. They are especially useful in languages such as javascript that have virtually no type checks.

They also encourage efficient use of pattern matching to structure code and external API.

🟢 Figure 1 - shorthands for method names and their types.

```
|SHORT          |LONG NAME            |TYPES                                      |
|---------------|---------------------|-------------------------------------------|
| ar            | args                | (number|[num...],function|array)          |
| wh            | when                | (function,function|array)                 |
| whn           | when_not            | (function,function|array)                 |
| arn           | args_not            | (number|[num...],function|array)          |
| arwh          | args_when           | (number|[num...],function,function|array) |
| arwhn         | args_when_not       | (number|[num...],function,function|array) |
| arnwhn        | args_not_when_not   | (number|[num...],function,function|array) |
| def           | default             | (function|array)                          |
```
#### Method Descriptions

The API surface is kept large to provide as much help when it comes to writing error-handling logic in large codebases.

◾️ `args` : `(number|[num...],function|array)`

First argument can be an array of number or just a number, which describes how many arguments are acceptable before running the function provided in the second argument.

Second argument can also just be an array, in which case, we just return an array.

◾️ `when` : `(function,function|array)`

first function should return a boolean, which determines if second function is run or not.

◾️ `when_not`: `(function,function|array)`

Same as above but if the first function return `true` then the second function is **not** run.

◾️ `args_not` : `(number|[num...],function|array)`

Same as `args` but the functions added is only run if the argument.length **doesn't match** the values provided in the first argument to `args_not`.

◾️ `args_when` : `(number|[num...],function,function|array)`

A combination of `args` and `when` operators, first argument is number of argument we are ready to accept, first function is a validator just like what we would use with `.when` and last function is what would run if the first two conditions are met.

◾️ `args_when_not` : `(number|[num...],function,function|array)`

Just like `args_when` but only runs if the validator function return false.

◾️ `args_not_when_not` : `(number|[num...],function,function|array)`

Just like `args_when_not` but runs if either conditions fails ( argument or function ), ( since the method name is quite a mouthful, its better to use the shorthand `.arnwhn`).

◾️ `default` : `(function|array)`

In case `hoplon` is unable to match anything, it would resort to returning `undefined` unless a function is added using `.default`, in which case the return value of that function is used.

#### `⛔️ Note ⛔️`

All the methods accept array as their last value, functionality was added to make it possible to easily return static values for efficient and easy pattern matching.

## LICENCE

- Code released under MIT License, see [LICENSE](https://github.com/sourcevault/hoplon/blob/dist/LICENCE) for details.

- Documentation and image released under CC-BY-4.0 see [LICENSE](https://github.com/sourcevault/hoplon/blob/dev/LICENCE1) for details.

