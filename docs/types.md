
# `hoplon.types`
1. Chainable Functions
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
2. [Creating Custom Basetypes](#creating-custom-basetypes)
3. [Context Variable](#context-variable)
4. [Helper Validators](#helper-validators)
    - [required](#helper-validators)
    - [integer](#helper-validators)
    - [maybe\*](#maybe)
5. [flatro](#flatro)
6. [common pitfall](#common-pitfall)

.. **quick examples** ..

🟡 Object with required properties `foo` and `bar`.

```js
var is = require("hoplon").types

var V = is.required("foo","bar")

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
var is = require("hoplon").types

var address = is.required("city","country")
.on("city",is.str)
.on("country",is.str)

var V = is.required("address","name","age")
.on("address",address)
.on("name",is.str)
.on("age",is.num)

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

🟢 Table 1 - method names and their mapping to which underlying type check or shorthands.

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
objerr         Error
-------------------------------
cont           continue
err            error
alt            alternative
```

`hoplon.types` uses few chainable operators for creating type validators, for handling arbitrary complex data types.

We start by defining our basetypes:

- `num`,`arr`,`str`,`null`,`bool`,`undef`,`arg`,`obj`,`fun` and `objerr`

.. then chainable units :

- `and`,`or`,`alt`,`map`,`on`.

.. and finally consumption units which are also chainable :

- `cont/edit`,`tap`,`forEach`,`jam`,`err` and `fix`.

- `wrap` is a special helper function, that **does not** return a `hoplon.types` object.

#### Initializing Validator

Each validator chain starts with a *basetype*.

```js
var V = is.num
V(1) // {continue: true, error: false, value:1}
```

```js
var V = is.obj
V({}) // {continue: true, error: false, value:{}}
```

```js
var V = is.arr
V([]) // {continue: true, error: false, value:[]}
```

```js
var V = is.obj
V([]) // {continue: false, error: true, message:"not an array",path:[]}
```

The return object will always return `.continue`, `.error` and `.value`. First two are boolean, and will always be opposite in value. The final output is kept in the `.value` attribute.

---

⚠️⛔️ `.value` may be **modified** if consumption units are used in the chain , so be careful. ⛔️⚠️

---

If `{cotinue:false,error:true,...}` the return object would also have attributes `.message` and `.path`:

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
var isG7 = is.str.and(valG7)

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
var canbeIP = is.str.or(is.arr.map(is.str))
```

### - `alt`

- functionally similar to `or` using **either** condition **but** the result ( or error ) is merged with upstream validator chain.

```js
var canbeIP = is.str.or(is.arr.map(is.str))
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
var ratifydata = is.obj.map(is.num);
```

### - `on`

###### `⛔️ .on only works for basetype Array, Object and Argument. ⛔️`

- apply validator to specific value in an object or array.

- if there are multiple `on`, instead of chaining them, you could just pass an object with the validator for each key.

```js

var V = is.obj
.on("foo",is.num)
.on("bar",is.num)

V.auth((foo:1,bar:2))

// Also ...

var V1 = is.obj.on({foo:is.num,bar:is.num})

V1.auth((foo:1,bar:2))

// Also ...

var V2 = is.obj.on(["foo","bar"],is.num)

V2.auth((foo:1,bar:2))

```

a common pattern with `.on` is type validation based on prior values.

an example taken from the `remotemon` project :

```ls
be = hoplon.types

bko = be.known.obj

check_if_remote_not_defined = bko
.on \remote,be.arr
.and do
  bko.on \remotehost,be.undefnull
  .or do
    bko.on \remotefold,be.undefnull
.cont true
.fix false
```

here we can see that `remotehost` and `remotefold` cannot be `undefined` **if** `remote` is an array type.

the logic is hard to decipher using normal usage of `.on`.

```ls
V = be.known.obj
.on do
  *[
    [\and,\remote,be.arr]
    [\alt,[\remotefold,\remotehost],be.undefnull]
   ]
.cont true
.fix false
```
however we can use the single array pattern to flatten the same logic, this is a 'special' function provided to match on `.on` due to the commonality of the usage.

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

var canbeIP = is.arr.map(is.str)
.or(is.str.cont (x) => [x]) // <-- we want string to go inside an array
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

var canbeIP = is.arr.map(is.str)
.or(is.string.cont((x) => [x]))
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

- for example, lets say we want to see what values are moving through your chain.

- we could use `cont` from above, but we need to make sure our return values are set correctly.

- `tap` is just like `cont` but it does not use the returned value to change the original value.

- there is also `hoplon.type.tap` provided as a helper function.

### - `forEach`

- `forEach` is `tap` for functors, in the sense that it's only available for `obj`,`arr` and `arg` types.

### - `wrap`

- For user facing function, we generally end up having to create a wrapper function of this sort :

```js
IS = require("hoplon").types

var V = is.arr.fix(() => []) // empty array if not array

var F = (x) => (V.auth(x)).value // creating our wrapper function by hand

F([1,2,35]) // [1,2,35]

F(null) // []
```

`.wrap()` prevents us from having to write `line 5`, instead we could just do :

```js
IS = require("hoplon").types

var V = is.arr.fix(() => []) // empty array if not array
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

- It simply passes it downstream ( as subsequent ) arguments in case they are needed.

- We refer to these extra arguments as ***context variables***.

- In cases where `.map` of `.on` are used, the context variables are appended with the key value.

🟡 These context variables are useful in two important ways :

- data needs to be provided to `.err` to create better error message, it could be things like filename.

- `.map`, `on` modification is index / key dependant.

#### Helper Validators

Some validators are common enough to be added in core.

- `required` - accepts a list of strings and checks *if they are not undefined*  in an object.

- `restricted` - checks if object has properties that are restricted to provided keys.

- `int` - checks if input is a integer

🟡 using `int` :

```js
var is = require("hoplon").types

is.int(2)
//{continue:true,error:false,value:1}

is.int(-1.1) //{continue:false,error:true,message:['not an integer']}

is.int(2.1)
//{continue:false,error:true,message:['not an integer']}
```

#### `maybe.*`

- maybe namespace can be used to validate optional value that conform to a type.

- The function exposed through `maybe.*` using `is.int` :

```js
var IS = require("hoplon").types


var V = is.maybe.int

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

### `.flatro`

**problem:**

`.err` function by default gives the raw chain of errors. flatting it gets quite messy 🤷🏼‍♂️.

**solution:**

`hoplon.types` provides a helper function `hoplon.types.flatro` to smoothly flatten raw error values.

but it requires your messages to follow a specific protocol :

- error value should always be an tuple.

- first value of said array should always be a string that starts with a colon ':'.

- to help with sorting, a number can be provided after a second colon ':' to tell flatro the hierarchy ( importance ) of your messages.

messages that do not have any signature are given `:undef`.

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

[
  ':undef',
  ['not array','not string']
]

```

#### common pitfall

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

console.log torn #{foo:undefined} 🡐 ( won't change, can't change )
```
It's one of the trade off of having hidden **mutability**, it's easy to avoid such "bugs" by restricting the use of the chainable functions for their stated purpose ( e.g don't use `.and` to edit variables, use `.edit` instead ).


#### `hoplon.types.known`

Using `hoplon` validators in `hoplon.guard` is quite common, it's why `hoplon.types.known` was introduced as a namespace.

`hoplon.types.known.*` avoids making the **first** type check, but **does do** the subsequent type check. At first glance the namespace does not seem useful, but as it turns out, algebraic unit functions are really good at describing control flow logic - again use the right tool for the job 👀.

