## `hoplon.guard`

- [Quick Example](#quick-examples-to-get-started)
- [Introduction](#why-)
- [Methods](#methods)
     - [ar](#ar)
     - [wh](#wh)
     - [ma](#ma)
     - [arma](#arma)
     - [par](#par)
     - [arpar](#arpar)
     - [whn](#whn)
     - [arn](#arn)
     - [arwh](#arwh)
     - [arwhn](#arwhn)
     - [arnwh](#arnwh)
     - [arnwhn](#arnwhn)
     - [def](#def)
     - [clone](#clone)

1. [Description and type in table](#description-and-type-in-table)
1. [Namespaces](#Namespaces)
     - [immutable](#immutable)
     - [unary](#unary)
     - [debug](#debug)


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

Guards are wrappers that are commonly found in functional programming languages, which help in making sure error handling code does not clutter core procedures, these come especially handy in languages such as javascript that have virtually no type checks.

They also encourage efficient use of pattern matching to structure code and external API.

#### Methods

The API surface is purposefully kept large to cover all types of niche pattern matching usecases:

```
CORE   : ar,wh,arwh,ma,arma,par,arpar,def,clone
EXTRAS : whn,arn,arwhn,arnwh,arnwhn
```

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

There are times when the validator function does some side-effects ( eg. finding a file in a directory ).

In situations like that we may need to ensure two things :

- validator is run only **once**,

-  provide some value created to our validator function to the execution function ( second function ).

`.ma` is just like `.wh` but gives us the option of ensuring both these conditions are met.

-  return value of the validator function is sent to the execution function, as the first **argument**.

If the validator function in `.ma` returns `null` then `hoplon` jumps to the next validator, in *any other value type including undefined and false*, `hoplon` **replaces** the value to the argument object to be provided to the execution function.

### `arma`

`arma :: {spans},{ validator },{ execution }`

Combines `.ar` and `.ma`, first argument can be a number or a array of number just like in `.ar`.

### `par`

`par :: {spans},{ validator },{ execution },{handleError}`

`.par` is exactly like `.ma` but accepts a final error handling function, it's validator also **only accepts** a tuple as return value.

In the trivial case, validator functions return just `true` or `false`, but as we have to deal with more complicated situations, a better return signature would be a tuple, where the second value is relevant metadata (in case of error) or just data.

If the `handleError` function returns `undefined` then `hoplon.guard` jumps to the next validator, *for any other value* **X** it terminates the loop and returns **X**.


### `arpar`

`arpar :: {spans},{ validator },{ execution },{handleError}`

`.arpar` is `.par` but also matches against number of arguments.

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

Just like `arwh` but only runs if the validator function return `false`.

### `arnwh`

`arnwh :: (number|[num...],function,function|any)`

Just like `arwh` but runs if the `ar` does not match and validator returns `true`.

### `arnwhn`

`arnwhn :: (number|[num...],function,function|any)`

Just like `arwh` but runs if both `ar` and `wh` do not match.

### `def`

`def :: (function|any)`

In case `hoplon` is unable to match anything, the return value of the function added to `.def`  is used.

It's also possible to just provide a static value or object as default.

### `clone`

`clone :: void`

Alongside the `hoplon.guard.immutable` namespace, `hoplon.guard` also has a handy `.clone` operator in case there needs to be seperation in the validator chain.

When using fluent API pattern, the underlying object is kept by default to be mutable, to aid in efficiency, but there are rare situations where validator chains share a common parent chain.


#### `⛔️ Notes ⛔️`

- Each `hoplon.guard` object **always** has to end with a `.def`.

- all the methods also accept **non-functions** as their last value, functionality was added to make it possible to easily return static values for efficient and easy pattern matching.

- `hoplon.guard` also accepts validators created using `hoplon.types`.

- when creating large validator chains, you may want to 'reach' / 'use' the `.def` value to *short circuit* your pattern matching, in situation like that `.symdef` is provided, it allows using the `.def` function directly, it's important to note this is purely an *optimization concern*.

#### why introduce functions like `arwhn`, `arnwh` and `arnwhn` or even `arn` ?

It's important to write as few simple functions as possible and reduce the overall number of `if..else`.

These functions also completes the algebra of the core operators.

##### Description and type in table

- `exec` - execution function - once all the conditions are met, this function is run. The return value of this function is the return value of the `hoplon.guard` object.

- `errorfun` - error logic is expressed within this function.

```
[ LEGENDS ]

arglen      👉🏼       number | [num...]
validator   👉🏼  ( -> bool ) | { hoplon.types object }
exec        👉🏼    function  | any
errorfun    👉🏼    function 

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
par          par                 validator,exec,errorfun
arpar        args par            arglen,validator,exec,errorfun

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
arpar        arglen      validator   exec        errorfun
par          validator   exec        errorfun

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

