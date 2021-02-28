![](https://raw.githubusercontent.com/sourcevault/hoplon/dev/logo.jpg)

```js
npm install hoplon
// github            much install |
npm install sourcevault/hoplon#dist
```

[![Build Status](https://travis-ci.org/sourcevault/hoplon.svg?branch=dev)](https://travis-ci.org/sourcevault/hoplon) [![Join the chat at https://gitter.im/sourcevault/hoplon](https://badges.gitter.im/sourcevault/hoplon.svg)](https://gitter.im/sourcevault/hoplon?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`hoplon` is a tiny utility module to construct immutable functional guards, similar to what exists in Haskell / Elixir / Erlang for graceful error handling.

.. **quick examples** ..

🟡 Handling argument errror for adder function :
```js
var hoplon = require("hoplon")

var add = (x,y) => x + y

var adder = hoplon
.arn(2,() => console.log("Error: only accepts 2 arugument"))
.ar(2,add)
.def(null) // always provide a default value when all match fails.

adder(1,3) // 4
```

If you notice we do not check if x, y are numbers, we can fix this by using `.whn` (when not ) in our error handling :

```js
var bothNum = (x,y)=> (((typeof x) is "number") && ((typeof y) is "number"))

var argE = () => console.log("only accepts 2 arugument")

var typeE = () => console.log("argument type has to be number")

var add = (x,y) =>  x + y

var adder = hoplon
.arn(2,argE)
.whn(bothNum,typeE)
.ar(2,add)
.def(null)

adder(1,2) // 3
```
This now allows us to cover both `typeError` and `argumentError` for the adder function.

##### *Why ?*

Guards are function wrappers that are commonly found in functional programming language, they help in making sure error handling code does not clutter core logic. They are especially useful in languages such as javascript that have virtually no type checks.

They also encourage efficient use of pattern matching to structure code and external API.

```
[ LEGENDS ]

arglen      👉🏼       number | [num...]
validator   👉🏼  ( -> bool ) | { valledate object }
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

### Method Descriptions

The API surface is purposefully kept large to cover all types of niche pattern matching usecases.

🟣 `ar :: (number|[num...],function|any)`

First argument can be an any of number or just a number, which describes how many arguments are acceptable before running the function in the second argument.

Second argument can also just be an any, in which case, we just return an any.

🟣 `wh :: (function,function|any)`

first function should return a boolean, which determines if second function is run or not.

🟣 `ma :: (function,function|any)`

```
.ma :: { validator } -> { execution }

// 🔻 [ .. expanded .. ] 🔻

.ma ::      function -> function|any

// 🔻 [ .. expanded .. ] 🔻

.ma ::   ( -> bool ) -> function|any
```

There are times when the validator itself does some side-effects ( eg. finding a file in a directory ).

In situations like that we may need to ensure two things :

- validator is run only **once**,

-  provide some value created to our validator function to the execution function ( second function ).

`.ma` is just like `.wh` but gives us the option of ensuring both these conditions are met.

-  return value of the validator function is sent to the execution function, as the first **argument**.

If the validator function in `.ma` returns `false` or `undefined` then `hoplon` jumps to the next validator, in *any other value type including true* `hoplon` adds the value to the argument object to be provided to the execution function.

🟣 `arma :: {spans} -> { validator } -> { execution }`

Combines `.ar` and `.ma`, first argument can be a number or a array of number just like in `.ar`.

🟣 `arpar :: {spans} -> { validator } -> { execution } -> {handleError}`


`.arpar` is exactly like `.arma` but accepts a final error handling function and **only accepts** a tuple as return value for the validator.

In the trivial case, validator functions return just `true` or `false`, but as we have to deal with more involved situations, a better return signature would be a tuple where, the second value is relevant metadata (in case of error) or just data :

```
[true,...]
[false,...]
```

🟣 `whn :: (function,function|any)`

Same as above but if the first function return `true` then the second function is **not** run.

🟣 `arn :: (number|[num...],function|any)`

Same as `ar` but the functions added is only run if the argument.length **doesn't match** the values provided in the first argument to `arn`.

🟣 `arwh :: (number|[num...],function,function|any)`

A combination of `ar` and `wh` operators, first argument is number of argument we are ready to accept, first function is a validator just like what we would use with `.wh` and last function is what would run if the first two conditions are met.

🟣 `arwhn :: (number|[num...],function,function|any)`

Just like `arwh` but only runs if the validator function return false.

🟣 `arnwh :: (number|[num...],function,function|any)`

Just like `arwh` but only runs if the arguments do not match.

🟣 `arnwhn :: (number|[num...],function,function|any)`

Just like `arwhn` but runs if either conditions fails ( argument or function ), ( since the method name is quite a mouthful, its better to use the shorthand `.arnwhn`).

🟣 `def :: (function|any)`

In case `hoplon` is unable to match anything, the return value of the function added to `.def`  is used.

It's also possible to just provide a static value or object as default.

#### `⛔️ Notes ⛔️`

- Each hoplon object **always** has to end with a `.def`.

- all the methods also accept **non-functions** as their last value, functionality was added to make it possible to easily return static values for efficient and easy pattern matching.

- `hoplon` also accepts [valleydate](https://github.com/sourcevault/valleydate) validators.

### Namespaces

***immutable***

In case immutable chain is needed, hoplon offers immutability through `hoplon.immutable` namespace.

```js
var ihop = hoplon.immutable

var init = ihop
.def(=> console.log ("wrong number of arguments"))

var add2 = init.ar(2,(x,y)=> x + y)

var add3 = init.ar(3,(x,y,z)=> x + y + z)

console.log (add2 == add3) // false
```

***unary***

It's common enough to want to apply the `.ar` counting on a specific argument itself.

`hoplon.unary` is a namespace where the `.ar` counting is done on the first argument.

The condition of course is that the first argument **has** to be **array like**.

***debug***

By default exit function doesn't have debug logging enabled.

In case debug message is needed then `.debug` namespace can be used.

#### Update and API change

◾️ `0.0.41` - `.arpar` added and validators can now be `valleydate` objects.

◾️ `0.0.33` - `.ma` Nd `.arma` behavior modified to now do action functions.

◾️ `0.0.28` - `.debug` namespace added, `binapi` is used to now expose namespaces using ES6 proxies.

◾️ `0.0.25` - `.unary` namespace added.

◾️ `0.0.24` - `.arma` added as a new method.

◾️ `0.0.18` - hoplon have been made mutable by default, immutability moved to `hoplon.immutable`. `mutelog` option added.

◾️ `0.0.17` - internal rewrite to improve performance.

## LICENCE

- Code released under BSD-3-Clause.
- Documentation and images released under CC BY-NC-ND 4.0.
- details can be found [here](https://github.com/sourcevault/hoplon/blob/dev/COPYING.txt).
