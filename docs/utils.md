# `hoplon.utils`

- `binapi`
- `flat` - [flat](https://github.com/hughsk/flat)
- `R` - [Ramda](https://github.com/ramda/ramda)
- `l` - `console.log`
- `z` - `console.log`
  - `z.n` - adds new line before and after `console.log`
  - `z.j` - `console.log(j(...))`
- `noop` - `noop` function
- `c` - 8 bit color palette
- `alpha_sort` - [alpha-sort](https://github.com/sindresorhus/alpha-sort)
- `esp` - [error-stack-parser](https://github.com/stacktracejs/error-stack-parser)
- `deep_freeze` - [deep-freeze](https://github.com/substack/deep-freeze)
- `advanced_pad` - [advanced-pad](https://github.com/tylerdevs/advanced-pad)
- `lit` - zip printer for color output
- `jspc` - [json-stringify-pretty-compact](https://github.com/AitoDotAI/json-stringify-pretty-compact#readme)
  - `jspc.r` - arguments reversed and curried.
- `wait` - setTimeout with the arguments reversed.
- `print_fail` - used in test files to show file location for test failure.
- `create_stack` - wrapper for `error-stack-parser` that accepts error object.
- `common_symbols` - Symbols used to identify different objects, like `hoplon.type`.
- `loopfault` - a proxy object that acts as a dummy return object to prevent throwing unnecessary errors.
- `util_inspect_custom` - wrapper for `node.js`'s `util_inspect_custom`  that does not throw error if used in browser.

### `hoplon.utils.binapi`

- [quick examples](#quick-example-2)
- [using state variable](#using-state-variable)
- [custom logger](#custom-logger)

##### *Quick Example 1*

```js
var binapi = require("hoplon").utils.binapi

var main = function (state,args)
{

  var a = args[0]
  var b = args[1]

  if (state.flip) // flip arguments
  {
      var temporary = a
      a = b
      b = temporary
  }

  var output = a - b

  if (state.abs) // output only absolute value
  {
      return Math.abs(output)
  }

  return output

}

getter = function(state,key) {
  state[key] = true
  return state;
}

var subtract = binapi(main,getter,{})

subtract(10,5) // 5

subtract.flip(10,5) // - -5

subtract.flip.abs(10,5) //  5

subtract.abs.flip(10,5) //  5

// last two operations are doing the same thing

```

As shown above, we are using object properties as switches to turn "ON" certain flags in `main`.

[colors](https://www.npmjs.com/package/colors) is a good example of module that follows this pattern.

`hoplon.guard` namespaces also depends on `binapi`.

`binapi` is a shorthand for binary APIs.

.. **Features**

 - functions are built lazily, if you have 100 methods but the user only uses 3 functions - then only 3 objects are created.

`binapi` requires 2 functions to initialize :

- *application function* - it is run whenever there is a call from the user.
- *getter function* - run whenever  `.` operation is appiled, needed for updating state variable needed by the application function.


##### *Quick Example 2*

```js

var binapi = require("hoplon").utils.binapi

folks =
{
  charles:{age:null},
  henry:{age:null}
}

var main = function(key,args)
{

  folks[key] = args[0]
}

var getter = function(state,key) {return key}

var setAge = binapi(main,getter)

setAge.charles(32)

setAge.henry(29)

console.log(folks.charles) // 32

console.log(folks.henry) //29

```

#### using state variable

Sometimes some state has to be present in your function, this is especially useful for nested `binapi`.

🟡 *..Example 3 - adding state variable as second argument..*

```js
var binapi = require("hoplon").utils.binapi

var main,getter;

var loop = (state) => binapi(main,getter,state);

var get = ([num],key) => [num,key];

var F6 = ([x,key],args) =>

  var y = args[0]

  switch (key) {
  case "init":
    return loop([y]);
  case "add":
    return loop([x + y]);
  case "multiply":
    return loop([x * y]);
  case "ret":
    return x;
  default:
    return fail(6);

var compute = lopo(["init"])

var out = compute(5)
.add(5)
.multiply(10)
.ret()
```

#### Custom Logger

Internally `binapi` uses ES6 proxies allowing binding of custom log functions - providing us with the option of giving better object information when using `console.log`, custom log function is added as the 4rth argument.

🟡 *..Example 4 - custom logger provided as 4rth argument..*

```js
var binapi = require("hoplon").utils.binapi

var main = function (){}

var getter = function(state,key) {return state.concat(key);}

var log = function(state)
{
  var chain = state.join(' | ')

  console.log ("( " + chain + " )")
}
test = binapi(main,getter,[],log)

tsf = test.sync.flip

console.log (tsf) // ( sync | flip )
```