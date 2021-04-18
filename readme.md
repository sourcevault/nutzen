<!-- ![](https://raw.githubusercontent.com/sourcevault/hoplon/dev/logo.jpg) -->

![](./logo.jpg)

```js
npm install hoplon
// github            much install |
npm install sourcevault/hoplon#dist
```

[![Build Status](https://travis-ci.org/sourcevault/hoplon.svg?branch=dev)](https://travis-ci.org/sourcevault/hoplon) [![Join the chat at https://gitter.im/sourcevault/hoplon](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/sourcevault/hoplon)

`hoplon` provides common utility functions for coders that make heavy use of pattern matching technique(s) in `javascript`.

#### Introduction

There are 3 namespaces that exists in `hoplon` :

```js
var hoplon = require("hoplon")
hoplon.types
hoplon.guard
hoplon.utils
```

◾️ [`hoplon.types`](#hoplontypes) - immutable schema validator that puts composability ( recursiveness ) and extensibility as it's core feature.

◾️ [`hoplon.guard`](#hoplonguard) - functional guards (mutable & immutable), similar to what exists in Elixir / Erlang for graceful error handling.

◾️ [`hoplon.utils`](#hoplonutils) - exposes `hoplon`'s internal utils, like [`Ramda`](https://github.com/ramda/ramda)  and [`error-stack-parser`](https://github.com/stacktracejs/error-stack-parser), ( it's done so that I have fewer direct dependencies upstream ).

1. [hoplon.types](#hoplontypes)
    1. [Introduction](#-why-another-schema-validator-)
    1. [Initializing Validator](#initializing-validator)
    1. [Chainable Functions](#chainable-functions)
        - [and](#--and)
        - [or](#--or)
        - [alt](#--alt)
        - [map](#--map)
        - [on](#--on)
        - [edit / cont](#--cont)
        - [fix](#--fix)
        - [err](#--err)
        - [jam](#--jam)
        - [tap](#--tap)
        - [forEach](#--forEach)
        - [wrap](#--wrap)

    1. [Creating Custom Basetypes](#creating-custom-basetypes)
    1. [Context Variable](#context-variable)
    1. [Helper Validators](#helper-validators)
        - [required](#helper-validators)
        - [integer](#helper-validators)
        - [maybe\*](#maybe)
    1. [.flatro](#flatro)
    1. [common pitfall](#common-pitfall)
    1. [hoplon.types.known](#hoplontypesknown)

1. [hoplon.guard](#hoplonguard)
    1. [Quick Example](#quick-examples-to-get-started)
    1. [Introduction](#why-)
    1. [Method Description](#method-descriptions)
        - [ar](#ar)
        - [wh](#wh)
        - [whn](#whn)
        - [ma](#ma)
        - [arn](#arn)
        - [arma](#arma)
        - [arwh](#arwh)
        - [arnwh](#arnwh)
        - [arwhn](#arwhn)
        - [arnwhn](#arnwhn)
        - [arpar](#arpar)
    1. [Description and Type in Table](#description-and-type-in-table)
    1. [Namespaces](#Namespaces)
        - [immutable](#immutable)
        - [unary](#unary)
        - [debug](#dubug)

1. [hoplon.utils](#hoplonutils)

  1. [hoplon.utils.binapi](#hoplonutilsbinapi)
      1. [quick examples](#quick-example-1)
      1. [using state variable](#using-state-variable)
      1. [custom logger](#custom-logger)


### `hoplon.types`

.. **quick examples** ..

🟡 Object with required properties `foo` and `bar`.

```js
var IS = require("hoplon").types

var V = IS.required("foo","bar")

console.log(V.auth({}))

/*
{
  continue: false,
  error: true,
  value: {},
  message: [ 'foo', 'bar' ],
  path: [ 'foo' ]
}
*/
```

🟡 Object with required properties `name` `age` and `address`, with `address` having required fields of `city` and `country.`


```js
var IS = require("hoplon").types

var address = IS.required("city","country")
.on("city",IS.str)
.on("country",IS.str)

var V = IS.required("address","name","age")
.on("address",address)
.on("name",IS.str)
.on("age",IS.num)

var sample =
  {
    name:"Fred",
    age:30,
    address:
      {
        city:"foocity"
      }
  }

console.log(V.auth(sample))

/*{
  continue: false,
  error: true,
  value: { name: 'Fred', age: 30, address: { city: 'foocity' } },
  message: [ 'city', 'country' ],
  path: [ 'address', 'country' ]
}*/

```

🟢 Table 1 - method names and their mapping to which underlying type check.

```
SHORTHANDS     ..FOR
-------------------------------
obj            Object
arr            Array
undef          Undefined
bool           Boolean
null           Null
num            Number
str            String
fun            Function
arg            Argument
-------------------------------
cont           continue
err            error
alt            alternative
```

#### ***.. why another schema validator ?***

- chainable functions that are closed (Monadic).

- custom validators that are easy to build and extend.

`hoplon.types` exposes few key operators for creating data validators, for handling arbitrary complex data types.

We start by defining our basetypes:

- `num`,`arr`,`str`,`null`,`bool`,`undef`,`arg`,`obj` and `fun`.

.. then chainable units :

- `and`,`or`,`alt`,`map`,`on`.

.. and consumption units :

- `cont/edit`,`tap`,`forEach`,`jam`,`err` and `fix`.

`⛔️ Note ⛔️`

- `wrap` is a special helper function, that **does not** return a `hoplon.types` object.

#### Initializing Validator

Each validator chain starts with a *basetype*.

```js
var V = IS.num
V(1) // {continue: true, error: false, value:1}
```

```js
var V = IS.obj
V({}) // {continue: true, error: false, value:{}}
```

```js
var V = IS.arr
V([]) // {continue: true, error: false, value:[]}
```

```js
var V = IS.obj
V([]) // {continue: false, error: true, message:"not an array",path:[]}
```

The return object will always return `.continue`, `.error` and `.value`. First two are boolean, and will always be opposite in value. The final output is kept in the `.value` attribute.

⚠️ `.value` may be **modified** if consumption units are used in the chain , so be careful. ⚠️

If `{cotinue:false,error:true,...}` the return object would also have attributes `.message` and `.path`, both are `Array` , with message values :

- `message`- that passes along error messages from the validator.
- `path` - in case the input is of type array or object, the path within the object where the validator function failed.

`⛔️ Notes ⛔️`

The `path` variable is provided for convenience, it discards information about what happens in side chains in your validator(s).

In case the side channel information is relevant, you can **rewrite** your main chain's error message and(or) path variable by returning a object with `.message` and (or) `.path`properties.

#### Chainable Functions

After initilizating a validator with its basetype, you are returned a unit object that can be chained ( infinitely ) using a few operators.

These operators all accept custom validators but also other `hoplon` validator (`hoplon.types`) objects.

### - `and`

- when validators need to be combined, and data has to satisfy conditions set by **both** validator.

- a common situation is validating string enums.

```js

var G7 = new Set([
  "USA","EU","UK","Japan","Italy","Germany","France"
]);

var valG7 = function(s){
  if (G7.has(s)){
   return true
  }
  else {
   return [false,"not in G7"]
  }
}
var isG7 = IS.str.and(valG7)

isG7.auth("UK")

//{ continue: true, error: false, value: 'UK' }

isG7.auth("Spain")

/*{ continue: false,
  error: true,
  message: [ 'not in G7' ],
  value: 'Spain'
  }
*/
```

⛔️ `valG7` is a **custom validator** in the above example, they can be any function that returns `boolean` or `[boolean,string]`.

### - `or`

- when validators need to be combined, here data can satisfy **either** validator.

- a useful example would be accepting a single string or multiple strings in an array to define ipaddress to use in an application.

```js
var canbeIP = IS.str.or(IS.arr.map(IS.str))
```

### - `alt`

- functionally similar to `or` using **either** condition **but** the result ( or error ) is merged with upstream validator chain.

```js
var canbeIP = IS.str.or(IS.arr.map(IS.str))
```

### - `map`

###### `⛔️ .map only works for basetype Array, Object and Argument. ⛔️`

- map allows to run validators on each value in an array or object.

- an example of this would be an object of names with age.

```js
var example = {
  "adam":22,
  "charles":35,
  "henry":30,
  "joe":24
}
```

A validator for it would look something like this :

```js
var ratifydata = IS.obj.map(IS.num);
```

### - `on`

###### `⛔️ .on only works for basetype Array, Object and Argument. ⛔️`

- apply validator to specific value in an object or array.

- if there are multiple `on`, instead of chaining them, you could just pass an object with the validator for each key.

```js

var V = IS.obj
.on("foo",IS.num)
.on("bar",IS.num)

V.auth((foo:1,bar:2))

// Also ...

var V1 = IS.obj.on({foo:IS.num,bar:IS.num})

V1.auth((foo:1,bar:2))

// Also ...

var V2 = IS.obj.on(["foo","bar"],IS.num)

V2.auth((foo:1,bar:2))

```

### - `cont`

Alias: **edit**

- accepts functions that run based on output of validation.

- After validating some data, it needs to be consumed ( if valid ) or throw an error.

- `.cont/edit`,`jam`,`fix` and `err` are consumption unit function that can be used to do just that.

- return value of consumption units are important, they replace some parts of return object.

using the IP example from above :

```js
var sendData = function(data){...}

var data = ["209.85.231.104","207.46.170.123"]

var V = canbeIP
.cont(sendDate) // <-- only this is called as data is valid
.err(console.log)

```

🟡 `.cont` can be used to making values **consistent**, using the IP address validator from above :


```js
var IS = require("hoplon").types

var canbeIP = IS.arr.map(IS.str)
.or(IS.str.cont (x) => [x]) // <-- we want string to go inside an array
// so we do not have to do extra prcessing downstream.

var ret = canbeIP.auth("209.85.231.104")

console.log(ret)
//{error: false, continue: true, value: ['209.85.231.104']}
//                                           ↑  ↑  ↑
//                                       value is an array
```

### - `fix`

- When errors can be dealt with locally without being passed upstream.

- Used commonly in creating default, using the IP address from above :

```js
IS = require("hoplon").types

var canbeIP = IS.arr.map(IS.str)
.or(IS.string.cont((x) => [x]))
.fix(["127.0.0.1"])

var ret = canbeIP.auth(null)

console.log(ret) // ["127.0.0.1"]
```

### - `err`

- When validation fails, callback provided to `.err` is invoked.

- The return value of `.err` replaces the `.error` message to be sent downstream.

- returning `{message:msg,path:p}` would replace `message` with `msg` and path with `p`.

### - `jam`

- `jam` allows to "jam" (raise an error) within a validation chain.

- The return value of `.jam` replaces the `.error` message to be sent upstream.

### - `tap`

- `tap` is an operation specifically made for debugging / side effect.

- for example, lets say we want to see what values are moving through our chain.

- we could use `cont` from above, but we need to make sure our return values are set correctly.

- `tap` is just like `cont` but it does not use the returned value to change the original value.

- there is also `hoplon.type.tap` provided as a helper function.

### - `forEach`

- `forEach` is `tap` for functors, in the sense that it's only available for `obj`,`arr` and `arg` types.

### - `wrap`

- For user facing function, we generally end up having to create a wrapper function of this sort :

```js
IS = require("hoplon").types

var V = IS.arr.fix(() => []) // empty array if not array

var F = (x) => (V.auth(x)).value // creating our wrapper function by hand

F([1,2,35]) // [1,2,35]

F(null) // []
```

`.wrap()` prevents us from having to write `line 5`, instead we could just do :

```js
IS = require("hoplon").types

var V = IS.arr.fix(() => []) // empty array if not array
.wrap()

V([1,2,35]) // [1,2,35]

V(null) // []
```

It seems like such a trivial thing, but because it's so common, it does not make much sense to not include it as a standard helper.

#### Creating Custom Basetypes

In case defaults are not sufficient, clean validators can be easily created.

1. create a validator function with return types :
  - `boolean`
  - `[boolean,any]`

2. provide it as first argument into `holplon.types` as shown below :

```js
var IS = require("hoplon").types

var simpleEmail = function(value){

  var isemail = value.match (/[\w-]+@([\w-]+\.)+[\w-]+/)

  if (isemail) {return true}
  else {return [false,"not a valid email address"] }

}

var isEmail = IS(simpleEmail)

// isEmail is now an holplon validator which means it gets

// .and, .or, .cont, .err , .jam and .fix methods.

isEmail.and
isEmail.or
isEmail.cont
```

#### Context Variable

- `.auth` actually accepts **any number** of arguments.

- but expects the first argument to be what needs to be validated.

🟡 *so, what does `holplon.types` do with the extra arguments ?*

- It simply passes it downstream ( as subsequent ) arguments in case they need them.

- We refer to these extra arguments as ***context variables***.

- In cases where `.map` of `.on` are used, the context variables are appended with the key value.

🟡 These context variables are useful in two important ways :

- data needs to be provided to `.err` to create better error message, it could be things like filename.

- `.map`, `on` modification is index / key dependant.

#### Helper Validators

Some validators are common enough to be added in core.

- `required` - accepts a list of strings and checks *if they are not undefined*  in an object.

- `restricted` - checks if object has properties that are restricted to provided keys. examples

- `int` - checks if input is a integer

🟡 using `int` :

```js
var IS = require("hoplon").types

IS.int(2)
//{continue:true,error:false,value:1}

IS.int(-1.1) //{continue:false,error:true,message:['not an integer']}

IS.int(2.1)
//{continue:false,error:true,message:['not an integer']}
```

#### `maybe.*`

- maybe namespace can be used to validate optional value that conform to a type.

- The function exposed through `maybe.*` using `IS.int` :

```js
var IS = require("hoplon").types


var V = IS.maybe.int

V.auth(undefined) // { continue: true, error: false, value: undefined }

V.auth(2) // { continue: true, error: false, value: 2}

V.auth("foo bar")

/*{
  continue: false,
  error: true,
  message: [ 'not an integer ( or number )', 'not undefined' ],
  value: 'foo bar'
}*/

```

🟢 All possible primitive and helper function provided in core.

```js
// how to see both helper and primitive validators
> console.log((require("hoplon")).types)
{.*}
int.neg              int.pos
known.arr            known.bool
known.fun            known.null
known.num            known.obj
known.str            known.undef
list.ofint           list.ofnum
list.ofstr           maybe.arr
maybe.bool           maybe.boolnum
maybe.fun            maybe.int.neg
maybe.int.pos        maybe.list.ofint
maybe.list.ofnum     maybe.list.ofstr
maybe.null           maybe.num
maybe.obj            maybe.str
maybe.undef          not.arr
not.bool             not.fun
not.null             not.num
not.obj              not.str
not.undef            arg
arr                  bool
boolnum              flatro
fun                  null
num                  obj
reqres               required
restricted           str
undef                undefnull
tap
```

####  `.flatro`

`.err` function by default gives the raw chain of errors.

flatting it gets quite messy 🤷🏼‍♂️.

`hoplon.types` provides a helper function `.flatro` to smoothly flatten raw error values.

but it requires your messages to follow a specific message passing protocol :

- error value should always be an array.

- first value of said array should always be a string that starts with a colon ':'.

- to help with sorting, a number can be provided after a second colon ':' to tell flatro the hierarchy of your messages.

```js
// Examples of message that flatro matches against
[
  ':not_tuple',
  [' value is not tuple type.']
]

[
  ':not_tuple:1',
  ['length',' value is not tuple type.']
]

[
  ':not_tuple:2',
  ['innertype',' value is not tuple type.']
]
```

#### .. common pitfall ..

1. **why does mutating variable in function does not change it downstream ?**

each value is rewritten *at every return*, so for example using context variable to try and change a value will lead to confusing output.

```ls
# .. in livescript instead of javascript ..
be = (require "hoplon").types

V = be.obj.on \foo,
  (foo,__,data) ->
    data.foo = "i got changed !"
    true

data = {foo:void}

torn = (V data,data).value

console.log torn #{foo:undefined} 🡐 ( wont change, can't change )
```
It's one of the trade off of having hidden **mutability**, it's easy to avoid such "bugs" by restricting the use of the chainable functions for their stated purpose ( e.g don't use `.and` to edit variables, use `.edit` instead ).


#### `hoplon.types.known`

Using `hoplon` validators in `hoplon.guard` is quite common, it's why `hoplon.types.known` was introduced as a namespace.

`hoplon.types.known.*` avoids making the **first** type check, but **does do** the subsequent type check. At first glance the namespace does not seem useful, but as it turns out, algebraic unit functions are really good at describing control flow logic - again use the right tool for the job 👀.

### `hoplon.guard`

##### ..quick examples to get started..

🟡 Handling argument errror for adder function :
```js
var guard = require("hoplon").guard

var add = (x,y) => x + y

var adder = guard
.arn(2,() => console.log("Error: only accepts 2 arugument"))
.ar(2,add)
.def(null) // always provide a default value when all match fails.

adder(1,3) // 4
```

If you notice we do not check if x, y are numbers, we can fix this by using `.whn` (when not ) in our error handling :

```js
var bothNum = (x,y) => (((typeof x) is "number") && ((typeof y) is "number"))

var argE = () => console.log("only accepts 2 arugument")

var typeE = () => console.log("argument type has to be number")

var add = (x,y) =>  x + y

var adder = guard
.arn(2,argE)
.whn(bothNum,typeE)
.ar(2,add)
.def(null)

adder(1,2) // 3
```
This now allows us to cover both `typeError` and `argumentError` for the adder function.

#### *Why ?*

Guards are function wrappers that are commonly found in functional programming language, they help in making sure error handling code does not clutter core logic. They are especially useful in languages such as javascript that have virtually no type checks.

They also encourage efficient use of pattern matching to structure code and external API.

#### Method Descriptions

The API surface is purposefully kept large to cover all types of niche pattern matching usecases :

### `ar`

`ar :: (number|[num...],function|any)`

First argument can be an any of number or just a number, which describes how many arguments are acceptable before running the function in the second argument.

Second argument can also just be an any, in which case, we just return an any.

### `wh`

`wh :: (function,function|any)`

first function should return a boolean, which determines if second function is run or not.

### `ma`

`ma :: { validator } -> { execution }`

➡️`:: function -> function|any`

➡️`:: ( -> bool ) -> function|any`

➡️`:: (function,function|any)`

There are times when the validator itself does some side-effects ( eg. finding a file in a directory ).

In situations like that we may need to ensure two things :

- validator is run only **once**,

-  provide some value created to our validator function to the execution function ( second function ).

`.ma` is just like `.wh` but gives us the option of ensuring both these conditions are met.

-  return value of the validator function is sent to the execution function, as the first **argument**.

If the validator function in `.ma` returns `false` or `undefined` then `hoplon` jumps to the next validator, in *any other value type including true* `hoplon` adds the value to the argument object to be provided to the execution function.

### `arma`

`arma :: {spans} -> { validator } -> { execution }`

Combines `.ar` and `.ma`, first argument can be a number or a array of number just like in `.ar`.

### `arpar`

`arpar :: {spans} -> { validator } -> { execution } -> {handleError}`

`.arpar` is exactly like `.arma` but accepts a final error handling function and **only accepts** a tuple as return value for the validator.

In the trivial case, validator functions return just `true` or `false`, but as we have to deal with more involved situations, a better return signature would be a tuple where, the second value is relevant metadata (in case of error) or just data :

```
[true,...]
[false,...]
```

### `whn`

`whn :: (function,function|any)`

Same as above but if the first function return `true` then the second function is **not** run.

### `arn`

`arn :: (number|[num...],function|any)`

Same as `ar` but the functions added is only run if the argument.length **doesn't match** the values provided in the first argument to `arn`.

### `arwh`

`arwh :: (number|[num...],function,function|any)`

A combination of `ar` and `wh` operators, first argument is number of argument we are ready to accept, first function is a validator just like what we would use with `.wh` and last function is what would run if the first two conditions are met.

### `arwhn`

`arwhn :: (number|[num...],function,function|any)`

Just like `arwh` but only runs if the validator function return false.

### `arnwh`

`arnwh :: (number|[num...],function,function|any)`

Just like `arwh` but only runs if the arguments do not match.

### `arnwhn`

`arnwhn :: (number|[num...],function,function|any)`

Just like `arwhn` but runs if either conditions fails ( argument or function ), ( since the method name is quite a mouthful, its better to use the shorthand `.arnwhn`).

### `def`

`def :: (function|any)`

In case `hoplon` is unable to match anything, the return value of the function added to `.def`  is used.

It's also possible to just provide a static value or object as default.

#### `⛔️ Notes ⛔️`

- Each `hoplon.guard` object **always** has to end with a `.def`.

- all the methods also accept **non-functions** as their last value, functionality was added to make it possible to easily return static values for efficient and easy pattern matching.

- `hoplon.guard` also accepts validators created using `hoplon.types`.

##### Description and Type in Table

```
[ LEGENDS ]

arglen      👉🏼       number | [num...]
validator   👉🏼  ( -> bool ) | { hoplon.types object }
exec        👉🏼    function  | any

🟢 Table 1 - method names and their types.

METHOD NAME  EXPANDED            TYPES
----------------------------------------------------------------
ar           args                arglen,exec
wh           when                validator,exec
whn          when not            validator,exec
ma           match               validator,exec
arn          args not            arglen,exec
arma         args match          arglen,validator,exec
arwh         args when           arglen,validator,exec
arnwh        args not when       arglen,validator,exec
arwhn        args when not       arglen,validator,exec
arnwhn       args not when not   arglen,validator,exec
arpar        args par            arglen,validator,exec,function
----------------------------------------------------------------
def          default             (function|any)
----------------------------------------------------------------
```

```
🟢 Table 2 - method types displayed with argument columns.

METHOD NAME  TYPES
             ARG 1       ARG 2       ARG 3       ARG 4
---------------------------------------------------------
ar           arglen      exec
wh           validator   exec
whn          validator   exec
ma           validator   exec
arn          arglen      exec
arwh         arglen      validator   exec
arma         arglen      validator   exec
arnwh        arglen      validator   exec
arwhn        arglen      validator   exec
arnwhn       arglen      validator   exec
arpar        arglen      validator   exec        function
def          function|any
```

#### Namespaces

##### *immutable*

In case immutable chain is needed, `hoplon.guard` offers immutability through `hoplon.guard.immutable` namespace.

```js
var guard = hoplon.guard.immutable

var init = guard
.def(=> console.log ("wrong number of arguments"))

var add2 = init.ar(2,(x,y)=> x + y)

var add3 = init.ar(3,(x,y,z)=> x + y + z)

console.log (add2 == add3) // false
```

##### *unary*

It's common enough to want to apply the `.ar` counting on a specific argument itself.

`hoplon.guard.unary` is a namespace where the `.ar` counting is done on the first argument.

The condition of course is that the first argument **has** to be **array like**.

##### *debug*

By default exit function doesn't have debug logging enabled.

In case debug message is needed then `.debug` (`hoplon.guard.debug`) namespace can be used.


### `hoplon.utils`

- `flat` - [flat](https://github.com/hughsk/flat)
- `R` - [Ramda](https://github.com/ramda/ramda)
- `l` - `console.log`
- `z` - `console.log`
- `noop` - `noop` function
- `c` - 8 bit color palette
- `zj`- `console.log(j(...))`
- `zn` - adds new line before and after `console.log`
- `alpha_sort` - [alpha-sort](https://github.com/sindresorhus/alpha-sort)
- `esp` - [error-stack-parser](https://github.com/stacktracejs/error-stack-parser)
- `deep_freeze` - [deep-freeze](https://github.com/substack/deep-freeze)
- `advanced_pad` - [advanced-pad](https://github.com/tylerdevs/advanced-pad)
- `lit` - zip printer for color output
- `j` - [json-stringify-pretty-compact](https://github.com/AitoDotAI/json-stringify-pretty-compact#readme)
- `wait` - setTimeout with the arguments reversed.
- `print_fail` - used in test files to show file location for test failure.
- `create_stack` - wrapper for `error-stack-parser` that accepts error object.
- `common_symbols` - Symbols used to identify different objects, like `hoplon.type`.
- `loopfault` - a proxy object that acts as a dummy return object to prevent throwing unnecessary errors.
- `util_inspect_custom` - wrapper for `node.js`'s `util_inspect_custom`  that does not throw error if used in browser.


### `hoplon.utils.binapi`

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

#### Update and API change

◾️ `0.1.26` -  added `.wrap` and `.err` now allows changing of path variable downstream, if a object is used instead of an array.

◾️ `0.1.24` - `hoplon.types.tap` added.

◾️ `1.0.0` - `hoplon` and `valleydate` modules merged into `hoplon.guard` and `hoplon.types`, `@sourcevault/common.utils` also merged into `hoplon.utils`, and also introduced `hoplon.types.known`.

◾️ `0.0.41` - `.arpar` added and validators can now be `valleydate` objects.

◾️ `0.0.41` - `.arpar` added and validators can now be `valleydate` objects.

◾️ `0.0.33` - `.ma` and `.arma` behavior modified to now do action functions.

◾️ `0.0.28` - `.debug` namespace added, `binapi` is used to now expose namespaces using ES6 proxies.

◾️ `0.0.25` - `.unary` namespace added.

◾️ `0.0.24` - `.arma` added as a new method.

◾️ `0.0.18` - hoplon have been made mutable by default, immutability moved to `hoplon.immutable`. `mutelog` option added.

◾️ `0.0.17` - internal rewrite to improve performance.


## LICENCE

- Code released under BSD-3-Clause.
- Documentation and images released under CC BY-NC-ND 4.0.
- details can be found [here](https://github.com/sourcevault/hoplon/blob/dev/COPYING.txt).
