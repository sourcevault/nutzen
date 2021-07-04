var ref$, com, print, sig, tightloop, z, l, R, j, uic, deep_freeze, loopError, zj, oxo, x$, cache, assort, cato, y$, wrap, z$, guard, z1$, define, z2$, validate, props, initState, z3$, proto, key, val, F, handleError, custom, slice$ = [].slice, arrayFrom$ = Array.from || function(x){return slice$.call(x);};
ref$ = require('./print.common'), com = ref$.com, print = ref$.print, sig = ref$.sig;
tightloop = require('./tightloop');
z = com.z, l = com.l, R = com.R, j = com.j, uic = com.uic, deep_freeze = com.deep_freeze, loopError = com.loopError, zj = com.zj;
oxo = require('../guard/main');
x$ = cache = {};
x$.def = new Set();
x$.ins = new Set();
'd';
'i';
'f';
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
y$ = wrap = {};
y$.on = null;
y$.rest = null;
z$ = guard = {};
z$.on = null;
z$.rest = null;
z1$ = define = {};
z1$.and = null;
z1$.or = null;
z1$.proto = null;
z1$.on = null;
z1$.basis = null;
z2$ = validate = {};
z2$.on = null;
z2$.rest = null;
props = ['and', 'or', 'alt', 'cont', 'tap', 'edit', 'err', 'jam', 'fix'];
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
z3$ = proto = {};
z3$.normal = {};
z3$.functor = null;
proto.normal.wrap = function(){
  var F;
  F = this;
  return function(){
    return F.auth.apply(F, arguments).value;
  };
};
for (key in props) {
  val = props[key];
  F = wrap.rest(val);
  proto.normal[val] = F;
}
proto.normal.auth = tightloop;
proto.normal[uic] = print.log;
proto.functor = (import$({}, proto.normal));
proto.functor.map = wrap.rest('map');
proto.functor.forEach = wrap.rest('forEach');
proto.functor.on = wrap.on;
proto.functor[uic] = print.log;
handleError = function(info){
  print.route(info);
  return loopError();
};
custom = oxo.arn(1, function(){
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
  var props, F, put, key, ob, fun, res$, val, array, block, data, ref$;
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
    break;
  case 'single_array':
    array = type[1];
    put = ['on', ['single_array', array]];
  }
  block = define.and(state, [put]);
  data = (ref$ = {}, import$(ref$, state), (ref$.phase = 'chain', ref$.all = block, ref$.str = state.str.concat('on'), ref$));
  return define.proto(data);
};
guard.on = oxo.unary.arn([1, 2], function(args, state){
  return handleError([new Error(), 'input.fault', ['on', ['arg_count', [state.str, 'on']]]]);
}).arpar(1, function(args, state){
  var maybe_object, type, I, val, ok, clean, error_msg, i$, len$, each, fields, F, field_type, j$, len1$, ref$, wF, inner_error;
  maybe_object = args[0];
  type = R.type(maybe_object);
  if (type === 'Object') {
    for (I in maybe_object) {
      val = maybe_object[I];
      if (!(R.type(val) === 'Function' || cache.ins.has(val))) {
        return [false, [new Error(), 'input.fault', ['on', ['object', [state.str, 'on']]]]];
      }
    }
    return [true, ['object']];
  } else if (type === 'Array') {
    ok = true;
    clean = [];
    error_msg = null;
    for (i$ = 0, len$ = maybe_object.length; i$ < len$; ++i$) {
      each = maybe_object[i$];
      if (!(each.length === 3)) {
        ok = false;
        error_msg = 'length_less_then_3';
        break;
      }
      type = each[0], fields = each[1], F = each[2];
      field_type = R.type(fields);
      if (type === 'and') {
        if (field_type === 'String') {
          field_type = 'S';
        } else if (field_type === 'Array') {
          field_type = 'A';
        } else {
          error_msg = 'alt_wrong_field_type';
          ok = false;
          break;
        }
      } else if (type === 'alt') {
        if (field_type === 'Array') {
          for (j$ = 0, len1$ = fields.length; j$ < len1$; ++j$) {
            I = fields[j$];
            if (!((ref$ = R.type(I)) === 'String' || ref$ === 'Number')) {
              ok = false;
              break;
            }
          }
          if (!ok) {
            error_msg = 'alt_wrong_field_type';
            break;
          }
          field_type = 'A';
        } else if (field_type === 'String') {
          field_type = 'S';
        } else {
          ok = false;
          break;
        }
      } else {
        ok = false;
        error_msg = 'not_and_alt';
        break;
      }
      wF = assort(F);
      if (wF[0] === 'f') {
        ok = false;
        break;
      }
      clean.push([type, [field_type, fields], wF[0], wF[1]]);
    }
    if (ok) {
      return [true, ['single_array', clean]];
    } else {
      inner_error = ['on', ['single_array', [state.str, 'on'], error_msg]];
      return [false, [new Error(), 'input.fault', inner_error]];
    }
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
  case 'tap':
  case 'forEach':
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
guard.rest = oxo.wh(validate.rest, function(args, state, type){
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
    case 'forEach':
      return define.and(state, [[type, funs[0]]]);
    case 'err':
    case 'fix':
    case 'cont':
    case 'jam':
    case 'edit':
    case 'tap':
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
  var inner, data, ref$;
  if (typeof F === 'object') {
    inner = [];
  } else {
    inner = [[['d', F]]];
  }
  cache.def.add(F);
  data = (ref$ = {}, import$(ref$, initState), (ref$.type = name, ref$.str = [name], ref$.all = inner, ref$));
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
module.exports = {
  custom: custom,
  define: define,
  cache: cache
};
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}