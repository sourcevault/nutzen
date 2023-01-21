## `hoplon.guard`

- [Quick Example](#quick-examples-to-get-started)
- [Introduction](#why-)
- [Methods](#detailed-api-description)
     - [ar](#ar)
     - [wh](#wh)
     - [cap](#cap)
     - [arcap](#arcap)
     - [whn](#whn)
     - [arn](#arn)
     - [arwh](#arwh)
     - [arwhn](#arwhn)
     - [arnwh](#arnwh)
     - [arnwhn](#arnwhn)
     - [def](#def)
     - [clone](#clone)
- [Object Pattern](#object-pattern)
- [Summary in Tabular Form](#summary-in-tabular-form)
- [Namespaces](#Namespaces)
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

The API surface is kept large to cover various forms of requirements :

```
CORE   : ar,wh,arwh,cap,arcap,def,clone
EXTRAS : whn,arn,arwhn,arnwh,arnwhn
```

The document makes use of [Hindley-Milner](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system) notation, the below notes are provided for some quick guide :

#### `⛔️ Note ⛔️`

1. `number|[num...]` 👉🏼 This means either a number **or** an array of numbers.

2. `pos_int|[pos_int...]` 👉🏼 same as (1) but instead of number you have positive integers.

3. `(function|any)` 👉🏼 it means either a function or any value, the last argument of all `hoplon.guard` is of this type.

4. `{ validator },{ execution }` 👉🏼 this shows that the function accepts two arguments, one if called the validator, and the other is called `execution` function.

6. `{arglen}` 👉🏼 describes arguments that specify `argument.length` values to match.

5. `(-> bool),(function|any)` 👉🏼 here the function accepts two arguments. The first one accepts a function with a return value of type `bool` while the second argument is `any`function or just `any` value.

6. A summary of API and their argument specification has been provided in two [tables](summary-in-tabular-form) for quick reference.

### Detailed API Description

```
[ LEGENDS ]

PI  =    pos_int | [pos_int,...]
FT  =  validator | hoplon.types
FT  =  (-> bool) | hoplon.types
FA  =   function | any
 F  =   function
```

### `ar`

```
✅ ar :: {arglen},{execution}
↪️ ar :: (pos_int|[pos_int...]),(function|any)
↪️ ar :: PI,FA
✅ ar :: {object}
```
First argument can be an array of positive integer or just single positive integer, which describes how many arguments are acceptable before running the function in the second argument.

Second argument can also just be an `any`, in which case, we just return an `any` without executing a function.

### `wh`

```
✅ wh :: {validator},{execution}
↪️ wh :: (hoplon.types|function),(function|any)
↪️ wh :: (hoplon.types|(-> bool)),(function|any)
↪️ wh :: FT,FA
```
First function should return a boolean, which determines if second function is run or not.

`hoplon.types` validator can also be used.

### `cap`

```
✅ cap/2 :: {validator},{execution}
↪️ cap/2 :: (hoplon.types|function),(function|any) 
↪️ cap/2 :: (hoplon.types|(-> false|any)),(function|any)
↪️ cap/2 :: FT,FA
```
```
✅ cap/3 :: {validator},{handleError},{execution}
↪️ cap/3 :: (hoplon.types|function),function,(function|any) 
↪️ cap/3 :: (hoplon.types|(-> false|any)),function,(function|any)
↪️ cap/3 :: FT,F,FA
```

There are situations where the validator function does some side-effects ( eg. finding a file in a directory ) and there is a need to  **cap**ture the result of these side-effects as values.

It's important to ensure two things :

- validator doesn't run multiple times.

-  provide captured value from validator to the execution function.

`.cap` is just like `.wh` but gives us the option of ensuring both these conditions are met.

-  return value of the validator function is sent to the execution function, as the first **argument**.

If the validator function in `.cap` returns `false` then `hoplon.guard` jumps to the next validator, in *any other value type including undefined*, `hoplon` **adds** this value as the first argument to the execution function.

### `arcap`

```
✅ arcap/1 :: {object}
✅ arcap/2 :: {arglen},{execution}
✅ arcap/3 :: {arglen},{validator},{execution}
✅ arcap/4 :: {arglen},{validator},{lastview},{execution}
```

`arcap` combines the operations of `.ar` and `.cap` while also accepting object notation.

```
✅ arcap/3 :: {arglen},{validator},{execution}
↪️ arcap/3 :: (pos_int|[pos_int,...]),(hoplon.types|function),(function|any)
↪️ arcap/3 :: (pos_int|[pos_int,...]),(hoplon.types|(-> false|any)),(function|any)
↪️ arcap/3 :: PI,FT,FA
```

First argument can be an array of positive integer or just single positive integer , which describes how many arguments are acceptable before running the validator function in the second argument.

`{validator}` can return `false|any` where `any` is treated as value to be captured to be used by `{execution}`.

in case `{validator}` is `hoplon.types` object, then the corrosponding `.value` is used as data to be captured by `{execution}`.

```
✅ arcap/4 :: {arglen},{validator},{handleError},{execution}
↪️ arcap/4 :: (pos_int|[pos_int,...]),(hoplon.types|function),(function|any)
↪️ arcap/4 :: -----------------------,(hoplon.types|(-> false|any|[bool,any])),(-> void|any),(function|any)
↪️ arcap/4 :: PI,FT,F,FA
```

In the trivial case, validator functions return just `true` or `false`, but as we have to deal with more complicated error handling scenarios, a better return signature would be a tuple, where the second value is relevant metadata (in case of error) or just data.

If the `{handleError}` function returns `void` then `hoplon.guard` jumps to the next validator, *for any other value* **X** it terminates the loop and returns **X**.

### `whn`

```
✅ whn :: {validator},{execution}
↪️ whn :: (hoplon.types|function),(function|any)
↪️ whn :: (hoplon.types|(-> bool)),(function|any)
↪️ whn :: FT,FA
```
Same as `wh` but `{execution}` runs if `{validator}` return `false`.

### `arn`

```
✅ arn :: {arglen},{execution}
↪️ arn :: (pos_int|[pos_int...]),(function|any)
↪️ arn :: PI,FA
```
Same as `ar` but the functions added is only run if the `arguments.length` **doesn't match** the values provided in `{arglen}`.

### `arwh`

```
✅ arwh :: {arglen},{validator},{execution}
↪️ arwh :: (pos_int|[pos_int...]),(hoplon.types|function),(function|any)
↪️ arwh :: ----------------------,(hoplon.types|(-> bool)),------------
↪️ arwh :: PI,FT,FA
```

A combination of `ar` and `wh` operators, first argument is number of argument we are ready to accept, first function is a validator just like what we would use with `.wh` and last function is what would run if the first two conditions are met.

### `arwhn`

```
✅ arwhn :: {arglen},{validator},{execution}
↪️ arwhn :: (pos_int|[pos_int...]),(hoplon.types|function),(function|any)
↪️ arwhn :: ----------------------,(hoplon.types|(-> bool)),------------
↪️ arwhn :: PI,FT,FA
```

Just like `arwh` but only runs if the validator function return `false`.

### `arnwh`

```
✅ arnwh :: {arglen},{validator},{execution}
↪️ arnwh :: (pos_int|[pos_int...]),(hoplon.types|function),(function|any)
↪️ arnwh :: ----------------------,(hoplon.types|(-> bool)),------------
↪️ arnwh :: PI,FT,FA
```

Just like `arwh` but runs if the `ar` does not match and validator returns `true`.

### `arnwhn`

```
✅ arnwh :: {arglen},{validator},{execution}
↪️ arnwh :: (pos_int|[pos_int...]),(hoplon.types|function),(function|any)
↪️ arnwh :: ----------------------,(hoplon.types|(-> bool)),------------
↪️ arnwh :: PI,FT,FA
```

Just like `arwh` but runs if **both** `ar` and `wh` do not match.

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

- all the methods also accept **non-functions** as their last value, in case only static values are returned. 

- `hoplon.guard` also accepts validators created using `hoplon.types`.

##### why introduce functions like `arn`,`arwhn`, `arnwh` and `arnwhn` ?

It's important to write as few primitive functions as possible and reduce the overall number of `if..else`.

These functions also completes the algebra of the core operators.

##### Object Pattern

Instead of matching on arguments on different validators, we can use a single objects to match against argument number.

This feature is available to be used on `ar`,`arwh`,`arcap` and `arwhn`.

Lets suppose we have the following example :

```js
var xop = hoplon.guard

var show = xop
.ar(1,() => console.log("one"));
.ar(2,() => console.log("two"));
.def()

show(null); // one
show(null,null); // two
```

we can rewrite it using an object:

```js
var xop = hoplon.guard

var ob = {
  1:() => console.log("one")
  2:() => console.log("two")
}

var show = xop
.ar(ob);
.def()

show(null); // one
show(null,null); // two
```

##### Summary in Tabular Form
```
[ LEGENDS ]

PI  =    pos_int | [pos_int,...]
FT  =  validator | hoplon.types
FT  =  (-> bool) | hoplon.types
FA  =  function  | any
 F  =  function

🟢 Table 1 - method names and their types.

METHOD NAME  EXPANDED NAME         INPUT TYPE
----------------------------------------------------------------
ar           argument              PI,FA
wh           when                  FT,FA
whn          when not              FT,FA
cap/2        capture               FT,FA
cap/3        ...                   FT,F,FA
arn          args not              PI,FA
arcap/3      argument capture      PI,FT,FA
arcap/4      ...                   PI,FT,F,FA
arcap/2      ...                   PI,FA
arwh         argument when         PI,FT,FA
arnwh        argument not when     PI,FT,FA
arwhn        argument when not     PI,FT,FA
arnwhn       argument not when not PI,FT,FA
----------------------------------------------------------------
def          default               FA
----------------------------------------------------------------
```

```
🟢 Table 2 - method types displayed with argument columns.

METHOD PIME  TYPES
             ARG 1       ARG 2       ARG 3        ARG 4
---------------------------------------------------------
ar           arglen      execution                   
wh           validator   execution                   
whn          validator   execution                   
cap/2        validator   execution                   
cap/3        validator   execution                   
arn          arglen      execution                   
arwh         arglen      validator   execution       
arcap/3      arglen      validator   execution       
arcap/4      arglen      validator   handleError  execution
arnwh        arglen      validator   execution       
arwhn        arglen      validator   execution       
arnwhn       arglen      validator   execution       

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

