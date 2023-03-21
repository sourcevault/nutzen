<!-- ![](https://raw.githubusercontent.com/sourcevault/nutzen/dev/logo.png) -->

![](./logo.png)

```js
npm install nutzen
// github            much install |
npm install sourcevault/nutzen#dist
```

`nutzen` provides common utility functions for coders that make heavy use of pattern matching technique(s) in `javascript`.

#### Introduction

There are 3 namespaces that exists in `nutzen` :

```js
var nutzen = require("nutzen")
nutzen.types
nutzen.guard
nutzen.utils
```

◾️ [`nutzen.types`](docs/types.md) - immutable type validator that puts composability ( recursiveness ) and extensibility as it's core feature. It can also be used for validating `json` schemas.

◾️ [`nutzen.guard`](docs/guard.md) - functional guards (mutable & immutable), similar to what exists in Elixir / Erlang for graceful error handling.

◾️ [`nutzen.utils`](docs/utils.md) - exposes `nutzen`'s internal utils, like [`Ramda`](https://github.com/ramda/ramda)  and [`error-stack-parser`](https://github.com/stacktracejs/error-stack-parser), ( this way there are fewer direct dependencies ).

## LICENCE

- Code released under BSD-3-Clause.
- Documentation and images released under CC BY-NC-ND 4.0.
- details can be found [here](https://github.com/sourcevault/nutzen/blob/dev/COPYING.txt).
