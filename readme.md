![](https://raw.githubusercontent.com/sourcevault/hoplon/dev/logo.jpg)

```js
npm install hoplon
// github            much install |
npm install sourcevault/hoplon#dist
```

[![Build Status](https://travis-ci.org/sourcevault/hoplon.svg?branch=unstable)](https://travis-ci.org/sourcevault/hoplon)

`hoplon` is a small utility function to provide extensive support for creation of immutable functional guards, similar to what exists in Haskell / Elixir / Erlang for graceful error handling.

.. **quick examples** ..

🟡 Handling argument errror for adder function :
```js
var hoplon = require("hoplon")

var add = (x,y)=> x + y

var adder = hoplon
.ar(2,add)
.arn(2,() => console.log("only accepts 2 arugument"))
.def(null) // always provide a default when all match fails.

adder(1,3) // 4
```

If you notice we do not check if x, y are numbers, we can fix this by using `.when_not` in our error handling :

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

🟢 Table 1 - shorthands for method names and their types.

```
METHOD NAME      EXPANDED            TYPES
----------------------------------------------------------------------------
ar               args                number|[num...],function|any
wh               when                function,function|any
whn              when not            function,function|any
ma               match               [f1,f2....]|f1,f2,...
arn              args not            number|[num...],function|any
arma             args match          number|[num...],[f1,f2....]|f1,f2,...
arwh             args when           number|[num...],function,function|any
arnwh            args not when       number|[num...],function,function|any
arwhn            args when not       number|[num...],function,function|any
arnwhn           args not when not   number|[num...],function,function|any
----------------------------------------------------------------------------
def              default             (function|any)
----------------------------------------------------------------------------
```


🟢 Table 2 - Types displayed with argument columns.

```
METHOD NAME   TYPES
              ARG 1             ARG 2          ARG 3
-----------------------------------------------------------
ar            number|[num...]  function|any
wh            function         function|any
whn           function         function|any
arn           number|[num...]  function|any
arwh          number|[num...]  function        function|any
arnwh         number|[num...]  function        function|any

arwhn         number|[num...]  function        function|any
arnwhn        number|[num...]  function        function|any
def           function|any
```

```
        ARG N
ma      function|[function....]|f₁,f₂,f₃  ......... fₙ
arma    function|[function....]|f₁,f₂,f₃  ......... fₙ
```
### Method Descriptions

The API surface is kept large to provide as much help when it comes to writing error-handling logic in large codebases.

◾️ `ar` : `(number|[num...],function|any)`

First argument can be an any of number or just a number, which describes how many arguments are acceptable before running the function in the second argument.

Second argument can also just be an any, in which case, we just return an any.

◾️ `wh` : `(function,function|any)`

first function should return a boolean, which determines if second function is run or not.

◾️ `whn`: `(function,function|any)`

Same as above but if the first function return `true` then the second function is **not** run.

◾️ `arn` : `(number|[num...],function|any)`

Same as `ar` but the functions added is only run if the argument.length **doesn't match** the values provided in the first argument to `arn`.

◾️ `arwh` : `(number|[num...],function,function|any)`

A combination of `ar` and `wh` operators, first argument is number of argument we are ready to accept, first function is a validator just like what we would use with `.wh` and last function is what would run if the first two conditions are met.

◾️ `arwhn` : `(number|[num...],function,function|any)`

Just like `arwh` but only runs if the validator function return false.

◾️ `arnwh` : `(number|[num...],function,function|any)`

Just like `arwh` but only runs if the arguments do not match.

◾️ `arnwhn` : `(number|[num...],function,function|any)`

Just like `arwhn` but runs if either conditions fails ( argument or function ), ( since the method name is quite a mouthful, its better to use the shorthand `.arnwhn`).

◾️ `ma` : `function|[f1,f2,...]|f1,f2,...`

It's common in `.wh` operations to have **both** the validator and the return function be the same.

Making it redundant to have them run twice.

`ma` looks at the return value of the validator to find the return value itself.

If `.ma` returns `false` or `undefined` then `hoplon` jumps to the next validator, in *any other value type* `hoplon` returns and breaks.

◾️ `arma` : `number|[num...],function|[f1,f2,...]|f1,f2,...`

Combines `.ar` and `.ma`, first argument can be a number or a array of number just like in `.ar`.

Subsequent arguments are validator functions just like in `.ma`.

◾️ `def` : `(function|any)`

In case `hoplon` is unable to match anything, the return value of the function added to `.def`  is used.

It's also possible to just provide a static value or object as default.

`⛔️ Note ⛔️`

- Each hoplon object **always** has to end with a `.def`.

- all the methods also accept **non-functions** as their last value, functionality was added to make it possible to easily return static values for efficient and easy pattern matching.

### Namespaces

***Immutable***

In case immutable chain is needed, hoplon offers immutability through `hoplon.immutable` namespace.

```js
var ihop = hoplon.immutable

var init = ihop
.def(=> console.log ("wrong number of arguments"))

var add2 = init.ar(2,(x,y)=> x + y)

var add3 = init.ar(3,(x,y,z)=> x + y + z)

console.log (add2 == add3) // false
```

***Unary***

It's common enough to want to apply the `.ar` counting on a specific argument itself.

`hoplon.unary` is a namespace where the `.ar` counting is done on the first argument.

The condition of course is that the first argument **has** to be **array like**.


#### Update and API change

◾️ `0.0.25` - `.unary` namespace added.

◾️ `0.0.24` - `.arma` added as a new method.

◾️ `0.0.20` - `.pipe` and `.wrap` removed and `.wrap` is done using `.def`. `.def` is compulsory for `hoplon`.

◾️ `0.0.18` - hoplon have been made mutable by default, immutability moved to `hoplon.immutable`. `mutelog` option added.

◾️ `0.0.17` - internal rewrite to improve performance.

## LICENCE

- Code released under MIT License, see [LICENSE](https://github.com/sourcevault/hoplon/blob/dist/LICENCE) for details.

- Documentation and image released under CC-BY-4.0 see [LICENSE](https://github.com/sourcevault/hoplon/blob/dev/LICENCE1) for details.