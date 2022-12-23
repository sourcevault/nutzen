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

◾️ [`hoplon.types`](https://github.com/sourcevault/hoplon/blob/dev/docs/types.md) - immutable type validator that puts composability ( recursiveness ) and extensibility as it's core feature. It can also be used for validating `json` schemas.

◾️ [`hoplon.guard`](https://github.com/sourcevault/hoplon/blob/dev/docs/guard.md) - functional guards (mutable & immutable), similar to what exists in Elixir / Erlang for graceful error handling.

◾️ [`hoplon.utils`](https://github.com/sourcevault/hoplon/blob/dev/docs/utils.md) - exposes `hoplon`'s internal utils, like [`Ramda`](https://github.com/ramda/ramda)  and [`error-stack-parser`](https://github.com/stacktracejs/error-stack-parser), ( this way there are fewer direct dependencies ).

## LICENCE

- Code released under BSD-3-Clause.
- Documentation and images released under CC BY-NC-ND 4.0.
- details can be found [here](https://github.com/sourcevault/hoplon/blob/dev/COPYING.txt).
