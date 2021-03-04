var reg, com, print, tightloop, sig, cache, z, l, R, hop, j, uic, deep_freeze, loopError, assort, cato, x$, wrap, y$, guard, z$, define, z1$, validate, props, initState, z2$, proto, key, val, F, handleError, custom, pkg, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
reg = require("./registry");
require("./print");
require("./tightloop");
com = reg.com, print = reg.print, tightloop = reg.tightloop, sig = reg.sig, cache = reg.cache;
z = com.z, l = com.l, R = com.R, hop = com.hop, j = com.j, uic = com.uic, deep_freeze = com.deep_freeze, loopError = com.loopError;
assort = function(F){
  if (cache.def.has(F)) {
    return ['d', F];
  } else if (cache.ins.has(F)) {
    return ['i', F];
  } else {
    return ['f', F];
  }
};
cato = function(arg){
  var fun, i$, to$, I, F, block;
  switch (R.type(arg)) {
  case 'Function':
  case 'Object':
    return assort(arg);
  case 'Arguments':
    fun = [];
    for (i$ = 0, to$ = arg.length; i$ < to$; ++i$) {
      I = i$;
      F = arg[I];
      block = assort(F);
      fun.push(block);
    }
    return fun;
  }
};
x$ = wrap = {};
x$.on = null;
x$.rest = null;
y$ = guard = {};
y$.on = null;
y$.rest = null;
z$ = define = {};
z$.and = null;
z$.or = null;
z$.proto = null;
z$.on = null;
z$.basis = null;
z1$ = validate = {};
z1$.on = null;
z1$.rest = null;
props = ['and', 'or', 'alt', 'cont', 'edit', 'err', 'jam', 'fix'];
initState = {
  all: [],
  type: null,
  str: []
};
wrap.rest = function(type){
  return function(){
    return guard.rest(arguments, this[sig], type);
  };
};
wrap.on = function(){
  return guard.on(arguments, this[sig]);
};
z2$ = proto = {};
z2$.normal = {};
z2$.functor = null;
for (key in props) {
  val = props[key];
  F = wrap.rest(val);
  proto.normal[val] = F;
}
proto.normal.auth = tightloop;
proto.normal[uic] = print.log;
proto.functor = (import$({}, proto.normal));
proto.functor.map = wrap.rest('map');
proto.functor.on = wrap.on;
proto.functor[uic] = print.log;
handleError = function(info){
  print.route(info);
  return loopError();
};
custom = hop.arn(1, function(){
  return handleError([new Error(), 'input.fault', ['custom', ['arg_count']]]);
}).whn(function(f){
  return R.type(f) === 'Function' || f[sig];
}, function(){
  return handleError([new Error(), 'input.fault', ['custom', ['not_function']]]);
}).def(function(F){
  var G, data;
  G = cato(F);
  data = {
    type: 'custom',
    all: [[G]],
    str: ["{..}"]
  };
  return define.proto(data);
});
custom[uic] = print.inner;
define.on = function(type, args, state){
  var props, F, put, key, ob, fun, res$, val, block, data, ref$;
  switch (type[0]) {
  case 'array':
    props = args[0], F = args[1];
    put = ['on', ['array', [R.uniq(props)].concat(arrayFrom$(cato(F)))]];
    break;
  case 'string':
    key = args[0], F = args[1];
    put = ['on', ['string', [key].concat(arrayFrom$(cato(F)))]];
    put;
    break;
  case 'object':
    ob = args[0];
    res$ = [];
    for (key in ob) {
      val = ob[key];
      res$.push([key].concat(arrayFrom$(cato(val))));
    }
    fun = res$;
    put = ['on', ['object', fun]];
  }
  block = define.and(state, [put]);
  data = (ref$ = {}, import$(ref$, state), (ref$.phase = 'chain', ref$.all = block, ref$.str = state.str.concat('on'), ref$));
  return define.proto(data);
};
guard.on = hop.unary.arn([1, 2], function(args, state){
  return handleError([new Error(), 'input.fault', ['on', ['arg_count', [state.str, 'on']]]]);
}).arpar(1, function(arg$, state){
  var maybeObject, I, val;
  maybeObject = arg$[0];
  if (R.type(maybeObject) === 'Object') {
    for (I in maybeObject) {
      val = maybeObject[I];
      if (!(R.type(val) === 'Function' || cache.ins.has(val))) {
        return [false, [new Error(), 'input.fault', ['on', ['object', [state.str, 'on']]]]];
      }
    }
    return [true, 'object'];
  } else {
    return [false];
  }
}, define.on, function(data){
  if (data[1] === 'input.fault') {
    return handleError(data);
  }
  return false;
}).arma(2, function(arg$, state){
  var first, second, i$, len$, I;
  first = arg$[0], second = arg$[1];
  switch (R.type(first)) {
  case 'Array':
    for (i$ = 0, len$ = first.length; i$ < len$; ++i$) {
      I = first[i$];
      if (!(R.type(I) === 'String')) {
        return [new Error(), 'input.fault', ['on', ['array', [state.str, 'on']]]];
      }
    }
    if (!(R.type(second) === 'Function' || cache.ins.has(second))) {
      return [new Error(), 'input.fault', ['on', ['array', [state.str, 'on']]]];
    }
    return ['array'];
  case 'String':
  case 'Number':
    if (!(R.type(second) === 'Function' || cache.ins.has(second))) {
      return [new Error(), 'input.fault', ['on', ['string', [state.str, 'on']]]];
    }
    return ['string'];
  default:
    return false;
  }
}, define.on).def(function(args, state){
  return handleError([new Error(), 'input.fault', ['on', ['typeError', [state.str, 'on']]]]);
});
validate.rest = function(funs, state, type){
  var i$, len$, F, f;
  switch (type) {
  case 'and':
  case 'or':
  case 'alt':
    if (funs.length === 0) {
      print.route([new Error(), 'input.fault', [type, ['arg_count', [state.str, type]]]]);
      return false;
    }
    for (i$ = 0, len$ = funs.length; i$ < len$; ++i$) {
      F = funs[i$];
      if (!(R.type(F) === 'Function' || cache.ins.has(F))) {
        print.route([new Error(), 'input.fault', [type, ['not_function', [state.str, type]]]]);
        return false;
      }
    }
    return true;
  case 'map':
    if (!(funs.length === 1)) {
      print.route([new Error(), 'input.fault', [type, ['arg_count', [state.str, type]]]]);
      return false;
    }
    return true;
    f = funs[0];
    if (!(R.type(f) === 'Function' || cache.ins.has(F))) {
      print.route([new Error(), 'input.fault', [type, ['not_function', [state.str, type]]]]);
      return false;
    }
    return true;
  case 'err':
  case 'fix':
  case 'cont':
  case 'jam':
  case 'edit':
    return true;
  default:
    return false;
  }
};
guard.rest = hop.wh(validate.rest, function(args, state, type){
  var funs, block, data, ref$;
  funs = cato(args);
  block = (function(){
    switch (type) {
    case 'and':
      return define.and(state, funs);
    case 'or':
      return define.or(state, funs);
    case 'alt':
      return define.or(state, [['alt', funs]]);
    case 'map':
      return define.and(state, [['map', funs[0]]]);
    case 'err':
    case 'fix':
    case 'cont':
    case 'jam':
    case 'edit':
      return define.and(state, [[type, args[0]]]);
    }
  }());
  data = (ref$ = {}, import$(ref$, state), (ref$.all = block, ref$.str = state.str.concat(type), ref$));
  return define.proto(data);
}).def(loopError);
define.copy = function(F, data, type){
  type == null && (type = data.type);
  switch (type) {
  case 'obj':
  case 'arr':
  case 'arg':
    Object.assign(F, proto.functor);
    break;
  default:
    Object.assign(F, proto.normal);
  }
  F[sig] = data;
  return cache.ins.add(F);
};
define.proto = function(data, type){
  var put;
  type == null && (type = data.type);
  switch (type) {
  case 'obj':
  case 'arr':
  case 'arg':
    put = Object.create(proto.functor);
    break;
  default:
    put = Object.create(proto.normal);
  }
  put[sig] = data;
  cache.ins.add(put);
  return put;
};
define.basis = function(name, F){
  var data, ref$;
  cache.def.add(F);
  data = (ref$ = {}, import$(ref$, initState), (ref$.type = name, ref$.str = [name], ref$.all = [[['d', F]]], ref$));
  define.copy(F, data);
};
define.and = function(state, funs){
  var all, last, init, nlast, block;
  all = state.all;
  switch (all.length % 2) {
  case 0:
    return all.concat([funs]);
  case 1:
    last = R.last(all);
    init = R.init(all);
    nlast = arrayFrom$(last).concat(arrayFrom$(funs));
    block = arrayFrom$(init).concat([nlast]);
    return block;
  }
};
define.or = function(state, funs){
  var all, last, init, nlast, block;
  all = state.all;
  switch (all.length % 2) {
  case 0:
    last = R.last(all);
    init = R.init(all);
    nlast = arrayFrom$(last).concat(arrayFrom$(funs));
    block = arrayFrom$(init).concat([nlast]);
    return block;
  case 1:
    return all.concat([funs]);
  }
};
reg.internal = {
  custom: custom,
  define: define
};
pkg = require("./init");
deep_freeze(pkg);
module.exports = pkg;
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}